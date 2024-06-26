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
reg  zf, cf, af;

ALU_top a1(ALU_OUT,OP1_DEST, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, OP1, OP2, OP3, OP1_ORIG, aluk,MUX_ADDER_IMM,MUX_AND_INT, MUX_SHF, CMPXCHNG_P_OP, zf, cf, af);
integer i;


initial begin
    af = 0;
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
    
    for(i = 0; i < 20; i = i + 1) begin 
        
        OP3 = 64'h0000_FFFF_FFFF_FFFF;
        OP1 = 64'h7313_8013_9F13_83F4;
        OP2 = 64'h4111_9011_0000_0185;
        #CYCLE_TIME
        aluk = aluk + 1;
    end
    
    
end

endmodule