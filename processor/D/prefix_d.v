module prefix_d (
    input clk,
    input reset,
    input [127:0] packet,
    output [2:0] num_prefixes,
    output is_rep,
    output [5:0] is_seg_override,
    output is_opsiz_override;
    ); //TODO: how to encode which seg override - there are 6 possible values

    wire [7:0] prefix1, prefix2, prefix3;

    assign prefix1 = packet[127:120];
    assign prefix2 = packet[119:112];
    assign prefix3 = packet[111:104];

    wire is_rep1, is_rep2, is_rep3;
    wire [5:0] seg_override1, seg_override2, seg_override3;
    wire is_opsize_override1, is_opsize_override2, is_opsize_override3;
    
    prefix_lut prefix_lut1(
        .clk(clk),
        .reset(reset),
        .prefix(prefix1),
        .is_rep(is_rep1),
        .seg_override(seg_override1),
        .is_opsize_override(is_opsize_override1)
    );

    prefix_lut prefix_lut2(
        .clk(clk),
        .reset(reset),
        .prefix(prefix2),
        .is_rep(is_rep2),
        .seg_override(seg_override2),
        .is_opsize_override(is_opsize_override2)
    );

    prefix_lut prefix_lut3(
        .clk(clk),
        .reset(reset),
        .prefix(prefix3),
        .is_rep(is_rep3),
        .seg_override(seg_override3),
        .is_opsize_override(is_opsize_override3)
    );

    
    and3$(is_rep, is_rep1, is_rep2, is_rep3);
    
    and3$(is_seg_override[0], is_seg_override1[0], is_seg_override2[0], is_seg_override3[0]);
    and3$(is_seg_override[1], is_seg_override1[1], is_seg_override2[1], is_seg_override3[1]);
    and3$(is_seg_override[2], is_seg_override1[2], is_seg_override2[2], is_seg_override3[2]);
    and3$(is_seg_override[3], is_seg_override1[3], is_seg_override2[3], is_seg_override3[3]);
    and3$(is_seg_override[4], is_seg_override1[4], is_seg_override2[4], is_seg_override3[4]);
    and3$(is_seg_override[5], is_seg_override1[5], is_seg_override2[5], is_seg_override3[5]);
    
    and3$(is_opsize_override, is_opsize_override1, is_opsize_override2, is_opsize_override3); 

    //count the number of prefixes

    //TODO: how to encode num prefixes: onehot? or sum?

    //need to shift to encode num prefixes



endmodule