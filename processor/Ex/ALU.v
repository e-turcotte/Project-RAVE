module ALU_top(
    output[63:0] ALU_OUT,
    output [31:0] OP1_DEST,

    output cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out,
    input [63:0] OP1,
    input [63:0] OP2,
    input [63:0] OP3,

    input [31:0] OP1_ORIG,
    input [4:0] aluk,
    input [2:0] MUX_ADDER_IMM,
    input MUX_AND_INT,
    input MUX_SHF,
    input CMPXCHNG_P_OP,
    //input EFLAGS
    input zf, cf
);

//WHYHYYHY
//doflags
//aluk = 00000
wire[63:0] and_out;
AND_alu a1(and_out,OP1,OP2,MUX_AND_INT);

//do flags
//aluk = 00001
wire[63:0] add_out;
wire add_cout;
ADD_alu a2(add_out, add_cout, OP1, OP2, MUX_ADDER_IMM);

//do flags
//aluk = 00010
wire[63:0] penc_out;
wire penc_zf;
wire penc_invalid;
PENC_alu p1(penc_out, penc_zf, penc_invalid, OP1);

//aluk = 00011
wire[63:0] passB;
assign passB = OP2;

//aluk = 00100
wire[63:0] passA;
assign passA = OP1;

//aluk = 00101
wire[63:0] pass0;
wire cld_df;
assign cld_df = 1;
assign pass0 = 64'd0;

//aluk = 00110
wire[63:0] pass1;
wire std_df;
assign std_df = 1;
assign pass1 = 64'd1;

//do flags
//aluk = 00111
wire[63:0] cmpxchng_out;
wire cmpxchng_zf;
CMPXCHNG_alu a3(cmpxchng_out, OP1_DEST, cmpxchng_zf, OP1, OP2, OP3,OP1_ORIG, CMPXCHNG_P_OP);

//do parity
//aluk = 01000
wire[63:0] daa_out;
wire daa_cf;
wire daa_af;
DAA_alu d1(daa_out, daa_af, daa_cf, OP1, af, cf );

 //NOTA_alu
//aluk = 01001
wire [63:0] notA_out;
inv_n #(64) i1(notA_out, OP1);

//do flags
//aluk = 01001
wire or_cf, or_of;
wire[63:0] or_out;
OR_alu o1(or_out, or_cf, or_of, OP1, OP2);

//aluk = 01010
wire[63:0] paddw_out; 
PADDW_alu p2(paddw_out, OP1, OP2);

//aluk = 01011
wire[63:0] paddd_out; 
PADDD_alu p3(paddd_out, OP1, OP2);

//aluk = 01100
wire[63:0] packsswb_out;
PACKSSWB_alu p4(packsswb_out, OP1, OP2);

//aluk = 01101
wire[63:0] packssdw_out;
PACKSSDW_alu p5(packssdw_out, OP1, OP2);

//aluk = 01110
wire[63:0] punpckhbw_out;
PUNPCKHBW_alu p6 (punpckhbw_out, OP1, OP2);

//aluk = 01111
wire[63:0] punpckhw_out;
PUNPCKHW_alu p7 (punpckhw_out, OP1, OP2);

//do flags
//aluk = 10000
wire[63:0] sar_out;
SAR_alu s1(sar_out, OP1, OP2, MUX_SHF);

//do flags
//aluk = 10001
wire[63:0] sal_out;
SAL_alu s2(sal_out, OP1, OP2, MUX_SHF);

wire[31:0] alukOH;
decodern #(5) d2(aluk, alukOH);

wire[1215:0] aluRes;
assign aluRes = {sal_out, sar_out, punpckhw_out, punpckhbw_out,packssdw_out, packsswb_out, paddd_out, paddw_out, or_out,notA_out, daa_out, cmpxchng_out, pass1, pass0, passA, passB, penc_out,add_out,and_out};
muxnm_tristate #(32,64) t1(aluRes, alukOH, ALU_OUT);

endmodule

///////////////////////////////////////////////////////////

module SAL_alu(
    output [63:0] SAR_out,
    input [63:0] OP1, OP2, 
    input MUX_SHF
);
wire[31:0] shiftCnt;
mux2n #(32) m2(shiftCnt, OP2[31:0], 32'd1);
lshfn_variable #(32) r1(OP1, shiftCnt, 1'b0, SAR_out);
assign SAR_out[63:32] = 32'd0;
endmodule


///////////////////////////////////////////////////////////

module SAR_alu(
    output [63:0] SAR_out,
    input [63:0] OP1, OP2, 
    input MUX_SHF
);
wire[31:0] shiftCnt;
mux2n #(32) m1 (shiftCnt, OP2[31:0], 32'd1);
rshfn_variable #(32)  r1(OP1, shiftCnt, OP1[31], SAR_out);
assign SAR_out[63:32] = 32'd0;
endmodule

///////////////////////////////////////////////////////////

module PUNPCKHW_alu(
    output [63:0] punpckhw_out,
    input [63:0] OP1, OP2
);
    assign punpckhw_out[15:0] =  OP1[47:32];
    assign punpckhw_out[31:16] = OP2[47:32];
    assign punpckhw_out[47:32] = OP1[63:48];
    assign punpckhw_out[63:48] = OP2[63:48];
    
endmodule

///////////////////////////////////////////////////////////

module PUNPCKHBW_alu(
    output [63:0] punpckhbw_out,
    input [63:0] OP1, OP2
);
    assign punpckhbw_out[7:0] = OP1[39:32];
    assign punpckhbw_out[15:8] = OP2[39:32];
    assign punpckhbw_out[23:16] = OP1[47:40];
    assign punpckhbw_out[31:24] = OP2[47:40];
    assign punpckhbw_out[39:32] = OP1[55:48];
    assign punpckhbw_out[47:40] = OP2[55:48];
    assign punpckhbw_out[55:48] = OP1[63:56];
    assign punpckhbw_out[63:56] = OP2[63:56];
endmodule

///////////////////////////////////////////////////////////

module PACKSSDW_alu(
    output [63:0] packssdw_out,
    input [63:0] OP1, OP2
);
    genvar i;
    wire[7:0] cout;
    generate 
        for(i = 0; i < 2; i = i + 1) begin : iterate
            satAdder #(16) a(packssdw_out[16*i+15:8*i],cout[i], OP1[32*i+31:32*i+16], OP1[32*i+15:16*i], 1'b0 );
            satAdder #(16) b(packssdw_out[16*i+15+32:16*i+32],cout[i+4], OP2[32*i+31:32*i+16], OP2[32*i+31:32*i], 1'b0 );
        end
    endgenerate
endmodule

///////////////////////////////////////////////////////////

module PACKSSWB_alu(
    output [63:0] packsswb_out,
    input [63:0] OP1, OP2
);
    genvar i;
    wire[7:0] cout;
    generate 
        for(i = 0; i < 4; i = i + 1) begin : iterate
            satAdder #(8) a(packsswb_out[8*i+7:8*i],cout[i], OP1[16*i+15:16*i+8], OP1[16*i+7:16*i], 1'b0 );
            satAdder #(8) b(packsswb_out[8*i+7+32:8*i+32],cout[i+4], OP2[16*i+15:16*i+8], OP2[16*i+7:16*i], 1'b0 );
        end
    endgenerate
endmodule

///////////////////////////////////////////////////////////

module PADDD_alu(
    output [63:0] paddd_out,
    input [63:0] OP1, OP2
);
    genvar i;
    wire[3:0] cout;
    generate 
        for(i = 0; i < 2; i = i + 1) begin : iterate
            kogeAdder #(32) a(paddd_out[32*i+31:32*i],cout[i], OP1[32*i+31:32*i], OP2[32*i+31:32*i], 1'b0 );
        end
    endgenerate
endmodule

///////////////////////////////////////////////////////////

module PADDW_alu(
    output [63:0] paddw_out,
    input [63:0] OP1, OP2
);
    genvar i;
    wire[3:0] cout;
    generate 
        for(i = 0; i < 4; i = i + 1) begin : iterate
            kogeAdder #(16) a(paddw_out[16*i+15:16*i],cout[i], OP1[16*i+15:16*i], OP2[16*i+15:16*i], 1'b0 );
        end
    endgenerate
endmodule

///////////////////////////////////////////////////////////

module OR_alu(
    output[63:0] or_out,
    output or_of, or_cf,
    input [63:0] OP1, OP2
);
 genvar i;
 generate
    for(i = 0; i < 64; i = i + 1) begin : ord
        or2$ o1(or_out[i], OP1[i], OP2[i]);
    end
 endgenerate
 assign or_of = 0; 
 assign or_cf = 0;
endmodule


////////////////////////////////////////////////////////////

module DAA_alu(
    output [63:0] daa_out,
    output daa_af, daa_cf,
    input [63:0] OP1,
    input af, cf
);

//Perform AL&x0F > 9
or3$ o1(grt9, OP1[0], OP1[1], OP1[2]);
and2$ a1(isGreat, grt9, OP1[3]);
or2$ o2(daa_af, af, isGreat);

//Handle fist if satement
wire[7:0] inc6;
wire cout6;
kogeAdder #(8) k1(inc6, cout6, OP1[7:0], 8'd6, 1'b0);
wire[7:0] newAL;
mux2n #(8) m1(newAL, OP1[7:0], inc6, daa_af);

//Handle second if statement
wire AGB, BGA, cout60;
wire[7:0] inc60;
mag_comp8$ m2(newAL, 8'h99, AGB, BGA);
kogeAdder #(8) k2(inc60, cout60, newAL, 8'h60, 1'b0);
or2$ o3(mux2, cf, AGB);

mux2n #(8) m3(daa_out[7:0], newAL, inc60, mux2);
assign daa_out[63:8] = 56'd0;

//compute CF
and2$ a4(cf_firstIF, daa_af, cout6);
or3$ o4 (daa_cf, cf, mux2 );

endmodule


/////////////////////////////////////////////////////////////////////////////

module CMPXCHNG_alu(
    output[63:0] cmpxchng_out,
    output [31:0] op1_dest,
    output cmpxchng_zf,
    input [63:0] OP1, OP2, OP3,
    input [31:0] op1_orig,
    input cmpxchng_p_op

);
    assign cmpxchng_zf = op1_EQ_op3;
    wire isCMPXCHNG;
    wire op1_EQ_op3;
    equaln #(32) e1(OP1[31:0], OP3[31:0], op1_EQ_op3);
    // wire[4:0] alukProper;
    
    // inv_n #(2) in1(alukProper[4:3], aluk[4:3]);
    // assign alukProper[2:0] = aluk[2:0];
    
    wire[31:0] mux1_out;
    mux2n #(32) m1(mux1_out, 32'd0, op1_orig, op1_EQ_op3);

    mux2n #(32) m2(op1_dest, op1_orig, mux1_out, cmpxchng_p_op);

    
    mux2n #(64) m3(cmpxchng_out, OP1, OP2, op1_EQ_op3);

endmodule

/////////////////////////////////////////////

module PENC_alu(
    output [63:0] penc_out,
    output invalid,
    output penc_zf,
    input [63:0] penc_in
);
wire[4:0] penc_val;
wire penc_valid;

pencoder32_5 p1(penc_val, penc_valid, penc_in[31:0]);

inv1$ n1(invalid, penc_valid);
assign penc_zf = invalid;
assign penc_out = {59'd0,penc_val};

endmodule

////////////////////////////////////////////

module AND_alu(
    output[63:0] AND_ALU_OUT,
    input [63:0] OP1, OP2,
    input MUX_ADDER_INT
);
    wire[63:0] clear_high;
    assign clear_high = 64'h0000_0000_0000_FFFF;
    wire[63:0] mux_out;
    mux2n #(64) m1(mux_out,OP2, clear_high, MUX_ADDER_INT);
    and2n #(64) a1(AND_ALU_OUT, OP1, mux_out);
endmodule

////////////////////////////////////////////////

module ADD_alu(
    output[63:0] ADD_ALU_OUT,
    output COUT,
    input[63:0] OP1, OP2,
    input[2:0] MUX_ADDER_IMM
);
    wire [31:0] mux_res;
    wire[31:0] adderResult;
    mux8_n #(32) m1(mux_res, OP2[31:0], 32'd2, 32'd4, 0, 32'd6, 32'hFFFF_FFFE, 32'hFFFF_FFFC, 0, MUX_ADDER_IMM[0],MUX_ADDER_IMM[1], MUX_ADDER_IMM[2]);
    kogeAdder #(32) a1(adderResult, COUT, OP1[31:0], mux_res, 1'b0);
    
    wire[63:0] ext1;
    wire[63:0] ext0;
    assign ext0 = {32'h0000_0000, adderResult};
    assign ext1 = {32'hFFFF_FFFF, adderResult};

    mux2n #(64) m2(ADD_ALU_OUT, ext0, ext1, adderResult[31]);

endmodule


/////////////////////////////////////////////
 

/////////////////////////////////////////
module and2n #(parameter DATA_WIDTH = 32)(
    output [DATA_WIDTH-1:0] OUT,
    input [DATA_WIDTH-1:0] A,B
    
);

genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i=i+1) begin : nmux
        and2$ m(OUT[i], A[i], B[i]);
    end
endgenerate

endmodule 

module parityGen #(parameter WIDTH = 32) (
    output pf,
    input [WIDTH-1:0] OP
);
if(WIDTH == 4)begin 
    par4 p1(pf, OP);
end
else if(WIDTH==8) begin
    par8 p2(pf, OP);
end

else if(WIDTH==16) begin
    par16 p3(pf, OP);
end

else if(WIDTH==32) begin
    par32 p4(pf, OP);
end

endmodule

//////////////////////////////////////////


module par4(
    output pf,
    input[3:0] OP
);

    xor4$ x1(pf, OP[3], OP[2], OP[1], OP[0]);    

endmodule 

//////////////////////////////////////////

module par8(
    output pf,
    input[7:0] OP
);
wire [3:0] x1;
genvar i;
generate
    for(i = 0; i < 4; i= i + 1) begin : xor1
        xor2$ x(x1[i], OP[2*i], OP[2*i+1]);
    end
endgenerate 
xor4$ x2(pf, x1[0], x1[2], x1[3],x1[1]);
endmodule 

//////////////////////////////////////////

module par16(
    output pf,
    input[15:0] OP
);
    genvar i;
    wire [3:0] x1;
    generate
        for(i = 0; i < 4; i= i + 1) begin : xor1
            xor4$ x(x1[i], OP[4*i], OP[4*i+1], OP[4*i+2], OP[4*i+3]);
        end
    endgenerate
    xor4$ x2(pf, x1[0], x1[2], x1[3],x1[1]);
endmodule 

//////////////////////////////////////////

module par32(
    output pf,
    input[31:0] OP
);
    genvar i;
    wire [7:0] x1;
    generate
        for(i = 0; i < 8; i= i + 1) begin : xor1
            xor4$ x(x1[i], OP[4*i], OP[4*i+1], OP[4*i+2], OP[4*i+3]);
        end
    endgenerate
    xor4$ x4(pf1, x1[0], x1[2], x1[3],x1[1]);
    xor4$ x5(pf2, x1[4], x1[5], x1[6],x1[7]);
    xor2$ x6(pf, pf1, pf2);
endmodule 