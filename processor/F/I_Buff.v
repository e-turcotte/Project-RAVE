module iBuff_latch (
    input wire clk,
    input wire reset,
    input wire is_BR_T_NT,
    input wire is_resteer,
    input wire is_init,
    input wire [127:0] line_even_fetch1,
    input wire [127:0] line_odd_fetch1,

    input wire [1:0] FIP_o_lsb_fetch1,
    input wire [1:0] FIP_e_lsb_fetch1,

    input wire cache_miss_even_fetch1,
    input wire cache_miss_odd_fetch1,

    input wire evenW_fetch1,
    input wire oddW_fetch1,

    input wire [5:0] new_BIP_fetch2,
    input wire [5:0] old_BIP_fetch2,

    output wire [127:0] line_00,
    output wire line_00_valid,
    output wire [127:0] line_01,
    output wire line_01_valid,
    output wire [127:0] line_10,
    output wire line_10_valid,
    output wire [127:0] line_11,
    output wire line_11_valid,

    output wire even_latch_was_loaded,
    output wire odd_latch_was_loaded

);

wire CF;
orn #(3) o0(.in({is_init, is_resteer, is_BR_T_NT}), .out(CF));

wire [1:0] num_lines_to_ld_reg_out;
wire ld_reg;
nor2$ n0(.out(ld_reg), .in0(cache_miss_even_fetch1), .in1(cache_miss_odd_fetch1));
loadStateReg r0(.clk(clk), .reset(reset), .CF(CF), .ld_reg(ld_reg), .v_00(line_00_valid), .v_01(line_01_valid), .v_10(line_10_valid), .v_11(line_11_valid), 
                    .num_lines_to_ld(num_lines_to_ld_reg_out));

wire invalidate_line_00, invalidate_line_01, invalidate_line_10, invalidate_line_11;
wire ld_0, ld_1, ld_2, ld_3;
ld_selector l0(.num_lines_to_ld_in(num_lines_to_ld_reg_out), .FIP_o(FIP_o_lsb_fetch1), .FIP_e(FIP_e_lsb_fetch1), .cache_miss_even(cache_miss_even_fetch1), 
                .cache_miss_odd(cache_miss_odd_fetch1), .evenW(evenW_fetch1), .oddW(oddW_fetch1), .invalidate_line_00(invalidate_line_00), 
                .invalidate_line_01(invalidate_line_01), .invalidate_line_10(invalidate_line_10), .invalidate_line_11(invalidate_line_11), 
                .ld_0(ld_0), .ld_1(ld_1), .ld_2(ld_2), .ld_3(ld_3));
orn #(2) o1123124(.out(even_latch_was_loaded), .in({ld_0, ld_2}));
orn #(2) o1123125(.out(odd_latch_was_loaded), .in({ld_1, ld_3}));

invalidate_selector i0(.new_BIP(new_BIP_fetch2), .old_BIP(old_BIP_fetch2), .invalidate_line_00(invalidate_line_00), .invalidate_line_01(invalidate_line_01), 
                        .invalidate_line_10(invalidate_line_10), .invalidate_line_11(invalidate_line_11));

//maybe or the clr signal for each of the lines and valid bits with the reset and invalidate signals

wire valid_00_in, valid_01_in, valid_10_in, valid_11_in;
muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m0(.in({1'b0, 1'b1}), .sel(invalidate_line_00), .out(valid_00_in));
muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m1(.in({1'b0, 1'b1}), .sel(invalidate_line_01), .out(valid_01_in));
muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m2(.in({1'b0, 1'b1}), .sel(invalidate_line_10), .out(valid_10_in));
muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m3(.in({1'b0, 1'b1}), .sel(invalidate_line_11), .out(valid_11_in));


regn #(.WIDTH(1)) valid1(.din(valid_00_in), .ld(ld_0), .clr(reset), .clk(clk), .dout(line_00_valid));
regn #(.WIDTH(128)) line1(.din(line_even_fetch1), .ld(ld_0), .clr(reset), .clk(clk), .dout(line_00));

//line01
regn #(.WIDTH(1)) valid2(.din(valid_01_in), .ld(ld_1), .clr(reset), .clk(clk), .dout(line_01_valid));
regn #(.WIDTH(128)) line2(.din(line_odd_fetch1), .ld(ld_1), .clr(reset), .clk(clk), .dout(line_01));

//line10
regn #(.WIDTH(1)) valid3(.din(valid_10_in), .ld(ld_2), .clr(reset), .clk(clk), .dout(line_10_valid));
regn #(.WIDTH(128)) line3(.din(line_even_fetch1), .ld(ld_2), .clr(reset), .clk(clk), .dout(line_10));

//line11
regn #(.WIDTH(1)) valid4(.din(valid_11_in), .ld(ld_3), .clr(reset), .clk(clk), .dout(line_11_valid));
regn #(.WIDTH(128)) line4(.din(line_odd_fetch1), .ld(ld_3), .clr(reset), .clk(clk), .dout(line_11));

    
endmodule

module loadStateReg (
    input wire clk,
    input wire reset,
    input wire CF,
    input wire ld_reg,
    input wire v_00,
    input wire v_01,
    input wire v_10,
    input wire v_11,

    output wire [1:0] num_lines_to_ld
);

wire move_to_even, move_to_odd, move_to_both; // 1.0 ns to get these
next_num_Cache_line_to_load n0(.v_00(v_00), .v_01(v_01), .v_10(v_10), .v_11(v_11), .move_to_even(move_to_even), 
                                .move_to_odd(move_to_odd), .move_to_both(move_to_both));

wire S1, S0; // 1.0 + 0.40 = 1.4 ns to get these

orn #(3) o0(.in({CF, move_to_both, move_to_even}), .out(S1));
orn #(3) o1(.in({CF, move_to_both, move_to_odd}), .out(S0));

wire [1:0] reg_out;
regn #(.WIDTH(2)) r0(.din({S1,S0}), .ld(ld_reg), .clr(reset), .clk(clk), .dout(reg_out));

wire not_CF;
inv1$ i0(.out(not_CF), .in(CF));
muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(2)) m0(.in({reg_out, 2'b11}), .sel({not_CF, CF}), .out(num_lines_to_ld));


endmodule

module invalidate_selector (
    input wire [5:0] new_BIP,
    input wire [5:0] old_BIP,

    output wire invalidate_line_00,
    output wire invalidate_line_01,
    output wire invalidate_line_10,
    output wire invalidate_line_11
);

wire [7:0] new_buff_offset, old_buff_offset;
assign new_buff_offset = {4'b0000, new_BIP[3:0]};
assign old_buff_offset = {4'b0000, old_BIP[3:0]};

wire crossed_boundary;
mag_comp8$ m0(.A(new_buff_offset), .B(old_buff_offset), .AGB(), .BGA(crossed_boundary));

wire [3:0] check_line, check_line_bar;
decoder2_4$ d0(.SEL(old_BIP[5:4]), .Y(check_line), .YBAR(check_line_bar));

andn #(2) a0(.in({crossed_boundary, check_line[0]}), .out(invalidate_line_00));
andn #(2) a1(.in({crossed_boundary, check_line[1]}), .out(invalidate_line_01));
andn #(2) a2(.in({crossed_boundary, check_line[2]}), .out(invalidate_line_10));
andn #(2) a3(.in({crossed_boundary, check_line[3]}), .out(invalidate_line_11));

endmodule

module ld_selector (
    input wire [1:0] num_lines_to_ld_in,
    input wire [1:0] FIP_o,
    input wire [1:0] FIP_e,
    input wire cache_miss_even,
    input wire cache_miss_odd,
    input wire evenW,
    input wire oddW,
    input wire invalidate_line_00,
    input wire invalidate_line_01,
    input wire invalidate_line_10,
    input wire invalidate_line_11,

    output wire ld_0,
    output wire ld_1,
    output wire ld_2,
    output wire ld_3
);

wire [3:0] check_line_o, check_line_o_bar;
wire check_line_00_o, check_line_01_o, check_line_10_o, check_line_11_o;
decoder2_4$ d1(.SEL(FIP_o), .Y(check_line_o), .YBAR(check_line_o_bar));
assign check_line_00_o = check_line_o[0]; // this should always be 0
assign check_line_01_o = check_line_o[1]; 
assign check_line_10_o = check_line_o[2]; // this should always be 0
assign check_line_11_o = check_line_o[3]; 

wire [3:0] check_line_e, check_line_e_bar;
wire check_line_00_e, check_line_01_e, check_line_10_e, check_line_11_e;
decoder2_4$ d2(.SEL(FIP_e), .Y(check_line_e), .YBAR(check_line_e_bar));
assign check_line_00_e = check_line_e[0]; 
assign check_line_01_e = check_line_e[1]; // this should always be 0
assign check_line_10_e = check_line_e[2]; 
assign check_line_11_e = check_line_e[3]; // this should always be 0

wire [3:0] num_lines_to_ld_out;
wire even, odd;
wire both;
wire both_00_01, both_01_10, both_10_11, both_11_00;
wire even_00, even_10, odd_01, odd_11;

decodern #(.INPUT_WIDTH(2)) d(.in(num_lines_to_ld_in), .out(num_lines_to_ld_out));
assign even = num_lines_to_ld_out[2];
assign odd = num_lines_to_ld_out[1];
assign both = num_lines_to_ld_out[3];

andn #(3) a0(.in({both, check_line_00_e, check_line_01_o}), .out(both_00_01));
andn #(3) a1(.in({both, check_line_01_o, check_line_10_e}), .out(both_01_10));
andn #(3) a2(.in({both, check_line_10_e, check_line_11_o}), .out(both_10_11));
andn #(3) a3(.in({both, check_line_11_o, check_line_00_e}), .out(both_11_00));

andn #(2) a4(.in({even, check_line_00_e}), .out(even_00));
andn #(2) a5(.in({odd, check_line_01_o}), .out(odd_01));
andn #(2) a6(.in({even, check_line_10_e}), .out(even_10));
andn #(2) a7(.in({odd, check_line_11_o}), .out(odd_11));

wire ld_no_check_00, ld_no_check_01, ld_no_check_10, ld_no_check_11;
orn #(3) o0(.in({even_00, both_00_01, both_11_00}), .out(ld_no_check_00));
orn #(3) o1(.in({odd_01, both_00_01, both_01_10}), .out(ld_no_check_01));
orn #(3) o2(.in({even_10, both_01_10, both_10_11}), .out(ld_no_check_10));
orn #(3) o3(.in({odd_11, both_10_11, both_11_00}), .out(ld_no_check_11));

wire ld_nothing;
inv1$ i4(.out(ld_nothing), .in(num_lines_to_ld_out[0]));

wire not_cache_miss_even, not_cache_miss_odd;
inv1$ i5(.out(not_cache_miss_even), .in(cache_miss_even));
inv1$ i6(.out(not_cache_miss_odd), .in(cache_miss_odd));

wire not_evenW, not_oddW;
inv1$ i7(.out(not_evenW), .in(evenW));
inv1$ i8(.out(not_oddW), .in(oddW));

wire ld_0_no_invalid, ld_1_no_invalid, ld_2_no_invalid, ld_3_no_invalid;
andn #(4) a8(.in({ld_no_check_00, ld_nothing, not_cache_miss_even, not_evenW}), .out(ld_0_no_invalid));
andn #(4) a9(.in({ld_no_check_01, ld_nothing, not_cache_miss_odd, not_oddW}), .out(ld_1_no_invalid));
andn #(4) a10(.in({ld_no_check_10, ld_nothing, not_cache_miss_even, not_evenW}), .out(ld_2_no_invalid));
andn #(4) a11(.in({ld_no_check_11, ld_nothing, not_cache_miss_odd, not_oddW}), .out(ld_3_no_invalid));

orn #(2) o4(.out(ld_0), .in({ld_0_no_invalid, invalidate_line_00}));
orn #(2) o5(.out(ld_1), .in({ld_1_no_invalid, invalidate_line_01}));
orn #(2) o6(.out(ld_2), .in({ld_2_no_invalid, invalidate_line_10}));
orn #(2) o7(.out(ld_3), .in({ld_3_no_invalid, invalidate_line_11}));


endmodule

module next_num_Cache_line_to_load ( // total prob somewhere less than 1.0 ns for this module
    input wire v_00,
    input wire v_01,
    input wire v_10,
    input wire v_11,

    output wire move_to_even,
    output wire move_to_odd,
    output wire move_to_both
);

wire not_v_00, not_v_01, not_v_10, not_v_11; // 0.15 to get each of these
inv1$ i0(.out(not_v_00), .in(v_00));
inv1$ i1(.out(not_v_01), .in(v_01));
inv1$ i2(.out(not_v_10), .in(v_10));
inv1$ i3(.out(not_v_11), .in(v_11));

wire any_evens_avail, any_odds_avail; // 0.15 + 0.35 = 0.5 for each of these
orn #(2) o0(.in({not_v_00, not_v_10}), .out(any_evens_avail));
orn #(2) o1(.in({not_v_01, not_v_11}), .out(any_odds_avail));

wire all_odds_not_avail, all_evens_not_avail; // 0.5 + 0.4 for each of these
andn #(3) a0(.in({v_00, v_10, any_evens_avail}), .out(move_to_even));
andn #(3) a1(.in({v_01, v_11, any_odds_avail}), .out(move_to_odd));

wire buff_00_01, buff_01_10, buff_10_11, buff_11_00; // 0.15 + 0.35 = 0.5 for each of these
andn #(2) a4(.in({not_v_00, not_v_01}), .out(buff_00_01));
andn #(2) a5(.in({not_v_01, not_v_10}), .out(buff_01_10));
andn #(2) a6(.in({not_v_10, not_v_11}), .out(buff_10_11));
andn #(2) a7(.in({not_v_11, not_v_00}), .out(buff_11_00));

//prob < 0.5 + 0.5 for this
orn #(4) o2(.in({buff_00_01, buff_01_10, buff_10_11, buff_11_00}), .out(move_to_both));

  
endmodule