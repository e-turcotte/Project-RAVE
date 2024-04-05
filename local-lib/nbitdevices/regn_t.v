module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k, l;

    reg [NUM_TESTS-1:0] in;
    reg clr;
    wire [NUM_TESTS-1:0] out [0:NUM_TESTS-1];
    reg clk;

    genvar j;
    generate
        for(j = 0; j < NUM_TESTS; j = j + 1) begin : reg_instances
            reg_tester #(.WIDTH(j+1)) t0(.in(in[j:0]), .clk(clk), .clr(clr), .out(out[j][j:0]));
        end
    endgenerate

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        in = 2;
        clr = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        for (k = 0; k < 2**(NUM_TESTS+1); k = k + 1) begin
            #CYCLE_TIME;
            in <= in + 1;
        end
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule

module reg_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in,
                                        input clk, clr,
                                        output [WIDTH-1:0] out);

    wire ld_sig;
    wire [63:0] refout;

    inv1$ g0(.out(ld_sig), .in(in[0]));

    regn #(.WIDTH(WIDTH)) m0(.din(in), .ld(ld_sig), .clr(clr), .clk(clk), .dout(out));
    reg64e$ t0(.CLK(clk), .Din({{64-WIDTH{1'b0}},in}), .Q(refout), .QBAR(), .CLR(clr), .PRE(1'b1), .en(ld_sig));

    always @(posedge clk) begin
        if (out != refout) begin
            $display("TEST FAILED REG(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, refout); 
        end
    end

endmodule
