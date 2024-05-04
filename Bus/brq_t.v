module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [3:0] send3, send2, send1, send0;
    reg [3:0] dest3, dest2, dest1, dest0;
    reg req3, req2, req1, req0;
    reg free4, free3, free2, free1, free0;
    reg pull;
    reg clr;
    wire ack3, ack2, ack1, ack0;
    wire valid, empty;
    wire [3:0] send_out;
    reg clk;

    brq m0(.send3(send3), .send2(send2), .send1(send1), .send0(send0),
           .dest3(dest3), .dest2(dest2), .dest1(dest1), .dest0(dest0),
           .req3(req3), .req2(req2), .req1(req1), .req0(req0),
           .free4(free4), .free3(free3), .free2(free2), .free1(free1), .free0(free0),
           .pull(pull), .clk(clk), .clr(clr),
           .ack3(ack3), .ack2(ack2), .ack1(ack1), .ack0(ack0),
           .valid(valid), .empty(empty), .send_out(send_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        req3 = 1'b0; req2 = 1'b0; req1 = 1'b0; req0 = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        send3 = 4'h6; send2 = 4'h5; send1 = 4'h2; send0 = 4'h0;
        dest3 = 4'hb; dest2 = 4'ha; dest1 = 4'h9; dest0 = 4'h8;
        free4 = 1'b1; free3 = 1'b1; free2 = 1'b1; free1 = 1'b1; free0 = 1'b1; 
        pull = 1'b0;
        req3 = 1'b1; req2 = 1'b1; req1 = 1'b1; req0 = 1'b1;
        #CYCLE_TIME;
        req3 = 1'b0; req2 = 1'b1; req1 = 1'b1; req0 = 1'b1; 
        #CYCLE_TIME;
        req3 = 1'b0; req2 = 1'b0; req1 = 1'b1; req0 = 1'b1; 
        #CYCLE_TIME;
        req3 = 1'b0; req2 = 1'b0; req1 = 1'b0; req0 = 1'b1;
        #CYCLE_TIME;
        req3 = 1'b0; req2 = 1'b0; req1 = 1'b0; req0 = 1'b0;
        #CYCLE_TIME;
        pull = 1'b1;
        free2 = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        $finish;
    end

    always @(posedge clk) begin
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