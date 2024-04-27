module encoder4_2(
    input [3:0] in,
    output [1:0] out
);

    or2$ g0(.out(out[1]), .in0(in[2]), .in1(in[3]));
    or2$ g1(.out(out[0]), .in0(in[1]), .in1(in[3]));

endmodule