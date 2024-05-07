module writeback_TOP(
    input clk,
    input valid_in,
    input [31:0] EIP_in,
    input IE_in,                           //interrupt or exception signal
    input [3:0] IE_type_in,
    input [31:0] BR_pred_target_in,
    input BR_pred_T_NT_in,
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
    output BR_valid, BR_taken, BR_correct, //done
    output is_resteer,
    output [15:0] CS_out, //done

    output final_IE_val,
    output [3:0] final_IE_type
    );

    mux2n #(16) mxn(res1, {{48{1'b0}},inp1[47:32]}, inp1, LD_EIP_CS);
    assign res2 = inp2;
    assign res3 = inp3;
    assign res4 = inp4;
    assign ressize = inpsize;

    assign reg_addr = {inp1_dest[2:0],inp2_dest[2:0],inp3_dest[2:0],inp4_dest[2:0]};
    assign reg_ld = {inp1_isReg,inp2_isReg,inp3_isReg,inp4_isReg};
    assign seg_addr = {inp1_dest[2:0],inp2_dest[2:0],inp3_dest[2:0],inp4_dest[2:0]};
    assign seg_ld = {inp1_isSeg,inp2_isSeg,inp3_isSeg,inp4_isSeg};
    
    assign CS_out = CS_in;

    wire LD_EIP_CS;

    or3$ o2(LD_EIP_CS, P_OP[36], P_OP[35], P_OP[32]);

    mux_tristate #(.SEL_WIDTH(4), .DATA_WIDTH(64)) t1(.in({inp1,inp2,inp3,inp4}), .sel({inp1_isMem,inp2_isMem,inp3_isMem,inp4_isMem}), .out(mem_data));
    mux_tristate #(.SEL_WIDTH(4), .DATA_WIDTH(32)) t2(.in({inp1_dest,inp2_dest,inp3_dest,inp4_dest}), .sel({inp1_isMem,inp2_isMem,inp3_isMem,inp4_isMem}), .out(mem_addr));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(2)) m0(.in({2'b11,ressize}), .sel(LD_EIP_CS), .out(memsize));

    mux2n #(32) m1(FIP_e   , {BR_FIP_in[31:4],4'd0}, {BR_FIP_p1_in, 4'd0}, BR_FIP_in[5]);
    mux2n #(32) m2(FIP_o, {BR_FIP_p1_in, 4'd0}, {BR_FIP_in[31:4],4'd0}, BR_FIP_in[5]);

    wire [31:0] targetEIP;

    mux2n #(32) m25(targetEIP, BR_FIP_in, inp1[31:0], LD_EIP_CS);
    mux2n #(32) m3 (newEIP,EIP_in, targetEIP , BR_taken); //TODO: set newEIP to NT target or T target
    assign BR_valid = BR_valid_in;
    assign BR_taken = BR_taken_in;
    assign BR_correct = BR_correct_in;
    inv1$ g0(.out(is_resteer), .in(BR_correct_in));

    assign valid_out = valid_in;

    assign final_IE_type[2:0] = IE_type_in[2:0]; //TODO: Rohan's IE stuff
    assign final_IE_type[3] = interrupt_in;
    or2$ o4(.out(final_IE_val), .in0(IE_in), .in1(interrupt_in));

    //TODO: Send final IE signal to stall/flush all stages and send final IE_type to exception handling in Fetch 2

endmodule