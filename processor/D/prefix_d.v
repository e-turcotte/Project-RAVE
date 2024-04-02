module prefix_d (
    input [127:0] packet,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_seg_override,
    output is_opsize_override,
    output [1:0] num_prefixes //sum of all prefixes (not onehot)
    );
    //total prefix decode time is 3.35ns (i think)
    wire [7:0] prefix1, prefix2, prefix3;

    assign prefix1 = packet[127:120];
    assign prefix2 = packet[119:112];
    assign prefix3 = packet[111:104];

    wire is_rep1, is_rep2, is_rep3;
    wire [5:0] seg_override1, seg_override2, seg_override3;
    wire is_opsize_override1, is_opsize_override2, is_opsize_override3;
    
    prefix_cmp prefix_cmp1( //0.7ns in parallel
        .prefix(prefix1),
        .is_rep(is_rep1),
        .seg_override(seg_override1),
        .is_opsize_override(is_opsize_override1)
    );

    prefix_cmp prefix_cmp2(
        .prefix(prefix2),
        .is_rep(is_rep2),
        .seg_override(seg_override2),
        .is_opsize_override(is_opsize_override2)
    );

    prefix_cmp prefix_cmp3(
        .prefix(prefix3),
        .is_rep(is_rep3),
        .seg_override(seg_override3),
        .is_opsize_override(is_opsize_override3)
    );
    
    or3$(.out(is_rep), .in0(is_rep1), .in1(is_rep2), .in2(is_rep3)); //0.35ns in parallel
    
    or3$(.out(seg_override[0]), .in0(seg_override1[0]), .in1(seg_override2[0]), .in2(seg_override3[0]));
    or3$(.out(seg_override[1]), .in0(seg_override1[1]), .in1(seg_override2[1]), .in2(seg_override3[1]));
    or3$(.out(seg_override[2]), .in0(seg_override1[2]), .in1(seg_override2[2]), .in2(seg_override3[2]));
    or3$(.out(seg_override[3]), .in0(seg_override1[3]), .in1(seg_override2[3]), .in2(seg_override3[3]));
    or3$(.out(seg_override[4]), .in0(seg_override1[4]), .in1(seg_override2[4]), .in2(seg_override3[4]));
    or3$(.out(seg_override[5]), .in0(seg_override1[5]), .in1(seg_override2[5]), .in2(seg_override3[5]));

    or3$(.out(is_opsize_override), .in0(is_opsize_override1), .in1(is_opsize_override2), .in2(is_opsize_override3)); 

    //find is_seg_override

    wire nor_1, nor_2, nor_3;

    nor2$(.out(nor_1), .in0(seg_override[0]), .in1(seg_override[1])); //0.2ns
    nor2$(.out(nor_2), .in0(seg_override[2]), .in1(seg_override[3]));
    nor2$(.out(nor_3), .in0(seg_override[4]), .in1(seg_override[5]));

    nand3$(.out(is_seg_override), .in0(nor_1), .in1(nor_2), .in2(nor_3)); //0.2ns

    //to encode num prefixes as a sum:

    fulladder1$ fa(.A(is_rep), .B(is_seg_override), .cin(is_opsize_override),
                   .sum(num_prefixes[0]), .cout(num_prefixes[1])); //0.7ns

endmodule

