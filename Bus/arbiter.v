module arbiter(input [3:0] in,
               output [3:0] out);

    wire invi3, invi2, invi1;

    inv1$ g0(.out(invi3), .in(in[3]));
    inv1$ g1(.out(invi2), .in(in[2]));
    inv1$ g2(.out(invi1), .in(in[1]));

    assign out[3] = in[3];
    and2$ g3(.out(out[2]), .in0(in[2]), .in1(invi3));
    and3$ g4(.out(out[1]), .in0(in[1]), .in1(invi2), .in2(invi3));
    and4$ g5(.out(out[0]), .in0(in[0]), .in1(invi1), .in2(invi2), .in3(invi3));

endmodule