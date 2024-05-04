module brq (input [3:0] send3, send2, send1, send0,
            input [3:0] dest3, dest2, dest1, dest0,
            input req3, req2, req1, req0,
            input free4, free3, free2, free1, free0,
            input pull,
            
            input clk, clr,
            
            output ack3, ack2, ack1, ack0,
            output valid,
            output [3:0] send_out);

    wire [3:0] arb_wr_vector, arb_rd_vector;
    wire [7:0] req_in;
    wire incoming_reqs;

    arbiter a0(.in({req3,req2,req1,req0}), .out(arb_wr_vector));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m0(.in({send3,dest3,send2,dest2,send1,dest1,send0,dest0}), .sel(arb_wr_vector), .out(req_in));
    or4$ g0(.out(incoming_reqs), .in0(req3), .in1(req2), .in2(req1), .in3(req0));

    wire rempty [0:3], rld [0:3];
    wire [8:0] rout [0:3];

    regn #(.WIDTH(9)) r0(.din({incoming_reqs,req_in}), .ld(rld[0]), .clr(clr), .clk(clk), .dout(rout[0]));
    regn #(.WIDTH(9)) r1(.din(rout[0]), .ld(rld[1]), .clr(clr), .clk(clk), .dout(rout[1]));
    regn #(.WIDTH(9)) r2(.din(rout[1]), .ld(rld[2]), .clr(clr), .clk(clk), .dout(rout[2]));
    regn #(.WIDTH(9)) r3(.din(rout[2]), .ld(rld[3]), .clr(clr), .clk(clk), .dout(rout[3]));

    wire [3:0] ready_vector;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : queue_slices
            
            wire readydma, ready3, ready2, ready1, ready0;
            wire invsubd1, invsubd0;

            inv1$ g1(.out(invsubd1), .in(rout[i][1]));
            inv1$ g2(.out(invsubd0), .in(rout[i][0]));

            andn #(.NUM_INPUTS(5)) g3(.in({rout[i][3],rout[i][2],rout[i][8],free4,pull}), .out(readydma));
            andn #(.NUM_INPUTS(5)) g4(.in({rout[i][1],rout[i][0],rout[i][8],free3,pull}), .out(ready3));
            andn #(.NUM_INPUTS(5)) g5(.in({rout[i][1],invsubd0,rout[i][8],free2,pull}), .out(ready2));
            andn #(.NUM_INPUTS(5)) g6(.in({invsubd1,rout[i][0],rout[i][8],free1,pull}), .out(ready1));
            andn #(.NUM_INPUTS(5)) g7(.in({invsubd1,invsubd0,rout[i][8],free0,pull}), .out(ready0));

            orn #(.NUM_INPUTS(5)) g8(.in({readydma,ready3,ready2,ready1,ready0}), .out(ready_vector[i]));

        end
    endgenerate    

    arbiter a1(.in(ready_vector), .out(arb_rd_vector));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(4)) m1(.in({rout[3][7:4],rout[2][7:4],rout[1][7:4],rout[0][7:4]}), .out(send_out));

    wire invvalid3, invvalid2, invvalid1, invvalid0;

    inv1$ g9(.out(invvalid3), .in(rout[3][8]));
    inv1$ g10(.out(invvalid2), .in(rout[2][8]));
    inv1$ g11(.out(invvalid1), .in(rout[1][8]));
    inv1$ g12(.out(invvalid0), .in(rout[0][8]));


    or2$ g13(.out(rld[3]), .in0(invvalid3), .in1(arb_rd_vector[3]));
    or4$ g14(.out(rld[2]), .in0(invvalid3), .in1(invvalid2), .in2(arb_rd_vector[3]), .in3(arb_rd_vector[2]));
    orn #(.NUM_INPUTS(6)) g15(.in({invvalid3,invvalid2,invvalid1,arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1]}), .out(rld[1]));
    orn #(.NUM_INPUTS(8)) g16(.in({invvalid3,invvalid2,invvalid1,invvalid0,arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1],arb_rd_vector[0]}), .out(rld[0]));

    and2$ g17(.out(ack3), .in0(arb_wr_vector[3]), .in1(rld[0]));
    and2$ g18(.out(ack2), .in0(arb_wr_vector[2]), .in1(rld[0]));
    and2$ g19(.out(ack1), .in0(arb_wr_vector[1]), .in1(rld[0]));
    and2$ g20(.out(ack0), .in0(arb_wr_vector[0]), .in1(rld[0]));

endmodule
