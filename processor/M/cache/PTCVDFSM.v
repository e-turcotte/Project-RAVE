module PTCVDFSM(
input wire clk,
input wire set,
input wire rst,
input wire r,
input wire sw,
input wire ex,
input wire wb,
input enable,
input ptc_clear,
output PTC, D, V
);

wire PTC_new, D_new, V_new;
dff$ d1(clk, D_new, D, D_bar, rst, set);
dff$ d2(clk, V_new, V, V_bar, rst, set);
dff$ d3(clk, PTC_new, PTC, PTC_bar, rst, set);
wire[2:0] nextState;
wire[2:0] cc, cc_temp;


mux2n #(3) m(cc_temp, {V,PTC,D}, nextState, enable);

and2$ asasas(d_next, V, D);
and2$ sdfsdf(ptc_next, V_bar, PTC);
mux2n #(3) maxmux(cc, {V, ptc_next,d_next},cc_temp,  ptc_clear );
assign V_new = cc[2];
assign PTC_new  = cc[1];
assign D_new = cc[0];
inv1$ invasdf(ex_bar, ex);
and2$ a121(ex_r, ex, r);
and2$ a122(ex_sw, ex, sw);
and2$ a123(ex_bar_sw, ex_bar, sw);



and4$ a1(EX100r, V, PTC_bar, D_bar, ex_r);//010
and4$ a420(EX100sw, V, PTC_bar, D_bar, ex_sw);//010
and4$ a2(SW000, V_bar, PTC_bar, D_bar, sw); //010
and4$ a11(R000, V_bar, PTC_bar, D_bar, r); //010
and4$ a3(WB010, V_bar, PTC, D_bar, wb);//100
and4$ a4(SW100, V, PTC_bar, D_bar, sw); //110
and4$ a5(WB110, V, PTC, D_bar, wb);//101
and4$ a6(SW101, V, PTC_bar, D, ex_bar_sw); //111
and4$ a7(WB111, V, PTC, D, wb); //101
and4$ a8(EX101r, V, PTC_bar, D, ex_r); //010
and4$ a420blazeit(EX101sw, V, PTC_bar, D, ex_sw); //010
and4$ a420bi(SW010, V_bar, PTC, D_bar, sw);

and4$ a9(SW111, V, PTC, D, sw);
and4$ a10(SW110, V, PTC,  D_bar, sw);
and4$ a12(WB011, V_bar,    PTC, D, wb);
orn #(15) o1(.out(invalid_transition_n), .in({SW010,EX100sw,EX101sw, SW110, SW111,EX100r,SW000,WB010,SW100,WB110,SW101,WB111,EX101r, R000, WB011}));
inv1$ in1 (invalid_transition, invalid_transition_n);
muxnm_tristate #(16, 3) tm({{V,PTC,D},3'b011, 3'b011, 3'b011, 3'b110, 3'b111,3'b010,3'b011,3'b100,3'b110,3'b101,3'b111,3'b101,3'b010 , 3'b010, 3'b110}, {invalid_transition,SW010,EX100sw,EX101sw, SW110, SW111,EX100r,SW000,WB010,SW100,WB110,SW101,WB111,EX101r, R000, WB011},nextState);

endmodule