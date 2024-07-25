//ONLY VALID FOR WIDTH >= 4
module satAdder #(parameter WIDTH = 32)(
    output [WIDTH-1:0] SUM, 
    output COUT,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input CIN
);
 localparam min4 = WIDTH-4;
wire[WIDTH-1:0] adder_out;
wire OF, UF;
wire[WIDTH-1:0] OF_V;
assign OF_V = {4'h7, {min4{1'b1}}};
wire[WIDTH-1:0] UF_V;
assign UF_V = {4'h8, {min4{1'b0}}};


kogeAdder #(WIDTH) k1(adder_out, COUT, A, B, CIN);

calcSat c1(OF, UF, A[WIDTH-1], B[WIDTH - 1] , adder_out[WIDTH - 1]);
mux4n #(WIDTH) m1(SUM, adder_out, OF_V, {WIDTH{1'b0}}, UF_V, OF, UF);
//muxnm_tree #(2, WIDTH)()

endmodule

module calcSat (
output wire OF,
output wire UF,
input wire A,
input wire B,
input wire C
);

inv1$ n0(notA, A);
inv1$ n1(notB, B);
inv1$ n2(notC, C);

and3$ f1(UF, notC, A, B);

and3$ f2(OF, notB, notA, C);

endmodule

module mux4n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B,C,D,
    input S0, S1
);

genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i=i+1) begin : nmux
        mux4$ m(OUT[i], A[i], B[i], C[i], D[i], S0, S1);
    end
endgenerate

endmodule 
