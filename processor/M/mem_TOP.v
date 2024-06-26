module mem (input valid_in,
            input fwd_stall,
            input [1:0] opsize_in,
            input [31:0] mem_addr1, mem_addr2, mem_addr1_end, mem_addr2_end,
            input [63:0] reg1, reg2, reg3, reg4,
            input [127:0] ptc_r1, ptc_r2, ptc_r3, ptc_r4,
            input [2:0] reg1_orig, reg2_orig, reg3_orig, reg4_orig,
            input [15:0] seg1, seg2, seg3, seg4,
            input [31:0] ptc_s1, ptc_s2, ptc_s3, ptc_s4,
            output [2:0] seg1_orig, seg2_orig, seg3_orig, seg4_orig,
            input [6:0] inst_ptcid_in,
            input [12:0] op1_sel, op2_sel, op3_sel, op4_sel,
            input [12:0] dest1_sel, dest2_sel, dest3_sel, dest4_sel,
            input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in,
            input [31:0] rep_num,
            input        is_rep_in,
            input memsizeOVR,
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

            input [7:0] qentry_slot_in_e, qentry_slot_in_o,
            output [6:0] ptcid_out_e, ptcid_out_o,
            output [7:0] rd_qentry_slots_out_e, sw_qentry_slots_out_e, rd_qentry_slots_out_o, sw_qentry_slots_out_o,
            
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
            input [31:0] eip_in,
            input [31:0] latched_eip_in,
            input IE_in,
            input [3:0] IE_type_in,
            input [31:0] BR_pred_target_in,
            input BR_pred_T_NT_in,
            input [5:0] BP_alias_in,

            input clr,
            input clk,
           
            output valid_out,
            output [31:0] eip_out,
            output [31:0] latched_eip_out,
            output IE_out,
            output [3:0] IE_type_out,
            output [31:0] BR_pred_target_out,
            output BR_pred_T_NT_out,
            output [5:0] BP_alias_out,
            
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
            output [16:0] fmask_out,
            output [1:0] conditionals_out,
            output is_br_out, is_fp_out, is_imm_out, is_rep_out,
            output [15:0] CS_out,

            output [3:0] wake_init_out, wake_cache_out,
            output [6:0] cache_ptcid_out,
            output cache_valid_out,
            output [63:0] cache_data_out,
            output [127:0] cache_ptcinfo_out,
            output stall,

            output [127:0] cacheline_e_bus_in_data, cacheline_o_bus_in_data,
            output [255:0] cacheline_e_bus_in_ptcinfo, cacheline_o_bus_in_ptcinfo
            );

    wire [31:0] mem1, nextmem1, regmem1, mem2, nextmem2, regmem2, incdec;
    wire isrepreg;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m0(.in({32'h0000_0001,32'hffff_ffff}), .sel(/*TODO:*/), .out(incdec));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m1(.in({regmem1,mem_addr1}), .sel(isrepreg), .out(mem1));
    kogeAdder #(.WIDTH(32)) add0(.SUM(nextmem1), .COUT(), .A(mem1), .B(incdec), .CIN(1'b0));
    regn #(.WIDTH(32)) r0(.din(nextmem1), .ld(1'b1), .clr(clr), .clk(clk), .dout(regmem1));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m2(.in({regmem2,mem_addr2}), .sel(isrepreg), .out(mem2));
    kogeAdder #(.WIDTH(32)) add1(.SUM(nextmem2), .COUT(), .A(mem2), .B(incdec), .CIN(1'b0));
    regn #(.WIDTH(32)) r1(.din(nextmem2), .ld(1'b1), .clr(clr), .clk(clk), .dout(regmem2));

    regn #(.WIDTH(1)) r2(.din(is_rep_in), .ld(1'b1), .clr(clr), .clk(clk), .dout(isrepreg));

    wire [31:0] cnt, nextcnt, cntreg;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m3(.in({cntreg,reg3[31:0]}), .sel(isrepreg), .out(cnt));
    kogeAdder #(.WIDTH(32)) add2(.SUM(nextcnt), .COUT(), .A(cnt), .B(32'hffff_ffff), .CIN(1'b0));
    regn #(.WIDTH(32)) r4(.din(nextcnt), .ld(1'b1), .clr(clr), .clk(clk), .dout(cntreg));

    wire rep_stall, cntnotzero;

    orn #(.NUM_INPUTS(32)) or0(.in(nextcnt), .out(cntnotzero));
    and2$ g0(.out(rep_stall), .in0(cntnotzero), .in1(is_rep_in));

    wire r_is_m1, sw_is_m1;
    wire TLB_miss, prot_exc;
    wire rdaq_isfull, swaq_isfull;
    wire [127:0] ptc_info_r, ptc_info_sw;
    wire [3:0] wake_init_r, wake_init_sw;
    wire cache_stall;

    assign wake_init_out = {wake_init_sw[3],wake_init_r[2],wake_init_sw[1],wake_init_r[0]};

    wire [127:0] data_out;

    d$ dcache(.clk(clk), .clk_bus(clk_bus), .rst(clr), .set(1'b1), .BUS(BUS),
              .setReciever_d(setReceiver_d), .free_bau_d(free_bau_d), .grant_d(grant_d), .ack_d(ack_d), .releases_d(releases_d), .req_d(req_d), .dest_d(dest_d),
              .data_m1(), .data_m2(), .M1(mem1), .M2(mem2), .M1_RW(mem1_rw), .M2_RW(mem2_rw),
              .opsize(opsize_in), .valid_RSW(valid_in), .sizeOVR(memsizeOVR), .PTC_ID_in(inst_ptcid_in), .r_is_m1(r_is_m1), .sw_is_m1(sw_is_m1),
              .TLB_miss_wb(), .TLB_pe_wb(), .TLB_hit_wb(),
              .TLB_miss_r(), .TLB_pe_r(), .TLB_hit_r(),
              .TLB_miss_sw(), .TLB_pe_sw(), .TLB_hit_sw(),
              .data_in_wb({64'h0000000000000000,wb_memdata}), .address_in_wb(wb_memaddr), .size_in_wb(wb_size), .valid_in_wb(wb_valid), .PTC_ID_in_wb(wb_ptcid),
              .VP(VP_in), .PF(PF_in),
              .entry_V(entry_V_in), .entry_P(entry_P_in), .entry_RW(entry_RW_in), .entry_PCD(entry_PCD_in),
              .TLB_miss(TLB_miss), .protection_exception(prot_exc), .TLB_hit(), .PCD_out(),
              .ptc_info_r(ptc_info_r), .ptc_info_sw(ptc_info_sw), .wake_init_vector_r(wake_init_r), .wake_init_vector_sw(wake_init_sw),
              .aq_isempty(), .rdaq_isfull(rdaq_isfull), .swaq_isfull(swaq_isfull), .wbaq_isfull(wbaq_isfull),
              .wake(wake_cache_out), .PTC_ID_out(cache_ptcid_out), .cache_valid(cache_valid_out), .data(data_out), .stall(cache_stall), .ptcinfo_out(cache_ptcinfo_out),
              .qentry_slot_in_e(qentry_slot_in_e), .ptcid_out_e(ptcid_out_e), .rd_qentry_slots_out_e(rd_qentry_slots_out_e), .sw_qentry_slots_out_e(sw_qentry_slots_out_e), .mshr_hit_e(), .mshr_full_e(),
              .qentry_slot_in_o(qentry_slot_in_o), .ptcid_out_o(ptcid_out_o), .rd_qentry_slots_out_o(rd_qentry_slots_out_o), .sw_qentry_slots_out_o(sw_qentry_slots_out_o), .mshr_hit_o(), .mshr_full_o(),
              .cacheline_e_bus_in_data(cacheline_e_bus_in_data), .cacheline_o_bus_in_data(cacheline_o_bus_in_data), .cacheline_e_bus_in_ptcinfo(cacheline_e_bus_in_ptcinfo), .cacheline_o_bus_in_ptcinfo(cacheline_o_bus_in_ptcinfo));

    assign cache_data_out = data_out[63:0]; //TODO: why is data out 128bits

    wire invstall;

    or3$ g1(.out(stall), .in0(rep_stall), .in1(cache_stall), .in2(fwd_stall));
    inv1$ g2(.out(invstall), .in(stall));
    and2$ g3(.out(valid_out), .in0(valid_in), .in1(invstall));

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
              .mem1_addr(mem1), .mem2_addr(mem2),
              .mem1_ptc(m1_ptc), .mem2_ptc(m2_ptc),
              .eip_data(eip_in), .imm(imm),
              .op1_mux(op1_sel), .op2_mux(op2_sel), .op3_mux(op3_sel), .op4_mux(op4_sel),
              .dest1_mux(dest1_sel), .dest2_mux(dest2_sel), .dest3_mux(dest3_sel), .dest4_mux(dest4_sel),
              .op1(op1_val), .op2(op2_val), .op3(op3_val), .op4(op4_val),
              .op1_ptcinfo(op1_ptcinfo), .op2_ptcinfo(op2_ptcinfo), .op3_ptcinfo(op3_ptcinfo), .op4_ptcinfo(op4_ptcinfo),
              .dest1_addr(dest1_addr), .dest2_addr(dest2_addr), .dest3_addr(dest3_addr), .dest4_addr(dest4_addr),
              .dest1_ptcinfo(dest1_ptcinfo), .dest2_ptcinfo(dest2_ptcinfo), .dest3_ptcinfo(dest3_ptcinfo), .dest4_ptcinfo(dest4_ptcinfo),
              .dest1_type({dest1_is_mem,dest1_is_seg,dest1_is_reg}), .dest2_type({dest2_is_mem,dest2_is_seg,dest2_is_reg}), .dest3_type({dest3_is_mem,dest3_is_seg,dest3_is_reg}), .dest4_type({dest4_is_mem,dest4_is_seg,dest4_is_reg}));
    
    //TODO:
    //or2$ g1(.out(IE_type_out[0]), .in0(prot_seg), .in1(TLB_prot));                        //update protection exception
    //assign IE_type_out[1] = TLB_miss;                                                   //update page fault exception
    //assign IE_type_out[3:2] = IE_type_in[3:2];                                          //pass along
    //or4$ g2(.out(IE_out), .in1(IE_in), .in2(prot_seg), .in3(TLB_miss), .in4(TLB_prot));   //update IE_out
    
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

endmodule