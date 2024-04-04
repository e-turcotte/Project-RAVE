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
        for(j = 0; j < NUM_TESTS; j = j + 1) begin : eq_instances
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
        $dumpvars(4, TOP);
    end

endmodule

module reg_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in,
                                        input clk, clr,
                                        output [WIDTH-1:0] out);

    regn #(.WIDTH(WIDTH)) m0(.din(in), .ld(~in[0]), .clr(clr), .clk(clk), .dout(out));

    always @(posedge clk) begin
        if (out != ((in%2==0)? in-2 : in-1)) begin
            $display("TEST FAILED REG(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, (in%2==0)? in-2 : in-1); 
        end
    end

endmodule