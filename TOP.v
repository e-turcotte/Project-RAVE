 module TOP();
    localparam CYCLE_TIME = 15;
    localparam CYCLE_TIME_BUS = CYCLE_TIME / 2.0;
    
    integer file;
    reg clk;
    reg bus_clk;
    integer cycle_number;

    localparam m_size_D_RrAg = 1;
    localparam n_size_D_RrAg = 409;
    
    localparam m_size_MEM_EX = 780;
    localparam n_size_MEM_EX = 860; //858 with instr is idtr push

    initial begin
        file = $fopen("debug.out", "w");
        cycle_number = 0;
        $vcdplusfile("processor.dump.vpd");
        $vcdpluson(0, TOP); 
    end

    initial begin
        bus_clk = 1'b1;
        forever #(CYCLE_TIME_BUS / 2.0) bus_clk = ~bus_clk;
    end

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end
    inv1$ icg1(halts_n, halts);
    always @(posedge clk) begin
        cycle_number = cycle_number + 1;
        $fdisplay(file, "Cycle number: %d", cycle_number);
    end

    // reg [127:0] packet;
    // reg D_valid;

    //TODO: TLB Initializations
    reg [19:0] VP_0, VP_1, VP_2, VP_3, VP_4, VP_5, VP_6, VP_7;
	reg [19:0] PF_0, PF_1, PF_2, PF_3, PF_4, PF_5, PF_6, PF_7;
	reg [7:0] entry_v;
	reg [7:0] entry_P;
	reg [7:0] entry_RW;
    reg [7:0] entry_PCD;
	reg [159:0] VP, PF; //concats of VP_7 to VP_0 and PF_7 to PF_0

    //TODO: SegFile Initializations
    reg [19:0] ES_LIM, CS_LIM, SS_LIM, DS_LIM, FS_LIM, GS_LIM;

    //TODO: Core initializations:
    reg global_reset;
    reg global_set;
    reg global_init;
    reg [31:0] EIP_init;
    reg [31:0] IDTR_base;

    initial begin
        // D_valid = 1'b1;
        // packet = 128'h0432_0000_0000_0000_0000_0000_0000_0000;
        global_reset = 0;
        global_set = 1;
        IDTR_base = 32'h02000000;
        global_init = 0;
        //initialize TLB
        VP_0 = 20'h00000;
		VP_1 = 20'h02000; // - IDTR
		VP_2 = 20'h04000;
		VP_3 = 20'h0b000;
		VP_4 = 20'h0c000;
        //VP_4 = 20'h0b001; //for test2a
		VP_5 = 20'h0a000;
		VP_6 = 20'h06000;
		VP_7 = 20'h03000;

		PF_0 = 20'h00000; //00000000 = x00
		PF_1 = 20'h00002; //01000000 = x40 - IDTR
		PF_2 = 20'h00005; //10100000 = xa0
		PF_3 = 20'h00004; //10000000 = x80
		PF_4 = 20'h00007; //11100000 = xe0
		PF_5 = 20'h00005; //11000000 = xc0
		PF_6 = 20'h00006; //10100000 = xa0
		PF_7 = 20'h00003; //01100000 = x60

		entry_v = 8'b11111111;
		entry_P = 8'b11111111;
		entry_RW= 8'b11111110;
		entry_PCD =  8'b10000000;

		VP = {VP_7, VP_6, VP_5, VP_4, VP_3, VP_2, VP_1, VP_0};
		PF = {PF_7, PF_6, PF_5, PF_4, PF_3, PF_2, PF_1, PF_0};

        ES_LIM = 20'h003ff;
        CS_LIM = 20'h04fff;
        SS_LIM = 20'h04000;
        DS_LIM = 20'h011ff;
        FS_LIM = 20'h003ff;
        GS_LIM = 20'h007ff;

        #(CYCLE_TIME)
        global_reset = 1;
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #(CYCLE_TIME)
        #10000

        $finish;

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
    wire valid_F_D_latch_in;
    wire [127:0] packet_F_D_latch_in;
    wire [7:0] BP_alias_F_D_latch_in;
    wire IE_F_D_latch_in;
    wire [3:0] IE_type_F_D_latch_in;
    wire [31:0] BR_pred_target_F_D_latch_in;
    wire BR_pred_T_NT_F_D_latch_in;
    wire instr_is_IDTR_orig_F_D_latch_in;
    wire IDTR_is_POP_EFLAGS_F_D_latch_in;


    ///////////////////////////////////////////////////////////
    //         Outputs from F_D_latch that go into D:       //  
    //////////////////////////////////////////////////////////
    wire valid_F_D_latch_out;
    wire [127:0] packet_F_D_latch_out;
    wire [7:0] BP_alias_F_D_latch_out;
    wire IE_F_D_latch_out;
    wire [3:0] IE_type_F_D_latch_out;
    wire [31:0] BR_pred_target_F_D_latch_out;
    wire BR_pred_T_NT_F_D_latch_out;
    wire instr_is_IDTR_orig_F_D_latch_out;
    wire IDTR_is_POP_EFLAGS_F_D_latch_out;

    ///////////////////////////////////////////////////////////
    //    Outputs from D that go into the D_RrAg_latch:     //  
    //////////////////////////////////////////////////////////
    //output to go to fetch
    wire [7:0] D_length_D_F_out;

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
    wire [7:0]  BP_alias_D_RrAg_latch_in;
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
    wire [3:0]  memSizeOVR_D_RrAg_latch_in;
    wire        instr_is_IDTR_orig_D_RrAg_latch_in;

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
    wire [7:0]  BP_alias_D_RrAg_latch_out;
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
    wire [3:0]  memSizeOVR_D_RrAg_latch_out;
    wire        instr_is_IDTR_orig_D_RrAg_latch_out;

    ///////////////////////////////////////////////////////////
    // Outputs from Rr/Ag that go into the RrAg_MEM_latch:  //  
    //////////////////////////////////////////////////////////
    
    wire         valid_RrAg_MEM_latch_in;
    wire [1:0]   opsize_RrAg_MEM_latch_in;
    wire [31:0]  mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in, latched_EIP_end_RrAg_MEM_latch_in;
    wire         mem1_end_is_valid_RrAg_MEM_latch_in, mem2_end_is_valid_RrAg_MEM_latch_in;  
    wire         latched_EIP_end_is_valid_RrAg_MEM_latch_in;
    wire [63:0]  reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in;
    wire [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in;
    wire [2:0]   reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in;
    wire [15:0]  seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in;
    wire [31:0]  ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in;
    wire [19:0] seg1_lim_RrAg_MEM_latch_in, seg2_lim_RrAg_MEM_latch_in, seg3_lim_RrAg_MEM_latch_in, seg4_lim_RrAg_MEM_latch_in;
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
    wire [7:0]   BP_alias_RrAg_MEM_latch_in;
    wire [3:0]  memSizeOVR_RrAg_MEM_latch_in;
    wire        instr_is_IDTR_orig_RrAg_MEM_latch_in;
    
    ///////////////////////////////////////////////////////////
    //   Outputs from RrAg_MEM_latch that go into the MEM:  //  
    //////////////////////////////////////////////////////////

    wire         valid_RrAg_MEM_latch_out;
    wire [1:0]   opsize_RrAg_MEM_latch_out;
    wire [31:0]  mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out, latched_EIP_end_RrAg_MEM_latch_out;
    wire         mem1_end_is_valid_RrAg_MEM_latch_out, mem2_end_is_valid_RrAg_MEM_latch_out, latched_EIP_end_is_valid_RrAg_MEM_latch_out;
    wire [63:0]  reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out;
    wire [127:0] ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out;
    wire [2:0]   reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out;
    wire [15:0]  seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out;
    wire [31:0]  ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out;
    wire [19:0] seg1_lim_RrAg_MEM_latch_out, seg2_lim_RrAg_MEM_latch_out, seg3_lim_RrAg_MEM_latch_out, seg4_lim_RrAg_MEM_latch_out;
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
    wire [7:0]   BP_alias_RrAg_MEM_latch_out;
    wire [3:0]   memSizeOVR_RrAg_MEM_latch_out;
    wire        instr_is_IDTR_orig_RrAg_MEM_latch_out;

    ///////////////////////////////////////////////////////////
    //     Outputs from MEM that go into MEM_EX_latch:      //  
    //////////////////////////////////////////////////////////

    wire         valid_MEM_EX_latch_in;
    wire [31:0]  EIP_MEM_EX_latch_in;
    wire [31:0]  latched_eip_MEM_EX_latch_in;
    wire         IE_MEM_EX_latch_in;
    wire [3:0]   IE_type_MEM_EX_latch_in;
    wire         instr_is_IDTR_orig_MEM_EX_latch_in;
    wire [31:0]  BR_pred_target_MEM_EX_latch_in;
    wire         BR_pred_T_NT_MEM_EX_latch_in;
    wire [7:0]   BP_alias_MEM_EX_latch_in;
 
    wire         res1_ld_MEM_EX_latch_in, res2_ld_MEM_EX_latch_in, res3_ld_MEM_EX_latch_in, res4_ld_MEM_EX_latch_in;
    wire [63:0]  op1_MEM_EX_latch_in, op2_MEM_EX_latch_in, op3_MEM_EX_latch_in, op4_MEM_EX_latch_in;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_in, op2_ptcinfo_MEM_EX_latch_in, op3_ptcinfo_MEM_EX_latch_in, op4_ptcinfo_MEM_EX_latch_in;
    wire [31:0]  dest1_addr_MEM_EX_latch_in, dest2_addr_MEM_EX_latch_in, dest3_addr_MEM_EX_latch_in, dest4_addr_MEM_EX_latch_in;
    wire [127:0] dest1_ptcinfo_MEM_EX_latch_in, dest2_ptcinfo_MEM_EX_latch_in, dest3_ptcinfo_MEM_EX_latch_in, dest4_ptcinfo_MEM_EX_latch_in;
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
    wire [6:0]   inst_ptcid_MEM_EX_latch_in;
    wire [3:0]  memSizeOVR_MEM_EX_latch_in;
    

    ///////////////////////////////////////////////////////////
    //     Outputs from MEM_EX_latch that go into EX:        //  
    //////////////////////////////////////////////////////////

    wire         valid_MEM_EX_latch_out;
    wire [31:0]  EIP_MEM_EX_latch_out;
    wire [31:0]  latched_eip_MEM_EX_latch_out;
    wire         IE_MEM_EX_latch_out;
    wire [3:0]   IE_type_MEM_EX_latch_out;
    wire         instr_is_IDTR_orig_MEM_EX_latch_out;
    wire [31:0]  BR_pred_target_MEM_EX_latch_out;
    wire         BR_pred_T_NT_MEM_EX_latch_out;
    wire [7:0]   BP_alias_MEM_EX_latch_out;

    wire         res1_ld_MEM_EX_latch_out, res2_ld_MEM_EX_latch_out, res3_ld_MEM_EX_latch_out, res4_ld_MEM_EX_latch_out;
    wire [63:0]  op1_MEM_EX_latch_out, op2_MEM_EX_latch_out, op3_MEM_EX_latch_out, op4_MEM_EX_latch_out;
    wire [127:0] op1_ptcinfo_MEM_EX_latch_out, op2_ptcinfo_MEM_EX_latch_out, op3_ptcinfo_MEM_EX_latch_out, op4_ptcinfo_MEM_EX_latch_out;
    wire [31:0]  dest1_addr_MEM_EX_latch_out, dest2_addr_MEM_EX_latch_out, dest3_addr_MEM_EX_latch_out, dest4_addr_MEM_EX_latch_out;
    wire [127:0] dest1_ptcinfo_MEM_EX_latch_out, dest2_ptcinfo_MEM_EX_latch_out, dest3_ptcinfo_MEM_EX_latch_out, dest4_ptcinfo_MEM_EX_latch_out;
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
    wire [3:0]  memSizeOVR_MEM_EX_latch_out;

    ///////////////////////////////////////////////////////////
    //     Outputs from Ex that go into the EX_WB_Latch:    //  
    //////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_in;
    wire [17:0] eflags_old;
    wire [31:0] EIP_EX_WB_latch_in;
    wire [31:0] latched_eip_EX_WB_latch_in;
    wire        IE_EX_WB_latch_in;
    wire [3:0]  IE_type_EX_WB_latch_in;
    wire        instr_is_IDTR_orig_EX_WB_latch_in;
    wire [31:0] BR_pred_target_EX_WB_latch_in;
    wire BR_pred_T_NT_EX_WB_latch_in;
    wire [6:0] inst_ptcid_EX_WB_latch_in;
    wire [31:0] latched_latched_EIP_WB_out;

    wire [63:0] inp1_EX_WB_latch_in, inp2_EX_WB_latch_in, inp3_EX_WB_latch_in, inp4_EX_WB_latch_in;
    wire  inp1_isReg_EX_WB_latch_in,  inp2_isReg_EX_WB_latch_in, inp3_isReg_EX_WB_latch_in,  inp4_isReg_EX_WB_latch_in;
    wire  inp1_isSeg_EX_WB_latch_in,  inp2_isSeg_EX_WB_latch_in, inp3_isSeg_EX_WB_latch_in,  inp4_isSeg_EX_WB_latch_in;
    wire  inp1_isMem_EX_WB_latch_in,  inp2_isMem_EX_WB_latch_in, inp3_isMem_EX_WB_latch_in,  inp4_isMem_EX_WB_latch_in;
    wire [31:0] inp1_dest_EX_WB_latch_in, inp2_dest_EX_WB_latch_in, inp3_dest_EX_WB_latch_in, inp4_dest_EX_WB_latch_in;
    wire [1:0] inpsize_EX_WB_latch_in;
    wire inp1_wb_EX_WB_latch_in, inp2_wb_EX_WB_latch_in, inp3_wb_EX_WB_latch_in, inp4_wb_EX_WB_latch_in;
    wire [127:0] inp1_ptcinfo_EX_WB_latch_in, inp2_ptcinfo_EX_WB_latch_in, inp3_ptcinfo_EX_WB_latch_in, inp4_ptcinfo_EX_WB_latch_in;
    wire [127:0] dest1_ptcinfo_EX_WB_latch_in, dest2_ptcinfo_EX_WB_latch_in, dest3_ptcinfo_EX_WB_latch_in, dest4_ptcinfo_EX_WB_latch_in;

    wire BR_valid_EX_WB_latch_in, BR_taken_EX_WB_latch_in, BR_correct_EX_WB_latch_in;
    wire[31:0] BR_FIP_EX_WB_latch_in, BR_FIP_p1_EX_WB_latch_in;
    wire[15:0] CS_EX_WB_latch_in;
    wire [17:0] EFLAGS_EX_WB_latch_in;
    wire [36:0] P_OP_EX_WB_latch_in;
    wire is_rep_EX_WB_latch_in;
    wire [7:0] BP_alias_EX_WB_latch_in;
    wire [3:0]  memSizeOVR_EX_WB_latch_in;

    ///////////////////////////////////////////////////////////
    //     Outputs from EX_WB_Latch that go into the WB:    //  
    //////////////////////////////////////////////////////////

    wire valid_EX_WB_latch_out;
    wire [31:0] EIP_EX_WB_latch_out;
    wire [31:0]  latched_eip_EX_WB_latch_out;
    wire IE_EX_WB_latch_out;
    wire [3:0] IE_type_EX_WB_latch_out;
    wire       instr_is_IDTR_orig_EX_WB_latch_out;
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
    wire [127:0] dest1_ptcinfo_EX_WB_latch_out, dest2_ptcinfo_EX_WB_latch_out, dest3_ptcinfo_EX_WB_latch_out, dest4_ptcinfo_EX_WB_latch_out;

    wire BR_valid_EX_WB_latch_out, BR_taken_EX_WB_latch_out, BR_correct_EX_WB_latch_out;
    wire[31:0] BR_FIP_EX_WB_latch_out, BR_FIP_p1_EX_WB_latch_out;
    wire[15:0] CS_EX_WB_latch_out;
    wire [17:0] EFLAGS_EX_WB_latch_out;
    wire [36:0] P_OP_EX_WB_latch_out;
    wire is_rep_EX_WB_latch_out;
    wire [7:0] BP_alias_EX_WB_latch_out;
    wire [3:0]  memSizeOVR_EX_WB_latch_out;

    ///////////////////////////////////////////////////////////
    //     Outputs from WB that go everywhere:              //
    //////////////////////////////////////////////////////////
    wire fwd_stall_WB_EX_out;
    wire is_valid_WB_out;
    wire [63:0] res1_WB_RRAG_out, res2_WB_RRAG_out, res3_WB_RRAG_out, res4_WB_RRAG_out, mem_data_WB_M_out; //done
    wire [127:0] res1_ptcinfo_WB_RRAG_out, res2_ptcinfo_WB_RRAG_out, res3_ptcinfo_WB_RRAG_out, res4_ptcinfo_WB_RRAG_out;
    wire [1:0] ressize_WB_RRAG_out, memsize_WB_M_out;
    wire [11:0] reg_addr_WB_RRAG_out, seg_addr_WB_RRAG_out;
    wire [31:0] mem_addr_WB_M_out; //done
    wire [3:0] reg_ld_WB_RRAG_out, seg_ld_WB_RRAG_out;
    wire mem_ld_WB_M_out, wbaq_isfull_WB_M_in;
    wire [6:0] inst_ptcid_out_WB_RRAG_out;
    wire [7:0] WB_BP_update_alias;
    wire [31:0] newFIP_e_WB_out, newFIP_o_WB_out;
    wire [31:0] newEIP_WB_out, latched_EIP_WB_out, EIP_WB_out;
    wire [31:0] latched_eip_WB_out;
    wire [31:0] latched_latched_eip_WB_out;
    wire [31:0] latched_latched_latched_eip_WB_out;
    wire is_resteer_WB_out;
    wire BR_valid_WB_BP_out, BR_taken_WB_BP_out, BR_correct_WB_BP_out;
    wire final_IE_val;
    wire [2:0] final_IE_type;
    wire [3:0] IE_type_WB_out;
    wire [17:0] final_EFLAGS;
    wire [15:0] final_CS;

    ////////////////////////////////////////////////////////////////
    //     Outputs from BP that go to the everywhere in frontend://
    ///////////////////////////////////////////////////////////////
    wire [31:0] BP_EIP_BTB_out;
    wire is_BR_T_NT_BP_out;
    wire [27:0] BP_FIP_e_BTB_out, BP_FIP_o_BTB_out;
    wire [7:0] BP_update_alias_out;

    ////////////////////////////////////////////////////////////////
    //     Outputs from IDTR that go to the everywhere:           //
    ///////////////////////////////////////////////////////////////

    wire [127:0] IDTR_packet_out;
    wire IDTR_packet_select_out;
    wire IDTR_PTC_out;
    wire IDTR_is_POP_EFLAGS;
    wire IDTR_LD_EIP_out;
    wire IDTR_flush_pipe;
    wire is_servicing_IE;
    wire idtr_ptc_clear_out;
    wire IDTR_is_switching;
    wire IDTR_LD_info_regs;
    wire IDTR_invalidate_fetch_out;

    wire IDTR_PTC_clear; //AND with signal to lower PTC_CLEAR out of WB for resteer.

    wire instr_is_IDTR_switch_final_WB;
    wire is_iretd_WB_out;

    /////////////////////////////////////////////////////////////////
    //                   offcoreBus inputs/outputs                //
    ///////////////////////////////////////////////////////////////
    wire freeIE, freeIO, freeDE, freeDO, reqIE, reqIO, reqDEr, reqDEw, 
        reqDOr, reqDOw, relIE, relIO, relDEr, relDEw, relDOr, relDOw;
    wire [3:0] destIE, destIO, destDEr, destDEw, destDOr, destDOw;
    wire [72:0] BUS;
    wire ackIE, ackIO, ackDEr, ackDEw, ackDOr, ackDOw, grantIE, grantIO, 
        grantDEr, grantDEw, grantDOr, grantDOw, recvIE, recvIO, recvDE, recvDO;

    wire interrupt;

    offcoreBus_TOP offcoreBus(
        .clk(clk),
        .rst(global_reset),
        .set(global_set),
        .clk_bus(bus_clk),
        
        .freeIE(freeIE),
        .freeIO(freeIO),
        .freeDE(freeDE),
        .freeDO(freeDO),
        .reqIE(reqIE),
        .reqIO(reqIO),
        .reqDEr(reqDEr),//tied to 0 for testing
        .reqDEw(reqDEw),//tied to 0 for testing
        .reqDOr(reqDOr),//tied to 0 for testing
        .reqDOw(reqDOw),//tied to 0 for testing
        .relIE(relIE),
        .relIO(relIO), 
        .relDEr(relDEr), 
        .relDEw(relDEw), 
        .relDOr(relDOr), 
        .relDOw(relDOw),

        .destIE(destIE), 
        .destIO(destIO), 
        .destDEr(destDEr),
        .destDEw(destDEw), 
        .destDOr(destDOr), 
        .destDOw(destDOw),

        .BUS(BUS),

        .ackIE(ackIE), 
        .ackIO(ackIO), 
        .ackDEr(ackDEr), 
        .ackDEw(ackDEw), 
        .ackDOr(ackDOr), 
        .ackDOw(ackDOw),
        .grantIE(grantIE), 
        .grantIO(grantIO), 
        .grantDEr(grantDEr), 
        .grantDEw(grantDEw), 
        .grantDOr(grantDOr), 
        .grantDOw(grantDOw),
        .recvIE(recvIE), 
        .recvIO(recvIO), 
        .recvDE(recvDE), 
        .recvDO(recvDO),
        .interrupt_out(interrupt)
    );
    IDTR_FSM_2 IDTR( //TODO: PRAY
    .clk(clk),
    .rst(global_reset),
    .rrag_stall(D_RrAg_Latches_full),
    .is_IE(final_IE_val),
    .is_IRET(is_iretd_WB_out),
    .IE_type_in(final_IE_type),
    .IDTR_base_address(IDTR_base),
    .valid_wb(valid_EX_WB_latch_out),
    .cs_WB(final_CS),
    .eip_WB(latched_eip_WB_out),
    .eflags_EX_old(eflags_old),
    .OP1_wb(res1_WB_RRAG_out),
    .P_OP_wb(P_OP_EX_WB_latch_out),
    .P_OP_1_2_override(P_OP_1_2_override_idtr),
    .P_OP_21_22_override (P_OP_21_22_override_idtr),
    .P_OP_22_23_override (P_OP_22_23_override_idtr),
    .invalidate_op1_wb(invalidate_op1_wb_idtr),
    .packet_out(IDTR_packet_out),
    .packet_select(IDTR_packet_select_out),
    .flush_pipe(IDTR_flush_pipe),
    .PTC_clear(idtr_ptc_clear_out),
    .allow_fetch(IDTR_invalidate_fetch_out)
    );
    assign IDTR_is_POP_EFLAGS = 0;
    assign is_servicing_IE = 0;
    assign IDTR_is_switching = 0;
    assign IDTR_LD_info_regs = 0;
    // IE_handler IDTR(
    //     .clk(clk),
    //     .reset(global_reset),
    //     .enable(1'b1), //im not sure when it should be disabled but its here if u need
    //     .IE_in(final_IE_val),
    //     .IE_type_in(final_IE_type),
    //     .IDTR_base_address(IDTR_base),
    //     .EIP_WB(latched_eip_WB_out),
    //     .EFLAGS_WB(final_EFLAGS),
    //     .CS_WB(final_CS),
    //     .is_resteer(is_resteer_WB_out),
    //     .is_IRETD(is_iretd_WB_out),
    //     .rrag_stall_in(D_RrAg_Latches_full),
    //     .is_final_switch_instr_WB(instr_is_IDTR_switch_final_WB),
    
    //     .IDTR_packet_out(IDTR_packet_out),
    //     .packet_out_select(IDTR_packet_select_out),
    //     .flush_pipe(IDTR_flush_pipe),
    //     .PTC_clear(idtr_ptc_clear_out),
    //     .LD_EIP(IDTR_LD_EIP_out),
    //     .is_POP_EFLAGS(IDTR_is_POP_EFLAGS),
    //     .is_servicing_IE(is_servicing_IE),
    //     .is_switching(IDTR_is_switching),
    //     .LD_info_regs_out(IDTR_LD_info_regs),
    //     .invalidate_fetch_out(IDTR_invalidate_fetch_out)
    // );

    wire btb_hit;
    wire LD_btb;
    andn #(.NUM_INPUTS(2)) and2(.in({is_valid_WB_out, BR_valid_WB_BP_out}), .out(LD_btb));
    bp_btb BPstuff(
        .clk(clk),
        .reset(global_reset),
        .eip(latched_eip_D_RrAg_latch_in),
        .prev_BR_result(BR_taken_WB_BP_out),
        .prev_BR_alias(WB_BP_update_alias),
        .prev_is_BR(BR_valid_WB_BP_out),
        .prev_BR_correct(BR_correct_WB_BP_out),
        .LD(LD_btb),
        .is_D_valid(valid_out_D_RrAg_latch_in),
        .is_WB_valid(is_valid_WB_out),

        .btb_update_eip_WB(latched_eip_WB_out), //EIP of BR instr, passed from D
        .FIP_E_WB(newFIP_e_WB_out), 
        .FIP_O_WB(newFIP_o_WB_out), 
        .EIP_WB(newEIP_WB_out), //update, from WB

        .prediction(is_BR_T_NT_BP_out),
        .BP_update_alias_out(BP_update_alias_out),

        .FIP_E_target(BP_FIP_e_BTB_out),
        .FIP_O_target(BP_FIP_o_BTB_out),
        .EIP_target(BP_EIP_BTB_out),
        .btb_miss(),
        .btb_hit(btb_hit)
    );

    wire is_BR_T_NT_BP_out_and_btb_hit;
    andn #(.NUM_INPUTS(2)) and1(.in({is_BR_T_NT_BP_out, btb_hit}), .out(is_BR_T_NT_BP_out_and_btb_hit));
    
    /*TODO: SIGNAL FOR CLEARING LATCHES*/
    wire WB_to_clr_latches_resteer, WB_to_clr_latches_resteer_active_low;
    orn #(4) hi1(.in( {IDTR_flush_pipe, is_resteer_WB_out, final_IE_val, is_iretd_WB_out} ), .out(WB_to_clr_latches_resteer)); 
    inv1$ sdhfkjh4o2r02ur09u0(.in(WB_to_clr_latches_resteer), .out(WB_to_clr_latches_resteer_active_low));

    fetch_TOP f0(
        .clk(clk),
        .clk_ng(clk),
        .set(global_set),
        .reset(global_reset),
        .bus_clk(bus_clk),
        .cs(CS_RrAg_MEM_latch_in),

        .D_length(D_length_D_F_out),
        .stall(D_stall_out),

        .WB_FIP_o(newFIP_o_WB_out),
        .WB_FIP_e(newFIP_e_WB_out),
        .WB_BIP(newEIP_WB_out[5:0]),
        .resteer(is_resteer_WB_out),// comment out bp

        .BP_FIP_o(BP_FIP_o_BTB_out),
        .BP_FIP_e(BP_FIP_e_BTB_out),
        .BP_BIP(BP_EIP_BTB_out[5:0]),
        .is_BR_T_NT(is_BR_T_NT_BP_out_and_btb_hit), //TODO : change this if testing BP
        .BP_update_alias(BP_update_alias_out), //
        .BP_target(BP_EIP_BTB_out), //

        .init_addr(),
        .is_init(global_init),

        .IDTR_packet(IDTR_packet_out),
        .packet_select(IDTR_packet_select_out),
        .WB_IE_val(final_IE_val),
        .IDTR_LD_info_regs(IDTR_LD_info_regs),
        .IDTR_is_POP_EFLAGS_in(IDTR_is_POP_EFLAGS),
        .IDTR_invalidate_fetch(IDTR_invalidate_fetch_out),

        .SER_i$_grant_e(grantIE),
        .SER_i$_grant_o(grantIO),
        .SER_i$_release_o(relIO),
        .SER_i$_req_o(reqIO),
        .SER_i$_release_e(relIE),
        .SER_i$_req_e(reqIE),
        .DES_i$_reciever_e(recvIE),
        .DES_i$_reciever_o(recvIO),
        .SER_i$_ack_e(ackIE),
        .SER_i$_ack_o(ackIO),
        .DES_i$_free_o(freeIO),
        .DES_i$_free_e(freeIE),
        .SER_dest_o(destIO),
        .SER_dest_e(destIE),

        .BUS(BUS),

        .protection_exception_e(),
        .TLB_MISS_EXCEPTION_e(),
        .protection_exception_o(),
        .TLB_MISS_EXCEPTION_o(),
        .VP(VP),
        .PF(PF),
        .TLB_entry_V(entry_v),
        .TLB_entry_P(entry_P),
        .TLB_entry_RW(entry_RW),
        .TLB_entry_PCD(entry_PCD),

        .packet_out(packet_F_D_latch_in),
        .packet_valid_out(valid_F_D_latch_in),
        .is_BR_T_NT_out(BR_pred_T_NT_F_D_latch_in),
        .BP_target_out(BR_pred_target_F_D_latch_in),
        .BP_update_alias_out(BP_alias_F_D_latch_in),

        .IE_out(IE_F_D_latch_in),
        .IE_type_out(IE_type_F_D_latch_in),
        .instr_is_IDTR_orig(instr_is_IDTR_orig_F_D_latch_in),
        .IDTR_is_POP_EFLAGS_out(IDTR_is_POP_EFLAGS_F_D_latch_in)
    );

    wire F_D_latch_LD;
    inv1$ eddiesmassivetushy(.out(F_D_latch_LD), .in(D_stall_out));

    wire F_D_latch_clr;
    andn #(.NUM_INPUTS(2)) momma(.in({global_reset, WB_to_clr_latches_resteer_active_low}), .out(F_D_latch_clr));

    F_D_latch f1(
        .ld(F_D_latch_LD),
        .clk(clk),
        .clr(F_D_latch_clr),

        .valid_in(valid_F_D_latch_in),
        .packet_in(packet_F_D_latch_in),
        .BP_alias_in(BP_alias_F_D_latch_in),
        .IE_in(IE_F_D_latch_in), //TODO: IE_F_D_latch_in, hardcoded for now as no IE
        .IE_type_in(IE_type_F_D_latch_in), //TODO: IE_type_F_D_latch_in
        .BR_pred_target_in(BR_pred_target_F_D_latch_in),
        .BR_pred_T_NT_in(BR_pred_T_NT_F_D_latch_in),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_F_D_latch_in),
        .IDTR_is_POP_EFLAGS_in(IDTR_is_POP_EFLAGS_F_D_latch_in),
        .P_OP_1_2_override_in(P_OP_1_2_override_idtr),
        .P_OP_21_22_override_in(P_OP_21_22_override_idtr),
        .P_OP_22_23_override_in(P_OP_22_23_override_idtr),
        .invalidate_op1_wb_in(invalidate_op1_wb_idtr),
         //outputs
        .valid_out(valid_F_D_latch_out),
        .packet_out(packet_F_D_latch_out),
        .BP_alias_out(BP_alias_F_D_latch_out),
        .IE_out(IE_F_D_latch_out),
        .IE_type_out(IE_type_F_D_latch_out),
        .BR_pred_target_out(BR_pred_target_F_D_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_F_D_latch_out),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_F_D_latch_out),
        .IDTR_is_POP_EFLAGS_out(IDTR_is_POP_EFLAGS_F_D_latch_out),
        .P_OP_1_2_override(  P_OP_1_2_override_F_D_LATCH),
        .P_OP_21_22_override(P_OP_21_22_override_F_D_LATCH),
        .P_OP_22_23_override(P_OP_22_23_override_F_D_LATCH),
        .invalidate_op1_wb(  invalidate_op1_wb_F_D_LATCH)
    );

    wire IDTR_is_POP_EFLAGS_D_out;
    wire [36:0] p_op_D_out;
    decode_TOP d0(
        // Clock and Reset
        .clk(clk),
        .reset(global_reset),
    
        // Signals from fetch_2
        .valid_in(valid_F_D_latch_out),
        .packet_in(packet_F_D_latch_out),

        .IE_in(IE_F_D_latch_out),
        .IE_type_in(IE_type_F_D_latch_out),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_F_D_latch_out),
        .IDTR_is_POP_EFLAGS_in(IDTR_is_POP_EFLAGS_F_D_latch_out),
        // .BP_alias_in(BP_alias_F_D_latch_out),
        // .BR_pred_target_in(BR_pred_target_F_D_latch_out),
        // .BR_pred_T_NT_in(BR_pred_T_NT_F_D_latch_out),
        .P_OP_1_2_override(P_OP_1_2_override_F_D_LATCH),
        .P_OP_21_22_override(P_OP_21_22_override_F_D_LATCH),
        .P_OP_22_23_override(P_OP_22_23_override_F_D_LATCH),
        .invalidate_op1_wb(invalidate_op1_wb_F_D_LATCH),


        // Signals from BP
        .BP_EIP(BP_EIP_BTB_out),
        .is_BR_T_NT(is_BR_T_NT_BP_out_and_btb_hit),
        .BP_alias_in(BP_update_alias_out),
        .BP_BR_pred_target_in(BP_EIP_BTB_out),
    
        // Writeback signals
        .WB_EIP(newEIP_WB_out),
        .is_resteer(is_resteer_WB_out),
    
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
        .BP_alias_out(BP_alias_D_RrAg_latch_in),

        .aluk_out(aluk_D_RrAg_latch_in),
        .mux_adder_out(mux_adder_D_RrAg_latch_in),
        .mux_and_int_out(mux_and_int_D_RrAg_latch_in),
        .mux_shift_out(mux_shift_D_RrAg_latch_in),
        .p_op_out(p_op_D_out),
        .fmask_out(fmask_D_RrAg_latch_in),
        .conditionals_out(conditionals_D_RrAg_latch_in),
        .is_br_out(is_br_D_RrAg_latch_in),
        .is_fp_out(is_fp_D_RrAg_latch_in),
        .imm_out(imm_D_RrAg_latch_in),
        .mem1_rw_out(mem1_rw_D_RrAg_latch_in),
        .mem2_rw_out(mem2_rw_D_RrAg_latch_in),
        .latched_eip_out(latched_eip_D_RrAg_latch_in),
        .eip_out(eip_D_RrAg_latch_in),
        .IE_out(IE_D_RrAg_latch_in),
        .IE_type_out(IE_type_D_RrAg_latch_in),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_D_RrAg_latch_in),
        .IDTR_is_POP_EFLAGS_out(IDTR_is_POP_EFLAGS_D_out),
        .BR_pred_target_out(BR_pred_target_D_RrAg_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_D_RrAg_latch_in),
        .isImm_out(is_imm_D_RrAg_latch_in),
        .memSizeOVR(memSizeOVR_D_RrAg_latch_in),
    
        // Outputs to fetch_2
        .stall_out(D_stall_out), //TODO: send to fetch_2
        .D_length(D_length_D_F_out)
    );

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(37)) pop_eflags_mux(.in({37'b0_0000_0000_0001_0000_0000_0000_0000_0000_0011, p_op_D_out}), .sel(IDTR_is_POP_EFLAGS_D_out), .out(p_op_D_RrAg_latch_in));
    
    wire [m_size_D_RrAg-1:0] m_din_D_RrAg;
    wire [n_size_D_RrAg-1:0] n_din_D_RrAg;

    assign m_din_D_RrAg = valid_out_D_RrAg_latch_in;
    assign n_din_D_RrAg = {instr_is_IDTR_orig_D_RrAg_latch_in, memSizeOVR_D_RrAg_latch_in, BP_alias_D_RrAg_latch_in, latched_eip_D_RrAg_latch_in, is_imm_D_RrAg_latch_in, reg_addr1_D_RrAg_latch_in, reg_addr2_D_RrAg_latch_in, reg_addr3_D_RrAg_latch_in, reg_addr4_D_RrAg_latch_in,
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
    inv1$ n2002 (.out(D_RrAg_Latch_RD), .in(RrAg_stall_out));

    wire D_RrAg_Latch_clr;
    andn #(.NUM_INPUTS(2)) n2amdl003 (.in({global_reset, WB_to_clr_latches_resteer_active_low}), .out(D_RrAg_Latch_clr));

    D_RrAg_Queued_Latches #(.M_WIDTH(m_size_D_RrAg), .N_WIDTH(n_size_D_RrAg), .Q_LENGTH(8)) q2 (
        .m_din(m_din_D_RrAg), .n_din(n_din_D_RrAg), .new_m_vector(), 
        .wr(valid_out_D_RrAg_latch_in), .rd(D_RrAg_Latch_RD), 
        .modify_vector(8'h0), .clr(D_RrAg_Latch_clr), .clk(clk), .full(D_RrAg_Latches_full), .empty(D_RrAg_Latches_empty), .old_m_vector(/*TODO*/), 
            .dout({valid_out_D_RrAg_latch_out, instr_is_IDTR_orig_D_RrAg_latch_out, memSizeOVR_D_RrAg_latch_out, BP_alias_D_RrAg_latch_out, latched_eip_D_RrAg_latch_out, is_imm_D_RrAg_latch_out, reg_addr1_D_RrAg_latch_out, reg_addr2_D_RrAg_latch_out, reg_addr3_D_RrAg_latch_out, reg_addr4_D_RrAg_latch_out,
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

        wire [63:0] reg1_rragdf, reg2_rragdf, reg3_rragdf, reg4_rragdf;
        wire [15:0] seg1_rragdf, seg2_rragdf, seg3_rragdf, seg4_rragdf;

        wire RrAg_MEM_latch_clr;
        andn #(.NUM_INPUTS(2)) n2amdl002 (.in({global_reset, WB_to_clr_latches_resteer_active_low}), .out(RrAg_MEM_latch_clr));
    
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
        .lim_init5(GS_LIM), .lim_init4(FS_LIM), .lim_init3(DS_LIM), .lim_init2(SS_LIM), .lim_init1(CS_LIM), .lim_init0(ES_LIM),
        .VP(VP), .PF(PF),
        .BP_alias_in(BP_alias_D_RrAg_latch_out), .aluk_in(aluk_D_RrAg_latch_out), .mux_adder_in(mux_adder_D_RrAg_latch_out), .mux_and_int_in(mux_and_int_D_RrAg_latch_out), .mux_shift_in(mux_shift_D_RrAg_latch_out),
        .p_op_in(p_op_D_RrAg_latch_out), .fmask_in(fmask_D_RrAg_latch_out), .conditionals_in(conditionals_D_RrAg_latch_out), .is_br_in(is_br_D_RrAg_latch_out), .is_fp_in(is_fp_D_RrAg_latch_out),
        .is_imm_in(is_imm_D_RrAg_latch_out), .imm_in(imm_D_RrAg_latch_out), .mem1_rw_in(mem1_rw_D_RrAg_latch_out), .mem2_rw_in(mem2_rw_D_RrAg_latch_out), .memsizeOVR_in(memSizeOVR_D_RrAg_latch_out),
        .latched_eip_in(latched_eip_D_RrAg_latch_out), .eip_in(eip_D_RrAg_latch_out),
        .IE_in(IE_D_RrAg_latch_out), .IE_type_in(IE_type_D_RrAg_latch_out), .instr_is_IDTR_orig_in(instr_is_IDTR_orig_D_RrAg_latch_out), .BR_pred_target_in(BR_pred_target_D_RrAg_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_D_RrAg_latch_out),
        .wb_data1(res1_WB_RRAG_out), .wb_data2(res2_WB_RRAG_out), .wb_data3(res3_WB_RRAG_out), .wb_data4(res4_WB_RRAG_out),
        .wb_segdata1(res1_WB_RRAG_out[15:0]), .wb_segdata2(res2_WB_RRAG_out[15:0]), .wb_segdata3(res3_WB_RRAG_out[15:0]), .wb_segdata4(res4_WB_RRAG_out[15:0]),
        .wb_addr1(reg_addr_WB_RRAG_out[2:0]), .wb_addr2(reg_addr_WB_RRAG_out[5:3]), .wb_addr3(reg_addr_WB_RRAG_out[8:6]), .wb_addr4(reg_addr_WB_RRAG_out[11:9]),
        .wb_segaddr1(seg_addr_WB_RRAG_out[2:0]), .wb_segaddr2(seg_addr_WB_RRAG_out[5:3]), .wb_segaddr3(seg_addr_WB_RRAG_out[8:6]), .wb_segaddr4(seg_addr_WB_RRAG_out[11:9]),
        .wb_opsize(ressize_WB_RRAG_out), .wb_regld(reg_ld_WB_RRAG_out), .wb_segld(seg_ld_WB_RRAG_out), .wb_inst_ptcid(inst_ptcid_out_WB_RRAG_out),
        .fwd_stall(MEM_stall_out), //recieve from MEM
        .ptc_clear(RrAg_MEM_latch_clr), //TODO: from IDTR      

        //outputs
        .valid_out(valid_RrAg_MEM_latch_in), .stall(RrAg_stall_out), //send to D_RrAg_Queued_Latches
        .opsize_out(opsize_RrAg_MEM_latch_in),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_in), .mem_addr2(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_in),
        .mem1_end_is_valid(mem1_end_is_valid_RrAg_MEM_latch_in), .mem2_end_is_valid(mem2_end_is_valid_RrAg_MEM_latch_in),
        .latched_EIP_end_is_valid(latched_EIP_end_is_valid_RrAg_MEM_latch_in), .latched_EIP_end_size(latched_EIP_end_RrAg_MEM_latch_in),
        .reg1(reg1_rragdf), .reg2(reg2_rragdf), .reg3(reg3_rragdf), .reg4(reg4_rragdf),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_in), .ptc_r2(ptc_r2_RrAg_MEM_latch_in), .ptc_r3(ptc_r3_RrAg_MEM_latch_in), .ptc_r4(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_in), .reg2_orig(reg2_orig_RrAg_MEM_latch_in), .reg3_orig(reg3_orig_RrAg_MEM_latch_in), .reg4_orig(reg4_orig_RrAg_MEM_latch_in),
        .seg1(seg1_rragdf), .seg2(seg2_rragdf), .seg3(seg3_rragdf), .seg4(seg4_rragdf),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_in), .ptc_s2(ptc_s2_RrAg_MEM_latch_in), .ptc_s3(ptc_s3_RrAg_MEM_latch_in), .ptc_s4(ptc_s4_RrAg_MEM_latch_in),
        .seg1_lim(seg1_lim_RrAg_MEM_latch_in), .seg2_lim(seg2_lim_RrAg_MEM_latch_in), .seg3_lim(seg3_lim_RrAg_MEM_latch_in), .seg4_lim(seg4_lim_RrAg_MEM_latch_in),
        .seg1_orig(seg1_orig_RrAg_MEM_latch_in), .seg2_orig(seg2_orig_RrAg_MEM_latch_in), .seg3_orig(seg3_orig_RrAg_MEM_latch_in), .seg4_orig(seg4_orig_RrAg_MEM_latch_in),
        .inst_ptcid(inst_ptcid_RrAg_MEM_latch_in),
        .op1_out(op1_RrAg_MEM_latch_in), .op2_out(op2_RrAg_MEM_latch_in), .op3_out(op3_RrAg_MEM_latch_in), .op4_out(op4_RrAg_MEM_latch_in),
        .dest1_out(dest1_RrAg_MEM_latch_in), .dest2_out(dest2_RrAg_MEM_latch_in), .dest3_out(dest3_RrAg_MEM_latch_in), .dest4_out(dest4_RrAg_MEM_latch_in),
        .res1_ld_out(res1_ld_RrAg_MEM_latch_in), .res2_ld_out(res2_ld_RrAg_MEM_latch_in), 
        .res3_ld_out(res3_ld_RrAg_MEM_latch_in), .res4_ld_out(res4_ld_RrAg_MEM_latch_in),
        .rep_num(rep_num_RrAg_MEM_latch_in), .is_rep_out(is_rep_RrAg_MEM_latch_in),
        .BP_alias_out(BP_alias_RrAg_MEM_latch_in),
        .aluk_out(aluk_RrAg_MEM_latch_in),
        .mux_adder_out(mux_adder_RrAg_MEM_latch_in),
        .mux_and_int_out(mux_and_int_RrAg_MEM_latch_in), .mux_shift_out(mux_shift_RrAg_MEM_latch_in),
        .p_op_out(p_op_RrAg_MEM_latch_in),
        .fmask_out(fmask_RrAg_MEM_latch_in),
        .CS_out(CS_RrAg_MEM_latch_in),
        .conditionals_out(conditionals_RrAg_MEM_latch_in),
        .is_br_out(is_br_RrAg_MEM_latch_in), .is_fp_out(is_fp_RrAg_MEM_latch_in), .is_imm_out(is_imm_RrAg_MEM_latch_in), 
        .imm_out(imm_RrAg_MEM_latch_in),
        .mem1_rw_out(mem1_rw_RrAg_MEM_latch_in), .mem2_rw_out(mem2_rw_RrAg_MEM_latch_in), .memsizeOVR_out(memSizeOVR_RrAg_MEM_latch_in),
        .latched_eip_out(latched_eip_RrAg_MEM_latch_in), .eip_out(eip_RrAg_MEM_latch_in), //TODO RN
        .IE_out(IE_RrAg_MEM_latch_in),
        .IE_type_out(IE_type_RrAg_MEM_latch_in),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_RrAg_MEM_latch_in), //HERE
        .BR_pred_target_out(BR_pred_target_RrAg_MEM_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_RrAg_MEM_latch_in)
    );

    wire [47:0] dummy_zero_collector;

    bypassmech #(.NUM_PROSPECTS(4), .NUM_OPERANDS(8)) rragdf(.prospective_data({res4_WB_RRAG_out,res3_WB_RRAG_out,res2_WB_RRAG_out,res1_WB_RRAG_out}), .prospective_ptc({res4_ptcinfo_WB_RRAG_out,res3_ptcinfo_WB_RRAG_out,res2_ptcinfo_WB_RRAG_out,res1_ptcinfo_WB_RRAG_out}),
                                                             .operand_data({reg4_rragdf,reg3_rragdf,reg2_rragdf,reg1_rragdf,
                                                                            48'h000000000000,seg4_rragdf,48'h000000000000,seg3_rragdf,48'h000000000000,seg2_rragdf,48'h000000000000,seg1_rragdf}),
                                                             .operand_ptc({ptc_r4_RrAg_MEM_latch_in,ptc_r3_RrAg_MEM_latch_in,ptc_r2_RrAg_MEM_latch_in,ptc_r1_RrAg_MEM_latch_in,
                                                                           96'h000000000000000000000000,ptc_s4_RrAg_MEM_latch_in,96'h000000000000000000000000,ptc_s3_RrAg_MEM_latch_in,
                                                                           96'h000000000000000000000000,ptc_s2_RrAg_MEM_latch_in,96'h000000000000000000000000,ptc_s1_RrAg_MEM_latch_in}),
                                                             .new_data({reg4_RrAg_MEM_latch_in,reg3_RrAg_MEM_latch_in,reg2_RrAg_MEM_latch_in,reg1_RrAg_MEM_latch_in,dummy_zero_collector,seg4_RrAg_MEM_latch_in,dummy_zero_collector,seg3_RrAg_MEM_latch_in,dummy_zero_collector,seg2_RrAg_MEM_latch_in,dummy_zero_collector,seg1_RrAg_MEM_latch_in}), .modify());
    
    wire RrAg_MEM_latch_LD;
    inv1$ n2000(.out(RrAg_MEM_latch_LD), .in(MEM_stall_out));

    RrAg_MEM_latch q4(
        //inputs
        .ld(RrAg_MEM_latch_LD), .clr(RrAg_MEM_latch_clr), // LD comes from MEM stalling 
        .clk(clk),
        .valid_in(valid_RrAg_MEM_latch_in), .opsize_in(opsize_RrAg_MEM_latch_in),
        .mem_addr1_in(mem_addr1_RrAg_MEM_latch_in), .mem_addr2_in(mem_addr2_RrAg_MEM_latch_in), .mem_addr1_end_in(mem_addr1_end_RrAg_MEM_latch_in), .mem_addr2_end_in(mem_addr2_end_RrAg_MEM_latch_in),
        .mem1_end_is_valid_in(mem1_end_is_valid_RrAg_MEM_latch_in), .mem2_end_is_valid_in(mem2_end_is_valid_RrAg_MEM_latch_in),
        .latched_EIP_end_in(latched_EIP_end_RrAg_MEM_latch_in), .latched_EIP_end_is_valid_in(latched_EIP_end_is_valid_RrAg_MEM_latch_in),
        .reg1_in(reg1_RrAg_MEM_latch_in), .reg2_in(reg2_RrAg_MEM_latch_in), .reg3_in(reg3_RrAg_MEM_latch_in), .reg4_in(reg4_RrAg_MEM_latch_in),
        .ptc_r1_in(ptc_r1_RrAg_MEM_latch_in), .ptc_r2_in(ptc_r2_RrAg_MEM_latch_in), .ptc_r3_in(ptc_r3_RrAg_MEM_latch_in), .ptc_r4_in(ptc_r4_RrAg_MEM_latch_in),
        .reg1_orig_in(reg1_orig_RrAg_MEM_latch_in), .reg2_orig_in(reg2_orig_RrAg_MEM_latch_in), .reg3_orig_in(reg3_orig_RrAg_MEM_latch_in), .reg4_orig_in(reg4_orig_RrAg_MEM_latch_in),
        .seg1_in(seg1_RrAg_MEM_latch_in), .seg2_in(seg2_RrAg_MEM_latch_in), .seg3_in(seg3_RrAg_MEM_latch_in), .seg4_in(seg4_RrAg_MEM_latch_in),
        .ptc_s1_in(ptc_s1_RrAg_MEM_latch_in), .ptc_s2_in(ptc_s2_RrAg_MEM_latch_in), .ptc_s3_in(ptc_s3_RrAg_MEM_latch_in), .ptc_s4_in(ptc_s4_RrAg_MEM_latch_in),
        .seg1_lim_in(seg1_lim_RrAg_MEM_latch_in), .seg2_lim_in(seg2_lim_RrAg_MEM_latch_in), .seg3_lim_in(seg3_lim_RrAg_MEM_latch_in), .seg4_lim_in(seg4_lim_RrAg_MEM_latch_in),
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
        .CS_in(CS_RrAg_MEM_latch_in),
        .conditionals_in(conditionals_RrAg_MEM_latch_in),
        .is_br_in(is_br_RrAg_MEM_latch_in), .is_fp_in(is_fp_RrAg_MEM_latch_in), .is_imm_in(is_imm_RrAg_MEM_latch_in),
        .imm_in(imm_RrAg_MEM_latch_in),
        .mem1_rw_in(mem1_rw_RrAg_MEM_latch_in), .mem2_rw_in(mem2_rw_RrAg_MEM_latch_in), .memsizeOVR_in(memSizeOVR_RrAg_MEM_latch_in),
        .eip_in(eip_RrAg_MEM_latch_in),
        .latched_eip_in(latched_eip_RrAg_MEM_latch_in), 
        .IE_in(IE_RrAg_MEM_latch_in),
        .IE_type_in(IE_type_RrAg_MEM_latch_in),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_RrAg_MEM_latch_in),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_in),
        .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_in),
        .BP_alias_in(BP_alias_RrAg_MEM_latch_in),
        
        //outputs
        .valid_out(valid_RrAg_MEM_latch_out), .opsize_out(opsize_RrAg_MEM_latch_out),
        .mem_addr1_out(mem_addr1_RrAg_MEM_latch_out), .mem_addr2_out(mem_addr2_RrAg_MEM_latch_out), .mem_addr1_end_out(mem_addr1_end_RrAg_MEM_latch_out), .mem_addr2_end_out(mem_addr2_end_RrAg_MEM_latch_out),
        .latched_EIP_end_out(latched_EIP_end_RrAg_MEM_latch_out), .latched_EIP_end_is_valid_out(latched_EIP_end_is_valid_RrAg_MEM_latch_out),
        .mem1_end_is_valid_out(mem1_end_is_valid_RrAg_MEM_latch_out), .mem2_end_is_valid_out(mem2_end_is_valid_RrAg_MEM_latch_out),
        .reg1_out(reg1_RrAg_MEM_latch_out), .reg2_out(reg2_RrAg_MEM_latch_out), .reg3_out(reg3_RrAg_MEM_latch_out), .reg4_out(reg4_RrAg_MEM_latch_out),
        .ptc_r1_out(ptc_r1_RrAg_MEM_latch_out), .ptc_r2_out(ptc_r2_RrAg_MEM_latch_out), .ptc_r3_out(ptc_r3_RrAg_MEM_latch_out), .ptc_r4_out(ptc_r4_RrAg_MEM_latch_out),
        .reg1_orig_out(reg1_orig_RrAg_MEM_latch_out), .reg2_orig_out(reg2_orig_RrAg_MEM_latch_out), .reg3_orig_out(reg3_orig_RrAg_MEM_latch_out), .reg4_orig_out(reg4_orig_RrAg_MEM_latch_out),
        .seg1_out(seg1_RrAg_MEM_latch_out), .seg2_out(seg2_RrAg_MEM_latch_out), .seg3_out(seg3_RrAg_MEM_latch_out), .seg4_out(seg4_RrAg_MEM_latch_out),
        .ptc_s1_out(ptc_s1_RrAg_MEM_latch_out), .ptc_s2_out(ptc_s2_RrAg_MEM_latch_out), .ptc_s3_out(ptc_s3_RrAg_MEM_latch_out), .ptc_s4_out(ptc_s4_RrAg_MEM_latch_out),
        .seg1_lim_out(seg1_lim_RrAg_MEM_latch_out), .seg2_lim_out(seg2_lim_RrAg_MEM_latch_out), .seg3_lim_out(seg3_lim_RrAg_MEM_latch_out), .seg4_lim_out(seg4_lim_RrAg_MEM_latch_out),
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
        .mem1_rw_out(mem1_rw_RrAg_MEM_latch_out), .mem2_rw_out(mem2_rw_RrAg_MEM_latch_out), .memsizeOVR_out(memSizeOVR_RrAg_MEM_latch_out),
        .eip_out(eip_RrAg_MEM_latch_out),
        .latched_eip_out(latched_eip_RrAg_MEM_latch_out),
        .IE_out(IE_RrAg_MEM_latch_out),
        .IE_type_out(IE_type_RrAg_MEM_latch_out),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_RrAg_MEM_latch_out),
        .BR_pred_target_out(BR_pred_target_RrAg_MEM_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_RrAg_MEM_latch_out),
        .BP_alias_out(BP_alias_RrAg_MEM_latch_out)
    );

    wire [63:0] reg1_memdf, reg2_memdf, reg3_memdf, reg4_memdf, seg1_memdf, seg2_memdf, seg3_memdf, seg4_memdf;

    bypassmech #(.NUM_PROSPECTS(4), .NUM_OPERANDS(8)) memdf(.prospective_data({res4_WB_RRAG_out,res3_WB_RRAG_out,res2_WB_RRAG_out,res1_WB_RRAG_out}), .prospective_ptc({res4_ptcinfo_WB_RRAG_out,res3_ptcinfo_WB_RRAG_out,res2_ptcinfo_WB_RRAG_out,res1_ptcinfo_WB_RRAG_out}),
                                                            .operand_data({reg4_RrAg_MEM_latch_out,reg3_RrAg_MEM_latch_out,reg2_RrAg_MEM_latch_out,reg1_RrAg_MEM_latch_out,
                                                                           48'h000000000000,seg4_RrAg_MEM_latch_out,48'h000000000000,seg3_RrAg_MEM_latch_out,
                                                                           48'h000000000000,seg2_RrAg_MEM_latch_out,48'h000000000000,seg1_RrAg_MEM_latch_out}),
                                                            .operand_ptc({ptc_r4_RrAg_MEM_latch_out,ptc_r3_RrAg_MEM_latch_out,ptc_r2_RrAg_MEM_latch_out,ptc_r1_RrAg_MEM_latch_out,
                                                                          96'h000000000000000000000000,ptc_s4_RrAg_MEM_latch_out,96'h000000000000000000000000,ptc_s3_RrAg_MEM_latch_out,
                                                                          96'h000000000000000000000000,ptc_s2_RrAg_MEM_latch_out,96'h000000000000000000000000,ptc_s1_RrAg_MEM_latch_out}),
                                                            .new_data({reg4_memdf,reg3_memdf,reg2_memdf,reg1_memdf,seg4_memdf,seg3_memdf,seg2_memdf,seg1_memdf}), .modify());
    
    wire [3:0] init_wake, cache_wake;
    wire [7:0] mshr_rd_qslot_e_out, mshr_sw_qslot_e_out, mshr_rd_io_qslot_e_out, mshr_sw_io_qslot_e_out;
    wire [7:0] mshr_rd_qslot_o_out, mshr_sw_qslot_o_out, mshr_rd_io_qslot_o_out, mshr_sw_io_qslot_o_out;
    wire [7:0] cache_qslot_out;
    
    wire cache_out_valid;
    wire [63:0] cache_out_data;
    wire [127:0] cache_out_ptcinfo;
    wire [127:0] cacheline_e_bus_in_data, cacheline_o_bus_in_data;
    wire [255:0] cacheline_e_bus_in_ptcinfo, cacheline_o_bus_in_ptcinfo;

    mem m1 (
        //inputs
        .clk_ng(clk),
        .valid_in(valid_RrAg_MEM_latch_out),
        .fwd_stall(MEM_EX_Latches_full), // receive from MEM_EX_Queued_Latches
        .opsize_in(opsize_RrAg_MEM_latch_out),
        .mem_addr1(mem_addr1_RrAg_MEM_latch_out),
        .mem_addr2(mem_addr2_RrAg_MEM_latch_out),
        .mem_addr1_end(mem_addr1_end_RrAg_MEM_latch_out),
        .mem_addr2_end(mem_addr2_end_RrAg_MEM_latch_out),
        .latched_EIP_end(latched_EIP_end_RrAg_MEM_latch_out), .latched_EIP_end_is_valid(latched_EIP_end_is_valid_RrAg_MEM_latch_out),
        .mem1_end_is_valid(mem1_end_is_valid_RrAg_MEM_latch_out),
        .mem2_end_is_valid(mem2_end_is_valid_RrAg_MEM_latch_out),
        .reg1(reg1_memdf),
        .reg2(reg2_memdf),
        .reg3(reg3_memdf),
        .reg4(reg4_memdf),
        .ptc_r1(ptc_r1_RrAg_MEM_latch_out),
        .ptc_r2(ptc_r2_RrAg_MEM_latch_out),
        .ptc_r3(ptc_r3_RrAg_MEM_latch_out),
        .ptc_r4(ptc_r4_RrAg_MEM_latch_out),
        .reg1_orig(reg1_orig_RrAg_MEM_latch_out),
        .reg2_orig(reg2_orig_RrAg_MEM_latch_out),
        .reg3_orig(reg3_orig_RrAg_MEM_latch_out),
        .reg4_orig(reg4_orig_RrAg_MEM_latch_out),
        .seg1(seg1_memdf[15:0]),
        .seg2(seg2_memdf[15:0]),
        .seg3(seg3_memdf[15:0]),
        .seg4(seg4_memdf[15:0]),
        .ptc_s1(ptc_s1_RrAg_MEM_latch_out),
        .ptc_s2(ptc_s2_RrAg_MEM_latch_out),
        .ptc_s3(ptc_s3_RrAg_MEM_latch_out),
        .ptc_s4(ptc_s4_RrAg_MEM_latch_out),
        .seg1_lim(seg1_lim_RrAg_MEM_latch_out),
        .seg2_lim(seg2_lim_RrAg_MEM_latch_out),
        .seg3_lim(seg3_lim_RrAg_MEM_latch_out),
        .seg4_lim(seg4_lim_RrAg_MEM_latch_out),
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
        .idtr_ptc_clear(IDTR_PTC_clear), //TODO:
        .clk_bus(bus_clk),
        .BUS(BUS),
        .setReceiver_d({recvDO,recvDE}), .free_bau_d({freeDO,freeDE}), .grant_d({grantDEr,grantDEw,grantDOr,grantDOw}), .ack_d({ackDEr,ackDEw,ackDOr,ackDOw}), .releases_d({relDEr,relDEw,relDOr,relDOw}), .req_d({reqDEr,reqDEw,reqDOr,reqDOw}), .dest_d({destDOw,destDOr,destDEw,destDEr}),
        .wb_memdata(mem_data_WB_M_out), .wb_memaddr(mem_addr_WB_M_out), .wb_size(memsize_WB_M_out), .wb_valid(mem_ld_WB_M_out), .wb_ptcid(inst_ptcid_out_WB_RRAG_out), .wbaq_isfull(wbaq_isfull_WB_M_in),
        .VP_in(VP), .PF_in(PF),
        .entry_V_in(entry_v), .entry_P_in(entry_P), .entry_RW_in(entry_RW), .entry_PCD_in(entry_PCD),
        .qentry_slot_in(q5.q0.ptr_wr),
        .rd_qentry_slots_out_e(mshr_rd_qslot_e_out), .sw_qentry_slots_out_e(mshr_sw_qslot_e_out), .rd_qentry_slots_out_o(mshr_rd_qslot_o_out), .sw_qentry_slots_out_o(mshr_sw_qslot_o_out),
        .rd_qentry_slots_out_e_io(mshr_rd_io_qslot_e_out), .sw_qentry_slots_out_e_io(mshr_sw_io_qslot_e_out), .rd_qentry_slots_out_o_io(mshr_rd_io_qslot_o_out), .sw_qentry_slots_out_o_io(mshr_sw_io_qslot_o_out),
        .aluk_in(aluk_RrAg_MEM_latch_out), .mux_adder_in(mux_adder_RrAg_MEM_latch_out), 
        .mux_and_int_in(mux_and_int_RrAg_MEM_latch_out), .mux_shift_in(mux_shift_RrAg_MEM_latch_out),
        .p_op_in(p_op_RrAg_MEM_latch_out), .fmask_in(fmask_RrAg_MEM_latch_out),
        .CS_in(CS_RrAg_MEM_latch_out),
        .conditionals_in(conditionals_RrAg_MEM_latch_out), .is_br_in(is_br_RrAg_MEM_latch_out), 
        .is_fp_in(is_fp_RrAg_MEM_latch_out), .is_imm_in(is_imm_RrAg_MEM_latch_out),
        .imm(imm_RrAg_MEM_latch_out), .mem1_rw(mem1_rw_RrAg_MEM_latch_out), .mem2_rw(mem2_rw_RrAg_MEM_latch_out), .memsizeOVR_in(memSizeOVR_RrAg_MEM_latch_out),
        .eip_in(eip_RrAg_MEM_latch_out), .latched_eip_in(latched_eip_RrAg_MEM_latch_out),
        .IE_in(IE_RrAg_MEM_latch_out), .IE_type_in(IE_type_RrAg_MEM_latch_out), .instr_is_IDTR_orig_in(instr_is_IDTR_orig_RrAg_MEM_latch_out),
        .BR_pred_target_in(BR_pred_target_RrAg_MEM_latch_out), .BR_pred_T_NT_in(BR_pred_T_NT_RrAg_MEM_latch_out),
        .BP_alias_in(BP_alias_RrAg_MEM_latch_out),
        .clr(global_reset), .clk(clk),
        //outputs
        .valid_out(valid_MEM_EX_latch_in),
        .memsizeOVR_out(memSizeOVR_MEM_EX_latch_in),
        .eip_out(EIP_MEM_EX_latch_in),
        .latched_eip_out(latched_eip_MEM_EX_latch_in),
        .IE_out(IE_MEM_EX_latch_in),
        .IE_type_out(IE_type_MEM_EX_latch_in),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_MEM_EX_latch_in),
        .BR_pred_target_out(BR_pred_target_MEM_EX_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_MEM_EX_latch_in),
        .BP_alias_out(BP_alias_MEM_EX_latch_in),
        .opsize_out(opsize_MEM_EX_latch_in),
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
        .dest1_ptcinfo(dest1_ptcinfo_MEM_EX_latch_in),
        .dest2_ptcinfo(dest2_ptcinfo_MEM_EX_latch_in),
        .dest3_ptcinfo(dest3_ptcinfo_MEM_EX_latch_in),
        .dest4_ptcinfo(dest4_ptcinfo_MEM_EX_latch_in),
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
        .res1_ld_out(res1_ld_MEM_EX_latch_in),
        .res2_ld_out(res2_ld_MEM_EX_latch_in),
        .res3_ld_out(res3_ld_MEM_EX_latch_in),
        .res4_ld_out(res4_ld_MEM_EX_latch_in),
        .inst_ptcid_out(inst_ptcid_MEM_EX_latch_in), 
        .aluk_out(aluk_MEM_EX_latch_in), .mux_adder_out(MUX_ADDER_IMM_MEM_EX_latch_in), 
        .mux_and_int_out(MUX_AND_INT_MEM_EX_latch_in), .mux_shift_out(MUX_SHIFT_MEM_EX_latch_in),
        .p_op_out(P_OP_MEM_EX_latch_in), .fmask_out(FMASK_MEM_EX_latch_in), .conditionals_out(conditionals_MEM_EX_latch_in), 
        .is_br_out(isBR_MEM_EX_latch_in), .is_fp_out(is_fp_MEM_EX_latch_in), .is_imm_out(is_imm_MEM_EX_latch_in), 
        .is_rep_out(is_rep_MEM_EX_latch_in), 
        .CS_out(CS_MEM_EX_latch_in),
        .wake_init_out(init_wake), .wake_cache_out(cache_wake),
        .cache_qentry_slot_out(cache_qslot_out), .cache_valid_out(cache_out_valid), .cache_data_out(cache_out_data), .cache_ptcinfo_out(cache_out_ptcinfo),
        .stall(MEM_stall_out), //send to RrAg and RrAg_MEM_latch
        .cacheline_e_bus_in_data(cacheline_e_bus_in_data), .cacheline_o_bus_in_data(cacheline_o_bus_in_data),
        .cacheline_e_bus_in_ptcinfo(cacheline_e_bus_in_ptcinfo), .cacheline_o_bus_in_ptcinfo(cacheline_o_bus_in_ptcinfo)
    );        
        
    
    wire [m_size_MEM_EX-1:0] m_din_MEM_EX;
    wire [n_size_MEM_EX-1:0] n_din_MEM_EX;

    assign m_din_MEM_EX = { inst_ptcid_MEM_EX_latch_in, init_wake, op1_MEM_EX_latch_in, op2_MEM_EX_latch_in, op3_MEM_EX_latch_in, op4_MEM_EX_latch_in, 
                            op1_ptcinfo_MEM_EX_latch_in, op2_ptcinfo_MEM_EX_latch_in, op3_ptcinfo_MEM_EX_latch_in, op4_ptcinfo_MEM_EX_latch_in,
                            valid_MEM_EX_latch_in
                          };

    assign n_din_MEM_EX = { instr_is_IDTR_orig_MEM_EX_latch_in, memSizeOVR_MEM_EX_latch_in, BP_alias_MEM_EX_latch_in, is_rep_MEM_EX_latch_in, is_imm_MEM_EX_latch_in, EIP_MEM_EX_latch_in, latched_eip_MEM_EX_latch_in, IE_MEM_EX_latch_in, 
                            IE_type_MEM_EX_latch_in, BR_pred_target_MEM_EX_latch_in, BR_pred_T_NT_MEM_EX_latch_in,
                            opsize_MEM_EX_latch_in, dest1_addr_MEM_EX_latch_in, dest2_addr_MEM_EX_latch_in, dest3_addr_MEM_EX_latch_in, dest4_addr_MEM_EX_latch_in,
                            dest1_ptcinfo_MEM_EX_latch_in, dest2_ptcinfo_MEM_EX_latch_in, dest3_ptcinfo_MEM_EX_latch_in, dest4_ptcinfo_MEM_EX_latch_in,
                            res1_is_reg_MEM_EX_latch_in, res2_is_reg_MEM_EX_latch_in, res3_is_reg_MEM_EX_latch_in, res4_is_reg_MEM_EX_latch_in,
                            res1_is_seg_MEM_EX_latch_in, res2_is_seg_MEM_EX_latch_in, res3_is_seg_MEM_EX_latch_in, res4_is_seg_MEM_EX_latch_in,
                            res1_is_mem_MEM_EX_latch_in, res2_is_mem_MEM_EX_latch_in, res3_is_mem_MEM_EX_latch_in, res4_is_mem_MEM_EX_latch_in,
                            res1_ld_MEM_EX_latch_in, res2_ld_MEM_EX_latch_in, res3_ld_MEM_EX_latch_in, res4_ld_MEM_EX_latch_in, 
                            aluk_MEM_EX_latch_in, MUX_ADDER_IMM_MEM_EX_latch_in, MUX_AND_INT_MEM_EX_latch_in, MUX_SHIFT_MEM_EX_latch_in, P_OP_MEM_EX_latch_in,
                            FMASK_MEM_EX_latch_in, conditionals_MEM_EX_latch_in, isBR_MEM_EX_latch_in, is_fp_MEM_EX_latch_in, CS_MEM_EX_latch_in
                          };
    
    wire MEM_EX_Latch_RD, exinvstall; 
    inv1$ n2001 (.out(exinvstall), .in(EX_stall_out));
    andn #(.NUM_INPUTS(5)) n20000034(.in({wake_MEM_EX_latch_out,exinvstall}), .out(MEM_EX_Latch_RD));

    wire MEM_EX_Latch_clr;
    andn #(.NUM_INPUTS(2)) n2amdl001 (.in({global_reset, WB_to_clr_latches_resteer_active_low}), .out(MEM_EX_Latch_clr));

    wire [m_size_MEM_EX*8-1:0] new_m_M_EX, old_m_M_EX;
    wire [7:0] modify_M_EX_latch;

    latchconnections #(.MSIZE(m_size_MEM_EX)) mexlc(.cache_out_data(cache_out_data), .cache_out_ptcinfo(cache_out_ptcinfo), .cache_out_valid(cache_out_valid), .cache_wake(cache_wake),
                                                    .cache_qslot_out(cache_qslot_out),
                                                    .mshr_rd_qslot_e_out(mshr_rd_qslot_e_out), .mshr_sw_qslot_e_out(mshr_sw_qslot_e_out), .mshr_rd_qslot_o_out(mshr_rd_qslot_o_out), .mshr_sw_qslot_o_out(mshr_sw_qslot_o_out),
                                                    .mshr_rd_io_qslot_e_out(mshr_rd_io_qslot_e_out), .mshr_sw_io_qslot_e_out(mshr_sw_io_qslot_e_out), .mshr_rd_io_qslot_o_out(mshr_rd_io_qslot_o_out), .mshr_sw_io_qslot_o_out(mshr_sw_io_qslot_o_out),
                                                    .cacheline_e_bus_in_data(cacheline_e_bus_in_data), .cacheline_o_bus_in_data(cacheline_o_bus_in_data),
                                                    .cacheline_e_bus_in_ptcinfo(cacheline_e_bus_in_ptcinfo), .cacheline_o_bus_in_ptcinfo(cacheline_o_bus_in_ptcinfo),
                                                    .new_m_M_EX(new_m_M_EX), .old_m_M_EX(old_m_M_EX), .modify_M_EX_latch(modify_M_EX_latch),
                                                    .wb_res1(res1_WB_RRAG_out), .wb_res2(res2_WB_RRAG_out), .wb_res3(res3_WB_RRAG_out), .wb_res4(res4_WB_RRAG_out),
                                                    .wb_res1_ptcinfo(res1_ptcinfo_WB_RRAG_out), .wb_res2_ptcinfo(res2_ptcinfo_WB_RRAG_out), .wb_res3_ptcinfo(res3_ptcinfo_WB_RRAG_out), .wb_res4_ptcinfo(res4_ptcinfo_WB_RRAG_out));

    MEM_EX_Queued_Latches #(.M_WIDTH(m_size_MEM_EX), .N_WIDTH(n_size_MEM_EX), .Q_LENGTH(8)) q5 (
        .m_din(m_din_MEM_EX), .n_din(n_din_MEM_EX), .new_m_vector(new_m_M_EX), 
        .wr(valid_MEM_EX_latch_in), .rd(MEM_EX_Latch_RD),
        .modify_vector(modify_M_EX_latch), .clr(MEM_EX_Latch_clr), .clk(clk), .full(MEM_EX_Latches_full), .empty(MEM_EX_Latches_empty), .old_m_vector(old_m_M_EX), 
            .dout({
                inst_ptcid_MEM_EX_latch_out, wake_MEM_EX_latch_out, op1_MEM_EX_latch_out, op2_MEM_EX_latch_out, op3_MEM_EX_latch_out, op4_MEM_EX_latch_out, 
                op1_ptcinfo_MEM_EX_latch_out, op2_ptcinfo_MEM_EX_latch_out, op3_ptcinfo_MEM_EX_latch_out, op4_ptcinfo_MEM_EX_latch_out,
                valid_MEM_EX_latch_out, instr_is_IDTR_orig_MEM_EX_latch_out, memSizeOVR_MEM_EX_latch_out, BP_alias_MEM_EX_latch_out, is_rep_MEM_EX_latch_out, is_imm_MEM_EX_latch_out, EIP_MEM_EX_latch_out, latched_eip_MEM_EX_latch_out, IE_MEM_EX_latch_out, IE_type_MEM_EX_latch_out, BR_pred_target_MEM_EX_latch_out, BR_pred_T_NT_MEM_EX_latch_out,
                opsize_MEM_EX_latch_out, dest1_addr_MEM_EX_latch_out, dest2_addr_MEM_EX_latch_out, dest3_addr_MEM_EX_latch_out, dest4_addr_MEM_EX_latch_out, 
                dest1_ptcinfo_MEM_EX_latch_out, dest2_ptcinfo_MEM_EX_latch_out, dest3_ptcinfo_MEM_EX_latch_out, dest4_ptcinfo_MEM_EX_latch_out,
                res1_is_reg_MEM_EX_latch_out, res2_is_reg_MEM_EX_latch_out, res3_is_reg_MEM_EX_latch_out, res4_is_reg_MEM_EX_latch_out,
                res1_is_seg_MEM_EX_latch_out, res2_is_seg_MEM_EX_latch_out, res3_is_seg_MEM_EX_latch_out, res4_is_seg_MEM_EX_latch_out,
                res1_is_mem_MEM_EX_latch_out, res2_is_mem_MEM_EX_latch_out, res3_is_mem_MEM_EX_latch_out, res4_is_mem_MEM_EX_latch_out,
                res1_ld_MEM_EX_latch_out, res2_ld_MEM_EX_latch_out, res3_ld_MEM_EX_latch_out, res4_ld_MEM_EX_latch_out, 
                aluk_MEM_EX_latch_out, MUX_ADDER_IMM_MEM_EX_latch_out, MUX_AND_INT_MEM_EX_latch_out, MUX_SHIFT_MEM_EX_latch_out, P_OP_MEM_EX_latch_out,
                FMASK_MEM_EX_latch_out, conditionals_MEM_EX_latch_out, isBR_MEM_EX_latch_out, is_fp_MEM_EX_latch_out, CS_MEM_EX_latch_out }
             )
    );

    wire expostwakevalid;

    andn #(.NUM_INPUTS(5)) n20000035(.in({wake_MEM_EX_latch_out,valid_MEM_EX_latch_out}), .out(expostwakevalid));

    wire [63:0] op1_exdf, op2_exdf, op3_exdf, op4_exdf;

    bypassmech #(.NUM_PROSPECTS(4), .NUM_OPERANDS(4)) exdf(.prospective_data({res4_WB_RRAG_out,res3_WB_RRAG_out,res2_WB_RRAG_out,res1_WB_RRAG_out}), .prospective_ptc({res4_ptcinfo_WB_RRAG_out,res3_ptcinfo_WB_RRAG_out,res2_ptcinfo_WB_RRAG_out,res1_ptcinfo_WB_RRAG_out}),
                                                           .operand_data({op4_MEM_EX_latch_out,op3_MEM_EX_latch_out,op2_MEM_EX_latch_out,op1_MEM_EX_latch_out}), .operand_ptc({op4_ptcinfo_MEM_EX_latch_out,op3_ptcinfo_MEM_EX_latch_out,op2_ptcinfo_MEM_EX_latch_out,op1_ptcinfo_MEM_EX_latch_out}),
                                                           .new_data({op4_exdf,op3_exdf,op2_exdf,op1_exdf}), .modify());

    execute_TOP e1 (
        .clk(clk),
        .eflags_old(eflags_old),
        .fwd_stall(fwd_stall_WB_EX_out), //TODO: recieve from WB
        .valid_in(expostwakevalid),
        .latch_empty(MEM_EX_Latches_empty),
        .memsizeOVR_in(memSizeOVR_MEM_EX_latch_out),
        .EIP_in(EIP_MEM_EX_latch_out),
        .latched_EIP_in(latched_eip_MEM_EX_latch_out),
        .IE_in(IE_MEM_EX_latch_out),  
        .IE_type_in(IE_type_MEM_EX_latch_out),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_MEM_EX_latch_out),
        .BR_pred_target_in(BR_pred_target_MEM_EX_latch_out),     
        .BR_pred_T_NT_in(BR_pred_T_NT_MEM_EX_latch_out),        
        .set(global_set), .rst(global_reset),
        .PTCID_in(inst_ptcid_MEM_EX_latch_out),

        .res1_ld_in(res1_ld_MEM_EX_latch_out), .res2_ld_in(res2_ld_MEM_EX_latch_out),
        .res3_ld_in(res3_ld_MEM_EX_latch_out), .res4_ld_in(res4_ld_MEM_EX_latch_out),
        .BP_alias_in(BP_alias_MEM_EX_latch_out), //TODO
        .op1(op1_exdf), .op2(op2_exdf),
        .op3(op3_exdf), .op4(op4_exdf),
        .op1_ptcinfo(op1_ptcinfo_MEM_EX_latch_out), .op2_ptcinfo(op2_ptcinfo_MEM_EX_latch_out),
        .op3_ptcinfo(op3_ptcinfo_MEM_EX_latch_out), .op4_ptcinfo(op4_ptcinfo_MEM_EX_latch_out),
        .wake_in(wake_MEM_EX_latch_out),
        .dest1_addr(dest1_addr_MEM_EX_latch_out), .dest2_addr(dest2_addr_MEM_EX_latch_out), 
        .dest3_addr(dest3_addr_MEM_EX_latch_out), .dest4_addr(dest4_addr_MEM_EX_latch_out),
        .dest1_ptcinfo_in(dest1_ptcinfo_MEM_EX_latch_out), .dest2_ptcinfo_in(dest2_ptcinfo_MEM_EX_latch_out),
        .dest3_ptcinfo_in(dest3_ptcinfo_MEM_EX_latch_out), .dest4_ptcinfo_in(dest4_ptcinfo_MEM_EX_latch_out),
        .res1_is_reg_in(res1_is_reg_MEM_EX_latch_out), .res2_is_reg_in(res2_is_reg_MEM_EX_latch_out),
        .res3_is_reg_in(res3_is_reg_MEM_EX_latch_out), .res4_is_reg_in(res4_is_reg_MEM_EX_latch_out),
        .res1_is_seg_in(res1_is_seg_MEM_EX_latch_out), .res2_is_seg_in(res2_is_seg_MEM_EX_latch_out),
        .res3_is_seg_in(res3_is_seg_MEM_EX_latch_out), .res4_is_seg_in(res4_is_seg_MEM_EX_latch_out),
        .res1_is_mem_in(res1_is_mem_MEM_EX_latch_out), .res2_is_mem_in(res2_is_mem_MEM_EX_latch_out), 
        .res3_is_mem_in(res3_is_mem_MEM_EX_latch_out), .res4_is_mem_in(res4_is_mem_MEM_EX_latch_out),
        .opsize_in(opsize_MEM_EX_latch_out),
        .is_resteer(is_resteer_WB_out),
        .valid_wb(is_valid_WB_out),
        
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
        .is_resteer(is_resteer_WB_out),
        .valid_wb(is_valid_WB_out),

        //outputs:
        .valid_out(valid_EX_WB_latch_in), //TODO: implement
        .memsizeOVR_out(memSizeOVR_EX_WB_latch_in),
        .EIP_out(EIP_EX_WB_latch_in),
        .latched_EIP_out(latched_eip_EX_WB_latch_in),
        .IE_out(IE_EX_WB_latch_in),
        .IE_type_out(IE_type_EX_WB_latch_in),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_EX_WB_latch_in),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_in),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_in),
        .PTCID_out(inst_ptcid_EX_WB_latch_in),
        .is_rep_out(is_rep_EX_WB_latch_in),
        .BP_alias_out(BP_alias_EX_WB_latch_in),

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
        .dest1_ptcinfo_out(dest1_ptcinfo_EX_WB_latch_in), .dest2_ptcinfo_out(dest2_ptcinfo_EX_WB_latch_in),
        .dest3_ptcinfo_out(dest3_ptcinfo_EX_WB_latch_in), .dest4_ptcinfo_out(dest4_ptcinfo_EX_WB_latch_in),
        .ressize(inpsize_EX_WB_latch_in), 

        .BR_valid(BR_valid_EX_WB_latch_in), 
        .BR_taken(BR_taken_EX_WB_latch_in),
        .BR_correct(BR_correct_EX_WB_latch_in), 
        .BR_FIP(BR_FIP_EX_WB_latch_in), 
        .BR_FIP_p1(BR_FIP_p1_EX_WB_latch_in),
        .stall(EX_stall_out) //send stall to MEM_EX_Queued_Latches
    );

    wire EX_WB_latch_LD;
    inv1$ i2i31nfkdas(.out(EX_WB_latch_LD), .in(fwd_stall_WB_EX_out));

    // wire EX_WB_latch_clr;
    // andn #(.NUM_INPUTS(2)) n2amdl0011 (.in({global_reset, WB_to_clr_latches_resteer_active_low}), .out(EX_WB_latch_clr));

    E_WB_latch e_w_latch(
        //inputs 
        .ld(EX_WB_latch_LD), .clr(global_reset),
        .clk(clk),

        .valid_in(valid_EX_WB_latch_in),
        .memsizeOVR_in(memSizeOVR_EX_WB_latch_in),
        .EIP_in(EIP_EX_WB_latch_in),
        .latched_EIP_in(latched_eip_EX_WB_latch_in), 
        .IE_in(IE_EX_WB_latch_in),
        .IE_type_in(IE_type_EX_WB_latch_in),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_EX_WB_latch_in),
        .BR_pred_target_in(BR_pred_target_EX_WB_latch_in),
        .BR_pred_T_NT_in(BR_pred_T_NT_EX_WB_latch_in),
        .PTCID_in(inst_ptcid_EX_WB_latch_in),
        .is_rep_in(is_rep_EX_WB_latch_in),
        .BP_alias_in(BP_alias_EX_WB_latch_in),

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
        .dest1_ptcinfo_in(dest1_ptcinfo_EX_WB_latch_in), .dest2_ptcinfo_in(dest2_ptcinfo_EX_WB_latch_in),
        .dest3_ptcinfo_in(dest3_ptcinfo_EX_WB_latch_in), .dest4_ptcinfo_in(dest4_ptcinfo_EX_WB_latch_in),
        .ressize_in(inpsize_EX_WB_latch_in), 

        .BR_valid_in(BR_valid_EX_WB_latch_in),
        .BR_taken_in(BR_taken_EX_WB_latch_in),
        .BR_correct_in(BR_correct_EX_WB_latch_in), 
        .BR_FIP_in(BR_FIP_EX_WB_latch_in), .BR_FIP_p1_in(BR_FIP_p1_EX_WB_latch_in),

        //outputs
        .valid_out(valid_EX_WB_latch_out),
        .memsizeOVR_out(memSizeOVR_EX_WB_latch_out),
        .EIP_out(EIP_EX_WB_latch_out),
        .latched_EIP_out(latched_eip_EX_WB_latch_out),
        .IE_out(IE_EX_WB_latch_out),
        .IE_type_out(IE_type_EX_WB_latch_out),
        .instr_is_IDTR_orig_out(instr_is_IDTR_orig_EX_WB_latch_out),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_out),
        .PTCID_out(inst_ptcid_EX_WB_latch_out),
        .is_rep_out(is_rep_EX_WB_latch_out),
        .BP_alias_out(BP_alias_EX_WB_latch_out),

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
        .dest1_ptcinfo_out(dest1_ptcinfo_EX_WB_latch_out), .dest2_ptcinfo_out(dest2_ptcinfo_EX_WB_latch_out),
        .dest3_ptcinfo_out(dest3_ptcinfo_EX_WB_latch_out), .dest4_ptcinfo_out(dest4_ptcinfo_EX_WB_latch_out),
        .ressize_out(inpsize_EX_WB_latch_out), 

        .BR_valid_out(BR_valid_EX_WB_latch_out),
        .BR_taken_out(BR_taken_EX_WB_latch_out),
        .BR_correct_out(BR_correct_EX_WB_latch_out), 
        .BR_FIP_out(BR_FIP_EX_WB_latch_out), .BR_FIP_p1_out(BR_FIP_p1_EX_WB_latch_out)
    );
    
    writeback_TOP wb_inst(
        .clk(clk),
        .valid_in(valid_EX_WB_latch_out),
        .memsizeOVR_in(memSizeOVR_EX_WB_latch_out),
        .EIP_in(EIP_EX_WB_latch_out),
        .latched_EIP_in(latched_eip_EX_WB_latch_out),
        .IE_in(IE_EX_WB_latch_out),                           //interrupt or exception signal
        .IE_type_in(IE_type_EX_WB_latch_out),
        .instr_is_IDTR_orig_in(instr_is_IDTR_orig_EX_WB_latch_out),
        .BR_pred_target_in(BR_pred_target_EX_WB_latch_out),
        .BR_pred_T_NT_in(BR_pred_T_NT_EX_WB_latch_out),
        .BP_alias_in(BP_alias_EX_WB_latch_out),
        .inst_ptcid_in(inst_ptcid_EX_WB_latch_out),
        .set(global_set), .rst(global_reset),
        .latched_latched_EIP_out(latched_latched_eip_WB_out),
        .latched_latched_latched_EIP_out(latched_latched_latched_eip_WB_out),

        .inp1_wb(inp1_wb_EX_WB_latch_out), .inp2_wb(inp2_wb_EX_WB_latch_out), .inp3_wb(inp3_wb_EX_WB_latch_out), .inp4_wb(inp4_wb_EX_WB_latch_out),
        .inp1(inp1_EX_WB_latch_out), .inp2(inp2_EX_WB_latch_out), .inp3(inp3_EX_WB_latch_out), .inp4(inp4_EX_WB_latch_out),
        .inp1_ptcinfo(inp1_ptcinfo_EX_WB_latch_out), .inp2_ptcinfo(inp2_ptcinfo_EX_WB_latch_out), 
        .inp3_ptcinfo(inp3_ptcinfo_EX_WB_latch_out), .inp4_ptcinfo(inp4_ptcinfo_EX_WB_latch_out),
        .dest1_ptcinfo(dest1_ptcinfo_EX_WB_latch_out), .dest2_ptcinfo(dest2_ptcinfo_EX_WB_latch_out),
        .dest3_ptcinfo(dest3_ptcinfo_EX_WB_latch_out), .dest4_ptcinfo(dest4_ptcinfo_EX_WB_latch_out),
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

        .interrupt_in(interrupt), //TODO
        .IDTR_is_serciving_IE(is_servicing_IE),
        .VP(VP), .PF(PF),
        .CS_LIM(CS_LIM),

        .wbaq_full(wbaq_isfull_WB_M_in), .is_rep(is_rep_EX_WB_latch_out),

        //outputs
        .valid_out(is_valid_WB_out),

        .res1(res1_WB_RRAG_out), .res2(res2_WB_RRAG_out), .res3(res3_WB_RRAG_out), .res4(res4_WB_RRAG_out), .mem_data(mem_data_WB_M_out),
        .res1_ptcinfo(res1_ptcinfo_WB_RRAG_out), .res2_ptcinfo(res2_ptcinfo_WB_RRAG_out), .res3_ptcinfo(res3_ptcinfo_WB_RRAG_out), .res4_ptcinfo(res4_ptcinfo_WB_RRAG_out),
        .ressize(ressize_WB_RRAG_out), .memsize(memsize_WB_M_out),
        .reg_addr(reg_addr_WB_RRAG_out), .seg_addr(seg_addr_WB_RRAG_out),
        .mem_addr(mem_addr_WB_M_out),
        .reg_ld(reg_ld_WB_RRAG_out), .seg_ld(seg_ld_WB_RRAG_out),
        .mem_ld(mem_ld_WB_M_out),
        .inst_ptcid_out(inst_ptcid_out_WB_RRAG_out),

        .newFIP_e(newFIP_e_WB_out), .newFIP_o(newFIP_o_WB_out), .newEIP(newEIP_WB_out), //done 
        .latched_EIP_out(latched_eip_WB_out), //done
        .EIP_out(EIP_WB_out),
        .BR_valid(BR_valid_WB_BP_out), .BR_taken(BR_taken_WB_BP_out), .BR_correct(BR_correct_WB_BP_out), //done
        .is_resteer(is_resteer_WB_out),
        .CS_out(final_CS),
        .EFLAGS_out(final_EFLAGS),
        
        .WB_BP_update_alias(WB_BP_update_alias),

        .stall(fwd_stall_WB_EX_out),
        .is_iretd(is_iretd_WB_out),

        .final_IE_val(final_IE_val),
        .final_IE_type(IE_type_WB_out),
        .halts(halts),
        .instr_is_final_WB(instr_is_IDTR_switch_final_WB)
    );

   assign final_IE_type[1:0] = IE_type_WB_out[1:0];
   assign final_IE_type[2] = IE_type_WB_out[3];
    
    // assign final_IE_val = 0;
    // assign final_IE_type = 0;

    nor2$ ptc_clear_and (.in0(idtr_ptc_clear_out), .in1(is_resteer_WB_out), .out(IDTR_PTC_clear)); //TODO

    dumper dumpy(.eip(EIP_EX_WB_latch_out), .latch_eip(latched_eip_EX_WB_latch_out),
                 .ptcid(inst_ptcid_EX_WB_latch_out),
                 .res1(res1_WB_RRAG_out), .res2(res2_WB_RRAG_out), .res3(res3_WB_RRAG_out), .res4(res4_WB_RRAG_out),
                 .dest1(inp1_dest_EX_WB_latch_out), .dest2(inp2_dest_EX_WB_latch_out), .dest3(inp3_dest_EX_WB_latch_out), .dest4(inp4_dest_EX_WB_latch_out),
                 .reg_wb(reg_ld_WB_RRAG_out), .seg_wb(seg_ld_WB_RRAG_out), .mem_wb(wb_inst.partialmem_ld),
                 .eip_wb(is_resteer_WB_out), .is_halt(wb_inst.halt_ld),
                 .br_pred_tnt(BR_pred_T_NT_EX_WB_latch_out), .br_pred_target(BR_pred_target_EX_WB_latch_out),
                 .eflags(final_EFLAGS),
                 .gpf_out({r1.rf.gf.e_out[7],r1.rf.gf.h_out[7],r1.rf.gf.l_out[7],
                          r1.rf.gf.e_out[6],r1.rf.gf.h_out[6],r1.rf.gf.l_out[6],
                          r1.rf.gf.e_out[5],r1.rf.gf.h_out[5],r1.rf.gf.l_out[5],
                          r1.rf.gf.e_out[4],r1.rf.gf.h_out[4],r1.rf.gf.l_out[4],
                          r1.rf.gf.e_out[3],r1.rf.gf.h_out[3],r1.rf.gf.l_out[3],
                          r1.rf.gf.e_out[2],r1.rf.gf.h_out[2],r1.rf.gf.l_out[2],
                          r1.rf.gf.e_out[1],r1.rf.gf.h_out[1],r1.rf.gf.l_out[1],
                          r1.rf.gf.e_out[0],r1.rf.gf.h_out[0],r1.rf.gf.l_out[0]}),
                 .mmf_out(r1.rf.mf.outs),
                 .sf_out(r1.sf.base_outs),
                 .clk(clk), .valid(is_valid_WB_out),
                 .br_valid(BR_valid_WB_BP_out),
                 .br_taken(BR_taken_WB_BP_out),
                 .br_correct(BR_correct_WB_BP_out),
                 .fipE(newFIP_e_WB_out),
                 .fipO(newFIP_o_WB_out),
                 .eip_bp(newEIP_WB_out)
    );



 endmodule
