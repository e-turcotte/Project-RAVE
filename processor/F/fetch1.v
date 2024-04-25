module fetch_1 (
    input wire clk,
    input wire [31:0] init_addr,
    input wire [31:0] resteer_addr,
    input wire [31:0] D_EIP,
    input wire is_resteer,
    input wire is_init,

    input wire v_00_in,
    input wire v_01_in,
    input wire v_10_in,
    input wire v_11_in,

    output wire [127:0] line_1_out,
    output wire [127:0] line_2_out,
    output wire [127:0] line_3_out,
    output wire [127:0] line_4_out,
    

);

wire BR_hit;
wire [27:0] BP_FIP_o, BP_FIP_e;
wire [127:0] odd_line_out, even_line_out;

wire cache_miss_even, cache_miss_odd;



select_address_ICache select_address_ICache0(.clk(clk), .init(), .BP(BP_FIP_o), .resteer(), .sel_CF(sel_CF), .ld_FIP_reg(ld_FIP_reg), 
                                        .clr_FIP_reg(clr_FIP_reg), .is_ctrl_flow(is_ctrl_flow), .addr());
select_address_ICache select_address_ICache1(.clk(clk), .init(), .BP(BP_FIP_e), .resteer(), .sel_CF(sel_CF), .ld_FIP_reg(ld_FIP_reg), 
                                        .clr_FIP_reg(clr_FIP_reg), .is_ctrl_flow(is_ctrl_flow), .addr());

ICache ICache0(.clk(clk), .FIP_o(), .FIP_e(), .even_OE(), .odd_OE(), .cache_miss_even(cache_miss_even), .cache_miss_odd(cache_miss_odd), .odd_line(odd_line_out), .even_line(even_line_out));




                    
    
endmodule

module select_address_ICache (
    input wire clk,
    input wire [27:0] init,
    input wire [27:0] BP,
    input wire [27:0] resteer,
    input wire [2:0] sel_CF,
    input wire ld_FIP_reg,
    input wire clr_FIP_reg,
    input wire [1:0] is_ctrl_flow,
    output wire [27:0] addr
);

wire [27:0] ctrl_flow_addr;
wire [31:0] FIP_reg_data_out, FIP_reg_data_in;

muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(28)) m0(.in({init, BP, resteer}), .sel(sel_CF), .out(ctrl_flow_addr));
kogeAdder #(.WIDTH(32)) a0(.SUM(FIP_reg_data_in), .COUT(), .A({4'b0, addr}), .B(32'b10), .CIN(1'b0)); // for COUT to be anything other than 0 that means the address overflowed which should be an exception right?
regn #(.WIDTH(32)) r0(.din(FIP_reg_data_in), .ld(ld_FIP_reg), .clr(clr_FIP_reg), .clk(clk), .dout(FIP_reg_data_out));

muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(32)) m1(.in({FIP_reg_data_out[27:0], ctrl_flow_addr}), .sel(is_ctrl_flow), .out(addr));
    
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