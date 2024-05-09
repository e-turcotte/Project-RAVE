module bau(input [3:0] sender, dest,
           input req_ready,
           input relIE, relIO, relDEr, relDEw, relDOr, relDOw, relB0, relB1, relB2, relB3, relDMA,
           
           input clr, clk,
           
           output pull,
           output grantIE, grantIO, grantDEr, grantDEw, grantDOr, grantDOw, grantB0, grantB1, grantB2, grantB3, grantDMA,
           output recvIE, recvIO, recvDE, recvDO, recvB0, recvB1, recvB2, recvB3, recvDMA);

    wire s_invdom1, s_invdom0, s_invsubdom1, s_invsubdom0;

    inv1$ g0(.out(s_invdom1), .in(sender[3]));
    inv1$ g1(.out(s_invdom0), .in(sender[2]));
    inv1$ g2(.out(s_invsubdom1), .in(sender[1]));
    inv1$ g3(.out(s_invsubdom0), .in(sender[0]));

    wire [10:0] grant_vector;

    andn #(.NUM_INPUTS(5)) g4(.in({  req_ready, s_invdom1,  s_invdom0, s_invsubdom1, s_invsubdom0}), .out(grant_vector[10]));
    andn #(.NUM_INPUTS(5)) g5(.in({  req_ready, s_invdom1,  s_invdom0, s_invsubdom1,    sender[0]}), .out(grant_vector[9]));
    andn #(.NUM_INPUTS(5)) g6(.in({  req_ready, s_invdom1,  sender[2], s_invsubdom1, s_invsubdom0}), .out(grant_vector[8]));
    andn #(.NUM_INPUTS(5)) g7(.in({  req_ready, s_invdom1,  sender[2], s_invsubdom1,    sender[0]}), .out(grant_vector[7]));
    andn #(.NUM_INPUTS(5)) g8(.in({  req_ready, s_invdom1,  sender[2],    sender[1], s_invsubdom0}), .out(grant_vector[6]));
    andn #(.NUM_INPUTS(5)) g9(.in({  req_ready, s_invdom1,  sender[2],    sender[1],    sender[0]}), .out(grant_vector[5]));
    andn #(.NUM_INPUTS(5)) g10(.in({ req_ready, sender[3],  s_invdom0, s_invsubdom1, s_invsubdom0}), .out(grant_vector[4]));
    andn #(.NUM_INPUTS(5)) g11(.in({ req_ready, sender[3],  s_invdom0, s_invsubdom1,    sender[0]}), .out(grant_vector[3]));
    andn #(.NUM_INPUTS(5)) g12(.in({ req_ready, sender[3],  s_invdom0,    sender[1], s_invsubdom0}), .out(grant_vector[2]));
    andn #(.NUM_INPUTS(5)) g13(.in({ req_ready, sender[3],  s_invdom0,    sender[1],    sender[0]}), .out(grant_vector[1]));
    andn #(.NUM_INPUTS(5)) g14(.in({ req_ready, sender[3],  sender[2], s_invsubdom1, s_invsubdom0}), .out(grant_vector[0]));

    wire d_invdom1, d_invdom0, d_invsubdom1, d_invsubdom0;

    inv1$ g15(.out(d_invdom1), .in(dest[3]));
    inv1$ g16(.out(d_invdom0), .in(dest[2]));
    inv1$ g17(.out(d_invsubdom1), .in(dest[1]));
    inv1$ g18(.out(d_invsubdom0), .in(dest[0]));

    wire [8:0] recv_vector;

    andn #(.NUM_INPUTS(5)) g19(.in({  req_ready, d_invdom1,  d_invdom0,         1'b1, d_invsubdom0}), .out(recv_vector[8]));
    andn #(.NUM_INPUTS(5)) g20(.in({  req_ready, d_invdom1,  d_invdom0,         1'b1,      dest[0]}), .out(recv_vector[7]));
    andn #(.NUM_INPUTS(5)) g21(.in({  req_ready, d_invdom1,    dest[2],         1'b1, d_invsubdom0}), .out(recv_vector[6]));
    andn #(.NUM_INPUTS(5)) g22(.in({  req_ready, d_invdom1,    dest[2],         1'b1,      dest[0]}), .out(recv_vector[5]));
    andn #(.NUM_INPUTS(5)) g23(.in({  req_ready,   dest[3],  d_invdom0, d_invsubdom1, d_invsubdom0}), .out(recv_vector[4]));
    andn #(.NUM_INPUTS(5)) g24(.in({  req_ready,   dest[3],  d_invdom0, d_invsubdom1,      dest[0]}), .out(recv_vector[3]));
    andn #(.NUM_INPUTS(5)) g25(.in({  req_ready,   dest[3],  d_invdom0,     dest[1],  d_invsubdom0}), .out(recv_vector[2]));
    andn #(.NUM_INPUTS(5)) g26(.in({  req_ready,   dest[3],  d_invdom0,     dest[1],       dest[0]}), .out(recv_vector[1]));
    andn #(.NUM_INPUTS(5)) g27(.in({  req_ready,   dest[3],    dest[2], d_invsubdom1, d_invsubdom0}), .out(recv_vector[0]));
    
    wire busy, idle, releaseBUS, ldstate;

    regn #(.WIDTH(11)) r0(.din(grant_vector), .ld(pull), .clr(clr), .clk(clk), .dout({grantIE,grantIO,grantDEr,grantDOr,grantDEw,grantDOw,grantB0,grantB1,grantB2,grantB3,grantDMA}));
    regn #(.WIDTH(9)) r1(.din(recv_vector), .ld(pull), .clr(clr), .clk(clk), .dout({recvIE,recvIO,recvDE,recvDO,recvB0,recvB1,recvB2,recvB3,recvDMA}));

    orn #(.NUM_INPUTS(11)) g28(.in({grantIE,grantIO,grantDEr,grantDOr,grantDEw,grantDOw,grantB0,grantB1,grantB2,grantB3,grantDMA}), .out(busy));
    inv1$ g29(.out(idle), .in(busy));
    equaln #(.WIDTH(11)) g30(.a({grantIE,grantIO,grantDEr,grantDOr,grantDEw,grantDOw,grantB0,grantB1,grantB2,grantB3,grantDMA}), .b({relIE,relIO,relDEr,relDOr,relDEw,relDOw,relB0,relB1,relB2,relB3,relDMA}), .eq(releaseBUS));
    or2$ g31(.out(pull), .in0(idle), .in1(releaseBUS));

endmodule