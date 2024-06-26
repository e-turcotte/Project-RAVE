module brq (input [87:0] req_data,
            input [10:0] req,
            input freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA,
            input pull,
            
            input clk, clr,
            
            output [10:0] ack,
            output req_ready,
            output [3:0] send_out, dest_out);

    wire [10:0] arb_wr_vector, arb_rd_vector;
    wire [7:0] req_in;
    wire incoming_reqs;
    wire [0:10] rld;
    arbiter a0(.in({req}), .out(arb_wr_vector));
    muxnm_tristate #(.NUM_INPUTS(11), .DATA_WIDTH(8)) m0(.in({req_data}), .sel(arb_wr_vector), .out(req_in));
    orn #(.NUM_INPUTS(11)) g0(.in({req}), .out(incoming_reqs));

    and2$ g1(.out(ack[10]), .in0(arb_wr_vector[10]), .in1(rld[0]));
    and2$ g2(.out(ack[9]), .in0(arb_wr_vector[9]), .in1(rld[0]));
    and2$ g3(.out(ack[8]), .in0(arb_wr_vector[8]), .in1(rld[0]));
    and2$ g4(.out(ack[7]), .in0(arb_wr_vector[7]), .in1(rld[0])); 
    and2$ g5(.out(ack[6]), .in0(arb_wr_vector[6]), .in1(rld[0]));
    and2$ g6(.out(ack[5]), .in0(arb_wr_vector[5]), .in1(rld[0])); 
    and2$ g7(.out(ack[4]), .in0(arb_wr_vector[4]), .in1(rld[0]));
    and2$ g8(.out(ack[3]), .in0(arb_wr_vector[3]), .in1(rld[0]));
    and2$ g9(.out(ack[2]), .in0(arb_wr_vector[2]), .in1(rld[0]));
    and2$ g10(.out(ack[1]), .in0(arb_wr_vector[1]), .in1(rld[0]));
    and2$ g11(.out(ack[0]), .in0(arb_wr_vector[0]), .in1(rld[0]));

    
    wire [8:0] rout [10:0];
    wire [9:0] valid_pass;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr0(.in({1'b0,rout[0][8]}), .sel(arb_rd_vector[0]), .out(valid_pass[0]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr1(.in({1'b0,rout[1][8]}), .sel(arb_rd_vector[1]), .out(valid_pass[1]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr2(.in({1'b0,rout[2][8]}), .sel(arb_rd_vector[2]), .out(valid_pass[2]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr3(.in({1'b0,rout[3][8]}), .sel(arb_rd_vector[3]), .out(valid_pass[3]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr4(.in({1'b0,rout[4][8]}), .sel(arb_rd_vector[4]), .out(valid_pass[4]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr5(.in({1'b0,rout[5][8]}), .sel(arb_rd_vector[5]), .out(valid_pass[5]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr6(.in({1'b0,rout[6][8]}), .sel(arb_rd_vector[6]), .out(valid_pass[6]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr7(.in({1'b0,rout[7][8]}), .sel(arb_rd_vector[7]), .out(valid_pass[7]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr8(.in({1'b0,rout[8][8]}), .sel(arb_rd_vector[8]), .out(valid_pass[8]));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) mr9(.in({1'b0,rout[9][8]}), .sel(arb_rd_vector[9]), .out(valid_pass[9]));

    regn #(.WIDTH(9)) r0(.din({incoming_reqs,req_in}), .ld(rld[0]), .clr(clr), .clk(clk), .dout(rout[0]));
    regn #(.WIDTH(9)) r1(.din({valid_pass[0],rout[0][7:0]}), .ld(rld[1]), .clr(clr), .clk(clk), .dout(rout[1]));
    regn #(.WIDTH(9)) r2(.din({valid_pass[1],rout[1][7:0]}), .ld(rld[2]), .clr(clr), .clk(clk), .dout(rout[2]));
    regn #(.WIDTH(9)) r3(.din({valid_pass[2],rout[2][7:0]}), .ld(rld[3]), .clr(clr), .clk(clk), .dout(rout[3]));
    regn #(.WIDTH(9)) r4(.din({valid_pass[3],rout[3][7:0]}), .ld(rld[4]), .clr(clr), .clk(clk), .dout(rout[4]));
    regn #(.WIDTH(9)) r5(.din({valid_pass[4],rout[4][7:0]}), .ld(rld[5]), .clr(clr), .clk(clk), .dout(rout[5]));
    regn #(.WIDTH(9)) r6(.din({valid_pass[5],rout[5][7:0]}), .ld(rld[6]), .clr(clr), .clk(clk), .dout(rout[6]));
    regn #(.WIDTH(9)) r7(.din({valid_pass[6],rout[6][7:0]}), .ld(rld[7]), .clr(clr), .clk(clk), .dout(rout[7]));
    regn #(.WIDTH(9)) r8(.din({valid_pass[7],rout[7][7:0]}), .ld(rld[8]), .clr(clr), .clk(clk), .dout(rout[8]));
    regn #(.WIDTH(9)) r9(.din({valid_pass[8],rout[8][7:0]}), .ld(rld[9]), .clr(clr), .clk(clk), .dout(rout[9]));
    regn #(.WIDTH(9)) r10(.din({valid_pass[9],rout[9][7:0]}), .ld(rld[10]), .clr(clr), .clk(clk), .dout(rout[10]));

    wire [10:0] ready_vector;
    wire [10:0] invvalid;

    genvar i;
    generate
        for (i = 0; i < 11; i = i + 1) begin : queue_slices
            
            wire readyIE, readyIO, readyDE, readyDO, readyB0, readyB1, readyB2, readyB3, readyDMA;
            wire invdom1, invdom0, invsubdom1, invsubdom0;
            
            inv1$ g12(.out(invdom1), .in(rout[i][3]));
            inv1$ g13(.out(invdom0), .in(rout[i][2]));
            inv1$ g14(.out(invsubdom1), .in(rout[i][1]));
            inv1$ g15(.out(invsubdom0), .in(rout[i][0]));

            andn #(.NUM_INPUTS(7)) g16(.in({rout[i][8],     invdom1,    invdom0,       1'b1, invsubdom0,  freeIE, pull}), .out(readyIE));
            andn #(.NUM_INPUTS(7)) g17(.in({rout[i][8],     invdom1,    invdom0,       1'b1, rout[i][0],  freeIO, pull}), .out(readyIO));
            andn #(.NUM_INPUTS(7)) g18(.in({rout[i][8],     invdom1, rout[i][2],       1'b1, invsubdom0,  freeDE, pull}), .out(readyDE));
            andn #(.NUM_INPUTS(7)) g19(.in({rout[i][8],     invdom1, rout[i][2],       1'b1, rout[i][0],  freeDO, pull}), .out(readyDO));
            andn #(.NUM_INPUTS(7)) g20(.in({rout[i][8],  rout[i][3],    invdom0, invsubdom1, invsubdom0,  freeB0, pull}), .out(readyB0));
            andn #(.NUM_INPUTS(7)) g21(.in({rout[i][8],  rout[i][3],    invdom0, invsubdom1, rout[i][0],  freeB1, pull}), .out(readyB1));
            andn #(.NUM_INPUTS(7)) g22(.in({rout[i][8],  rout[i][3],    invdom0, rout[i][1], invsubdom0,  freeB2, pull}), .out(readyB2));
            andn #(.NUM_INPUTS(7)) g23(.in({rout[i][8],  rout[i][3],    invdom0, rout[i][1], rout[i][0],  freeB3, pull}), .out(readyB3));
            andn #(.NUM_INPUTS(7)) g24(.in({rout[i][8],  rout[i][3], rout[i][2], invsubdom1, invsubdom0, freeDMA, pull}), .out(readyDMA));

            orn #(.NUM_INPUTS(9)) g25(.in({readyIE,readyIO,readyDE,readyDO,readyB0,readyB1,readyB2,readyB3,readyDMA}), .out(ready_vector[i]));
            
            inv1$ g26(.out(invvalid[i]), .in(rout[i][8]));

        end
    endgenerate    

    arbiter a1(.in(ready_vector), .out(arb_rd_vector));
    muxnm_tristate #(.NUM_INPUTS(11), .DATA_WIDTH(4)) m1(.in({rout[10][7:4],rout[9][7:4],rout[8][7:4],rout[7][7:4],rout[6][7:4],rout[5][7:4],rout[4][7:4],rout[3][7:4],rout[2][7:4],rout[1][7:4],rout[0][7:4]}), .sel(arb_rd_vector), .out(send_out));
    muxnm_tristate #(.NUM_INPUTS(11), .DATA_WIDTH(4)) m2(.in({rout[10][3:0],rout[9][3:0],rout[8][3:0],rout[7][3:0],rout[6][3:0],rout[5][3:0],rout[4][3:0],rout[3][3:0],rout[2][3:0],rout[1][3:0],rout[0][3:0]}), .sel(arb_rd_vector), .out(dest_out));

    orn #(.NUM_INPUTS(2)) g27(.in({invvalid[10],arb_rd_vector[10]}), .out(rld[10]));
    orn #(.NUM_INPUTS(4)) g28(.in({invvalid[10],invvalid[9],arb_rd_vector[10],arb_rd_vector[9]}), .out(rld[9]));
    orn #(.NUM_INPUTS(6)) g29(.in({invvalid[10],invvalid[9],invvalid[8],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8]}), .out(rld[8]));
    orn #(.NUM_INPUTS(8)) g30(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7]}), .out(rld[7]));
    orn #(.NUM_INPUTS(10)) g31(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6]}), .out(rld[6]));
    orn #(.NUM_INPUTS(12)) g32(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5]}), .out(rld[5]));
    orn #(.NUM_INPUTS(14)) g33(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4]}), .out(rld[4]));
    orn #(.NUM_INPUTS(16)) g34(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3]}), .out(rld[3]));
    orn #(.NUM_INPUTS(18)) g35(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2]}), .out(rld[2]));
    orn #(.NUM_INPUTS(20)) g36(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],invvalid[1],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1]}), .out(rld[1]));
    orn #(.NUM_INPUTS(22)) g37(.in({invvalid[10],invvalid[9],invvalid[8],invvalid[7],invvalid[6],invvalid[5],invvalid[4],invvalid[3],invvalid[2],invvalid[1],invvalid[0],arb_rd_vector[10],arb_rd_vector[9],arb_rd_vector[8],arb_rd_vector[7],arb_rd_vector[6],arb_rd_vector[5],arb_rd_vector[4],arb_rd_vector[3],arb_rd_vector[2],arb_rd_vector[1],arb_rd_vector[0]}), .out(rld[0]));

    orn #(.NUM_INPUTS(11)) g38(.in(ready_vector), .out(req_ready));

endmodule



module arbiter(input [10:0] in,
               output [10:0] out);

    wire inv [1:10];
    inv1$ g0(.out(inv[10]), .in(in[10]));
    inv1$ g1(.out(inv[9]), .in(in[9]));
    inv1$ g2(.out(inv[8]), .in(in[8]));
    inv1$ g3(.out(inv[7]), .in(in[7]));
    inv1$ g4(.out(inv[6]), .in(in[6]));
    inv1$ g5(.out(inv[5]), .in(in[5]));
    inv1$ g6(.out(inv[4]), .in(in[4]));
    inv1$ g7(.out(inv[3]), .in(in[3]));
    inv1$ g8(.out(inv[2]), .in(in[2]));
    inv1$ g9(.out(inv[1]), .in(in[1]));

    assign out[10] = in[10];
    andn #(.NUM_INPUTS(2)) g10(.in({in[9],inv[10]}), .out(out[9]));
    andn #(.NUM_INPUTS(3)) g11(.in({in[8],inv[10],inv[9]}), .out(out[8]));
    andn #(.NUM_INPUTS(4)) g12(.in({in[7],inv[10],inv[9],inv[8]}), .out(out[7]));
    andn #(.NUM_INPUTS(5)) g13(.in({in[6],inv[10],inv[9],inv[8],inv[7]}), .out(out[6]));
    andn #(.NUM_INPUTS(6)) g14(.in({in[5],inv[10],inv[9],inv[8],inv[7],inv[6]}), .out(out[5]));
    andn #(.NUM_INPUTS(7)) g15(.in({in[4],inv[10],inv[9],inv[8],inv[7],inv[6],inv[5]}), .out(out[4]));
    andn #(.NUM_INPUTS(8)) g16(.in({in[3],inv[10],inv[9],inv[8],inv[7],inv[6],inv[5],inv[4]}), .out(out[3]));
    andn #(.NUM_INPUTS(9)) g17(.in({in[2],inv[10],inv[9],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3]}), .out(out[2]));
    andn #(.NUM_INPUTS(10)) g18(.in({in[1],inv[10],inv[9],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3],inv[2]}), .out(out[1]));
    andn #(.NUM_INPUTS(11)) g19(.in({in[0],inv[10],inv[9],inv[8],inv[7],inv[6],inv[5],inv[4],inv[3],inv[2],inv[1]}), .out(out[0]));

endmodule
