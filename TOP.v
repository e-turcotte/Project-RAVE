module TOP();
    localparam CYCLE_TIME = 8.0;

    reg clk;
    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    //...
    //MEM
    //Latch
    //Ex
    //LAtch
    //WB

    wire valid_EX_WB_latch_out;
    wire [31:0] EIP_EX_WB_latch_out;
    wire IE_EX_WB_latch_out;
    wire [3:0] IE_type_EX_WB_latch_out;
    wire [31:0] BR_pred_target_EX_WB_latch_out;
    wire BR_pred_T_NT_EX_WB_latch_out;

    wire [17:0] eflags_EX_WB_latch_out;

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
        .valid_out(valid_EX_WB_latch_out),
        .EIP_out(EIP_EX_WB_latch_out),
        .IE_out(IE_EX_WB_latch_out),
        .IE_type_out(IE_type_EX_WB_latch_out),
        .BR_pred_target_out(BR_pred_target_EX_WB_latch_out),
        .BR_pred_T_NT_out(BR_pred_T_NT_EX_WB_latch_out),

        .eflags(eflags_EX_WB_latch_out),

        .res1_wb(res1_wb_EX_WB_latch_out),
        .res1(res1_EX_WB_latch_out),
        .res1_is_reg(res1_is_reg_EX_WB_latch_out),
        .res1_dest(res1_dest_EX_WB_latch_out),
        .res1_size(res1_size_EX_WB_latch_out),

        .res2_wb(res2_wb_EX_WB_latch_out),
        .res2(res2_EX_WB_latch_out),
        .res2_is_reg(res2_is_reg_EX_WB_latch_out),
        .res2_dest(res2_dest_EX_WB_latch_out),
        .res2_size(res2_size_EX_WB_latch_out),

        .res3_wb(res3_wb_EX_WB_latch_out),
        .res3(res3_EX_WB_latch_out),
        .res3_is_reg(res3_is_reg_EX_WB_latch_out),
        .res3_dest(res3_dest_EX_WB_latch_out),
        .res3_size(res3_size_EX_WB_latch_out),

        .res4_wb(res4_wb_EX_WB_latch_out),
        .res4(res4_EX_WB_latch_out),
        .res4_is_reg(res4_is_reg_EX_WB_latch_out),
        .res4_dest(res4_dest_EX_WB_latch_out),
        .res4_size(res4_size_EX_WB_latch_out),

        .load_eip_in_res1(load_eip_in_res1_EX_WB_latch_out),
        .load_segReg_in_res1(load_segReg_in_res1_EX_WB_latch_out),
        .load_eip_in_res2(load_eip_in_res2_EX_WB_latch_out),
        .load_segReg_in_res2(load_segReg_in_res2_EX_WB_latch_out),

        .BR_valid(BR_valid_EX_WB_latch_out), 
        .BR_taken(BR_taken_EX_WB_latch_out), 
        .BR_correct(BR_correct_EX_WB_latch_out), 
        .BR_FIP(BR_FIP_EX_WB_latch_out), 
        .BR_FIP_p1(BR_FIP_p1_EX_WB_latch_out)
    );

    integer EX_WB_latch_size; EX_WB_latch_size = 400;

    regn (.WIDTH(EX_WB_latch_size)) (
        .din({
            valid_EX_WB_latch_out, EIP_EX_WB_latch_out, IE_EX_WB_latch_out, IE_type_EX_WB_latch_out,
            BR_pred_target_EX_WB_latch_out, BR_pred_T_NT_EX_WB_latch_out, eflags_EX_WB_latch_out,

            res1_wb_EX_WB_latch_out, res1_EX_WB_latch_out, res1_is_reg_EX_WB_latch_out, res1_dest_EX_WB_latch_out, res1_size_EX_WB_latch_out, 
            res2_wb_EX_WB_latch_out, res2_EX_WB_latch_out, res2_is_reg_EX_WB_latch_out, res2_dest_EX_WB_latch_out, res2_size_EX_WB_latch_out, 
            res3_wb_EX_WB_latch_out, res3_EX_WB_latch_out, res3_is_reg_EX_WB_latch_out, res3_dest_EX_WB_latch_out, res3_size_EX_WB_latch_out, 
            res4_wb_EX_WB_latch_out, res4_EX_WB_latch_out, res4_is_reg_EX_WB_latch_out, res4_dest_EX_WB_latch_out, res4_size_EX_WB_latch_out,
            
            load_eip_in_res1_EX_WB_latch_out, load_segReg_in_res1_EX_WB_latch_out, 
            load_eip_in_res2_EX_WB_latch_out, load_segReg_in_res2_EX_WB_latch_out, 
            BR_valid_EX_WB_latch_out, BR_taken_EX_WB_latch_out, BR_correct_EX_WB_latch_out, BR_FIP_EX_WB_latch_out, BR_FIP_p1_EX_WB_latch_out
            }),
        .ld(),
        .clr(),
        .clk(),
        .dout({

        })
    );



endmodule
