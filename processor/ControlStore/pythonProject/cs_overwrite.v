module cs_overwrite(
output [0:0] isMOD,
output [0:0] modSWAP,
output [0:0] isDouble,
output [7:0] OPCext,
output [4:0] aluk,
output [2:0] MUX_ADDER_IMM,
output [0:0] MUX_AND_INT,
output [0:0] MUX_SHIFT,
output [36:0] P_OP,
output [17:0] FMASK,
output [1:0] conditionals,
output [0:0] swapEIP,
output [0:0] isBR,
output [0:0] isFP,
output [0:0] isImm,
output [1:0] immSize,
output [1:0] size,
output [2:0] R1,
output [2:0] R2,
output [2:0] R3,
output [2:0] R4,
output [2:0] S1,
output [2:0] S2,
output [2:0] S3,
output [2:0] S4,
output [12:0] op1_mux,
output [12:0] op2_mux,
output [12:0] op3_mux,
output [12:0] op4_mux,
output [12:0] dest1_mux,
output [12:0] dest2_mux,
output [12:0] dest3_mux,
output [12:0] dest4_mux,
output [0:0] op1_wb,
output [0:0] op2_wb,
output [0:0] op3_wb,
output [0:0] op4_wb,
output [0:0] R1_MOD_OVR,
output [1:0] M1_RW,
output [1:0] M2_RW,
output [1:0] OP_MOD_OVR,
output [0:0] S3_MOD_OVR,
output [3:0] memSizeOVR,

input isSIB,
input [229:0] chosen,
 input isREP, isSIZE, isSEG,
 input[3:0] prefSize, 
 input[5:0] segSEL,
input [7:0] B1, B2, B3,
input [2:0] r2_act,
input [2:0] r3_act);
wire[7:0] m;
wire[2:0] S10a;
wire [0:0] isMOD0; wire [0:0] modSWAP0; wire [0:0] isDouble0; wire [7:0] OPCext0; wire [4:0] aluk0; wire [2:0] MUX_ADDER_IMM0; wire [0:0] MUX_AND_INT0; wire [0:0] MUX_SHIFT0; wire [36:0] P_OP0; wire [17:0] FMASK0; wire [1:0] conditionals0; wire [0:0] swapEIP0; wire [0:0] isBR0; wire [0:0] isFP0; wire [0:0] isImm0; wire [1:0] immSize0; wire [1:0] size0; wire [2:0] R10; wire [2:0] R20; wire [2:0] R30; wire [2:0] R40; wire [2:0] S10; wire [2:0] S20; wire [2:0] S30; wire [2:0] S40; wire [12:0] op1_mux0; wire [12:0] op2_mux0; wire [12:0] op3_mux0; wire [12:0] op4_mux0; wire [12:0] dest1_mux0; wire [12:0] dest2_mux0; wire [12:0] dest3_mux0; wire [12:0] dest4_mux0; wire [0:0] op1_wb0; wire [0:0] op2_wb0; wire [0:0] op3_wb0; wire [0:0] op4_wb0; wire [0:0] R1_MOD_OVR0; wire [1:0] M1_RW0; wire [1:0] M2_RW0; wire [1:0] OP_MOD_OVR0; wire [0:0] S3_MOD_OVR0; wire [3:0] memSizeOVR0; 
inv1$ inv1(size_n, isSIZE);
inv1$ inv2(size1_n, size0[1]);
nor3$ n1(size_s, size_n, size1_n, size0[0]);
mux2n #(2)mx12(size, size0, 2'b01, size_s);
csAdapter csa0(.memSizeOVR(memSizeOVR0), .S3_MOD_OVR(S3_MOD_OVR), .OP_MOD_OVR(OP_MOD_OVR), .M2_RW(M2_RW), .M1_RW(M1_RW0), .R1_MOD_OVR(R1_MOD_OVR), .op4_wb(op4_wb0), .op3_wb(op3_wb), .op2_wb(op2_wb), .op1_wb(op1_wb), .dest4_mux(dest4_mux), .dest3_mux(dest3_mux), .dest2_mux(dest2_mux0), .dest1_mux(dest1_mux0), .op4_mux(op4_mux), .op3_mux(op3_mux), .op2_mux(op2_mux0), .op1_mux(op1_mux0), .S4(S4), .S3(S30), .S2(S2), .S1(S10), .R4(R4), .R3(R3), .R2(R20), .R1(R10), .size(size0), .immSize(immSize0), .isImm(isImm), .isFP(isFP), .isBR(isBR), .swapEIP(swapEIP), .conditionals(conditionals), .FMASK(FMASK), .P_OP(P_OP), .MUX_SHIFT(MUX_SHIFT), .MUX_AND_INT(MUX_AND_INT), .MUX_ADDER_IMM(MUX_ADDER_IMM), .aluk(aluk), .OPCext(OPCext), .isDouble(isDouble), .modSWAP(modSWAP), .isMOD(isMOD), .toSplit(chosen));
mux2n  # (8) m1x(m, B2, B3, isDouble);

or2$ norsax(sal_size_8_hotfix, immSize0[0], immSize0[1]);
and3$ (imm_size_ovr_no8,size_s, isImm, sal_size_8_hotfix);
mux2n #(2) mx13(immSize, immSize0, 2'b01, imm_size_ovr_no8);


mux2$ mx1(m1, B2[6], B3[6], isDouble);
mux2$ mx2(m2, B2[7], B3[7], isDouble);
or2$  or123(opmodovr, OP_MOD_OVR[0], OP_MOD_OVR[1]);
and4$ a1(m1rw_s, isMOD, m1, m2, opmodovr);
// and4$ a22(m2rw_s, isMOD, m1, m2, OP_MOD_OVR[1]);
mux2n  # (2) mx3(M1_RW, M1_RW0, 2'b00, m1rw_s);
// mux2n  # (2) mx33(M2_RW, M2_RW0, 2'b00, m2rw_s);
and2$ a2(s3_s, isMOD,  S3_MOD_OVR);
mux2n  # (3)  mx4(S3, S30, m[5:3], s3_s);
and2$ a3(r1_s, isMOD, R1_MOD_OVR);
// and4$ a3(r1_s, isMOD, m1, m2, R1_MOD_OVR);

mux2n  # (3)  mx5(R1, R10, m[5:3], r1_s);

and2$ ors2(isMEM1, B2[7], B2[6]);
and2$ ors1(isMEM2, B3[7], B3[6]);
mux2n #(1) mc12(isMEM, isMEM1, isMEM2, isDouble);
and3$ a4(d1_s, dest1_mux0[8], OP_MOD_OVR[0], isMEM);
and3$ a5(op1_s, op1_mux0[8], OP_MOD_OVR[0], isMEM);
and3$ a6(d2_s, dest2_mux0[8], OP_MOD_OVR[1], isMEM);
and3$ a7(op2_s, op2_mux0[8], OP_MOD_OVR[1], isMEM);

mux2n  # (13) mx6(dest1_mux, dest1_mux0, 13'h0002, d1_s);
mux2n  # (13) mx7(dest2_mux, dest2_mux0, 13'h0002, d2_s);
mux2n  # (13) mx8(op1_mux, op1_mux0, 13'h0002, op1_s); //{    6'd0,S3_MOD_OVR ,2'd0, 2'd0,opmodovr,1'b0}
mux2n  #(13) mx9(op2_mux, op2_mux0, 13'h0002, op2_s);
mux2n #(3) mx10(R2, R20, m[2:0], m1rw_s);
wire [2:0] s_out; 
 muxnm_tristate #(8,3) mxtr( {3'd7, 3'd6, 3'd5, 3'd4, 3'd0, 3'd3,3'd2, 3'd1},{2'b0, segSEL}, s_out );
and2$ a8(seg_sel, isMOD, isSEG); 
 mux2n #(3) mx11(S1, S10a, s_out, seg_sel);
 mux2$ mx69(op4_wb, op4_wb0, 1'b1, isREP);
 mux2n #(4) mx70(memSizeOVR, memSizeOVR0, {memSizeOVR0[3], memSizeOVR0[1], memSizeOVR0[2], memSizeOVR0[0]}, isSIZE);

nor2$ (dont_ow_r1 ,m[7], m[6]);
inv1$ (notm4, m[1]);
nand4$ (ignore, dont_ow_r1, m[2], m[0],notm4);
or2$ (S1ovr, M1_RW[1], M1_RW[0]);
equaln #(3) axp0(r2_act, 3'd4, R2_ovr0);
equaln #(3) axp1(r2_act, 3'd5, R2_ovr1);
or2$ axp22(S1ovr2, R2_ovr0, R2_ovr1 );
and4$ axp99999(R2_is_mod_ovr, S1ovr2,isMOD, S1ovr,ignore );

equaln #(3) axp2a(r3_act, 3'd4, R3_ovr0);
equaln #(3) axp3a(r3_act, 3'd5, R3_ovr1);
or2$ axp2(S1ovr_is_stack, R3_ovr0, R3_ovr1 );
and3$ axp2222(R3_is_mod_ovr, S1ovr_is_stack,isSIB ,S1ovr );

or2$ axp5(s1_ovr_stack, R3_is_mod_ovr, R2_is_mod_ovr);
mux2n #(3) leFix(S10a, S10, 3'd2, s1_ovr_stack );

endmodule