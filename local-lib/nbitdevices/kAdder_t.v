`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2024 07:00:59 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(
    
    );
    reg[31:0] A, B;
    reg CIN;
    wire[31:0] C_32;
    wire[15:0] C_16;
    wire[7:0] C_8;
    wire[3:0] C_4;
    wire[5:0] C_6;
    
    wire COUT_32, COUT_16;
    wire COUT_8, COUT_4, COUT_6;
    wire [31:0] expected;
    assign expected = A + B + CIN;
    wire [32:0] p_expected;
    wire [31:0] g1, p1;
    assign p_expected = {A ^ B,1'b0};
    wire [32:0] g_expected;
    assign g_expected = {A & B,CIN};
    kogeAdder #(16) b1(C_16, COUT_16, A[15:0], B[15:0], CIN);
    kogeAdder #(32) b2(C_32, COUT_32, A, B, CIN);
    kogeAdder #(8) b3(C_8, COUT_8, A[7:0], B[7:0], CIN);
    kogeAdder #(4) b4(C_4, COUT_4, A[3:0], B[3:0], CIN);
    kogeAdder #(6) b5(C_6, COUT_6, A[5:0], B[5:0], CIN);
    assign g1[0] = CIN;
    assign p1[0] = 0;
    genvar i;
    generate
    
    for(i = 1; i < 2; i= i+1) begin : G1G
        assign g1[i] = (p_expected[i] & g_expected[i-1]) | g_expected[i]; 
    end
    endgenerate 
    
    generate
    
    for(i = 2; i < 32; i= i+1) begin : G1B
        assign g1[i] = (p_expected[i] & g_expected[i-1]) | g_expected[i];
        assign p1[i] = p_expected[i] & p_expected[i-1];
    end
    endgenerate 
    
    initial begin
    A = 0; 
    B = 0;
    CIN = 0;
    #20
    CIN = 1;
    #20
    A = 32'hFFFF_FFFF;
    #20
    B = 32'hFFFF_FFFF;
    A = 0;
    #20
    CIN = 0;
    A = 32'h5555_5555;
    B = 32'hAAAA_AAAA;
    #20
    CIN = 1;
    #20 CIN = 0;
    
    A = 32'h1111_2222;
    B = 32'h1212_1212;
    #20
    CIN = 1;
    
    #20 CIN = 0;
    A = 0; B = 0;
    
    #20
    A=  32'hFFFF_FFFF;
    B = 1;
    
    #20
    A=  32'h0000_003F;
    B = 1;
    
//    for( i = 0; i < 4; i = i + 1) begin
//        for( j = 0; j < 4; j = j + 1) begin
//            #20
//            pg0 = i;
//            pg1 = j;
            
//        end
//    end
    
    end
    
endmodule
