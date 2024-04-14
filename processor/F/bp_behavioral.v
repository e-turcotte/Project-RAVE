module bp_behavioral(
    input clk,
    input [31:0] eip,
    input prev_BR_result,
    input [5:0] prev_BR_alias,
    input prev_is_BR,
    output reg prediction,
    output reg [5:0] BR_alias
);

    reg [5:0] GBHR, GBHR_shifted;
    wire [63:0] counter_out, counter_en_in;

    decodern #(.INPUT_WIDTH(6)) pred_in(.in(prev_BR_alias), .out(counter_en_in));
    decodern #(.INPUT_WIDTH(6)) pred_out(.in(BR_alias), .out(counter_out));

    generate 
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin
            sat_2b_behavioral (.clk(clk), .in(prev_BR_result), .enable(counter_en_in[i]), .s_out_high_bit(counter_out[i]));
        end
    endgenerate

    always @(posedge clk) begin
        if (prev_is_BR) begin
            GBHR_shifted = GBHR << 1;
            GBHR_shifted[0] = prev_BR_result;
        end

        BR_alias[0] = eip[29] ^ GBHR[5];
        BR_alias[1] = eip[23] ^ GBHR[4];
        BR_alias[2] = eip[17] ^ GBHR[3];
        BR_alias[3] = eip[11] ^ GBHR[2];
        BR_alias[4] = eip[8] ^ GBHR[1];
        BR_alias[5] = eip[2] ^ GBHR[0];
    end

    always @(negedge clk) begin
        if (prev_is_BR) begin
            GBHR = GBHR_shifted;
        end
    end

endmodule


module sat_2b_behavioral(
    input wire clk,
    input wire in,
    input wire enable,
    output wire s_out_high_bit
);
    wire [1:0] s_out;

    always @(posedge clk) begin
        if (enable) begin
            if (in) begin
                if (s_out == 2'b11) begin
                    assign s_out = 2'b11;
                end else begin
                    assign s_out = s_out + 1;
                end
            end else begin
                if (s_out == 2'b00) begin
                    assign s_out = 2'b00;
                end else begin
                    assign s_out = s_out - 1;
                end
            end
        end    
    end

    assign s_out_high_bit = s_out[1];

endmodule