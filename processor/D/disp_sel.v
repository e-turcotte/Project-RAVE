module disp_sel_logic(
    input [3:0] num_prefixes_onehot,
    input is_double_opcode,
    input is_MOD,
    input is_SIB,
    output [6:0] disp_sel
);
    wire is_double_opcode_inv, is_MOD_inv, is_SIB_inv;
    wire [3:0] num_prefixes_inv;

    invn #(.NUM_INPUTS(4)) i0(.in(num_prefixes_onehot), .out(num_prefixes_inv));
    inv1$ i1(.out(is_double_opcode_inv), .in(is_double_opcode));
    inv1$ i2(.out(is_MOD_inv), .in(is_MOD));
    inv1$ i3(.out(is_SIB_inv), .in(is_SIB));

    //disp_sel[0] - done
    andn #(.NUM_INPUTS(7)) a0(.in({num_prefixes_inv[3], num_prefixes_inv[2], num_prefixes_inv[1], num_prefixes_onehot[0], is_double_opcode_inv, is_MOD_inv, is_SIB_inv}), .out(disp_sel[0]));

    //disp_sel[1] - done
    wire sel1_0, sel1_1, sel1_2;
    andn #(.NUM_INPUTS(7)) a1(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel1_0));
    andn #(.NUM_INPUTS(7)) a2(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD_inv, is_SIB_inv}), .out(sel1_1));
    andn #(.NUM_INPUTS(7)) a3(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode_inv, is_MOD_inv, is_SIB_inv}), .out(sel1_2));
    or3$ o0(.out(disp_sel[1]), .in0(sel1_0), .in1(sel1_1), .in2(sel1_2));

    //disp_sel[2] - done
    wire sel2_0, sel2_1, sel2_2, sel2_3, sel2_4;
    andn #(.NUM_INPUTS(7)) a4(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel2_0));
    andn #(.NUM_INPUTS(7)) a5(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel2_1));
    andn #(.NUM_INPUTS(7)) a6(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel2_2));
    andn #(.NUM_INPUTS(7)) a7(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode, is_MOD_inv, is_SIB_inv}), .out(sel2_3));
    andn #(.NUM_INPUTS(7)) a8(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode_inv, is_MOD_inv, is_SIB_inv}), .out(sel2_4));
    orn #(.NUM_INPUTS(5)) o1(.in({sel2_0, sel2_1, sel2_2, sel2_3, sel2_4}), .out(disp_sel[2]));

    //disp_sel[3] - done
    wire sel3_0, sel3_1, sel3_2, sel3_3, sel3_4, sel3_5;
    andn #(.NUM_INPUTS(7)) a9(.in({num_prefixes_inv[3:1], num_prefixes_onehot[0], is_double_opcode, is_MOD, is_SIB}), .out(sel3_0));
    andn #(.NUM_INPUTS(7)) a10(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel3_1));
    andn #(.NUM_INPUTS(7)) a11(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel3_2));
    andn #(.NUM_INPUTS(7)) a12(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel3_3));
    andn #(.NUM_INPUTS(7)) a13(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD_inv, is_SIB_inv}), .out(sel3_4));
    andn #(.NUM_INPUTS(7)) a14(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode_inv, is_MOD_inv, is_SIB_inv}), .out(sel3_5));
    orn #(.NUM_INPUTS(6)) o2(.in({sel3_0, sel3_1, sel3_2, sel3_3, sel3_4, sel3_5}), .out(disp_sel[3]));

    //disp_sel[4] - done
    wire sel4_0, sel4_1, sel4_2, sel4_3, sel4_4;
    andn #(.NUM_INPUTS(7)) a15(.in({num_prefixes_inv[3:2], num_prefixes_onehot[1], num_prefixes_inv[0], is_double_opcode, is_MOD, is_SIB}), .out(sel4_0));
    andn #(.NUM_INPUTS(7)) a16(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel4_1));
    andn #(.NUM_INPUTS(7)) a17(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel4_2));
    andn #(.NUM_INPUTS(7)) a18(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode_inv, is_MOD, is_SIB_inv}), .out(sel4_3));
    andn #(.NUM_INPUTS(7)) a19(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode, is_MOD_inv, is_SIB_inv}), .out(sel4_4));
    orn #(.NUM_INPUTS(5)) o3(.in({sel4_0, sel4_1, sel4_2, sel4_3, sel4_4}), .out(disp_sel[4]));

    //disp_sel[5] - done
    wire sel5_0, sel5_1, sel5_2;
    andn #(.NUM_INPUTS(7)) a20(.in({num_prefixes_inv[3], num_prefixes_onehot[2], num_prefixes_inv[1:0], is_double_opcode, is_MOD, is_SIB}), .out(sel5_0));
    andn #(.NUM_INPUTS(7)) a21(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode_inv, is_MOD, is_SIB}), .out(sel5_1));
    andn #(.NUM_INPUTS(7)) a22(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode, is_MOD, is_SIB_inv}), .out(sel5_2));
    orn #(.NUM_INPUTS(3)) o4(.in({sel5_0, sel5_1, sel5_2}), .out(disp_sel[5]));

    //disp_sel[6] - done
    andn #(.NUM_INPUTS(7)) a23(.in({num_prefixes_onehot[3], num_prefixes_inv[2:0], is_double_opcode, is_MOD, is_SIB}), .out(disp_sel[6]));

endmodule

module size_sel_logic(
    input [1:0] mod,
    input [2:0] rm,
    input isMOD,
    input is_size_override,
    output [3:0] rot_sel
);
    
    wire isMOD_inv, is_size_override_inv;
    inv1$ i0(.out(isMOD_inv), .in(isMOD));
    inv1$ i1(.out(is_size_override_inv), .in(is_size_override));
    wire [1:0] mod_inv;
    invn #(.NUM_INPUTS(2)) i2(.in(mod), .out(mod_inv));
    wire [2:0] rm_inv;
    invn #(.NUM_INPUTS(3)) i3(.in(rm), .out(rm_inv));

    assign rot_sel[0] = isMOD_inv;

    andn #(.NUM_INPUTS(2)) a023413(.in({mod_inv[1], mod[0]}), .out(rot_sel[1]));

    wire sel2_0, sel2_1;
    andn #(.NUM_INPUTS(3)) a0341234(.in({mod[1], mod_inv[0], is_size_override}), .out(sel2_0));
    andn #(.NUM_INPUTS(6)) a1(.in({mod_inv[1], mod_inv[0], is_size_override, rm[2], rm[1], rm_inv[0]}), .out(sel2_1));
    or2$ o0(.out(rot_sel[2]), .in0(sel2_0), .in1(sel2_1));

    wire sel3_0, sel3_1;
    andn #(.NUM_INPUTS(3)) a0qwr3(.in({mod[1], mod_inv[0], is_size_override_inv}), .out(sel4_0));
    andn #(.NUM_INPUTS(6)) a1df324r(.in({mod_inv[1], mod_inv[0], is_size_override_inv, rm[2], rm_inv[1], rm[0]}), .out(sel4_1));
    or2$ o0dfbds(.out(rot_sel[3]), .in0(sel4_0), .in1(sel4_1));

endmodule