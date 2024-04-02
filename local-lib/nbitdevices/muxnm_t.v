module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 2;
    integer k, l;

    reg [NUM_TESTS-1:0] a, b, c, d, e;
    reg [5-1:0] tristate_sel;
    reg [3-1:0] tree_sel;
    wire [NUM_TESTS-1:0] tristate_out, tree_out;
    reg clk;

    muxnm_tristate #(.NUM_INPUTS(5), .DATA_WIDTH(NUM_TESTS)) m0(.in({a,b,c,d,e}), .sel(tristate_sel), .out(tristate_out));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(NUM_TESTS)) m1(.in({6'h0,e,d,c,b,a}), .sel(tree_sel), .out(tree_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        a = 0; b = 0; c = 0; d = 0; e = 0;
        tristate_sel = 5'h0f;
        tree_sel = 3'h0;
        for (k = 0; k < (2**(NUM_TESTS))*5; k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
            if(k % 2 == 0) b <= b + 1; 
            if(k % 3 == 0) c <= c + 1; 
            if(k % 4 == 0) d <= d + 1; 
            if(k % 5 == 0) e <= e + 1;
            if (tristate_out != tree_out) begin
                $display("TEST FAILED:\ttristate=0x%0h, tree=0x%0h", tristate_out, tree_out); 
            end
        end
        a = 0; b = 0; c = 0; d = 0; e = 0;
        tristate_sel = 5'h17;
        tree_sel = 3'h1;
        for (k = 0; k < (2**(NUM_TESTS))*5; k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
            if(k % 2 == 0) b <= b + 1; 
            if(k % 3 == 0) c <= c + 1; 
            if(k % 4 == 0) d <= d + 1; 
            if(k % 5 == 0) e <= e + 1;
            if (tristate_out != tree_out) begin
                $display("TEST FAILED:\ttristate=0x%0h, tree=0x%0h", tristate_out, tree_out); 
            end
        end
        a = 0; b = 0; c = 0; d = 0; e = 0;
        tristate_sel = 5'h1b;
        tree_sel = 3'h2;
        for (k = 0; k < (2**(NUM_TESTS))*5; k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
            if(k % 2 == 0) b <= b + 1; 
            if(k % 3 == 0) c <= c + 1; 
            if(k % 4 == 0) d <= d + 1; 
            if(k % 5 == 0) e <= e + 1;
            if (tristate_out != tree_out) begin
                $display("TEST FAILED:\ttristate=0x%0h, tree=0x%0h", tristate_out, tree_out); 
            end
        end
        a = 0; b = 0; c = 0; d = 0; e = 0;
        tristate_sel = 5'h1d;
        tree_sel = 3'h3;
        for (k = 0; k < (2**(NUM_TESTS))*5; k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
            if(k % 2 == 0) b <= b + 1; 
            if(k % 3 == 0) c <= c + 1; 
            if(k % 4 == 0) d <= d + 1; 
            if(k % 5 == 0) e <= e + 1;
            if (tristate_out != tree_out) begin
                $display("TEST FAILED:\ttristate=0x%0h, tree=0x%0h", tristate_out, tree_out); 
            end
        end
        a = 0; b = 0; c = 0; d = 0; e = 0;
        tristate_sel = 5'h1e;
        tree_sel = 3'h4;
        for (k = 0; k < (2**(NUM_TESTS))*5; k = k + 1) begin
            #CYCLE_TIME;
            a <= a + 1;
            if(k % 2 == 0) b <= b + 1; 
            if(k % 3 == 0) c <= c + 1; 
            if(k % 4 == 0) d <= d + 1; 
            if(k % 5 == 0) e <= e + 1;
            if (tristate_out != tree_out) begin
                $display("TEST FAILED:\ttristate=0x%0h, tree=0x%0h", tristate_out, tree_out); 
            end
        end
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(7, TOP);
    end

endmodule

/*module eq_tester #(parameter WIDTH=2) (input [WIDTH-1:0] a, b,
                                       input clk,
                                       output out);

    equaln #(.WIDTH(WIDTH)) m0(.a(a), .b(b), .eq(out));

    always @(posedge clk) begin
        if (out != (a == b)) begin
            $display("TEST FAILED EQ(n=%0d):\tactual=0x%0h, ref=0x%0h", WIDTH, out, a == b); 
        end
    end

endmodule*/