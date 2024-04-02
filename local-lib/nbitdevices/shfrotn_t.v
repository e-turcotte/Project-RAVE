module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 16;
    integer k;

    reg [NUM_TESTS-1:0] in;
    wire [NUM_TESTS-1:0] lshf_out, rshf_out, lrot_out, rrot_out;
    reg clk;

    lshfn_fixed #(.WIDTH(NUM_TESTS), .SHF_AMNT(4)) m0(.in(in), .shf_in(4'h0), .out(lshf_out));
    rshfn_fixed #(.WIDTH(NUM_TESTS), .SHF_AMNT(4)) m1(.in(in), .shf_in(4'h0), .out(rshf_out));
    lrotn_fixed #(.WIDTH(NUM_TESTS), .ROT_AMNT(4)) m2(.in(in), .out(lrot_out));
    rrotn_fixed #(.WIDTH(NUM_TESTS), .ROT_AMNT(4)) m3(.in(in), .out(rrot_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        in = 0;
        for (k = 0; k < 2**(NUM_TESTS); k = k + 1) begin
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