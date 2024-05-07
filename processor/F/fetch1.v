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

    output wire [127:0] even_line_out,
    output wire [127:0] odd_line_out,

    output wire cache_miss_even,
    output wire cache_miss_odd,

    output wire [1:0] FIP_o_lsb,
    output wire [1:0] FIP_e_lsb
    
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

assign FIP_o_lsb = FIP_o_access[5:4];
assign FIP_e_lsb = FIP_e_access[5:4];

wire cache_miss_even, cache_miss_odd;
I$ cache(.FIP_o(FIP_o_access), .FIP_e(FIP_e_access), .line_even_out(even_line_out), .cache_miss_even(cache_miss_even), 
            .line_odd_out(odd_line_out), .cache_miss_odd(cache_miss_odd));


    
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
    input wire [27:0] FIP_o,
    input wire [27:0] FIP_e,
    
    output wire [127:0] line_even_out,
    output wire [127:0] line_odd_out,

    output wire cache_miss_even,
    output wire cache_miss_odd
);

wire [31:0] odd_access_address_VA, even_access_address_VA;
assign odd_access_address_VA = {FIP_o[27:0], 4'b0000};
assign even_access_address_VA = {FIP_e[27:0], 4'b0000};
/*FILL OUT THESE SIGNALS*/
TLB tlb_even(
    .clk(/*TODO*/),
    .address(/*TODO*/), //used to lookup
    .RW_in(/*TODO*/),
    .is_mem_request(/*TODO*/), //if 1, then we are doing a memory request, else - no prot exception should be thrown
    .VP(/*TODO*/), //unpacked, do wire concatenation in TOP
    .PF(/*TODO*/),
    .entry_v(/*TODO*/),
    .entry_P(/*TODO*/),
    .entry_RW(/*TODO*/), //read or write (im guessing 0 is read only)
    .entry_PCD(/*TODO*/), //PCD disable - 1 means this entry is disabled for normal mem accesses since it is for MMIO
    .PF_out(/*TODO*/),
    .PCD_out(/*TODO*/),
    .miss(/*TODO*/),
    .hit(/*TODO*/), //if page is valid, present and tag hit - 1 if hit
    .protection_exception(/*TODO*/) //if RW doesn't match entry_RW - 1 if exception
);


cacheBank even(
    .clk(/*TODO*/),
    .rst(/*TODO*/), 
    .set(/*TODO*/),
    .cache_id(/*TODO*/),
    .vAddress(/*TODO*/),
    .pAddress(/*TODO*/),
    .data(/*TODO*/),
    .size(/*TODO*/),
    .r(1'b1),
    .w(/*TODO*/),
    .sw(/*TODO*/),
    .valid_in(1'b1),
    .fromBUS(/*TODO*/), 
    .mask(/*TODO*/),
    .AQ_isEMPTY(1'b0),
    .PTC_ID_IN(/*TODO*/),
    .oddIsGreater_in(/*TODO*/),
    .needP1_in(/*TODO*/),
    .oneSize(/*TODO*/),
    .MSHR_HIT(/*TODO*/),
    .MSHR_FULL(/*TODO*/),
    .SER1_FULL(/*TODO*/),
    .SER0_FULL(/*TODO*/),
    .PCD_IN(/*TODO*/),
    .AQ_READ(/*TODO*/),
    .MSHR_valid(/*TODO*/),
    .MSHR_pAddress(/*TODO*/),
    .SER_valid0(/*TODO*/),
    .SER_data0(/*TODO*/),
    .SER_pAddress0(/*TODO*/),
    .SER_return0(/*TODO*/),
    .SER_size0(/*TODO*/),
    .SER_rw0(/*TODO*/),
    .SER_dest0(/*TODO*/),
    .SER_valid1(/*TODO*/),
    .SER_pAddress1(/*TODO*/),
    .SER_return1(/*TODO*/),
    .SER_size1(/*TODO*/),
    .SER_rw1(/*TODO*/),
    .SER_dest1(/*TODO*/),
    .EX_valid(/*TODO*/),
    .EX_data(/*TODO*/),
    .EX_vAddress(/*TODO*/),
    .EX_pAddress(/*TODO*/),
    .EX_size(/*TODO*/),
    .EX_wake(/*TODO*/),
    .oddIsGreater(/*TODO*/),
    .cache_stall(/*TODO*/),
    .cache_miss(/*TODO*/),
    .needP1(/*TODO*/),
    .oneSize_out(/*TODO*/)
);

TLB tlb_even(
    .clk(/*TODO*/),
    .address(/*TODO*/), //used to lookup
    .RW_in(/*TODO*/),
    .is_mem_request(/*TODO*/), //if 1, then we are doing a memory request, else - no prot exception should be thrown
    .VP(/*TODO*/), //unpacked, do wire concatenation in TOP
    .PF(/*TODO*/),
    .entry_v(/*TODO*/),
    .entry_P(/*TODO*/),
    .entry_RW(/*TODO*/), //read or write (im guessing 0 is read only)
    .entry_PCD(/*TODO*/), //PCD disable - 1 means this entry is disabled for normal mem accesses since it is for MMIO
    .PF_out(/*TODO*/),
    .PCD_out(/*TODO*/),
    .miss(/*TODO*/),
    .hit(/*TODO*/), //if page is valid, present and tag hit - 1 if hit
    .protection_exception(/*TODO*/) //if RW doesn't match entry_RW - 1 if exception
);


cacheBank even(
    .clk(/*TODO*/),
    .rst(/*TODO*/), 
    .set(/*TODO*/),
    .cache_id(/*TODO*/),
    .vAddress(/*TODO*/),
    .pAddress(/*TODO*/),
    .data(/*TODO*/),
    .size(/*TODO*/),
    .r(1'b1),
    .w(/*TODO*/),
    .sw(/*TODO*/),
    .valid_in(1'b1),
    .fromBUS(/*TODO*/), 
    .mask(/*TODO*/),
    .AQ_isEMPTY(1'b0),
    .PTC_ID_IN(/*TODO*/),
    .oddIsGreater_in(/*TODO*/),
    .needP1_in(/*TODO*/),
    .oneSize(/*TODO*/),
    .MSHR_HIT(/*TODO*/),
    .MSHR_FULL(/*TODO*/),
    .SER1_FULL(/*TODO*/),
    .SER0_FULL(/*TODO*/),
    .PCD_IN(/*TODO*/),
    .AQ_READ(/*TODO*/),
    .MSHR_valid(/*TODO*/),
    .MSHR_pAddress(/*TODO*/),
    .SER_valid0(/*TODO*/),
    .SER_data0(/*TODO*/),
    .SER_pAddress0(/*TODO*/),
    .SER_return0(/*TODO*/),
    .SER_size0(/*TODO*/),
    .SER_rw0(/*TODO*/),
    .SER_dest0(/*TODO*/),
    .SER_valid1(/*TODO*/),
    .SER_pAddress1(/*TODO*/),
    .SER_return1(/*TODO*/),
    .SER_size1(/*TODO*/),
    .SER_rw1(/*TODO*/),
    .SER_dest1(/*TODO*/),
    .EX_valid(/*TODO*/),
    .EX_data(/*TODO*/),
    .EX_vAddress(/*TODO*/),
    .EX_pAddress(/*TODO*/),
    .EX_size(/*TODO*/),
    .EX_wake(/*TODO*/),
    .oddIsGreater(/*TODO*/),
    .cache_stall(/*TODO*/),
    .cache_miss(/*TODO*/),
    .needP1(/*TODO*/),
    .oneSize_out(/*TODO*/)
);
    
endmodule