module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [3:0] sender;
    reg req_ready;
    reg releaseIE, releaseIO, releaseDE, releaseDO, releaseB0, releaseB1, releaseB2, releaseB3, releaseDMA;
    reg clr;
    wire grantIE, grantIO, grantDE, grantDO, grantB0, grantB1, grantB2, grantB3, grantDMA;
    reg clk;

    bau m0(.sender(sender), .req_ready(req_ready),
           .releaseIE(releaseIE), .releaseIO(releaseIO), .releaseDE(releaseDE), .releaseDO(releaseDO),
           .releaseB0(releaseB0), .releaseB1(releaseB1), .releaseB2(releaseB2), .releaseB3(releaseB3),
           .releaseDMA(releaseDMA),
           .clr(clr), .clk(clk),
           .grantIE(grantIE), .grantIO(grantIO), .grantDE(grantDE), .grantDO(grantDO),
           .grantB0(grantB0), .grantB1(grantB1), .grantB2(grantB2), .grantB3(grantB3),
           .grantDMA(grantDMA));
    
    

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
        sender = 4'h2;
        
        releaseIE = 1'b0; releaseIO = 1'b0; releaseDE = 1'b0; releaseDO = 1'b0;
        releaseB0 = 1'b0; releaseB1 = 1'b0; releaseB2 = 1'b0; releaseB3 = 1'b0;
        releaseDMA = 1'b0;
        #CYCLE_TIME;
        sender = 4'hc;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        releaseIE = 1'b1;
        #CYCLE_TIME;
        releaseIE = 1'b0;
        #CYCLE_TIME;

        $finish;
    end

    always @(posedge clk) begin
        $display("HELD BY %b", {grantIE,grantIO,grantDE,grantDO,grantB0,grantB1,grantB2,grantB3,grantDMA});
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule