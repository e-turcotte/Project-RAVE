module PTCVDFSM(
input wire clk,
input wire set_n,
input wire rst_n,
input wire sw,
input wire extract,
input wire wb,
input enable,
output PTC, D, V
);

inv1$ n3(notsw, sw);
inv1$ n4(notextract, extract,);
inv1$ n5(notwb, wb);

nand3$ f1(w2, notwb, PTC, D);
nand2$ f2(w6, sw, extract,);
nor2$ f3(w1, w2, w6);
nand3$ f4(w10, notwb, PTC, V);
nand2$ f5(w14, sw, extract,);
nor2$ f6(w9, w10, w14);
nand3$ f7(w18, notsw, V, PTC);
nand2$ f8(w22, extract, wb);
nor2$ f9(w17, w18, w22);
nand3$ f10(V_NS, w1, w9, w17);

nand3$ f11(w26, notextract, V, PTC);
nand2$ f12(w30, sw, wb);
nor2$ f13(w25, w26, w30);
nand3$ f14(w34, notsw, PTC, D);
nand2$ f15(w38, extract, wb);
nor2$ f16(w33, w34, w38);
nand3$ f17(w42, notsw, V, PTC);
nand2$ f18(w46, extract, wb);
nor2$ f19(w41, w42, w46);
nand3$ f20(PTC_NS, w25, w33, w41);

nand3$ f21(w50, notsw, D, V);
nand3$ f22(w54, PTC, extract, wb);
nor2$ f23(w49, w50, w54);
nand3$ f24(w59, notwb, PTC, V);
nand2$ f25(w63, sw, extract,);
nor2$ f26(w58, w59, w63);
nand2$ f27(D_NS, w49, w58);

mux2$ m1(V_N, V, V_NS, enable);
mux2$ m2(D_N, D, D_NS, enable);
mux2$ m3(PTC_N, PTC, PTC_NS, enable);

dff$ s1(clk, V_NS, V, notV, rst_n, set_n);
dff$ s2(clk, PTC_N, PTC, notPTC, rst_n, set_n);
dff$ s3(clk, D_N, D, notD, rst_n, set_n);

endmodule
