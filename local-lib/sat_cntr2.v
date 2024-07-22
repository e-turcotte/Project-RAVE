module sat_cntr2(
    input wire clk,
    input wire set_n,
    input wire rst_n,
    input wire in,
    input wire enable,
    output wire s_out_high,
    output wire s_out_low
);

    wire [1:0] NS, S, notS;
    inv1$ i1(notS[0], S[0]);
    inv1$ i2(notS[1], S[1]);
    wire not_in;
    inv1$ i0(not_in, in);

    wire clk_temp;
    and2$ a0(clk_temp, clk, enable);

    wire f1, f2, f3, f4, f5;
    and3$ a1(f1, notS[1], notS[0], in); //00 + 1 -> 0[1]
    and3$ a2(f2, notS[1], S[0], not_in);//01 + 0 -> 0[1]
    and3$ a3(f3, S[1], notS[0], not_in);//10 + 0 -> 0[1]
    and3$ a4(f4, S[1], notS[0], in);//10 + 1 -> 1[1]
    and3$ a5(f5, S[1], S[0], in);//11 + 1 -> 1[1]
    orn #(5) o0(.in({f1, f2, f3, f4, f5}), .out(NS[0]));

    wire f6, f7, f8;
    and3$ a6(f6, notS[1], S[0], in);//01 + 1 -> [1]0
    and3$ a7(f7, S[1], notS[1], in);//10 + 1 -> [1]1
    and2$ a8(f8, S[1], S[1]);//11 + 0 -> [1]0 || 11 + 1 -> [1]1
    orn #(3) o1(.in({f6, f7, f8}), .out(NS[1]));


    regn #(.WIDTH(1)) s1(.din(NS[1]), .ld(enable), .clr(rst_n), .clk(clk), .dout(S[1]));
    regn #(.WIDTH(1)) s2(.din(NS[0]), .ld(enable), .clr(rst_n), .clk(clk), .dout(S[0]));

    assign s_out_high = S[1];
    assign s_out_low = S[0];

endmodule
