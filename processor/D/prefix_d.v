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

 
module prefix_cmp(
    input [7:0] prefix,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_opsize_override
    ); 
 
 //total time: 0.7ns

    wire [7:0] rep, seg_cs, seg_ss, seg_ds, seg_es, seg_fs, seg_gs, opsize;
    wire [7:0] prefix_temp;

    // wire rep_gt, rep_lt;
    // wire seg_cs_gt, seg_cs_lt;
    // wire seg_ss_gt, seg_ss_lt;
    // wire seg_ds_gt, seg_ds_lt;
    // wire seg_es_gt, seg_es_lt;
    // wire seg_fs_gt, seg_fs_lt;
    // wire seg_gs_gt, seg_gs_lt;
    // wire opsize_gt, opsize_lt;
    
    //hardcode known prefixes
    assign rep = 8'hF3;
    assign seg_cs = 8'h2E;
    assign seg_ss = 8'h36;
    assign seg_ds = 8'h3E;
    assign seg_es = 8'h26;
    assign seg_fs = 8'h64;
    assign seg_gs = 8'h65;
    assign opsize = 8'h66;

    //need to buffer for fanout
    bufferH16_8b$ b0(prefix, prefix_temp); //0.24ns

    //TODO: do I need to add a buffer to prefix for fanout? - probably

    //compare each prefix to the known prefixes
    //output will be 0 if they are equal (ie we have a match)
    // mag_comp8$(prefix_temp, rep, rep_gt, rep_lt); //1.46ns in parallel
    // mag_comp8$(prefix_temp, seg_cs, seg_cs_gt, seg_cs_lt);
    // mag_comp8$(prefix_temp, seg_ss, seg_ss_gt, seg_ss_lt);
    // mag_comp8$(prefix_temp, seg_ds, seg_ds_gt, seg_ds_lt);
    // mag_comp8$(prefix_temp, seg_es, seg_es_gt, seg_es_lt);
    // mag_comp8$(prefix_temp, seg_fs, seg_fs_gt, seg_fs_lt);
    // mag_comp8$(prefix_temp, seg_gs, seg_gs_gt, seg_gs_lt);
    // mag_comp8$(prefix_temp, opsize, opsize_gt, opsize_lt);

    equaln #(.WIDTH(8)) rep_mux(.a(rep), .b(prefix_temp), .eq(is_rep)); //0.7ns in parallel
    equaln #(.WIDTH(8)) seg_cs_mux(.a(seg_cs), .b(prefix_temp), .eq(seg_override[0]));
    equaln #(.WIDTH(8)) seg_ss_mux(.a(seg_ss), .b(prefix_temp), .eq(seg_override[1]));
    equaln #(.WIDTH(8)) seg_ds_mux(.a(seg_ds), .b(prefix_temp), .eq(seg_override[2]));
    equaln #(.WIDTH(8)) seg_es_mux(.a(seg_es), .b(prefix_temp), .eq(seg_override[3]));
    equaln #(.WIDTH(8)) seg_fs_mux(.a(seg_fs), .b(prefix_temp), .eq(seg_override[4]));
    equaln #(.WIDTH(8)) seg_gs_mux(.a(seg_gs), .b(prefix_temp), .eq(seg_override[5]));
    equaln #(.WIDTH(8)) opsize_mux(.a(opsize), .b(prefix_temp), .eq(is_opsize_override));

    // nor2$(is_rep, rep_gt, rep_lt); //0.2 ns in parallel
    // nor2$(seg_override[0], seg_cs_gt, seg_cs_lt);
    // nor2$(seg_override[1], seg_ss_gt, seg_ss_lt);
    // nor2$(seg_override[2], seg_ds_gt, seg_ds_lt);
    // nor2$(seg_override[3], seg_es_gt, seg_es_lt);
    // nor2$(seg_override[4], seg_fs_gt, seg_fs_lt);
    // nor2$(seg_override[5], seg_gs_gt, seg_gs_lt);
    // nor2$(is_opsize_override, opsize_gt, opsize_lt);
    //at this point, outputs should be 1 for true (since nand)

endmodule


