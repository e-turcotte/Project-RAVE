//Delay: 1.68ns
module mag_comp32(
    input [31:0] A, //say this is read_address_size
    input [31:0] B, //say this is seg_size - seg size is 20b so make sure to zext it
    output AGB,
    output BGA,
    output EQ 
);

    wire [3:0] agb, bga, eq, eq_not, ripple, not_ripple;
    mag_comp8$(.A(A[31:24]), .B(B[31:24]), .AGB(agb[3]), .BGA(bga[3])); //1.46 in parallel
    mag_comp8$(.A(A[23:16]), .B(B[23:16]), .AGB(agb[2]), .BGA(bga[2]));
    mag_comp8$(.A(A[15:8]), .B(B[15:8]),   .AGB(agb[1]), .BGA(bga[1]));
    mag_comp8$(.A(A[7:0]), .B(B[7:0]),     .AGB(agb[0]), .BGA(bga[0]));

    equaln #(.WIDTH(8)) (.a(A[31:24]), .b(B[31:24]), .eq(eq[3]));
    equaln #(.WIDTH(8)) (.a(A[23:16]), .b(B[23:16]), .eq(eq[2]));
    equaln #(.WIDTH(8)) (.a(A[15:8]), .b(B[15:8]), .eq(eq[1]));
    equaln #(.WIDTH(8)) (.a(A[7:0]), .b(B[7:0]), .eq(eq[0]));

    inv1$ (.out(eq_not[0]), .in(eq[0]));
    inv1$ (.out(eq_not[1]), .in(eq[1]));
    inv1$ (.out(eq_not[2]), .in(eq[2]));
    inv1$ (.out(eq_not[3]), .in(eq[3]));
    and4$ (.out(EQ), .in0(eq[3]), .in1(eq[2]), .in2(eq[1]), .in3(eq[0]));

    assign ripple[3] = eq_not[3];
    inv1$ (.out(not_ripple[3]), .in(ripple[3])); //not ripple 3

    and2$ (.out(ripple[2]), .in0(eq[3]), .in1(eq_not[2]));
    inv1$ (.out(not_ripple[2]), .in(ripple[2])); //not ripple 2

    and3$ (.out(ripple[1]), .in0(eq[3]), .in1(not_ripple[2]), .in2(eq_not[1]));
    inv1$ (.out(not_ripple[1]), .in(ripple[1])); //not ripple 1

    and4$ (.out(ripple[0]), .in0(eq[3]), .in1(not_ripple[2]), .in2(not_ripple[1]), .in3(eq_not[0]));
    inv1$ (.out(not_ripple[0]), .in(ripple[0])); //not ripple 0

//   wire ripple_0;
//   or2$ (.out(ripple_0), .in0(ripple[0]), .in1(EQ));
	
//  wire [3:0] ripple_out;
//  assign ripple_out = {ripple[3:1], ripple_0};

//  muxn1_tristate #(.NUM_INPUTS(4)) (.in(agb), .sel(ripple_out), .out(AGB));
//  muxn1_tristate #(.NUM_INPUTS(4)) (.in(bga), .sel(ripple_out), .out(BGA));

    wire [1:0] encode;
    encoder4_2 (.in(ripple), .out(encode));

    mux4$ (.outb(AGB), .in0(agb[0]), .in1(agb[1]), .in2(agb[2]), .in3(agb[3]), .s0(encode[0]), .s1(encode[1]));
    mux4$ (.outb(BGA), .in0(bga[0]), .in1(bga[1]), .in2(bga[2]), .in3(bga[3]), .s0(encode[0]), .s1(encode[1]));

endmodule