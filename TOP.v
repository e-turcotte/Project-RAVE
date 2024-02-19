module TOP;
    localparam CYCLE_TIME = 2.0;
    
    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end
endmodule

