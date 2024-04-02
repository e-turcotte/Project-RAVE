module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k, l;

    reg [NUM_TESTS+1:0] a, b;
    wire [NUM_TESTS-1:0] out;
    reg clk;

    genvar j;
    generate
        for(j = 0; j < NUM_TESTS; j = j + 1) begin : eq_instances
            eq_tester #(.WIDTH(j+2)) t0(.a(a[j+1:0]), .b(b[j+1:0]), .clk(clk), .out(out[j]));
        end
    endgenerate

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        a = 0;
        b = 2**NUM_TESTS;
        for (k = 0; k < 2**(NUM_TESTS+1); k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
        end
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(4, TOP);
    end

endmodule

module eq_tester #(parameter WIDTH=2) (input [WIDTH-1:0] a, b,
                                       input clk,
                                       output out);

    equaln #(.WIDTH(WIDTH)) m0(.a(a), .b(b), .eq(out));

    always @(posedge clk) begin
        if (out != (a == b)) begin
            $display("TEST FAILED EQ(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, a == b); 
        end
    end

endmodule