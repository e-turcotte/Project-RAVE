module kb(
    input clk,
    input rst,

    output reg[7:0] data_kb,
    input read_kb


);

reg state;

reg [119:0] chars;


always @(posedge clk) begin
    if(!rst) begin
        data_kb <= 0;
        state <= 0;
        chars<= 120'h41_7368_6572_2077_6173_2068_6572_6521;
    end
    else begin
        data_kb <= chars[7:0];          
        if(read_kb) chars <= {8'd0, chars[119:8]};  
    end
end




endmodule