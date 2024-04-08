module pencoder32_5(
    output [4:0] Y,
    output valid,
    input [31:0] X
);

 wire [11:0] P1_OUT;
 wire [3:0] P1_VALID;
 wire [7:0] P1_RES;
 assign P1_RES = {4'h0, P1_VALID};
 genvar i;
 generate
    for(i = 0; i < 4; i=i+1) begin : penc
        pencoder8_3v$ p1(1'b0, X[i*8+7:i*8], P1_OUT[i*3+2:i*3],P1_VALID[i]); 
    end
endgenerate


wire [31:0][4:0] values;
generate
    for (i = 0; i < 32; i = i + 1) begin : assign_loop
        assign values[i] = i;
    end 
endgenerate

wire[19:0] muxOut;
generate
    for(i = 0; i < 4; i = i + 1) begin
        mux8_n #(32) m(muxOut[i*5+4:i*5], values[8*i], values[8*i+1], values[8*i+2], values[8*i+3], values[8*i+4], values[8*i+5], values[8*i+6], values[8*i+7], P1_OUT[3*i+2:i*3]);
    end
endgenerate

wire[2:0] penc_sel;
pencoder8_3v$ p2(1'b0, P1_RES, penc_sel, valid);

mux4_n #(32) m4(Y,muxOut[4:0], muxOut[9:5], muxOut[14:10], muxOut[19:15], penc_sel[0], penc_sel[1]);

endmodule

///////////////////////////////////////

module mux4_n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B,C, D,
    input S0, S1
);

genvar i;
generate
    for(i = 0; i < DATA_WIDTH/16; i=i+1) begin : nmux
        mux4_16$ m(OUT[16*i+15:16*i], A[16*i+15:16*i], B[16*i+15:16*i], C[16*i+15:16*i], D[16*i+15:16*i], S0, S1);
    end
endgenerate

endmodule 

/////////////////////////////////////////////
//Buffer???
module mux8_n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B, C, D, E, F,G, H,
    input S0, S1, S2
);

wire [DATA_WIDTH-1:0] mux1_out, mux2_out;
genvar i;
generate
    for(i = 0; i < DATA_WIDTH/16; i=i+1) begin : nmux
        mux4_16$ m(mux1_out[16*i+15:16*i], A[16*i+15:16*i], B[16*i+15:16*i], C[16*i+15:16*i],D[16*i+15:16*i], S0, S1);
        mux4_16$ mn(mux2_out[16*i+15:16*i], E[16*i+15:16*i], F[16*i+15:16*i], G[16*i+15:16*i], H[16*i+15:16*i], S0, S1);
    end
endgenerate

mux2n #(32) mx2(OUT,mux1_out, mux2_out, S2);

endmodule 
