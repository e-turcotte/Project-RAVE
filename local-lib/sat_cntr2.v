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

    and2$ a0(clk_temp, clk, enable);

    and3$ a1(f1, notS[0], in);
    and3$ a2(f2, S[1], S[0], in);
    or3$ o0(NS[0], f1, f2);

    and3$ a3(f3, S[0], in);
    assign NS[1] = f3;

    dff$ s1(clk_temp, NS[1], S[1], notS[1], rst_n, set_n);
    dff$ s2(clk_temp, NS[0], S[0], notS[0], rst_n, set_n);

    assign s_out_high = S[1];
    assign s_out_low = S[0];

endmodule
