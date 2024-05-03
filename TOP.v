module TOP();
    localparam CYCLE_TIME = 12.0;
    
    integer file;
    reg clk;
    
    initial begin
        file = $fopen("debug.out", "w");
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    //TODO: TLB Initializations
    reg [19:0] VP_0, VP_1, VP_2, VP_3, VP_4, VP_5, VP_6, VP_7;
	reg [19:0] PF_0, PF_1, PF_2, PF_3, PF_4, PF_5, PF_6, PF_7;
	reg [7:0] entry_v;
	reg [7:0] entry_P;
	reg [7:0] entry_RW;
    reg [7:0] entry_PCD;
	reg [159:0] VP, PF; //concats of VP_7 to VP_0 and PF_7 to PF_0

    //TODO: Core initializations:
    reg reset;

    //Pipeline: FETCH1 -> FETCH2 -> DECODE -> RrAg -> MEM -> EX -> WB

    //  IMPORTANT NOTES:
    //   -  notation for latche wires: <signal.name>_<stage.prev>_<stage.next>_latch_<in/out>
    //      where <in> is the input to the latch (output of stage.prev) and <out> is the output 
    //      from the latch (input of stage.next)

    ///////////////////////////////////////////////////////////
    // Outputs from Rr/Ag that go into the RrAg_MEM_latch:  //  
    //////////////////////////////////////////////////////////
    
    wire         valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in;
    wire [1:0]   opsize_RrAg_MEM_latch_in;
    wire [31:0]  mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in;
    wire [63:0]  reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in;
    wire [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in;
    wire [2:0]   reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in;
    wire [15:0]  seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in;
    wire [31:0]  ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in;
    wire [2:0]   seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in;
    wire [6:0]   inst_ptcid_RrAg_MEM_latch_in;
    wire [12:0]  op1_out_RrAg_MEM_latch_in, op2_out_RrAg_MEM_latch_in, op3_out_RrAg_MEM_latch_in, op4_out_RrAg_MEM_latch_in;
    wire [12:0]  dest1_out_RrAg_MEM_latch_in, dest2_out_RrAg_MEM_latch_in, dest3_out_RrAg_MEM_latch_in, dest4_out_RrAg_MEM_latch_in;
    wire         res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in;
    wire [31:0]  rep_num_RrAg_MEM_latch_in;
    wire [4:0]   aluk_out_RrAg_MEM_latch_in;
    wire [2:0]   mux_adder_out_RrAg_MEM_latch_in;
    wire         mux_and_int_out_RrAg_MEM_latch_in, mux_shift_out_RrAg_MEM_latch_in;
    wire [36:0]  p_op_out_RrAg_MEM_latch_in;
    wire [17:0]  fmask_out_RrAg_MEM_latch_in;
    wire [1:0]   conditionals_out_RrAg_MEM_latch_in;
    wire         is_br_out_RrAg_MEM_latch_in, is_fp_out_RrAg_MEM_latch_in;
    wire [47:0]  imm_out_RrAg_MEM_latch_in;
    wire [1:0]   mem1_rw_out_RrAg_MEM_latch_in, mem2_rw_out_RrAg_MEM_latch_in;
    wire [31:0]  eip_out_RrAg_MEM_latch_in;
    wire         IE_out_RrAg_MEM_latch_in;
    wire [3:0]   IE_type_out_RrAg_MEM_latch_in;
    wire [31:0]  BR_pred_target_out_RrAg_MEM_latch_in;
    wire         BR_pred_T_NT_out_RrAg_MEM_latch_in;
    
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
    wire [15:0]  CS_out_RrAg_MEM_latch_out;
    wire [1:0] conditionals_RrAg_MEM_latch_out;
    wire is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out;
    wire [47:0] imm_RrAg_MEM_latch_out;
    wire [1:0] mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out;
    wire [31:0] eip_RrAg_MEM_latch_out;
    wire IE_RrAg_MEM_latch_out;
    wire [3:0] IE_type_RrAg_MEM_latch_out;
    wire [31:0] BR_pred_target_RrAg_MEM_latch_out;
    wire BR_pred_T_NT_RrAg_MEM_latch_out;
    
    // integer RrAg_MEM_latch_size;  RrAg_MEM_latch_size = 1759;
    // wire [RrAg_MEM_latch_size - 1 : 0] all_RrAg_MEM_latch_out;
    // wire [RrAg_MEM_latch_size - 1 : 0] all_RrAg_MEM_latch_in;

    // assign all_RrAg_MEM_latch_out = {valid_RrAg_MEM_latch_out, stall_RrAg_MEM_latch_out, opsize_RrAg_MEM_latch_out,
    //                               mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out,
    //                               reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out,
    //                               ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out,
    //                               reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out,
    //                               seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out,
    //                               ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out,
    //                               seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out,
    //                               inst_ptcid_RrAg_MEM_latch_out,
    //                               op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out,
    //                               dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out,
    //                               res1_ld_out_RrAg_MEM_latch_out, res2_ld_out_RrAg_MEM_latch_out, res3_ld_out_RrAg_MEM_latch_out, res4_ld_out_RrAg_MEM_latch_out,
    //                               rep_num_RrAg_MEM_latch_out,
    //                               aluk_RrAg_MEM_latch_out,
    //                               mux_adder_RrAg_MEM_latch_out,
    //                               mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out,
    //                               p_op_RrAg_MEM_latch_out,
    //                               fmask_RrAg_MEM_latch_out,
    //                               conditionals_RrAg_MEM_latch_out,
    //                               is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out,
    //                               imm_RrAg_MEM_latch_out,
    //                               mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out,
    //                               eip_RrAg_MEM_latch_out,
    //                               IE_RrAg_MEM_latch_out,
    //                               IE_type_RrAg_MEM_latch_out,
    //                               BR_pred_target_RrAg_MEM_latch_out,
    //                               BR_pred_T_NT_RrAg_MEM_latch_out};

    // assign all_RrAg_MEM_latch_in = {valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in, opsize_RrAg_MEM_latch_in,
    //                              mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in,
    //                              reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in,
    //                              ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in,
    //                              reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in,
    //                              seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in,
    //                              ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in,
    //                              seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in,
    //                              inst_ptcid_RrAg_MEM_latch_in,
    //                              op1_RrAg_MEM_latch_in, op2_RrAg_MEM_latch_in, op3_RrAg_MEM_latch_in, op4_RrAg_MEM_latch_in,
    //                              dest1_RrAg_MEM_latch_in, dest2_RrAg_MEM_latch_in, dest3_RrAg_MEM_latch_in, dest4_RrAg_MEM_latch_in,
    //                              res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in,
    //                              rep_num_RrAg_MEM_latch_in,
    //                              aluk_RrAg_MEM_latch_in,
    //                              mux_adder_RrAg_MEM_latch_in,
    //                              mux_and_int_RrAg_MEM_latch_in, mux_shift_RrAg_MEM_latch_in,
    //                              p_op_RrAg_MEM_latch_in,
    //                              fmask_RrAg_MEM_latch_in,
    //                              conditionals_RrAg_MEM_latch_in,
    //                              is_br_RrAg_MEM_latch_in, is_fp_RrAg_MEM_latch_in,
    //                              imm_RrAg_MEM_latch_in,
    //                              mem1_rw_RrAg_MEM_latch_in, mem2_rw_RrAg_MEM_latch_in,
    //                              eip_RrAg_MEM_latch_in,
    //                              IE_RrAg_MEM_latch_in,
    //                              IE_type_RrAg_MEM_latch_in,
    //                              BR_pred_target_RrAg_MEM_latch_in,
    //                              BR_pred_T_NT_RrAg_MEM_latch_in
    //                             };

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

    RrAg_MEM_latch (
        //inputs
        .valid_in(valid_RrAg_MEM_latch_in), .stall(stall_RrAg_MEM_latch_in), .opsize_in(opsize_RrAg_MEM_latch_in),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_in), .mem_addr2(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_in),
        .reg1(reg1_RrAg_MEM_latch_in), .reg2(reg2_RrAg_MEM_latch_in), .reg3(reg3_RrAg_MEM_latch_in), .reg4(reg4_RrAg_MEM_latch_in),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_in), .ptc_r2(ptc_r2_RrAg_MEM_latch_in), .ptc_r3(ptc_r3_RrAg_MEM_latch_in), .ptc_r4(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_in), .reg2_orig(reg2_orig_RrAg_MEM_latch_in), .reg3_orig(reg3_orig_RrAg_MEM_latch_in), .reg4_orig(reg4_orig_RrAg_MEM_latch_in),
        .seg1(seg1_RrAg_MEM_latch_in), .seg2(seg2_RrAg_MEM_latch_in), .seg3(seg3_RrAg_MEM_latch_in), .seg4(seg4_RrAg_MEM_latch_in),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_in), .ptc_s2(ptc_s2_RrAg_MEM_latch_in), .ptc_s3(ptc_s3_RrAg_MEM_latch_in), .ptc_s4(ptc_s4_RrAg_MEM_latch_in),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_in), .seg2_orig(seg2_orig_RrAg_MEM_latch_in), .seg3_orig(seg3_orig_RrAg_MEM_latch_in), .seg4_orig(seg4_orig_RrAg_MEM_latch_in),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_in),
        .op1_sel(op1_out_RrAg_MEM_latch_in), .op2_sel(op2_out_RrAg_MEM_latch_in), .op3_sel(op3_out_RrAg_MEM_latch_in), .op4_sel(op4_out_RrAg_MEM_latch_in),
        .dest1_sel(dest1_out_RrAg_MEM_latch_in), .dest2_sel(dest2_out_RrAg_MEM_latch_in), .dest3_sel(dest3_out_RrAg_MEM_latch_in), .dest4_sel(dest4_out_RrAg_MEM_latch_in),
        .res1_ld_in(res1_ld_out_RrAg_MEM_latch_in), .res2_ld_in(res2_ld_out_RrAg_MEM_latch_in),
        .res3_ld_in(res3_ld_out_RrAg_MEM_latch_in), .res4_ld_in(res4_ld_out_RrAg_MEM_latch_in),
        .rep_num(rep_num_RrAg_MEM_latch_in),
        .aluk_in(aluk_out_RrAg_MEM_latch_in), .mux_adder_in(mux_adder_out_RrAg_MEM_latch_in),
        .mux_and_int_in(mux_and_int_out_RrAg_MEM_latch_in), .mux_shift_in(mux_shift_out_RrAg_MEM_latch_in),
        .p_op_in(p_op_out_RrAg_MEM_latch_in), .fmask_in(fmask_out_RrAg_MEM_latch_in),
        .conditionals_in(conditionals_out_RrAg_MEM_latch_in), .is_br_in(is_br_out_RrAg_MEM_latch_in),
        .is_fp_in(is_fp_out_RrAg_MEM_latch_in),
        .imm(imm_out_RrAg_MEM_latch_in), .mem1_rw(mem1_rw_out_RrAg_MEM_latch_in), .mem2_rw(mem2_rw_out_RrAg_MEM_latch_in),
        .eip_in(eip_out_RrAg_MEM_latch_in), .IE_in(IE_out_RrAg_MEM_latch_in), .IE_type_in(IE_type_out_RrAg_MEM_latch_in),
        .BR_pred_target_in(BR_pred_target_out_RrAg_MEM_latch_in), .BR_pred_T_NT_in(BR_pred_T_NT_out_RrAg_MEM_latch_in),
        .clk(clk),
        //outputs

        .valid_out(valid_RrAg_MEM_latch_out), .stall(stall_RrAg_MEM_latch_out), .opsize_out(opsize_RrAg_MEM_latch_out),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_out), .mem_addr2(mem_addr2_RrAg_MEM_latch_out), .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_out), .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_out),
        .reg1(reg1_RrAg_MEM_latch_out), .reg2(reg2_RrAg_MEM_latch_out), .reg3(reg3_RrAg_MEM_latch_out), .reg4(reg4_RrAg_MEM_latch_out),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_out), .ptc_r2(ptc_r2_RrAg_MEM_latch_out), .ptc_r3(ptc_r3_RrAg_MEM_latch_out), .ptc_r4(ptc_r4_RrAg_MEM_latch_out),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_out), .reg2_orig(reg2_orig_RrAg_MEM_latch_out), .reg3_orig(reg3_orig_RrAg_MEM_latch_out), .reg4_orig(reg4_orig_RrAg_MEM_latch_out),
        .seg1(seg1_RrAg_MEM_latch_out), .seg2(seg2_RrAg_MEM_latch_out), .seg3(seg3_RrAg_MEM_latch_out), .seg4(seg4_RrAg_MEM_latch_out),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_out), .ptc_s2(ptc_s2_RrAg_MEM_latch_out), .ptc_s3(ptc_s3_RrAg_MEM_latch_out), .ptc_s4(ptc_s4_RrAg_MEM_latch_out),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_out), .seg2_orig(seg2_orig_RrAg_MEM_latch_out), .seg3_orig(seg3_orig_RrAg_MEM_latch_out), .seg4_orig(seg4_orig_RrAg_MEM_latch_out),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_out),
        .op1_sel(op1_RrAg_MEM_latch_out), .op2_sel(op2_RrAg_MEM_latch_out), .op3_sel(op3_RrAg_MEM_latch_out), .op4_sel(op4_RrAg_MEM_latch_out),
        .dest1_sel(dest1_RrAg_MEM_latch_out), .dest2_sel(dest2_RrAg_MEM_latch_out), .dest3_sel(dest3_RrAg_MEM_latch_out), .dest4_sel(dest4_RrAg_MEM_latch_out),
        .res1_ld_in(res1_ld_out_RrAg_MEM_latch_out), .res2_ld_in(res2_ld_out_RrAg_MEM_latch_out),
        .res3_ld_in(res3_ld_out_RrAg_MEM_latch_out), .res4_ld_in(res4_ld_out_RrAg_MEM_latch_out),
        .rep_num(rep_num_RrAg_MEM_latch_out),
        .aluk_in(aluk_RrAg_MEM_latch_out), .mux_adder_in(mux_adder_RrAg_MEM_latch_out),
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_out), .mux_shift_in(mux_shift_RrAg_MEM_latch_out),
        .p_op_in(p_op_RrAg_MEM_latch_out), .fmask_in(fmask_RrAg_MEM_latch_out),
        .conditionals_in(conditionals_RrAg_MEM_latch_out), .is_br_in(is_br_RrAg_MEM_latch_out),
        .is_fp_in(is_fp_RrAg_MEM_latch_out),
        .imm(imm_RrAg_MEM_latch_out), .mem1_rw(mem1_rw_RrAg_MEM_latch_out), .mem2_rw(mem2_rw_RrAg_MEM_latch_out),
        .eip_in(eip_RrAg_MEM_latch_out), .IE_in(IE_RrAg_MEM_latch_out), .IE_type_in(IE_type_RrAg_MEM_latch_out),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_out)
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
        .VP_in(VP), .PF_in(PF),
        .entry_v_in(entry_v), .entry_P_in(entry_P), .entry_RW_in(entry_RW), .entry_PCD_in(entry_PCD),
        .aluk_in(aluk_RrAg_MEM_latch_out), .mux_adder_in(mux_adder_RrAg_MEM_latch_out), 
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_out), .mux_shift_in(mux_shift_RrAg_MEM_latch_out),
        .p_op_in(p_op_RrAg_MEM_latch_out), .fmask_in(fmask_RrAg_MEM_latch_out),
        .CS_in(CS_out_RrAg_MEM_latch_out),
        .conditionals_in(conditionals_RrAg_MEM_latch_out), .is_br_in(is_br_RrAg_MEM_latch_out), 
        .is_fp_in(is_fp_RrAg_MEM_latch_out),
        .imm(imm_RrAg_MEM_latch_out), .mem1_rw(mem1_rw_RrAg_MEM_latch_out), .mem2_rw(mem2_rw_RrAg_MEM_latch_out),
        .eip_in(eip_RrAg_MEM_latch_out), .IE_in(IE_RrAg_MEM_latch_out), .IE_type_in(IE_type_RrAg_MEM_latch_out),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_out),
        .clr(), .clk(clk), //TODO
        //outputs
        .valid_out(valid_MEM_EX_latch_in),
        .eip_out(EIP_MEM_EX_latch_in),
        .IE_out(IE_MEM_EX_latch_in),
        .IE_type_out(IE_type_MEM_EX_latch_in),
        .BR_pred_target_out(BR_pred_target_MEM_EX_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_MEM_EX_latch_in),
        .set_out(set_MEM_EX_latch_in),
        .rst_out(rst_MEM_EX_latch_in),
        .res1_ld_out(res1_ld_MEM_EX_latch_in),
        .res2_ld_out(res2_ld_MEM_EX_latch_in),
        .res3_ld_out(res3_ld_MEM_EX_latch_in),
        .res4_ld_out(res4_ld_MEM_EX_latch_in),
        .op1_val(op1_MEM_EX_latch_in),
        .op2_val(op2_MEM_EX_latch_in),
        .op3_val(op3_MEM_EX_latch_in),
        .op4_val(op4_MEM_EX_latch_in),
        .op1_ptcinfo(op1_ptcinfo_MEM_EX_latch_in),
        .op2_ptcinfo(op2_ptcinfo_MEM_EX_latch_in),
        .op3_ptcinfo(op3_ptcinfo_MEM_EX_latch_in),
        .op4_ptcinfo(op4_ptcinfo_MEM_EX_latch_in),
        .dest1_addr(dest1_addr_MEM_EX_latch_in),
        .dest2_addr(dest2_addr_MEM_EX_latch_in),
        .dest3_addr(dest3_addr_MEM_EX_latch_in),
        .dest4_addr(dest4_addr_MEM_EX_latch_in),
        .dest1_is_reg(res1_is_reg_MEM_EX_latch_in),
        .dest2_is_reg(res2_is_reg_MEM_EX_latch_in),
        .dest3_is_reg(res3_is_reg_MEM_EX_latch_in),
        .dest4_is_reg(res_in4_is_reg_MEM_EX_latch_in),
        .dest1_is_seg(res1_is_seg_MEM_EX_latch_in),
        .dest2_is_seg(res2_is_seg_MEM_EX_latch_in),
        .dest3_is_seg(res3_is_seg_MEM_EX_latch_in),
        .dest4_is_seg(res_in4_is_seg_MEM_EX_latch_in),
        .dest1_is_mem(res1_is_mem_MEM_EX_latch_in), .dest2_is_mem(res2_is_mem_MEM_EX_latch_in), 
        .dest3_is_mem(res3_is_mem_MEM_EX_latch_in), .dest4_is_mem(res_in4_is_mem_MEM_EX_latch_in),
        .aluk_out(aluk_MEM_EX_latch_in), .mux_adder_out(MUX_ADDER_IMM_MEM_EX_latch_in), 
        .mux_and_int_out(MUX_AND_INT_MEM_EX_latch_in), .mux_shift_out(MUX_SHIFT_MEM_EX_latch_in),
        .p_op_out(P_OP_MEM_EX_latch_in), .fmask_out(), .conditionals_out(), .is_br_out(), .is_fp_out(),
        .CS_out(CS_MEM_EX_latch_in)
    );        
        
    ///////////////////////////////////////////////////////////
    //     Outputs from EX that go into EX_WB_latch:        //  
    //////////////////////////////////////////////////////////

    wire valid_MEM_EX_latch_in;
    wire [31:0] EIP_MEM_EX_latch_in;
    wire IE_MEM_EX_latch_in;
    wire [3:0] IE_type_MEM_EX_latch_in;
    wire [31:0] BR_pred_target_MEM_EX_latch_in;
    wire BR_pred_T_NT_MEM_EX_latch_in;
    wire set_MEM_EX_latch_in;
    wire rst_MEM_EX_latch_in;

    wire res1_ld_MEM_EX_latch_in, res2_ld_MEM_EX_latch_in, res3_ld_MEM_EX_latch_in, res4_ld_MEM_EX_latch_in;
    wire [63:0] op1_MEM_EX_latch_in, op2_MEM_EX_latch_in, op3_MEM_EX_latch_in, op4_MEM_EX_latch_in;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_in, op2_ptcinfo_MEM_EX_latch_in, op3_ptcinfo_MEM_EX_latch_in, op4_ptcinfo_MEM_EX_latch_in;
    wire [31:0] dest1_addr_MEM_EX_latch_in, dest2_addr_MEM_EX_latch_in, dest3_addr_MEM_EX_latch_in, dest4_addr_MEM_EX_latch_in;
    wire res1_is_reg_MEM_EX_latch_in, res2_is_reg_MEM_EX_latch_in, res3_is_reg_MEM_EX_latch_in, res_in4_is_reg_MEM_EX_latch_in;
    wire res1_is_seg_MEM_EX_latch_in, res2_is_seg_MEM_EX_latch_in, res3_is_seg_MEM_EX_latch_in, res_in4_is_seg_MEM_EX_latch_in;
    wire res1_is_mem_MEM_EX_latch_in, res2_is_mem_MEM_EX_latch_in, res3_is_mem_MEM_EX_latch_in, res_in4_is_mem_MEM_EX_latch_in;
    wire [1:0] opsize_MEM_EX_latch_in; //TODO

    wire [4:0] aluk_MEM_EX_latch_in;
    wire [2:0] MUX_ADDER_IMM_MEM_EX_latch_in;
    wire MUX_AND_INT_MEM_EX_latch_in;
    wire MUX_SHIFT_MEM_EX_latch_in;

    wire [34:0] P_OP_MEM_EX_latch_in;
    wire load_eip_in_op1_MEM_EX_latch_in; //TODO
    wire load_segReg_in_op1_MEM_EX_latch_in;
    wire load_eip_in_op2_MEM_EX_latch_in;
    wire load_segReg_in_op2_MEM_EX_latch_in;
    wire [16:0] FMASK_MEM_EX_latch_in;
    wire [1:0] conditionals_MEM_EX_latch_in;

    wire isBR_MEM_EX_latch_in;
    wire is_fp_MEM_EX_latch_in;
    wire [15:0] CS_MEM_EX_latch_in;

    ///////////////////////////////////////////////////////////
    //     Outputs from EX_WB_latch that go into WB:        //  
    //////////////////////////////////////////////////////////

    wire valid_MEM_EX_latch_out;
    wire [31:0] EIP_MEM_EX_latch_out;
    wire IE_MEM_EX_latch_out;
    wire [3:0] IE_type_MEM_EX_latch_out;
    wire [31:0] BR_pred_target_MEM_EX_latch_out;
    wire BR_pred_T_NT_MEM_EX_latch_out;
    wire set_MEM_EX_latch_out;
    wire rst_MEM_EX_latch_out;

    wire res1_ld_MEM_EX_latch_out, res2_ld_MEM_EX_latch_out, res3_ld_MEM_EX_latch_out, res4_ld_MEM_EX_latch_out;
    wire [63:0] op1_MEM_EX_latch_out, op2_MEM_EX_latch_out, op3_MEM_EX_latch_out, op4_MEM_EX_latch_out;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_out, op2_ptcinfo_MEM_EX_latch_out, op3_ptcinfo_MEM_EX_latch_out, op4_ptcinfo_MEM_EX_latch_out;
    wire [31:0] dest1_addr_MEM_EX_latch_out, dest2_addr_MEM_EX_latch_out, dest3_addr_MEM_EX_latch_out, dest4_addr_MEM_EX_latch_out;
    wire res1_is_reg_MEM_EX_latch_out, res2_is_reg_MEM_EX_latch_out, res3_is_reg_MEM_EX_latch_out, res_in4_is_reg_MEM_EX_latch_out;
    wire res1_is_seg_MEM_EX_latch_out, res2_is_seg_MEM_EX_latch_out, res3_is_seg_MEM_EX_latch_out, res_in4_is_seg_MEM_EX_latch_out;
    wire res1_is_mem_MEM_EX_latch_out, res2_is_mem_MEM_EX_latch_out, res3_is_mem_MEM_EX_latch_out, res_in4_is_mem_MEM_EX_latch_out;
    wire [1:0] opsize_MEM_EX_latch_out;

    wire [4:0] aluk_MEM_EX_latch_out;
    wire [2:0] MUX_ADDER_IMM_MEM_EX_latch_out;
    wire MUX_AND_INT_MEM_EX_latch_out;
    wire MUX_SHIFT_MEM_EX_latch_out;
    wire [34:0] P_OP_MEM_EX_latch_out;
    wire load_eip_in_op1_MEM_EX_latch_out;
    wire load_segReg_in_op1_MEM_EX_latch_out;
    wire load_eip_in_op2_MEM_EX_latch_out;  //TODO
    wire load_segReg_in_op2_MEM_EX_latch_out;
    wire [16:0] FMASK_MEM_EX_latch_out;
    wire [1:0] conditionals_MEM_EX_latch_out;

    wire isBR_MEM_EX_latch_out;
    wire is_fp_MEM_EX_latch_out;
    wire [15:0] CS_MEM_EX_latch_out;


    //queued latch between MEM and EX - 8

endmodule


module RrAg_MEM_latch (
        input ld, clr,
        input clk,

        input valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in,
        input [1:0] opsize_RrAg_MEM_latch_in,
        input [31:0] mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in,
        input [63:0] reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in,
        input [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in,
        input [2:0] reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in,
        input [15:0] seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in,
        input [31:0] ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in,
        input [2:0] seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in,
        input [6:0] inst_ptcid_RrAg_MEM_latch_in,
        input [12:0] op1_out_RrAg_MEM_latch_in, op2_out_RrAg_MEM_latch_in, op3_out_RrAg_MEM_latch_in, op4_out_RrAg_MEM_latch_in,
        input [12:0] dest1_out_RrAg_MEM_latch_in, dest2_out_RrAg_MEM_latch_in, dest3_out_RrAg_MEM_latch_in, dest4_out_RrAg_MEM_latch_in,
        input res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in,
        input [31:0] rep_num_RrAg_MEM_latch_in,
        input [4:0] aluk_out_RrAg_MEM_latch_in,
        input [2:0] mux_adder_out_RrAg_MEM_latch_in,
        input mux_and_int_out_RrAg_MEM_latch_in, mux_shift_out_RrAg_MEM_latch_in,
        input [36:0] p_op_out_RrAg_MEM_latch_in,
        input [17:0] fmask_out_RrAg_MEM_latch_in,
        input [15:0]  CS_out_RrAg_MEM_latch_in,
        input [1:0] conditionals_out_RrAg_MEM_latch_in,
        input is_br_out_RrAg_MEM_latch_in, is_fp_out_RrAg_MEM_latch_in,
        input [47:0] imm_out_RrAg_MEM_latch_in,
        input [1:0] mem1_rw_out_RrAg_MEM_latch_in, mem2_rw_out_RrAg_MEM_latch_in,
        input [31:0] eip_out_RrAg_MEM_latch_in,
        input IE_out_RrAg_MEM_latch_in,
        input [3:0] IE_type_out_RrAg_MEM_latch_in,
        input [31:0] BR_pred_target_out_RrAg_MEM_latch_in,
        input BR_pred_T_NT_out_RrAg_MEM_latch_in,

        output valid_RrAg_MEM_latch_out, stall_RrAg_MEM_latch_out,
        output [1:0] opsize_RrAg_MEM_latch_out,
        output [31:0] mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out,
        output [63:0] reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out,
        output [127:0] ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out,
        output [2:0] reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out,
        output [15:0] seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out,
        output [31:0] ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out,
        output [2:0] seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out,
        output [6:0] inst_ptcid_RrAg_MEM_latch_out,
        output [12:0] op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out,
        output [12:0] dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out,
        output res1_ld_out_RrAg_MEM_latch_out, res2_ld_out_RrAg_MEM_latch_out, res3_ld_out_RrAg_MEM_latch_out, res4_ld_out_RrAg_MEM_latch_out,
        output [31:0] rep_num_RrAg_MEM_latch_out,
        output [4:0] aluk_RrAg_MEM_latch_out,
        output [2:0] mux_adder_RrAg_MEM_latch_out,
        output mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out,
        output [36:0] p_op_RrAg_MEM_latch_out,
        output [17:0] fmask_RrAg_MEM_latch_out,
        output [15:0]  CS_out_RrAg_MEM_latch_out,
        output [1:0] conditionals_RrAg_MEM_latch_out,
        output is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out,
        output [47:0] imm_RrAg_MEM_latch_out,
        output [1:0] mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out,
        output [31:0] eip_RrAg_MEM_latch_out,
        output IE_RrAg_MEM_latch_out,
        output [3:0] IE_type_RrAg_MEM_latch_out,
        output [31:0] BR_pred_target_RrAg_MEM_latch_out,
        output BR_pred_T_NT_RrAg_MEM_latch_out,

        );

    regn #(.WIDTH(1)) r1 (.din(valid_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r2 (.din(stall_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(stall_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r3 (.din(opsize_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(opsize_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r4 (.din(mem_addr1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r5 (.din(mem_addr2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r6 (.din(mem_addr1_end_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_end_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r7 (.din(mem_addr2_end_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_end_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r8 (.din(reg1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r9 (.din(reg2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r10 (.din(reg3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r11 (.din(reg4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r12 (.din(ptc_r1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r1_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r13 (.din(ptc_r2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r2_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r14 (.din(ptc_r3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r3_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r15 (.din(ptc_r4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r4_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r16 (.din(reg1_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r17 (.din(reg2_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r18 (.din(reg3_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r19 (.din(reg4_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r20 (.din(seg1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r21 (.din(seg2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r22 (.din(seg3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r23 (.din(seg4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r24 (.din(ptc_s1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s1_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r25 (.din(ptc_s2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s2_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r26 (.din(ptc_s3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s3_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r27 (.din(ptc_s4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s4_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r28 (.din(seg1_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r29 (.din(seg2_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r30 (.din(seg3_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r31 (.din(seg4_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(7)) r32 (.din(inst_ptcid_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(inst_ptcid_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r33 (.din(op1_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op1_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r34 (.din(op2_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op2_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r35 (.din(op3_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op3_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r36 (.din(op4_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op4_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r37 (.din(dest1_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest1_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r38 (.din(dest2_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest2_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r39 (.din(dest3_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest3_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r40 (.din(dest4_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest4_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r41 (.din(res1_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r42 (.din(res2_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r43 (.din(res3_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r44 (.din(res4_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r45 (.din(rep_num_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(rep_num_RrAg_MEM_latch_out));
    regn #(.WIDTH(5)) r46 (.din(aluk_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(aluk_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r47 (.din(mux_adder_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_adder_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r48 (.din(mux_and_int_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_and_int_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r49 (.din(mux_shift_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_shift_RrAg_MEM_latch_out));
    regn #(.WIDTH(37)) r50 (.din(p_op_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(p_op_RrAg_MEM_latch_out));
    regn #(.WIDTH(18)) r51 (.din(fmask_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(fmask_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r52 (.din(CS_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(CS_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r52 (.din(conditionals_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(conditionals_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r53 (.din(is_br_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_br_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r54 (.din(is_fp_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_fp_RrAg_MEM_latch_out));
    regn #(.WIDTH(48)) r55 (.din(imm_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(imm_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r56 (.din(mem1_rw_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem1_rw_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r57 (.din(mem2_rw_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem2_rw_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r58 (.din(eip_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(eip_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r59 (.din(IE_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_RrAg_MEM_latch_out));
    regn #(.WIDTH(4)) r60 (.din(IE_type_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r61 (.din(BR_pred_target_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r62 (.din(BR_pred_T_NT_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_RrAg_MEM_latch_out));

    always @(posedge clk) begin
		$display("\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: 0x%h", valid_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t stall: 0x%h", stall_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t opsize: 0x%h", opsize_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr1: 0x%h", mem_addr1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr2: 0x%h", mem_addr2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr1_end: 0x%h", mem_addr1_end_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr2_end: 0x%h", mem_addr2_end_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg1: 0x%h", reg1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg2: 0x%h", reg2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg3: 0x%h", reg3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg4: 0x%h", reg4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r1: 0x%h", ptc_r1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r2: 0x%h", ptc_r2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r3: 0x%h", ptc_r3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r4: 0x%h", ptc_r4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg1_orig: 0x%h", reg1_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg2_orig: 0x%h", reg2_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg3_orig: 0x%h", reg3_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg4_orig: 0x%h", reg4_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg1: 0x%h", seg1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg2: 0x%h", seg2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg3: 0x%h", seg3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg4: 0x%h", seg4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s1: 0x%h", ptc_s1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s2: 0x%h", ptc_s2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s3: 0x%h", ptc_s3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s4: 0x%h", ptc_s4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg1_orig: 0x%h", seg1_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg2_orig: 0x%h", seg2_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg3_orig: 0x%h", seg3_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg4_orig: 0x%h", seg4_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t inst_ptcid: 0x%h", inst_ptcid_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op1: 0x%h", op1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op2: 0x%h", op2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op3: 0x%h", op3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op4: 0x%h", op4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest1: 0x%h", dest1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest2: 0x%h", dest2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest3: 0x%h", dest3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest4: 0x%h", dest4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res1_ld_out: 0x%h", res1_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res2_ld_out: 0x%h", res2_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res3_ld_out: 0x%h", res3_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res4_ld_out: 0x%h", res4_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t rep_num: 0x%h", rep_num_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t aluk: 0x%h", aluk_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_adder: 0x%h", mux_adder_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_and_int: 0x%h", mux_and_int_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_shift: 0x%h", mux_shift_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t p_op: 0x%h", p_op_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t fmask: 0x%h", fmask_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t CS: 0x%h", CS_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t conditionals: 0x%h", conditionals_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t is_br: 0x%h", is_br_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t is_fp: 0x%h", is_fp_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t imm: 0x%h", imm_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem1_rw: 0x%h", mem1_rw_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem2_rw: 0x%h", mem2_rw_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t eip: 0x%h", eip_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t IE: 0x%h", IE_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t IE_type: 0x%h", IE_type_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: 0x%h", BR_pred_T_NT_RrAg_MEM_latch_out);
        
		
		$display("\n=================================================\n");    
	end

    

endmodule