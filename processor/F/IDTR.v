module IE_handler (
    input clk,
    input reset,
    input enable,

    input IE_in, //interrupt or exception from WB
    input [2:0] IE_type_in, 
    input [31:0] IDTR_base_address, //from init
    input [31:0] EIP_WB,
    input [17:0] EFLAGS_WB,
    input [15:0] CS_WB,
    input is_IRETD,
    input is_resteer,
    input rrag_stall_in,
    input is_final_switch_instr_WB,
    input is_pop_eflags_EX_in,
    
    output [127:0] IDTR_packet_out,
    output packet_out_select,           //to mux in fetch2 that picks between IBUFF or IDTR
    output flush_pipe,
    output PTC_clear,
    output LD_EIP,
    output is_POP_EFLAGS,
    output is_servicing_IE,
    output is_switching,                 //indicates that FSM is moving between ISR and normal execution and VV
    output LD_info_regs_out,
    output invalidate_fetch_out
    
);

//type encoding:
    //000: no stall
    //001: protection (read_address > seg_max_address), vector = 13
    //010: page fault (tlb_miss) , vector = 14 (decimal) * 8 
    //100: interrupt
    or2$ asxes(invalidate_fetch_out, invalidate_fetch_out_not_or, is_servicing_IE_not);
    //take IDTR and add 8 * vector to it
    wire [31:0] protection_vect, page_fault_vect, interrupt_vect;
    wire [31:0] vector_out, vector_out_shifted, IDT_entry_address, IDT_entry_address4;
    wire IE_internal;

    or2$ o198342y(.out(IE_internal), .in0(IE_in), .in1(is_servicing_IE));

    assign protection_vect = 32'd13;
    assign page_fault_vect = 32'd14;
    assign interrupt_vect = 32'd15;

    wire [2:0] IE_type_not, IE_type_internal;
    invn #(.NUM_INPUTS(3)) i0(.out(IE_type_not), .in(IE_type_in));
    assign IE_type_internal[0] = IE_type_in[0];
    andn #(.NUM_INPUTS(2)) a0(.out(IE_type_internal[1]), .in({IE_type_in[1], IE_type_not[0]}));
    andn #(.NUM_INPUTS(3)) a1(.out(IE_type_internal[2]), .in({IE_type_in[2], IE_type_not[1:0]})); 

    //if sel is 0, breaks trisate mux but output is a don't care
    muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(32)) m1(.in({interrupt_vect, page_fault_vect, protection_vect}), .sel(IE_type_internal), .out(vector_out)); 
    lshfn_fixed #(.WIDTH(32), .SHF_AMNT(3)) s1(.in(vector_out), .shf_val(3'b0), .out(vector_out_shifted));

    kogeAdder #(.WIDTH(32)) a2(.A(IDTR_base_address), .B(vector_out_shifted), .CIN(1'b0), .SUM(IDT_entry_address), .COUT());
    kogeAdder #(.WIDTH(32)) a3(.A(IDT_entry_address), .B(32'h4), .CIN(1'b0), .SUM(IDT_entry_address4), .COUT());

    orn #(2)  i394 (.in( {is_final_switch_instr_WB, is_pop_eflags_EX_in} ), .out(is_final_instr));

    wire [10:0] IDTR_packet_select;
    wire LD_info_regs;

    IDTR_FSM fsm(.clk(clk), .set(1'b1), .reset(reset), .enable(enable), .IE(IE_in), .is_IRETD(is_IRETD), .rrag_stall_in(rrag_stall_in),
                 .is_final_switch_instr_WB(is_final_instr), .IDTR_packet_select(IDTR_packet_select), .packet_out_select(packet_out_select), .flush_pipe(flush_pipe), 
                 .PTC_clear(PTC_clear), .LD_EIP(LD_EIP), .is_POP_EFLAGS(is_POP_EFLAGS), .LD_info_regs(LD_info_regs), 
                 .servicing_IE(is_servicing_IE), .is_switching(is_switching), .invalidate_fetch_out(invalidate_fetch_out_not_or));

    wire [31:0] IDT_entry_internal, IDT_entry4_internal, EFLAGS_internal, CS_internal, EIP_internal;
    wire is_servicing_IE_not;

    inv1$ iiio(.in(is_servicing_IE), .out(is_servicing_IE_not));
    assign LD_info_regs_out = LD_info_regs;

    regn #(.WIDTH(32)) reg_address  (.din(IDT_entry_address),   .ld(LD_info_regs), .clr(reset), .clk(clk), .dout(IDT_entry_internal));
    regn #(.WIDTH(32)) reg_address4 (.din(IDT_entry_address4),  .ld(LD_info_regs), .clr(reset), .clk(clk), .dout(IDT_entry4_internal));
    regn #(.WIDTH(32)) reg_EFLAGSWB (.din({14'b0, EFLAGS_WB}),  .ld(LD_info_regs), .clr(reset), .clk(clk), .dout(EFLAGS_internal));
    regn #(.WIDTH(32)) reg_CSWB     (.din({16'b0, CS_WB}), .ld(LD_info_regs), .clr(reset), .clk(clk), .dout(CS_internal));
    regn #(.WIDTH(32)) reg_EIPWB    (.din(EIP_WB),         .ld(LD_info_regs), .clr(reset), .clk(clk), .dout(EIP_internal));

    wire [127:0] push_eflags, push_cs, push_eip, first_4_bytes, second_4_bytes, exchange, sar16, mov_cs, jump, ret_far, pop_eflags;
    wire [31:0]  push_eflags_imm, push_cs_imm, push_eip_imm, first_4_bytes_imm, second_4_bytes_imm;

    //not reflected in naming, but true order is push CS, push EIP, 

    endian_swap32 e0(.in({EFLAGS_internal}), .out(push_eflags_imm));                //0000_0000_0001
    assign push_eflags = {8'h68, push_eflags_imm, 88'b0};                           //PUSH EFLAGS   

    endian_swap32 e1(.in({CS_internal}), .out(push_cs_imm));                        //0000_0000_0010
    assign push_cs = {8'h68, push_cs_imm, 88'b0};                                   //PUSH CS

    endian_swap32 e2(.in({EIP_internal}), .out(push_eip_imm));                      //0000_0000_0100
    assign push_eip = {8'h68, push_eip_imm, 88'b0};                                 //PUSH EIP
    
    endian_swap32 e3(.in({IDT_entry_internal}), .out(first_4_bytes_imm));           //0000_0000_1000
    assign first_4_bytes = {16'h8b0d, first_4_bytes_imm, 80'b0};                    //MOV ECX, [IDT_entry_internal]

    endian_swap32 e4(.in({IDT_entry4_internal}), .out(second_4_bytes_imm));         //0000_0001_0000
    assign second_4_bytes = {16'h8b15, second_4_bytes_imm, 80'b0};                  //MOV EDX, [IDT_entry4_internal]

    assign exchange = {24'h6687d1, 104'h0};                                         //XCHG CX, DX
    assign sar16 = {24'hc1f904, 104'h0};                                            //SAR ECX, 4
    assign mov_cs = {24'h668ec9, 104'h0};                                           //MOV CS, CX
    assign jump = {16'hffe2, 112'h0};                                               //JMP EDX
    assign ret_far = {8'hcb, 120'h0};                                               //RET FAR
    assign pop_eflags = {8'h59, 120'h0};                                            //POP EFLAGS to ECX but used to load EFLAGS

    muxnm_tristate #(.NUM_INPUTS(11), .DATA_WIDTH(128)) m2(.in({pop_eflags, ret_far, jump, mov_cs, sar16, exchange, second_4_bytes,
                                                                first_4_bytes, push_eip, push_cs, push_eflags}), 
                                                                .sel(IDTR_packet_select), .out(IDTR_packet_out));
    

endmodule

module IDTR_FSM (
    input clk,
    input set,
    input reset,
    input enable,

    input IE,
    input is_IRETD,
    input rrag_stall_in,
    input is_final_switch_instr_WB,

    output [10:0] IDTR_packet_select,
    output packet_out_select,
    output flush_pipe,
    output PTC_clear,
    output LD_EIP,
    output is_POP_EFLAGS,
    output LD_info_regs,
    output servicing_IE,
    output is_switching,                 //indicates that FSM is moving between ISR and normal execution and VV
    output invalidate_fetch_out
);

    wire [3:0] NS, CS, notCS, notNS;
    wire IE_not, is_IRETD_not, rrag_stall_not;
    wire NS0, NS1, NS2, NS3;


    
    inv1$ i0(.out(IE_not), .in(IE));
    inv1$ i1(.out(is_IRETD_not), .in(is_IRETD));
    inv1$ i7(.out(rrag_stall_not), .in(rrag_stall_in));

    //NEXT STATE LOGIC
    //NS[3]
    wire ns3_0, ns3_1, ns3_2;
    andn #(.NUM_INPUTS(3)) a1(.out(ns3_0), .in( {CS[2], CS[1], CS[0]} ));
    andn #(.NUM_INPUTS(2)) a2(.out(ns3_1), .in( {CS[3], notCS[2]} ));
    andn #(.NUM_INPUTS(2)) a3(.out(ns3_2), .in( {CS[3], notCS[1]} ));
    orn  #(.NUM_INPUTS(3)) o0(.out(NS3),  .in( {ns3_0, ns3_1, ns3_2} ));

    //NS[2]
    wire ns2_0, ns2_1, ns2_2, ns2_3;
    andn #(.NUM_INPUTS(4)) a4(.out(ns2_0), .in( {notCS[3], notCS[2], CS[1], CS[0]} ));
    andn #(.NUM_INPUTS(3)) a5(.out(ns2_1), .in( {notCS[3], CS[2], notCS[0]} ));
    andn #(.NUM_INPUTS(2)) a6(.out(ns2_2), .in( {CS[2], notCS[1]} ));
    andn #(.NUM_INPUTS(4)) a7(.out(ns2_3), .in( {notCS[2], CS[1], CS[0], is_IRETD} ));
    orn  #(.NUM_INPUTS(4)) o1(.out(NS2),  .in( {ns2_0, ns2_1, ns2_2, ns2_3} ));

    //NS[1]
    wire ns1_0, ns1_1, ns1_2, ns1_3;
    andn #(.NUM_INPUTS(3)) a8(.out(ns1_0),  .in( {notCS[3], CS[1], notCS[0] } ));
    andn #(.NUM_INPUTS(3)) a9(.out(ns1_1),  .in( {notCS[2], CS[1], notCS[0] } ));
    andn #(.NUM_INPUTS(2)) a10(.out(ns1_2), .in( {notCS[1], CS[0] } ));
    andn #(.NUM_INPUTS(4)) a11(.out(ns1_3), .in( {CS[3], notCS[2], CS[1], is_IRETD_not } ));
    orn  #(.NUM_INPUTS(4)) o2(.out(NS1),   .in( {ns1_0, ns1_1, ns1_2, ns1_3 } ));

    //NS[0]
    wire ns0_0, ns0_1, ns0_2, ns0_3, ns0_4;
    andn #(.NUM_INPUTS(3)) a12(.out(ns0_0), .in( {CS[3], notCS[2], notCS[0]} ));
    andn #(.NUM_INPUTS(3)) a13(.out(ns0_1), .in( {CS[2],notCS[1], notCS[0]} ));
    andn #(.NUM_INPUTS(3)) a14(.out(ns0_2), .in( {notCS[3], CS[1], notCS[0]} ));
    andn #(.NUM_INPUTS(3)) a15(.out(ns0_3), .in( {notCS[3], notCS[0], IE} ));
    andn #(.NUM_INPUTS(4)) a16(.out(ns0_4), .in( {CS[3], notCS[2], CS[1], is_IRETD_not} ));
    orn  #(.NUM_INPUTS(5)) o3(.out(NS0),   .in( {ns0_0, ns0_1, ns0_2, ns0_3, ns0_4} ));

    invn #(4) i134 (.out(notNS), .in( {NS} ));

    wire muxsel0, muxsel1, muxsel2, muxsel;
    
    andn #(5) wgw235 (.out(muxsel0), .in({ notNS[3:1], NS[0],  rrag_stall_in})); //next state is setup and rrag - allow to change
    //DO NOT CHANGE THIS FROM 3 --> 2 - somehow breaks everything
    orn #(3) p234 (.out(muxsel1), .in( {rrag_stall_not, muxsel0} ));
    //if allowed to move or no rrag stall, allow to move

    inv1$ i1834(.in(muxsel1), .out(muxsel2));
    orn #(2) j7367 (.out(muxsel), .in( {muxsel2, ld_mux_inv} ));

    //sel = 1 = stall, move on = 0
    mux2$ m0(.outb(NS[0]), .in0(NS0), .in1(CS[0]), .s0(muxsel));
    mux2$ m1(.outb(NS[1]), .in0(NS1), .in1(CS[1]), .s0(muxsel));
    mux2$ m2(.outb(NS[2]), .in0(NS2), .in1(CS[2]), .s0(muxsel));
    mux2$ m3(.outb(NS[3]), .in0(NS3), .in1(CS[3]), .s0(muxsel));

    dff$ s1(clk, NS[0], CS[0], notCS[0], reset, set);
    dff$ s2(clk, NS[1], CS[1], notCS[1], reset, set);
    dff$ s3(clk, NS[2], CS[2], notCS[2], reset, set);
    dff$ s4(clk, NS[3], CS[3], notCS[3], reset, set);

    //IDTR_packet_select
    andn #(.NUM_INPUTS(4)) a17(.out(IDTR_packet_select[0]),  .in( {notCS[3:2], CS[1], notCS[0]} ));
    andn #(.NUM_INPUTS(4)) a18(.out(IDTR_packet_select[1]),  .in( {notCS[3:2], CS[1:0]} ));
    andn #(.NUM_INPUTS(4)) a19(.out(IDTR_packet_select[2]),  .in( {notCS[3], CS[2], notCS[1:0]} ));
    andn #(.NUM_INPUTS(4)) a20(.out(IDTR_packet_select[3]),  .in( {notCS[3], CS[2], notCS[1], CS[0]} ));
 
    andn #(.NUM_INPUTS(4)) a21(.out(IDTR_packet_select[4]),  .in( {notCS[3], CS[2:1], notCS[0]} ));
    andn #(.NUM_INPUTS(4)) a22(.out(IDTR_packet_select[5]),  .in( {notCS[3], CS[2:0]} ));
    andn #(.NUM_INPUTS(4)) a23(.out(IDTR_packet_select[6]),  .in( {CS[3], notCS[2:0]} ));
    andn #(.NUM_INPUTS(4)) a24(.out(IDTR_packet_select[7]),  .in( {CS[3], notCS[2:1], CS[0]} ));
 
    andn #(.NUM_INPUTS(4)) a25(.out(IDTR_packet_select[8]),  .in( {CS[3], notCS[2], CS[1], notCS[0]}));
    andn #(.NUM_INPUTS(4)) a26(.out(IDTR_packet_select[9]),  .in( {CS[3:2], notCS[1], CS[0]} ));
    andn #(.NUM_INPUTS(4)) a27(.out(IDTR_packet_select[10]), .in( {CS[3:1], notCS[0]} ));

    //packet_out_select
    wire p0, p1, p2, p3, p4;
    andn #(.NUM_INPUTS(2)) a28(.out(p0), .in( { notCS[3], CS[1] } )); 
    andn #(.NUM_INPUTS(2)) a29(.out(p1), .in( { notCS[3], CS[2] } ));
    andn #(.NUM_INPUTS(2)) a30(.out(p2), .in( { CS[1], notCS[0] } ));
    andn #(.NUM_INPUTS(3)) a31(.out(p3), .in( { CS[3], notCS[1], CS[0] } ));
    andn #(.NUM_INPUTS(3)) a32(.out(p4), .in( { CS[3], notCS[2:1] } ));
    orn  #(.NUM_INPUTS(5)) o4(.out(packet_out_select), .in( {p0, p1, p2, p3, p4} ));

    //flush_pipe
    wire f0, f1;
    andn #(.NUM_INPUTS(4)) a33(.out(f0), .in( {notCS[3:1], CS[0]} ));
    andn #(.NUM_INPUTS(4)) a34(.out(f1), .in( {CS[3:2], notCS[1:0]} ));
    orn  #(.NUM_INPUTS(2)) o5(.out(flush_pipe), .in( {f0, f1} ));

    //PTC_clear - same as flush_pipe
    assign PTC_clear = flush_pipe;

    //LD_EIP
    wire e0, e1, e2;
    andn #(.NUM_INPUTS(4)) a35(.out(e0), .in( { notCS[3:0] } ));
    andn #(.NUM_INPUTS(3)) a36(.out(e1), .in( { CS[3], notCS[2], CS[1] } ));
    andn #(.NUM_INPUTS(3)) a37(.out(e2), .in( { CS[3:2], CS[1] } ));
    orn  #(.NUM_INPUTS(3)) o6(.out(LD_EIP), .in( {e0, e1, e2} ));

    //is_POP_EFLAGS
    //andn #(.NUM_INPUTS(4)) a38(.out(is_POP_EFLAGS), .in( {CS[3:2], notCS[1], CS[0]} ));
    andn #(.NUM_INPUTS(4)) a38(.out(is_POP_EFLAGS), .in( {CS[3:1], notCS[0] } ));

    //LD_info_regs
    andn #(.NUM_INPUTS(4)) a39(.out(LD_info_regs), .in( {notCS[3:0]} ));

    //servicing_IE
    wire not_servicing_IE, serv1, serv2;
    andn #(.NUM_INPUTS(4)) a40(.out(serv1), .in( { notCS[3:0] } ));
    andn #(.NUM_INPUTS(4)) a49(.out(serv2), .in( { notCS[3:1], CS[0] } ));
    orn  #(.NUM_INPUTS(2)) o99(.out(not_servicing_IE), .in( {serv1, serv2} ));
    inv1$ i2(.out(servicing_IE), .in(not_servicing_IE));

    //is_switching
    wire is_not_switching_0, is_not_switching_1, is_not_switching;
    andn #(.NUM_INPUTS(4)) a41(.out(is_not_switching_0), .in( { notCS[3:0] } ));
    andn #(.NUM_INPUTS(4)) a42(.out(is_not_switching_1), .in( { CS[3], notCS[2], CS[1:0] } ));
    orn  #(.NUM_INPUTS(2)) o9(.out(is_not_switching), .in( {is_not_switching_0, is_not_switching_1} ));
    inv1$ i9(.out(is_switching), .in(is_not_switching));

    //is_final_switch_state
    wire switch0, switch1;
    andn #(4) a43 (.out(switch0), .in( {CS[3], notCS[2], CS[1], notCS[0]} )); //1010
    //andn #(4) a44 (.out(switch1), .in( { CS[3:2], notCS[1], CS[0] } )); //1101
    andn #(4) a499876 (.out(switch1), .in( { CS[3:1], notCS[0] } )); //1110
    orn  #(.NUM_INPUTS(2)) o9898769(.out(is_final_switch_state), .in(  {switch0, switch1 /*, switch2*/ } ));

    //if (CS = 1010 or 1101 and is_final_switch_instr_WB = 0) then (NS = CS) , (fetch_packet_valid_out = 0)

    wire is_not_final_switch_instr_internal, is_final_switch_instr_internal;

    dff$ d111(.clk(clk), .d(is_final_switch_instr_WB), .q(is_final_switch_instr_internal), .qbar(is_not_final_switch_instr_internal), .r(reset), .s(set));
    
    wire ld_mux_inv, ld_mux;
    andn #(2) i44567(.out(ld_mux_inv), .in( {is_final_switch_state, is_not_final_switch_instr_internal} ));

    wire ld_mux_latched, ld_mux_out;
    dff$ d112(.clk(clk), .d(ld_mux), .q(ld_mux_latched), .qbar(), .r(reset), .s(set));
    andn #(2) (.out(ld_mux_out), .in( {rrag_stall_not, ld_mux_latched} ));

    inv1$ g543 (.out(ld_mux), .in(ld_mux_inv));
    assign invalidate_fetch_out = ld_mux_out;

endmodule

module endian_swap32 (
    input [31:0] in,
    output [31:0] out
);
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule