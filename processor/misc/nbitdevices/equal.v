module equaln #(parameter WIDTH=2) (input [WIDTH-1:0] a, b,
                                    output eq);

    wire [WIDTH-1:0] equal_vector;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : equal_slices
            xnor2$ g0(.out(equal_vector[i]), .in0(a[i]), .in1(b[i]));
        end
    endgenerate

    andn #(.NUM_INPUTS(WIDTH)) m0(.in(equal_vector), .out(eq));

endmodule