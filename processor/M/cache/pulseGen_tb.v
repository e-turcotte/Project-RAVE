module pulseGen_tb();
parameter W = 4;
localparam CYCLE_TIME = 12.0;
//reg[W*8-1:0] A, B;
//reg[W*8-1:0] C32;
//reg[W*4-1:0] C16;
//reg[W*2-1:0] C8;
//reg[W*1-1:0] C4;
//reg CIN;
reg clk;
wire COUT32, COUT16, COUT8, COUT4;
wire pulse; reg signal;

pulseGen p1(clk, signal, pulse);

initial begin
    signal = 1;
    #CYCLE_TIME
    
    signal = 0;
        #CYCLE_TIME
    signal = 1;
        #CYCLE_TIME
        #CYCLE_TIME
        #CYCLE_TIME
    signal = 0;
        #CYCLE_TIME
        #CYCLE_TIME    #CYCLE_TIME
        #CYCLE_TIME
        signal =1;
            #CYCLE_TIME
        #CYCLE_TIME
        $finish;

end
initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end
initial begin
 $vcdplusfile("pulseGen.vpd");
 $vcdpluson(0, pulseGen_tb); 
end

endmodule