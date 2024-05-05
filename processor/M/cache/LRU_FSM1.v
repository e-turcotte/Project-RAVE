module LRU_FSM1(
    output [3:0]LRUx,
    input clk,
    input rst, set,
    input[3:0] LRUin,
    input enable   
);
wire[7:0] state, state_new,state_new1, state_n, state_swap;
wire[3:0] LRUina;
wire holdVal;

and2$ a6(LRUina[0], enable, LRUin[0]);
and2$ a9(LRUina[1], enable, LRUin[1]);
and2$ a7(LRUina[2], enable, LRUin[2]);
and2$ a8(LRUina[3], enable, LRUin[3]);

dff$ d1(clk, state_new[0], state[0], state_n[0], rst, set  );
dff$ d2(clk, state_new[1], state[1], state_n[1], rst, set  );
dff$ d3(clk, state_new[2], state[2], state_n[2], set, rst  );
dff$ d4(clk, state_new[3], state[3], state_n[3], set, rst  );
dff$ d5(clk, state_new[4], state[4], state_n[4], rst, set  );
dff$ d6(clk, state_new[5], state[5], state_n[5], set, rst  );
dff$ d7(clk, state_new[6], state[6], state_n[6], rst, set  );
dff$ d8(clk, state_new[7], state[7], state_n[7], rst, set  );

assign LRUx[3] = state[7];
assign LRUx[2] = state[6];
assign LRUx[1] = state[5];
assign LRUx[0] = state[4];

wire[3:0] nextState, stateFlip;
wire stateTransit;
genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin : x
        nand2$ n2(nextState[i], LRUina[i],state[i]);
    end
endgenerate
nor4$ n1(stateTransit, nextState[0], nextState[1], nextState[2], nextState[3]);

mux2n #(4) m1(state_new1[7:4], state[7:4], {state[6:4], 1'b0}, stateTransit);
mux2n #(4) m2(state_new1[3:0], state[3:0], stateFlip, stateTransit);

// nor2$ a2(LRUx[1], state[4], state_n[3]);
// nor2$ a3(LRUx[2], state_n[4], state[3]);
// nor2$ a4(LRUx[3], state_n[4], state_n[3]);

nor4$ a5(holdVal, LRUina[0], LRUina[1], LRUina[2], LRUina[3]);
mux2n #(8) m3(state_new, state_new1, 8'b00011110, LRUina[0]);

xor2$ x1(stateFlip[0], state[0], LRUina[0]);
xor2$ x2(stateFlip[1], state[1], LRUina[1]);
xor2$ x3(stateFlip[2], state[2], LRUina[2]);
xor2$ x4(stateFlip[3], state[3], LRUina[3]);




endmodule

