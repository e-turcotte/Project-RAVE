module ALU_t();


wire[63:0] ALU_OUT;
wire [31:0] OP1_DEST;
wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out;

reg clk;

reg  [63:0] OP1;
reg  [63:0] OP2;
reg  [63:0] OP3;

reg  [31:0] OP1_ORIG;
reg  [4:0] aluk;
reg  [2:0] MUX_ADDER_IMM;
reg  MUX_AND_INT;
reg  MUX_SHF;
reg  [1:0] shift;
reg  CMPXCHNG_P_OP;
reg  zf, cf;

ALU_top(ALU_OUT,OP1_DEST, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, OP1, OP2, OP3, OP1_ORIG, aluk,MUX_ADDER_IMM,MUX_AND_INT, MUX_SHF, CMPXCHNG_P_OP, zf, cf);


endmodule