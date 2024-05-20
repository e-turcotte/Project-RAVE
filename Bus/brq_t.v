module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [3:0] destIE, destIO, destDEr, destDEw, destDOr, destDOw, destB0, destB1, destB2, destB3, destDMA;
    reg reqIE, reqIO, reqDEr, reqDEw, reqDOr, reqDOw, reqB0, reqB1, reqB2, reqB3, reqDMA;
    reg freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA;
    reg pull;
    reg clr;
    wire ackIE, ackIO, ackDEr, ackDEw, ackDOr, ackDOw, ackB0, ackB1, ackB2, ackB3, ackDMA;
    wire req_ready;
    wire [3:0] send_out, dest_out;
    reg clk;

    brq m0(.req_data({4'hc,destDMA,4'h0,destIE,4'h1,destIO,4'h4,destDEr,4'h6,destDEw,4'h5,destDOr,4'h7,destDOw,4'h8,destB0,4'h9,destB1,4'ha,destB2,4'hb,destB3}),
           .req({reqDMA,reqIE,reqIO,reqDEr,reqDEw,reqDOr,reqDOw,reqB0,reqB1,reqB2,reqB3}),
           .freeIE(freeIE), .freeIO(freeIO), .freeDE(freeDE), .freeDO(freeDO),
           .freeB0(freeB0), .freeB1(freeB1), .freeB2(freeB2), .freeB3(freeB3),
           .freeDMA(freeDMA),
           .pull(pull), .clk(clk), .clr(clr),
           .ack({ackDMA,ackIE,ackIO,ackDEr,ackDEw,ackDOr,ackDOw,ackB0,ackB1,ackB2,ackB3}),
           .req_ready(req_ready), .send_out(send_out), .dest_out(dest_out));

    initial begin
        clk = 1'B1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'B0;
        reqIE = 1'B0; reqIO = 1'B0; reqDEr = 1'B0; reqDEw = 1'B0; reqDOr = 1'B0; reqDOw = 1'B0; reqB0 = 1'B0; reqB1 = 1'B0; reqB2 = 1'B0; reqB3 = 1'B0; reqDMA = 1'B0;
        #CYCLE_TIME;
        clr = 1'B1;
        destIE = 4'h8; destIO = 4'h9; destDEr = 4'ha; destDEw = 4'h5; destDOr = 4'hb; destDOw = 4'hc; destB0 = 4'h4; destB1 = 4'h5; destB2 = 4'h0; destB3 = 4'h1; destDMA = 4'h0;
        freeIE = 1'B0; freeIO = 1'B1; freeDE = 1'B1; freeDO = 1'B0; freeB0 = 1'B1; freeB1 = 1'B0; freeB2 = 1'B0; freeB3 = 1'B1; freeDMA = 1'B1;
        reqIE = 1'B1; reqIO = 1'B1; reqDEr = 1'B1; reqDEw = 1'B1; reqDOr = 1'B1; reqDOw = 1'B1; reqB0 = 1'B1; reqB1 = 1'B1; reqB2 = 1'B1; reqB3 = 1'B1; reqDMA = 1'B1;
        pull = 1'B0;
        #CYCLE_TIME;
        reqDMA = 1'b0;
        #CYCLE_TIME;
        reqIE = 1'b0;
        #CYCLE_TIME;
        reqIO = 1'b0;
        #CYCLE_TIME;
        reqDEr = 1'b0;
        #CYCLE_TIME;
        reqDEw = 1'b0;
        #CYCLE_TIME;
        reqDOr = 1'b0;
        #CYCLE_TIME;
        reqDOw = 1'b0;
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
        freeIE = 1'B0; freeDO = 1'B1; freeB1 = 1'B0; freeB2 = 1'B1;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        freeIE = 1'B1; freeDO = 1'B1; freeB1 = 1'B1; freeB2 = 1'B1;
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
        $display("BRQ10: 0x%h", m0.rout[10]);
        $display("BRQ9:  0x%h", m0.rout[9]);
        $display("BRQ8:  0x%h", m0.rout[8]);
        $display("BRQ7:  0x%h", m0.rout[7]);
        $display("BRQ6:  0x%h", m0.rout[6]);
        $display("BRQ5:  0x%h", m0.rout[5]);
        $display("BRQ4:  0x%h", m0.rout[4]);
        $display("BRQ3:  0x%h", m0.rout[3]);
        $display("BRQ2:  0x%h", m0.rout[2]);
        $display("BRQ1:  0x%h", m0.rout[1]);
        $display("BRQ0:  0x%h", m0.rout[0]);
        $display("\n");
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule