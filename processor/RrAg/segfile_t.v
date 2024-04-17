module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k;
    reg [7:0] regk;

    reg [15:0] base_in;
    reg [2:0] ld, rd1, rd0;
    reg ld_en, clr;
    wire [15:0] base_out1, base_out0;
    wire [19:0] lim_out1, lim_out0;
    reg clk;

    segfile sf(.base_in(base_in), .ld_addr(ld), .rd_addr({rd1,rd0}), .ld_en(ld_en), .clr(clr), .clk(clk), .base_out({base_out1,base_out0}), .lim_out({lim_out1,lim_out0}));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        #CYCLE_TIME;

        ld_en = 1'b1;
        clr = 1'b1;
        rd0 = 3'b000;
        for (k = 0; k < 6; k = k + 1) begin
            regk = k & 8'hff;
            base_in = {64{regk<<4}};
            rd1 = ld;
            ld = regk[2:0];
            ld_en = ~ld_en;
            #CYCLE_TIME; 
        end
        #(2*CYCLE_TIME);
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule