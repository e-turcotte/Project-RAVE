module prefix_d (
    input clk,
    input reset,
    input [127:0] packet,
    output [1:0] num_prefixes,
    output is_rep,
    output is_seg_override,
    output is_opsiz_override;
    ); //TODO: how to encode which seg override - there are 6 possible values

    wire [7:0] prefix1, prefix2, prefix3;

    assign prefix1 = packet[127:120];
    assign prefix2 = packet[119:112];
    assign prefix3 = packet[111:104];

    wire is_rep1, is_rep2, is_rep3;
    wire is_seg_override1, is_seg_override2, is_seg_override3;
    wire is_opsize_override1, is_opsize_override2, is_opsize_override3;
    
    prefix_lut prefix_lut1(
        .prefix(prefix1),
        .is_rep(is_rep1),
        .is_seg_override(is_seg_override1),
        .is_opsize_override(is_opsiz_override1)
    );

    prefix_lut prefix_lut2(
        .prefix(prefix2),
        .is_rep(is_rep2),
        .is_seg_override(is_seg_override2),
        .is_opsize_override(is_opsiz_override2)
    );

    prefix_lut prefix_lut3(
        .prefix(prefix3),
        .is_rep(is_rep3),
        .is_seg_override(is_seg_override3),
        .is_opsize_override(is_opsiz_override3)
    );

    nand3$(is_rep1, is_rep2, is_rep3, is_rep);
    nand3$(is_seg_override1, is_seg_override2, is_seg_override3, is_seg_override);
    nand3$(is_opsize_override1, is_opsize_override2, is_opsize_override3, is_opsize_override);

    //count the number of prefixes
    //TODO: how to encode num prefixes: onehot?


endmodule