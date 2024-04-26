module cs_tb();
wire [0:0] isMOD0; wire [0:0] modSWAP0; wire [0:0] isDouble0; wire [7:0] OPCext0; wire [4:0] aluk0; wire [2:0] MUX_ADDER_IMM0; wire [0:0] MUX_AND_INT0; wire [0:0] MUX_SHIFT0; wire [36:0] P_OP0; wire [17:0] FMASK0; wire [1:0] conditionals0; wire [0:0] swapEIP0; wire [0:0] isBR0; wire [0:0] isFP0; wire [0:0] isImm0; wire [1:0] immSize0; wire [1:0] size0; wire [2:0] R10; wire [2:0] R20; wire [2:0] R30; wire [2:0] R40; wire [2:0] S10; wire [2:0] S20; wire [2:0] S30; wire [2:0] S40; wire [12:0] op1_mux0; wire [12:0] op2_mux0; wire [12:0] op3_mux0; wire [12:0] op4_mux0; wire [12:0] dest1_mux0; wire [12:0] dest2_mux0; wire [12:0] dest3_mux0; wire [12:0] dest4_mux0; wire [0:0] op1_wb0; wire [0:0] op2_wb0; wire [0:0] op3_wb0; wire [0:0] op4_wb0; wire [0:0] R1_MOD_OVR0; wire [1:0] M1_RW0; wire [1:0] M2_RW0; wire [1:0] OP_MOD_OVR0; wire [0:0] S3_MOD_OVR0; wire [0:0] memSizeOVR0; 
reg[7:0] B1, B2, B3, B4, B5, B6;
reg isREP, isSIZE, isSEG;
reg[3:0] prefSize;
reg[5:0] segSEL;
cs_top cst1(.isMOD(isMOD), .modSWAP(modSWAP), .isDouble(isDouble), .OPCext(OPCext), .aluk(aluk), .MUX_ADDER_IMM(MUX_ADDER_IMM), .MUX_AND_INT(MUX_AND_INT), .MUX_SHIFT(MUX_SHIFT), .P_OP(P_OP), .FMASK(FMASK), .conditionals(conditionals), .swapEIP(swapEIP), .isBR(isBR), .isFP(isFP), .isImm(isImm), .immSize(immSize), .size(size), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .S1(S1), .S2(S2), .S3(S3), .S4(S4), .op1_mux(op1_mux), .op2_mux(op2_mux), .op3_mux(op3_mux), .op4_mux(op4_mux), .dest1_mux(dest1_mux), .dest2_mux(dest2_mux), .dest3_mux(dest3_mux), .dest4_mux(dest4_mux), .op1_wb(op1_wb), .op2_wb(op2_wb), .op3_wb(op3_wb), .op4_wb(op4_wb), .R1_MOD_OVR(R1_MOD_OVR), .M1_RW(M1_RW), .M2_RW(M2_RW), .OP_MOD_OVR(OP_MOD_OVR), .S3_MOD_OVR(S3_MOD_OVR), .memSizeOVR(memSizeOVR),.B1(B1), .B2(B2), .B3(B3), .B4(B4), .B5(B5), .B6(B6), .isREP(isREP), .isSIZE(isSIZE), .isSEG(isSEG), .prefSize(prefSize), .segSEL(segSEL) );

initial begin
prefSize = 1;
isREP = 0;
isSIZE = 0;
isSEG = 0;
segSEL = 0;
B1= 8'h0f; B2 = 8'h63; B3 = 8'hF9;

end
endmodule