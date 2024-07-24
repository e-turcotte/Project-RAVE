module cs_top(
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
output cs_hit_out,

input[7:0] B1, B2, B3, B4, B5, B6,
 input isREP, isSIZE, isSEG,
 input[3:0] prefSize, 
 input[5:0] segSEL,
 input isSIB );

wire [229:0] w0; wire [229:0] w1; wire [229:0] w2; wire [229:0] w3; wire [229:0] w4; wire [229:0] w5; wire [229:0] w6; wire [229:0] w7; wire [229:0] w8; wire [229:0] w9; wire [229:0] w10; wire [229:0] w11; wire [229:0] w12; wire [229:0] w13; wire [229:0] w14; wire [229:0] w15; wire [229:0] w16; wire [229:0] w17; wire [229:0] w18; wire [229:0] w19; wire [229:0] w20; wire [229:0] w21; wire [229:0] w22; wire [229:0] w23; wire [229:0] w24; wire [229:0] w25; wire [229:0] w26; wire [229:0] w27; wire [229:0] w28; wire [229:0] w29; wire [229:0] w30; wire [229:0] w31; wire [229:0] w32; wire [229:0] w33; wire [229:0] w34; wire [229:0] w35; wire [229:0] w36; wire [229:0] w37; wire [229:0] w38; wire [229:0] w39; wire [229:0] w40; wire [229:0] w41; wire [229:0] w42; wire [229:0] w43; wire [229:0] w44; wire [229:0] w45; wire [229:0] w46; wire [229:0] w47; wire [229:0] w48; wire [229:0] w49; wire [229:0] w50; wire [229:0] w51; wire [229:0] w52; wire [229:0] w53; wire [229:0] w54; wire [229:0] w55; wire [229:0] w56; wire [229:0] w57; wire [229:0] w58; wire [229:0] w59; wire [229:0] w60; wire [229:0] w61; wire [229:0] w62; wire [229:0] w63; wire [229:0] w64; wire [229:0] w65; wire [229:0] w66; wire [229:0] w67; wire [229:0] w68; wire [229:0] w69; wire [229:0] w70; wire [229:0] w71; wire [229:0] w72; wire [229:0] w73; wire [229:0] w74; wire [229:0] w75; wire [229:0] w76; wire [229:0] w77; wire [229:0] w78; wire [229:0] w79; wire [229:0] w80; wire [229:0] w81; wire [229:0] w82; wire [229:0] w83; wire [229:0] w84; wire [229:0] w85; wire [229:0] w86; wire [229:0] w87; wire [229:0] w88; wire [229:0] w89; wire [229:0] w90; wire [229:0] w91; wire [229:0] w92; wire [229:0] w93; wire [229:0] w94; wire [229:0] w95; wire [229:0] w96; wire [229:0] w97; wire [229:0] w98; wire [229:0] w99; wire [229:0] w100; wire [229:0] w101; wire [229:0] w102; wire [229:0] w103; wire [229:0] w104; wire [229:0] w105; wire [229:0] w106; wire [229:0] w107; wire [229:0] w108; wire [229:0] w109; wire [229:0] w110; wire [229:0] w111; wire [229:0] w112; wire [229:0] w113; wire [229:0] w114; wire [229:0] w115; wire [229:0] w116; wire [229:0] w117; wire [229:0] w118; wire [229:0] w119; wire [229:0] w120; wire [229:0] w121; wire [229:0] w122; wire [229:0] w123; wire [229:0] w124; wire [229:0] w125; wire [229:0] w126; wire [229:0] w127; wire [229:0] w128; wire [229:0] w129; wire [229:0] w130; wire [229:0] w131; wire [229:0] w132; wire [229:0] w133; wire [229:0] w134; wire [229:0] w135; wire [229:0] w136; wire [229:0] w137; wire [229:0] w138; wire [229:0] w139; 
cs_data cs1(.w0(w0), .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27), .w28(w28), .w29(w29), .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37), .w38(w38), .w39(w39), .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47), .w48(w48), .w49(w49), .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57), .w58(w58), .w59(w59), .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67), .w68(w68), .w69(w69), .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77), .w78(w78), .w79(w79), .w80(w80), .w81(w81), .w82(w82), .w83(w83), .w84(w84), .w85(w85), .w86(w86), .w87(w87), .w88(w88), .w89(w89), .w90(w90), .w91(w91), .w92(w92), .w93(w93), .w94(w94), .w95(w95), .w96(w96), .w97(w97), .w98(w98), .w99(w99), .w100(w100), .w101(w101), .w102(w102), .w103(w103), .w104(w104), .w105(w105), .w106(w106), .w107(w107), .w108(w108), .w109(w109), .w110(w110), .w111(w111), .w112(w112), .w113(w113), .w114(w114), .w115(w115), .w116(w116), .w117(w117), .w118(w118), .w119(w119), .w120(w120), .w121(w121), .w122(w122), .w123(w123), .w124(w124), .w125(w125), .w126(w126), .w127(w127), .w128(w128), .w129(w129), .w130(w130), .w131(w131), .w132(w132), .w133(w133), .w134(w134), .w135(w135), .w136(w136), .w137(w137), .w138(w138), .w139(w139) );
wire[229:0] chosen, chosen1, chosen2, chosen3, chosen4;
 wire[23:0] chosen5;

wire cs_hit3, cs_hit2, cs_hit1, cs_hit0;

cs_select css1(.w0(w0), .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27), .w28(w28), .w29(w29), .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37), .w38(w38), .w39(w39), .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47), .w48(w48), .w49(w49), .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57), .w58(w58), .w59(w59), .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67), .w68(w68), .w69(w69), .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77), .w78(w78), .w79(w79), .w80(w80), .w81(w81), .w82(w82), .w83(w83), .w84(w84), .w85(w85), .w86(w86), .w87(w87), .w88(w88), .w89(w89), .w90(w90), .w91(w91), .w92(w92), .w93(w93), .w94(w94), .w95(w95), .w96(w96), .w97(w97), .w98(w98), .w99(w99), .w100(w100), .w101(w101), .w102(w102), .w103(w103), .w104(w104), .w105(w105), .w106(w106), .w107(w107), .w108(w108), .w109(w109), .w110(w110), .w111(w111), .w112(w112), .w113(w113), .w114(w114), .w115(w115), .w116(w116), .w117(w117), .w118(w118), .w119(w119), .w120(w120), .w121(w121), .w122(w122), .w123(w123), .w124(w124), .w125(w125), .w126(w126), .w127(w127), .w128(w128), .w129(w129), .w130(w130), .w131(w131), .w132(w132), .w133(w133), .w134(w134), .w135(w135), .w136(w136), .w137(w137), .w138(w138), .w139(w139), .chosen(chosen1), .cs_hit(cs_hit0), .B1(B1), .B2(B2), .B3(B3));
cs_select css2(.w0(w0), .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27), .w28(w28), .w29(w29), .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37), .w38(w38), .w39(w39), .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47), .w48(w48), .w49(w49), .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57), .w58(w58), .w59(w59), .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67), .w68(w68), .w69(w69), .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77), .w78(w78), .w79(w79), .w80(w80), .w81(w81), .w82(w82), .w83(w83), .w84(w84), .w85(w85), .w86(w86), .w87(w87), .w88(w88), .w89(w89), .w90(w90), .w91(w91), .w92(w92), .w93(w93), .w94(w94), .w95(w95), .w96(w96), .w97(w97), .w98(w98), .w99(w99), .w100(w100), .w101(w101), .w102(w102), .w103(w103), .w104(w104), .w105(w105), .w106(w106), .w107(w107), .w108(w108), .w109(w109), .w110(w110), .w111(w111), .w112(w112), .w113(w113), .w114(w114), .w115(w115), .w116(w116), .w117(w117), .w118(w118), .w119(w119), .w120(w120), .w121(w121), .w122(w122), .w123(w123), .w124(w124), .w125(w125), .w126(w126), .w127(w127), .w128(w128), .w129(w129), .w130(w130), .w131(w131), .w132(w132), .w133(w133), .w134(w134), .w135(w135), .w136(w136), .w137(w137), .w138(w138), .w139(w139), .chosen(chosen2), .cs_hit(cs_hit1), .B1(B2), .B2(B3), .B3(B4));
cs_select css3(.w0(w0), .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27), .w28(w28), .w29(w29), .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37), .w38(w38), .w39(w39), .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47), .w48(w48), .w49(w49), .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57), .w58(w58), .w59(w59), .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67), .w68(w68), .w69(w69), .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77), .w78(w78), .w79(w79), .w80(w80), .w81(w81), .w82(w82), .w83(w83), .w84(w84), .w85(w85), .w86(w86), .w87(w87), .w88(w88), .w89(w89), .w90(w90), .w91(w91), .w92(w92), .w93(w93), .w94(w94), .w95(w95), .w96(w96), .w97(w97), .w98(w98), .w99(w99), .w100(w100), .w101(w101), .w102(w102), .w103(w103), .w104(w104), .w105(w105), .w106(w106), .w107(w107), .w108(w108), .w109(w109), .w110(w110), .w111(w111), .w112(w112), .w113(w113), .w114(w114), .w115(w115), .w116(w116), .w117(w117), .w118(w118), .w119(w119), .w120(w120), .w121(w121), .w122(w122), .w123(w123), .w124(w124), .w125(w125), .w126(w126), .w127(w127), .w128(w128), .w129(w129), .w130(w130), .w131(w131), .w132(w132), .w133(w133), .w134(w134), .w135(w135), .w136(w136), .w137(w137), .w138(w138), .w139(w139), .chosen(chosen3), .cs_hit(cs_hit2), .B1(B3), .B2(B4), .B3(B5));
cs_select css4(.w0(w0), .w1(w1), .w2(w2), .w3(w3), .w4(w4), .w5(w5), .w6(w6), .w7(w7), .w8(w8), .w9(w9), .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27), .w28(w28), .w29(w29), .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37), .w38(w38), .w39(w39), .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47), .w48(w48), .w49(w49), .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57), .w58(w58), .w59(w59), .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67), .w68(w68), .w69(w69), .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77), .w78(w78), .w79(w79), .w80(w80), .w81(w81), .w82(w82), .w83(w83), .w84(w84), .w85(w85), .w86(w86), .w87(w87), .w88(w88), .w89(w89), .w90(w90), .w91(w91), .w92(w92), .w93(w93), .w94(w94), .w95(w95), .w96(w96), .w97(w97), .w98(w98), .w99(w99), .w100(w100), .w101(w101), .w102(w102), .w103(w103), .w104(w104), .w105(w105), .w106(w106), .w107(w107), .w108(w108), .w109(w109), .w110(w110), .w111(w111), .w112(w112), .w113(w113), .w114(w114), .w115(w115), .w116(w116), .w117(w117), .w118(w118), .w119(w119), .w120(w120), .w121(w121), .w122(w122), .w123(w123), .w124(w124), .w125(w125), .w126(w126), .w127(w127), .w128(w128), .w129(w129), .w130(w130), .w131(w131), .w132(w132), .w133(w133), .w134(w134), .w135(w135), .w136(w136), .w137(w137), .w138(w138), .w139(w139), .chosen(chosen4), .cs_hit(cs_hit3), .B1(B4), .B2(B5), .B3(B6));
muxnm_tristate #(4, 24) mxt420({{B6,B5,B4}, {B5, B4, B3}, {B4,B3,B2}, {B3,B2,B1}}, prefSize,chosen5);
muxnm_tristate #(4,230) mxt69({chosen4, chosen3, chosen2,chosen1}, prefSize,chosen);
cs_overwrite cso1(.isSIB(isSIB), .memSizeOVR(memSizeOVR), .S3_MOD_OVR(S3_MOD_OVR), .OP_MOD_OVR(OP_MOD_OVR), .M2_RW(M2_RW), .M1_RW(M1_RW), .R1_MOD_OVR(R1_MOD_OVR), .op4_wb(op4_wb), .op3_wb(op3_wb), .op2_wb(op2_wb), .op1_wb(op1_wb), .dest4_mux(dest4_mux), .dest3_mux(dest3_mux), .dest2_mux(dest2_mux), .dest1_mux(dest1_mux), .op4_mux(op4_mux), .op3_mux(op3_mux), .op2_mux(op2_mux), .op1_mux(op1_mux), .S4(S4), .S3(S3), .S2(S2), .S1(S1), .R4(R4), .R3(R3), .R2(R2), .R1(R1), .size(size), .immSize(immSize), .isImm(isImm), .isFP(isFP), .isBR(isBR), .swapEIP(swapEIP), .conditionals(conditionals), .FMASK(FMASK), .P_OP(P_OP), .MUX_SHIFT(MUX_SHIFT), .MUX_AND_INT(MUX_AND_INT), .MUX_ADDER_IMM(MUX_ADDER_IMM), .aluk(aluk), .OPCext(OPCext), .isDouble(isDouble), .modSWAP(modSWAP), .isMOD(isMOD),  .chosen(chosen), .B1(chosen5[7:0]), .B2(chosen5[15:8]), .B3(chosen5[23:16]), .isREP(isREP), .isSIZE(isSIZE), .isSEG(isSEG), .prefSize(prefSize), .segSEL(segSEL));

//cs_top cst1(.memSizeOVR(memSizeOVR), .S3_MOD_OVR(S3_MOD_OVR), .OP_MOD_OVR(OP_MOD_OVR), .M2_RW(M2_RW), .M1_RW(M1_RW), .R1_MOD_OVR(R1_MOD_OVR), .op4_wb(op4_wb), .op3_wb(op3_wb), .op2_wb(op2_wb), .op1_wb(op1_wb), .dest4_mux(dest4_mux), .dest3_mux(dest3_mux), .dest2_mux(dest2_mux), .dest1_mux(dest1_mux), .op4_mux(op4_mux), .op3_mux(op3_mux), .op2_mux(op2_mux), .op1_mux(op1_mux), .S4(S4), .S3(S3), .S2(S2), .S1(S1), .R4(R4), .R3(R3), .R2(R2), .R1(R1), .size(size), .immSize(immSize), .isImm(isImm), .isFP(isFP), .isBR(isBR), .swapEIP(swapEIP), .conditionals(conditionals), .FMASK(FMASK), .P_OP(P_OP), .MUX_SHIFT(MUX_SHIFT), .MUX_AND_INT(MUX_AND_INT), .MUX_ADDER_IMM(MUX_ADDER_IMM), .aluk(aluk), .OPCext(OPCext), .isDouble(isDouble), .modSWAP(modSWAP), .isMOD(isMOD), );

muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(1)) mext123 (.in( { cs_hit3, cs_hit2, cs_hit1, cs_hit0} ), .sel(prefSize), .out(cs_hit_out));

endmodule