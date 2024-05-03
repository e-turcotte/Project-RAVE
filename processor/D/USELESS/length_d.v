module length_d(
    input wire [7:0] B1,
    input wire [7:0] B2,
    input wire [7:0] B3,
    input wire [7:0] B4,
    input wire [7:0] B5,
    input wire is_rep,
    input wire is_seg_override,
    input wire is_opsize_override,
    input wire [3:0] prefSize,
    input wire isDoubleOp,
    input wire isModRM,
    input wire [1:0] immSize,
    input wire isImm,

    output wire [7:0] length,
    output wire [7:0] length_no_imm
);
    wire [40959:0] data;
    length_data ld(.out(data));
    wire [40959:0] buffered_data;
    bufferH16_nb$ #(.WIDTH(40960)) buff(.in(data), .out(buffered_data));

    wire [11:0] sel0;
    assign sel0 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B1[7:6], B1[2:0]};
    wire [9:0] chosen_data0;
    select_length sl0(.data(buffered_data), .sel(sel0), .out(chosen_data0));

    wire [11:0] sel1;
    assign sel1 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B2[7:6], B2[2:0]};
    wire [9:0] chosen_data1;
    select_length sl1(.data(buffered_data), .sel(sel1), .out(chosen_data1));

    wire [11:0] sel2;
    assign sel2 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B3[7:6], B3[2:0]};
    wire [9:0] chosen_data2;
    select_length sl2(.data(buffered_data), .sel(sel2), .out(chosen_data2));

    wire [11:0] sel3;
    assign sel3 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B4[7:6], B4[2:0]};
    wire [9:0] chosen_data3;
    select_length sl3(.data(buffered_data), .sel(sel3), .out(chosen_data3));

    wire [11:0] sel4;
    assign sel4 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B5[7:6], B5[2:0]};
    wire [9:0] chosen_data4;
    select_length sl4(.data(buffered_data), .sel(sel4), .out(chosen_data4));

    wire [39:0] concat_no_double_data;
    assign concat_no_double_data = {chosen_data3, chosen_data2, chosen_data1, chosen_data0};
    wire [39:0] concat_double_data;
    assign concat_double_data = {chosen_data4, chosen_data3, chosen_data2, chosen_data1};

    wire [9:0] no_double_data;
    muxnm_tristate #(4, 10) mxt1(.in(concat_no_double_data), .sel(prefSize) ,.out(no_double_data));
    wire [9:0] double_data;
    muxnm_tristate #(4, 10) mxt2(.in(concat_double_data), .sel(prefSize) ,.out(double_data));
    wire [9:0] actual_selected_data;
    muxnm_tree #(1, 10) mxt3(.in({double_data, no_double_data}), .sel(isDoubleOp) ,.out(actual_selected_data));

    assign length = {3'b000, actual_selected_data[9:5]};
    assign length_no_imm = {3'b000, actual_selected_data[4:0]};


endmodule

