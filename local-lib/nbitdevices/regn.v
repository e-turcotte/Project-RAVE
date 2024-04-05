module regn #(parameter WIDTH=16) (input [WIDTH-1:0] din,
                                   input ld, clr,
                                   input clk,
                                   output [WIDTH-1:0] dout);
    
    wire [WIDTH-1:0] datatold;
 
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reg_slices
            mux2$ g0(.outb(datatold[i]), .in0(dout[i]), .in1(din[i]), .s0(ld));
            dff$ g1(.clk(clk), .d(datatold[i]), .q(dout[i]), .qbar(), .r(clr), .s(1'b1));
        end
    endgenerate

endmodule
