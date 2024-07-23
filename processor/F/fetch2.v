module fetch_2 (
    /////////////////////////////
    //     global signals     //  
    ///////////////////////////
    input wire clk,
    input wire reset,

    /////////////////////////////
    //   signals from IBuf    //  
    ///////////////////////////
    input wire [127:0] line_00,
    input wire line_00_valid,
    input wire [127:0] line_01,
    input wire line_01_valid,
    input wire [127:0] line_10,
    input wire line_10_valid,
    input wire [127:0] line_11,
    input wire line_11_valid,

    /////////////////////////////
    // signals from decode //  
    ///////////////////////////
    input wire [7:0] D_length,
    input stall,

    /////////////////////////////
    // signals from writeback //  
    ///////////////////////////
    input wire [5:0] WB_BIP,
    input wire is_resteer,

    /////////////////////////////
    //    signals from BP     //  
    ///////////////////////////
    input wire [5:0] BP_BIP, //from BTB
    input wire is_BR_T_NT,

    ////////////////////////////
    // signals from init     //  
    ///////////////////////////
    input wire [5:0] init_BIP,
    input wire is_init,

    ////////////////////////////
    // signals from IDTR     //  
    ///////////////////////////

    input wire [127:0] IDTR_packet,
    input wire packet_select,
    input wire WB_IE_val,
    input wire IDTR_LD_info_regs,
    input wire IDTR_invalidate_fetch,

    /////////////////////////////
    //    output signals      //  
    ///////////////////////////
    output wire [127:0] packet_out,
    output wire packet_out_valid,
    output wire [5:0] old_BIP,
    output wire [5:0] new_BIP
);

    wire [2:0] select_CF_mux;

    wire select_CF_mux_0, select_CF_mux_1, select_CF_mux_2;
    assign select_CF_mux_2 = is_init;
    
    wire not_is_init;
    inv1$ i0(.in(is_init), .out(not_is_init));
    andn #(2) a0(.in({not_is_init, is_resteer}), .out(select_CF_mux_1));

    wire not_is_resteer;
    inv1$ i1(.in(is_resteer), .out(not_is_resteer));
    andn #(3) a1(.in({not_is_init, not_is_resteer, is_BR_T_NT}), .out(select_CF_mux_0));

    wire [5:0] CF_BIP;
    muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(6)) m0(
        .in({init_BIP, WB_BIP, BP_BIP}), 
        .sel({select_CF_mux_2, select_CF_mux_1, select_CF_mux_0}), 
        .out(CF_BIP)
    );

    wire is_CF, not_is_CF;
    orn #(3) o0(.in({is_init, is_resteer, is_BR_T_NT}), .out(is_CF));
    inv1$ i2(.in(is_CF), .out(not_is_CF));

    wire [5:0] latched_BIP, mux_BIP_to_load;
    wire [7:0] BIP_plus_length;
    muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(6)) m1(
        .in({BIP_plus_length[5:0], CF_BIP}), 
        .sel({not_is_CF, is_CF}), 
        .out(mux_BIP_to_load)
    );

    wire not_stall, ld_BIP_no_override, ld_BIP;
    inv1$ i3(.in(stall), .out(not_stall));
    wire packet_out_valid_latched;
    wire ld_BIP_override, not_IDTR_invalidate_fetch;
    inv1$ idfsd4(.in(IDTR_invalidate_fetch), .out(not_IDTR_invalidate_fetch));

    andn #(2) asdfs2(.in({is_resteer, not_IDTR_invalidate_fetch}), .out(ld_BIP_override));

    regn #(.WIDTH(1)) scrappy_fix_to_get_delayed_valid_for_decode_so_i_dont_have_to_refactor(.din(packet_out_valid), 
                                                                .ld(not_stall), .clk(clk), .clr(reset), .dout(packet_out_valid_latched));
    
    wire ld_BIP_no_override_not_checking_CF;
    andn #(2) a2(.in({not_stall, packet_out_valid_latched}), .out(ld_BIP_no_override_not_checking_CF));
    orn #(2) jhdkfh(.in({ld_BIP_no_override_not_checking_CF, is_CF}), .out(ld_BIP_no_override));

    orn #(2) sdfo1(.out(ld_BIP), .in({ld_BIP_no_override, ld_BIP_override}));
    
    regn #(.WIDTH(6)) BIP_reg(.din(mux_BIP_to_load), .ld(ld_BIP), .clk(clk), .clr(reset), .dout(latched_BIP));

    kogeAdder #(.WIDTH(8)) a4(.A({2'b0, latched_BIP}), .B({D_length}), .CIN(1'b0), .SUM(BIP_plus_length), .COUT());

    wire fetch_packet_out_valid, packet_out_valid_almost1, packet_out_valid_almost2, packet_out_valid_almost3, IE_val_inv;
    check_valid_rotate cvr(
        .curr_line(BIP_plus_length[5:4]),
        .valid_00(line_00_valid),
        .valid_01(line_01_valid),
        .valid_10(line_10_valid),
        .valid_11(line_11_valid),
        .CF(is_CF),
        .valid_rotate(fetch_packet_out_valid)
    );
    
    inv1$ i1324 (.out(IE_val_inv), .in(WB_IE_val));

    // wire top_byte_is0, top_byte_is_not0;
    // equaln #(8) nibble0 (.a(8'b0), .b(packet_IBuff_out[127:120]), .eq(top_byte_is0));
    // inv1$ i235 (.out(top_byte_is_not0), .in(top_byte_is0));
     
    // wire IDTR_LD_info_regs_inv, IDTR_is_switching, IDTR_is_not_switching;
    // inv1$ i235 (.out(IDTR_LD_info_regs_inv), .in(IDTR_LD_info_regs));
    // andn #(2) a234 (.out(IDTR_is_switching), .in({IDTR_LD_info_regs_inv, WB_IE_val})); //IE seen but IDTR fsm hasn't kicked in yet - ibuff invalid
    // inv1$ i93 (.out(IDTR_is_not_switching), .in(IDTR_is_switching));

    andn #(2) b23r(.out(packet_out_valid_almost1), .in( {fetch_packet_out_valid, IE_val_inv} ));
    or2$ o1243(.out(packet_out_valid_almost2), .in0(packet_out_valid_almost1), .in1(packet_select));
    andn #(2) k23 (.out(packet_out_valid), .in( {packet_out_valid_almost2, IDTR_invalidate_fetch} ));
    // orn #(2) lasjfhl(.out(packet_out_valid), .in({packet_out_valid_almost3, is_resteer})); //for the jump within the switching service routine;

    wire [127:0] line_00_reverse, line_01_reverse, line_10_reverse, line_11_reverse;
    reverse_bit_vector_by_bytes rbv0(.in(line_00), .out(line_00_reverse));
    reverse_bit_vector_by_bytes rbv1(.in(line_01), .out(line_01_reverse));
    reverse_bit_vector_by_bytes rbv2(.in(line_10), .out(line_10_reverse));
    reverse_bit_vector_by_bytes rbv3(.in(line_11), .out(line_11_reverse));

    wire [127:0] packet_IBuff_out;
    rotate_I_Buff rib(
        .line_00_in(line_00_reverse),
        .line_01_in(line_01_reverse),
        .line_10_in(line_10_reverse),
        .line_11_in(line_11_reverse),
        .length_to_rotate(BIP_plus_length[5:0]),
        .line_out(packet_IBuff_out)
    );
    //assign packet_out = packet_IBuff_out;


    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(128)) m2(
        .in({IDTR_packet, packet_IBuff_out}), 
        .sel(packet_select), 
        .out(packet_out)
    );

    assign old_BIP = latched_BIP;
    assign new_BIP = BIP_plus_length[5:0];

    
endmodule

module reverse_bit_vector_by_bytes (
    input wire [127:0] in,
    output wire [127:0] out
);

genvar i;
generate
    for(i = 0; i < 16; i = i + 1)begin
        assign out[8*(i+1)-1:8*i] = in[128-8*i-1:128-8*(i+1)];
    end
endgenerate
    
endmodule

module bit_level_rot (
    input wire [63:0] rot_input,
    input wire [5:0] sel,
    output wire [63:0] rot_output
);

genvar i;
generate // sel 1 takes jump and 0 takes direct output
    wire [63:0] bit0_layer_out0, bit0_layer_out1, bit0_layer_out2, bit0_layer_out3, bit0_layer_out4, bit0_layer_out5;
    for(i = 0; i < 64; i = i + 1)begin
        if((i) < 1)begin
            mux2$ m0(.outb(bit0_layer_out0[i]), .in1(rot_input[64+i-1]), .in0(rot_input[i]), .s0(sel[0]));
        end else begin
            mux2$ m1(.outb(bit0_layer_out0[i]), .in1(rot_input[i-1]), .in0(rot_input[i]), .s0(sel[0]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 2)begin
            mux2$ m2(.outb(bit0_layer_out1[i]), .in1(bit0_layer_out0[64+i-2]), .in0(bit0_layer_out0[i]), .s0(sel[1]));
        end else begin
            mux2$ m3(.outb(bit0_layer_out1[i]), .in1(bit0_layer_out0[i-2]), .in0(bit0_layer_out0[i]), .s0(sel[1]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 4)begin
            mux2$ m4(.outb(bit0_layer_out2[i]), .in1(bit0_layer_out1[64+i-4]), .in0(bit0_layer_out1[i]), .s0(sel[2]));
        end else begin
            mux2$ m5(.outb(bit0_layer_out2[i]), .in1(bit0_layer_out1[i-4]), .in0(bit0_layer_out1[i]), .s0(sel[2]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 8)begin
            mux2$ m6(.outb(bit0_layer_out3[i]), .in1(bit0_layer_out2[64+i-8]), .in0(bit0_layer_out2[i]), .s0(sel[3]));
        end else begin
            mux2$ m7(.outb(bit0_layer_out3[i]), .in1(bit0_layer_out2[i-8]), .in0(bit0_layer_out2[i]), .s0(sel[3]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 16)begin
            mux2$ m8(.outb(bit0_layer_out4[i]), .in1(bit0_layer_out3[64+i-16]), .in0(bit0_layer_out3[i]), .s0(sel[4]));
        end else begin
            mux2$ m9(.outb(bit0_layer_out4[i]), .in1(bit0_layer_out3[i-16]), .in0(bit0_layer_out3[i]), .s0(sel[4]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 32)begin
            mux2$ m10(.outb(bit0_layer_out5[i]), .in1(bit0_layer_out4[64+i-32]), .in0(bit0_layer_out4[i]), .s0(sel[5]));
        end else begin
            mux2$ m11(.outb(bit0_layer_out5[i]), .in1(bit0_layer_out4[i-32]), .in0(bit0_layer_out4[i]), .s0(sel[5]));
        end
    end

    assign rot_output = bit0_layer_out5;
endgenerate
    
endmodule

module rotate_I_Buff (
    input wire [127:0] line_00_in,
    input wire [127:0] line_01_in,
    input wire [127:0] line_10_in,
    input wire [127:0] line_11_in,

    input wire [5:0] length_to_rotate,

    output wire [127:0] line_out
);

wire [511:0] line_concat;
assign line_concat = {line_00_in, line_01_in, line_10_in, line_11_in};

wire [63:0] bit0s, bit1s, bit2s, bit3s, bit4s, bit5s, bit6s, bit7s;
genvar i;
generate
    for(i = 0; i < 64; i = i + 1)begin
        assign bit0s[i] = line_concat[(i*8) + 0];
        assign bit1s[i] = line_concat[(i*8) + 1];
        assign bit2s[i] = line_concat[(i*8) + 2];
        assign bit3s[i] = line_concat[(i*8) + 3];
        assign bit4s[i] = line_concat[(i*8) + 4];
        assign bit5s[i] = line_concat[(i*8) + 5];
        assign bit6s[i] = line_concat[(i*8) + 6];
        assign bit7s[i] = line_concat[(i*8) + 7];
    end
endgenerate

wire [63:0] bit0_rot, bit1_rot, bit2_rot, bit3_rot, bit4_rot, bit5_rot, bit6_rot, bit7_rot;
bit_level_rot b0(.rot_input(bit0s), .sel(length_to_rotate), .rot_output(bit0_rot));
bit_level_rot b1(.rot_input(bit1s), .sel(length_to_rotate), .rot_output(bit1_rot));
bit_level_rot b2(.rot_input(bit2s), .sel(length_to_rotate), .rot_output(bit2_rot));
bit_level_rot b3(.rot_input(bit3s), .sel(length_to_rotate), .rot_output(bit3_rot));
bit_level_rot b4(.rot_input(bit4s), .sel(length_to_rotate), .rot_output(bit4_rot));
bit_level_rot b5(.rot_input(bit5s), .sel(length_to_rotate), .rot_output(bit5_rot));
bit_level_rot b6(.rot_input(bit6s), .sel(length_to_rotate), .rot_output(bit6_rot));
bit_level_rot b7(.rot_input(bit7s), .sel(length_to_rotate), .rot_output(bit7_rot));

genvar j;
generate
    wire [511:0] line_rot_out;
    for(j=0; j < 64; j = j+1)begin
        assign line_rot_out[(j*8) + 7 : (j*8)] = {bit7_rot[j], bit6_rot[j], bit5_rot[j], bit4_rot[j], bit3_rot[j], bit2_rot[j], bit1_rot[j], bit0_rot[j]};
    end
endgenerate

assign line_out = line_rot_out[511:384];



endmodule

module check_valid_rotate (
    input wire [1:0] curr_line,
    input wire valid_00,
    input wire valid_01,
    input wire valid_10,
    input wire valid_11,
    input CF,

    output wire valid_rotate
);

wire not_CF;
inv1$ i0(.in(CF), .out(not_CF));

wire [3:0] check_line, check_line_bar;
decoder2_4$ d0(.SEL(curr_line), .Y(check_line), .YBAR(check_line_bar));

wire valid_rotate_00_01, valid_rotate_01_10, valid_rotate_10_11, valid_rotate_11_00;
andn #(3) a0(.in({check_line[0], valid_00, valid_01}), .out(valid_rotate_00_01));
andn #(3) a1(.in({check_line[1], valid_01, valid_10}), .out(valid_rotate_01_10));
andn #(3) a2(.in({check_line[2], valid_10, valid_11}), .out(valid_rotate_10_11));
andn #(3) a3(.in({check_line[3], valid_11, valid_00}), .out(valid_rotate_11_00));

wire valid_rotate_no_CF;
orn #(4) o0(.in({valid_rotate_00_01, valid_rotate_01_10, valid_rotate_10_11, valid_rotate_11_00}), .out(valid_rotate_no_CF));

andn #(2) a4(.in({not_CF, valid_rotate_no_CF}), .out(valid_rotate));

endmodule