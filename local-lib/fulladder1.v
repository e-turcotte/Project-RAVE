//1 bit full adder - 0.7ns

module fulladder1$(
    input A, B, cin,
    output sum, cout
    );
    
    wire xor_1, nand_1, nand_2;

    xor2$ x0(.out(xor_1), .in0(A), .in1(B));
    xor2$ x1(.out(sum), .in0(xor_1), .in1(cin));

    nand2$ n0(.out(nand_1), .in0(A), .in1(B));
    nand2$ n1(.out(nand_2), .in0(xor_1), .in1(cin));

    nand2$ n2(.out(cout), .in0(nand_1), .in1(nand_2));

endmodule