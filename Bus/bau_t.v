module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [3:0] sender, dest;
    reg req_ready;
    reg releaseIE, releaseIO, releaseDEr, releaseDEw, releaseDOr, releaseDOw, releaseB0, releaseB1, releaseB2, releaseB3, releaseDMA;
    reg clr;
    wire pull;
    wire grantIE, grantIO, grantDEr, grantDEw, grantDOr, grantDOw, grantB0, grantB1, grantB2, grantB3, grantDMA;
    wire recvIE, recvIO, recvDE, recvDO, recvB0, recvB1, recvB2, recvB3, recvDMA;
    reg clk;

    bau m0(.sender(sender), .dest(dest), .req_ready(req_ready),
           .relIE(releaseIE), .relIO(releaseIO),
           .relDEr(releaseDEr), .relDEw(releaseDEw), .relDOr(releaseDOr), .relDOw(releaseDOw),
           .relB0(releaseB0), .relB1(releaseB1), .relB2(releaseB2), .relB3(releaseB3),
           .relDMA(releaseDMA),
           .clr(clr), .clk(clk),
           .pull(pull),
           .grantIE(grantIE), .grantIO(grantIO),
           .grantDEr(grantDEr), .grantDEw(grantDEw), .grantDOr(grantDOr), .grantDOw(grantDOw),
           .grantB0(grantB0), .grantB1(grantB1), .grantB2(grantB2), .grantB3(grantB3),
           .grantDMA(grantDMA),
           .recvIE(recvIE), .recvIO(recvIO), .recvDE(recvDE), .recvDO(recvDO),
           .recvB0(recvB0), .recvB1(recvB1), .recvB2(recvB2), .recvB3(recvB3),
           .recvDMA(recvDMA));
    
    

    initial begin
        clk = 1'B1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'B0;
        req_ready = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        req_ready = 1'b1;
        sender = 4'h0; dest = 4'hc;
        
        releaseIE =  1'b0; releaseIO =  1'b0;
        releaseDEr = 1'b0; releaseDEw = 1'b0; releaseDOr = 1'b0; releaseDOw = 1'b0;
        releaseB0 =  1'b0; releaseB1 =  1'b0; releaseB2 =  1'b0; releaseB3 =  1'b0;
        releaseDMA = 1'b0;
        #CYCLE_TIME;
        sender = 4'hc; dest = 4'hb;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        releaseIE = 1'b1;
        #CYCLE_TIME;
        releaseIE = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        req_ready = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        releaseDMA = 1'b1;
        #CYCLE_TIME;
        releaseDMA = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;

        $finish;
    end

    always @(posedge clk) begin
        $display("SENT BY %b", {grantIE,grantIO,grantDEr,grantDOr,grantDEw,grantDOw,grantB0,grantB1,grantB2,grantB3,grantDMA});
        $display("RECV BY %b", {recvIE , recvIO,  recvDE,  recvDO,  recvDE,  recvDO, recvB0, recvB1, recvB2, recvB3, recvDMA});
        $display("\n");
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule