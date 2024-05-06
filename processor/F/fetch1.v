module fetch_1 (
    input wire clk,
    input wire reset,
    input wire [31:0] init_addr,
    input wire is_init,
    input wire [27:0] BP_FIP_o,
    input wire [27:0] BP_FIP_e,
    input wire is_BR_T_NT,
    input wire [27:0] WB_FIP_o,
    input wire [27:0] WB_FIP_e,
    input wire is_resteer,

    input wire even_latch_was_loaded,
    input wire odd_latch_was_loaded,

    output wire [127:0] line_1_out,
    output wire [127:0] line_2_out,
    output wire [127:0] line_3_out,
    output wire [127:0] line_4_out
    
);

wire cache_miss_even, cache_miss_odd;

// CF priority arbitration
wire [2:0] select_CF_mux;
wire select_CF_mux_0, select_CF_mux_1, select_CF_mux_2;
assign select_CF_mux_2 = is_init;
wire not_is_init;
inv1$ i0(.in(is_init), .out(not_is_init));
andn #(2) a0(.in({not_is_init, is_resteer}), .out(select_CF_mux_1));
wire not_is_resteer;
inv1$ i1(.in(is_resteer), .out(not_is_resteer));
andn #(3) a1(.in({not_is_init, not_is_resteer, is_BR_T_NT}), .out(select_CF_mux_0));
select_CF_mux = {select_CF_mux_2, select_CF_mux_1, select_CF_mux_0};

wire is_CF;
orn #(3) o0(.in({is_init, is_resteer, is_BR_T_NT}), .out(is_CF));

// init FIP addr calculation
wire [27:0] init_FIP_o, init_FIP_e;

wire [31:0] init_addr_plus_1;
kogeAdder #(.WIDTH(32)) a0(.SUM(init_addr_plus_1), .COUT(), .A({init_addr}), .B(32'd16), .CIN(1'b0));

muxnm_tree #(.NUM_INPUTS(2), .DATA_WIDTH(28)) m0(.in({init_addr, init_addr_plus_1}), .sel(init_addr[4]), .out(init_FIP_o));
muxnm_tree #(.NUM_INPUTS(2), .DATA_WIDTH(28)) m1(.in({init_addr_plus_1, init_addr}), .sel(init_addr[4]), .out(init_FIP_e));

// ld_FIP reg even calculation
wire ld_FIP_reg_even;
assign ld_FIP_reg_even = even_latch_was_loaded;

// ld_FIP reg odd calculation
wire ld_FIP_reg_odd;
assign ld_FIP_reg_odd = odd_latch_was_loaded;

wire [27:0] FIP_o_access, FIP_e_access;

select_address_ICache sel_odd(.clk(clk), .init_FIP(init_FIP_o), .BP_FIP(BP_FIP_o), .WB_FIP(WB_FIP_o), .sel_CF(select_CF_mux), .ld_FIP_reg(ld_FIP_reg_odd), 
                                       .clr_FIP_reg(reset), .is_ctrl_flow(is_CF), .addr(FIP_o_access));
select_address_ICache sel_even(.clk(clk), .init_FIP(init_FIP_e), .BP_FIP(BP_FIP_e), .WB_FIP(WB_FIP_e), .sel_CF(select_CF_mux), .ld_FIP_reg(ld_FIP_reg_even), 
                                       .clr_FIP_reg(reset), .is_ctrl_flow(is_CF), .addr(FIP_e_access));


    
endmodule

module select_address_ICache (
   input wire clk,
   input wire [27:0] init_FIP,
   input wire [27:0] BP_FIP,
   input wire [27:0] WB_FIP,
   input wire [2:0] sel_CF,
   input wire ld_FIP_reg,
   input wire clr_FIP_reg,
   input wire is_ctrl_flow,
   output wire [27:0] output_addr
);

wire [27:0] ctrl_flow_addr;
wire [31:0] addr_plus_2;
wire [27:0] FIP_reg_data_out;

muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(28)) m0(.in({init_FIP, WB_FIP, BP_FIP}), .sel(sel_CF), .out(ctrl_flow_addr));
kogeAdder #(.WIDTH(32)) a0(.SUM(addr_plus_2), .COUT(), .A({4'b0000, output_addr}), .B(32'd2), .CIN(1'b0));
regn #(.WIDTH(28)) r0(.din(addr_plus_2[27:0]), .ld(ld_FIP_reg), .clr(clr_FIP_reg), .clk(clk), .dout(FIP_reg_data_out));

muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(28)) m1(.in({ctrl_flow_addr, FIP_reg_data_out}), .sel(is_ctrl_flow), .out(output_addr));
    
endmodule


module I$ (
    
);
    
endmodule