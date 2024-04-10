module ALU_t();
localparam CYCLE_TIME = 10;

wire[63:0] ALU_OUT;
wire [31:0] OP1_DEST;
wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out;

reg  [63:0] OP1;
reg  [63:0] OP2;
reg  [63:0] OP3;

reg  [31:0] OP1_ORIG;
reg  [4:0] aluk;
reg  [2:0] MUX_ADDER_IMM;
reg  MUX_AND_INT;
reg  MUX_SHF;
reg  CMPXCHNG_P_OP;
reg  zf, cf;

ALU_top a1(ALU_OUT,OP1_DEST, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, OP1, OP2, OP3, OP1_ORIG, aluk,MUX_ADDER_IMM,MUX_AND_INT, MUX_SHF, CMPXCHNG_P_OP, zf, cf);

initial begin
    OP1 = 0;
    OP2 = 0;
    OP3 = 0;
    OP1_ORIG = 0;
    aluk = 0;
    MUX_ADDER_IMM = 0;
    MUX_AND_INT = 0;
    MUX_SHF = 0;
    CMPXCHNG_P_OP = 0;
    zf = 0;
    cf = 0;
    
end

endmodule