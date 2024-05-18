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

module regn_with_set #(parameter WIDTH=16) (input [WIDTH-1:0] din,
                                   input ld, clr,
                                   input clk,
                                   output [WIDTH-1:0] dout);
    
    wire [WIDTH-1:0] datatold;
 
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reg_slices
            mux2$ g0(.outb(datatold[i]), .in0(dout[i]), .in1(din[i]), .s0(ld));
            dff$ g1(.clk(clk), .d(datatold[i]), .q(dout[i]), .qbar(), .r(1'b1), .s(clr));
        end
    endgenerate

endmodule

module regn_with_set_lsb #(parameter PARITY=0, WIDTH=16) (input [WIDTH-1:0] din,
                                   input ld, clr,
                                   input clk,
                                   output [WIDTH-1:0] dout);
    
    wire [WIDTH-1:0] datatold;
 
    genvar i;
    generate
        if(PARITY == 1) begin
            mux2$ g0wkdnfvkds(.outb(datatold[0]), .in0(dout[0]), .in1(din[0]), .s0(ld));
            dff$ gsdflnsdl1(.clk(clk), .d(datatold[0]), .q(dout[0]), .qbar(), .r(1'b1), .s(clr));
        end
        else begin
            mux2$ gsdmfnls0(.outb(datatold[0]), .in0(dout[0]), .in1(din[0]), .s0(ld));
            dff$ gsdfksj1(.clk(clk), .d(datatold[0]), .q(dout[0]), .qbar(), .r(clr), .s(1'b1));
        end
        for (i = 1; i < WIDTH; i = i + 1) begin : reg_slices
            mux2$ g0(.outb(datatold[i]), .in0(dout[i]), .in1(din[i]), .s0(ld));
            dff$ g1(.clk(clk), .d(datatold[i]), .q(dout[i]), .qbar(), .r(1'b1), .s(clr));
        end
    endgenerate

endmodule 

module ptr_regn #(parameter WIDTH=16) (input [WIDTH-1:0] din,
                                       input ld, clr,
                                       input clk,
                                       output [WIDTH-1:0] dout);
    
    wire [WIDTH-1:0] datatold;
 
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reg_slices
            wire clear, set;

            if (i > 0) begin
                assign clear = clr;
                assign set = 1'b1;
            end else begin
                assign clear = 1'b1;
                assign set = clr;
            end
            
            mux2$ g0(.outb(datatold[i]), .in0(dout[i]), .in1(din[i]), .s0(ld));
            dff$ g1(.clk(clk), .d(datatold[i]), .q(dout[i]), .qbar(), .r(clear), .s(set));
        end
    endgenerate

endmodule
