module addressing_decode (
    input wire [7:0] packet1,
    input wire [7:0] packet2,
    input wire [7:0] packet3,
    input wire [7:0] packet4,
    input wire [7:0] packet5,
    input wire [7:0] packet6,
    input wire isMod,

    input wire [3:0] num_prefixes_onehot,
    input wire isDoubleOp,
    input wire is_opsize_override,

    output wire [5:0] length_of_mod_sib_disp,
    output wire [3:0] disp_size,
    output wire [2:0] R2_override_val,
    output wire use_R2,
    output wire [1:0] shift_R3_amount,
    output wire [2:0] R3_override_val,
    output wire use_R3,
    output wire isSIB
);

    wire [2:0] R2_override_val_1, R3_override_val_1;
    wire use_R2_1, use_R3_1;
    wire [1:0] shift_R3_amount_1;
    wire [5:0] length_of_everything_mod_and_after_1;
    wire [3:0] length_of_disp_1;
    wire is_SIB_1;

    mod m0(
        .modrm_byte(packet1),
        .sib_byte(packet2),
        .is_opsize_override(is_opsize_override),
        .isMod(isMod),

        .R2_override_val(R2_override_val_1),
        .R3_override_val(R3_override_val_1),
        .use_R2(use_R2_1),
        .use_R3(use_R3_1),
        .shift_R3_amount(shift_R3_amount_1),
        .length_of_everything_mod_and_after(length_of_everything_mod_and_after_1),
        .length_of_disp(length_of_disp_1),
        .is_SIB(is_SIB_1)
    );

    wire [20:0] data1_concat;
    assign data1_concat = {R2_override_val_1, R3_override_val_1, use_R2_1, use_R3_1, shift_R3_amount_1, length_of_everything_mod_and_after_1, length_of_disp_1, is_SIB_1};

    wire [2:0] R2_override_val_2, R3_override_val_2;
    wire use_R2_2, use_R3_2;
    wire [1:0] shift_R3_amount_2;
    wire [5:0] length_of_everything_mod_and_after_2;
    wire [3:0] length_of_disp_2;
    wire is_SIB_2;

    mod m1(
        .modrm_byte(packet2),
        .sib_byte(packet3),
        .is_opsize_override(is_opsize_override),
        .isMod(isMod),

        .R2_override_val(R2_override_val_2),
        .R3_override_val(R3_override_val_2),
        .use_R2(use_R2_2),
        .use_R3(use_R3_2),
        .shift_R3_amount(shift_R3_amount_2),
        .length_of_everything_mod_and_after(length_of_everything_mod_and_after_2),
        .length_of_disp(length_of_disp_2),
        .is_SIB(is_SIB_2)
    );

    wire [20:0] data2_concat;
    assign data2_concat = {R2_override_val_2, R3_override_val_2, use_R2_2, use_R3_2, shift_R3_amount_2, length_of_everything_mod_and_after_2, length_of_disp_2, is_SIB_2};

    wire [2:0] R2_override_val_3, R3_override_val_3;
    wire use_R2_3, use_R3_3;
    wire [1:0] shift_R3_amount_3;
    wire [5:0] length_of_everything_mod_and_after_3;
    wire [3:0] length_of_disp_3;
    wire is_SIB_3;
    
    mod m2(
        .modrm_byte(packet3),
        .sib_byte(packet4),
        .is_opsize_override(is_opsize_override),
        .isMod(isMod),

        .R2_override_val(R2_override_val_3),
        .R3_override_val(R3_override_val_3),
        .use_R2(use_R2_3),
        .use_R3(use_R3_3),
        .shift_R3_amount(shift_R3_amount_3),
        .length_of_everything_mod_and_after(length_of_everything_mod_and_after_3),
        .length_of_disp(length_of_disp_3),
        .is_SIB(is_SIB_3)
    );

    wire [20:0] data3_concat;
    assign data3_concat = {R2_override_val_3, R3_override_val_3, use_R2_3, use_R3_3, shift_R3_amount_3, length_of_everything_mod_and_after_3, length_of_disp_3, is_SIB_3};

    wire [2:0] R2_override_val_4, R3_override_val_4;
    wire use_R2_4, use_R3_4;
    wire [1:0] shift_R3_amount_4;
    wire [5:0] length_of_everything_mod_and_after_4;
    wire [3:0] length_of_disp_4;
    wire is_SIB_4;

    mod m3(
        .modrm_byte(packet4),
        .sib_byte(packet5),
        .is_opsize_override(is_opsize_override),
        .isMod(isMod),

        .R2_override_val(R2_override_val_4),
        .R3_override_val(R3_override_val_4),
        .use_R2(use_R2_4),
        .use_R3(use_R3_4),
        .shift_R3_amount(shift_R3_amount_4),
        .length_of_everything_mod_and_after(length_of_everything_mod_and_after_4),
        .length_of_disp(length_of_disp_4),
        .is_SIB(is_SIB_4)
    );

    wire [20:0] data4_concat;
    assign data4_concat = {R2_override_val_4, R3_override_val_4, use_R2_4, use_R3_4, shift_R3_amount_4, length_of_everything_mod_and_after_4, length_of_disp_4, is_SIB_4};

    wire [2:0] R2_override_val_5, R3_override_val_5;
    wire use_R2_5, use_R3_5;
    wire [1:0] shift_R3_amount_5;
    wire [5:0] length_of_everything_mod_and_after_5;
    wire [3:0] length_of_disp_5;
    wire is_SIB_5;

    mod m4(
        .modrm_byte(packet5),
        .sib_byte(packet6),
        .is_opsize_override(is_opsize_override),
        .isMod(isMod),

        .R2_override_val(R2_override_val_5),
        .R3_override_val(R3_override_val_5),
        .use_R2(use_R2_5),
        .use_R3(use_R3_5),
        .shift_R3_amount(shift_R3_amount_5),
        .length_of_everything_mod_and_after(length_of_everything_mod_and_after_5),
        .length_of_disp(length_of_disp_5),
        .is_SIB(is_SIB_5)
    );

    wire [20:0] data5_concat;
    assign data5_concat = {R2_override_val_5, R3_override_val_5, use_R2_5, use_R3_5, shift_R3_amount_5, length_of_everything_mod_and_after_5, length_of_disp_5, is_SIB_5};

    wire [20:0] data_sel_no_double;
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(21)) muxeewee(.in({data4_concat, data3_concat, data2_concat, data1_concat}), .sel(num_prefixes_onehot), .out(data_sel_no_double));

    wire [20:0] data_sel_double;
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(21)) muxeewee2(.in({data5_concat, data4_concat, data3_concat, data2_concat}), .sel(num_prefixes_onehot), .out(data_sel_double));

    wire [20:0] data_sel;
    muxnm_tree #(1, 21) muxeewee3(.in({data_sel_double, data_sel_no_double}), .sel(isDoubleOp), .out(data_sel));

    //assign all the output values
    assign length_of_mod_sib_disp = data_sel[10:5];
    assign disp_size = data_sel[4:1];
    assign R2_override_val = data_sel[20:18];
    assign use_R2 = data_sel[14];
    assign R3_override_val = data_sel[17:15];
    assign use_R3 = data_sel[13];
    assign shift_R3_amount = data_sel[12:11];
    assign isSIB = data_sel[0];
  


endmodule

module mod (
    input wire [7:0] modrm_byte,
    input wire [7:0] sib_byte,
    input wire is_opsize_override,
    input wire isMod,

    output wire [2:0] R2_override_val,
    output wire [2:0] R3_override_val,
    output wire use_R2,
    output wire use_R3,
    output wire [1:0] shift_R3_amount,
    output wire [5:0] length_of_everything_mod_and_after,
    output wire [3:0] length_of_disp,
    output wire is_SIB

);

wire [1:0] mod;
wire [2:0] rm;
wire [1:0] scale;
wire [2:0] index;
wire [2:0] base;

assign mod = modrm_byte[7:6];
assign rm = modrm_byte[2:0];
assign scale = sib_byte[7:6];
assign index = sib_byte[5:3];
assign base = sib_byte[2:0];

//if mod equal to 00
wire [1:0] mod_equal_00_check;
wire mod_equal_00;
inv1$ i0(.in(mod[1]), .out(mod_equal_00_check[1]));
inv1$ i1(.in(mod[0]), .out(mod_equal_00_check[0]));
andn #(2) a0(.in({mod_equal_00_check[1], mod_equal_00_check[0]}), .out(mod_equal_00));

//if mod equal to 01
wire [1:0] mod_equal_01_check;
wire mod_equal_01;
inv1$ i2(.in(mod[1]), .out(mod_equal_01_check[1]));
assign mod_equal_01_check[0] = mod[0];
andn #(2) a1(.in({mod_equal_01_check[1], mod_equal_01_check[0]}), .out(mod_equal_01));

//if mod equal to 10
wire [1:0] mod_equal_10_check;
wire mod_equal_10;
assign mod_equal_10_check[1] = mod[1];
inv1$ i3(.in(mod[0]), .out(mod_equal_10_check[0]));
andn #(2) a2(.in({mod_equal_10_check[1], mod_equal_10_check[0]}), .out(mod_equal_10));

//if mod equal to 11
wire [1:0] mod_equal_11_check;
wire mod_equal_11;
assign mod_equal_11_check[1] = mod[1];
assign mod_equal_11_check[0] = mod[0];
andn #(2) a3(.in({mod_equal_11_check[1], mod_equal_11_check[0]}), .out(mod_equal_11));

//if mod not equal to 11
wire mod_not_equal_11;
inv1$ i4(.in(mod_equal_11), .out(mod_not_equal_11));

//if rm equal to 100
wire [2:0] rm_equal_100_check;
wire rm_equal_100;
assign rm_equal_100_check[2] = rm[2];
inv1$ i5(.in(rm[1]), .out(rm_equal_100_check[1]));
inv1$ i6(.in(rm[0]), .out(rm_equal_100_check[0]));
andn #(3) a4(.in({rm_equal_100_check[2], rm_equal_100_check[1], rm_equal_100_check[0]}), .out(rm_equal_100));

//if rm equal to 101
wire [2:0] rm_equal_101_check;
wire rm_equal_101;
assign rm_equal_101_check[2] = rm[2];
inv1$ i7(.in(rm[1]), .out(rm_equal_101_check[1]));
assign rm_equal_101_check[0] = rm[0];
andn #(3) a5(.in({rm_equal_101_check[2], rm_equal_101_check[1], rm_equal_101_check[0]}), .out(rm_equal_101));

//if rm equal to 110
wire [2:0] rm_equal_110_check;
wire rm_equal_110;
assign rm_equal_110_check[2] = rm[2];
assign rm_equal_110_check[1] = rm[1];
inv1$ i8(.in(rm[0]), .out(rm_equal_110_check[0]));
andn #(3) a67812936917(.in({rm_equal_110_check[2], rm_equal_110_check[1], rm_equal_110_check[0]}), .out(rm_equal_110));

// if rm equal to 111
wire [2:0] rm_equal_111_check;
wire rm_equal_111;
assign rm_equal_111_check[2] = rm[2];
assign rm_equal_111_check[1] = rm[1];
assign rm_equal_111_check[0] = rm[0];
andn #(3) a67812936918(.in({rm_equal_111_check[2], rm_equal_111_check[1], rm_equal_111_check[0]}), .out(rm_equal_111));

//isSIB?
wire isSIB;
andn #(3) a6(.in({mod_not_equal_11, rm_equal_100, isMod}), .out(isSIB));

//length_of_everything_mod_and_after

//32 bit mode
// wire w32_bit_mode;
// inv1$ mybrotherinchrist(.in(is_opsize_override), .out(w32_bit_mode));
wire w32_bit_length_of_everything_mod_and_after_bit_5, w32_bit_length_of_everything_mod_and_after_bit_4, 
        w32_bit_length_of_everything_mod_and_after_bit_3, w32_bit_length_of_everything_mod_and_after_bit_2, 
        w32_bit_length_of_everything_mod_and_after_bit_1, w32_bit_length_of_everything_mod_and_after_bit_0;
//assign 0 length
wire no_mod;
inv1$ imgonnatouchyoulittlebro(.in(isMod), .out(no_mod));
assign w32_bit_length_of_everything_mod_and_after_bit_0 = no_mod;

//assign 1 length
wire rm_not_equal_100, rm_not_equal_101;
wire temp0, temp1;
inv1$ i9(.in(rm_equal_100), .out(rm_not_equal_100));
inv1$ i10(.in(rm_equal_101), .out(rm_not_equal_101));
andn #(4) a7(.in({mod_equal_00, rm_not_equal_100, rm_not_equal_101, isMod}), .out(temp0));
andn #(2) a8(.in({mod_equal_11, isMod}), .out(temp1));
orn #(2) o0(.in({temp0, temp1}), .out(w32_bit_length_of_everything_mod_and_after_bit_1));

//assign 2 length
wire not_SIB;
inv1$ i11(.in(isSIB), .out(not_SIB));
wire temp2, temp3;
andn #(3) a9(.in({mod_equal_01, not_SIB, isMod}), .out(temp2));
andn #(3) a10(.in({mod_equal_00, isSIB, isMod}), .out(temp3));
orn #(2) o1(.in({temp2, temp3}), .out(w32_bit_length_of_everything_mod_and_after_bit_2));

//assign 3 length
andn #(3) a11(.in({mod_equal_01, isSIB, isMod}), .out(w32_bit_length_of_everything_mod_and_after_bit_3));

//assign 5 length
wire temp4, temp5;
andn #(3) a12(.in({mod_equal_00, rm_equal_101, isMod}), .out(temp4));
andn #(3) a13(.in({mod_equal_10, not_SIB, isMod}), .out(temp5));
orn #(2) o2(.in({temp4, temp5}), .out(w32_bit_length_of_everything_mod_and_after_bit_4));

//assign 6 length
andn #(3) a14(.in({mod_equal_10, rm_equal_100, isMod}), .out(w32_bit_length_of_everything_mod_and_after_bit_5));


// //16 bit mode
// wire w16_bit_mode;
// assign w16_bit_mode = is_opsize_override;
// wire w16_bit_length_of_everything_mod_and_after_bit_5, w16_bit_length_of_everything_mod_and_after_bit_4, 
//         w16_bit_length_of_everything_mod_and_after_bit_3, w16_bit_length_of_everything_mod_and_after_bit_2, 
//         w16_bit_length_of_everything_mod_and_after_bit_1, w16_bit_length_of_everything_mod_and_after_bit_0;

// //assign 0 length
// assign w16_bit_length_of_everything_mod_and_after_bit_0 = no_mod;

// //assign 1 length
// wire temp6, temp7;
// wire rm_not_equal_110;
// inv1$ i12(.in(rm_equal_110), .out(rm_not_equal_110));
// andn #(4) a15(.in({mod_equal_00, rm_not_equal_110, isMod, w16_bit_mode}), .out(temp6));
// andn #(3) a16(.in({mod_equal_11, isMod, w16_bit_mode}), .out(temp7));
// orn #(2) o3(.in({temp6, temp7}), .out(w16_bit_length_of_everything_mod_and_after_bit_1));

// //assign 2 length
// andn #(3) a17(.in({mod_equal_01, isMod, w16_bit_mode}), .out(w16_bit_length_of_everything_mod_and_after_bit_2));

// //assign 3 length
// wire temp8, temp9;
// andn #(4) a18(.in({mod_equal_00, rm_equal_110, isMod, w16_bit_mode}), .out(temp8));
// andn #(3) a18788(.in({mod_equal_10, isMod, w16_bit_mode}), .out(temp9));
// orn #(2) o4(.in({temp8, temp9}), .out(w16_bit_length_of_everything_mod_and_after_bit_3));

// //assign 5 length
// assign w16_bit_length_of_everything_mod_and_after_bit_4 = 1'b0;

// //assign 6 length
// assign w16_bit_length_of_everything_mod_and_after_bit_5 = 1'b0;

//combine the 16 and 32 bit versions
// orn #(2) o5(.in({w16_bit_length_of_everything_mod_and_after_bit_0, w32_bit_length_of_everything_mod_and_after_bit_0}), .out(length_of_everything_mod_and_after[0]));
// orn #(2) o6(.in({w16_bit_length_of_everything_mod_and_after_bit_1, w32_bit_length_of_everything_mod_and_after_bit_1}), .out(length_of_everything_mod_and_after[1]));
// orn #(2) o7(.in({w16_bit_length_of_everything_mod_and_after_bit_2, w32_bit_length_of_everything_mod_and_after_bit_2}), .out(length_of_everything_mod_and_after[2]));
// orn #(2) o8(.in({w16_bit_length_of_everything_mod_and_after_bit_3, w32_bit_length_of_everything_mod_and_after_bit_3}), .out(length_of_everything_mod_and_after[3]));
// orn #(2) o9(.in({w16_bit_length_of_everything_mod_and_after_bit_4, w32_bit_length_of_everything_mod_and_after_bit_4}), .out(length_of_everything_mod_and_after[4]));
// orn #(2) o10(.in({w16_bit_length_of_everything_mod_and_after_bit_5, w32_bit_length_of_everything_mod_and_after_bit_5}), .out(length_of_everything_mod_and_after[5]));
assign length_of_everything_mod_and_after[0] = w32_bit_length_of_everything_mod_and_after_bit_0;
assign length_of_everything_mod_and_after[1] = w32_bit_length_of_everything_mod_and_after_bit_1;
assign length_of_everything_mod_and_after[2] = w32_bit_length_of_everything_mod_and_after_bit_2;
assign length_of_everything_mod_and_after[3] = w32_bit_length_of_everything_mod_and_after_bit_3;
assign length_of_everything_mod_and_after[4] = w32_bit_length_of_everything_mod_and_after_bit_4;
assign length_of_everything_mod_and_after[5] = w32_bit_length_of_everything_mod_and_after_bit_5;

//length_of_disp
//32 bit mode
wire w32_bit_length_of_disp_bit_3, w32_bit_length_of_disp_bit_2, w32_bit_length_of_disp_bit_1, w32_bit_length_of_disp_bit_0;
//assign 0 length
wire temp10, temp11;
andn #(3) a19(.in({mod_equal_00, rm_not_equal_101, isMod}), .out(temp10));
andn #(2) a20(.in({mod_equal_11, isMod}), .out(temp11));
orn #(3) o11(.in({temp10, temp11, no_mod}), .out(w32_bit_length_of_disp_bit_0));

//assign 1 length
andn #(2) a21(.in({mod_equal_01, isMod}), .out(w32_bit_length_of_disp_bit_1));

//assign 2 length
assign w32_bit_length_of_disp_bit_2 = 1'b0;

//assign 3 length
wire temp12, temp13;
andn #(3) a22(.in({mod_equal_00, rm_equal_101, isMod}), .out(temp12));
andn #(2) a23(.in({mod_equal_10, isMod}), .out(temp13));
orn #(2) o12(.in({temp12, temp13}), .out(w32_bit_length_of_disp_bit_3));

// //16 bit mode
// wire w16_bit_length_of_disp_bit_3, w16_bit_length_of_disp_bit_2, w16_bit_length_of_disp_bit_1, w16_bit_length_of_disp_bit_0;
// //assign 0 length
// wire temp14, temp15;
// andn #(4) a24(.in({mod_equal_00, rm_not_equal_110, isMod, w16_bit_mode}), .out(temp14));
// andn #(3) a25(.in({mod_equal_11, isMod, w16_bit_mode}), .out(temp15));
// orn #(3) o13(.in({temp14, temp15, no_mod}), .out(w16_bit_length_of_disp_bit_0));

// //assign 1 length
// andn #(3) a26(.in({mod_equal_01, isMod, w16_bit_mode}), .out(w16_bit_length_of_disp_bit_1));

// //assign 2 length
// wire temp16, temp17;
// andn #(4) a27(.in({mod_equal_00, rm_equal_110, isMod, w16_bit_mode}), .out(temp16));
// andn #(3) a28(.in({mod_equal_10, isMod, w16_bit_mode}), .out(temp17));
// orn #(2) o14(.in({temp16, temp17}), .out(w16_bit_length_of_disp_bit_2));

// //assign 3 length
// assign w16_bit_length_of_disp_bit_3 = 1'b0;

//combine the 16 and 32 bit versions
// orn #(2) o15(.in({w16_bit_length_of_disp_bit_0, w32_bit_length_of_disp_bit_0}), .out(length_of_disp[0]));
// orn #(2) o16(.in({w16_bit_length_of_disp_bit_1, w32_bit_length_of_disp_bit_1}), .out(length_of_disp[1]));
// orn #(2) o17(.in({w16_bit_length_of_disp_bit_2, w32_bit_length_of_disp_bit_2}), .out(length_of_disp[2]));
// orn #(2) o18(.in({w16_bit_length_of_disp_bit_3, w32_bit_length_of_disp_bit_3}), .out(length_of_disp[3]));
assign length_of_disp[0] = w32_bit_length_of_disp_bit_0;
assign length_of_disp[1] = w32_bit_length_of_disp_bit_1;
assign length_of_disp[2] = w32_bit_length_of_disp_bit_2;
assign length_of_disp[3] = w32_bit_length_of_disp_bit_3;

//all the logic to determine if R2 is being used
// //16 bit mode
// wire w16_useR2;
// wire temp18, temp19, temp20, temp21;
// wire rm_equal_0xx;
// wire rm_equal_11x;
// inv1$ i13(.in(rm[2]), .out(rm_equal_0xx));
// andn #(2) gobbleme(.in({rm[2], rm[1]}), .out(rm_equal_11x));
// andn #(4) a29(.in({mod_not_equal_11, rm_equal_0xx, isMod, w16_bit_mode}), .out(temp18));
// andn #(4) a30(.in({mod_equal_00, rm_equal_111, isMod, w16_bit_mode}), .out(temp19));
// andn #(4) a31(.in({mod_equal_01, rm_equal_11x, isMod, w16_bit_mode}), .out(temp20));
// andn #(4) a32(.in({mod_equal_10, rm_equal_11x, isMod, w16_bit_mode}), .out(temp21));
// orn #(4) o19(.in({temp18, temp19, temp20, temp21}), .out(w16_useR2));

//32 bit mode
wire w32_useR2;
wire temp_mod00_rm101, not_temp_mod00_rm101;
andn #(2) a33(.in({mod_equal_00, rm_equal_101}), .out(temp_mod00_rm101));
inv1$ i14(.in(temp_mod00_rm101), .out(not_temp_mod00_rm101));
andn #(2) anul(.in({not_temp_mod00_rm101, isMod}), .out(w32_useR2));

//combine the 16 and 32 bit versions with just mod == 11
// orn #(3) o20(.in({w16_useR2, w32_useR2, mod_equal_11}), .out(use_R2));
assign use_R2 = w32_useR2;

//all the logic to determine if R3 is being used
//16 bit mode
// wire w16_useR3;
// wire temp22, temp23, temp24;
// andn #(4) a34(.in({mod_not_equal_11, rm_equal_0xx, isMod, w16_bit_mode}), .out(temp22));
// andn #(4) a35(.in({mod_not_equal_11, rm_equal_100, isMod, w16_bit_mode}), .out(temp23));
// andn #(4) a36(.in({mod_not_equal_11, rm_equal_101, isMod, w16_bit_mode}), .out(temp24));
// orn #(3) o21(.in({temp22, temp23, temp24}), .out(w16_useR3));      

//32 bit mode
wire w32_useR3;
andn #(2) a3adeqw6(.in({isSIB, mod_not_equal_11}), .out(w32_useR3));

//combine the 16 and 32 bit versions with just mod == 11
// orn #(2) o22(.in({w16_useR3, w32_useR3}), .out(use_R3));
assign use_R3 = w32_useR3;

//all the logic to select the actual value of R2

wire [2:0] /*R2_val_16_version,*/ R2_val_16_or_32_version;
// wire sel_R2_val;
// andn #(2) a37(.in({is_opsize_override, mod_not_equal_11}), .out(sel_R2_val));
// muxnm_tree #(1, 3) m2(.in({3'b011, 3'b101}), .sel(rm[1]), .out(R2_val_16_version));
// muxnm_tree #(1, 3) m3(.in({R2_val_16_version, rm}), .sel(sel_R2_val), .out(R2_val_16_or_32_version));
assign R2_val_16_or_32_version = rm;
muxnm_tree #(1, 3) m4(.in({base, R2_val_16_or_32_version}), .sel(isSIB), .out(R2_override_val));

//all the logic to select the actual value of R3
wire [2:0] /*R3_val_16_version,*/ R3_val_16_or_32_version;
// muxnm_tree #(1, 3) m5(.in({3'b111, 3'b110}), .sel(rm[0]), .out(R3_val_16_version));
// muxnm_tree #(1, 3) m6(.in({R3_val_16_version, index}), .sel(is_opsize_override), .out(R3_val_16_or_32_version));
assign R3_val_16_or_32_version = index;
muxnm_tree #(1, 3) m7(.in({index, R3_val_16_or_32_version}), .sel(isSIB), .out(R3_override_val));

//all the logic to select how much to scale by
muxnm_tree #(1,2) m8(.in({scale, 2'b00}), .sel(isSIB), .out(shift_R3_amount));

assign is_SIB = isSIB;

endmodule