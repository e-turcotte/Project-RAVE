module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;

    reg clr;
    wire [7:0] ptcid;
    reg clk;

    ptc_generator m0(.next(1'b1), .clr(clr), .clk(clk), .ptcid(ptcid));


    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        #(10*CYCLE_TIME);
        clr = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        #(12*CYCLE_TIME);
        clr = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        #(8*CYCLE_TIME);
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule