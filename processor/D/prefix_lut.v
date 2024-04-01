 

module prefix_lut(
    input clk,
    input reset,
    input [7:0] prefix,
    output is_rep,
    output is_seg_override,
    output is_opsize_override;
    ); //TODO: how to encode which seg override?

    //compare each prefix to the known prefixes in lookup table
    
    wire [7:0] rep, seg_cs, seg_ss, seg_ds, seg_es, seg_fs, seg_gs, opsize;
    assign rep = 8'hF3;
    assign seg_cs = 8'h2E;
    assign seg_ss = 8'h36;
    assign seg_ds = 8'h3E;
    assign seg_es = 8'h26;
    assign seg_fs = 8'h64;
    assign seg_gs = 8'h65;
    assign opsize = 8'h66;

    //TODO: do I need to add a buffer for fanout?
    //magic_comp8 will be 0 if they are equal
    mag_comp8$(prefix, rep, is_rep);
    mag_comp8$(prefix, seg_cs, is_seg_override);
    mag_comp8$(prefix, seg_ss, is_seg_override);
    mag_comp8$(prefix, seg_ds, is_seg_override);
    mag_comp8$(prefix, seg_es, is_seg_override);
    mag_comp8$(prefix, seg_fs, is_seg_override);
    mag_comp8$(prefix, seg_gs, is_seg_override);
    mag_comp8$(prefix, opsize, is_opsize_override);
    



endmodule