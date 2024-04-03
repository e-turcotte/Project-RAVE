module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 6;
    integer k;

    reg [NUM_TESTS-1:0] in;
    wire [(2**NUM_TESTS)-1:0] out [0:NUM_TESTS-1];
    reg clk;

    genvar j;
    generate
        for(j = 0; j < NUM_TESTS; j = j + 1) begin : dec_instances
            dec_tester #(.WIDTH(j+1)) t0(.in(in[j:0]), .clk(clk), .out(out[j][(2**(j+1))-1:0]));
        end
    endgenerate

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        in = 0;
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

module dec_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in,
                                       input clk,
                                       output [(2**WIDTH)-1:0] out);

    decodern #(.INPUT_WIDTH(WIDTH)) m0(.in(in), .out(out));

    always @(posedge clk) begin
        if (out != 1 << in) begin
            $display("TEST FAILED DEC(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, 1 << in); 
        end
    end

endmodule