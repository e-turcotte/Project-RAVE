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
assign isMOD=toSplit[0:0];
assign modSWAP=toSplit[1:1];
assign isDouble=toSplit[2:2];
assign OPCext=toSplit[10:3];
assign aluk=toSplit[15:11];
assign MUX_ADDER_IMM=toSplit[18:16];
assign MUX_AND_INT=toSplit[19:19];
assign MUX_SHIFT=toSplit[20:20];
assign P_OP=toSplit[57:21];
assign FMASK=toSplit[75:58];
assign conditionals=toSplit[77:76];
assign swapEIP=toSplit[78:78];
assign isBR=toSplit[79:79];
assign isFP=toSplit[80:80];
assign isImm=toSplit[81:81];
assign immSize=toSplit[83:82];
assign size=toSplit[85:84];
assign R1=toSplit[88:86];
assign R2=toSplit[91:89];
assign R3=toSplit[94:92];
assign R4=toSplit[97:95];
assign S1=toSplit[100:98];
assign S2=toSplit[103:101];
assign S3=toSplit[106:104];
assign S4=toSplit[109:107];
assign op1_mux=toSplit[122:110];
assign op2_mux=toSplit[135:123];
assign op3_mux=toSplit[148:136];
assign op4_mux=toSplit[161:149];
assign dest1_mux=toSplit[174:162];
assign dest2_mux=toSplit[187:175];
assign dest3_mux=toSplit[200:188];
assign dest4_mux=toSplit[213:201];
assign op1_wb=toSplit[214:214];
assign op2_wb=toSplit[215:215];
assign op3_wb=toSplit[216:216];
assign op4_wb=toSplit[217:217];
assign R1_MOD_OVR=toSplit[218:218];
assign M1_RW=toSplit[220:219];
assign M2_RW=toSplit[222:221];
assign OP_MOD_OVR=toSplit[224:223];
assign S3_MOD_OVR=toSplit[225:225];
assign memSizeOVR=toSplit[226:226];
endmodule