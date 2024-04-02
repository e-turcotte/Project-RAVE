module prefix_d (
    input [127:0] packet,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_seg_override,
    output is_opsize_override,
    output [1:0] num_prefixes
    );

    wire [7:0] prefix1, prefix2, prefix3;

    assign prefix1 = packet[127:120];
    assign prefix2 = packet[119:112];
    assign prefix3 = packet[111:104];

    wire is_rep1, is_rep2, is_rep3;
    wire [5:0] seg_override1, seg_override2, seg_override3;
    wire is_opsize_override1, is_opsize_override2, is_opsize_override3;
    
    prefix_lut prefix_lut1(
        .prefix(prefix1),
        .is_rep(is_rep1),
        .seg_override(seg_override1),
        .is_opsize_override(is_opsize_override1)
    );

    prefix_lut prefix_lut2(
        .prefix(prefix2),
        .is_rep(is_rep2),
        .seg_override(seg_override2),
        .is_opsize_override(is_opsize_override2)
    );

    prefix_lut prefix_lut3(
        .prefix(prefix3),
        .is_rep(is_rep3),
        .seg_override(seg_override3),
        .is_opsize_override(is_opsize_override3)
    );
    
    or3$(is_rep, is_rep1, is_rep2, is_rep3);
    
    or3$(seg_override[0], seg_override1[0], seg_override2[0], seg_override3[0]);
    or3$(seg_override[1], seg_override1[1], seg_override2[1], seg_override3[1]);
    or3$(seg_override[2], seg_override1[2], seg_override2[2], seg_override3[2]);
    or3$(seg_override[3], seg_override1[3], seg_override2[3], seg_override3[3]);
    or3$(seg_override[4], seg_override1[4], seg_override2[4], seg_override3[4]);
    or3$(seg_override[5], seg_override1[5], seg_override2[5], seg_override3[5]);
    
    or3$(is_opsize_override, is_opsize_override1, is_opsize_override2, is_opsize_override3); 

    //find is_seg_override

    wire nor_1, nor_2, nor_3;

    nor2$(nor_1, seg_override[0], seg_override[1]);
    nor2$(nor_2, seg_override[2], seg_override[3]);
    nor2$(nor_3, seg_override[4], seg_override[5]);

    nand3$(is_seg_override, nor_1, nor_2, nor_3);

    //to encode num prefixes as a sum:

    fulladder1$ fa(is_rep, is_seg_override, is_opsize_override, num_prefixes[0], num_prefixes[1]);



endmodule
