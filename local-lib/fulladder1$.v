//1 bit full adder - 0.7ns

module fulladder1$(
    input A, B, cin,
    output sum, cout
    );
    
    wire xor_1, nand_1, nand_2;

    xor2$ (xor_1, A, B);
    xor2$ (sum, xor_1, cin);

    nand2$ (nand_1, A, B);
    nand2$ (nand_2, xor_1, cin);

    nand2$ (cout, nand_1, nand_2);

endmodule