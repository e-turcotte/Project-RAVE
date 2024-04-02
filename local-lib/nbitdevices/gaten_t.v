module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k, l;

    reg [NUM_TESTS+1:0] in;
    wire [NUM_TESTS-1:0] and_out;
    wire [NUM_TESTS-1:0] or_out;
    reg clk;

    genvar j;
    generate
        for(j = 0; j < NUM_TESTS; j = j + 1) begin : andor_instances
            andn_tester #(.WIDTH(j+2)) t0(.in(in[j+1:0]), .clk(clk), .out(and_out[j]));
            orn_tester #(.WIDTH(j+2)) t1(.in(in[j+1:0]), .clk(clk), .out(or_out[j]));
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
        $dumpvars(4, TOP);
    end

endmodule

module andn_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in,
                                         input clk,
                                         output out);

    andn #(.NUM_INPUTS(WIDTH)) m0(.in(in), .out(out));

    always @(posedge clk) begin
        if (out != &in) begin
            $display("TEST FAILED AND(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, &in); 
        end
    end

endmodule

module orn_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in,
                                        input clk,
                                        output out);

    orn #(.NUM_INPUTS(WIDTH)) m0(.in(in), .out(out));

    always @(posedge clk) begin
        if (out != |in) begin
            $display("TEST FAILED OR(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, |in); 
        end
    end

endmodule
