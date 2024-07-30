module fip_seg_prot_check(
    input [159:0] VP, PF,
    input [31:0] FIP,
    output prot_logic_is_valid
);



    wire cout0, cout1;
    wire [31:0] address_size_shifted, addr_sum1;

    wire [31:0] read_address_end_size_V;
    assign read_address_end_size_V = {FIP[31:4] , 4'hF};
    
    //run read_address_end_size through a TLB to get physical read_address_end_size
    wire[7:0] tag_select;
    wire [19:0] entry_P;

    genvar i;
    for(i = 0; i < 8; i = i + 1) begin
        equaln #(20) ahf(VP[i*20 + 19 : i*20], read_address_end_size_V[31:12], tag_select[i]);
    end
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(20)) adgf(.in(PF), .sel(tag_select), .out(entry_P));
    
    orn #(8) asg(.in(tag_select), .out(tlb_valid));

    assign read_address_end_size = {entry_P, read_address_end_size_V[11:0]};

    assign prot_logic_is_valid = tlb_valid;

endmodule