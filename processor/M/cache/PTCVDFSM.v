module PTCVDFSM(
input wire clk,
input wire set,
input wire rst,
input wire r,
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

and4$ a1(EX100r, V, PTC_bar, D_bar, ex & r);//010
and4$ a420(EX100sw, V, PTC_bar, D_bar, ex & sw);//010
and4$ a2(SW000, V_bar, PTC_bar, D_bar, sw); //010
and4$ a11(R000, V_bar, PTC_bar, D_bar, r); //010
and4$ a3(WB010, V_bar, PTC, D_bar, wb);//100
and4$ a4(SW100, V, PTC_bar, D_bar, sw); //110
and4$ a5(WB110, V, PTC, D_bar, wb);//101
and4$ a6(SW101, V, PTC_bar, D, sw & !ex); //111
and4$ a7(WB111, V, PTC, D, wb); //101
and4$ a8(EX101r, V, PTC_bar, D, ex & r); //010
and4$ a420blazeit(EX101sw, V, PTC_bar, D, ex & sw); //010
and4$ a420bi(SW010, V_bar, PTC, D_bar, sw);

and4$ a9(SW111, V, PTC, D, sw);
and4$ a10(SW110, V, PTC,  D_bar, sw);
and4$ a12(WB011, V_bar,    PTC, D, wb);

muxnm_tristate #(15, 3) tm({3'b011, 3'b011, 3'b011, 3'b110, 3'b111,3'b010,3'b011,3'b100,3'b110,3'b101,3'b111,3'b101,3'b010 , 3'b010, 3'b110}, {SW010,EX100sw,EX101sw, SW110, SW111,EX100r,SW000,WB010,SW100,WB110,SW101,WB111,EX101r, R000, WB011},nextState);

endmodule