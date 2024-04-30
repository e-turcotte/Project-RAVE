module disp_sel(
    input [3:0] num_prefixes_onehot,
    input is_double_opcode,
    input is_MOD,
    input is_SIB,
    output [6:0] disp_sel
);
    wire is_double_opcode_inv, is_MOD_inv, is_SIB_inv;
    wire [3:0] num_prefixes_inv;

    invn #(.NUM_INPUTS(1)) i0(.in(num_prefixes_onehot), .out(num_prefixes_inv));
    inv1$ i1(.out(is_double_opcode_inv), .in(is_double_opcode));
    inv1$ i2(.out(is_MOD_inv), .in(is_MOD));
    inv1$ i3(.out(is_SIB_inv), .in(is_SIB));

    assign disp_sel[0] = is_MOD_inv;

    andn #(.NUM_INPUTS(7)) a0(.in({num_prefixes_inv[3], num_prefixes_inv[2], num_prefixes_inv[1], num_prefixes_onehot[0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(disp_sel[1]));

    wire sel2_0, sel2_1, sel2_2;
    andn #(.NUM_INPUTS(7)) a1(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel2_0));
    andn #(.NUM_INPUTS(7)) a2(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel2_1));
    andn #(.NUM_INPUTS(7)) a3(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel2_2));
    or3$ o0(.out(disp_sel[2]), .in0(sel2_0), .in1(sel2_1), .in2(sel2_2));


    wire sel3_0, sel3_1, sel3_2, sel3_3, sel3_4;
    andn #(.NUM_INPUTS(7)) a4(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD, is_SIB}), .out(sel3_0));
    andn #(.NUM_INPUTS(7)) a5(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel3_1));
    andn #(.NUM_INPUTS(7)) a6(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel3_2));
    andn #(.NUM_INPUTS(7)) a7(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel3_3));
    andn #(.NUM_INPUTS(7)) a8(.in({num_prefixes_onehot[3], num_prefixes_inv[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel3_3));
    orn #(.NUM_INPUTS(5)) o1(.in({sel3_0, sel3_1, sel3_2, sel3_3, sel3_4}), .out(disp_sel[3]));

    wire sel4_0, sel4_1, sel4_2, sel4_3;
    andn #(.NUM_INPUTS(7)) a9(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode, is_MOD, is_SIB}), .out(sel4_0));
    andn #(.NUM_INPUTS(7)) a10(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel4_1));
    andn #(.NUM_INPUTS(7)) a11(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel4_2));
    andn #(.NUM_INPUTS(7)) a12(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel4_3));
    orn #(.NUM_INPUTS(4)) o2(.in({sel4_0, sel4_1, sel4_2, sel4_3}), .out(disp_sel[4]));

    wire sel5_0, sel5_1;
    andn #(.NUM_INPUTS(7)) a13(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD, is_SIB}), .out(sel5_0));
    andn #(.NUM_INPUTS(7)) a14(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel5_1));
    or2$ o3(.out(disp_sel[5]), .in0(sel5_0), .in1(sel5_1));

    andn #(.NUM_INPUTS(7)) a15(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode, is_MOD, is_SIB}), .out(disp_sel[6]));


endmodule