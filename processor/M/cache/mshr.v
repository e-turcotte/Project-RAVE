module mshr (input [14:0] pAddress,
             input [6:0] ptcid_in,
             input rd_or_sw_in,
             input alloc, dealloc,

             input clk, clr,
             
             output [6:0] ptcid_out,
             output rd_or_sw_out,
             output mshr_hit, mshr_full);
    
    wire [127:0] issued_reqs;
    wire [7:0] invalidation_vector, match_vector, miss_vector;

    wire [14:0] dealloc_paddr;
    wire [6:0] dealloc_ptcid;
    wire dealloc_rd_or_sw, dealloc_valid;

    queuenm #(.M_WIDTH(16), .N_WIDTH(8), .Q_LENGTH(8)) q0(.m_din({1'b1,pAddress}), .n_din({rd_or_sw_in,ptcid_in}),
                                                          .new_m_vector({128{1'b0}}), .wr(alloc), .rd(dealloc),
                                                          .modify_vector(invalidation_vector), .clr(clr), .clk(clk),
                                                          .full(mshr_full), .empty(), .old_m_vector(issued_reqs),
                                                          .dout({dealloc_valid,dealloc_paddr,dealloc_rd_or_sw,dealloc_ptcid}));

    assign rd_or_sw_out = dealloc_rd_or_sw;
    assign ptcid_out = dealloc_ptcid;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : m_slices
            equaln #(.WIDTH(15)) eq0(.a(dealloc_paddr), .b(issued_reqs[(i+1)*16-2:i*16]), .eq(invalidation_vector[i]));
            equaln #(.WIDTH(15)) eq1(.a(pAddress), .b(issued_reqs[(i+1)*16-2:i*16]), .eq(match_vector[i]));
            and2$ g0(.out(miss_vector[i]), .in0(match_vector[i]), .in1(issued_reqs[(i+1)*16-1]));
        end
    endgenerate

    orn #(.NUM_INPUTS(8)) g1(.in(miss_vector), .out(mshr_hit));

endmodule