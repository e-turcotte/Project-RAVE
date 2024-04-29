module PTCVDFSM(
input wire clk,
input wire set,
input wire rst,
input wire sw,
input wire ex,
input wire wb,
input enable,
output PTC, D, V
);
wire PTC_new, D_new, V_new;
dff$ d1(clk, D_new, D, D_bar, rst, set);
dff$ d2(clk, V_new, V, V_bar, rst, set);
dff$ d3(clk, PTC_new, PTC, PTC_bar, rst, set);
wire[2:0] nextState;
wire[2:0] cc;

mux2n #(3) m(cc, {V,PTC,D}, nextState, enable);
assign V_new = cc[2];
assign PTC_new  = cc[1];
assign D_new = cc[0];

and4$(EX100, V, PTC_bar, D_bar, ex);//010
and4$(SW000, V_bar, PTC_bar, D_bar, sw); //010
and4$(WB010, V_bar, PTC, D_bar, wb);//100
and4$(SW100, V, PTC_bar, D_bar, sw); //110
and4$(WB110, V, PTC, D_bar, wb);//101
and4$(SW101, V, PTC_bar, D, sw); //111
and4$(WB111, V, PTC, D, wb); //101
and4$(EX101, V, PTC_bar, D, ex); //010


muxnm_tristate #(8, 3) tm({3'b010,3'b010,3'b100,3'b110,3'b101,3'b111,3'b101,3'b010 }, {EX100,SW000,WB010,SW100,WB110,SW101,WB111,EX101},nextState);

endmodule
