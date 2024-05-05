module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [3:0] destIE, destIO, destDE, destDO, destB0, destB1, destB2, destB3, destDMA;
    reg reqIE, reqIO, reqDE, reqDO, reqB0, reqB1, reqB2, reqB3, reqDMA;
    reg freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA;
    reg pull;
    reg clr;
    wire ackIE, ackIO, ackDE, ackDO, ackB0, ackB1, ackB2, ackB3, ackDMA;
    wire req_ready;
    wire [3:0] send_out;
    reg clk;

    brq m0(.destIE(destIE), .destIO(destIO), .destDE(destDE), .destDO(destDO),
           .destB0(destB0), .destB1(destB1), .destB2(destB2), .destB3(destB3),
           .destDMA(destDMA),
           .reqIE(reqIE), .reqIO(reqIO), .reqDE(reqDE), .reqDO(reqDO),
           .reqB0(reqB0), .reqB1(reqB1), .reqB2(reqB2), .reqB3(reqB3),
           .reqDMA(reqDMA),
           .freeIE(freeIE), .freeIO(freeIO), .freeDE(freeDE), .freeDO(freeDO),
           .freeB0(freeB0), .freeB1(freeB1), .freeB2(freeB2), .freeB3(freeB3),
           .freeDMA(freeDMA),
           .pull(pull), .clk(clk), .clr(clr),
           .ackIE(ackIE), .ackIO(ackIO), .ackDE(ackDE), .ackDO(ackDO),
           .ackB0(ackB0), .ackB1(ackB1), .ackB2(ackB2), .ackB3(ackB3),
           .ackDMA(ackDMA),
           .req_ready(req_ready), .send_out(send_out));

    initial begin
        clk = 1'B1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'B0;
        reqIE = 1'B0; reqIO = 1'B0; reqDE = 1'B0; reqDO = 1'B0; reqB0 = 1'B0; reqB1 = 1'B0; reqB2 = 1'B0; reqB3 = 1'B0; reqDMA = 1'B0;
        #CYCLE_TIME;
        clr = 1'B1;
        destIE = 4'h8; destIO = 4'h9; destDE = 4'ha; destDO = 4'hb; destB0 = 4'h6; destB1 = 4'h5; destB2 = 4'h2; destB3 = 4'h1; destDMA = 4'h2;
        freeIE = 1'B0; freeIO = 1'B1; freeDE = 1'B1; freeDO = 1'B0; freeB0 = 1'B1; freeB1 = 1'B0; freeB2 = 1'B0; freeB3 = 1'B1; freeDMA = 1'B1;
        reqIE = 1'B1; reqIO = 1'B1; reqDE = 1'B1; reqDO = 1'B1; reqB0 = 1'B1; reqB1 = 1'B1; reqB2 = 1'B1; reqB3 = 1'B1; reqDMA = 1'B1;
        pull = 1'B0;
        #CYCLE_TIME;
        reqDMA = 1'b0;
        #CYCLE_TIME;
        reqIE = 1'b0;
        #CYCLE_TIME;
        reqIO = 1'b0;
        #CYCLE_TIME;
        reqDE = 1'b0;
        #CYCLE_TIME;
        reqDO = 1'b0;
        #CYCLE_TIME;
        reqB0 = 1'b0;
        #CYCLE_TIME;
        reqB1 = 1'b0;
        #CYCLE_TIME;
        reqB2 = 1'b0;
        #CYCLE_TIME;
        reqB3 = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        pull = 1'B1;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;

        $finish;
    end

    always @(posedge clk) begin
        $display("R8: 0x%h", m0.rout[8]);
        $display("R7: 0x%h", m0.rout[7]);
        $display("R6: 0x%h", m0.rout[6]);
        $display("R5: 0x%h", m0.rout[5]);
        $display("R4: 0x%h", m0.rout[4]);
        $display("R3: 0x%h", m0.rout[3]);
        $display("R2: 0x%h", m0.rout[2]);
        $display("R1: 0x%h", m0.rout[1]);
        $display("R0: 0x%h", m0.rout[0]);
        $display("\n");
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule