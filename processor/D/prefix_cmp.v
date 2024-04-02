 
module prefix_cmp(
    input [7:0] prefix,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_opsize_override
    ); 
 
 //total time: 1.9ns

    wire [7:0] rep, seg_cs, seg_ss, seg_ds, seg_es, seg_fs, seg_gs, opsize;
    wire [7:0] prefix_temp;

    wire rep_gt, rep_lt;
    wire seg_cs_gt, seg_cs_lt;
    wire seg_ss_gt, seg_ss_lt;
    wire seg_ds_gt, seg_ds_lt;
    wire seg_es_gt, seg_es_lt;
    wire seg_fs_gt, seg_fs_lt;
    wire seg_gs_gt, seg_gs_lt;
    wire opsize_gt, opsize_lt;
    
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
    mag_comp8$(prefix_temp, rep, rep_gt, rep_lt); //1.46ns in parallel
    mag_comp8$(prefix_temp, seg_cs, seg_cs_gt, seg_cs_lt);
    mag_comp8$(prefix_temp, seg_ss, seg_ss_gt, seg_ss_lt);
    mag_comp8$(prefix_temp, seg_ds, seg_ds_gt, seg_ds_lt);
    mag_comp8$(prefix_temp, seg_es, seg_es_gt, seg_es_lt);
    mag_comp8$(prefix_temp, seg_fs, seg_fs_gt, seg_fs_lt);
    mag_comp8$(prefix_temp, seg_gs, seg_gs_gt, seg_gs_lt);
    mag_comp8$(prefix_temp, opsize, opsize_gt, opsize_lt);

    nor2$(is_rep, rep_gt, rep_lt); //0.2 ns
    nor2$(seg_override[0], seg_cs_gt, seg_cs_lt);
    nor2$(seg_override[1], seg_ss_gt, seg_ss_lt);
    nor2$(seg_override[2], seg_ds_gt, seg_ds_lt);
    nor2$(seg_override[3], seg_es_gt, seg_es_lt);
    nor2$(seg_override[4], seg_fs_gt, seg_fs_lt);
    nor2$(seg_override[5], seg_gs_gt, seg_gs_lt);
    nor2$(is_opsize_override, opsize_gt, opsize_lt);
    //at this point, outputs should be 1 for true (since nand)

endmodule
