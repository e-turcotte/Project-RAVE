module cacheaqsys (input [14:0] rd_pAddress_e, rd_pAddress_o, sw_pAddress_e, sw_pAddress_o, wb_pAddress_e, wb_pAddress_o, bus_pAddress_e, bus_pAddress_o,
                   input [16*8-1:0] wb_data_e, wb_data_o, bus_data_e, bus_data_o,
                   input [1:0] rd_size_e, rd_size_o, sw_size_e, sw_size_o, wb_size_e, wb_size_o,
                   input rd_valid_e, rd_valid_o, sw_valid_e, sw_valid_o, wb_valid_e, wb_valid_o, bus_valid_e, bus_valid_o,
                   input [16*8-1:0] wb_mask_e, wb_mask_o,
                   input [6:0] rd_ptcid, sw_ptcid, wb_ptcid,
                   input rd_odd_is_greater, sw_odd_is_greater, wb_odd_is_greater,
                   input rd_needP1, sw_needP1, wb_needP1,
                   input [2:0] rd_onesize, sw_onesize, wb_onesize,
                   input rd_pcd, sw_pcd, wb_pcd, bus_pcd,
                   input bus_isempty,
                   
                   input read, rd_write, sw_write, wb_write,
                   
                   input clk, clr,
                   
                   output [14:0] pAddress_e, pAddress_o,
                   output [16*8-1:0] data_e, data_o,
                   output [1:0] size_e, size_o,
                   output r, w, sw,
                   output valid_e, valid_o,
                   output fromBUS,
                   output [16*8-1:0] mask_e, mask_o,
                   output [6:0] ptcid,
                   output odd_is_greater,
                   output [2:0] onesize,
                   output pcd,

                   output aq_isempty, rdaq_isfull, swaq_isfull, wbaq_isfull);

    wire rd_read, sw_read, wb_read;

    wire [560:0] rdaq_out, swaq_out, wbaq_out, bus_out;
    wire rdaq_isempty, swaq_isempty, wbaq_isempty;

    aq rdaq(.pAddress_e_in(rd_pAddress_e), .pAddress_o_in(rd_pAddress_o), .data_e_in(), .data_o_in(),
            .size_e_in(rd_size_e), .size_o_in(rd_size_o), .valid_e_in(rd_valid_e), .valid_o_in(rd_valid_o),
            .mask_e_in(128'b0), .mask_o_in(128'b0), .ptcid_in(rd_ptcid), .odd_is_greater_in(rd_odd_is_greater),
            .needP1_in(rd_needP1), .onesize_in(rd_onesize), .pcd_in(rd_pcd),
            .read(rd_read), .write(rd_write),
            .clk(clk), .clr(clr),
            .aq_out(rdaq_out),
            .aq_isempty(rdaq_isempty), .aq_isfull(rdaq_isfull));

    aq swaq(.pAddress_e_in(sw_pAddress_e), .pAddress_o_in(sw_pAddress_o), .data_e_in(), .data_o_in(),
            .size_e_in(sw_size_e), .size_o_in(sw_size_o), .valid_e_in(sw_valid_e), .valid_o_in(sw_valid_o),
            .mask_e_in(128'b0), .mask_o_in(128'b0), .ptcid_in(sw_ptcid), .odd_is_greater_in(sw_odd_is_greater),
            .needP1_in(sw_needP1), .onesize_in(sw_onesize), .pcd_in(sw_pcd),
            .read(sw_read), .write(sw_write),
            .clk(clk), .clr(clr),
            .aq_out(swaq_out),
            .aq_isempty(swaq_isempty), .aq_isfull(swaq_isfull));

    aq wbaq(.pAddress_e_in(wb_pAddress_e), .pAddress_o_in(wb_pAddress_o), .data_e_in(wb_data_e), .data_o_in(wb_data_o),
            .size_e_in(wb_size_e), .size_o_in(wb_size_o), .valid_e_in(wb_valid_e), .valid_o_in(wb_valid_o),
            .mask_e_in(wb_mask_e), .mask_o_in(wb_mask_o), .ptcid_in(wb_ptcid), .odd_is_greater_in(wb_odd_is_greater),
            .needP1_in(wb_needP1), .onesize_in(wb_onesize), .pcd_in(wb_pcd),
            .read(wb_read), .write(wb_write),
            .clk(clk), .clr(clr),
            .aq_out(wbaq_out),
            .aq_isempty(wbaq_isempty), .aq_isfull(wbaq_isfull));

    assign bus_out = {bus_valid_e,bus_valid_o,bus_pAddress_e,bus_pAddress_o,bus_data_e,bus_data_o,
                      4'h0,{256{1'b1}},7'b0000000,1'b0,1'b0,3'b000,bus_pcd};

    wire bus_ready, wb_ready, sw_ready;

    inv1$ g0(.out(bus_ready), .in(bus_isempty));
    inv1$ g1(.out(wb_ready), .in(wbaq_isempty));
    inv1$ g2(.out(sw_ready), .in(swaq_isempty));

    wire [560:0] rdswout, coreout;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(561)) m0(.in({swaq_out,rdaq_out}), .sel(sw_ready), .out(rdswout));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(561)) m1(.in({wbaq_out,rdswout}), .sel(wb_ready), .out(coreout));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(561)) m2(.in({bus_out,coreout}), .sel(bus_ready), .out({valid_e,valid_o,
                                                                                                    pAddress_e,pAddress_o,
                                                                                                    data_e,data_o,
                                                                                                    size_e,size_o,
                                                                                                    mask_e,mask_o,
                                                                                                    ptcid,
                                                                                                    odd_is_greater,
                                                                                                    needP1,
                                                                                                    onesize,
                                                                                                    pcd}));

    wire [3:0] rdswstat, corestat;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(4)) m3(.in({4'b0010,4'b0001}), .sel(sw_ready), .out(rdswstat));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(4)) m4(.in({4'b0100,rdswstat}), .sel(wb_ready), .out(corestat));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(4)) m5(.in({4'b1000,corestat}), .sel(bus_ready), .out({fromBUS,w,sw,r}));

    and4$ g3(.out(aq_isempty), .in0(bus_isempty), .in1(wbaq_isempty), .in2(swaq_isempty), .in3(rdaq_isempty));

    and2$ g4(.out(wb_read), .in0(read), .in1(w));
    and2$ g5(.out(sw_read), .in0(read), .in1(sw));
    and2$ g6(.out(rd_read), .in0(read), .in1(r));

endmodule



module aq (input [14:0] pAddress_e_in, pAddress_o_in,
           input [16*8-1:0] data_e_in, data_o_in,
           input [1:0] size_e_in, size_o_in,
           input valid_e_in, valid_o_in,
           input [16*8-1:0] mask_e_in, mask_o_in,
           input [6:0] ptcid_in,
           input odd_is_greater_in,
           input needP1_in,
           input [2:0] onesize_in,
           input pcd_in,
 
           input read, write,

           input clk, clr,

           output [560:0] aq_out,
           
           output aq_isempty, aq_isfull);

    queuenm #(.M_WIDTH(2), .N_WIDTH(559), .Q_LENGTH(4)) q(.m_din({valid_e_in,valid_o_in}),
                                                          .n_din({pAddress_e_in,pAddress_o_in,
                                                                  data_e_in,data_o_in,
                                                                  size_e_in,size_o_in,
                                                                  mask_e_in,mask_o_in,
                                                                  ptcid_in,
                                                                  odd_is_greater_in,
                                                                  needP1_in,
                                                                  onesize_in,
                                                                  pcd_in}),
                                                          .new_m_vector(),
                                                          .wr(write), .rd(read),
                                                          .modify_vector(4'h0),
                                                          .clr(clr), .clk(clk),
                                                          .full(aq_isfull), .empty(aq_isempty),
                                                          .old_m_vector(),
                                                          .dout(aq_out));
 
endmodule