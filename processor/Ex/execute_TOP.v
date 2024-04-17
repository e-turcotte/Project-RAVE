module execute_TOP(
 output valid,
 
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
 
 output load_EIP, //done
 output load_segReg, //done
 
 input valid_in,

 input op1_wb,
 input[63:0] op1,
 input op1_is_reg,
 input[31:0] op1_orig,
 input[1:0] op1_size,
 
 input[63:0] op2,
 input op2_is_reg,
 input[31:0] op2_orig,
 input[1:0] op2_size,
 
 input[63:0] op3,
 input op3_is_reg,
 input[31:0] op3_orig,
 input[1:0] op3_size,
 
 input[4:0] aluk,
 input [2:0] MUX_ADDER_IMM,
 input MUX_AND_INT,
 input MUX_SHIFT,
 
 input[33:0] P_OP,
 input load_eip_in,
 input load_segReg_in,
 input [16:0] FMASK,
 input [1:0] conditionals,
 
 input pred_T_NT,
 input pred_target,
 input isBR,
 input is_fp,
 input[31:0] EIP_in, 
 
 //Global
 input stall,
 input set, rst,
 input clk,
 input interrupt,
 
 //BR Outputs
 output BR_valid, //
 output BR_taken, //
 output BR_correct,  //
 output[47:0] BR_dest, //
 output [31:0] BR_EIP //
 
);

wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_val;
wire af, cf, of, sf, pf, zf, df;
assign load_eip = load_eip_in;
assign BR_EIP = EIP_in;
assign load_segReg = load_segReg_in;
assign res2_wb = P_OP[33];
assign res1_wb = op1_wb;
wire swapCXC; 

//Handle RES1/RES2
 mux4n #(64) mx1(res1_is_reg, op1_is_res, op2_is_reg, op2_is_reg, op2_isr_reg, swapCXC, P_OP[33]);
 mux2n #(64) mx2(res2_is_reg, op2_is_res, op1_is_reg, P_OP[33]);
 mux2n #(32) mx3(res2_dest, op2_orig, op1_orig, P_OP[33]);
 mux2n #(32) mx4(res1_dest, res1_dest_out, op2_orig, P_OP[33]);
 assign res1_size = op1_size;
 assign res2_size = op2_size;

//handle ALU
ALU_top a1(res1, res1_dest_out, res2, swapCXC, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_inval, op1, op2, op3, op1_orig, aluk, MUX_ADDER_IMM, MUX_AND_INT, MUX_SHIFT, P_OP[7], P_OP[2], P_OP[31],P_OP[29], P_OP[30], op1_size,af,cf,zf); 

//Handle eflags block
wire[16:0] eflags_ld, eflags_rd;
assign eflags_ld = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, of_out, df_out,  1'b0, 1'b0, sf_out, zf_out, af_out, pf_out, cf_out}; 
assign af = eflags_rd[2]; assign cf = eflags_rd[0];  assign pf = eflags_rd[1]; assign zf = eflags_rd[3];   assign sf = eflags_rd[4];  assign df = eflags_rd[7];  assign of = eflags_rd[8];     
EFLAG e1(eflags_rd, clk, set, rst, valid_in, eflags_ld, FMASK, cc_inval);

//Handle skipGen
wire skip;
SKIPGEN s1(skip, P_OP[6], P_OP[11], P_OP[12], cf, zf, condtionals);
inv1$ i1(skip_n, skip);
and2$ a2(valid, valid_n, skip_n);

//HandleBRLOGIC
BRLOGIC b1(BR_valid, BR_taken, BR_correctm, BR_dest, valid_in, pred_target, pred_T_NT, conditionals, , zf, cf, res1, P_OP[11], P_OP[12], P_OP[32]);
endmodule 

/*
P_OP List/Numbering
0	ADD
1	AND
2	BSF
3	CALL
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
*/