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
output [0:0] memSizeOVR,

input [227:0] chosen,
 input isREP, isSIZE, isSEG,
 input[3:0] prefSize, 
 input[5:0] segSEL,
input [7:0] B1, B2, B3);

inv1$ inv1(size_n, isSIZE);
inv1$ inv2(size1_n, size0[1]);
nand3$ n1(size_s, size_n, size1_n, size[0]);
mux2n mx12(size, size, 2'b01, size_s);
wire [0:0] isMOD0; wire [0:0] modSWAP0; wire [0:0] isDouble0; wire [7:0] OPCext0; wire [4:0] aluk0; wire [2:0] MUX_ADDER_IMM0; wire [0:0] MUX_AND_INT0; wire [0:0] MUX_SHIFT0; wire [36:0] P_OP0; wire [17:0] FMASK0; wire [1:0] conditionals0; wire [0:0] swapEIP0; wire [0:0] isBR0; wire [0:0] isFP0; wire [0:0] isImm0; wire [1:0] immSize0; wire [1:0] size0; wire [2:0] R10; wire [2:0] R20; wire [2:0] R30; wire [2:0] R40; wire [2:0] S10; wire [2:0] S20; wire [2:0] S30; wire [2:0] S40; wire [12:0] op1_mux0; wire [12:0] op2_mux0; wire [12:0] op3_mux0; wire [12:0] op4_mux0; wire [12:0] dest1_mux0; wire [12:0] dest2_mux0; wire [12:0] dest3_mux0; wire [12:0] dest4_mux0; wire [0:0] op1_wb0; wire [0:0] op2_wb0; wire [0:0] op3_wb0; wire [0:0] op4_wb0; wire [0:0] R1_MOD_OVR0; wire [1:0] M1_RW0; wire [1:0] M2_RW0; wire [1:0] OP_MOD_OVR0; wire [0:0] S3_MOD_OVR0; wire [0:0] memSizeOVR0; 
csAdapter csa0(.isMOD(isMOD0), .modSWAP(modSWAP), .isDouble(isDouble), .OPCext(OPCext), .aluk(aluk), .MUX_ADDER_IMM(MUX_ADDER_IMM), .MUX_AND_INT(MUX_AND_INT), .MUX_SHIFT(MUX_SHIFT), .P_OP(P_OP), .FMASK(FMASK), .conditionals(conditionals), .swapEIP(swapEIP), .isBR(isBR), .isFP(isFP), .isImm(isImm), .immSize(immSize), .size(size0), .R1(R10), .R2(R2), .R3(R3), .R4(R4), .S1(S10), .S2(S2), .S3(S3), .S4(S4), .op1_mux(op1_mux0), .op2_mux(op2_mux0), .op3_mux(op3_mux), .op4_mux(op4_mux), .dest1_mux(dest1_mux0), .dest2_mux(dest2_mux0), .dest3_mux(dest3_mux), .dest4_mux(dest4_mux), .op1_wb(op1_wb), .op2_wb(op2_wb), .op3_wb(op3_wb), .op4_wb(op4_wb), .R1_MOD_OVR(R1_MOD_OVR), .M1_RW(M1_RW0), .M2_RW(M2_RW), .OP_MOD_OVR(OP_MOD_OVR), .S3_MOD_OVR(S3_MOD_OVR), .memSizeOVR(memSizeOVR), .isMOD(isMOD), .modSWAP(modSWAP), .isDouble(isDouble), .OPCext(OPCext), .aluk(aluk), .MUX_ADDER_IMM(MUX_ADDER_IMM), .MUX_AND_INT(MUX_AND_INT), .MUX_SHIFT(MUX_SHIFT), .P_OP(P_OP), .FMASK(FMASK), .conditionals(conditionals), .swapEIP(swapEIP), .isBR(isBR), .isFP(isFP), .isImm(isImm), .immSize(immSize), .size(size0), .R1(R10), .R2(R2), .R3(R3), .R4(R4), .S1(S10), .S2(S2), .S3(S3), .S4(S4), .op1_mux(op1_mux0), .op2_mux(op2_mux0), .op3_mux(op3_mux), .op4_mux(op4_mux), .dest1_mux(dest1_mux0), .dest2_mux(dest2_mux0), .dest3_mux(dest3_mux), .dest4_mux(dest4_mux), .op1_wb(op1_wb), .op2_wb(op2_wb), .op3_wb(op3_wb), .op4_wb(op4_wb), .R1_MOD_OVR(R1_MOD_OVR), .M1_RW(M1_RW0), .M2_RW(M2_RW), .OP_MOD_OVR(OP_MOD_OVR), .S3_MOD_OVR(S3_MOD_OVR), .memSizeOVR(memSizeOVR), .chosen(chosen));mux2n  # (8) m1x(m, B2, B3, isDouble);
mux2$ mx1(m1, B2[6], B3[6], isDouble);
mux2$ mx2(m2, B2[7], B3[7], isDouble);
and3$ a1(m1rw_s, isMOD, m1, m2);
mux2n  # (2) mx3(M1_RW, M1_RW0, 2'b00, m1rw_s);
and4$ a2(s3_s, isMOD, m1, m2, S3_MOD_OVR);
mux2n  # (3)  mx4(S3, S30, m[5:3], s3_s);
and4$ a3(r1_s, isMOD, m1, m2, R1_MOD_OVR);
mux2n  # (3)  mx5(R1, R10, m[5:3], r1_s);
and2$ a4(d1_s, dest1_mux0[8], OP_MOD_OVR[0]);
and2$ a5(op1_s, dest1_mux0[8], OP_MOD_OVR[0]);
and2$ a6(d2_s, dest2_mux0[8], OP_MOD_OVR[1]);
and2$ a7(op2_s, dest2_mux0[8], OP_MOD_OVR[1]);
mux2n  # (3) mx6(dest1_mux, dest1_mux0, 13'h0002, d1_s);
mux2n  # (3) mx7(dest2_mux, dest2_mux0, 13'h0002, d2_s);
mux2n  # (3) mx8(op1_mux, op1_mux0, 13'h0002, op1_s);
mux2n  # (3) mx9(op2_mux, op2_mux0, 13'h0002, op2_s);
mux2n #(3) mx10(R2, R20, m[2:0], m1rw_s);
wire [2:0] s_out; 
 muxmn_tristate #(8,3) mxtr( {3'd7, 3'd6, 3'd5, 3'd4, 3'd3, 3'd2,3'd1, 3'd0},{2'b00, segSEL}, s_out );
and2$(seg_sel, isMOD0, isSEG); 
 mux2n #(3) mx11(S1, S10, s_out, seg_sel);
endmodule