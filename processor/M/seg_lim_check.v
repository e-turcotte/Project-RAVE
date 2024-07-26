module seg_lim_check(
    input [159:0] VP, PF,
    input [31:0]  address,
    input [31:0]  seg_max, 
    output        seg_lim_exception
);

//onehot encoding for IE_type, from highest pri to lowest pri (i think)
    //000: no IE
    //001: protection (read_address > seg_max_address)
    //010: page fault (tlb_miss)
    //100: interrupt


    //run read_address_end_size through a TLB to get physical read_address_end_size
    wire[7:0] tag_select;

    genvar i;
    for(i = 0; i < 8; i = i + 1) begin
        equaln #(20) ahf(VP[i*20 + 19 : i*20], address[31:12], tag_select[i]);
    end

    orn #(8) asg(.in(tag_select), .out(tlb_valid));

    wire RA_gt_SS, RA_lt_SS, EQ, seg_ex;
    mag_comp32 mag(.A(address), .B(seg_max), .AGB(RA_gt_SS), .BGA(RA_lt_SS), .EQ(EQ));

    orn #(2) o1(.out(seg_ex), .in( {EQ, RA_gt_SS} ));
    andn #(2) a2 (.out(seg_lim_exception), .in({tlb_valid, seg_ex}));

endmodule
