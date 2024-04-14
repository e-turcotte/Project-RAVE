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

    and2$ (clk_temp, clk, enable);

    and2$ (f1 ,S[1], notS[0]);
    and3$ (f2, notS[1], notS[0], in);
    and3$ (f3, S[1], S[0], in);
    or3$ (NS[0], f1, f2, f3);

    and2$ (f4, S[1], S[0]);
    and3$ (f5, S[1], notS[0], in);
    and3$ (f6, notS[1], S[0], in);
    or3$ (NS[1], f4, f5, f6);

    dff$ s1(clk_temp, NS[1], S[1], notS[1], rst_n, set_n);
    dff$ s2(clk_temp, NS[0], S[0], notS[0], rst_n, set_n);

    assign s_out_high = S[1];
    assign s_out_low = S[0];

endmodule
