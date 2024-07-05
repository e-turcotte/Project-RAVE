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
output [3:0] memSizeOVR,

input [229:0] toSplit
);
assign memSizeOVR=toSplit[3:0];
assign S3_MOD_OVR=toSplit[4:4];
assign OP_MOD_OVR=toSplit[6:5];
assign M2_RW=toSplit[8:7];
assign M1_RW=toSplit[10:9];
assign R1_MOD_OVR=toSplit[11:11];
assign op4_wb=toSplit[12:12];
assign op3_wb=toSplit[13:13];
assign op2_wb=toSplit[14:14];
assign op1_wb=toSplit[15:15];
assign dest4_mux=toSplit[28:16];
assign dest3_mux=toSplit[41:29];
assign dest2_mux=toSplit[54:42];
assign dest1_mux=toSplit[67:55];
assign op4_mux=toSplit[80:68];
assign op3_mux=toSplit[93:81];
assign op2_mux=toSplit[106:94];
assign op1_mux=toSplit[119:107];
assign S4=toSplit[122:120];
assign S3=toSplit[125:123];
assign S2=toSplit[128:126];
assign S1=toSplit[131:129];
assign R4=toSplit[134:132];
assign R3=toSplit[137:135];
assign R2=toSplit[140:138];
assign R1=toSplit[143:141];
assign size=toSplit[145:144];
assign immSize=toSplit[147:146];
assign isImm=toSplit[148:148];
assign isFP=toSplit[149:149];
assign isBR=toSplit[150:150];
assign swapEIP=toSplit[151:151];
assign conditionals=toSplit[153:152];
assign FMASK=toSplit[171:154];
assign P_OP=toSplit[208:172];
assign MUX_SHIFT=toSplit[209:209];
assign MUX_AND_INT=toSplit[210:210];
assign MUX_ADDER_IMM=toSplit[213:211];
assign aluk=toSplit[218:214];
assign OPCext=toSplit[226:219];
assign isDouble=toSplit[227:227];
assign modSWAP=toSplit[228:228];
assign isMOD=toSplit[229:229];
endmodule