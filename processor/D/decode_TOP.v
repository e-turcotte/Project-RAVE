module decode_TOP;
    //instantiate queued latches here? or take in as input?
    
    //prefix decoding:
    wire is_rep, is_seg_override, is_opsize_override;
    wire [5:0] seg_override;
    wire [1:0] num_prefixes;

	prefix_d(.packet(packet), .is_rep(is_rep), .seg_override(seg_override), 
            .is_seg_override(is_seg_override), .is_opsize_override(is_opsize_override), .num_prefixes(num_prefixes));



endmodule