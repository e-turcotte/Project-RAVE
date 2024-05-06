module LRU_FSM_tb();
localparam CYCLE_TIME = 18.0;
    reg clk;
    reg rst, set;
initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
 $vcdplusfile("LRU_FSM.vpd");
 $vcdpluson(0, LRU_FSM_tb); 
end

    wire [3:0]LRUx;

    reg[3:0] LRUin;
    reg enable;
    LRU_FSM1 lfs(.LRUx(LRUx), .clk(clk), .rst(rst), .set(set), .LRUin(LRUin), .enable(enable));

initial begin
    enable = 0;
    rst = 0;
    set = 1;
    #CYCLE_TIME
    rst = 1;
    enable = 1;
    LRUin = 1;
    #CYCLE_TIME
    LRUin = 1;
    #CYCLE_TIME
    LRUin = 2;
    #CYCLE_TIME
    LRUin =4;
    #CYCLE_TIME
    LRUin = 8;
    #CYCLE_TIME
    LRUin = 4;
    #CYCLE_TIME
    LRUin = 0;
    #CYCLE_TIME
    LRUin = 8;
    #CYCLE_TIME
    LRUin = 1;
    #CYCLE_TIME

    LRUin = 4;
    #CYCLE_TIME
    enable = 0;
    LRUin = 2;
    #CYCLE_TIME
    LRUin = 1;
    $finish ;
    
    

    
end

endmodule
