module DES #(parameter loc = 0) (
    //From block input
    input read,
    input clk_bus,
    input clk_core, rst, set,

    //to block ouput
    output full,
    output [14:0] pAdr,
    output [16*8-1:0] data,
    output [3:0]return,
    output [3:0] dest,
    output rw,
    output [15:0] size,

    //from bus input
    input valid_bus,
    input [14:0] pAdr_bus,
    input [31:0] data_bus,
    input [3:0]return_bus,
    input [3:0] dest_bus,
    input rw_bus,
    input [15:0] size_bus,


    input setReciever,
    //to bau output
    output free_bau
);

wire[3:0] location;
assign location = loc;

wire[2:0] state;
regn #(1) r8 (state2_in, state2_ld, rst, clk_bus, state[2]);
regn #(1) r9 (state1_in, state1_ld, rst, clk_bus, state[1]);
mux2$ g0(.outb(state0_in), .in0(state[0]), .in1(state0_inp), .s0(state0_ld));
dff$ g1(.clk(clk_bus), .d(state0_in), .q(state[0]), .qbar(), .r(1'b1), .s(rst));

////////////
assign full = state[2];
assign free_bau = state[0];
////////////


/////////////////////
//State Transitions
/////////////////////
wire isReciever;


and2$ a1(state0_inp, state[2], read);
nand2$ n1(state0a, state[0],setReciever);
nand2$ n3(state0_ld, state0a, state2a);

and2$ a2(state1_in, state[0], setReciever);
nand2$ n4(state1a, size_bus[0], state[1]);
nand2$ n5(state1_ld, state0a, state1a);

and2$ a3(state2_in, state[1], size_bus[0]);
nand2$ n2(state2a, state[2], read);
nand2$ n6(state2_ld, state2a, state1a);


///////////////////////
//Input Handlers
///////////////////////

// regn #(1) r1(valid_bus ,state[1], rst, clk_bus,    full );
regn #(15) r2(pAdr_bus ,state[1], rst, clk_bus,    pAdr );

regn #(32) r3(data_bus ,d0_ld, rst, clk_bus,    data[31:0] );
regn #(32) r4(data_bus ,d1_ld, rst, clk_bus,    data[63:32] );
regn #(32) r5(data_bus ,d2_ld, rst, clk_bus,    data[95:64] );
regn #(32) r6(data_bus ,d3_ld, rst, clk_bus,    data[127:96] );

regn #(4) r7(return_bus , state[1] , rst, clk_bus,    return );
regn #(4) r10(dest_bus   ,state[1] , rst, clk_bus,    dest );
regn #(1) r11(rw_bus     ,state[1] , rst, clk_bus,    rw );
regn #(16) r12({size_bus[3:0],12'd0}   , state[1], rst, clk_bus,    size );

and2$ an1(d0_ld, state[1],size_bus[0] );
and2$ an2(d1_ld, state[1],size_bus[1] );
and2$ an3(d2_ld, state[1],size_bus[2] );
and2$ an4(d3_ld, state[1],size_bus[3] );



endmodule