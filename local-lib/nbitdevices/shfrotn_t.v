module XKCD;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 12;
    integer k;

    reg [NUM_TESTS-1:0] in, shfrot;
    wire [NUM_TESTS-1:0] lshf_out, rshf_out, lrot_out, rrot_out;
    wire [NUM_TESTS-1:0] lshfv_out, rshfv_out, lrotv_out, rrotv_out;
    reg clk;

    shfrot_tester #(.WIDTH(NUM_TESTS)) m0(.in(in), .shfrot(shfrot), .clk(clk),
                                          .lshf_out(lshf_out), .rshf_out(rshf_out), .lrot_out(lrot_out), .rrot_out(rrot_out),
                                          .lshfv_out(lshfv_out), .rshfv_out(rshfv_out), .lrotv_out(lrotv_out), .rrotv_out(rrotv_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        in = 0;
        shfrot = 12'h010;
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

module shfrot_tester #(parameter WIDTH=2) (input [WIDTH-1:0] in, shfrot,
                                           input clk,
                                           output [WIDTH-1:0] lshf_out, rshf_out, lrot_out, rrot_out,
                                           output [WIDTH-1:0] lshfv_out, rshfv_out, lrotv_out, rrotv_out);

    lshfn_fixed #(.WIDTH(WIDTH), .SHF_AMNT(4)) m0(.in(in), .shf_val(4'h0), .out(lshf_out));
    rshfn_fixed #(.WIDTH(WIDTH), .SHF_AMNT(4)) m1(.in(in), .shf_val({4{in[WIDTH-1]}}), .out(rshf_out));
    lrotn_fixed #(.WIDTH(WIDTH), .ROT_AMNT(4)) m2(.in(in), .out(lrot_out));
    rrotn_fixed #(.WIDTH(WIDTH), .ROT_AMNT(4)) m3(.in(in), .out(rrot_out));

    lshfn_variable #(.WIDTH(WIDTH)) m4(.in(in), .shf(shfrot), .shf_val(1'b0), .out(lshfv_out));
    rshfn_variable #(.WIDTH(WIDTH)) m5(.in(in), .shf(shfrot), .shf_val(in[WIDTH-1]), .out(rshfv_out));
    lrotn_variable #(.WIDTH(WIDTH)) m6(.in(in), .rot(shfrot), .out(lrotv_out));
    rrotn_variable #(.WIDTH(WIDTH)) m7(.in(in), .rot(shfrot), .out(rrotv_out));

    always @(posedge clk) begin
        if (lshf_out != lshfv_out) begin
            $display("TEST FAILED LSHF:\tfixed=0x%0h, variable=0x%0h", lshf_out, lshfv_out); 
        end
        if (rshf_out != rshfv_out) begin
            $display("TEST FAILED RSHF:\tfixed=0x%0h, variable=0x%0h", rshf_out, rshfv_out); 
        end
        if (lrot_out != lrotv_out) begin
            $display("TEST FAILED LROT:\tfixed=0x%0h, variable=0x%0h", lrot_out, lrotv_out); 
        end
        if (rrot_out != rrotv_out) begin
            $display("TEST FAILED RROT:\tfixed=0x%0h, variable=0x%0h", rrot_out, rrotv_out); 
        end
    end

endmodule