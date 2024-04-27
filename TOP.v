module TOP();
    localparam CYCLE_TIME = 8.0;

    reg clk;
    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

//FETCH1 -> FETCH2 -> DECODE -> RrAg -> MEM -> EX -> WB


//  notation for latche wires: <signal.name>_<stage.prev>_<stage.next>_latch_<in/out>
//  where in is the input to the latch (output of stage.prev) and out is the output from the latch (input of stage.next)

//////////////////////////////////////////////////////////
//    Outputs from EX that go into EX_WB_latch:          //  
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

    integer EX_WB_latch_size; EX_WB_latch_size = 400;

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
    .clk(),
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
    .inp1(), .inp2(), .inp3(), .inp4(),
    .inp1_isReg(), .inp2_isReg(), .inp3_isReg(), .inp4_isReg(),
    .inp1_dest(), .inp2_dest(), .inp3_dest(), .inp4_dest(),
    .inp1_size(), .inp2_size(), .inp3_size(), .inp4_size(),
    .inp1_isPTC(), .inp2_isPTC(), .inp3_isPTC(), .inp4_isPTC(),
    .inp1_PTC(), .inp2_PTC(), .inp3_PTC(), .inp4_PTC(),
    .inp1_wb(), .inp2_wb(), .inp3_wb(), .inp4_wb(),
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

    .FIP_e(), .FIP_o(), .EIP(),
    .BR_valid(), .BR_taken(), .BR_correct(),
    .CS(),
    .segReg1(),
    .segReg2(),

    .load_segReg1(),
    .load_segReg2(),

    .final_IE_val(),
    .final_IE_type()
    );




endmodule
