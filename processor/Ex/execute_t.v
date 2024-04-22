module execute_t();
    localparam cycle_time = 10;
    reg clk;
    initial begin
        clk = 0;
        forever
             #(cycle_time / 2) clk = ~clk;
    end
    
    
    reg valid_in, op1_wb, op2_wb, op3_wb, op4_wb;
    reg[63:0] op1, op2, op3, op4;
    reg op1_is_reg,op2_is_reg, op3_is_reg, op4_is_reg;
    reg[31:0] op1_orig, op2_orig, op3_orig, op4_orig;
    reg[1:0] op1_size,op2_size, op3_size, op4_size, conditionals;
    reg[4:0] aluk;
    reg[2:0] MUX_ADDER_IMM;
    reg MUX_AND_INT, MUX_SHIFT, load_eip_in, load_segReg_in;
    reg[16:0] FMASK;
    reg[34:0] P_OP;
    
    reg pred_T_NT, pred_target, isBR, is_fp, stall, set, rst, interrupt;
    reg[31:0] EIP_in;
    
     reg load_eip_in_op1;
 reg load_segReg_in_op1;
 reg load_eip_in_op2;
 reg load_segReg_in_op2;
 
 wire valid, res1_wb, res1_is_reg, res2_wb, res2_is_reg, res3_wb, res3_is_reg, res4_wb, res4_is_reg;
 wire  [63:0] res1, res2, res3, res4;
 wire[31:0] res1_dest, res2_dest, res3_dest, res4_dest;
 wire[1:0] res1_size, res2_size, res3_size, res4_size;
 wire [16:0] eflags;
 wire load_eip_in_op1, load_eip_in_op2, load_segReg_in_op1, load_segReg_in_op2;
 wire BR_valid, BR_taken, BR_correct;
 wire [31:0] BR_FIP, BR_FIP_p1, BR_EIP;
 
 
 execute_TOP e1(valid, eflags, res1_wb, res1, res1_is_reg, res1_dest, res1_size, res2_wb, res2, res2_is_reg, res2_dest, res2_size, res3_wb, res3, res3_is_reg, res3_dest, res3_size, res4_wb, res4, res4_is_reg, res4_dest, res4_size, load_eip_in_res1, load_segReg_in_res1, load_eip_in_res2, load_segReg_in_res2, valid_in, op1_wb, op1, op1_is_reg, op1_orig, op1_size, op2_wb, op2, op2_is_reg, op2_orig, op2_size, op3_wb, op3, op3_is_reg, op3_orig, op3_size, op4_wb, op4, op4_is_reg, op4_orig, op4_size,aluk, MUX_ADDER_IMM, MUX_AND_INT, MUX_SHIFT, P_OP, load_eip_in_op1, load_segReg_in_op1, load_eip_in_op2, load_segReg_in_op2, FMASK, conditionals, pred_T_NT, pred_target, isBR, is_fp, EIP_in, stall, set, rst, clk, interrupt, BR_valid, BR_taken, BR_correct, BR_FIP, BR_FIP_p1, BR_EIP);   

integer i;

    initial begin
    
    valid_in = 1; op1_wb = 1; op2_wb = 1; op3_wb = 1; op4_wb = 1; op1_is_reg = 1;op2_is_reg = 1;op3_is_reg = 1; op4_is_reg = 1; op1_orig = 3; op2_orig = 5; op3_orig = 7; op4_orig = 2;
    op1_size = 2; op2_size = 2; op3_size = 2; op4_size = 2; conditionals= 0; aluk = 0;
    MUX_ADDER_IMM = 0; EIP_in = 32'h1234_1234; MUX_AND_INT = 0;
     MUX_SHIFT = 0; load_eip_in = 0; load_segReg_in = 0; FMASK = 0; P_OP = 0;
    pred_T_NT = 0; pred_target = 0; isBR = 0; is_fp = 0; stall = 0;load_eip_in_op1 = 0;load_eip_in_op2 = 0;load_segReg_in_op1 = 0;load_segReg_in_op2 = 0;
    rst = 0;
    set = 1;
    #10
    rst = 1;
    op3 = 64'h0000_FFFF_FFFF_FFFF;
    op1 = 64'h7313_8013_9F13_83F4;
    op2 = 64'h4111_9011_0000_0185;
    op4 = 64'h1234_1234_1234_1234;
    for(i = 0; i < 20; i = i + 1) begin 
        #cycle_time
        aluk = i;
        op3 = 64'h0000_FFFF_FFFF_FFFF;
        op1 = 64'h7313_8013_9F13_83F4;
        op2 = 64'h4111_9011_0000_0185;
        op4 = 64'h1234_1234_1234_1234;
        #cycle_time
        op1 = 0; op2 = 0; op3=0; op4 = 0;
        aluk = 0;
        
    end
    end





endmodule