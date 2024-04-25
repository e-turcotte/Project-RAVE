module fetch_2 (
    input wire clk,
    input wire reset,
    input wire [127:0] line_00,
    input wire line_00_valid,
    input wire [127:0] line_01,
    input wire line_01_valid,
    input wire [127:0] line_10,
    input wire line_10_valid,
    input wire [127:0] line_11,
    input wire line_11_valid,

    input wire [7:0] D_length,

    output wire [127:0] packet_out,
    output wire packet_out_valid
);


    
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
            mux2$ m0(.outb(bit0_layer_out0[i]), .in1(rot_input[64-i-1]), .in0(rot_input[i]), .s0(sel[0]));
        end else begin
            mux2$ m1(.outb(bit0_layer_out0[i]), .in1(rot_input[i-1]), .in0(rot_input[i]), .s0(sel[0]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 2)begin
            mux2$ m2(.outb(bit0_layer_out1[i]), .in1(bit0_layer_out0[64-i-2]), .in0(bit0_layer_out0[i]), .s0(sel[1]));
        end else begin
            mux2$ m3(.outb(bit0_layer_out1[i]), .in1(bit0_layer_out0[i-2]), .in0(bit0_layer_out0[i]), .s0(sel[1]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 4)begin
            mux2$ m4(.outb(bit0_layer_out2[i]), .in1(bit0_layer_out1[64-i-4]), .in0(bit0_layer_out1[i]), .s0(sel[2]));
        end else begin
            mux2$ m5(.outb(bit0_layer_out2[i]), .in1(bit0_layer_out1[i-4]), .in0(bit0_layer_out1[i]), .s0(sel[2]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 8)begin
            mux2$ m6(.outb(bit0_layer_out3[i]), .in1(bit0_layer_out2[64-i-8]), .in0(bit0_layer_out2[i]), .s0(sel[3]));
        end else begin
            mux2$ m7(.outb(bit0_layer_out3[i]), .in1(bit0_layer_out2[i-8]), .in0(bit0_layer_out2[i]), .s0(sel[3]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 16)begin
            mux2$ m8(.outb(bit0_layer_out4[i]), .in1(bit0_layer_out3[64-i-16]), .in0(bit0_layer_out3[i]), .s0(sel[4]));
        end else begin
            mux2$ m9(.outb(bit0_layer_out4[i]), .in1(bit0_layer_out3[i-16]), .in0(bit0_layer_out3[i]), .s0(sel[4]));
        end
    end
    for(i = 0; i < 64; i = i + 1)begin
        if((i ) < 32)begin
            mux2$ m10(.outb(bit0_layer_out5[i]), .in1(bit0_layer_out4[64-i-32]), .in0(bit0_layer_out4[i]), .s0(sel[5]));
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

    output wire valid_rotate
);
wire [3:0] check_line, check_line_bar;
decoder2_4$ d0(.SEL(curr_line), .Y(check_line), .YBAR(check_line_bar));

wire valid_rotate_00_01, valid_rotate_01_10, valid_rotate_10_11, valid_rotate_11_00;
andn #(3) a0(.in({check_line[0], valid_00, valid_01}), .out(valid_rotate_00_01));
andn #(3) a1(.in({check_line[1], valid_01, valid_10}), .out(valid_rotate_01_10));
andn #(3) a2(.in({check_line[2], valid_10, valid_11}), .out(valid_rotate_10_11));
andn #(3) a3(.in({check_line[3], valid_11, valid_00}), .out(valid_rotate_11_00));

orn #(4) o0(.in({valid_rotate_00_01, valid_rotate_01_10, valid_rotate_10_11, valid_rotate_11_00}), .out(valid_rotate));

endmodule