//ADD EFLAG_Override
//ADD EIPswap
//handle EIP+CS in execute
// add {CS, EIP} to ALU
// swap EIP and CS to res2
//Handle ESP-4 ,2 for OP4
//verify CMOVC reads both r132 and rm32
// handle push for OP3 and decrementing ESP
//How is POP handled in RRAG
//Look into how to handle skipgen when BR pred taken but actually not
//allow OP4 = OP4 + OP2

module execute_TOP(
    input clk,
    input valid_in,                         // N
    input [31:0] EIP_in,                    // N
    input IE_in,                            //interrupt or exception signal - N
    input [3:0] IE_type_in,                 // N
    input [31:0] BR_pred_target_in,         //branch prediction target - N
    input BR_pred_T_NT_in,                  //branch prediction taken or not taken - N
    input set, rst,                        

    input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in, //N

    input[63:0] op1, op2, op3, op4, //M
    input [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo, //M
    input [3:0] wake_in, //TODO: M, needs to be implemented - not implemented in TOP just yet

    input [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr, //N
    input res1_is_reg_in, res2_is_reg_in, res3_is_reg_in, res4_is_reg_in, //N
    input res1_is_seg_in, res2_is_seg_in, res3_is_seg_in, res4_is_seg_in, //N
    input res1_is_mem_in, res2_is_mem_in, res3_is_mem_in, res4_is_mem_in, //N
    input[1:0] opsize_in, //N
    
    //From ContStore
    input[4:0] aluk, //N
    input [2:0] MUX_ADDER_IMM, //N
    input MUX_AND_INT,  //N
    input MUX_SHIFT, //N
    input[34:0] P_OP, //N
    input [16:0] FMASK, //N
    input [1:0] conditionals, //N
    
    //From BP
    input isBR,     //N
    input is_fp,    //N
    input[15:0] CS, //N
    //Global

    output valid_out,
    output [31:0] EIP_out, //
    output IE_out,
    output [3:0] IE_type_out,
    output [31:0] BR_pred_target_out,
    output BR_pred_T_NT_out,
    
    output[17:0] eflags,
    output[15:0] CS_out, 
    
    output res1_wb, res2_wb, res3_wb, res4_wb,
    output [63:0] res1, res2, res3, res4, //done
    output res1_is_reg_out, res2_is_reg_out, res3_is_reg_out, res4_is_reg_out, //done
    output res1_is_seg_out, res2_is_seg_out, res3_is_seg_out, res4_is_seg_out, //done
    output res1_is_mem_out, res2_is_mem_out, res3_is_mem_out, res4_is_mem_out, //done
    output [31:0] res1_dest, res2_dest, res3_dest, res4_dest, //
    output [1:0] ressize, //done
        
    //BR Outputs
    output BR_valid, //
    output BR_taken, //
    output BR_correct,  //
    output[31:0] BR_FIP, //
    output [31:0] BR_FIP_p1
    output [3:0] wake_out, //TODO: M, needs to be implemented if necessary - not implemented in TOP just yet

);

    wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_val;
    wire af, cf, of, sf, pf, zf, df;
    assign EIP_out = EIP_in;
    assign res2_wb = res2_ld_in;
    assign res1_wb = res1_ld_in;
    wire swapCXC; 
    wire[63:0] res2_xchg;
    or2$ g1(gBR, load_eip_in_op1,load_eip_in_op2,);

    //handle RES3/RES4
    assign ressize = opsize_in;

    assign res4 = op4;
    assign res4_is_reg_out = res4_is_reg_in;
    assign res4_is_seg_out = res4_is_seg_in;
    assign res4_is_mem_out = res4_is_mem_in;
    assign res4_dest = dest4_addr;
    assign res4_wb = res4_ld_in;

    assign res3 = op3;
    assign res3_is_reg_out = res3_is_reg_in;
    assign res3_is_seg_out = res3_is_seg_in;
    assign res3_is_mem_out = res3_is_mem_in;
    assign res3_dest = dest3_addr;
    assign res3_wb = res3_ld_in;

    wire[31:0] res1_dest_out;

    //Handle RES1/RES2
    // mux4n #(64) mx1(res1_is_reg, op1_is_reg, op2_is_reg, op2_is_reg, op2_is_reg, swapCXC, P_OP[33]);
    mux2n #(32) mx4(res1_dest, res1_dest_out, dest2_addr, P_OP[33]);
    assign res1_is_reg_out = res1_is_reg_in;
    assign res1_is_seg_out = res1_is_seg_in;
    assign res1_is_mem_out = res1_is_mem_in;
    
    mux2n #(64) mx5(res2, res2_xchg, op2, P_OP[15]);
    // mux2n #(64) mx2(res2_is_reg, op2_is_reg, op1_is_reg, P_OP[33]);
    // mux2n #(32) mx3(res2_dest, dest2_addr, dest1_addr, P_OP[33]);
    assign res2_is_reg_out = res2_is_reg_in;
    assign reg2_is_seg_out = res2_is_seg_in;
    assign res2_is_mem_out = res2_is_mem_in;
    assign res2_dest = dest2_addr;

    //handle ALU
    ALU_top a1(res1, res1_dest_out, res2_xchg, swapCXC, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_inval, op1, op2, op3, dest1_addr, aluk, MUX_ADDER_IMM, MUX_AND_INT, MUX_SHIFT, P_OP[7], P_OP[2], P_OP[31],P_OP[29], P_OP[30], opsize_in,af,cf,of,zf, CS, EIP_in); 

    //Handle eflags block
    wire[17:0] eflags_ld, eflags_rd;
    assign eflags = eflags_rd;
    assign eflags_ld = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, of_out, df_out,  1'b0, 1'b0, sf_out, zf_out, af_out, pf_out, cf_out}; 
    assign af = eflags_rd[2]; assign cf = eflags_rd[0];  assign pf = eflags_rd[1]; assign zf = eflags_rd[3];   assign sf = eflags_rd[4];  assign df = eflags_rd[7];  assign of = eflags_rd[8];     
    EFLAG e1(eflags_rd, clk, set, rst, valid_in, eflags_ld, FMASK, cc_inval);
    assign CS_out = CS;
    //Handle skipGen
    wire skip;
    SKIPGEN s1(skip, P_OP[6], P_OP[11], P_OP[12], cf, zf, conditionals);
    inv1$ i1(skip_n, skip);
    and2$ a2(valid_out, valid_in, skip_n);

    //HandleBRLOGIC
    assign BR_EIP = EIP_in;
    BRLOGIC b1(BR_valid, BR_taken, BR_correct, BR_FIP, BR_FIP_p1, valid_in, BR_pred_target_in, BR_pred_T_NT_in, conditionals, zf, cf, res1[31:0], P_OP[11], P_OP[12], P_OP[32], gBR);

    //TODO: exception checking for DIV0 for FDIV
    //      - without throwing exception, result from Goldschmidt div will be 0:

    //assign IE_type_out[1:0] = IE_type_in[1:0];
    //assign IE_type_out[2] fp_div0_exception;
    //assign IE_type_out[3] = IE_type_in[3];
    //or2$ g3(.out(IE_out), .in0(IE_in), .in1(fp_div0_exception);

endmodule

/*
P_OP List/Numbering
0	ADD
1	AND
2	BSF
3	CALLnear
4	CLD
5	STD
6	CMOVC
7	CMPXCHG
8	DAA
9	HLT
0	IREtd
11	JMPnear
12	JMPfar
13	MOV
14	MOVQ
15	MOVS
16	NOT
17	OR
18	PADDW
19	PADDD
20	PACKSSWB
21	PACKSSDW
22	PUNPCKHBW
23	PUNPCKHWD
24	POP
25	POP_seg
26	PUSH
27	PUSH_seg
28	RET
29	SAL
30	SAR
31      STD
32 	JMPptr
33  XCHG
34 CALLfar
*/
