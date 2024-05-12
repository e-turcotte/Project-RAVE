module mshr (input [14:0] pAddress,
             input [6:0] ptcid_in,
             input [7:0] qentry_slot_in,
             input rdsw_in,
             input alloc, dealloc,

             input clk, clr,
             
             output [6:0] ptcid_out,
             output [7:0] qentry_slots_out,
             output [1:0] wake_vector_out,
             output mshr_hit, mshr_full);
    
    wire [1:0] wake_vector_in;

    assign wake_vector_in[1] = rdsw_in;
    inv1$ g0(.out(wake_vector_in[0]), .in(rdsw_in));
    
    wire [383:0] issued_reqs, change_reqs;
    wire [7:0] update_vector, invalidation_vector, match_vector, hit_vector;

    wire [14:0] dealloc_paddr;
    wire [6:0] dealloc_qentries;
    wire dealloc_wake, dealloc_valid;

    queuenm #(.M_WIDTH(24), .N_WIDTH(2), .Q_LENGTH(8)) q0(.m_din({1'b1,pAddress,qentry_slot_in}), .n_din({wake_vector_in}),
                                                          .new_m_vector(change_reqs), .wr(alloc), .rd(dealloc),
                                                          .modify_vector(update_vector), .clr(clr), .clk(clk),
                                                          .full(mshr_full), .empty(), .old_m_vector(issued_reqs),
                                                          .dout({dealloc_valid,dealloc_paddr,dealloc_qentries,dealloc_wake}));

    assign qentry_slots_out = dealloc_qentries;
    assign wake_vector_out = dealloc_wake;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : m_slices
            equaln #(.WIDTH(15)) eq0(.a(dealloc_paddr), .b(issued_reqs[i*24 + 22:i*24 + 8]), .eq(invalidation_vector[i]));
            equaln #(.WIDTH(15)) eq1(.a(pAddress), .b(issued_reqs[i*24 + 22:i*24 + 8]), .eq(match_vector[i]));
            and2$ g1(.out(hit_vector[i]), .in0(match_vector[i]), .in1(issued_reqs[i*24 + 23]));

            inv1$ g2(.out(change_reqs[i*24 + 23]), .in(invalidation_vector[i]));
            assign change_reqs[i*24 + 23] = issued_reqs[i*24 + 23];
            or2$ g3(.out(change_reqs[i*24 + 7]), .in0(issued_reqs[i*24 + 7]), .in1(qentry_slot_in[7]));
            or2$ g4(.out(change_reqs[i*24 + 6]), .in0(issued_reqs[i*24 + 6]), .in1(qentry_slot_in[6]));
            or2$ g5(.out(change_reqs[i*24 + 5]), .in0(issued_reqs[i*24 + 5]), .in1(qentry_slot_in[5]));
            or2$ g6(.out(change_reqs[i*24 + 4]), .in0(issued_reqs[i*24 + 4]), .in1(qentry_slot_in[4]));
            or2$ g7(.out(change_reqs[i*24 + 3]), .in0(issued_reqs[i*24 + 3]), .in1(qentry_slot_in[3]));
            or2$ g8(.out(change_reqs[i*24 + 2]), .in0(issued_reqs[i*24 + 2]), .in1(qentry_slot_in[2]));
            or2$ g9(.out(change_reqs[i*24 + 1]), .in0(issued_reqs[i*24 + 1]), .in1(qentry_slot_in[1]));
            or2$ g10(.out(change_reqs[i*24 + 0]), .in0(issued_reqs[i*24 + 0]), .in1(qentry_slot_in[0]));

            or2$ g11(.out(update_vector[i]), .in0(invalidation_vector[i]), .in1(hit_vector[i]));
        end
    endgenerate

    orn #(.NUM_INPUTS(8)) g12(.in(hit_vector), .out(mshr_hit));

endmodule