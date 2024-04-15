module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k;
    reg [7:0] regk;

    reg [15:0] base_in;
    reg [2:0] ld, rd;
    reg clr;
    wire [15:0] base_out;
    wire [19:0] lim_out;
    reg clk;

    segfile sf(.base_in(base_in), .ld(ld), .rd(rd), .clr(clr), .clk(clk), .base_out(base_out), .lim_out(lim_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        #CYCLE_TIME;

        clr = 1'b1;
        for (k = 0; k < 6; k = k + 1) begin
            regk = k & 8'hff;
            base_in = {64{regk<<4}};
            rd = ld;
            ld = regk[2:0];
            #CYCLE_TIME; 
        end
        #2*CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule