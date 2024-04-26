module a();
wire[7:0] B1, B2, B3; wire isDouble0;
wire [7:0] m;

wire[12:0] dest1_mux0, op1_mux, dest2_mux0, op2_mux;
wire[1:0] OP_MOD_OVR0;

mux2n #(8)(m, B2, B3, isDouble0);
mux2$ mx1(m1,B2[6], B3[6], isDouble0);
mux2$ mx2(m2,B2[7], B3[7], isDouble0);
and3$ a1(m1rw_s, isMOD0, m1, m2);
mux2n #(2) mx3(M1_RW, M1_RW0, 2'b00, m1rw_s);

and4$ a2(s3_s, isMOD0,m1, m2, S3_MOD_OVR0 );
mux2n #(3)  mx4(S3, S30, m[5:3], s3_s);

and2$ a3(r1_s, isMOD0, R1_MOD_OVR0 );
mux2n #(3)  mx5(R1, R10, m[5:3], r1_s);

and2$ a4(d1_s, dest1_mux0[8],OP_MOD_OVR0[0]);
and2$ a5(op1_s, dest1_mux0[8],OP_MOD_OVR0[0]);
and2$ a6(d2_s, dest2_mux0[8],OP_MOD_OVR0[1]);
and2$ a7(op2_s, dest2_mux0[8],OP_MOD_OVR0[1]);
mux2n #(13) mx6(dest1_mux, dest1_mux0, "13'h0002");
mux2n #(13) mx7(dest2_mux, dest2_mux0, "13'h0002");
mux2n #(13) mx8(op1_mux, op1_mux0, "13'h0002");
mux2n #(13) mx9(op1_mux, op1_mux0, "13'h0002");

mux2 #(3) mx10(R2, R20, m[2:0], m1rw_s);

wire [2:0] s_out;


inv1$ inv1(size_n, isSIZE);\ninv1$ inv2(size1_n, size0[1]);\nnand3$ n1(size_s, size_n, size1_n, size[0]);\nmux2n mx12(size, size, 2'b01, size_s);



wire[227:0] c0, c1, c2, c3

endmodule
