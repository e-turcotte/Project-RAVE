module fetch_stage_1 (
    input wire clk,
    input wire [27:0] init_FIP_o,
    input wire [27:0] init_FIP_e,

    
);

wire ld_FIP_o, ld_FIP_e;
reg [27:0] FIP_o, FIP_e;

    
endmodule


module BP_BTB (
    input wire clk,
    output WB_resteer,

);

reg [5:0] resteer_counter;

    
endmodule

module mux2to1 #(
    parameter WIDTH = 32
) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [clog2(N)-1:0] sel,
    output wire [WIDTH-1:0] out
);

always @(*) begin
    if(sel == 0) begin
        out = a;
    end
    else begin
        out = b;
    end
end

endmodule

module ICache (
    input wire clk,
    input wire [27:0] FIP_o,
    input wire [27:0] FIP_e,
    input wire even_OE,
    input wire odd_OE,
    output cache_miss_even,
    output cache_miss_odd,
    output wire [127:0] odd_line,
    output wire [127:0] even_line
);


ICache_bank #(.miss_freq(2), .modality(0)) even(.clk(clk), .addr(FIP_e[27:1]), .OE(even_OE), .cache_miss(cache_miss_even), .line(even_line));
ICache_bank #(.miss_freq(2), .modality(1)) odd(.clk(clk), .addr(FIP_o[27:1]), .OE(odd_OE), .cache_miss(cache_miss_odd), .line(odd_line));

endmodule

module ICache_bank #(
    parameter miss_freq = 2,
    modality = 0;
) (
    input wire clk,
    input wire [26:0] addr,
    input wire OE,
    output cache_miss,
    output wire [127:0] line
);

wire [$clog2(miss_freq):0] miss_counter;
always @(posedge clk) begin
    if(modality == 0) begin
        if(OE == 1'b1) begin
            if(miss_counter == miss_freq) begin
                cache_miss <= 1;
                miss_counter <= 0;
            end
            else begin
                cache_miss <= 0;
                miss_counter <= miss_counter + 1;
            end
            line <= {addr, 5'b0, 96'hBEEF0000FEED}; // specifier for even lines
        end
    end
    else begin
        if(OE == 1'b1) begin
            if(miss_counter == miss_freq) begin
                cache_miss <= 1;
                miss_counter <= 0;
            end
            else begin
                cache_miss <= 0;
                miss_counter <= miss_counter + 1;
            end
            line <= {addr, 5'b0, 96'hDEAD0000DEAD}; // specifier for odd lines
        end
    end
end
    
endmodule