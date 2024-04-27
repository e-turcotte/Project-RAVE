module csAdapter(
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

input [226:0] toSplit
);
assign memSizeOVR=toSplit[0:0];
assign S3_MOD_OVR=toSplit[1:1];
assign OP_MOD_OVR=toSplit[3:2];
assign M2_RW=toSplit[5:4];
assign M1_RW=toSplit[7:6];
assign R1_MOD_OVR=toSplit[8:8];
assign op4_wb=toSplit[9:9];
assign op3_wb=toSplit[10:10];
assign op2_wb=toSplit[11:11];
assign op1_wb=toSplit[12:12];
assign dest4_mux=toSplit[25:13];
assign dest3_mux=toSplit[38:26];
assign dest2_mux=toSplit[51:39];
assign dest1_mux=toSplit[64:52];
assign op4_mux=toSplit[77:65];
assign op3_mux=toSplit[90:78];
assign op2_mux=toSplit[103:91];
assign op1_mux=toSplit[116:104];
assign S4=toSplit[119:117];
assign S3=toSplit[122:120];
assign S2=toSplit[125:123];
assign S1=toSplit[128:126];
assign R4=toSplit[131:129];
assign R3=toSplit[134:132];
assign R2=toSplit[137:135];
assign R1=toSplit[140:138];
assign size=toSplit[142:141];
assign immSize=toSplit[144:143];
assign isImm=toSplit[145:145];
assign isFP=toSplit[146:146];
assign isBR=toSplit[147:147];
assign swapEIP=toSplit[148:148];
assign conditionals=toSplit[150:149];
assign FMASK=toSplit[168:151];
assign P_OP=toSplit[205:169];
assign MUX_SHIFT=toSplit[206:206];
assign MUX_AND_INT=toSplit[207:207];
assign MUX_ADDER_IMM=toSplit[210:208];
assign aluk=toSplit[215:211];
assign OPCext=toSplit[223:216];
assign isDouble=toSplit[224:224];
assign modSWAP=toSplit[225:225];
assign isMOD=toSplit[226:226];
endmodule