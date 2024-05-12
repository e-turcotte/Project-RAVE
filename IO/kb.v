module kb(
    input clk,
    input rst,

    output reg[7:0] data_kb,
    input read_kb,

    input valid_in_kb,
    input[7:0] data_in_kb
);

reg state;




always @(posedge clk) begin
    if(!rst) begin
        data_kb <= 0;
        state <= 0;
    end
    else begin
        case(state)
            1'b0:  begin 
            data_kb <= data_in_kb;
                if(valid_in_kb) begin
                    state <= 1;
                end
            end
            1'b1: begin
                if(read_kb) state <= 0;
            end

        endcase
    end
end




endmodule