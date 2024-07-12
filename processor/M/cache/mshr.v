module mshr (input [14:0] pAddress, //this shouldve been 11 bits but too late to change now
             input [6:0] ptcid_in,
             input [7:0] qentry_slot_in,
             input rdsw_in,
             input alloc, dealloc,

             input clk, clr,
             
             output [7:0] rd_qentry_slots_out, sw_qentry_slots_out,
             output mshr_hit, mshr_full);
    
    wire [223:0] issued_reqs, change_reqs;
    wire [7:0] update_vector, match_vector, hit_vector, return_vector;

    wire moveq, invdealloc;

    wire dealloc_valid;
    wire [10:0] dealloc_paddr;
    wire [15:0] dealloc_qentries;
    wire dealloc_n_spacer;

    wire [7:0] rd_qentry_slot_in, sw_qentry_slot_in;
    wire [127:0] issued_qentries;
    wire [15:0] qentries_out;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m0(.in({8'h00,qentry_slot_in}), .sel(rdsw_in), .out(rd_qentry_slot_in));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m1(.in({qentry_slot_in,8'h00}), .sel(rdsw_in), .out(sw_qentry_slot_in));
    
    inv1$ g0(.out(moveq), .in(dealloc_valid));
    inv1$ g1(.out(invdealloc), .in(dealloc));

    queuenm #(.M_WIDTH(28), .N_WIDTH(1), .Q_LENGTH(8)) q0(.m_din({1'b1,pAddress[14:4],rd_qentry_slot_in,sw_qentry_slot_in}), .n_din(1'b1),
                                                          .new_m_vector(change_reqs), .wr(alloc), .rd(moveq),
                                                          .modify_vector(update_vector), .clr(clr), .clk(clk),
                                                          .full(mshr_full), .empty(), .old_m_vector(issued_reqs),
                                                          .dout({dealloc_valid,dealloc_paddr,dealloc_qentries,dealloc_n_spacer}));

    muxnm_tristate #(.NUM_INPUTS(9), .DATA_WIDTH(16)) m2(.in({issued_qentries,16'h0000}), .sel({return_vector,invdealloc}), .out(rd_qentry_slots_out,sw_qentry_slots_out));

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : m_slices
            equaln #(.WIDTH(11)) eq0(.a(pAddress[14:4]), .b(issued_reqs[i*28 + 26:i*28 + 16]), .eq(match_vector[i]));
            
            and2$ g2(.out(hit_vector[i]), .in0(match_vector[i]), .in1(issued_reqs[i*28 + 27]));
            and2$ g3(.out(return_vector[i]), .in0(hit_vector[i]), .in1(dealloc));

            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m4(.in({1'b0,issued_reqs[i*28 + 27]}), .sel(return_vector[i]), .out(change_reqs[i*28 + 27]));
            assign change_reqs[i*28 + 26:i*28 + 16] = issued_reqs[i*28 + 26:i*28 + 16];
            or2$ g4(.out(change_reqs[i*28 + 15]), .in0(issued_reqs[i*28 + 15]), .in1(rd_qentry_slot_in[7]));
            or2$ g5(.out(change_reqs[i*28 + 14]), .in0(issued_reqs[i*28 + 14]), .in1(rd_qentry_slot_in[6]));
            or2$ g6(.out(change_reqs[i*28 + 13]), .in0(issued_reqs[i*28 + 13]), .in1(rd_qentry_slot_in[5]));
            or2$ g7(.out(change_reqs[i*28 + 12]), .in0(issued_reqs[i*28 + 12]), .in1(rd_qentry_slot_in[4]));
            or2$ g8(.out(change_reqs[i*28 + 11]), .in0(issued_reqs[i*28 + 11]), .in1(rd_qentry_slot_in[3]));
            or2$ g9(.out(change_reqs[i*28 + 10]), .in0(issued_reqs[i*28 + 10]), .in1(rd_qentry_slot_in[2]));
            or2$ g10(.out(change_reqs[i*28 + 9]), .in0(issued_reqs[i*28 + 9]), .in1(rd_qentry_slot_in[1]));
            or2$ g11(.out(change_reqs[i*28 + 8]), .in0(issued_reqs[i*28 + 8]), .in1(rd_qentry_slot_in[0]));
            or2$ g12(.out(change_reqs[i*28 + 7]), .in0(issued_reqs[i*28 + 7]), .in1(sw_qentry_slot_in[7]));
            or2$ g13(.out(change_reqs[i*28 + 6]), .in0(issued_reqs[i*28 + 6]), .in1(sw_qentry_slot_in[6]));
            or2$ g14(.out(change_reqs[i*28 + 5]), .in0(issued_reqs[i*28 + 5]), .in1(sw_qentry_slot_in[5]));
            or2$ g15(.out(change_reqs[i*28 + 4]), .in0(issued_reqs[i*28 + 4]), .in1(sw_qentry_slot_in[4]));
            or2$ g16(.out(change_reqs[i*28 + 3]), .in0(issued_reqs[i*28 + 3]), .in1(sw_qentry_slot_in[3]));
            or2$ g17(.out(change_reqs[i*28 + 2]), .in0(issued_reqs[i*28 + 2]), .in1(sw_qentry_slot_in[2]));
            or2$ g18(.out(change_reqs[i*28 + 1]), .in0(issued_reqs[i*28 + 1]), .in1(sw_qentry_slot_in[1]));
            or2$ g19(.out(change_reqs[i*28 + 0]), .in0(issued_reqs[i*28 + 0]), .in1(sw_qentry_slot_in[0]));

            assign issued_qentries[16*(i+1)-1:16*i] = issued_reqs[i*28+15:i*28];

            or2$ g20(.out(update_vector[i]), .in0(invalidation_vector[i]), .in1(hit_vector[i]));
        end
    endgenerate

    orn #(.NUM_INPUTS(8)) g21(.in(hit_vector), .out(mshr_hit));

endmodule


module mshrio (input [14:0] pAddress, //this shouldve been 11 bits but too late to change now
               input [6:0] ptcid_in,
               input [7:0] qentry_slot_in,
               input rdsw_in,
               input alloc, dealloc,

               input clk, clr,
             
               output [7:0] rd_qentry_slots_out, sw_qentry_slots_out,
               output mshr_hit, mshr_full);
    
    wire [223:0] issued_reqs, change_reqs;
    wire [7:0] update_vector, invalidation_vector, match_vector_send, match_vector_recv, hit_vector;

    wire dealloc_valid;
    wire [10:0] dealloc_paddr;
    wire [15:0] dealloc_qentries;
    wire dealloc_n_spacer;

    wire [7:0] rd_qentry_slot_in, sw_qentry_slot_in;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m0(.in({8'h00,qentry_slot_in}), .sel(rdsw_in), .out(rd_qentry_slot_in));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m1(.in({qentry_slot_in,8'h00}), .sel(rdsw_in), .out(sw_qentry_slot_in));
    
    queuenm #(.M_WIDTH(28), .N_WIDTH(1), .Q_LENGTH(8)) q0(.m_din({1'b1,pAddress[14:4],rd_qentry_slot_in,sw_qentry_slot_in}), .n_din(1'b1),
                                                          .new_m_vector(change_reqs), .wr(alloc), .rd(dealloc),
                                                          .modify_vector(update_vector), .clr(clr), .clk(clk),
                                                          .full(mshr_full), .empty(), .old_m_vector(issued_reqs),
                                                          .dout({dealloc_valid,dealloc_paddr,dealloc_qentries,dealloc_n_spacer}));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(16)) m2(.in({dealloc_qentries,16'h00}), .sel(dealloc), .out({rd_qentry_slots_out,sw_qentry_slots_out}));

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : m_slices
            equaln #(.WIDTH(11)) eq0(.a(dealloc_paddr), .b(issued_reqs[i*28 + 26:i*28 + 16]), .eq(match_vector_recv[i]));
            and3$ g3(.out(invalidation_vector[i]), .in0(match_vector_recv[i]), .in1(issued_reqs[i*28 + 27]), .in2(dealloc));
            equaln #(.WIDTH(11)) eq1(.a(pAddress[14:4]), .b(issued_reqs[i*28 + 26:i*28 + 16]), .eq(match_vector_send[i]));
            and2$ g4(.out(hit_vector[i]), .in0(match_vector_send[i]), .in1(issued_reqs[i*28 + 27]));

            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m4(.in({1'b0,issued_reqs[i*28 + 27]}), .sel(invalidation_vector[i]), .out(change_reqs[i*28 + 27]));
            assign change_reqs[i*28 + 26:i*28 + 16] = issued_reqs[i*28 + 26:i*28 + 16];
            or2$ g5(.out(change_reqs[i*28 + 15]), .in0(issued_reqs[i*28 + 15]), .in1(rd_qentry_slot_in[7]));
            or2$ g6(.out(change_reqs[i*28 + 14]), .in0(issued_reqs[i*28 + 14]), .in1(rd_qentry_slot_in[6]));
            or2$ g7(.out(change_reqs[i*28 + 13]), .in0(issued_reqs[i*28 + 13]), .in1(rd_qentry_slot_in[5]));
            or2$ g8(.out(change_reqs[i*28 + 12]), .in0(issued_reqs[i*28 + 12]), .in1(rd_qentry_slot_in[4]));
            or2$ g9(.out(change_reqs[i*28 + 11]), .in0(issued_reqs[i*28 + 11]), .in1(rd_qentry_slot_in[3]));
            or2$ g10(.out(change_reqs[i*28 + 10]), .in0(issued_reqs[i*28 + 10]), .in1(rd_qentry_slot_in[2]));
            or2$ g11(.out(change_reqs[i*28 + 9]), .in0(issued_reqs[i*28 + 9]), .in1(rd_qentry_slot_in[1]));
            or2$ g12(.out(change_reqs[i*28 + 8]), .in0(issued_reqs[i*28 + 8]), .in1(rd_qentry_slot_in[0]));
            or2$ g13(.out(change_reqs[i*28 + 7]), .in0(issued_reqs[i*28 + 7]), .in1(sw_qentry_slot_in[7]));
            or2$ g14(.out(change_reqs[i*28 + 6]), .in0(issued_reqs[i*28 + 6]), .in1(sw_qentry_slot_in[6]));
            or2$ g15(.out(change_reqs[i*28 + 5]), .in0(issued_reqs[i*28 + 5]), .in1(sw_qentry_slot_in[5]));
            or2$ g16(.out(change_reqs[i*28 + 4]), .in0(issued_reqs[i*28 + 4]), .in1(sw_qentry_slot_in[4]));
            or2$ g17(.out(change_reqs[i*28 + 3]), .in0(issued_reqs[i*28 + 3]), .in1(sw_qentry_slot_in[3]));
            or2$ g18(.out(change_reqs[i*28 + 2]), .in0(issued_reqs[i*28 + 2]), .in1(sw_qentry_slot_in[2]));
            or2$ g19(.out(change_reqs[i*28 + 1]), .in0(issued_reqs[i*28 + 1]), .in1(sw_qentry_slot_in[1]));
            or2$ g20(.out(change_reqs[i*28 + 0]), .in0(issued_reqs[i*28 + 0]), .in1(sw_qentry_slot_in[0]));

            or2$ g21(.out(update_vector[i]), .in0(invalidation_vector[i]), .in1(hit_vector[i]));
        end
    endgenerate

    orn #(.NUM_INPUTS(8)) g22(.in(hit_vector), .out(mshr_hit));

endmodule