module brq (input [3:0] destIE, destIO, destDE, destDO, destB0, destB1, destB2, destB3, destDMA,
            input reqIE, reqIO, reqDE, reqDO, reqB0, reqB1, reqB2, reqB3, reqDMA,
            input freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA,
            input pull,
            
            input clk, clr,
            
            output ackIE, ackIO, ackDE, ackDO, ackB0, ackB1, ackB2, ackB3, ackDMA,
            output req_ready,
            output [3:0] send_out);

    wire [8:0] arb_wr_vector, arb_rd_vector;
    wire [7:0] req_in;
    wire incoming_reqs;

    arbiter a0(.in({reqDMA,reqIE,reqIO,reqDE,reqDO,reqB0,reqB1,reqB2,reqB3}), .out(arb_wr_vector));
    muxnm_tristate #(.NUM_INPUTS(9), .DATA_WIDTH(8)) m0(.in({4'hc,destDMA,4'h2,destIE,4'h1,destIO,4'h6,destDE,4'h5,destDO,4'h8,destB0,4'h9,destB1,4'ha,destB2,4'hb,destB3}), .sel(arb_wr_vector), .out(req_in));
    orn #(.NUM_INPUTS(9)) g0(.in({reqIE,reqIO,reqDE,reqDO,reqB0,reqB1,reqB2,reqB3,reqDMA}), .out(incoming_reqs));

    and2$ g1(.out(ackDMA), .in0(arb_wr_vector[8]), .in1(rld[0]));
    and2$ g2(.out(ackIE), .in0(arb_wr_vector[7]), .in1(rld[0]));
    and2$ g3(.out(ackIO), .in0(arb_wr_vector[6]), .in1(rld[0]));
    and2$ g4(.out(ackDE), .in0(arb_wr_vector[5]), .in1(rld[0]));
    and2$ g5(.out(ackDO), .in0(arb_wr_vector[4]), .in1(rld[0]));
    and2$ g6(.out(ackB0), .in0(arb_wr_vector[3]), .in1(rld[0]));
    and2$ g7(.out(ackB1), .in0(arb_wr_vector[2]), .in1(rld[0]));
    and2$ g8(.out(ackB2), .in0(arb_wr_vector[1]), .in1(rld[0]));
    and2$ g9(.out(ackB3), .in0(arb_wr_vector[0]), .in1(rld[0]));

    wire rempty [0:3], rld [0:8];
    wire [8:0] rout [0:8];

    regn #(.WIDTH(9)) r0(.din({incoming_reqs,req_in}), .ld(rld[0]), .clr(clr), .clk(clk), .dout(rout[0]));
    regn #(.WIDTH(9)) r1(.din(rout[0]), .ld(rld[1]), .clr(clr), .clk(clk), .dout(rout[1]));
    regn #(.WIDTH(9)) r2(.din(rout[1]), .ld(rld[2]), .clr(clr), .clk(clk), .dout(rout[2]));
    regn #(.WIDTH(9)) r3(.din(rout[2]), .ld(rld[3]), .clr(clr), .clk(clk), .dout(rout[3]));
    regn #(.WIDTH(9)) r4(.din(rout[3]), .ld(rld[4]), .clr(clr), .clk(clk), .dout(rout[4]));
    regn #(.WIDTH(9)) r5(.din(rout[4]), .ld(rld[5]), .clr(clr), .clk(clk), .dout(rout[5]));
    regn #(.WIDTH(9)) r6(.din(rout[5]), .ld(rld[6]), .clr(clr), .clk(clk), .dout(rout[6]));
    regn #(.WIDTH(9)) r7(.din(rout[6]), .ld(rld[7]), .clr(clr), .clk(clk), .dout(rout[7]));
    regn #(.WIDTH(9)) r8(.din(rout[7]), .ld(rld[8]), .clr(clr), .clk(clk), .dout(rout[8]));

    wire [8:0] ready_vector;
    wire invvalid [0:8];

    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin : queue_slices
            
            wire readyIE, readyIO, readyDE, readyDO, readyB0, readyB1, readyB2, readyB3, readyDMA;
            wire invdom1, invdom0, invsubdom1, invsubdom0;
            
            inv1$ g1(.out(invdom1), .in(rout[i][3]));
            inv1$ g2(.out(invdom0), .in(rout[i][2]));
            inv1$ g3(.out(invsubdom1), .in(rout[i][1]));
            inv1$ g4(.out(invsubdom0), .in(rout[i][0]));

            andn #(.NUM_INPUTS(7)) g10(.in({rout[i][8],invdom1,invdom0,rout[i][1],invsubdom0,freeIE,pull}), .out(readyIE));
            andn #(.NUM_INPUTS(7)) g11(.in({rout[i][8],invdom1,invdom0,invsubdom1,rout[i][0],freeIO,pull}), .out(readyIO));
            andn #(.NUM_INPUTS(7)) g12(.in({rout[i][8],invdom1,rout[i][2],rout[i][1],invsubdom0,freeDE,pull}), .out(readyDE));
            andn #(.NUM_INPUTS(7)) g13(.in({rout[i][8],invdom1,rout[i][2],invsubdom1,rout[i][0],freeDO,pull}), .out(readyDO));
            andn #(.NUM_INPUTS(7)) g14(.in({rout[i][8],rout[i][3],invdom0,invsubdom1,invsubdom0,freeB0,pull}), .out(readyB0));
            andn #(.NUM_INPUTS(7)) g15(.in({rout[i][8],rout[i][3],invdom0,invsubdom1,rout[i][0],freeB1,pull}), .out(readyB1));
            andn #(.NUM_INPUTS(7)) g16(.in({rout[i][8],rout[i][3],invdom0,rout[i][1],invsubdom0,freeB2,pull}), .out(readyB2));
            andn #(.NUM_INPUTS(7)) g17(.in({rout[i][8],rout[i][3],invdom0,rout[i][1],rout[i][0],freeB3,pull}), .out(readyB3));
            andn #(.NUM_INPUTS(7)) g18(.in({rout[i][8],rout[i][3],rout[i][2],invsubdom1,invsubdom0,freeDMA,pull}), .out(readyDMA));

            orn #(.NUM_INPUTS(9)) g19(.in({readyIE,readyIO,readyDE,readyDO,readyB0,readyB1,readyB2,readyB3,readyDMA}), .out(ready_vector[i]));
            
            inv1$ g20(.out(invvalid[i]), .in(rout[i][8]));

        end
    endgenerate    

    arbiter a1(.in(ready_vector), .out(arb_rd_vector));
    muxnm_tristate #(.NUM_INPUTS(9), .DATA_WIDTH(4)) m1(.in({rout[8][7:4],rout[7][7:4],rout[6][7:4],rout[5][7:4],rout[4][7:4],rout[3][7:4],rout[2][7:4],rout[1][7:4],rout[0][7:4]}), .sel(arb_rd_vector), .out(send_out));

    orn #(.NUM_INPUTS(2)) g21(.in({invvalid[8],arb_rd_vector[8]}), .out(rld[8]));
    orn #(.NUM_INPUTS(4)) g22(.in({invvalid[8],invvalid[7],arb_rd_vector[8],arb_rd_vector[7]}), .out(rld[7]));
    orn #(.NUM_INPUTS(6)) g23(.in({invvalid[8],invvalid[7],invvalid[6],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6]}), .out(rld[6]));
    orn #(.NUM_INPUTS(8)) g24(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5]}), .out(rld[5]));
    orn #(.NUM_INPUTS(10)) g25(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4]}), .out(rld[4]));
    orn #(.NUM_INPUTS(12)) g26(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3]}), .out(rld[3]));
    orn #(.NUM_INPUTS(14)) g27(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2]}), .out(rld[2]));
    orn #(.NUM_INPUTS(16)) g28(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],invvalid[1],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1]}), .out(rld[1]));
    orn #(.NUM_INPUTS(18)) g29(.in({invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],invvalid[1],invvalid[0],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1],arb_rd_vector[0]}), .out(rld[0]));

    orn #(.NUM_INPUTS(9)) g30(.in(ready_vector), .out(req_ready));

endmodule



module arbiter(input [8:0] in,
               output [8:0] out);

    wire inv [1:8];
    inv1$ g0(.out(inv[8]), .in(in[8]));
    inv1$ g1(.out(inv[7]), .in(in[7]));
    inv1$ g2(.out(inv[6]), .in(in[6]));
    inv1$ g3(.out(inv[5]), .in(in[5]));
    inv1$ g4(.out(inv[4]), .in(in[4]));
    inv1$ g5(.out(inv[3]), .in(in[3]));
    inv1$ g6(.out(inv[2]), .in(in[2]));
    inv1$ g7(.out(inv[1]), .in(in[1]));

    assign out[8] = in[8];
    andn #(.NUM_INPUTS(2)) g8(.in({in[7],inv[8]}), .out(out[7]));
    andn #(.NUM_INPUTS(3)) g9(.in({in[6],inv[8],inv[7]}), .out(out[6]));
    andn #(.NUM_INPUTS(4)) g10(.in({in[5],inv[8],inv[7],inv[6]}), .out(out[5]));
    andn #(.NUM_INPUTS(5)) g11(.in({in[4],inv[8],inv[7],inv[6],inv[5]}), .out(out[4]));
    andn #(.NUM_INPUTS(6)) g12(.in({in[3],inv[8],inv[7],inv[6],inv[5],inv[4]}), .out(out[3]));
    andn #(.NUM_INPUTS(7)) g13(.in({in[2],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3]}), .out(out[2]));
    andn #(.NUM_INPUTS(8)) g14(.in({in[1],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3],inv[2]}), .out(out[1]));
    andn #(.NUM_INPUTS(9)) g15(.in({in[0],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3],inv[2],inv[1]}), .out(out[0]));

endmodule
