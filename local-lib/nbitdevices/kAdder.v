module kogeAdder #(parameter WIDTH = 32)(
    output [WIDTH-1:0] SUM, 
    output COUT,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input CIN
);
wire [WIDTH:0] P, G, G_OUT;
pg_stage #(WIDTH) pg(P, G, A,B, CIN );

body_pg #(WIDTH) bpg(G_OUT, P, G);
assign G_OUT[WIDTH] = G[WIDTH];

sum_stage #(WIDTH) ss(SUM, COUT, P, G_OUT);

endmodule

//////////////////////////////////////////////////
// Implementation Below
//////////////////////////////////////////////////

module pg_stage #(parameter WIDTH = 32) (
    output [WIDTH:0] P, G,
    input [WIDTH-1:0] A, B, 
    input CIN
);  
    assign  P[0] = 0;
    assign  G[0] = CIN;
    genvar i;
    generate
        for (i = 1; i <= WIDTH; i = i + 1) begin : pg_stg
            pg_cell pg0(P[i], G[i], A[i-1], B[i-1]);
        end
    endgenerate
endmodule

////////////////////////////


module body_pg #(parameter WIDTH = 32) (
    output [WIDTH-1:0] G_out,
    input [WIDTH-1:0] P,
    input [WIDTH-1:0] G
);



if(WIDTH <= 4) begin
    
end

else if(WIDTH <= 8) begin

end

else if(WIDTH <=16) begin
    body_16 b3(G_out, P, G);
end

else if(WIDTH <= 32) begin
   body_32 b4(G_out, P, G);
end


endmodule

////////////////////////////

module sum_stage #(parameter WIDTH = 32) (
    output [WIDTH-1:0] S, 
    output COUT,
    input [WIDTH:0]P,
    input [WIDTH:0]G
);
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : sumStg
        xor2$ x(S[i], G[i], P[i+1]);
    end
endgenerate
    grey_cell g1(COUT, G[WIDTH],P[WIDTH], G[WIDTH-1] );
endmodule

////////////////////////////


module grey_cell(
    output g,   
    input g0, p0, 
    input g1
);
wire temp;
wire temp2;
   nand2$ n1(temp, g1, p0);
   inv1$ n2(temp2, g0);
   nand2$ n3(g, temp, temp2);


endmodule

////////////////////////////

module black_cell(
    output g, p,   
    input g0,p0, g1,p1
    
);
   
 wire temp;
 wire temp2;
    nand2$ n1(temp, g1, p0);
    inv1$ n2(temp2, g0);
    nand2$ n3(g, temp, temp2);
    
    nand2$ n4(temp3, p1, p0);
    inv1$ n5(p, temp3);
endmodule 

////////////////////////////

module body_16(
output [15:0] C,   
input [15:0] P,
input [15:0] G
);
integer greyCnt = 1;
integer blackCnt = 14;
wire[15:0] P_1;
wire[15:0] G_1;
wire[15:0] P_2;
wire[15:0] G_2;
wire[15:0] P_3;
wire[15:0] G_3;
wire[15:0] P_4;
wire[15:0] G_4;
wire[15:0] P_5;
wire[15:0] G_5;
parameter WIDTH = 16;
assign G_1[0] = G[0];
genvar i;

////////////////////////////////////////////
// Row 1
////////////////////////////////////////////

generate
    for( i = 1; i < 2; i = i + 1) begin :row1g
        grey_cell g1(G_1[1], G[1], P[1], G[0]);
    end
endgenerate


generate
    for( i = 2 ; i < WIDTH; i = i + 1) begin :row1b
        black_cell b(G_1[i], P_1[i], G[i], P[i], G[i-1], P[i-1]);
    end
endgenerate

////////////////////////////////////////////
// Row 2
////////////////////////////////////////////

generate
    for( i = 0; i < 2; i = i + 1) begin :row2c
        assign G_2[i] = G_1[i];
    end
endgenerate

generate
    for( i = 2; i < 4; i = i + 1) begin :row2g
        grey_cell g1(G_2[i], G_1[i], P_1[i], G_1[i-2]);
    end
endgenerate

generate
    for( i = 4; i < WIDTH; i = i + 1) begin :row2b
        black_cell b(G_2[i], P_2[i], G_1[i], P_1[i], G_1[i-2], P_1[i-2]);
    end
endgenerate

////////////////////////////////////////////
// Row 3
////////////////////////////////////////////

generate
    for( i = 0; i < 4; i = i + 1) begin :row3c
        assign G_3[i] = G_2[i];
    end
endgenerate

generate
    for( i = 4; i < 8; i = i + 1) begin :row3g
        grey_cell g1(G_3[i], G_2[i], P_2[i], G_2[i-4]);
    end
endgenerate

generate
    for( i = 8 ; i < WIDTH; i = i + 1) begin :row3b
        black_cell b(G_3[i], P_3[i], G_2[i], P_2[i], G_2[i-4], P_2[i-4]);
    end
endgenerate

////////////////////////////////////////////
// Row 4
////////////////////////////////////////////

generate
    for( i = 0; i < 8; i = i + 1) begin :row4c
        assign G_4[i] = G_3[i];
    end
endgenerate

generate
    for( i = 8; i < 16; i = i + 1) begin :row4g
        grey_cell g1(G_4[i], G_3[i], P_3[i], G_3[i-8]);
    end
endgenerate

generate
    for( i = 16 ; i < WIDTH; i = i + 1) begin :row4b
        black_cell b(G_4[i], P_4[i], G_3[i], P_3[i], G_3[i-8], P_3[i-8]);
    end
endgenerate

//////////////////////////////////////////////
// Calculate Result
//////////////////////////////////////////////
assign C = G_4;

endmodule





module pg_cell  (
    output  P, G,
    input A, B
);

xor2$ x1(P, A, B);
and2$ x2(G, A,B);

endmodule

module body_32(
output [31:0] C,   
input [31:0] P,
input [31:0] G
);

wire[31:0] P_1;
wire[31:0] G_1;
wire[31:0] P_2;
wire[31:0] G_2;
wire[31:0] P_3;
wire[31:0] G_3;
wire[31:0] P_4;
wire[31:0] G_4;
wire[31:0] P_5;
wire[31:0] G_5;
parameter WIDTH = 32;
assign G_1[0] = G[0];
genvar i;

////////////////////////////////////////////
// Row 1
////////////////////////////////////////////

generate
    for( i = 1; i < 2; i = i + 1) begin :row1g
        grey_cell g1(G_1[1], G[1], P[1], G[0]);
    end
endgenerate


generate
    for( i = 2 ; i < WIDTH; i = i + 1) begin :row1b
        black_cell b(G_1[i], P_1[i], G[i], P[i], G[i-1], P[i-1]);
    end
endgenerate

////////////////////////////////////////////
// Row 2
////////////////////////////////////////////

generate
    for( i = 0; i < 2; i = i + 1) begin :row2c
        assign G_2[i] = G_1[i];
    end
endgenerate

generate
    for( i = 2; i < 4; i = i + 1) begin :row2g
        grey_cell g1(G_2[i], G_1[i], P_1[i], G_1[i-2]);
    end
endgenerate

generate
    for( i = 4; i < WIDTH; i = i + 1) begin :row2b
        black_cell b(G_2[i], P_2[i], G_1[i], P_1[i], G_1[i-2], P_1[i-2]);
    end
endgenerate

////////////////////////////////////////////
// Row 3
////////////////////////////////////////////

generate
    for( i = 0; i < 4; i = i + 1) begin :row3c
        assign G_3[i] = G_2[i];
    end
endgenerate

generate
    for( i = 4; i < 8; i = i + 1) begin :row3g
        grey_cell g1(G_3[i], G_2[i], P_2[i], G_2[i-4]);
    end
endgenerate

generate
    for( i = 8 ; i < WIDTH; i = i + 1) begin :row3b
        black_cell b(G_3[i], P_3[i], G_2[i], P_2[i], G_2[i-4], P_2[i-4]);
    end
endgenerate

////////////////////////////////////////////
// Row 4
////////////////////////////////////////////

generate
    for( i = 0; i < 8; i = i + 1) begin :row4c
        assign G_4[i] = G_3[i];
    end
endgenerate

generate
    for( i = 8; i < 16; i = i + 1) begin :row4g
        grey_cell g1(G_4[i], G_3[i], P_3[i], G_3[i-8]);
    end
endgenerate

generate
    for( i = 16 ; i < WIDTH; i = i + 1) begin :row4b
        black_cell b(G_4[i], P_4[i], G_3[i], P_3[i], G_3[i-8], P_3[i-8]);
    end
endgenerate

////////////////////////////////////////////
// Row 5
////////////////////////////////////////////

generate
    for( i = 0; i < 16; i = i + 1) begin :row5c
        assign G_5[i] = G_4[i];
    end
endgenerate

generate
    for( i = 16; i < 32; i = i + 1) begin :row5g
        grey_cell g1(G_5[i], G_4[i], P_4[i], G_4[i-16]);
    end
endgenerate

generate
    for( i = 32 ; i < WIDTH; i = i + 1) begin :row5b
        black_cell b(G_5[i], P_5[i], G_4[i], P_4[i], G_4[i-8], P_4[i-16]);
    end
endgenerate

//////////////////////////////////////////////
// Calculate Result
//////////////////////////////////////////////
assign C[31:0] = G_5[31:0];


endmodule



