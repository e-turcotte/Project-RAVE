module SER(
    input clk_core,
    input clk_bus,
    input rst, set,

    //From block input
    input valid_in,
    input [14:0] pAdr_in,
    input [16*8-1:0] data_in,
    input [3:0] dest_in,
    input [3:0]return_in,
    input rw_in,
    input [15:0] size_in,

    //to block output
    output full_block,
    output free_block,

    //From bau input
    input grant,
    input ack,

    //to bau output
    output releases,
    output req,

    //to BUS output
    inout [72:0] BUS,
    output[3:0] dest_bau
); 
wire[3:0] state;

wire valid_bus;
wire [14:0] pAdr_bus;
wire [31:0] data_bus;
wire [3:0]  return_bus;
wire [3:0]  dest_bus;
wire        rw_bus;
wire [15:0] size_bus;
wire [3:0] dest_tri; //done

assign BUS[0] = valid_bus;
assign BUS[15:1] = pAdr_bus;
assign BUS[47:16] = data_bus;
assign BUS[51:48] = return_bus;
assign BUS[55:52] = dest_bus;
assign BUS[56] = rw_bus  ;
assign BUS[72:57] = size_bus;
assign dest_bau = dest_tri;

wire valid_tri; //done
wire [14:0] pAdr_tri; //done
wire [31:0] data_tri;//done
wire [3:0]return_tri;//done

wire rw_tri; //done
wire [3:0] size_tri; //done

//Full/free
assign free_block = state[0];
inv1$ invFull(full_block, free_block);
assign releases = size_tri[0];
assign req = state[1];

//Handle the loading of data

wire[16*8-1:0] dataToSend;
and2$ a11(dataLoad, valid_in, state[0]);
regn #(16*8) data2S(data_in, dataLoad, rst, clk_bus, dataToSend);

//Handle valid load
regn #(1) r1 (valid_in, dataLoad, rst, clk_bus, valid_tri);

//handle rw
regn #(1) r2 (rw_in, dataLoad, rst, clk_bus, rw_tri);

//handle return
regn #(4) r3 (return_in, dataLoad, rst, clk_bus, return_tri);
//handle dest
regn #(4) r4 (dest_in, dataLoad, rst, clk_bus, dest_tri);
//handle pAdr
regn #(15) r5 (pAdr_in, dataLoad, rst, clk_bus, pAdr_tri);

//Handle Size
wire[3:0] sizeNew;
nand2$ sizeLd(sizeLoad, valid_in, state[0]);
inv1$  invS3(notS3, state[3]);
nand2$ gensld(sizeUpdate, notS3, sizeLoad);
mux2n #(4) m1(sizeNew,size_in[15:12], {1'b0,size_tri[3:1]}, state[3]);
regn #(4) d2S(sizeNew, sizeUpdate, rst, clk_bus, size_tri[3:0]);

muxnm_tristate #(4, 32) nm(dataToSend, size_tri[3:0], data_tri);

/////////////////
//Handle FSM Transitions
/////////////////
//state 3->0, 0->1
and2$ a16(state1_in, state[0], valid_in);
nand2$ a1(state0a,state[0], valid_in);
nand2$ a3(state0_ld, state0a, state3a);

//state 0->1, 1->2
and2$ a13(state2_in, state[1],ack);
nand2$ a4(state1a, state[1], ack);
nand2$ a5(state1_ld, state1a, state0a);

//state  1->2, 2->3
and2$ a14(state3_in, state[2],grant);
nand2$ a6(state2a, state[2], grant);
nand2$ a7(state2_ld, state2a, state1a);

//state 2->3, 3-> 0
and2$ a15(state0_inp, state[3],size_tri[0]);
nand2$ a8(state3a, state[3], size_tri[0]);
nand2$ a9(state3_ld, state2a, state3a);


regn #(1) r7 (state3_in, state3_ld, rst, clk_bus, state[3]);
regn #(1) r8 (state2_in, state2_ld, rst, clk_bus, state[2]);
regn #(1) r9 (state1_in, state1_ld, rst, clk_bus, state[1]);

mux2$ g0(.outb(state0_in), .in0(state[0]), .in1(state0_inp), .s0(state0_ld));
dff$ g1(.clk(clk_bus), .d(state0_in), .q(state[0]), .qbar(), .r(1'b1), .s(rst));

///////////////////
//Tristate Handler
///////////////////
tristate_bus_drivern #(1)  b0(state[3],  valid_tri, valid_bus);
tristate_bus_drivern #(15) b1(state[3],   pAdr_tri,  pAdr_bus);
tristate_bus_drivern #(32) b2(state[3],   data_tri,  data_bus);
tristate_bus_drivern #(4)  b6(state[3], return_tri,return_bus);
tristate_bus_drivern #(4)  b3(state[3],   dest_tri,  dest_bus);
tristate_bus_drivern #(1)  b4(state[3],     rw_tri,    rw_bus);
tristate_bus_drivern #(4)  b5(state[3],   size_tri[3:0],  size_bus[3:0]);
assign size_bus[15:4] = 12'bz;
endmodule

module tristate_bus_drivern #(parameter WIDTH = 16) (
    input enable,
    input [WIDTH-1:0] signal_in,
    output [WIDTH-1:0]signal_bus
);
    inv1$ in(en_n, enable);
    genvar i;
    generate 
        for( i = 0; i < WIDTH; i = i + 1) begin : busDriver
            tristate_bus_driver1$ t(en_n, signal_in[i], signal_bus[i]);
        end
    endgenerate
endmodule 
