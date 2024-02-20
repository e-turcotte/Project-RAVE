module testfile2(
input wire Q1,
input wire Q0,
input wire D,
input wire N,
output wire T1,
output wire T0,
output wire OPEN);


inv1$ n0(notQ1, Q1);
inv1$ n1(notQ0, Q0);
nand2$ f1(w3, D, notQ1);

inv1$ f2(w2, w3);

nand3$ f3(w7, N, Q0, notQ1);

inv1$ f4(w6, w7);

nor2$ f5(w1, w2, w6);

inv1$ f6(T1, w1);

nand3$ f7(w13, D, Q1, notQ0);

inv1$ f8(w12, w13);

nand2$ f9(w18, N, notQ0);

inv1$ f10(w17, w18);

nand3$ f11(w22, N, Q0, notQ1);

inv1$ f12(w21, w22);

nor3$ f13(w11, w12, w17, w21);

inv1$ f14(T0, w11);

nand2$ f15(w26, Q0, Q1);

inv1$ f16(OPEN, w26);

endmodule
