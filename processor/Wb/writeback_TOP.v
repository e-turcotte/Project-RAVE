module writeback_TOP(
    input clk,
    input valid_in,
    input [31:0] EIP_in,
    input [31:0] latched_EIP_in,
    input IE_in,                           //interrupt or exception signal
    input [3:0] IE_type_in,
    input [31:0] BR_pred_target_in,
    input BR_pred_T_NT_in,
    input [5:0] BP_alias_in,
    input [6:0] inst_ptcid_in,
    input set, rst,

    input [63:0] inp1, inp2, inp3, inp4,
    input  inp1_isReg,  inp2_isReg, inp3_isReg,  inp4_isReg,
    input  inp1_isSeg,  inp2_isSeg, inp3_isSeg,  inp4_isSeg,
    input  inp1_isMem,  inp2_isMem, inp3_isMem,  inp4_isMem,  
    input [31:0] inp1_dest, inp2_dest, inp3_dest, inp4_dest,
    input [1:0] inpsize,
    input inp1_wb, inp2_wb, inp3_wb, inp4_wb,
    input [127:0] inp1_ptcinfo, inp2_ptcinfo, inp3_ptcinfo, inp4_ptcinfo,

    input BR_valid_in, BR_taken_in, BR_correct_in,
    input[31:0] BR_FIP_in, BR_FIP_p1_in,
    input[15:0] CS_in,
    input [17:0] EFLAGS_in,
    input [36:0] P_OP,

    input interrupt_in,

    input wbaq_full, is_rep,

    output valid_out, //TODO

    output [63:0] res1, res2, res3, res4, mem_data, //done
    output [127:0] res1_ptcinfo, res2_ptcinfo, res3_ptcinfo, res4_ptcinfo,
    output [1:0] ressize, memsize,
    output [11:0] reg_addr, seg_addr,
    output [31:0] mem_addr, //done
    output [3:0] reg_ld, seg_ld,
    output mem_ld,
    output [6:0] inst_ptcid_out,

    output [31:0] newFIP_e, newFIP_o, newEIP, //done 
    output [31:0] latched_EIP_out,
    output BR_valid, BR_taken, BR_correct, //done
    output [5:0] WB_BP_update_alias,
    output is_resteer,
    output [15:0] CS_out, //done

    output stall,

    output final_IE_val,
    output [3:0] final_IE_type
    );

    assign inst_ptcid_out = inst_ptcid_in;


    mux2n #(16) mxn(res1, inp1, {{48{1'b0}},inp1[47:32]}, LD_EIP_CS);
    assign res2 = inp2;
    assign res3 = inp3;
    assign res4 = inp4;
    assign ressize = inpsize;

    assign reg_addr = {inp1_dest[2:0],inp2_dest[2:0],inp3_dest[2:0],inp4_dest[2:0]};
    and3$ g100(.out(reg_ld[3]), .in0(inp4_isReg), .in1(valid_out), .in2(inp1_wb));
    and3$ g101(.out(reg_ld[2]), .in0(inp3_isReg), .in1(valid_out), .in2(inp2_wb));
    and3$ g102(.out(reg_ld[1]), .in0(inp2_isReg), .in1(valid_out), .in2(inp3_wb));
    and3$ g103(.out(reg_ld[0]), .in0(inp1_isReg), .in1(valid_out), .in2(inp4_wb));
    assign seg_addr = {inp1_dest[2:0],inp2_dest[2:0],inp3_dest[2:0],inp4_dest[2:0]};
    and3$ g104(.out(seg_ld[3]), .in0(inp4_isSeg), .in1(valid_out), .in2(inp1_wb));
    and3$ g105(.out(seg_ld[2]), .in0(inp3_isSeg), .in1(valid_out), .in2(inp2_wb));
    and3$ g106(.out(seg_ld[1]), .in0(inp2_isSeg), .in1(valid_out), .in2(inp3_wb));
    and3$ g107(.out(seg_ld[0]), .in0(inp1_isSeg), .in1(valid_out), .in2(inp4_wb));

    wire [127:0] sreg_ptcs [0:3];
    wire [6:0] flip_ptcid, ptctouse;

    invn flip(.in(inst_ptcid_in), .out(flip_ptcid));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(7)) m3456789(.in({flip_ptcid,inst_ptcid_in}), .sel(is_rep), .out(ptctouse));
    assign sreg_ptcs[3] = {inp4_ptcinfo[127:126],ptctouse,inp4_ptcinfo[118:112],
                           inp4_ptcinfo[111:110],ptctouse,inp4_ptcinfo[102:96],
                           inp4_ptcinfo[95:94],ptctouse,inp4_ptcinfo[86:80],
                           inp4_ptcinfo[79:78],ptctouse,inp4_ptcinfo[70:64],
                           inp4_ptcinfo[63:62],ptctouse,inp4_ptcinfo[54:48],
                           inp4_ptcinfo[47:46],ptctouse,inp4_ptcinfo[38:32],
                           inp4_ptcinfo[31:30],ptctouse,inp4_ptcinfo[22:16],
                           inp4_ptcinfo[15:14],ptctouse,inp4_ptcinfo[6:0]};
    assign sreg_ptcs[2] = {inp3_ptcinfo[127:126],inst_ptcid_in,inp3_ptcinfo[118:112],
                           inp3_ptcinfo[111:110],inst_ptcid_in,inp3_ptcinfo[102:96],
                           inp3_ptcinfo[95:94],inst_ptcid_in,inp3_ptcinfo[86:80],
                           inp3_ptcinfo[79:78],inst_ptcid_in,inp3_ptcinfo[70:64],
                           inp3_ptcinfo[63:62],inst_ptcid_in,inp3_ptcinfo[54:48],
                           inp3_ptcinfo[47:46],inst_ptcid_in,inp3_ptcinfo[38:32],
                           inp3_ptcinfo[31:30],inst_ptcid_in,inp3_ptcinfo[22:16],
                           inp3_ptcinfo[15:14],inst_ptcid_in,inp3_ptcinfo[6:0]};
    assign sreg_ptcs[1] = {inp2_ptcinfo[127:126],inst_ptcid_in,inp2_ptcinfo[118:112],
                           inp2_ptcinfo[111:110],inst_ptcid_in,inp2_ptcinfo[102:96],
                           inp2_ptcinfo[95:94],inst_ptcid_in,inp2_ptcinfo[86:80],
                           inp2_ptcinfo[79:78],inst_ptcid_in,inp2_ptcinfo[70:64],
                           inp2_ptcinfo[63:62],inst_ptcid_in,inp2_ptcinfo[54:48],
                           inp2_ptcinfo[47:46],inst_ptcid_in,inp2_ptcinfo[38:32],
                           inp2_ptcinfo[31:30],inst_ptcid_in,inp2_ptcinfo[22:16],
                           inp2_ptcinfo[15:14],inst_ptcid_in,inp2_ptcinfo[6:0]};
    assign sreg_ptcs[0] = {inp1_ptcinfo[127:126],inst_ptcid_in,inp1_ptcinfo[118:112],
                           inp1_ptcinfo[111:110],inst_ptcid_in,inp1_ptcinfo[102:96],
                           inp1_ptcinfo[95:94],inst_ptcid_in,inp1_ptcinfo[86:80],
                           inp1_ptcinfo[79:78],inst_ptcid_in,inp1_ptcinfo[70:64],
                           inp1_ptcinfo[63:62],inst_ptcid_in,inp1_ptcinfo[54:48],
                           inp1_ptcinfo[47:46],inst_ptcid_in,inp1_ptcinfo[38:32],
                           inp1_ptcinfo[31:30],inst_ptcid_in,inp1_ptcinfo[22:16],
                           inp1_ptcinfo[15:14],inst_ptcid_in,inp1_ptcinfo[6:0]};

    wire [3:0] notneedptc;
    
    nor3$ qwerty(.out(notneedptc[3]), .in0(inp4_isReg), .in1(inp4_isSeg), .in2(inp4_isMem));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(128)) mqwerty(.in({128'h0,sreg_ptcs[3],sreg_ptcs[3],inp4_ptcinfo}), .sel({notneedptc[3],inp4_isReg,inp4_isSeg,inp4_isMem}), .out(res4_ptcinfo));
    nor3$ uiop(.out(notneedptc[2]), .in0(inp3_isReg), .in1(inp3_isSeg), .in2(inp3_isMem));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(128)) muiop(.in({128'h0,sreg_ptcs[2],sreg_ptcs[2],inp3_ptcinfo}), .sel({notneedptc[2],inp3_isReg,inp3_isSeg,inp3_isMem}), .out(res3_ptcinfo));
    nor3$ dvorak(.out(notneedptc[1]), .in0(inp2_isReg), .in1(inp2_isSeg), .in2(inp2_isMem));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(128)) mdvorak(.in({128'h0,sreg_ptcs[1],sreg_ptcs[1],inp2_ptcinfo}), .sel({notneedptc[1],inp2_isReg,inp2_isSeg,inp2_isMem}), .out(res2_ptcinfo));
    nor3$ zxcvb(.out(notneedptc[0]), .in0(inp1_isReg), .in1(inp1_isSeg), .in2(inp1_isMem));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(128)) mzxcvb(.in({128'h0,sreg_ptcs[0],sreg_ptcs[0],inp1_ptcinfo}), .sel({notneedptc[0],inp1_isReg,inp1_isSeg,inp1_isMem}), .out(res1_ptcinfo));
    
    
    assign CS_out = CS_in;

    wire LD_EIP_CS;

    or3$ o2(LD_EIP_CS, P_OP[36], P_OP[35], P_OP[32]);

    muxnm_tristate #(.SEL_WIDTH(4), .DATA_WIDTH(64)) t1(.in({inp1,inp2,inp3,inp4}), .sel({inp1_isMem,inp2_isMem,inp3_isMem,inp4_isMem}), .out(mem_data));
    muxnm_tristate #(.SEL_WIDTH(4), .DATA_WIDTH(32)) t2(.in({inp1_dest,inp2_dest,inp3_dest,inp4_dest}), .sel({inp1_isMem,inp2_isMem,inp3_isMem,inp4_isMem}), .out(mem_addr));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(2)) m0(.in({2'b11,ressize}), .sel(LD_EIP_CS), .out(memsize));

    mux2n #(32) m1(FIP_e   , {BR_FIP_in[31:4],4'd0}, {BR_FIP_p1_in, 4'd0}, BR_FIP_in[5]);
    mux2n #(32) m2(FIP_o, {BR_FIP_p1_in, 4'd0}, {BR_FIP_in[31:4],4'd0}, BR_FIP_in[5]);

    wire [31:0] targetEIP;

    mux2n #(32) m25(targetEIP, BR_FIP_in, inp1[31:0], LD_EIP_CS);
    mux2n #(32) m3 (newEIP,EIP_in, targetEIP, BR_taken); //TODO: set newEIP to NT target or T target
    assign BR_valid = BR_valid_in;
    assign BR_taken = BR_taken_in;
    assign BR_correct = BR_correct_in;
    inv1$ g0(.out(is_resteer), .in(BR_correct_in));
    assign latched_EIP_out = latched_EIP_in;
    assign WB_BP_update_alias = BP_alias_in;

    wire might_mem_ld, invstall;

    or4$ o94(.out(might_mem_ld), .in0(inp1_isMem), .in1(inp1_isMem), .in2(inp2_isMem), .in3(inp3_isMem));
    and2$ g108(.out(mem_ld), .in0(might_mem_ld), .in1(valid_out));
    and2$ a94(.out(stall), .in0(wbaq_full), .in1(mem_ld)); 
    inv1$ i92(.out(invstall), .in(stall));
    and2$ asd(.out(valid_out), .in0(valid_in), .in1(invstall));

    assign final_IE_type[2:0] = IE_type_in[2:0]; //TODO: Rohan's IE stuff
    assign final_IE_type[3] = interrupt_in;
    or2$ o4(.out(final_IE_val), .in0(IE_in), .in1(interrupt_in));

    //TODO: Send final IE signal to stall/flush all stages and send final IE_type to exception handling in Fetch 2

endmodule