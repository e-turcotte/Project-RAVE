module TOP();
    localparam CYCLE_TIME = 8.0;

    reg clk;
    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    //FETCH1 -> FETCH2 -> DECODE -> RrAg -> MEM -> EX -> WB

    //  IMPORTANT NOTES:
    //   -  notation for latche wires: <signal.name>_<stage.prev>_<stage.next>_latch_<in/out>
    //      where <in> is the input to the latch (output of stage.prev) and <out> is the output 
    //      from the latch (input of stage.next)

    ///////////////////////////////////////////////////////////
    // Outputs from Rr/Ag that go into the RrAg_MEM_latch:  //  
    //////////////////////////////////////////////////////////
    wire valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in;
    wire [1:0] opsize_RrAg_MEM_latch_in;
    wire [31:0] mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in;
    wire [63:0] reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in;
    wire [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in;
    wire [2:0] reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in;
    wire [15:0] seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in;
    wire [31:0] ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in;
    wire [2:0] seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in;
    wire [6:0] inst_ptcid_RrAg_MEM_latch_in;
    wire [12:0] op1_out_RrAg_MEM_latch_in, op2_out_RrAg_MEM_latch_in, op3_out_RrAg_MEM_latch_in, op4_out_RrAg_MEM_latch_in;
    wire [12:0] dest1_out_RrAg_MEM_latch_in, dest2_out_RrAg_MEM_latch_in, dest3_out_RrAg_MEM_latch_in, dest4_out_RrAg_MEM_latch_in;
    wire res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in;
    wire [31:0] rep_num_RrAg_MEM_latch_in;
    wire [4:0] aluk_out_RrAg_MEM_latch_in;
    wire [2:0] mux_adder_out_RrAg_MEM_latch_in;
    wire mux_and_int_out_RrAg_MEM_latch_in, mux_shift_out_RrAg_MEM_latch_in;
    wire [36:0] p_op_out_RrAg_MEM_latch_in;
    wire [17:0] fmask_out_RrAg_MEM_latch_in;
    wire [1:0] conditionals_out_RrAg_MEM_latch_in;
    wire is_br_out_RrAg_MEM_latch_in, is_fp_out_RrAg_MEM_latch_in;
    wire [47:0] imm_out_RrAg_MEM_latch_in;
    wire [1:0] mem1_rw_out_RrAg_MEM_latch_in, mem2_rw_out_RrAg_MEM_latch_in;
    wire [31:0] eip_out_RrAg_MEM_latch_in;
    wire IE_out_RrAg_MEM_latch_in;
    wire [3:0] IE_type_out_RrAg_MEM_latch_in;
    wire [31:0] BR_pred_target_out_RrAg_MEM_latch_in;
    wire BR_pred_T_NT_out_RrAg_MEM_latch_in;
    
    ///////////////////////////////////////////////////////////
    //   Outputs from RrAg_MEM_latch that go into the MEM:  //  
    //////////////////////////////////////////////////////////

    wire valid_RrAg_MEM_latch_out, stall_RrAg_MEM_latch_out;
    wire [1:0] opsize_RrAg_MEM_latch_out;
    wire [31:0] mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out;
    wire [63:0] reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out;
    wire [127:0] ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out;
    wire [2:0] reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out;
    wire [15:0] seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out;
    wire [31:0] ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out;
    wire [2:0] seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out;
    wire [6:0] inst_ptcid_RrAg_MEM_latch_out;
    wire [12:0] op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out;
    wire [12:0] dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out;
    wire res1_ld_out_RrAg_MEM_latch_out, res2_ld_out_RrAg_MEM_latch_out, res3_ld_out_RrAg_MEM_latch_out, res4_ld_out_RrAg_MEM_latch_out;
    wire [31:0] rep_num_RrAg_MEM_latch_out;
    wire [4:0] aluk_RrAg_MEM_latch_out;
    wire [2:0] mux_adder_RrAg_MEM_latch_out;
    wire mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out;
    wire [36:0] p_op_RrAg_MEM_latch_out;
    wire [17:0] fmask_RrAg_MEM_latch_out;
    wire [1:0] conditionals_RrAg_MEM_latch_out;
    wire is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out;
    wire [47:0] imm_RrAg_MEM_latch_out;
    wire [1:0] mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out;
    wire [31:0] eip_RrAg_MEM_latch_out;
    wire IE_RrAg_MEM_latch_out;
    wire [3:0] IE_type_RrAg_MEM_latch_out;
    wire [31:0] BR_pred_target_RrAg_MEM_latch_out;
    wire BR_pred_T_NT_RrAg_MEM_latch_out;      
    
    wire [RrAg_MEM_latch_size - 1 : 0] all_RrAg_MEM_latch_out;
    wire [RrAg_MEM_latch_size - 1 : 0] all_RrAg_MEM_latch_in;

    assign all_RrAg_MEM_latch_out = {valid_RrAg_MEM_latch_out, stall_RrAg_MEM_latch_out, opsize_RrAg_MEM_latch_out,
                                  mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out,
                                  reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out,
                                  ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out,
                                  reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out,
                                  seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out,
                                  ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out,
                                  seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out,
                                  inst_ptcid_RrAg_MEM_latch_out,
                                  op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out,
                                  dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out,
                                  res1_ld_out_RrAg_MEM_latch_out, res2_ld_out_RrAg_MEM_latch_out, res3_ld_out_RrAg_MEM_latch_out, res4_ld_out_RrAg_MEM_latch_out,
                                  rep_num_RrAg_MEM_latch_out,
                                  aluk_RrAg_MEM_latch_out,
                                  mux_adder_RrAg_MEM_latch_out,
                                  mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out,
                                  p_op_RrAg_MEM_latch_out,
                                  fmask_RrAg_MEM_latch_out,
                                  conditionals_RrAg_MEM_latch_out,
                                  is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out,
                                  imm_RrAg_MEM_latch_out,
                                  mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out,
                                  eip_RrAg_MEM_latch_out,
                                  IE_RrAg_MEM_latch_out,
                                  IE_type_RrAg_MEM_latch_out,
                                  BR_pred_target_RrAg_MEM_latch_out,
                                  BR_pred_T_NT_RrAg_MEM_latch_out};

    assign all_RrAg_MEM_latch_in = {valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in, opsize_RrAg_MEM_latch_in,
                                 mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in,
                                 reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in,
                                 ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in,
                                 reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in,
                                 seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in,
                                 ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in,
                                 seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in,
                                 inst_ptcid_RrAg_MEM_latch_in,
                                 op1_RrAg_MEM_latch_in, op2_RrAg_MEM_latch_in, op3_RrAg_MEM_latch_in, op4_RrAg_MEM_latch_in,
                                 dest1_RrAg_MEM_latch_in, dest2_RrAg_MEM_latch_in, dest3_RrAg_MEM_latch_in, dest4_RrAg_MEM_latch_in,
                                 res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in,
                                 rep_num_RrAg_MEM_latch_in,
                                 aluk_RrAg_MEM_latch_in,
                                 mux_adder_RrAg_MEM_latch_in,
                                 mux_and_int_RrAg_MEM_latch_in, mux_shift_RrAg_MEM_latch_in,
                                 p_op_RrAg_MEM_latch_in,
                                 fmask_RrAg_MEM_latch_in,
                                 conditionals_RrAg_MEM_latch_in,
                                 is_br_RrAg_MEM_latch_in, is_fp_RrAg_MEM_latch_in,
                                 imm_RrAg_MEM_latch_in,
                                 mem1_rw_RrAg_MEM_latch_in, mem2_rw_RrAg_MEM_latch_in,
                                 eip_RrAg_MEM_latch_in,
                                 IE_RrAg_MEM_latch_in,
                                 IE_type_RrAg_MEM_latch_in,
                                 BR_pred_target_RrAg_MEM_latch_in,
                                 BR_pred_T_NT_RrAg_MEM_latch_in
                                };

    integer RrAg_MEM_latch_size; 
    RrAg_MEM_latch_size = 1759;

    rrag r1 (
        //inputs
        .valid_in(), .reg_addr1(), .reg_addr2(), .reg_addr3(), .reg_addr4(), .seg_addr1(), .seg_addr2(), .seg_addr3(), .seg_addr4(),
        .opsize_in(), .addressingmode(), .op1_in(), .op2_in(), .op3_in(), .op4_in(),
        .res1_ld_in(), .res2_ld_in(), .res3_ld_in(), .res4_ld_in(),
        .dest1_in(), .dest2_in(), .dest3_in(), .dest4_in(),
        .disp(), .reg3_shfamnt(), .usereg2(), .usereg3(), .rep(),
        .clr(), .clk(),
        .lim_init5(), .lim_init4(), .lim_init3(), .lim_init2(), .lim_init1(), .lim_init0(),
        .aluk_in(), .mux_adder_in(), .mux_and_int_in(), .mux_shift_in(),
        .p_op_in(), .fmask_in(), .conditionals_in(), .is_br_in(), .is_fp_in(),
        .imm_in(), .mem1_rw_in(), .mem2_rw_in(), .eip_in(), .IE_in(), .IE_type_in(),
        .BR_pred_target_in(), .BR_pred_T_NT_in(),
        .wb_data1(), .wb_data2(), .wb_data3(), .wb_data4(),
        .wb_segdata1(), .wb_segdata2(), .wb_segdata3(), .wb_segdata4(),
        .wb_addr1(), .wb_addr2(), .wb_addr3(), .wb_addr4(),
        .wb_segaddr1(), .wb_segaddr2(), .wb_segaddr3(), .wb_segaddr4(),
        .wb_opsize(), .wb_regld(), .wb_segld(), .wb_inst_ptcid(),
        .fwd_stall(),

        //outputs
        .valid_out(valid_RrAg_MEM_latch_in), .stall(stall_RrAg_MEM_latch_in), .opsize_out(opsize_RrAg_MEM_latch_in),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_in), .mem_addr2(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_in),
        .reg1(reg1_RrAg_MEM_latch_in), .reg2(reg2_RrAg_MEM_latch_in), .reg3(reg3_RrAg_MEM_latch_in), .reg4(reg4_RrAg_MEM_latch_in),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_in), .ptc_r2(ptc_r2_RrAg_MEM_latch_in), .ptc_r3(ptc_r3_RrAg_MEM_latch_in), .ptc_r4(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_in), .reg2_orig(reg2_orig_RrAg_MEM_latch_in), .reg3_orig(reg3_orig_RrAg_MEM_latch_in), .reg4_orig(reg4_orig_RrAg_MEM_latch_in),
        .seg1(seg1_RrAg_MEM_latch_in), .seg2(seg2_RrAg_MEM_latch_in), .seg3(seg3_RrAg_MEM_latch_in), .seg4(seg4_RrAg_MEM_latch_in),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_in), .ptc_s2(ptc_s2_RrAg_MEM_latch_in), .ptc_s3(ptc_s3_RrAg_MEM_latch_in), .ptc_s4(ptc_s4_RrAg_MEM_latch_in),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_in), .seg2_orig(seg2_orig_RrAg_MEM_latch_in), .seg3_orig(seg3_orig_RrAg_MEM_latch_in), .seg4_orig(seg4_orig_RrAg_MEM_latch_in),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_in),
        .op1_out(op1_out_RrAg_MEM_latch_in), .op2_out(op2_out_RrAg_MEM_latch_in), .op3_out(op3_out_RrAg_MEM_latch_in), .op4_out(op4_out_RrAg_MEM_latch_in),
        .dest1_out(dest1_out_RrAg_MEM_latch_in), .dest2_out(dest2_out_RrAg_MEM_latch_in), .dest3_out(dest3_out_RrAg_MEM_latch_in), .dest4_out(dest4_out_RrAg_MEM_latch_in),
        .res1_ld_out(res1_ld_out_RrAg_MEM_latch_in), .res2_ld_out(res2_ld_out_RrAg_MEM_latch_in), 
        .res3_ld_out(res3_ld_out_RrAg_MEM_latch_in), .res4_ld_out(res4_ld_out_RrAg_MEM_latch_in),
        .rep_num(rep_num_RrAg_MEM_latch_in),
        .aluk_out(aluk_out_RrAg_MEM_latch_in),
        .mux_adder_out(mux_adder_out_RrAg_MEM_latch_in),
        .mux_and_int_out(mux_and_int_out_RrAg_MEM_latch_in), .mux_shift_out(mux_shift_out_RrAg_MEM_latch_in),
        .p_op_out(p_op_out_RrAg_MEM_latch_in),
        .fmask_out(fmask_out_RrAg_MEM_latch_in),
        .conditionals_out(conditionals_out_RrAg_MEM_latch_in),
        .is_br_out(is_br_out_RrAg_MEM_latch_in), .is_fp_out(is_fp_out_RrAg_MEM_latch_in),
        .imm_out(imm_out_RrAg_MEM_latch_in),
        .mem1_rw_out(mem1_rw_out_RrAg_MEM_latch_in), .mem2_rw_out(mem2_rw_out_RrAg_MEM_latch_in),
        .eip_out(eip_out_RrAg_MEM_latch_in),
        .IE_out(IE_out_RrAg_MEM_latch_in),
        .IE_type_out(IE_type_out_RrAg_MEM_latch_in),
        .BR_pred_target_out(BR_pred_target_out_RrAg_MEM_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_out_RrAg_MEM_latch_in)
    );


    regn (.WIDTH(RrAg_MEM_latch_size)) (
          .din(all_RrAg_MEM_latch_in),
          .ld(),
          .clr(),
          .clk(clk),
          .dout(all_RrAg_MEM_latch_out)
          );

    mem m1 (
        .valid_in(valid_RrAg_MEM_latch_out),
        .opsize_in(opsize_RrAg_MEM_latch_out),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_out),
        .mem_addr2(mem_addr2_RrAg_MEM_latch_out),
        .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_out),
        .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_out),
        .reg1(reg1_RrAg_MEM_latch_out),
        .reg2(reg2_RrAg_MEM_latch_out),
        .reg3(reg3_RrAg_MEM_latch_out),
        .reg4(reg4_RrAg_MEM_latch_out),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_out),
        .ptc_r2(ptc_r2_RrAg_MEM_latch_out),
        .ptc_r3(ptc_r3_RrAg_MEM_latch_out),
        .ptc_r4(ptc_r4_RrAg_MEM_latch_out),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_out),
        .reg2_orig(reg2_orig_RrAg_MEM_latch_out),
        .reg3_orig(reg3_orig_RrAg_MEM_latch_out),
        .reg4_orig(reg4_orig_RrAg_MEM_latch_out),
        .seg1(seg1_RrAg_MEM_latch_out),
        .seg2(seg2_RrAg_MEM_latch_out),
        .seg3(seg3_RrAg_MEM_latch_out),
        .seg4(seg4_RrAg_MEM_latch_out),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_out),
        .ptc_s2(ptc_s2_RrAg_MEM_latch_out),
        .ptc_s3(ptc_s3_RrAg_MEM_latch_out),
        .ptc_s4(ptc_s4_RrAg_MEM_latch_out),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_out),
        .seg2_orig(seg2_orig_RrAg_MEM_latch_out),
        .seg3_orig(seg3_orig_RrAg_MEM_latch_out),
        .seg4_orig(seg4_orig_RrAg_MEM_latch_out),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_out),
        .op1_sel(op1_RrAg_MEM_latch_out),
        .op2_sel(op2_RrAg_MEM_latch_out),
        .op3_sel(op3_RrAg_MEM_latch_out),
        .op4_sel(op4_RrAg_MEM_latch_out),
        .dest1_sel(dest1_RrAg_MEM_latch_out),
        .dest2_sel(dest2_RrAg_MEM_latch_out),
        .dest3_sel(dest3_RrAg_MEM_latch_out),
        .dest4_sel(dest4_RrAg_MEM_latch_out),
        .res1_ld_in(res1_ld_out_RrAg_MEM_latch_out), .res2_ld_in(res2_ld_out_RrAg_MEM_latch_out),
        .res3_ld_in(res3_ld_out_RrAg_MEM_latch_out), .res4_ld_in(res4_ld_out_RrAg_MEM_latch_out),
        .rep_num(rep_num_RrAg_MEM_latch_out),
        .VP_in(), .PF_in(),
        .entry_v_in(), .entry_P_in(), .entry_RW_in(),
        .aluk_in(aluk_RrAg_MEM_latch_out), .mux_adder_in(mux_adder_RrAg_MEM_latch_out), 
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_out), .mux_shift_in(mux_shift_RrAg_MEM_latch_out),
        .p_op_in(p_op_RrAg_MEM_latch_out), .fmask_in(fmask_RrAg_MEM_latch_out), 
        .conditionals_in(conditionals_RrAg_MEM_latch_out), .is_br_in(is_br_RrAg_MEM_latch_out), 
        .is_fp_in(is_fp_RrAg_MEM_latch_out),
        .imm(imm_RrAg_MEM_latch_out), .mem1_rw(mem1_rw_RrAg_MEM_latch_out), .mem2_rw(mem2_rw_RrAg_MEM_latch_out),
        .eip_in(eip_RrAg_MEM_latch_out), .IE_in(IE_RrAg_MEM_latch_out), .IE_type_in(IE_type_RrAg_MEM_latch_out),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_out),
        .clr(), .clk(clk), //TODO
        //outputs
        .valid_out(),
        .eip_out(), .IE_out(), .IE_type_out(), .BR_pred_target_out(), .BR_pred_T_NT_out(),
        .op1_val(), .op2_val(), .op3_val(), .op4_val(),
        .op1_ptcinfo(), .op2_ptcinfo(), .op3_ptcinfo(), .op4_ptcinfo(),
        .dest1_addr(), .dest2_addr(), .dest3_addr(), .dest4_addr(),
        .dest1_is_reg(), .dest2_is_reg(), .dest3_is_reg(), .dest4_is_reg(),
        .dest1_is_seg(), .dest2_is_seg(), .dest3_is_seg(), .dest4_is_seg(),
        .dest1_is_mem(), .dest2_is_mem(), .dest3_is_mem(), .dest4_is_mem(),
        .res1_ld_out(), .res2_ld_out(), .res3_ld_out(), .res4_ld_out(),
        .aluk_out(), .mux_adder_out(), .mux_and_int_out(), .mux_shift_out(),
        .p_op_out(), .fmask_out(), .conditionals_out(), .is_br_out(), .is_fp_out()
    );
        
        

    
    ///////////////////////////////////////////////////////////
    //     Outputs from EX that go into EX_WB_latch:        //  
    //////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_in;
    wire [31:0] EIP_EX_WB_latch_in;
    wire IE_EX_WB_latch_in;
    wire [3:0] IE_type_EX_WB_latch_in;
    wire [31:0] BR_pred_target_EX_WB_latch_in;
    wire BR_pred_T_NT_EX_WB_latch_in;

    wire [17:0] eflags_EX_WB_latch_in;
    wire [15:0] CS_EX_WB_latch_in;

    wire res1_wb_EX_WB_latch_in;
    wire [63:0] res1_EX_WB_latch_in;
    wire res1_is_reg_EX_WB_latch_in;
    wire [31:0] res1_dest_EX_WB_latch_in;
    wire [1:0] res1_size_EX_WB_latch_in;

    wire res2_wb_EX_WB_latch_in;
    wire [63:0] res2_EX_WB_latch_in;
    wire res2_is_reg_EX_WB_latch_in;
    wire [31:0] res2_dest_EX_WB_latch_in;
    wire [1:0] res2_size_EX_WB_latch_in;

    wire res3_wb_EX_WB_latch_in;
    wire [63:0] res3_EX_WB_latch_in;
    wire res3_is_reg_EX_WB_latch_in;
    wire [31:0] res3_dest_EX_WB_latch_in;
    wire [1:0] res3_size_EX_WB_latch_in;

    wire res4_wb_EX_WB_latch_in;
    wire [63:0] res4_EX_WB_latch_in;
    wire res4_is_reg_EX_WB_latch_in;
    wire [31:0] res4_dest_EX_WB_latch_in;
    wire [1:0] res4_size_EX_WB_latch_in;

    wire load_eip_in_res1_EX_WB_latch_in,
        load_segReg_in_res1_EX_WB_latch_in,
        load_eip_in_res2_EX_WB_latch_in,
        load_segReg_in_res2_EX_WB_latch_in;

    wire BR_valid_EX_WB_latch_in,
        BR_taken_EX_WB_latch_in,
        BR_correct_EX_WB_latch_in;
    wire [31:0] BR_FIP_EX_WB_latch_in,
                BR_FIP_p1_EX_WB_latch_in;


//////////////////////////////////////////////////////////
//    Outputs from EX_WB_latch that go into WB:         //  
//////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_out;
    wire [31:0] EIP_EX_WB_latch_out;
    wire IE_EX_WB_latch_out;
    wire [3:0] IE_type_EX_WB_latch_out;
    wire [31:0] BR_pred_target_EX_WB_latch_out;
    wire BR_pred_T_NT_EX_WB_latch_out;

    wire [17:0] eflags_EX_WB_latch_out;
    wire [15:0] CS_EX_WB_latch_out;

    wire res1_wb_EX_WB_latch_out;
    wire [63:0] res1_EX_WB_latch_out;
    wire res1_is_reg_EX_WB_latch_out;
    wire [31:0] res1_dest_EX_WB_latch_out;
    wire [1:0] res1_size_EX_WB_latch_out;

    wire res2_wb_EX_WB_latch_out;
    wire [63:0] res2_EX_WB_latch_out;
    wire res2_is_reg_EX_WB_latch_out;
    wire [31:0] res2_dest_EX_WB_latch_out;
    wire [1:0] res2_size_EX_WB_latch_out;

    wire res3_wb_EX_WB_latch_out;
    wire [63:0] res3_EX_WB_latch_out;
    wire res3_is_reg_EX_WB_latch_out;
    wire [31:0] res3_dest_EX_WB_latch_out;
    wire [1:0] res3_size_EX_WB_latch_out;

    wire res4_wb_EX_WB_latch_out;
    wire [63:0] res4_EX_WB_latch_out;
    wire res4_is_reg_EX_WB_latch_out;
    wire [31:0] res4_dest_EX_WB_latch_out;
    wire [1:0] res4_size_EX_WB_latch_out;

    wire load_eip_in_res1_EX_WB_latch_out,
         load_segReg_in_res1_EX_WB_latch_out,
         load_eip_in_res2_EX_WB_latch_out,
         load_segReg_in_res2_EX_WB_latch_out;

    wire BR_valid_EX_WB_latch_out,
         BR_taken_EX_WB_latch_out,
         BR_correct_EX_WB_latch_out;
    wire [31:0] BR_FIP_EX_WB_latch_out,
                BR_FIP_p1_EX_WB_latch_out;

    execute_TOP ex(
        //inputs:
        .clk(clk),
        .valid_in(),
        .EIP_in(),
        .IE_in(),
        .IE_type_in(),
        .BR_pred_target_in(),
        .BR_pred_T_NT_in(),
        .set(),
        .rst(),

        .op1_wb(),
        .op1(),
        .op1_is_reg(),
        .op1_orig(),
        .op1_size(),

        .op2_wb(),
        .op2(),
        .op2_is_reg(),
        .op2_orig(),
        .op2_size(),

        .op3_wb(),
        .op3(),
        .op3_is_reg(),
        .op3_orig(),
        .op3_size(),

        .op4_wb(),
        .op4(),
        .op4_is_reg(),
        .op4_orig(),
        .op4_size(),

        .aluk(),
        .MUX_ADDER_IMM(),
        .MUX_AND_INT(),
        .MUX_SHIFT(),
        .P_OP(),
        .load_eip_in_op1(),
        .load_segReg_in_op1(),
        .load_eip_in_op2(),
        .load_segReg_in_op2(),
        .FMASK(),
        .conditionals(),

        .isBR(),
        .is_fp(),
        .CS(),

        //outputs:
        .valid_out(valid_EX_WB_latch_in),
        .EIP_out(EIP_EX_WB_latch_in),
        .IE_out(IE_EX_WB_latch_in),
        .IE_type_out(IE_type_EX_WB_latch_in),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_in),

        .eflags(eflags_EX_WB_latch_in),
        .CS_out(CS_EX_WB_latch_in),

        .res1_wb(res1_wb_EX_WB_latch_in),
        .res1(res1_EX_WB_latch_in),
        .res1_is_reg(res1_is_reg_EX_WB_latch_in),
        .res1_dest(res1_dest_EX_WB_latch_in),
        .res1_size(res1_size_EX_WB_latch_in),

        .res2_wb(res2_wb_EX_WB_latch_in),
        .res2(res2_EX_WB_latch_in),
        .res2_is_reg(res2_is_reg_EX_WB_latch_in),
        .res2_dest(res2_dest_EX_WB_latch_in),
        .res2_size(res2_size_EX_WB_latch_in),

        .res3_wb(res3_wb_EX_WB_latch_in),
        .res3(res3_EX_WB_latch_in),
        .res3_is_reg(res3_is_reg_EX_WB_latch_in),
        .res3_dest(res3_dest_EX_WB_latch_in),
        .res3_size(res3_size_EX_WB_latch_in),

        .res4_wb(res4_wb_EX_WB_latch_in),
        .res4(res4_EX_WB_latch_in),
        .res4_is_reg(res4_is_reg_EX_WB_latch_in),
        .res4_dest(res4_dest_EX_WB_latch_in),
        .res4_size(res4_size_EX_WB_latch_in),

        .load_eip_in_res1(load_eip_in_res1_EX_WB_latch_in),
        .load_segReg_in_res1(load_segReg_in_res1_EX_WB_latch_in),
        .load_eip_in_res2(load_eip_in_res2_EX_WB_latch_in),
        .load_segReg_in_res2(load_segReg_in_res2_EX_WB_latch_in),

        .BR_valid(BR_valid_EX_WB_latch_in), 
        .BR_taken(BR_taken_EX_WB_latch_in), 
        .BR_correct(BR_correct_EX_WB_latch_in), 
        .BR_FIP(BR_FIP_EX_WB_latch_in), 
        .BR_FIP_p1(BR_FIP_p1_EX_WB_latch_in)
    );

    integer EX_WB_latch_size; 
    EX_WB_latch_size = 461;

    regn (.WIDTH(EX_WB_latch_size)) (
    .din({
        valid_EX_WB_latch_in, EIP_EX_WB_latch_in, IE_EX_WB_latch_in, IE_type_EX_WB_latch_in,
        BR_pred_target_EX_WB_latch_in, BR_pred_T_NT_EX_WB_latch_in, eflags_EX_WB_latch_in, CS_EX_WB_latch_in,

        res1_wb_EX_WB_latch_in, res1_EX_WB_latch_in, res1_is_reg_EX_WB_latch_in, res1_dest_EX_WB_latch_in, res1_size_EX_WB_latch_in, 
        res2_wb_EX_WB_latch_in, res2_EX_WB_latch_in, res2_is_reg_EX_WB_latch_in, res2_dest_EX_WB_latch_in, res2_size_EX_WB_latch_in, 
        res3_wb_EX_WB_latch_in, res3_EX_WB_latch_in, res3_is_reg_EX_WB_latch_in, res3_dest_EX_WB_latch_in, res3_size_EX_WB_latch_in, 
        res4_wb_EX_WB_latch_in, res4_EX_WB_latch_in, res4_is_reg_EX_WB_latch_in, res4_dest_EX_WB_latch_in, res4_size_EX_WB_latch_in,
        
        load_eip_in_res1_EX_WB_latch_in, load_segReg_in_res1_EX_WB_latch_in, 
        load_eip_in_res2_EX_WB_latch_in, load_segReg_in_res2_EX_WB_latch_in, 
        BR_valid_EX_WB_latch_in, BR_taken_EX_WB_latch_in, BR_correct_EX_WB_latch_in, BR_FIP_EX_WB_latch_in, BR_FIP_p1_EX_WB_latch_in
        }),
    .ld(),
    .clr(),
    .clk(clk),
    .dout({
        valid_EX_WB_latch_out, EIP_EX_WB_latch_out, IE_EX_WB_latch_out, IE_type_EX_WB_latch_out,
        BR_pred_target_EX_WB_latch_out, BR_pred_T_NT_EX_WB_latch_out, eflags_EX_WB_latch_out, CS_EX_WB_latch_out,

        res1_wb_EX_WB_latch_out, res1_EX_WB_latch_out, res1_is_reg_EX_WB_latch_out, res1_dest_EX_WB_latch_out, res1_size_EX_WB_latch_out, 
        res2_wb_EX_WB_latch_out, res2_EX_WB_latch_out, res2_is_reg_EX_WB_latch_out, res2_dest_EX_WB_latch_out, res2_size_EX_WB_latch_out, 
        res3_wb_EX_WB_latch_out, res3_EX_WB_latch_out, res3_is_reg_EX_WB_latch_out, res3_dest_EX_WB_latch_out, res3_size_EX_WB_latch_out, 
        res4_wb_EX_WB_latch_out, res4_EX_WB_latch_out, res4_is_reg_EX_WB_latch_out, res4_dest_EX_WB_latch_out, res4_size_EX_WB_latch_out,
        
        load_eip_in_res1_EX_WB_latch_out, load_segReg_in_res1_EX_WB_latch_out, 
        load_eip_in_res2_EX_WB_latch_out, load_segReg_in_res2_EX_WB_latch_out, 
        BR_valid_EX_WB_latch_out, BR_taken_EX_WB_latch_out, BR_correct_EX_WB_latch_out, BR_FIP_EX_WB_latch_out, BR_FIP_p1_EX_WB_latch_out
    })
);

writeback_TOP wb(
    //inputs:
    .clk(clk),
    .valid_in(valid_EX_WB_latch_out),
    .EIP_in(EIP_EX_WB_latch_out),
    .IE_in(IE_EX_WB_latch_out),
    .IE_type_in(IE_type_EX_WB_latch_out),
    .BR_pred_target_in(BR_pred_target_EX_WB_latch_out),
    .BR_pred_T_NT_in(BR_pred_T_NT_EX_WB_latch_out),
    .set(), .rst(),
    .inp1(res1_EX_WB_latch_out), .inp2(res2_EX_WB_latch_out), .inp3(res3_EX_WB_latch_out), .inp4(res4_EX_WB_latch_out),
    .inp1_isReg(res1_is_reg_EX_WB_latch_out), .inp2_isReg(res2_is_reg_EX_WB_latch_out), .inp3_isReg(res3_is_reg_EX_WB_latch_out), .inp4_isReg(res4_is_reg_EX_WB_latch_out),
    .inp1_dest(res1_dest_EX_WB_latch_out), .inp2_dest(res2_dest_EX_WB_latch_out), .inp3_dest(res3_dest_EX_WB_latch_out), .inp4_dest(res4_dest_EX_WB_latch_out),
    .inp1_size(res1_size_EX_WB_latch_out), .inp2_size(res2_size_EX_WB_latch_out), .inp3_size(res3_size_EX_WB_latch_out), .inp4_size(res4_size_EX_WB_latch_out),
    .inp1_isPTC(), .inp2_isPTC(), .inp3_isPTC(), .inp4_isPTC(),
    .inp1_PTC(), .inp2_PTC(), .inp3_PTC(), .inp4_PTC(),
    .inp1_wb(res1_wb_EX_WB_latch_out), .inp2_wb(res2_wb_EX_WB_latch_out), .inp3_wb(res3_wb_EX_WB_latch_out), .inp4_wb(res4_wb_EX_WB_latch_out),
    .P_OP(),

    .load_eip_in_res1(load_eip_in_res1_EX_WB_latch_out),
    .load_segReg_in_res1(load_segReg_in_res1_EX_WB_latch_out),
    .load_eip_in_res2(load_eip_in_res2_EX_WB_latch_out),
    .load_segReg_in_res2(load_segReg_in_res2_EX_WB_latch_out),

    .BR_valid_in(BR_valid_EX_WB_latch_out),
    .BR_taken_in(BR_taken_EX_WB_latch_out),
    .BR_correct_in(BR_correct_EX_WB_latch_out),
    .BR_FIP_in(BR_FIP_EX_WB_latch_out),
    .BR_FIP_p1_in(BR_FIP_p1_EX_WB_latch_out),
    .CS_in(CS_EX_WB_latch_out),
    .EFLAGS_in(eflags_EX_WB_latch_out),

    .interrupt_in(), //from IO device

    //outputs:
    .valid_out(),
    .res1(), .res2(), .res3(), .res4(),
    .res1_reg_w(), .res2_reg_w(), .res3_reg_w(), .res4_reg_w(),
    .res1_dest(), .res2_dest(), .res3_dest(), .res4_dest(),
    .res1_size(), .res2_size(), .res3_size(), .res4_size(),
    .res1_isPTC(), .res2_isPTC(), .res3_isPTC(), .res4_isPTC(),
    .res1_PTC(),
    .LD_EIP_CS(),
    .LD_EIP(),

    .mem_adr(),
    .mem_w(),
    .mem_data(),
    .mem_size(),

    .FIP_e(), .FIP_o(), .EIP(), //to fetch
    .BR_valid(), .BR_taken(), .BR_correct(), //to update BP
    .CS(), //for IE servicing
    .segReg1(),
    .segReg2(),

    .load_segReg1(),
    .load_segReg2(),

    .final_IE_val(),
    .final_IE_type()
    );

endmodule
