module queuenm #(parameter M_WIDTH=8, N_WIDTH=8, Q_LENGTH=16) (input [M_WIDTH-1:0] m_din,
                                                               input [N_WIDTH-1:0] n_din,
                                                               input [M_WIDTH*Q_LENGTH-1:0] new_m_vector,
                                                               input wr, rd,
                                                               input [Q_LENGTH-1:0] modify_vector,
                                                               input clr,
                                                               input clk,
                                                               output full, empty,
                                                               output [M_WIDTH*Q_LENGTH-1:0] old_m_vector,
                                                               output [M_WIDTH+N_WIDTH-1:0] dout);
    
    wire [Q_LENGTH-1:0] ptr_wr, new_ptr_wr, shf_ptr_wr, ptr_rd, new_ptr_rd, shf_ptr_rd;
    wire invclr, ldptr_wr, ldptr_rd;

    inv1$ g0(.out(invclr), .in(clr));
    or2$ g1(.out(ldptr_wr), .in0(wr), .in1(invclr));
    or2$ g2(.out(ldptr_rd), .in0(rd), .in1(invclr));

    regn #(.WIDTH(Q_LENGTH)) ptr_wr_reg(.din(new_ptr_wr), .ld(ldptr_wr), .clr(1'b1), .clk(clk), .dout(ptr_wr));
    regn #(.WIDTH(Q_LENGTH)) ptr_rd_reg(.din(new_ptr_rd), .ld(ldptr_rd), .clr(1'b1), .clk(clk), .dout(ptr_rd));

    lshfn_fixed #(.WIDTH(Q_LENGTH), .SHF_AMNT(1)) s0(.in(ptr_wr), .shf_val(1'b0), .out(shf_ptr_wr));
    lshfn_fixed #(.WIDTH(Q_LENGTH), .SHF_AMNT(1)) s1(.in(ptr_rd), .shf_val(1'b0), .out(shf_ptr_rd));
    
    equaln #(.WIDTH(Q_LENGTH)) e0(.a(ptr_rd), .b(ptr_wr), .eq(empty));
    equaln #(.WIDTH(Q_LENGTH)) e1(.a(ptr_rd), .b(shf_ptr_wr), .eq(full));

    muxnm_tree #(.SEL_WIDTH(2), .DATA_WIDTH(Q_LENGTH)) m0(.in({{(Q_LENGTH-1){1'b0}},1'b1,{(Q_LENGTH-1){1'b0}},1'b1,ptr_rd,shf_ptr_rd}), .sel({clr,empty}), .out(new_ptr_rd));
    muxnm_tree #(.SEL_WIDTH(2), .DATA_WIDTH(Q_LENGTH)) m1(.in({{(Q_LENGTH-1){1'b0}},1'b1,{(Q_LENGTH-1){1'b0}},1'b1,ptr_wr,shf_ptr_wr}), .sel({clr,full}), .out(new_ptr_wr));


    wire [(M_WIDTH+N_WIDTH)*Q_LENGTH-1:0] outs;

    genvar i;
    generate
        for (i = 0; i < Q_LENGTH; i = i + 1) begin : queue_slices
            wire ld;
            and2$ g3(.out(ld), .in0(wr), .in1(ptr_wr[i]));
            qentry #(.M_WIDTH(M_WIDTH), .N_WIDTH(N_WIDTH)) q0(.m_din(m_din), .n_din(n_din), .new_m(new_m_vector[(i+1)*M_WIDTH-1:i*M_WIDTH]), .ld(ld), .modify(modify_vector[i]), .clr(clr), .clk(clk), .old_m(old_m_vector[(i+1)*M_WIDTH-1:i*M_WIDTH]), .dout(outs[(i+1)*(M_WIDTH+N_WIDTH)-1:i*(M_WIDTH+N_WIDTH)]));
        end
    endgenerate


    muxnm_tristate #(.NUM_INPUTS(Q_LENGTH), .DATA_WIDTH(M_WIDTH+N_WIDTH)) m2(.in(outs), .sel(ptr_rd), .out(dout));

endmodule

module qentry #(parameter M_WIDTH=8, N_WIDTH=8) (input [M_WIDTH-1:0] m_din, 
                                                 input [N_WIDTH-1:0] n_din,
                                                 input [M_WIDTH-1:0] new_m,
                                                 input ld, modify, clr,
                                                 input clk,
                                                 output [M_WIDTH-1:0] old_m,
                                                 output [M_WIDTH+N_WIDTH-1:0] dout);
    
    wire [M_WIDTH-1:0] mdata;
    wire m_ld;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(M_WIDTH)) m0(.in({m_din,new_m}), .sel(ld), .out(mdata));
    or2$ g0(.out(m_ld), .in0(ld), .in1(modify));
    
    regn #(.WIDTH(M_WIDTH)) m_section(.din(mdata), .ld(m_ld), .clr(clr), .clk(clk), .dout(old_m));
    regn #(.WIDTH(N_WIDTH)) n_section(.din(n_din), .ld(ld), .clr(clr), .clk(clk), .dout(dout[N_WIDTH-1:0]));
    assign dout[M_WIDTH+N_WIDTH-1:N_WIDTH] = old_m;

endmodule