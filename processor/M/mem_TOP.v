module mem (input valid_in,
            input fwd_stall,
            input [1:0] opsize_in,
            input [31:0] mem_addr1, mem_addr2, mem_addr1_end, mem_addr2_end, latched_EIP_end,
            input mem1_end_is_valid, mem2_end_is_valid, latched_EIP_end_is_valid,
            input [63:0] reg1, reg2, reg3, reg4,
            input [127:0] ptc_r1, ptc_r2, ptc_r3, ptc_r4,
            input [2:0] reg1_orig, reg2_orig, reg3_orig, reg4_orig,
            input [15:0] seg1, seg2, seg3, seg4,
            input [31:0] ptc_s1, ptc_s2, ptc_s3, ptc_s4,
            input [19:0] seg1_lim, seg2_lim, seg3_lim, seg4_lim,
            output [2:0] seg1_orig, seg2_orig, seg3_orig, seg4_orig,
            input [6:0] inst_ptcid_in,
            input [12:0] op1_sel, op2_sel, op3_sel, op4_sel,
            input [12:0] dest1_sel, dest2_sel, dest3_sel, dest4_sel,
            input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in,
            input [31:0] rep_num,
            input        is_rep_in,
            input idtr_ptc_clear,

            input clk_bus,
            inout [72:0] BUS,
            input [1:0] setReceiver_d,
            output [1:0] free_bau_d,
            input [3:0] grant_d, ack_d,
            output [3:0] releases_d, req_d,
            output [15:0] dest_d,

            input [63:0] wb_memdata,
            input [31:0] wb_memaddr,
            input [1:0] wb_size,
            input wb_valid,
            input [6:0] wb_ptcid,
            output wbaq_isfull,

            input [159:0] VP_in,                  
            input [159:0] PF_in,
            input [7:0] entry_V_in,
            input [7:0] entry_P_in,
            input [7:0] entry_RW_in,
            input [7:0] entry_PCD_in,

            input [7:0] qentry_slot_in,
            output [7:0] rd_qentry_slots_out_e, sw_qentry_slots_out_e, rd_qentry_slots_out_o, sw_qentry_slots_out_o,
            output [7:0] rd_qentry_slots_out_e_io, sw_qentry_slots_out_e_io, rd_qentry_slots_out_o_io, sw_qentry_slots_out_o_io,
            
            input [4:0] aluk_in,
            input [2:0] mux_adder_in,
            input mux_and_int_in, mux_shift_in,
            input [36:0] p_op_in,
            input [17:0] fmask_in,
            input [15:0] CS_in,
            input [1:0] conditionals_in,
            input is_br_in, is_fp_in, is_imm_in,
            input [47:0] imm,
            input [1:0] mem1_rw, mem2_rw,
            input [3:0] memsizeOVR_in,
            input [31:0] eip_in,
            input [31:0] latched_eip_in,
            input IE_in,
            input [3:0] IE_type_in,
            input       instr_is_IDTR_orig_in,
            input [31:0] BR_pred_target_in,
            input BR_pred_T_NT_in,
            input [7:0] BP_alias_in,
            input clk_ng,

            input clr,
            input clk,
           
            output valid_out,
            output [3:0] memsizeOVR_out,
            output [31:0] eip_out,
            output [31:0] latched_eip_out,
            output IE_out,
            output [3:0] IE_type_out,
            output       instr_is_IDTR_orig_out,
            output [31:0] BR_pred_target_out,
            output BR_pred_T_NT_out,
            output [7:0] BP_alias_out,
            
            output [1:0] opsize_out,
            output [63:0] op1_val, op2_val, op3_val, op4_val,
            output [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo,
            output [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr,
            output [127:0] dest1_ptcinfo, dest2_ptcinfo, dest3_ptcinfo, dest4_ptcinfo,
            output dest1_is_reg, dest2_is_reg, dest3_is_reg, dest4_is_reg,
            output dest1_is_seg, dest2_is_seg, dest3_is_seg, dest4_is_seg,
            output dest1_is_mem, dest2_is_mem, dest3_is_mem, dest4_is_mem,
            output res1_ld_out, res2_ld_out, res3_ld_out, res4_ld_out,
            output [6:0] inst_ptcid_out,
            
            output [4:0] aluk_out,
            output [2:0] mux_adder_out,
            output mux_and_int_out, mux_shift_out,
            output [36:0] p_op_out,
            output [17:0] fmask_out,
            output [1:0] conditionals_out,
            output is_br_out, is_fp_out, is_imm_out, is_rep_out,
            output [15:0] CS_out,

            output [3:0] wake_init_out, wake_cache_out,
            output [7:0] cache_qentry_slot_out,
            output cache_valid_out,
            output [63:0] cache_data_out,
            output [127:0] cache_ptcinfo_out,
            output stall,

            output [127:0] cacheline_e_bus_in_data, cacheline_o_bus_in_data,
            output [255:0] cacheline_e_bus_in_ptcinfo, cacheline_o_bus_in_ptcinfo);

    assign memsizeOVR_out = memsizeOVR_in;

    wire r_is_m1, sw_is_m1;
    wire TLB_miss, prot_exc;
    wire rdaq_isfull, swaq_isfull;
    wire [127:0] ptc_info_r, ptc_info_sw;
    wire [3:0] wake_init_r, wake_init_sw;
    wire cache_stall;

    assign wake_init_out = {wake_init_sw[3],wake_init_r[2],wake_init_sw[1],wake_init_r[0]};

    wire [127:0] data_out;
    wire [1:0] size_to_use;
    wire usenormalopsize, ispush;
    wire [31:0] pushdecamnt, stackptrpostpush, realmem2;

    nor4$ gasdasd(.out(usenormalopsize), .in0(memsizeOVR_in[0]), .in1(memsizeOVR_in[1]), .in2(memsizeOVR_in[2]), .in3(memsizeOVR_in[3]));
    muxnm_tristate #(.NUM_INPUTS(5), .DATA_WIDTH(2)) mfcvgbhnj(.in({opsize_in,2'b11,2'b10,2'b01,2'b00}), .sel({usenormalopsize,memsizeOVR_in}), .out(size_to_use));

    muxnm_tree #(.SEL_WIDTH(2), .DATA_WIDTH(32)) mpush0(.in({32'hffff_fff8,32'hffff_fffc,32'hffff_fffe,32'hffff_ffff}), .sel(size_to_use), .out(pushdecamnt));
    kogeAdder #(.WIDTH(32)) addpush(.SUM(stackptrpostpush), .COUT(), .A(mem_addr2), .B(pushdecamnt), .CIN(1'b0));
    or4$ gpush(.out(ispush), .in0(p_op_in[35]), .in1(p_op_in[34]), .in2(p_op_in[3]), .in3(p_op_in[26]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) mpush1(.in({stackptrpostpush,mem_addr2}), .sel(ispush), .out(realmem2));

    d$ dcache(.clk(clk_ng), .clk_bus(clk_bus), .rst(clr), .set(1'b1), .BUS(BUS),
              .latched_eip_mem_$(latched_eip_in), .latched_ptcid_mem_$(inst_ptcid_in),
              .setReciever_d(setReceiver_d), .free_bau_d(free_bau_d), .grant_d(grant_d), .ack_d(ack_d), .releases_d(releases_d), .req_d(req_d), .dest_d(dest_d),
              .data_m1(), .data_m2(), .M1(mem_addr1), .M2(realmem2), .M1_RW(mem1_rw), .M2_RW(mem2_rw),
              .opsize(size_to_use), .valid_RSW(valid_in), .fwd_stall(fwd_stall), .sizeOVR(1'b0), .PTC_ID_in(inst_ptcid_in), .qentry_slot_in(qentry_slot_in), .r_is_m1(r_is_m1), .sw_is_m1(sw_is_m1),
              .TLB_miss_wb(), .TLB_pe_wb(), .TLB_hit_wb(),
              .TLB_miss_r(), .TLB_pe_r(), .TLB_hit_r(),
              .TLB_miss_sw(), .TLB_pe_sw(), .TLB_hit_sw(), .ptc_clear(idtr_ptc_clear),
              .data_in_wb({64'h0000000000000000,wb_memdata}), .address_in_wb(wb_memaddr), .size_in_wb(wb_size), .valid_in_wb(wb_valid), .PTC_ID_in_wb(wb_ptcid),
              .VP(VP_in), .PF(PF_in),
              .entry_V(entry_V_in), .entry_P(entry_P_in), .entry_RW(entry_RW_in), .entry_PCD(entry_PCD_in),
              .TLB_miss(TLB_miss), .protection_exception(prot_exc), .TLB_hit(), .PCD_out(),
              .ptc_info_r(ptc_info_r), .ptc_info_sw(ptc_info_sw), .wake_init_vector_r(wake_init_r), .wake_init_vector_sw(wake_init_sw),
              .aq_isempty(), .rdaq_isfull(rdaq_isfull), .swaq_isfull(swaq_isfull), .wbaq_isfull(wbaq_isfull),
              .wake(wake_cache_out), .PTC_ID_out(), .cache_valid(cache_valid_out),
              .data(data_out), .stall(cache_stall), .ptcinfo_out(cache_ptcinfo_out), .qentry_slot_out(cache_qentry_slot_out),
              .rd_qentry_slots_out_e(rd_qentry_slots_out_e), .sw_qentry_slots_out_e(sw_qentry_slots_out_e), .mshr_hit_e(), .mshr_full_e(),
              .rd_qentry_slots_out_o(rd_qentry_slots_out_o), .sw_qentry_slots_out_o(sw_qentry_slots_out_o), .mshr_hit_o(), .mshr_full_o(),
              .cacheline_e_bus_in_data(cacheline_e_bus_in_data), .cacheline_o_bus_in_data(cacheline_o_bus_in_data), .cacheline_e_bus_in_ptcinfo(cacheline_e_bus_in_ptcinfo), .cacheline_o_bus_in_ptcinfo(cacheline_o_bus_in_ptcinfo),
              .rd_qentry_slots_out_e_io(rd_qentry_slots_out_e_io), .sw_qentry_slots_out_e_io(sw_qentry_slots_out_e_io), .mshr_hit_e_io(), .mshr_full_e_io(),
              .rd_qentry_slots_out_o_io(rd_qentry_slots_out_o_io), .sw_qentry_slots_out_o_io(sw_qentry_slots_out_o_io), .mshr_hit_o_io(), .mshr_full_o_io());

    assign cache_data_out = data_out[63:0]; //TODO: why is data out 128bits

    wire guarded_fwd_stall;
    wire invstall, valid_in_inv;

    and2$ gfwd(.out(guarded_fwd_stall), .in0(fwd_stall), .in1(valid_in));
    or2$ g1(.out(stall), .in0(cache_stall), .in1(guarded_fwd_stall));
    inv1$ g2(.out(invstall), .in(stall));
    and2$ g3(.out(valid_out), .in0(valid_in), .in1(invstall));
    inv1$ g678(.out(valid_in_inv), .in(valid_in));

    wire mem1_is_access, mem2_is_access;
    orn #(2) yur(.in({mem1_rw}), .out(mem1_is_access));
    orn #(2) yurr(.in({mem2_rw}), .out(mem2_is_access));

    wire [127:0] m1_ptc, m2_ptc;

    muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(128)) m0ghkghi(.in({ptc_info_r,ptc_info_sw}), .sel({r_is_m1,sw_is_m1}), .out(m1_ptc));
    muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(128)) mkbkhk1(.in({ptc_info_r,ptc_info_sw}), .sel({sw_is_m1,r_is_m1}), .out(m2_ptc));

    opswap os(.reg1_data(reg1), .reg2_data(reg2), .reg3_data(reg3), .reg4_data(reg4),
              .reg1_addr(reg1_orig), .reg2_addr(reg2_orig), .reg3_addr(reg3_orig), .reg4_addr(reg4_orig),
              .reg1_ptc(ptc_r1), .reg2_ptc(ptc_r2), .reg3_ptc(ptc_r3), .reg4_ptc(ptc_r4),
              .seg1_data(seg1), .seg2_data(seg2), .seg3_data(seg3), .seg4_data(seg4),
              .seg1_addr(seg1_orig), .seg2_addr(seg2_orig), .seg3_addr(seg3_orig), .seg4_addr(seg4_orig),
              .seg1_ptc(ptc_s1), .seg2_ptc(ptc_s2), .seg3_ptc(ptc_s3), .seg4_ptc(ptc_s4),
              .mem1_data(64'h0000000000000000), .mem2_data(64'h0000000000000000),
              .mem1_addr(mem_addr1), .mem2_addr(realmem2),
              .mem1_ptc(m1_ptc), .mem2_ptc(m2_ptc),
              .eip_data(eip_in), .imm(imm),
              .op1_mux(op1_sel), .op2_mux(op2_sel), .op3_mux(op3_sel), .op4_mux(op4_sel),
              .dest1_mux(dest1_sel), .dest2_mux(dest2_sel), .dest3_mux(dest3_sel), .dest4_mux(dest4_sel),
              .op1(op1_val), .op2(op2_val), .op3(op3_val), .op4(op4_val),
              .op1_ptcinfo(op1_ptcinfo), .op2_ptcinfo(op2_ptcinfo), .op3_ptcinfo(op3_ptcinfo), .op4_ptcinfo(op4_ptcinfo),
              .dest1_addr(dest1_addr), .dest2_addr(dest2_addr), .dest3_addr(dest3_addr), .dest4_addr(dest4_addr),
              .dest1_ptcinfo(dest1_ptcinfo), .dest2_ptcinfo(dest2_ptcinfo), .dest3_ptcinfo(dest3_ptcinfo), .dest4_ptcinfo(dest4_ptcinfo),
              .dest1_type({dest1_is_mem,dest1_is_seg,dest1_is_reg}), .dest2_type({dest2_is_mem,dest2_is_seg,dest2_is_reg}), .dest3_type({dest3_is_mem,dest3_is_seg,dest3_is_reg}), .dest4_type({dest4_is_mem,dest4_is_seg,dest4_is_reg}));
    
    wire prot_seg1, prot_seg2, prot_seg3, prot_seg1_almost, prot_seg2_almost, prot_seg3_almost, prot_seg;

    //seg_lim_exception_logic segcheck1(.read_address_end_size(mem_addr1_end), .seg_size(seg1_lim), .seg_lim_exception(prot_seg1_almost));
    //seg_lim_exception_logic segcheck2(.read_address_end_size(mem_addr2_end), .seg_size(seg2_lim), .seg_lim_exception(prot_seg2_almost));
    //seg_lim_exception_logic segcheck3(.read_address_end_size(latched_EIP_end), .seg_size(seg4_lim), .seg_lim_exception(prot_seg3_almost));

    wire [31:0] seg1_shifted, SEG1_MAX, seg2_shifted, SEG2_MAX, seg4_shifted, SEG4_MAX;
    assign seg1_shifted = {seg1, 16'h0000};
    assign seg2_shifted = {seg2, 16'h0000};
    assign seg4_shifted = {seg4, 16'h0000};

    kogeAdder #(.WIDTH(32)) adder1(.SUM(SEG1_MAX), .COUT(cout1), .A(seg1_shifted), .B({12'h0, seg1_lim}), .CIN(1'b0));
    kogeAdder #(.WIDTH(32)) adder2(.SUM(SEG2_MAX), .COUT(cout2), .A(seg2_shifted), .B({12'h0, seg2_lim}), .CIN(1'b0));
    kogeAdder #(.WIDTH(32)) adder4(.SUM(SEG4_MAX), .COUT(cout4), .A(seg4_shifted), .B({12'h0, seg4_lim}), .CIN(1'b0));

    seg_lim_check s1(.VP(VP_in), .PF(PF_in), .address(mem_addr1), .seg_max(SEG1_MAX), .seg_lim_exception(prot_seg1_almost) );
    seg_lim_check s2(.VP(VP_in), .PF(PF_in), .address(mem_addr2), .seg_max(SEG2_MAX), .seg_lim_exception(prot_seg2_almost) );
    seg_lim_check s4(.VP(VP_in), .PF(PF_in), .address(latched_eip_in), .seg_max(SEG4_MAX), .seg_lim_exception(prot_seg3) );

    andn #(2) seglim_ismem1 (.in( {prot_seg1_almost, mem1_is_access} ), .out(prot_seg1));
    andn #(2) seglim_ismem2 (.in( {prot_seg2_almost, mem2_is_access } ), .out(prot_seg2));

    orn #(3) seg_or(.out(prot_seg), .in( {prot_seg1, prot_seg2, prot_seg3}));

    wire [3:0] IE_type_out_almost;
    or2$ g111(.out(IE_type_out_almost[0]), .in0(prot_seg), .in1(prot_exc));                        //update protection exception
    assign IE_type_out_almost[1] = TLB_miss;                                                       //update page fault exception
    assign IE_type_out_almost[3:2] = IE_type_in[3:2];                                              //pass along
    
    wire IE_out_almost;
    orn #(4) g222(.out(IE_out_almost), .in({IE_in, prot_seg, TLB_miss, prot_exc}));                      //update IE_out
    andn #(2) g99(.out(IE_out), .in( {IE_out_almost, valid_in} ));
    b4_bitwise_and yaba (.out(IE_type_out), .in0(IE_type_out_almost), .in1( {valid_in, valid_in, valid_in, valid_in} ));
    
    assign res1_ld_out = res1_ld_in;
    assign res2_ld_out = res2_ld_in;
    assign res3_ld_out = res3_ld_in;
    assign res4_ld_out = res4_ld_in;

    assign inst_ptcid_out = inst_ptcid_in;  
    
    assign eip_out = eip_in;
    assign latched_eip_out = latched_eip_in;
    assign BR_pred_target_out = BR_pred_target_in;
    assign BR_pred_T_NT_out = BR_pred_T_NT_in;
    assign aluk_out = aluk_in;
    assign mux_adder_out = mux_adder_in;
    assign mux_and_int_out = mux_and_int_in;
    assign mux_shift_out = mux_shift_in;
    assign p_op_out = p_op_in;
    assign fmask_out = fmask_in;
    assign conditionals_out = conditionals_in;
    assign is_br_out = is_br_in;
    assign is_fp_out = is_fp_in;
    assign is_imm_out = is_imm_in;
    assign is_rep_out = is_rep_in;
    assign CS_out = CS_in;
    assign BP_alias_out = BP_alias_in;

    assign opsize_out = opsize_in;
    wire[31:0] eip_$, address_1_$, address_2_$;
    assign address_1_$ =  mem_addr1;
    assign address_2_$ = realmem2;
    wire[7:0] ptc_id_$; 
    wire clk_$;
    integer cyc_ctr_$;
    initial cyc_ctr_$ = 0;
    always @(posedge clk) begin 
        cyc_ctr_$ = cyc_ctr_$ + 1;
    end
    assign valid_in_$ = valid_in;
    assign ptc_id_$ = inst_ptcid_in;
    assign eip_$ = latched_eip_in;
    assign instr_is_IDTR_orig_out = instr_is_IDTR_orig_in;
   
endmodule
