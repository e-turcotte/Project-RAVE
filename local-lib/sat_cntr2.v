module sat_cntr2(
    input wire clk,
    input wire set_n,
    input wire rst_n,
    input wire in,
    input wire enable,
    output wire [1:0] s_out
);

    wire [1:0] NS, S, notS;

    inv1$ (notclk, clk);
    inv1$ (not_en, enable);
    nand3$ (clk_temp, clk, not_en, notclk);

    and2$ (f1 ,S[1], notS[0]);
    and3$ (f2, notS[1], notS[0], in);
    and3$ (f3, S[1], S[0], in);
    or3$ (NS[0], f1, f2, f3);

    and2$ (f4, S[1], S[0]);
    and3$ (f5, S[1], notS[0], in);
    and3$ (f6, notS[1], S[0], in); //.35
    or3$ (NS[1], f4, f5, f6); //.4
    //.75 for NS to propogate, depends on setup time for DFF
    dff$ s1(clk_temp, NS[1], S[1], notS[1], rst_n, set_n);
    dff$ s2(clk_temp, NS[0], S[0], notS[0], rst_n, set_n);

    assign s_out = S;

endmodule
