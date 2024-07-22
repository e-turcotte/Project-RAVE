module seg_lim_exception_logic(
    input [31:0] read_address_end_size,
    input [19:0] seg_size, //need to zext to 32b
    output seg_lim_exception
);

//onehot encoding for IE_type, from highest pri to lowest pri (i think)
    //000: no IE
    //001: protection (read_address > seg_max_address)
    //010: page fault (tlb_miss)
    //100: interrupt


    //TODO: is seg_size allowed to be equal to read_address_size 
    // - based on implementation from prot_exception_logic.v, it can't
    // since it will give 1 + the last address of the 
    // accesss

    wire RA_gt_SS, RA_lt_SS, EQ;
    mag_comp32 mag(.A(read_address_end_size), .B({12'b0, seg_size}), .AGB(RA_gt_SS), .BGA(RA_lt_SS), .EQ(EQ));
    or2$ o1(.out(seg_lim_exception), .in0(EQ), .in1(RA_gt_SS));

endmodule
