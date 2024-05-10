 module TOP();
    localparam CYCLE_TIME = 15.0;
    
    integer file;
    reg clk;
    integer cycle_number;

    localparam m_size_D_RrAg = 1;
    localparam n_size_D_RrAg = 396;
    
    localparam m_size_MEM_EX = 780;
    localparam n_size_MEM_EX = 335;

    initial #500 $finish; //TODO: run for n ns

    initial begin
        file = $fopen("debug.out", "w");
        cycle_number = 0;
        $vcdplusfile("processor.dump.vpd");
        $vcdpluson(0, TOP); 
    end

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    always @(posedge clk) begin
        cycle_number = cycle_number + 1;
        $fdisplay(file, "Cycle number: %d", cycle_number);
    end

    reg [127:0] packet;
    reg D_valid;

    //TODO: TLB Initializations
    reg [19:0] VP_0, VP_1, VP_2, VP_3, VP_4, VP_5, VP_6, VP_7;
	reg [19:0] PF_0, PF_1, PF_2, PF_3, PF_4, PF_5, PF_6, PF_7;
	reg [7:0] entry_v;
	reg [7:0] entry_P;
	reg [7:0] entry_RW;
    reg [7:0] entry_PCD;
	reg [159:0] VP, PF; //concats of VP_7 to VP_0 and PF_7 to PF_0

    //TODO: Core initializations:
    reg global_reset;
    reg global_set;
    reg global_init;
    reg [31:0] EIP_init;

    initial begin

        global_set = 1;
        global_reset = 0;
        global_init = 0;

        #(CYCLE_TIME)

        global_reset = 1;
        global_set = 1;
        global_init = 1;
        EIP_init = 32'h0000_0000;

        #(CYCLE_TIME)

        global_init = 0;
        packet = 128'h0432_0000_0000_0000_0000_0000_0000_0000;
        D_valid = 1'b1;

        #(CYCLE_TIME)
        global_init = 0;

    end

    //Pipeline: FETCH1 -> FETCH2 -> DECODE -> RrAg -> MEM -> EX -> WB

    //  IMPORTANT NOTES:
    //   -  notation for latche wires: <signal.name>_<stage.prev>_<stage.next>_latch_<in/out>
    //      where <in> is the input to the latch (output of stage.prev) and <out> is the output 
    //      from the latch (input of stage.next)

    ///////////////////////////////////////////////////////////
    //                      stall signals:                  //  
    //////////////////////////////////////////////////////////

    wire EX_stall_out, MEM_stall_out, RrAg_stall_out, D_stall_out;
    wire D_RrAg_Latches_full, MEM_EX_Latches_full;
    wire D_RrAg_Latches_empty, MEM_EX_Latches_empty; // AND with valid to get internal valid signals   

    ///////////////////////////////////////////////////////////
    //    Outputs from F that go into the F_D_latch:     //  
    //////////////////////////////////////////////////////////
    
    wire [127:0] packet_out_F_D_latch_in;
    wire packet_out_valid_F_D_latch_in;

    ///////////////////////////////////////////////////////////
    //         Outputs from F_D_latch that go into D:       //  
    //////////////////////////////////////////////////////////
    
    wire [127:0] packet_out_F_D_latch_out;
    wire packet_out_valid_F_D_latch_out;

    ///////////////////////////////////////////////////////////
    //    Outputs from D that go into the D_RrAg_latch:     //  
    //////////////////////////////////////////////////////////

    wire        valid_out_D_RrAg_latch_in;
    wire [2:0]  reg_addr1_D_RrAg_latch_in;
    wire [2:0]  reg_addr2_D_RrAg_latch_in;
    wire [2:0]  reg_addr3_D_RrAg_latch_in;
    wire [2:0]  reg_addr4_D_RrAg_latch_in;
    wire [2:0]  seg_addr1_D_RrAg_latch_in;
    wire [2:0]  seg_addr2_D_RrAg_latch_in;
    wire [2:0]  seg_addr3_D_RrAg_latch_in;
    wire [2:0]  seg_addr4_D_RrAg_latch_in;
    wire [1:0]  opsize_D_RrAg_latch_in;
    wire        addressingmode_D_RrAg_latch_in;
    wire [12:0] op1_D_RrAg_latch_in;
    wire [12:0] op2_D_RrAg_latch_in;
    wire [12:0] op3_D_RrAg_latch_in;
    wire [12:0] op4_D_RrAg_latch_in;
    wire        res1_ld_D_RrAg_latch_in;
    wire        res2_ld_D_RrAg_latch_in;
    wire        res3_ld_D_RrAg_latch_in;
    wire        res4_ld_D_RrAg_latch_in;
    wire [12:0] dest1_D_RrAg_latch_in;
    wire [12:0] dest2_D_RrAg_latch_in;
    wire [12:0] dest3_D_RrAg_latch_in;
    wire [12:0] dest4_D_RrAg_latch_in;
    wire [31:0] disp_D_RrAg_latch_in;
    wire [1:0]  reg3_shfamnt_D_RrAg_latch_in;
    wire        usereg2_D_RrAg_latch_in;
    wire        usereg3_D_RrAg_latch_in;
    wire        rep_D_RrAg_latch_in;
    wire [4:0]  aluk_D_RrAg_latch_in;
    wire [2:0]  mux_adder_D_RrAg_latch_in;
    wire        mux_and_int_D_RrAg_latch_in;
    wire        mux_shift_D_RrAg_latch_in;
    wire [36:0] p_op_D_RrAg_latch_in;
    wire [17:0] fmask_D_RrAg_latch_in;
    wire [1:0]  conditionals_D_RrAg_latch_in;
    wire        is_br_D_RrAg_latch_in;
    wire        is_fp_D_RrAg_latch_in;
    wire [47:0] imm_D_RrAg_latch_in;
    wire [1:0]  mem1_rw_D_RrAg_latch_in;
    wire [1:0]  mem2_rw_D_RrAg_latch_in;
    wire [31:0] latched_eip_D_RrAg_latch_in;
    wire [31:0] eip_D_RrAg_latch_in;
    wire        IE_D_RrAg_latch_in;
    wire [3:0]  IE_type_D_RrAg_latch_in;
    wire [31:0] BR_pred_target_D_RrAg_latch_in;
    wire        BR_pred_T_NT_D_RrAg_latch_in;
    wire        is_imm_D_RrAg_latch_in;

    ///////////////////////////////////////////////////////////
    //   Outputs from the D_RrAg_latch that go into RrAg:   //  
    //////////////////////////////////////////////////////////

    wire        valid_out_D_RrAg_latch_out;
    wire [2:0]  reg_addr1_D_RrAg_latch_out;
    wire [2:0]  reg_addr2_D_RrAg_latch_out;
    wire [2:0]  reg_addr3_D_RrAg_latch_out;
    wire [2:0]  reg_addr4_D_RrAg_latch_out;

    wire [2:0]  seg_addr1_D_RrAg_latch_out;
    wire [2:0]  seg_addr2_D_RrAg_latch_out;
    wire [2:0]  seg_addr3_D_RrAg_latch_out;
    wire [2:0]  seg_addr4_D_RrAg_latch_out;

    wire [1:0]  opsize_D_RrAg_latch_out;
    wire        addressingmode_D_RrAg_latch_out;
    
    wire [12:0] op1_D_RrAg_latch_out;
    wire [12:0] op2_D_RrAg_latch_out;
    wire [12:0] op3_D_RrAg_latch_out;
    wire [12:0] op4_D_RrAg_latch_out;
    wire        res1_ld_D_RrAg_latch_out;
    wire        res2_ld_D_RrAg_latch_out;
    wire        res3_ld_D_RrAg_latch_out;
    wire        res4_ld_D_RrAg_latch_out;
    wire [12:0] dest1_D_RrAg_latch_out;
    wire [12:0] dest2_D_RrAg_latch_out;
    wire [12:0] dest3_D_RrAg_latch_out;
    wire [12:0] dest4_D_RrAg_latch_out;
    wire [31:0] disp_D_RrAg_latch_out;
    wire [1:0]  reg3_shfamnt_D_RrAg_latch_out;
    wire        usereg2_D_RrAg_latch_out;
    wire        usereg3_D_RrAg_latch_out;
    wire        rep_D_RrAg_latch_out;
    wire [4:0]  aluk_D_RrAg_latch_out;
    wire [2:0]  mux_adder_D_RrAg_latch_out;
    wire        mux_and_int_D_RrAg_latch_out;
    wire        mux_shift_D_RrAg_latch_out;
    wire [36:0] p_op_D_RrAg_latch_out;
    wire [17:0] fmask_D_RrAg_latch_out;
    wire [1:0]  conditionals_D_RrAg_latch_out;
    wire        is_br_D_RrAg_latch_out;
    wire        is_fp_D_RrAg_latch_out;
    wire [47:0] imm_D_RrAg_latch_out;
    wire [1:0]  mem1_rw_D_RrAg_latch_out;
    wire [1:0]  mem2_rw_D_RrAg_latch_out;
    wire [31:0] latched_eip_D_RrAg_latch_out;
    wire [31:0] eip_D_RrAg_latch_out;
    wire        IE_D_RrAg_latch_out;
    wire [3:0]  IE_type_D_RrAg_latch_out;
    wire [31:0] BR_pred_target_D_RrAg_latch_out;
    wire        BR_pred_T_NT_D_RrAg_latch_out;
    wire        is_imm_D_RrAg_latch_out;

    ///////////////////////////////////////////////////////////
    // Outputs from Rr/Ag that go into the RrAg_MEM_latch:  //  
    //////////////////////////////////////////////////////////
    
    wire         valid_RrAg_MEM_latch_in;
    wire [1:0]   opsize_RrAg_MEM_latch_in;
    wire [31:0]  mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in;
    wire [63:0]  reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in;
    wire [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in;
    wire [2:0]   reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in;
    wire [15:0]  seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in;
    wire [31:0]  ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in;
    wire [2:0]   seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in;
    wire [6:0]   inst_ptcid_RrAg_MEM_latch_in;
    wire [12:0]  op1_RrAg_MEM_latch_in, op2_RrAg_MEM_latch_in, op3_RrAg_MEM_latch_in, op4_RrAg_MEM_latch_in;
    wire [12:0]  dest1_RrAg_MEM_latch_in, dest2_RrAg_MEM_latch_in, dest3_RrAg_MEM_latch_in, dest4_RrAg_MEM_latch_in;
    wire         res1_ld_RrAg_MEM_latch_in, res2_ld_RrAg_MEM_latch_in, res3_ld_RrAg_MEM_latch_in, res4_ld_RrAg_MEM_latch_in;
    wire [31:0]  rep_num_RrAg_MEM_latch_in;
    wire         is_rep_RrAg_MEM_latch_in;
    wire [4:0]   aluk_RrAg_MEM_latch_in;
    wire [2:0]   mux_adder_RrAg_MEM_latch_in;
    wire         mux_and_int_RrAg_MEM_latch_in, mux_shift_RrAg_MEM_latch_in;
    wire [36:0]  p_op_RrAg_MEM_latch_in;
    wire [17:0]  fmask_RrAg_MEM_latch_in;
    wire [1:0]   conditionals_RrAg_MEM_latch_in;
    wire [15:0]  CS_RrAg_MEM_latch_in;
    wire         is_br_RrAg_MEM_latch_in, is_fp_RrAg_MEM_latch_in, is_imm_RrAg_MEM_latch_in;
    wire [47:0]  imm_RrAg_MEM_latch_in;
    wire [1:0]   mem1_rw_RrAg_MEM_latch_in, mem2_rw_RrAg_MEM_latch_in;
    wire [31:0]  eip_RrAg_MEM_latch_in;
    wire [31:0]  latched_eip_RrAg_MEM_latch_in; 
    wire         IE_RrAg_MEM_latch_in;
    wire [3:0]   IE_type_RrAg_MEM_latch_in;
    wire [31:0]  BR_pred_target_RrAg_MEM_latch_in;
    wire         BR_pred_T_NT_RrAg_MEM_latch_in;
    
    ///////////////////////////////////////////////////////////
    //   Outputs from RrAg_MEM_latch that go into the MEM:  //  
    //////////////////////////////////////////////////////////

    wire         valid_RrAg_MEM_latch_out;
    wire [1:0]   opsize_RrAg_MEM_latch_out;
    wire [31:0]  mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out;
    wire [63:0]  reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out;
    wire [127:0] ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out;
    wire [2:0]   reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out;
    wire [15:0]  seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out;
    wire [31:0]  ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out;
    wire [2:0]   seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out;
    wire [6:0]   inst_ptcid_RrAg_MEM_latch_out;
    wire [12:0]  op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out;
    wire [12:0]  dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out;
    wire         res1_ld_RrAg_MEM_latch_out, res2_ld_RrAg_MEM_latch_out, res3_ld_RrAg_MEM_latch_out, res4_ld_RrAg_MEM_latch_out;
    wire [31:0]  rep_num_RrAg_MEM_latch_out;
    wire         is_rep_RrAg_MEM_latch_out;
    wire [4:0]   aluk_RrAg_MEM_latch_out;
    wire [2:0]   mux_adder_RrAg_MEM_latch_out;
    wire         mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out;
    wire [36:0]  p_op_RrAg_MEM_latch_out;
    wire [17:0]  fmask_RrAg_MEM_latch_out;
    wire [15:0]  CS_RrAg_MEM_latch_out;
    wire [1:0]   conditionals_RrAg_MEM_latch_out;
    wire         is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out, is_imm_RrAg_MEM_latch_out;
    wire [47:0]  imm_RrAg_MEM_latch_out;
    wire [1:0]   mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out;
    wire [31:0]  eip_RrAg_MEM_latch_out;
    wire [31:0]  latched_eip_RrAg_MEM_latch_out;
    wire         IE_RrAg_MEM_latch_out;
    wire [3:0]   IE_type_RrAg_MEM_latch_out;
    wire [31:0]  BR_pred_target_RrAg_MEM_latch_out;
    wire         BR_pred_T_NT_RrAg_MEM_latch_out;

    ///////////////////////////////////////////////////////////
    //     Outputs from MEM that go into MEM_EX_latch:      //  
    //////////////////////////////////////////////////////////

    wire         valid_MEM_EX_latch_in;
    wire [31:0]  EIP_MEM_EX_latch_in;
    wire [31:0]  latched_eip_MEM_EX_latch_in;
    wire         IE_MEM_EX_latch_in;
    wire [3:0]   IE_type_MEM_EX_latch_in;
    wire [31:0]  BR_pred_target_MEM_EX_latch_in;
    wire         BR_pred_T_NT_MEM_EX_latch_in;
 
    wire         res1_ld_MEM_EX_latch_in, res2_ld_MEM_EX_latch_in, res3_ld_MEM_EX_latch_in, res4_ld_MEM_EX_latch_in;
    wire [63:0]  op1_MEM_EX_latch_in, op2_MEM_EX_latch_in, op3_MEM_EX_latch_in, op4_MEM_EX_latch_in;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_in, op2_ptcinfo_MEM_EX_latch_in, op3_ptcinfo_MEM_EX_latch_in, op4_ptcinfo_MEM_EX_latch_in;
    wire [31:0]  dest1_addr_MEM_EX_latch_in, dest2_addr_MEM_EX_latch_in, dest3_addr_MEM_EX_latch_in, dest4_addr_MEM_EX_latch_in;
    wire         res1_is_reg_MEM_EX_latch_in, res2_is_reg_MEM_EX_latch_in, res3_is_reg_MEM_EX_latch_in, res4_is_reg_MEM_EX_latch_in;
    wire         res1_is_seg_MEM_EX_latch_in, res2_is_seg_MEM_EX_latch_in, res3_is_seg_MEM_EX_latch_in, res4_is_seg_MEM_EX_latch_in;
    wire         res1_is_mem_MEM_EX_latch_in, res2_is_mem_MEM_EX_latch_in, res3_is_mem_MEM_EX_latch_in, res4_is_mem_MEM_EX_latch_in;
    wire [1:0]   opsize_MEM_EX_latch_in;

    wire [4:0]   aluk_MEM_EX_latch_in;
    wire [2:0]   MUX_ADDER_IMM_MEM_EX_latch_in;
    wire         MUX_AND_INT_MEM_EX_latch_in, MUX_SHIFT_MEM_EX_latch_in;

    wire [36:0]  P_OP_MEM_EX_latch_in;
    wire [17:0]  FMASK_MEM_EX_latch_in;
    wire [1:0]   conditionals_MEM_EX_latch_in;

    wire         isBR_MEM_EX_latch_in, is_fp_MEM_EX_latch_in, is_imm_MEM_EX_latch_in, is_rep_MEM_EX_latch_in;
    wire [15:0]  CS_MEM_EX_latch_in;
    wire [3:0]   wake_MEM_EX_latch_in;
    wire [6:0]   inst_ptcid_MEM_EX_latch_in;
    

    ///////////////////////////////////////////////////////////
    //     Outputs from MEM_EX_latch that go into EX:        //  
    //////////////////////////////////////////////////////////

    wire         valid_MEM_EX_latch_out;
    wire [31:0]  EIP_MEM_EX_latch_out;
    wire [31:0]  latched_eip_MEM_EX_latch_out;
    wire         IE_MEM_EX_latch_out;
    wire [3:0]   IE_type_MEM_EX_latch_out;
    wire [31:0]  BR_pred_target_MEM_EX_latch_out;
    wire         BR_pred_T_NT_MEM_EX_latch_out;

    wire         res1_ld_MEM_EX_latch_out, res2_ld_MEM_EX_latch_out, res3_ld_MEM_EX_latch_out, res4_ld_MEM_EX_latch_out;
    wire [63:0]  op1_MEM_EX_latch_out, op2_MEM_EX_latch_out, op3_MEM_EX_latch_out, op4_MEM_EX_latch_out;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_out, op2_ptcinfo_MEM_EX_latch_out, op3_ptcinfo_MEM_EX_latch_out, op4_ptcinfo_MEM_EX_latch_out;
    wire [31:0]  dest1_addr_MEM_EX_latch_out, dest2_addr_MEM_EX_latch_out, dest3_addr_MEM_EX_latch_out, dest4_addr_MEM_EX_latch_out;
    wire         res1_is_reg_MEM_EX_latch_out, res2_is_reg_MEM_EX_latch_out, res3_is_reg_MEM_EX_latch_out, res4_is_reg_MEM_EX_latch_out;
    wire         res1_is_seg_MEM_EX_latch_out, res2_is_seg_MEM_EX_latch_out, res3_is_seg_MEM_EX_latch_out, res4_is_seg_MEM_EX_latch_out;
    wire         res1_is_mem_MEM_EX_latch_out, res2_is_mem_MEM_EX_latch_out, res3_is_mem_MEM_EX_latch_out, res4_is_mem_MEM_EX_latch_out;
    wire [1:0]   opsize_MEM_EX_latch_out;

    wire [4:0]   aluk_MEM_EX_latch_out;
    wire [2:0]   MUX_ADDER_IMM_MEM_EX_latch_out;
    wire         MUX_AND_INT_MEM_EX_latch_out;
    wire         MUX_SHIFT_MEM_EX_latch_out;
    wire [36:0]  P_OP_MEM_EX_latch_out;
    wire [17:0]  FMASK_MEM_EX_latch_out;
    wire [1:0]   conditionals_MEM_EX_latch_out;

    wire         isBR_MEM_EX_latch_out, is_fp_MEM_EX_latch_out, is_imm_MEM_EX_latch_out, is_rep_MEM_EX_latch_out;
    wire [15:0]  CS_MEM_EX_latch_out;
    wire [3:0]   wake_MEM_EX_latch_out;
    wire [6:0]   inst_ptcid_MEM_EX_latch_out;

        ///////////////////////////////////////////////////////////
    //     Outputs from Ex that go into the EX_WB_Latch:    //  
    //////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_in;

    wire [31:0] EIP_EX_WB_latch_in;
    wire IE_EX_WB_latch_in;
    wire [3:0] IE_type_EX_WB_latch_in;
    wire [31:0] BR_pred_target_EX_WB_latch_in;
    wire BR_pred_T_NT_EX_WB_latch_in;
    wire [6:0] inst_ptcid_EX_WB_latch_in;

    wire [63:0] inp1_EX_WB_latch_in, inp2_EX_WB_latch_in, inp3_EX_WB_latch_in, inp4_EX_WB_latch_in;
    wire  inp1_isReg_EX_WB_latch_in,  inp2_isReg_EX_WB_latch_in, inp3_isReg_EX_WB_latch_in,  inp4_isReg_EX_WB_latch_in;
    wire  inp1_isSeg_EX_WB_latch_in,  inp2_isSeg_EX_WB_latch_in, inp3_isSeg_EX_WB_latch_in,  inp4_isSeg_EX_WB_latch_in;
    wire  inp1_isMem_EX_WB_latch_in,  inp2_isMem_EX_WB_latch_in, inp3_isMem_EX_WB_latch_in,  inp4_isMem_EX_WB_latch_in;
    wire [31:0] inp1_dest_EX_WB_latch_in, inp2_dest_EX_WB_latch_in, inp3_dest_EX_WB_latch_in, inp4_dest_EX_WB_latch_in;
    wire [1:0] inpsize_EX_WB_latch_in;
    wire inp1_wb_EX_WB_latch_in, inp2_wb_EX_WB_latch_in, inp3_wb_EX_WB_latch_in, inp4_wb_EX_WB_latch_in;
    wire [127:0] inp1_ptcinfo_EX_WB_latch_in, inp2_ptcinfo_EX_WB_latch_in, inp3_ptcinfo_EX_WB_latch_in, inp4_ptcinfo_EX_WB_latch_in;

    wire BR_valid_EX_WB_latch_in, BR_taken_EX_WB_latch_in, BR_correct_EX_WB_latch_in;
    wire[31:0] BR_FIP_EX_WB_latch_in, BR_FIP_p1_EX_WB_latch_in;
    wire[15:0] CS_EX_WB_latch_in;
    wire [17:0] EFLAGS_EX_WB_latch_in;
    wire [36:0] P_OP_EX_WB_latch_in;
    wire is_rep_EX_WB_latch_in;

    ///////////////////////////////////////////////////////////
    //     Outputs from EX_WB_Latch that go into the WB:    //  
    //////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_out;
    wire [31:0] EIP_EX_WB_latch_out;
    wire IE_EX_WB_latch_out;
    wire [3:0] IE_type_EX_WB_latch_out;
    wire [31:0] BR_pred_target_EX_WB_latch_out;
    wire BR_pred_T_NT_EX_WB_latch_out;
    wire [6:0] inst_ptcid_EX_WB_latch_out;

    wire [63:0] inp1_EX_WB_latch_out, inp2_EX_WB_latch_out, inp3_EX_WB_latch_out, inp4_EX_WB_latch_out;
    wire  inp1_isReg_EX_WB_latch_out,  inp2_isReg_EX_WB_latch_out, inp3_isReg_EX_WB_latch_out,  inp4_isReg_EX_WB_latch_out;
    wire  inp1_isSeg_EX_WB_latch_out,  inp2_isSeg_EX_WB_latch_out, inp3_isSeg_EX_WB_latch_out,  inp4_isSeg_EX_WB_latch_out;
    wire  inp1_isMem_EX_WB_latch_out,  inp2_isMem_EX_WB_latch_out, inp3_isMem_EX_WB_latch_out,  inp4_isMem_EX_WB_latch_out;
    wire [31:0] inp1_dest_EX_WB_latch_out, inp2_dest_EX_WB_latch_out, inp3_dest_EX_WB_latch_out, inp4_dest_EX_WB_latch_out;
    wire [1:0] inpsize_EX_WB_latch_out;
    wire inp1_wb_EX_WB_latch_out, inp2_wb_EX_WB_latch_out, inp3_wb_EX_WB_latch_out, inp4_wb_EX_WB_latch_out;
    wire [127:0] inp1_ptcinfo_EX_WB_latch_out, inp2_ptcinfo_EX_WB_latch_out, inp3_ptcinfo_EX_WB_latch_out, inp4_ptcinfo_EX_WB_latch_out;

    wire BR_valid_EX_WB_latch_out, BR_taken_EX_WB_latch_out, BR_correct_EX_WB_latch_out;
    wire[31:0] BR_FIP_EX_WB_latch_out, BR_FIP_p1_EX_WB_latch_out;
    wire[15:0] CS_EX_WB_latch_out;
    wire [17:0] EFLAGS_EX_WB_latch_out;
    wire [36:0] P_OP_EX_WB_latch_out;
    wire is_rep_EX_WB_latch_out;

    ///////////////////////////////////////////////////////////
    //     Outputs from WB that go everywhere:              //
    //////////////////////////////////////////////////////////
    wire fwd_stall_WB_EX_out;
    wire [63:0] res1_WB_RRAG_out, res2_WB_RRAG_out, res3_WB_RRAG_out, res4_WB_RRAG_out, mem_data_WB_M_out; //done
    wire [127:0] res1_ptcinfo_WB_RRAG_out, res2_ptcinfo_WB_RRAG_out, res3_ptcinfo_WB_RRAG_out, res4_ptcinfo_WB_RRAG_out;
    wire [1:0] ressize_WB_RRAG_out, memsize_WB_M_out;
    wire [11:0] reg_addr_WB_RRAG_out, seg_addr_WB_RRAG_out;
    wire [31:0] mem_addr_WB_M_out; //done
    wire [3:0] reg_ld_WB_RRAG_out, seg_ld_WB_RRAG_out;
    wire mem_ld_WB_M_out;
    wire [6:0] inst_ptcid_out_WB_RRAG_out;


    // bp_gshare bp (
    //     //inputs
    //     .clk(clk),
    //     .reset(global_reset),
    //     .eip(),
    //     .prev_BR_result(),
    //     .prev_BR_alias(),
    //     .prev_is_BR,
    //     .LD(),
    //     //outputs
    //     .prediction(),
    //     .BP_alias()
    // );

    decode_TOP d0(
        // Clock and Reset
        .clk(clk),
        .reset(global_reset),
    
        // Signals from fetch_2
        .valid_in(1'b1), //TODO: D_valid
        .packet_in(packet),
        .IE_in(),
        .IE_type_in(),
    
        // Signals from BP
        .BP_EIP(),
        .is_BR_T_NT(),
    
        // Writeback signals
        .WB_EIP(),
        .is_resteer(),
    
        // Init signals
        .init_EIP(EIP_init),
        .is_init(global_init),
    
        // Stall signal
        .queue_full_stall(D_RrAg_Latches_full), // recieve from D_RrAg_Queued_latches
    
        // Outputs to RRAG
        .valid_out(valid_out_D_RrAg_latch_in),
        .reg_addr1_out(reg_addr1_D_RrAg_latch_in),
        .reg_addr2_out(reg_addr2_D_RrAg_latch_in),
        .reg_addr3_out(reg_addr3_D_RrAg_latch_in),
        .reg_addr4_out(reg_addr4_D_RrAg_latch_in),
        .seg_addr1_out(seg_addr1_D_RrAg_latch_in),
        .seg_addr2_out(seg_addr2_D_RrAg_latch_in),
        .seg_addr3_out(seg_addr3_D_RrAg_latch_in),
        .seg_addr4_out(seg_addr4_D_RrAg_latch_in),
        .opsize_out(opsize_D_RrAg_latch_in),
        .addressingmode_out(addressingmode_D_RrAg_latch_in),
        .op1_out(op1_D_RrAg_latch_in),
        .op2_out(op2_D_RrAg_latch_in),
        .op3_out(op3_D_RrAg_latch_in),
        .op4_out(op4_D_RrAg_latch_in),
        .res1_ld_out(res1_ld_D_RrAg_latch_in),
        .res2_ld_out(res2_ld_D_RrAg_latch_in),
        .res3_ld_out(res3_ld_D_RrAg_latch_in),
        .res4_ld_out(res4_ld_D_RrAg_latch_in),
        .dest1_out(dest1_D_RrAg_latch_in),
        .dest2_out(dest2_D_RrAg_latch_in),
        .dest3_out(dest3_D_RrAg_latch_in),
        .dest4_out(dest4_D_RrAg_latch_in),
        .disp_out(disp_D_RrAg_latch_in),
        .reg3_shfamnt_out(reg3_shfamnt_D_RrAg_latch_in),
        .usereg2_out(usereg2_D_RrAg_latch_in),
        .usereg3_out(usereg3_D_RrAg_latch_in),
        .rep_out(rep_D_RrAg_latch_in),

        .aluk_out(aluk_D_RrAg_latch_in),
        .mux_adder_out(mux_adder_D_RrAg_latch_in),
        .mux_and_int_out(mux_and_int_D_RrAg_latch_in),
        .mux_shift_out(mux_shift_D_RrAg_latch_in),
        .p_op_out(p_op_D_RrAg_latch_in),
        .fmask_out(fmask_D_RrAg_latch_in),
        .conditionals_out(conditionals_D_RrAg_latch_in),
        .is_br_out(is_br_D_RrAg_latch_in),
        .is_fp_out(is_fp_D_RrAg_latch_in),
        .imm_out(imm_D_RrAg_latch_in),
        .mem1_rw_out(mem1_rw_D_RrAg_latch_in),
        .mem2_rw_out(mem2_rw_D_RrAg_latch_in),
        .latched_eip_out(latched_eip_D_RrAg_latch_in), //TODO
        .eip_out(eip_D_RrAg_latch_in),
        .IE_out(IE_D_RrAg_latch_in),
        .IE_type_out(IE_type_D_RrAg_latch_in),
        .BR_pred_target_out(BR_pred_target_D_RrAg_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_D_RrAg_latch_in),
        .isImm_out(is_imm_D_RrAg_latch_in),
    
        // Outputs to fetch_2
        .stall_out(D_stall_out), //TODO: send to fetch_2
        .D_length()
    );
    
    wire [m_size_D_RrAg-1:0] m_din_D_RrAg;
    wire [n_size_D_RrAg-1:0] n_din_D_RrAg;

    assign m_din_D_RrAg = valid_out_D_RrAg_latch_in;
    assign n_din_D_RrAg = {latched_eip_D_RrAg_latch_in, is_imm_D_RrAg_latch_in, reg_addr1_D_RrAg_latch_in, reg_addr2_D_RrAg_latch_in, reg_addr3_D_RrAg_latch_in, reg_addr4_D_RrAg_latch_in,
                           seg_addr1_D_RrAg_latch_in, seg_addr2_D_RrAg_latch_in, seg_addr3_D_RrAg_latch_in, seg_addr4_D_RrAg_latch_in,
                           opsize_D_RrAg_latch_in, addressingmode_D_RrAg_latch_in,
                           op1_D_RrAg_latch_in, op2_D_RrAg_latch_in, op3_D_RrAg_latch_in, op4_D_RrAg_latch_in,
                           res1_ld_D_RrAg_latch_in, res2_ld_D_RrAg_latch_in, res3_ld_D_RrAg_latch_in, res4_ld_D_RrAg_latch_in,
                           dest1_D_RrAg_latch_in, dest2_D_RrAg_latch_in, dest3_D_RrAg_latch_in, dest4_D_RrAg_latch_in, disp_D_RrAg_latch_in,
                           reg3_shfamnt_D_RrAg_latch_in, usereg2_D_RrAg_latch_in, usereg3_D_RrAg_latch_in, rep_D_RrAg_latch_in, aluk_D_RrAg_latch_in, 
                           mux_adder_D_RrAg_latch_in, mux_and_int_D_RrAg_latch_in, mux_shift_D_RrAg_latch_in, p_op_D_RrAg_latch_in, fmask_D_RrAg_latch_in, 
                           conditionals_D_RrAg_latch_in, is_br_D_RrAg_latch_in, is_fp_D_RrAg_latch_in, imm_D_RrAg_latch_in, mem1_rw_D_RrAg_latch_in, 
                           mem2_rw_D_RrAg_latch_in, eip_D_RrAg_latch_in, IE_D_RrAg_latch_in, IE_type_D_RrAg_latch_in, BR_pred_target_D_RrAg_latch_in, 
                           BR_pred_T_NT_D_RrAg_latch_in
                        };

    wire D_RrAg_Latch_RD; 
    nand2$ n2002 (.out(D_RrAg_Latch_RD), .in0(valid_RrAg_MEM_latch_in), .in1(RrAg_stall_out));

    D_RrAg_Queued_Latches #(.M_WIDTH(m_size_D_RrAg), .N_WIDTH(n_size_D_RrAg), .Q_LENGTH(8)) q2 (
        .m_din(m_din_D_RrAg), .n_din(n_din_D_RrAg), .new_m_vector(), 
        .wr(valid_out_D_RrAg_latch_in), .rd(D_RrAg_Latch_RD), 
        .modify_vector(8'h0), .clr(global_reset), .clk(clk), .full(D_RrAg_Latches_full), .empty(D_RrAg_Latches_empty), .old_m_vector(/*TODO*/), 
            .dout({valid_out_D_RrAg_latch_out, latched_eip_D_RrAg_latch_out, is_imm_D_RrAg_latch_out, reg_addr1_D_RrAg_latch_out, reg_addr2_D_RrAg_latch_out, reg_addr3_D_RrAg_latch_out, reg_addr4_D_RrAg_latch_out,
            seg_addr1_D_RrAg_latch_out, seg_addr2_D_RrAg_latch_out, seg_addr3_D_RrAg_latch_out, seg_addr4_D_RrAg_latch_out,
            opsize_D_RrAg_latch_out, addressingmode_D_RrAg_latch_out,
            op1_D_RrAg_latch_out, op2_D_RrAg_latch_out, op3_D_RrAg_latch_out, op4_D_RrAg_latch_out,
            res1_ld_D_RrAg_latch_out, res2_ld_D_RrAg_latch_out, res3_ld_D_RrAg_latch_out, res4_ld_D_RrAg_latch_out,
            dest1_D_RrAg_latch_out, dest2_D_RrAg_latch_out, dest3_D_RrAg_latch_out, dest4_D_RrAg_latch_out, disp_D_RrAg_latch_out,
            reg3_shfamnt_D_RrAg_latch_out, usereg2_D_RrAg_latch_out, usereg3_D_RrAg_latch_out, rep_D_RrAg_latch_out, aluk_D_RrAg_latch_out, 
            mux_adder_D_RrAg_latch_out, mux_and_int_D_RrAg_latch_out, mux_shift_D_RrAg_latch_out, p_op_D_RrAg_latch_out, fmask_D_RrAg_latch_out, 
            conditionals_D_RrAg_latch_out, is_br_D_RrAg_latch_out, is_fp_D_RrAg_latch_out, imm_D_RrAg_latch_out, mem1_rw_D_RrAg_latch_out, 
            mem2_rw_D_RrAg_latch_out, eip_D_RrAg_latch_out, IE_D_RrAg_latch_out, IE_type_D_RrAg_latch_out, BR_pred_target_D_RrAg_latch_out, 
            BR_pred_T_NT_D_RrAg_latch_out})
            
        );
    
    assign RrAg_stall_out = 0;
    rrag r1 (
        //inputs
        .valid_in(valid_out_D_RrAg_latch_out), .reg_addr1(reg_addr1_D_RrAg_latch_out), .reg_addr2(reg_addr2_D_RrAg_latch_out), .reg_addr3(reg_addr3_D_RrAg_latch_out), .reg_addr4(reg_addr4_D_RrAg_latch_out),
        .seg_addr1(seg_addr1_D_RrAg_latch_out), .seg_addr2(seg_addr2_D_RrAg_latch_out), .seg_addr3(seg_addr3_D_RrAg_latch_out), .seg_addr4(seg_addr4_D_RrAg_latch_out),
        .opsize_in(opsize_D_RrAg_latch_out), .addressingmode(addressingmode_D_RrAg_latch_out), 
        .op1_in(op1_D_RrAg_latch_out), .op2_in(op2_D_RrAg_latch_out), .op3_in(op3_D_RrAg_latch_out), .op4_in(op4_D_RrAg_latch_out),
        .res1_ld_in(res1_ld_D_RrAg_latch_out), .res2_ld_in(res2_ld_D_RrAg_latch_out), .res3_ld_in(res3_ld_D_RrAg_latch_out), .res4_ld_in(res4_ld_D_RrAg_latch_out),
        .dest1_in(dest1_D_RrAg_latch_out), .dest2_in(dest2_D_RrAg_latch_out), .dest3_in(dest3_D_RrAg_latch_out), .dest4_in(dest4_D_RrAg_latch_out),
        .disp(disp_D_RrAg_latch_out), .reg3_shfamnt(reg3_shfamnt_D_RrAg_latch_out), .usereg2(usereg2_D_RrAg_latch_out), .usereg3(usereg3_D_RrAg_latch_out), .is_rep_in(rep_D_RrAg_latch_out),
        .latch_empty(D_RrAg_Latches_empty), .clr(global_reset), .clk(clk),
        .lim_init5(), .lim_init4(), .lim_init3(), .lim_init2(), .lim_init1(), .lim_init0(), //TODO: initializations
        .aluk_in(aluk_D_RrAg_latch_out), .mux_adder_in(mux_adder_D_RrAg_latch_out), .mux_and_int_in(mux_and_int_D_RrAg_latch_out), .mux_shift_in(mux_shift_D_RrAg_latch_out),
        .p_op_in(p_op_D_RrAg_latch_out), .fmask_in(fmask_D_RrAg_latch_out), .conditionals_in(conditionals_D_RrAg_latch_out), .is_br_in(is_br_D_RrAg_latch_out), .is_fp_in(is_fp_D_RrAg_latch_out),
        .is_imm_in(is_imm_D_RrAg_latch_out), .imm_in(imm_D_RrAg_latch_out), .mem1_rw_in(mem1_rw_D_RrAg_latch_out), .mem2_rw_in(mem2_rw_D_RrAg_latch_out), .latched_eip_in(latched_eip_D_RrAg_latch_out),
        .eip_in(eip_D_RrAg_latch_out), .IE_in(IE_D_RrAg_latch_out), .IE_type_in(IE_type_D_RrAg_latch_out), .BR_pred_target_in(BR_pred_target_D_RrAg_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_D_RrAg_latch_out),
        .wb_data1(), .wb_data2(), .wb_data3(), .wb_data4(), //TODO: connect from WB
        .wb_segdata1(), .wb_segdata2(), .wb_segdata3(), .wb_segdata4(),
        .wb_addr1(), .wb_addr2(), .wb_addr3(), .wb_addr4(),
        .wb_segaddr1(), .wb_segaddr2(), .wb_segaddr3(), .wb_segaddr4(),
        .wb_opsize(), .wb_regld(4'b0), .wb_segld(4'b0), .wb_inst_ptcid(),
        .fwd_stall(MEM_stall_out), //recieve from MEM
        .ptc_clear(1'b1), //TODO: from IDTR

        //outputs
        .valid_out(valid_RrAg_MEM_latch_in), .stall(/*RrAg_stall_out*/), //send to D_RrAg_Queued_Latches
        .opsize_out(opsize_RrAg_MEM_latch_in),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_in), .mem_addr2(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_in),
        .reg1(reg1_RrAg_MEM_latch_in), .reg2(reg2_RrAg_MEM_latch_in), .reg3(reg3_RrAg_MEM_latch_in), .reg4(reg4_RrAg_MEM_latch_in),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_in), .ptc_r2(ptc_r2_RrAg_MEM_latch_in), .ptc_r3(ptc_r3_RrAg_MEM_latch_in), .ptc_r4(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_in), .reg2_orig(reg2_orig_RrAg_MEM_latch_in), .reg3_orig(reg3_orig_RrAg_MEM_latch_in), .reg4_orig(reg4_orig_RrAg_MEM_latch_in),
        .seg1(seg1_RrAg_MEM_latch_in), .seg2(seg2_RrAg_MEM_latch_in), .seg3(seg3_RrAg_MEM_latch_in), .seg4(seg4_RrAg_MEM_latch_in),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_in), .ptc_s2(ptc_s2_RrAg_MEM_latch_in), .ptc_s3(ptc_s3_RrAg_MEM_latch_in), .ptc_s4(ptc_s4_RrAg_MEM_latch_in),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_in), .seg2_orig(seg2_orig_RrAg_MEM_latch_in), .seg3_orig(seg3_orig_RrAg_MEM_latch_in), .seg4_orig(seg4_orig_RrAg_MEM_latch_in),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_in),
        .op1_out(op1_RrAg_MEM_latch_in), .op2_out(op2_RrAg_MEM_latch_in), .op3_out(op3_RrAg_MEM_latch_in), .op4_out(op4_RrAg_MEM_latch_in),
        .dest1_out(dest1_RrAg_MEM_latch_in), .dest2_out(dest2_RrAg_MEM_latch_in), .dest3_out(dest3_RrAg_MEM_latch_in), .dest4_out(dest4_RrAg_MEM_latch_in),
        .res1_ld_out(res1_ld_RrAg_MEM_latch_in), .res2_ld_out(res2_ld_RrAg_MEM_latch_in), 
        .res3_ld_out(res3_ld_RrAg_MEM_latch_in), .res4_ld_out(res4_ld_RrAg_MEM_latch_in),
        .rep_num(rep_num_RrAg_MEM_latch_in), .is_rep_out(is_rep_RrAg_MEM_latch_in),
        
        .aluk_out(aluk_RrAg_MEM_latch_in),
        .mux_adder_out(mux_adder_RrAg_MEM_latch_in),
        .mux_and_int_out(mux_and_int_RrAg_MEM_latch_in), .mux_shift_out(mux_shift_RrAg_MEM_latch_in),
        .p_op_out(p_op_RrAg_MEM_latch_in),
        .fmask_out(fmask_RrAg_MEM_latch_in),
        .CS_out(CS_RrAg_MEM_latch_in),
        .conditionals_out(conditionals_RrAg_MEM_latch_in),
        .is_br_out(is_br_RrAg_MEM_latch_in), .is_fp_out(is_fp_RrAg_MEM_latch_in), .is_imm_out(is_imm_RrAg_MEM_latch_in), 
        .imm_out(imm_RrAg_MEM_latch_in),
        .mem1_rw_out(mem1_rw_RrAg_MEM_latch_in), .mem2_rw_out(mem2_rw_RrAg_MEM_latch_in),
        .latched_eip_out(latched_eip_RrAg_MEM_latch_in), .eip_out(eip_RrAg_MEM_latch_in), //TODO RN
        .IE_out(IE_RrAg_MEM_latch_in),
        .IE_type_out(IE_type_RrAg_MEM_latch_in),
        .BR_pred_target_out(BR_pred_target_RrAg_MEM_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_RrAg_MEM_latch_in)
    );
    
    wire RrAg_MEM_latch_LD;
    nand2$ n2000(.out(RrAg_MEM_latch_LD), .in0(valid_MEM_EX_latch_in), .in1(MEM_stall_out));

    RrAg_MEM_latch q4(
        //inputs
        .ld(RrAg_MEM_latch_LD), .clr(global_reset), // LD comes from MEM stalling 
        .clk(clk),
        .valid_in(valid_RrAg_MEM_latch_in), .opsize_in(opsize_RrAg_MEM_latch_in),
        .mem_addr1_in(mem_addr1_RrAg_MEM_latch_in), .mem_addr2_in(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end_in(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end_in(mem_addr2_end_RrAg_MEM_latch_in),
        .reg1_in(reg1_RrAg_MEM_latch_in), .reg2_in(reg2_RrAg_MEM_latch_in), .reg3_in(reg3_RrAg_MEM_latch_in), .reg4_in(reg4_RrAg_MEM_latch_in),
        .ptc_r1_in(ptc_r1_RrAg_MEM_latch_in), .ptc_r2_in(ptc_r2_RrAg_MEM_latch_in), .ptc_r3_in(ptc_r3_RrAg_MEM_latch_in), .ptc_r4_in(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig_in(reg1_orig_RrAg_MEM_latch_in), .reg2_orig_in(reg2_orig_RrAg_MEM_latch_in), .reg3_orig_in(reg3_orig_RrAg_MEM_latch_in), .reg4_orig_in(reg4_orig_RrAg_MEM_latch_in),
        .seg1_in(seg1_RrAg_MEM_latch_in), .seg2_in(seg2_RrAg_MEM_latch_in), .seg3_in(seg3_RrAg_MEM_latch_in), .seg4_in(seg4_RrAg_MEM_latch_in),
        .ptc_s1_in(ptc_s1_RrAg_MEM_latch_in), .ptc_s2_in(ptc_s2_RrAg_MEM_latch_in), .ptc_s3_in(ptc_s3_RrAg_MEM_latch_in), .ptc_s4_in(ptc_s4_RrAg_MEM_latch_in),
        .seg1_orig_in(seg1_orig_RrAg_MEM_latch_in), .seg2_orig_in(seg2_orig_RrAg_MEM_latch_in), .seg3_orig_in(seg3_orig_RrAg_MEM_latch_in), .seg4_orig_in(seg4_orig_RrAg_MEM_latch_in),
        .inst_ptcid_in(inst_ptcid_RrAg_MEM_latch_in),
        .op1_in(op1_RrAg_MEM_latch_in), .op2_in(op2_RrAg_MEM_latch_in), .op3_in(op3_RrAg_MEM_latch_in), .op4_in(op4_RrAg_MEM_latch_in),
        .dest1_in(dest1_RrAg_MEM_latch_in), .dest2_in(dest2_RrAg_MEM_latch_in), .dest3_in(dest3_RrAg_MEM_latch_in), .dest4_in(dest4_RrAg_MEM_latch_in),
        .res1_ld_in(res1_ld_RrAg_MEM_latch_in), .res2_ld_in(res2_ld_RrAg_MEM_latch_in),
        .res3_ld_in(res3_ld_RrAg_MEM_latch_in), .res4_ld_in(res4_ld_RrAg_MEM_latch_in),
        .rep_num_in(rep_num_RrAg_MEM_latch_in), .is_rep_in(is_rep_RrAg_MEM_latch_in),
        .aluk_in(aluk_RrAg_MEM_latch_in),
        .mux_adder_in(mux_adder_RrAg_MEM_latch_in),
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_in), .mux_shift_in(mux_shift_RrAg_MEM_latch_in),
        .p_op_in(p_op_RrAg_MEM_latch_in),
        .fmask_in(fmask_RrAg_MEM_latch_in),
        .CS_in(CS_RrAg_MEM_latch_in), //TODO RN
        .conditionals_in(conditionals_RrAg_MEM_latch_in),
        .is_br_in(is_br_RrAg_MEM_latch_in), .is_fp_in(is_fp_RrAg_MEM_latch_in), .is_imm_in(is_imm_RrAg_MEM_latch_in),
        .imm_in(imm_RrAg_MEM_latch_in),
        .mem1_rw_in(mem1_rw_RrAg_MEM_latch_in), .mem2_rw_in(mem2_rw_RrAg_MEM_latch_in),
        .eip_in(eip_RrAg_MEM_latch_in),
        .latched_eip_in(latched_eip_RrAg_MEM_latch_in), 
        .IE_in(IE_RrAg_MEM_latch_in),
        .IE_type_in(IE_type_RrAg_MEM_latch_in),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_in),
        .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_in),
        
        //outputs
        .valid_out(valid_RrAg_MEM_latch_out), .opsize_out(opsize_RrAg_MEM_latch_out),
        .mem_addr1_out(mem_addr1_RrAg_MEM_latch_out), .mem_addr2_out(mem_addr2_RrAg_MEM_latch_out), .mem_addr1_end_out(mem_addr1_end_RrAg_MEM_latch_out), .mem_addr2_end_out(mem_addr2_end_RrAg_MEM_latch_out),
        .reg1_out(reg1_RrAg_MEM_latch_out), .reg2_out(reg2_RrAg_MEM_latch_out), .reg3_out(reg3_RrAg_MEM_latch_out), .reg4_out(reg4_RrAg_MEM_latch_out),
        .ptc_r1_out(ptc_r1_RrAg_MEM_latch_out), .ptc_r2_out(ptc_r2_RrAg_MEM_latch_out), .ptc_r3_out(ptc_r3_RrAg_MEM_latch_out), .ptc_r4_out(ptc_r4_RrAg_MEM_latch_out),
        .reg1_orig_out(reg1_orig_RrAg_MEM_latch_out), .reg2_orig_out(reg2_orig_RrAg_MEM_latch_out), .reg3_orig_out(reg3_orig_RrAg_MEM_latch_out), .reg4_orig_out(reg4_orig_RrAg_MEM_latch_out),
        .seg1_out(seg1_RrAg_MEM_latch_out), .seg2_out(seg2_RrAg_MEM_latch_out), .seg3_out(seg3_RrAg_MEM_latch_out), .seg4_out(seg4_RrAg_MEM_latch_out),
        .ptc_s1_out(ptc_s1_RrAg_MEM_latch_out), .ptc_s2_out(ptc_s2_RrAg_MEM_latch_out), .ptc_s3_out(ptc_s3_RrAg_MEM_latch_out), .ptc_s4_out(ptc_s4_RrAg_MEM_latch_out),
        .seg1_orig_out(seg1_orig_RrAg_MEM_latch_out), .seg2_orig_out(seg2_orig_RrAg_MEM_latch_out), .seg3_orig_out(seg3_orig_RrAg_MEM_latch_out), .seg4_orig_out(seg4_orig_RrAg_MEM_latch_out),
        .inst_ptcid_out(inst_ptcid_RrAg_MEM_latch_out),
        .op1_out(op1_RrAg_MEM_latch_out), .op2_out(op2_RrAg_MEM_latch_out), .op3_out(op3_RrAg_MEM_latch_out), .op4_out(op4_RrAg_MEM_latch_out),
        .dest1_out(dest1_RrAg_MEM_latch_out), .dest2_out(dest2_RrAg_MEM_latch_out), .dest3_out(dest3_RrAg_MEM_latch_out), .dest4_out(dest4_RrAg_MEM_latch_out),
        .res1_ld_out(res1_ld_RrAg_MEM_latch_out), .res2_ld_out(res2_ld_RrAg_MEM_latch_out),
        .res3_ld_out(res3_ld_RrAg_MEM_latch_out), .res4_ld_out(res4_ld_RrAg_MEM_latch_out),
        .rep_num_out(rep_num_RrAg_MEM_latch_out), .is_rep_out(is_rep_RrAg_MEM_latch_out),
        .aluk_out(aluk_RrAg_MEM_latch_out),
        .mux_adder_out(mux_adder_RrAg_MEM_latch_out),
        .mux_and_int_out(mux_and_int_RrAg_MEM_latch_out), .mux_shift_out(mux_shift_RrAg_MEM_latch_out),
        .p_op_out(p_op_RrAg_MEM_latch_out),
        .fmask_out(fmask_RrAg_MEM_latch_out),
        .CS_out(CS_RrAg_MEM_latch_out), //TODO RN
        .conditionals_out(conditionals_RrAg_MEM_latch_out),
        .is_br_out(is_br_RrAg_MEM_latch_out), .is_fp_out(is_fp_RrAg_MEM_latch_out), .is_imm_out(is_imm_RrAg_MEM_latch_out), 
        .imm_out(imm_RrAg_MEM_latch_out),
        .mem1_rw_out(mem1_rw_RrAg_MEM_latch_out), .mem2_rw_out(mem2_rw_RrAg_MEM_latch_out),
        .eip_out(eip_RrAg_MEM_latch_out),
        .latched_eip_out(latched_eip_RrAg_MEM_latch_out),
        .IE_out(IE_RrAg_MEM_latch_out),
        .IE_type_out(IE_type_RrAg_MEM_latch_out),
        .BR_pred_target_out(BR_pred_target_RrAg_MEM_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_RrAg_MEM_latch_out)
    );

    mem m1 (
        //inputs
        .valid_in(valid_RrAg_MEM_latch_out),
        .fwd_stall(MEM_EX_Latches_full), // receive from MEM_EX_Queued_Latches
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
        .inst_ptcid_in(inst_ptcid_RrAg_MEM_latch_out),
        .op1_sel(op1_RrAg_MEM_latch_out),
        .op2_sel(op2_RrAg_MEM_latch_out),
        .op3_sel(op3_RrAg_MEM_latch_out),
        .op4_sel(op4_RrAg_MEM_latch_out),
        .dest1_sel(dest1_RrAg_MEM_latch_out),
        .dest2_sel(dest2_RrAg_MEM_latch_out),
        .dest3_sel(dest3_RrAg_MEM_latch_out),
        .dest4_sel(dest4_RrAg_MEM_latch_out),
        .res1_ld_in(res1_ld_RrAg_MEM_latch_out), .res2_ld_in(res2_ld_RrAg_MEM_latch_out),
        .res3_ld_in(res3_ld_RrAg_MEM_latch_out), .res4_ld_in(res4_ld_RrAg_MEM_latch_out),
        .rep_num(rep_num_RrAg_MEM_latch_out),
        .is_rep_in(is_rep_RrAg_MEM_latch_out),
        .VP_in(VP), .PF_in(PF),
        .entry_v_in(entry_v), .entry_P_in(entry_P), .entry_RW_in(entry_RW), .entry_PCD_in(entry_PCD),
        .aluk_in(aluk_RrAg_MEM_latch_out), .mux_adder_in(mux_adder_RrAg_MEM_latch_out), 
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_out), .mux_shift_in(mux_shift_RrAg_MEM_latch_out),
        .p_op_in(p_op_RrAg_MEM_latch_out), .fmask_in(fmask_RrAg_MEM_latch_out),
        .CS_in(CS_RrAg_MEM_latch_out),
        .conditionals_in(conditionals_RrAg_MEM_latch_out), .is_br_in(is_br_RrAg_MEM_latch_out), 
        .is_fp_in(is_fp_RrAg_MEM_latch_out), .is_imm_in(is_imm_RrAg_MEM_latch_out),
        .imm(imm_RrAg_MEM_latch_out), .mem1_rw(mem1_rw_RrAg_MEM_latch_out), .mem2_rw(mem2_rw_RrAg_MEM_latch_out),
        .eip_in(eip_RrAg_MEM_latch_out), .latched_eip_in(latched_eip_RrAg_MEM_latch_out),
        .IE_in(IE_RrAg_MEM_latch_out), .IE_type_in(IE_type_RrAg_MEM_latch_out),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_out),
        .clr(global_reset), .clk(clk),
        //outputs
        .valid_out(valid_MEM_EX_latch_in),
        .eip_out(EIP_MEM_EX_latch_in),
        .latched_eip_out(latched_eip_MEM_EX_latch_in),
        .IE_out(IE_MEM_EX_latch_in),
        .IE_type_out(IE_type_MEM_EX_latch_in),
        .BR_pred_target_out(BR_pred_target_MEM_EX_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_MEM_EX_latch_in),
        .opsize_out(opsize_MEM_EX_latch_in),
        .res1_ld_out(res1_ld_MEM_EX_latch_in),
        .res2_ld_out(res2_ld_MEM_EX_latch_in),
        .res3_ld_out(res3_ld_MEM_EX_latch_in),
        .res4_ld_out(res4_ld_MEM_EX_latch_in),
        .inst_ptcid_out(inst_ptcid_MEM_EX_latch_in), 
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
        .dest4_is_reg(res4_is_reg_MEM_EX_latch_in),
        .dest1_is_seg(res1_is_seg_MEM_EX_latch_in),
        .dest2_is_seg(res2_is_seg_MEM_EX_latch_in),
        .dest3_is_seg(res3_is_seg_MEM_EX_latch_in),
        .dest4_is_seg(res4_is_seg_MEM_EX_latch_in),
        .dest1_is_mem(res1_is_mem_MEM_EX_latch_in), .dest2_is_mem(res2_is_mem_MEM_EX_latch_in), 
        .dest3_is_mem(res3_is_mem_MEM_EX_latch_in), .dest4_is_mem(res4_is_mem_MEM_EX_latch_in),
        .aluk_out(aluk_MEM_EX_latch_in), .mux_adder_out(MUX_ADDER_IMM_MEM_EX_latch_in), 
        .mux_and_int_out(MUX_AND_INT_MEM_EX_latch_in), .mux_shift_out(MUX_SHIFT_MEM_EX_latch_in),
        .p_op_out(P_OP_MEM_EX_latch_in), .fmask_out(FMASK_MEM_EX_latch_in), .conditionals_out(conditionals_MEM_EX_latch_in), 
        .is_br_out(isBR_MEM_EX_latch_in), .is_fp_out(is_fp_MEM_EX_latch_in), .is_imm_out(is_imm_MEM_EX_latch_in), 
        .is_rep_out(is_rep_MEM_EX_latch_in), 
        .CS_out(CS_MEM_EX_latch_in),
        .wake_out(wake_MEM_EX_latch_in),
        .stall(MEM_stall_out) //send to RrAg and RrAg_MEM_latch
    );        
        
    
    wire [m_size_MEM_EX-1:0] m_din_MEM_EX;
    wire [n_size_MEM_EX-1:0] n_din_MEM_EX;

    assign m_din_MEM_EX = { inst_ptcid_MEM_EX_latch_in, wake_MEM_EX_latch_in, op1_MEM_EX_latch_in, op2_MEM_EX_latch_in, op3_MEM_EX_latch_in, op4_MEM_EX_latch_in, 
                            op1_ptcinfo_MEM_EX_latch_in, op2_ptcinfo_MEM_EX_latch_in, op3_ptcinfo_MEM_EX_latch_in, op4_ptcinfo_MEM_EX_latch_in,
                            valid_MEM_EX_latch_in
                          };

    assign n_din_MEM_EX = { is_rep_MEM_EX_latch_in, is_imm_MEM_EX_latch_in, EIP_MEM_EX_latch_in, latched_eip_MEM_EX_latch_in, IE_MEM_EX_latch_in, 
                            IE_type_MEM_EX_latch_in, BR_pred_target_MEM_EX_latch_in, BR_pred_T_NT_MEM_EX_latch_in,
                            opsize_MEM_EX_latch_in, dest1_addr_MEM_EX_latch_in, dest2_addr_MEM_EX_latch_in, dest3_addr_MEM_EX_latch_in, dest4_addr_MEM_EX_latch_in, 
                            res1_is_reg_MEM_EX_latch_in, res2_is_reg_MEM_EX_latch_in, res3_is_reg_MEM_EX_latch_in, res4_is_reg_MEM_EX_latch_in,
                            res1_is_seg_MEM_EX_latch_in, res2_is_seg_MEM_EX_latch_in, res3_is_seg_MEM_EX_latch_in, res4_is_seg_MEM_EX_latch_in,
                            res1_is_mem_MEM_EX_latch_in, res2_is_mem_MEM_EX_latch_in, res3_is_mem_MEM_EX_latch_in, res4_is_mem_MEM_EX_latch_in,
                            res1_ld_MEM_EX_latch_in, res2_ld_MEM_EX_latch_in, res3_ld_MEM_EX_latch_in, res4_ld_MEM_EX_latch_in, 
                            aluk_MEM_EX_latch_in, MUX_ADDER_IMM_MEM_EX_latch_in, MUX_AND_INT_MEM_EX_latch_in, MUX_SHIFT_MEM_EX_latch_in, P_OP_MEM_EX_latch_in,
                            FMASK_MEM_EX_latch_in, conditionals_MEM_EX_latch_in, isBR_MEM_EX_latch_in, is_fp_MEM_EX_latch_in, CS_MEM_EX_latch_in
                          };
    
    wire MEM_EX_Latch_RD; 
    nand2$ n2001 (.out(MEM_EX_Latch_RD), .in0(valid_EX_WB_latch_in), .in1(EX_stall_out));

    MEM_EX_Queued_Latches #(.M_WIDTH(m_size_MEM_EX), .N_WIDTH(n_size_MEM_EX), .Q_LENGTH(8)) q5 (
        .m_din(m_din_MEM_EX), .n_din(n_din_MEM_EX), .new_m_vector(/*TODO*/), 
        .wr(valid_MEM_EX_latch_in), .rd(MEM_EX_Latch_RD),
        .modify_vector(8'b0), .clr(global_reset), .clk(clk), .full(MEM_EX_Latches_full), .empty(MEM_EX_Latches_empty), .old_m_vector(/*TODO*/), 
            .dout({
                inst_ptcid_MEM_EX_latch_out, wake_MEM_EX_latch_out, op1_MEM_EX_latch_out, op2_MEM_EX_latch_out, op3_MEM_EX_latch_out, op4_MEM_EX_latch_out, 
                op1_ptcinfo_MEM_EX_latch_out, op2_ptcinfo_MEM_EX_latch_out, op3_ptcinfo_MEM_EX_latch_out, op4_ptcinfo_MEM_EX_latch_out,
                valid_MEM_EX_latch_out, is_rep_MEM_EX_latch_out, is_imm_MEM_EX_latch_out, EIP_MEM_EX_latch_out, latched_eip_MEM_EX_latch_out, IE_MEM_EX_latch_out, IE_type_MEM_EX_latch_out, BR_pred_target_MEM_EX_latch_out, BR_pred_T_NT_MEM_EX_latch_out,
                opsize_MEM_EX_latch_out, dest1_addr_MEM_EX_latch_out, dest2_addr_MEM_EX_latch_out, dest3_addr_MEM_EX_latch_out, dest4_addr_MEM_EX_latch_out, 
                res1_is_reg_MEM_EX_latch_out, res2_is_reg_MEM_EX_latch_out, res3_is_reg_MEM_EX_latch_out, res4_is_reg_MEM_EX_latch_out,
                res1_is_seg_MEM_EX_latch_out, res2_is_seg_MEM_EX_latch_out, res3_is_seg_MEM_EX_latch_out, res4_is_seg_MEM_EX_latch_out,
                res1_is_mem_MEM_EX_latch_out, res2_is_mem_MEM_EX_latch_out, res3_is_mem_MEM_EX_latch_out, res4_is_mem_MEM_EX_latch_out,
                res1_ld_MEM_EX_latch_out, res2_ld_MEM_EX_latch_out, res3_ld_MEM_EX_latch_out, res4_ld_MEM_EX_latch_out, 
                aluk_MEM_EX_latch_out, MUX_ADDER_IMM_MEM_EX_latch_out, MUX_AND_INT_MEM_EX_latch_out, MUX_SHIFT_MEM_EX_latch_out, P_OP_MEM_EX_latch_out,
                FMASK_MEM_EX_latch_out, conditionals_MEM_EX_latch_out, isBR_MEM_EX_latch_out, is_fp_MEM_EX_latch_out, CS_MEM_EX_latch_out }
             )
    );

    execute_TOP e1 (
        .clk(clk),
        .fwd_stall(fwd_stall_WB_EX_out), //TODO: recieve from WB
        .valid_in(valid_MEM_EX_latch_out),
        .latch_empty(MEM_EX_Latches_empty),
        .EIP_in(EIP_MEM_EX_latch_out),
        .latched_EIP_in(latched_eip_MEM_EX_latch_out),
        .IE_in(IE_MEM_EX_latch_out),  
        .IE_type_in(IE_type_MEM_EX_latch_out),
        .BR_pred_target_in(BR_pred_target_MEM_EX_latch_out),     
        .BR_pred_T_NT_in(BR_pred_T_NT_MEM_EX_latch_out),        
        .set(global_set), .rst(global_reset),
        .PTCID_in(inst_ptcid_MEM_EX_latch_out),

        .res1_ld_in(res1_ld_MEM_EX_latch_out), .res2_ld_in(res2_ld_MEM_EX_latch_out),
        .res3_ld_in(res3_ld_MEM_EX_latch_out), .res4_ld_in(res4_ld_MEM_EX_latch_out),
        .op1(op1_MEM_EX_latch_out), .op2(op2_MEM_EX_latch_out),
        .op3(op2_MEM_EX_latch_out), .op4(op4_MEM_EX_latch_out),
        .op1_ptcinfo(op1_ptcinfo_MEM_EX_latch_out), .op2_ptcinfo(op2_ptcinfo_MEM_EX_latch_out),
        .op3_ptcinfo(op3_ptcinfo_MEM_EX_latch_out), .op4_ptcinfo(op4_ptcinfo_MEM_EX_latch_out),
        .wake_in(wake_MEM_EX_latch_out),
        .dest1_addr(dest1_addr_MEM_EX_latch_out), .dest2_addr(dest2_addr_MEM_EX_latch_out), 
        .dest3_addr(dest3_addr_MEM_EX_latch_out), .dest4_addr(dest4_addr_MEM_EX_latch_out),
        .res1_is_reg_in(res1_is_reg_MEM_EX_latch_out), .res2_is_reg_in(res2_is_reg_MEM_EX_latch_out),
        .res3_is_reg_in(res3_is_reg_MEM_EX_latch_out), .res4_is_reg_in(res4_is_reg_MEM_EX_latch_out),
        .res1_is_seg_in(res1_is_seg_MEM_EX_latch_out), .res2_is_seg_in(res2_is_seg_MEM_EX_latch_out),
        .res3_is_seg_in(res3_is_seg_MEM_EX_latch_out), .res4_is_seg_in(res4_is_seg_MEM_EX_latch_out),
        .res1_is_mem_in(res1_is_mem_MEM_EX_latch_out), .res2_is_mem_in(res2_is_mem_MEM_EX_latch_out), 
        .res3_is_mem_in(res3_is_mem_MEM_EX_latch_out), .res4_is_mem_in(res4_is_mem_MEM_EX_latch_out),
        .opsize_in(opsize_MEM_EX_latch_out),
        
        .aluk(aluk_MEM_EX_latch_out),
        .MUX_ADDER_IMM(MUX_ADDER_IMM_MEM_EX_latch_out),
        .MUX_AND_INT(MUX_AND_INT_MEM_EX_latch_out),
        .MUX_SHIFT(MUX_SHIFT_MEM_EX_latch_out),
        .P_OP(P_OP_MEM_EX_latch_out),
        .FMASK(FMASK_MEM_EX_latch_out),
        .conditionals(conditionals_MEM_EX_latch_out),
        .isImm(is_imm_MEM_EX_latch_out),
        .isBR(isBR_MEM_EX_latch_out),
        .is_fp(is_fp_MEM_EX_latch_out), 
        .is_rep_in(is_rep_MEM_EX_latch_out),
        .CS(CS_MEM_EX_latch_out),
        
        //outputs:
        .valid_out(valid_EX_WB_latch_in), //TODO: implement
        .EIP_out(EIP_EX_WB_latch_in),
        .latched_EIP_out(),
        .IE_out(IE_EX_WB_latch_in),
        .IE_type_out(IE_type_EX_WB_latch_in),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_in),
        .PTCID_out(inst_ptcid_EX_WB_latch_in),
        .is_rep_out(is_rep_EX_WB_latch_in),

        .eflags(EFLAGS_EX_WB_latch_in),
        .CS_out(CS_EX_WB_latch_in),
        .P_OP_out(P_OP_EX_WB_latch_in),
        
        .res1_wb(inp1_wb_EX_WB_latch_in),            .res2_wb(inp2_wb_EX_WB_latch_in),
        .res3_wb(inp3_wb_EX_WB_latch_in),            .res4_wb(inp4_wb_EX_WB_latch_in),
        .res1(inp1_EX_WB_latch_in),                  .res2(inp2_EX_WB_latch_in),            
        .res3(inp3_EX_WB_latch_in),                  .res4(inp4_EX_WB_latch_in),
        .res1_ptcinfo(inp1_ptcinfo_EX_WB_latch_in),  .res2_ptcinfo(inp2_ptcinfo_EX_WB_latch_in),    
        .res3_ptcinfo(inp3_ptcinfo_EX_WB_latch_in),  .res4_ptcinfo(inp4_ptcinfo_EX_WB_latch_in),
        .res1_is_reg_out(inp1_isReg_EX_WB_latch_in), .res2_is_reg_out(inp2_isReg_EX_WB_latch_in), 
        .res3_is_reg_out(inp3_isReg_EX_WB_latch_in), .res4_is_reg_out(inp4_isReg_EX_WB_latch_in), 
        .res1_is_seg_out(inp1_isSeg_EX_WB_latch_in), .res2_is_seg_out(inp2_isSeg_EX_WB_latch_in), 
        .res3_is_seg_out(inp3_isSeg_EX_WB_latch_in), .res4_is_seg_out(inp4_isSeg_EX_WB_latch_in), 
        .res1_is_mem_out(inp1_isMem_EX_WB_latch_in), .res2_is_mem_out(inp2_isMem_EX_WB_latch_in), 
        .res3_is_mem_out(inp3_isMem_EX_WB_latch_in), .res4_is_mem_out(inp4_isMem_EX_WB_latch_in),
        .res1_dest(inp1_dest_EX_WB_latch_in),        .res2_dest(inp2_dest_EX_WB_latch_in),       
        .res3_dest(inp3_dest_EX_WB_latch_in),        .res4_dest(inp4_dest_EX_WB_latch_in), 
        .ressize(inpsize_EX_WB_latch_in), 

        .BR_valid(BR_valid_EX_WB_latch_in), 
        .BR_taken(BR_taken_EX_WB_latch_in),
        .BR_correct(BR_correct_EX_WB_latch_in), 
        .BR_FIP(BR_FIP_EX_WB_latch_in), 
        .BR_FIP_p1(BR_FIP_p1_EX_WB_latch_in),
        .stall(EX_stall_out) //send stall to MEM_EX_Queued_Latches
    );

    //TODO: stall signal is negative logic, so need to invert when passing to queued latches
    wire EX_WB_latch_LD;
    inv1$ i2i31nfkdas(.out(EX_WB_latch_LD), .in(EX_stall_out));

    E_WB_latch e_w_latch(
        //inputs 
        .ld(EX_WB_latch_LD), .clr(global_reset),
        .clk(clk),

        .valid_in(valid_EX_WB_latch_in),
        .EIP_in(EIP_EX_WB_latch_in),
        .latched_EIP_in(), 
        .IE_in(IE_EX_WB_latch_in),
        .IE_type_in(IE_type_EX_WB_latch_in),
        .BR_pred_target_in(BR_pred_target_EX_WB_latch_in),
        .BR_pred_T_NT_in(BR_pred_T_NT_EX_WB_latch_in),
        .PTCID_in(inst_ptcid_EX_WB_latch_in),
        .is_rep_in(is_rep_EX_WB_latch_in),

        .eflags_in(EFLAGS_EX_WB_latch_in),
        .CS_in(CS_EX_WB_latch_in), 
        .P_OP_in(P_OP_EX_WB_latch_in),

        .res1_wb_in(inp1_wb_EX_WB_latch_in), .res2_wb_in(inp2_wb_EX_WB_latch_in), .res3_wb_in(inp3_wb_EX_WB_latch_in), .res4_wb_in(inp4_wb_EX_WB_latch_in),
        .res1_in(inp1_EX_WB_latch_in), .res2_in(inp2_EX_WB_latch_in), .res3_in(inp3_EX_WB_latch_in), .res4_in(inp4_EX_WB_latch_in), //done
        .res1_ptcinfo_in(inp1_ptcinfo_EX_WB_latch_in), .res2_ptcinfo_in(inp2_ptcinfo_EX_WB_latch_in), 
        .res3_ptcinfo_in(inp3_ptcinfo_EX_WB_latch_in), .res4_ptcinfo_in(inp4_ptcinfo_EX_WB_latch_in),
        .res1_is_reg_in(inp1_isReg_EX_WB_latch_in), .res2_is_reg_in(inp2_isReg_EX_WB_latch_in), 
        .res3_is_reg_in(inp3_isReg_EX_WB_latch_in), .res4_is_reg_in(inp4_isReg_EX_WB_latch_in), //done
        .res1_is_seg_in(inp1_isSeg_EX_WB_latch_in), .res2_is_seg_in(inp2_isSeg_EX_WB_latch_in), 
        .res3_is_seg_in(inp3_isSeg_EX_WB_latch_in), .res4_is_seg_in(inp4_isSeg_EX_WB_latch_in), //done
        .res1_is_mem_in(inp1_isMem_EX_WB_latch_in), .res2_is_mem_in(inp2_isMem_EX_WB_latch_in), 
        .res3_is_mem_in(inp3_isMem_EX_WB_latch_in), .res4_is_mem_in(inp4_isMem_EX_WB_latch_in), //done
        .res1_dest_in(inp1_dest_EX_WB_latch_in), .res2_dest_in(inp2_dest_EX_WB_latch_in), 
        .res3_dest_in(inp3_dest_EX_WB_latch_in), .res4_dest_in(inp4_dest_EX_WB_latch_in), //
        .ressize_in(inpsize_EX_WB_latch_in), 

        .BR_valid_in(BR_valid_EX_WB_latch_in),
        .BR_taken_in(BR_taken_EX_WB_latch_in),
        .BR_correct_in(BR_correct_EX_WB_latch_in), 
        .BR_FIP_in(BR_FIP_EX_WB_latch_in), .BR_FIP_p1_in(BR_FIP_p1_EX_WB_latch_in),

        //outputs
        .valid_out(valid_EX_WB_latch_out),
        .EIP_out(EIP_EX_WB_latch_out),
        .latched_EIP_out(),
        .IE_out(IE_EX_WB_latch_out),
        .IE_type_out(IE_type_EX_WB_latch_out),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_out),
        .PTCID_out(inst_ptcid_EX_WB_latch_out),
        .is_rep_out(is_rep_EX_WB_latch_out),

        .eflags_out(EFLAGS_EX_WB_latch_out),
        .CS_out(CS_EX_WB_latch_out),
        .P_OP_out(P_OP_EX_WB_latch_out),

        .res1_wb_out(inp1_wb_EX_WB_latch_out), .res2_wb_out(inp2_wb_EX_WB_latch_out), .res3_wb_out(inp3_wb_EX_WB_latch_out), .res4_wb_out(inp4_wb_EX_WB_latch_out),
        .res1_out(inp1_EX_WB_latch_out), .res2_out(inp2_EX_WB_latch_out), .res3_out(inp3_EX_WB_latch_out), .res4_out(inp4_EX_WB_latch_out), //done
        .res1_ptcinfo_out(inp1_ptcinfo_EX_WB_latch_out), .res2_ptcinfo_out(inp2_ptcinfo_EX_WB_latch_out), 
        .res3_ptcinfo_out(inp3_ptcinfo_EX_WB_latch_out), .res4_ptcinfo_out(inp4_ptcinfo_EX_WB_latch_out),
        .res1_is_reg_out(inp1_isReg_EX_WB_latch_out), .res2_is_reg_out(inp2_isReg_EX_WB_latch_out), 
        .res3_is_reg_out(inp3_isReg_EX_WB_latch_out), .res4_is_reg_out(inp4_isReg_EX_WB_latch_out), //done
        .res1_is_seg_out(inp1_isSeg_EX_WB_latch_out), .res2_is_seg_out(inp2_isSeg_EX_WB_latch_out), 
        .res3_is_seg_out(inp3_isSeg_EX_WB_latch_out), .res4_is_seg_out(inp4_isSeg_EX_WB_latch_out), //done
        .res1_is_mem_out(inp1_isMem_EX_WB_latch_out), .res2_is_mem_out(inp2_isMem_EX_WB_latch_out), 
        .res3_is_mem_out(inp3_isMem_EX_WB_latch_out), .res4_is_mem_out(inp4_isMem_EX_WB_latch_out), //done
        .res1_dest_out(inp1_dest_EX_WB_latch_out), .res2_dest_out(inp2_dest_EX_WB_latch_out), 
        .res3_dest_out(inp3_dest_EX_WB_latch_out), .res4_dest_out(inp4_dest_EX_WB_latch_out), //
        .ressize_out(inpsize_EX_WB_latch_out), 

        .BR_valid_out(BR_valid_EX_WB_latch_out),
        .BR_taken_out(BR_taken_EX_WB_latch_out),
        .BR_correct_out(BR_correct_EX_WB_latch_out), 
        .BR_FIP_out(BR_FIP_EX_WB_latch_out), .BR_FIP_p1_out(BR_FIP_p1_EX_WB_latch_out)
    );
    

    //TODO: implement BP_alias from out of decode to WB !!!!!!!!!!!
    writeback_TOP wb_inst(
        .clk(clk),
        .valid_in(valid_EX_WB_latch_out),
        .EIP_in(EIP_EX_WB_latch_out),
        .latched_EIP_in(),
        .IE_in(IE_EX_WB_latch_out),                           //interrupt or exception signal
        .IE_type_in(IE_type_EX_WB_latch_out),
        .BR_pred_target_in(BR_pred_target_EX_WB_latch_out),
        .BR_pred_T_NT_in(BR_pred_T_NT_EX_WB_latch_out),
        .BP_alias_in(),
        .inst_ptcid_in(inst_ptcid_EX_WB_latch_out),
        .set(), .rst(global_reset),

        .inp1_wb(inp1_wb_EX_WB_latch_out), .inp2_wb(inp2_wb_EX_WB_latch_out), .inp3_wb(inp3_wb_EX_WB_latch_out), .inp4_wb(inp4_wb_EX_WB_latch_out),
        .inp1(inp1_EX_WB_latch_out), .inp2(inp2_EX_WB_latch_out), .inp3(inp3_EX_WB_latch_out), .inp4(inp4_EX_WB_latch_out),
        .inp1_ptcinfo(inp1_ptcinfo_EX_WB_latch_out), .inp2_ptcinfo(inp2_ptcinfo_EX_WB_latch_out), 
        .inp3_ptcinfo(inp3_ptcinfo_EX_WB_latch_out), .inp4_ptcinfo(inp4_ptcinfo_EX_WB_latch_out),
        .inp1_isReg(inp1_isReg_EX_WB_latch_out),  .inp2_isReg(inp2_isReg_EX_WB_latch_out), 
        .inp3_isReg(inp3_isReg_EX_WB_latch_out),  .inp4_isReg(inp4_isReg_EX_WB_latch_out),
        .inp1_isSeg(inp1_isSeg_EX_WB_latch_out),  .inp2_isSeg(inp2_isSeg_EX_WB_latch_out), 
        .inp3_isSeg(inp3_isSeg_EX_WB_latch_out),  .inp4_isSeg(inp4_isSeg_EX_WB_latch_out),
        .inp1_isMem(inp1_isMem_EX_WB_latch_out),  .inp2_isMem(inp2_isMem_EX_WB_latch_out), 
        .inp3_isMem(inp3_isMem_EX_WB_latch_out),  .inp4_isMem(inp4_isMem_EX_WB_latch_out),  
        .inp1_dest(inp1_dest_EX_WB_latch_out), .inp2_dest(inp2_dest_EX_WB_latch_out), 
        .inp3_dest(inp3_dest_EX_WB_latch_out), .inp4_dest(inp4_dest_EX_WB_latch_out),
        .inpsize(inpsize_EX_WB_latch_out),

        .BR_valid_in(BR_valid_EX_WB_latch_out), .BR_taken_in(BR_taken_EX_WB_latch_out), .BR_correct_in(BR_correct_EX_WB_latch_out),
        .BR_FIP_in(BR_FIP_EX_WB_latch_out), .BR_FIP_p1_in(BR_FIP_p1_EX_WB_latch_out),

        .CS_in(CS_EX_WB_latch_out),
        .EFLAGS_in(EFLAGS_EX_WB_latch_out),
        .P_OP(P_OP_EX_WB_latch_out),

        .interrupt_in(),

        .wbaq_full(1'b0), .is_rep(is_rep_EX_WB_latch_out),

        .valid_out(),

        .res1(res1_WB_RRAG_out), .res2(res2_WB_RRAG_out), .res3(res3_WB_RRAG_out), .res4(res4_WB_RRAG_out), .mem_data(mem_data_WB_M_out), //done
        .res1_ptcinfo(res1_ptcinfo_WB_RRAG_out), .res2_ptcinfo(res2_ptcinfo_WB_RRAG_out), .res3_ptcinfo(res3_ptcinfo_WB_RRAG_out), .res4_ptcinfo(res4_ptcinfo_WB_RRAG_out),
        .ressize(ressize_WB_RRAG_out), .memsize(memsize_WB_M_out),
        .reg_addr(reg_addr_WB_RRAG_out), .seg_addr(seg_addr_WB_RRAG_out),
        .mem_addr(mem_addr_WB_M_out), //done
        .reg_ld(reg_ld_WB_RRAG_out), .seg_ld(seg_ld_WB_RRAG_out),
        .mem_ld(mem_ld_WB_M_out),
        .inst_ptcid_out(inst_ptcid_out_WB_RRAG_out),

        .newFIP_e(), .newFIP_o(), .newEIP(), //done 
        .latched_EIP_out(),
        .BR_valid(), .BR_taken(), .BR_correct(), //done
        .WB_BP_update_alias(),
        .is_resteer(),
        .CS_out(), //done

        .stall(fwd_stall_WB_EX_out),

        .final_IE_val(),
        .final_IE_type()
    );

 endmodule