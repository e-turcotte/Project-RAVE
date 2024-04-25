module satAdder_t();
parameter W = 4;
localparam CYCLE_TIME = 10.0;
reg[W*8-1:0] A, B;
reg[W*8-1:0] C32;
reg[W*4-1:0] C16;
reg[W*2-1:0] C8;
reg[W*1-1:0] C4;
reg CIN;
reg clk;
wire COUT32, COUT16, COUT8, COUT4;
satAdder #(32) s1(C32, COUT32, A, B, CIN);
satAdder #(16) s2(C16, COUT16, A, B, CIN);
satAdder #(8) s3(C8, COUT8, A, B, CIN);
satAdder #(4) s4(C4, COUT4, A, B, CIN);

initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
    A=0; B = 0; CIN = 0; 
    
end

endmodule