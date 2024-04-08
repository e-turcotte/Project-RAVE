module ALU_top(
    output[63:0] ALU_OUT,
    output [31:0] destReg_out,
    output cf_out,
    input [63:0] OP1,
    input [63:0] OP2,
    input [63:0] OP3,

    input [4:0] aluk,
    input [2:0] MUX_ADDER_IMM,
    input MUX_AND_INT,
    input [2:0] MUX_SHF
    input []
);
wire[63:0] and_out;
AND_alu a1(and_out,OP1,OP2,MUX_AND_INT);

wire[63:0] add_out;
wire add_cout;
ADD_alu a2(add_out, add_cout, OP1, OP2, MUX_ADDER_IMM);

// priorityEncoder

// PASSB

// PASSA

// PASS0

// PASS1

// DestReg1OverRide

// DAA_alu

// NOTA_alu

// PADDW_alu

// PADDD_alu

// PACKSSWB_alu

// PACKSSDW_alu

// PUNPCKHBW_alu

// PUNPCKHW_alu

// SAR_alu

// SAL_alu

endmodule

/////////////////////////////////////////////

module AND_alu(
    output[63:0] AND_ALU_OUT,
    input [63:0] OP1, OP2,
    input MUX_ADDER_INT
);
    wire[63:0] clear_high;
    assign clear_high = 64'h0000_0000_0000_FFFF;
    wire[63:0] mux_out;
    mux2n #(64) m1(mux_out,OP2, clear_high, MUX_ADDER_INT);
    and2n #(64) a1(AND_ALU_OUT, OP1, mux_out);
endmodule

////////////////////////////////////////////////

module ADD_alu(
    output[63:0] ADD_ALU_OUT,
    output COUT,
    input[63:0] OP1, OP2,
    input[2:0] MUX_ADDER_IMM
);
    wire [31:0] mux_res;
    wire[31:0] adderResult;
    mux8_n #(32) m1(mux_res, OP2[31:0], 32'd2, 32'd4, 0, 32'd6, 32'hFFFF_FFFE, 32'hFFFF_FFFC, 0, MUX_ADDER_IMM[0],MUX_ADDER_IMM[1], MUX_ADDER_IMM[2]);
    kogeAdder #(32) a1(adderResult, COUT, OP1[31:0], mux_res, 1'b0);
    
    wire[63:0] ext1;
    wire[63:0] ext0;
    assign ext0 = {32'h0000_0000, adderResult};
    assign ext1 = {32'hFFFF_FFFF, adderResult};

    mux2n #(64) m2(ADD_ALU_OUT, ext0, ext1, adderResult[31]);

endmodule

/////////////////////////////////////////////////////////////////////////////

module bsf(

)

endmodule













/////////////////////////////////////////////
//Buffer???
module mux2n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B,
    input S0_in
);
bufferH64$ b1(S0, S0_in);
genvar i;
generate
    for(i = 0; i < DATA_WIDTH/16; i=i+1) begin : nmux
        mux2_16$ m(OUT[16*i+15:16*i], A[16*i+15:16*i], B[16*i+15:16*i], S0);
    end
endgenerate

endmodule 

/////////////////////////////////////////
module and2n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B
    
);

genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i=i+1) begin : nmux
        and2$ m(OUT[i], A[i], B[i]);
    end
endgenerate

endmodule 