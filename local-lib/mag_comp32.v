module mag_comp32(
    input [31:0] A, //say this is read_address_size
    input [31:0] B, //say this is seg_size - seg size is 20b so make sure to zext it
    output AGB,
    output BGA
);

    wire [3:0] agb, bga, eq;

    mag_comp8$(.A(A[31:24]), .B(B[31:24]), .AGB(agb[0]), .BGA(bga[0])); //1.46 in parallel
    mag_comp8$(.A(A[23:16]), .B(B[23:16]), .AGB(agb[1]), .BGA(bga[1]));
    mag_comp8$(.A(A[15:8]), .B(B[15:8]), .AGB(agb[2]), .BGA(bga[2]));
    mag_comp8$(.A(A[7:0]), .B(B[7:0]), .AGB(agb[3]), .BGA(bga[3]));

    //A and B are equal if both agb and bga are 0
    and2$ (.out(eq[0]), .in0(agb[0]), .in1(bga[0])); //1.66
    and2$ (.out(eq[1]), .in0(agb[1]), .in1(bga[1]));
    and2$ (.out(eq[2]), .in0(agb[2]), .in1(bga[2]));
    and2$ (.out(eq[3]), .in0(agb[3]), .in1(bga[3]));

    and2$ (.out(f1), .in0(eq[0]), .in1(agb[1])); //(eq1 & gt2)
    and3$ (.out(f2), .in0(eq[0]), .in1(eq[1]), .in2(agb[2])); //(eq1 & eq2 & gt3)
    and4$ (.out(f3), .in0(eq[0]), .in1(eq[1]), .in2(eq[2]), .in3(agb[3])); //(eq1 & eq2 & eq3 & gt4) 2.06
    or4$  (.out(AGB), .in0(agb[0]), .in1(f1), .in2(f2), .in3(f3)); //2.56 holy moly

    and2$ (.out(f4), .in0(eq[1]), .in1(bga[2])); //(eq1 & lt2)
    and3$ (.out(f5), .in0(eq[1]), .in1(eq[2]), .in2(bga[3])); //(eq1 & eq2 & lt3)
    and4$ (.out(f6), .in0(eq[1]), .in1(eq[2]), .in2(eq[3]), .in3(bga[4])); //(eq1 & eq2 & eq3 & lt4)
    or4$  (.out(BGA), .in0(bga[0]), .in1(f4), .in2(f5), .in3(f6));


// assign greater = gt1 | (eq1 & gt2) | (eq1 & eq2 & gt3) | (eq1 & eq2 & eq3 & gt4);
// assign less = lt1 | (eq1 & lt2) | (eq1 & eq2 & lt3) | (eq1 & eq2 & eq3 & lt4);

endmodule
