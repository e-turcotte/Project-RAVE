module regn #(parameter WIDTH=16) (input [WIDTH-1:0] din,
                                   input ld, clr,
                                   input clk,
                                   output [WIDTH-1:0] dout);
    
    wire we;

    and2$ g0(.out(we), .in0(clk), .in1(ld));

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reg_slices
            dff$ g1(.clk(we), .d(din[i]), .q(dout[i]), .qbar(), .r(clr), .s(1'b1));
        end
    endgenerate

endmodule