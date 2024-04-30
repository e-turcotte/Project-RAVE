module fp_add(
    input wire clk,

    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] res
);

    wire A_s, B_s, res_s;
    wire [7:0] A_exp, B_exp, res_exp;
    wire [22:0] A_frac, B_frac, res_frac;

    assign A_s = A[31];
    assign B_s = B[31];
    assign A_exp = A[30:23];
    assign B_exp = B[30:23];
    assign A_frac = A[22:0];
    assign B_frac = B[22:0];

endmodule


module exp_diff(
    input wire [7:0] A_exp,
    input wire [7:0] B_exp,
    output wire [7:0] diff,
    output wire [1:0] sel
);

    //find -A.exp and -B.exp:

    wire [7:0] inv_A_exp, inv_B_exp, neg_A_exp, neg_B_exp;

    invn #(.NUM_INPUTS(8)) inv0(.in(A_exp), .out(inv_A_exp));
    invn #(.NUM_INPUTS(8)) inv1(.in(B_exp), .out(inv_B_exp));

    kogeAdder #(.WIDTH(8)) adder0(.SUM(neg_A_exp), .COUT(), .A(inv_A_exp), .B(23'b1), .Cin(1'b0));
    kogeAdder #(.WIDTH(8)) adder1(.SUM(neg_B_exp), .COUT(), .A(inv_B_exp), .B(23'b1), .Cin(1'b0));

    //find A.exp - B.exp and B.exp - A.exp:
    

endmodule