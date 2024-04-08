module pencoder32_5(
    output [4:0] OUT,
    output valid,
    input [31:0] INP
);
 genvar i;

 wire [11:0] P1_OUT_R;
 wire [11:0] P1_OUT;
 wire [3:0] P1_VALID;
 wire [7:0] P1_RES_R;
 wire [7:0] P1_RES;
 assign P1_RES[7:4] = 4'h0;
 assign P1_RES_R = {4'h0, P1_VALID};
 wire[31:0] X;
  generate
    for(i = 0; i < 4; i=i+1) begin : pence
        reverseBits #(8) r(X[i*8+8:i*8], INP[i*8+7: i*8]); 
    end
endgenerate


 generate
    for(i = 0; i < 4; i=i+1) begin : penc
        pencoder8_3v$ p1(1'b0, X[i*8+7:i*8], P1_OUT_R[i*3+2:i*3],P1_VALID[i]); 
    end
endgenerate

inv_n #(12) n(P1_OUT, P1_OUT_R);

wire [159:0] values;
assign values = {5'b11111, 5'b11110, 5'b11101, 5'b11100, 5'b11011, 5'b11010, 5'b11001, 5'b11000,
                5'b10111, 5'b10110, 5'b10101, 5'b10100, 5'b10011, 5'b10010, 5'b10001, 5'b10000,
                5'b01111, 5'b01110, 5'b01101, 5'b01100, 5'b01011, 5'b01010, 5'b01001, 5'b01000,
                5'b00111, 5'b00110, 5'b00101, 5'b00100, 5'b00011, 5'b00010, 5'b00001, 5'b00000};


wire[19:0] muxOut;
generate
    for(i = 0; i < 4; i = i + 1) begin
        mux8_n #(32) m(muxOut[i*5+4:i*5], values[40*i +4:40*i], values[40*i+4+5:40*i+5], values[40*i+4+10:40*i+10], values[40*i+4+15:40*i+15], values[40*i+4+20:40*i+20], values[40*i+4+25:40*i+25], values[40*i+4+30:40*i+30], values[40*i+4+35:40*i+35], P1_OUT[3*i],P1_OUT[3*i+1], P1_OUT[3*i+2] );
    end
endgenerate

wire[2:0] penc_sel_n;
wire[1:0] penc_sel;

reverseBits #(4) rev1(P1_RES[3:0], P1_RES_R[3:0]);
pencoder8_3v$ p2(1'b0, P1_RES, penc_sel_n, valid);
inv_n #(2) inv2(penc_sel, penc_sel_n[1:0]);
mux4_n #(32) m4(OUT,muxOut[4:0], muxOut[9:5], muxOut[14:10], muxOut[19:15], penc_sel[0], penc_sel[1]);

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
module mux2n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B,
    input S0
);

genvar i;
generate
    for(i = 0; i < DATA_WIDTH/16; i=i+1) begin : nmux
        mux2_16$ m(OUT[16*i+15:16*i], A[16*i+15:16*i], B[16*i+15:16*i], S0);
    end
endgenerate

endmodule 



//////////////////////////////////////////////////////////////

module reverseBits #(parameter WIDTH = 32)(
    output [WIDTH-1:0] OUT,
    input [WIDTH-1:0] IN
);
    genvar i;
    generate
        for(i = 0; i < WIDTH; i = i + 1) begin : rev
            assign OUT[i] = IN[WIDTH-1- i];
        end
    endgenerate 
endmodule

module inv_n #(parameter WIDTH = 32)(
    output [WIDTH-1:0] OUT,
    input [WIDTH-1:0] IN
);
    genvar i;
    generate
        for(i = 0; i < WIDTH; i = i + 1) begin : inv
            inv1$ n(OUT[i],IN[i]);
        end
    endgenerate 
endmodule