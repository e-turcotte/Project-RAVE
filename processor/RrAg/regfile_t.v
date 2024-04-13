module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k;
    reg [7:0] regk, regkinc;

    reg [63:0] in0, in1;
    reg [2:0] ld0, ld1,  rd0, rd1, rd2, rd3;
    reg [3:0] ldsize, rdsize;
    reg clr;
    wire [63:0] out0, out1, out2, out3;
    reg clk;

    regfile rf(.din({in1,in0}), .ld({ld1,ld0}), .rd({rd3,rd2,rd1,rd0}), .ldsize(ldsize), .rdsize(rdsize), .clr(clr), .clk(clk), .dout({out3,out2,out1,out0}));


    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        rd0 = 0; rd1 = 0; rd2 = 0; rd3 = 0;
        ld0 = 0; ld1 = 0;
        ldsize = 4'b0100; rdsize = 4'b0100;
        clr = 1'b1;
        #CYCLE_TIME;
        for (k = 0; k < 8; k = k + 2) begin
            regk = k & 8'hff; regkinc = (k+1) & 8'hff;
            in0 = {64{regk}};
            in1 = {64{regkinc}};
            rd0 = rd2; rd1 = rd3; rd2 = ld0; rd3 = ld1;
            ld0 = regk[2:0]; ld1 =regkinc[2:0];
            #CYCLE_TIME; 
        end

        ldsize = 4'b1000; rdsize = 4'b1000;
        for (k = 0; k < 8; k = k + 2) begin
            regk = k & 8'hff; regkinc = (k+1) & 8'hff;
            in0 = {64{regk<<4}};
            in1 = {64{regkinc<<4}};
            rd0 = rd2; rd1 = rd3; rd2 = ld0; rd3 = ld1;
            ld0 = regk[2:0]; ld1 =regkinc[2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;

        ldsize = 4'b0010; rdsize = 4'b0010;
        for (k = 0; k < 8; k = k + 2) begin
            regk = k & 8'hff; regkinc = (k+1) & 8'hff;
            in0 = {64{1'b1}};
            in1 = {64{1'b1}};
            rd0 = rd2; rd1 = rd3; rd2 = ld0; rd3 = ld1;
            ld0 = regk[2:0]; ld1 =regkinc[2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;

        ldsize = 4'b0001; rdsize = 4'b0001;
        for (k = 0; k < 8; k = k + 2) begin
            regk = k & 8'hff; regkinc = (k+1) & 8'hff;
            in0 = {64{regk<<4}};
            in1 = {64{regkinc<<4}};
            rd0 = rd2; rd1 = rd3; rd2 = ld0; rd3 = ld1;
            ld0 = regk[2:0]; ld1 =regkinc[2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule