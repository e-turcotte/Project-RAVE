//ADD EFLAG_Override
//ADD EIPswap
//handle EIP+CS in execute
// add {CS, EIP} to ALU
// swap EIP and CS to res2
//Handle ESP-4 ,2 for OP3
//verify CMOVC reads both r132 and rm32

module execute_TOP(
 output valid,
 output[17:0] eflags, 
 
 output res1_wb,
 output [63:0] res1, //done
 output res1_is_reg, //done
 output [31:0] res1_dest, //
 output [1:0] res1_size, //done
 
 output res2_wb,
 output [63:0] res2, //done
 output res2_is_reg,//done
 output [31:0] res2_dest,//
 output [1:0] res2_size,//done
 
  output res3_wb,
 output [63:0] res3, //done
 output res3_is_reg,//done
 output [31:0] res3_dest,//
 output [1:0] res3_size,//done
 
 output res4_wb,
 output [63:0] res4, //done
 output res4_is_reg,//done
 output [31:0] res4_dest,//
 output [1:0] res4_size,//done
 
 output load_eip_in_res1,
 output load_segReg_in_res1,
 output load_eip_in_res2,
 output load_segReg_in_res2,
 
 input valid_in,

 input op1_wb,
 input[63:0] op1,
 input op1_is_reg,
 input[31:0] op1_orig,
 input[1:0] op1_size,
 
 input op2_wb,
 input[63:0] op2,
 input op2_is_reg,
 input[31:0] op2_orig,
 input[1:0] op2_size,
 
 input op3_wb,
 input[63:0] op3,
 input op3_is_reg,
 input[31:0] op3_orig,
 input[1:0] op3_size,
 
 input op4_wb,
 input[63:0] op4,
 input op4_is_reg,
 input[31:0] op4_orig,
 input[1:0] op4_size,
 
 //From ContStore
 input[4:0] aluk,
 input [2:0] MUX_ADDER_IMM,
 input MUX_AND_INT,
 input MUX_SHIFT,
 input[34:0] P_OP,
 input load_eip_in_op1,
 input load_segReg_in_op1,
 input load_eip_in_op2,
 input load_segReg_in_op2,
 input [16:0] FMASK,
 input [1:0] conditionals,
 
 //From BP
 input pred_T_NT,
 input pred_target,
 input isBR,
 input is_fp,
 input[31:0] EIP_in, 
 input[15:0] CS,
 //Global
 input stall,
 input set, rst,
 input clk,
 input interrupt,
 
 //BR Outputs
 output BR_valid, //
 output BR_taken, //
 output BR_correct,  //
 output[31:0] BR_FIP, //
 output [31:0] BR_FIP_p1,
 output [31:0] EIP_out //

);

wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_val;
wire af, cf, of, sf, pf, zf, df;
assign EIP_out = EIP_in;
assign res2_wb = op2_wb;
assign res1_wb = op1_wb;
wire swapCXC; 
wire[63:0] res2_xchg;
or2$ g1(gBR, load_eip_in_op1,load_eip_in_op2,);

assign load_eip_in_res1 = load_eip_in_op1;
assign load_segReg_in_res1 = load_segReg_in_op1;
assign load_eip_in_res2= load_eip_in_op2;
assign load_segReg_in_res2 =load_segReg_in_op2;

//handle RES3/RES4
assign res4 = op4;
assign res4_is_reg = op4_is_reg;
assign res4_dest = op4_orig;
assign res4_size = op4_size;
assign res4_wb = op4_wb;

assign res3 = op3;
assign res3_is_reg = op3_is_reg;
assign res3_dest = op3_orig;
assign res3_size = op3_size;
assign res3_wb = op3_wb;

wire[31:0] res1_dest_out;

//Handle RES1/RES2
// mux4n #(64) mx1(res1_is_reg, op1_is_reg, op2_is_reg, op2_is_reg, op2_is_reg, swapCXC, P_OP[33]);
 mux2n #(32) mx4(res1_dest, res1_dest_out, op2_orig, P_OP[33]);
 assign res1_is_reg = op1_is_reg;
 
 mux2n #(64) mx5(res2, res2_xchg, op2, P_OP[15]);
// mux2n #(64) mx2(res2_is_reg, op2_is_reg, op1_is_reg, P_OP[33]);
// mux2n #(32) mx3(res2_dest, op2_orig, op1_orig, P_OP[33]);
assign res2_is_reg = op2_is_reg;
assign res2_dest = op2_orig;
 
 assign res1_size = op1_size;
 assign res2_size = op2_size;

//handle ALU
ALU_top a1(res1, res1_dest_out, res2_xchg, swapCXC, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_inval, op1, op2, op3, op1_orig, aluk, MUX_ADDER_IMM, MUX_AND_INT, MUX_SHIFT, P_OP[7], P_OP[2], P_OP[31],P_OP[29], P_OP[30], op1_size,af,cf,zf); 

//Handle eflags block
wire[17:0] eflags_ld, eflags_rd;
assign eflags = eflags_rd;
assign eflags_ld = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, of_out, df_out,  1'b0, 1'b0, sf_out, zf_out, af_out, pf_out, cf_out}; 
assign af = eflags_rd[2]; assign cf = eflags_rd[0];  assign pf = eflags_rd[1]; assign zf = eflags_rd[3];   assign sf = eflags_rd[4];  assign df = eflags_rd[7];  assign of = eflags_rd[8];     
EFLAG e1(eflags_rd, clk, set, rst, valid_in, eflags_ld, FMASK, cc_inval);

//Handle skipGen
wire skip;
SKIPGEN s1(skip, P_OP[6], P_OP[11], P_OP[12], cf, zf, conditionals);
inv1$ i1(skip_n, skip);
and2$ a2(valid, valid_in, skip_n);

//HandleBRLOGIC
assign BR_EIP = EIP_in;
BRLOGIC b1(BR_valid, BR_taken, BR_correct, BR_FIP, BR_FIP_p1, valid_in, pred_target, pred_T_NT, conditionals, zf, cf, res1[31:0], P_OP[11], P_OP[12], P_OP[32], gBR);
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