module encoder4_2(
    input [3:0] in,
    output [1:0] out
);

    or2$ g0(.out(out[1]), .in0(in[2]), .in1(in[3]));
    or2$ g1(.out(out[0]), .in0(in[1]), .in1(in[3]));

endmodule



module pencoder4_2(input [3:0] in,
                   output [1:0] out,
                   output valid);

    wire invi2, invi2andi1;

    inv1$ g0(.out(invi2), .in(in[2]));
    and2$ g1(.out(invi2andi1), .in0(i[1]), .in1(invi2));
    or2$ g2(.out(out[0]), .in0(i[3]), .in1(invi2andi1));

    or2$ g3(.out(out[1]), .in0(in[3]) ,.in1(in[2]));

    or4$ g4(.out(valid), .in0(in[3]), .in1(in[2]), .in2(in[1]), .in3(in[0]));

endmodule