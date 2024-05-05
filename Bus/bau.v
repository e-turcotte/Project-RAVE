module bau(input [3:0] sender,
           input req_ready,
           input releaseIE, releaseIO, releaseDE, releaseDO, releaseB0, releaseB1, releaseB2, releaseB3, releaseDMA,
           
           input clr, clk,
           
           output pull,
           output grantIE, grantIO, grantDE, grantDO, grantB0, grantB1, grantB2, grantB3, grantDMA);

    wire [8:0] grant_vector;
    wire invdom1, invdom0, invsubdom1, invsubdom0;

    inv1$ g0(.out(invdom1), .in(sender[3]));
    inv1$ g1(.out(invdom0), .in(sender[2]));
    inv1$ g2(.out(invsubdom1), .in(sender[1]));
    inv1$ g3(.out(invsubdom0), .in(sender[0]));

    andn #(.NUM_INPUTS(5)) g4(.in({req_ready,invdom1,invdom0,sender[1],invsubdom0}), .out(grant_vector[8]));
    andn #(.NUM_INPUTS(5)) g5(.in({req_ready,invdom1,invdom0,invsubdom1,sender[0]}), .out(grant_vector[7]));
    andn #(.NUM_INPUTS(5)) g6(.in({req_ready,invdom1,sender[2],sender[1],invsubdom0}), .out(grant_vector[6]));
    andn #(.NUM_INPUTS(5)) g7(.in({req_ready,invdom1,sender[2],invsubdom1,sender[0]}), .out(grant_vector[5]));
    andn #(.NUM_INPUTS(5)) g8(.in({req_ready,sender[3],invdom0,invsubdom1,invsubdom0}), .out(grant_vector[4]));
    andn #(.NUM_INPUTS(5)) g9(.in({req_ready,sender[3],invdom0,invsubdom1,sender[0]}), .out(grant_vector[3]));
    andn #(.NUM_INPUTS(5)) g10(.in({req_ready,sender[3],invdom0,sender[1],invsubdom0}), .out(grant_vector[2]));
    andn #(.NUM_INPUTS(5)) g11(.in({req_ready,sender[3],invdom0,sender[1],sender[0]}), .out(grant_vector[1]));
    andn #(.NUM_INPUTS(5)) g12(.in({req_ready,sender[3],sender[2],invsubdom1,invsubdom0}), .out(grant_vector[0]));
    
    wire busy, idle, rel, ldstate;

    regn #(.WIDTH(9)) r0(.din(grant_vector), .ld(pull), .clr(clr), .clk(clk), .dout({grantIE,grantIO,grantDE,grantDO,grantB0,grantB1,grantB2,grantB3,grantDMA}));

    orn #(.NUM_INPUTS(9)) g13(.in({grantIE,grantIO,grantDE,grantDO,grantB0,grantB1,grantB2,grantB3,grantDMA}), .out(busy));
    inv1$ g14(.out(idle), .in(busy));
    equaln #(.WIDTH(9)) g15(.a({grantIE,grantIO,grantDE,grantDO,grantB0,grantB1,grantB2,grantB3,grantDMA}), .b({releaseIE,releaseIO,releaseDE,releaseDO,releaseB0,releaseB1,releaseB2,releaseB3,releaseDMA}), .eq(rel));
    or2$ g16(.out(pull), .in0(idle), .in1(rel));

endmodule