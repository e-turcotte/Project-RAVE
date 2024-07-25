module ALU_top(
    output[63:0] ALU_OUT,
    output[63:0] ALU_OUT_2,
    output swapCXC,
    output cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out,
    output cc_inval,
    input [63:0] OP1,
    input [63:0] OP2,
    input [63:0] OP3,

    input [31:0] OP1_ORIG,
    input [4:0] aluk,
    input [2:0] MUX_ADDER_IMM,
    input MUX_AND_INT,
    input MUX_SHF,
    input CMPXCHNG_P_OP,
    input BSF_P_OP,
    input STD_P_OP,
    input SAR_P_OP,
    input SAL_P_OP,

    input [1:0] size,
    //input EFLAGS
    input  af, cf, of, zf,
    input[15:0] CS,
    input[31:0] EIP
);
//CCGEN
wire zf_base; wire penc_zf;
wire cmpxchng_zf;
// assign pf_out = ALU_OUT[0];
xor4$ par0(pfx0,ALU_OUT[0],ALU_OUT[1],ALU_OUT[2],ALU_OUT[3] );
xor4$ par1(pfx1,ALU_OUT[4],ALU_OUT[5],ALU_OUT[6],ALU_OUT[7] );
xnor2$ par2(pf_out, pfx0, pfx1);
mux4$ m10(sf_out, ALU_OUT[7], ALU_OUT[15], ALU_OUT[31], ALU_OUT[63], size[0], size[1]);

wire [63:0] fix_alu_zf, fin_alu_zf;
mux4n #(64) (fix_alu_zf, 64'h0000_0000_0000_00FF, 64'h0000_0000_0000_FFFF, 64'h0000_0000_FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF, size[0], size[1] );
genvar k;
for(k = 0; k < 64; k = k +1) begin :kfix
    and2$ (fin_alu_zf[k], fix_alu_zf[k], ALU_OUT[k]);
end
orn #(64) o10 (fin_alu_zf[63:0], zf_basex);
inv1$ o125(zf_base, zf_basex);
mux3$ z1(zf_out, zf_base, penc_zf, cmpxchng_zf, BSF_P_OP, CMPXCHNG_P_OP);
assign df_out = STD_P_OP;

assign ALU_OUT_2 = OP2;
//WHYHYYHY
//doflags
//aluk = 00000
wire[63:0] and_out;
wire and_of, and_cf, and_af;
assign and_of = 1'b0; assign and_cf = 1'b0; assign and_af = 1'b0;
AND_alu a1(and_out, OP1,OP2,MUX_AND_INT);

//do flags
//aluk = 00001
wire[63:0] add_out;
wire add_cf, add_of, add_af;
ADD_alu a2(add_out, add_af, add_cf, add_of, OP1, OP2, MUX_ADDER_IMM, size);

//do flags
//aluk = 00010
wire[63:0] penc_out;

wire penc_invalid;
wire penc_cf, penc_of, penc_af;
assign penc_cf = 0; assign penc_of = 0; assign penc_af = 0;
PENC_alu p1(penc_out, penc_zf, penc_invalid, OP1);

//aluk = 00011
wire movB_cf, movB_of, movB_af;
assign movB_cf = 0; assign movB_of = 0; assign movB_af = 0;
wire[63:0] passB;
assign passB = OP2;

//aluk = 00100
wire movA_cf, movA_of, movA_af;
assign movA_cf = 0; assign movA_of = 0; assign movA_af = 0;
wire[63:0] passA;
assign passA = OP1;

//aluk = 00101
wire cld_cf, cld_of, cld_af;
assign cld_cf = 0; assign cld_of = 0; assign cld_af = 0;
wire[63:0] pass0;
wire cld_df;
assign cld_df = 1;
assign pass0 = 64'd0;

//aluk = 00110
wire std_cf, std_of, std_af;
assign std_cf = 0; assign std_of = 0; assign std_af = 0;
wire[63:0] pass1;
wire std_df;
assign std_df = 1;
assign pass1 = 64'd1;

//do flags
//aluk = 00111
wire[63:0] cmpxchng_out;
 wire cmpxchng_af;wire cmpxchng_cf;wire cmpxchng_of;
CMPXCHNG_alu a3(cmpxchng_out, swapCXC, cmpxchng_af, cmpxchng_cf, cmpxchng_of,  cmpxchng_zf, OP1, OP2, OP3,OP1_ORIG, CMPXCHNG_P_OP);

//do parity
//aluk = 01000
wire[63:0] daa_out;
wire daa_cf;
wire daa_af;
wire daa_of; assign daa_of = 0;
DAA_alu d1(daa_out, daa_af, daa_cf, OP1, af, cf );

 //NOTA_alu
//aluk = 01001
wire not_af; assign not_af = 0;
wire not_cf; assign not_cf = 0;
wire not_of; assign not_of = 0;
wire [63:0] notA_out;
inv_n #(64) i1(notA_out, OP1);

//do flags
//aluk = 01010
wire or_af; assign or_af = 0;
wire or_cf; assign or_cf = 0;
wire or_of; assign or_of = 0;

wire[63:0] or_out;
OR_alu o1(or_out,  OP1, OP2);

//aluk = 01011
wire[63:0] paddw_out; 
PADDW_alu p2(paddw_out, OP1, OP2);

//aluk = 01100
wire[63:0] paddd_out; 
PADDD_alu p3(paddd_out, OP1, OP2);

//aluk = 01101
wire[63:0] packsswb_out;
PACKSSWB_alu p4(packsswb_out, OP1, OP2);

//aluk = 01110
wire[63:0] packssdw_out;
PACKSSDW_alu p5(packssdw_out, OP1, OP2);

//aluk = 01111
wire[63:0] punpckhbw_out;
PUNPCKHBW_alu p6 (punpckhbw_out, OP1, OP2);

//aluk = 10000
wire[63:0] punpckhw_out;
PUNPCKHW_alu p7 (punpckhw_out, OP1, OP2);

//do flags
//aluk = 10001
wire[63:0] sar_out;
wire sar_af; 
wire sar_cf; 
wire sar_of; 
wire sar_cc_val;
SAR_alu s1(sar_out,sar_af, sar_cf, sar_of, sar_cc_val, OP1, OP2, MUX_SHF, of);

//do flags
//aluk = 10010
wire[63:0] sal_out;
wire sal_af; 
wire sal_cf; 
wire sal_of; 
wire sal_cc_val;
SAL_alu s2(sal_out,sal_af, sal_cf, sal_of, sal_cc_val, OP1, OP2, MUX_SHF, of);
nand2$ o11(cc_val, sar_cc_val,SAR_P_OP );
nand2$ o12(isSHF,sal_cc_val , SAL_P_OP);
nand2$ a12(cc_inval, cc_val, isSHF);

//aluk = 10011
wire[63:0] cmovc_out;
mux2n #(64) mxCMC(cmovc_out, OP1, OP2, cf);

wire [63:0] ptr_out;


wire[31:0] alukOH;
decodern #(5) d2(aluk, alukOH); 

wire[1279:0] aluRes;
assign aluRes = {cmovc_out, sal_out, sar_out, punpckhw_out, punpckhbw_out,packssdw_out, packsswb_out, paddd_out, paddw_out, or_out,notA_out, daa_out, cmpxchng_out, pass1, pass0, passA, passB, penc_out,add_out,and_out};
muxnm_tristate #(32,64) t1(aluRes, alukOH, ALU_OUT);


wire [31:0] af_sel;
assign af_sel = {13'd0, sal_af, sar_af, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, or_af, not_af, daa_af, cmpxchng_af, std_af, cld_af, movA_af, movB_af, penc_af, add_af, and_af};

wire [31:0] cf_sel;
assign cf_sel = {13'd0, sal_cf, sar_cf, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, or_cf, not_cf, daa_cf, cmpxchng_cf, std_cf, cld_cf, movA_cf, movB_cf, penc_cf, add_cf, and_cf};

wire [31:0] of_sel;
assign of_sel = {13'd0, sal_of, sar_of, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, or_of, not_of, daa_of, cmpxchng_of, std_of, cld_of, movA_of, movB_of, penc_of, add_of, and_of};

muxnm_tristate #(32,1) t2(af_sel, alukOH, af_out);
muxnm_tristate #(32,1) t3(cf_sel, alukOH, cf_out);
muxnm_tristate #(32,1) t4(of_sel, alukOH, of_out);

endmodule



///////////////////////////////////////////////////////////

module SAL_alu(
    output [63:0] SAL_out,
    output sal_af,
    output sal_cf,
    output sal_of,
    output cc_val,
    input [63:0] OP1, OP2, 
    input MUX_SHF,
    input of
);
wire[31:0] shiftCnt, shiftCntN;
wire[31:0] inpCap;
//assign inpCap[31:8] = 24'h0000_00;
//assign inpCap[7:0] = OP2[7:0];
decodern #(5) d1(OP2[4:0], inpCap);
mux2n #(32) m1 (shiftCnt, inpCap, 32'd2, MUX_SHF);
wire[31:0] shf_out;
lshfn_variable #(32)  r1(OP1[31:0], shiftCnt, 1'b0, shf_out);
assign SAL_out[63:32] = 32'd0;

wire overSHF;
genvar i;

equaln #(5) e1(shiftCnt[4:0], 5'b00010, of_sel);




//genCF

inv_n #(32) iv(shiftCntN, shiftCnt);
muxnm_tristate #(32, 1) mx3({1'b0,OP1[30:0]}, shiftCnt, SAR_cf_nOF);
mux2$ mx4(sal_cf, SAR_cf_nOF, OP1[31], overSHF);

or3$ o1(overSHF, OP2[6], OP2[7], OP2[5]);
mux2$ mx1(sal_of, of, OP1[31], of_sel);
assign sal_af = 0;
inv1$ asax(mux_shf_n, MUX_SHF);
and2$ xzs(overSHF_adj ,overSHF, mux_shf_n);
//TODO: check here
mux2n #(32) mx(SAL_out[31:0], shf_out, 32'd0 ,overSHF_adj);
equaln #(32) mx5(32'd0, shiftCnt, cc_val);

endmodule


///////////////////////////////////////////////////////////

module SAR_alu(
    output [63:0] SAR_out,
    output sar_af,
    output sar_cf,
    output sar_of,
    output cc_val,
    input [63:0] OP1, OP2, 
    input MUX_SHF,
    input of
);
wire[31:0] shiftCnt;
wire[31:0] inpCap;
//assign inpCap[31:8] = 24'h0000_00;
//assign inpCap[7:0] = OP2[7:0];
decodern #(5) d1(OP2[4:0], inpCap);
mux2n #(32) m1 (shiftCnt, inpCap, 32'd2, MUX_SHF);
wire[31:0] shf_out;
rshfn_variable #(32)  r1(OP1[31:0], shiftCnt, OP1[31], shf_out);
assign SAR_out[63:32] = 32'd0;

wire overSHF;
or3$ o1(overSHF, OP2[6], OP2[7], OP2[5]);
equaln #(5) e1(shiftCnt[4:0], 5'b00010, of_sel);

mux4n #(32) mx(SAR_out[31:0], shf_out, 32'd0 ,shf_out ,32'hFFFF_FFFF ,overSHF_adj, OP1[31]);


inv1$ asaxas(mux_shf_n, MUX_SHF);
and2$ asax(overSHF_adj ,overSHF, mux_shf_n);
//genCF
muxnm_tristate #(32, 1) mx1({OP1[30:0],1'b0}, shiftCnt, SAR_cf_nOF);
mux2$ mx2(sar_cf, SAR_cf_nOF, OP1[31], overSHF);

or3$ o2(overSHF, OP2[6], OP2[7], OP2[5]);
mux2$ mx3(sar_of,OP1[0],of, of_sel);

assign sar_af = 0;
equaln #(32) eq1(32'd0, shiftCnt, cc_val);
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
            satAdder #(16) a(packssdw_out[16*i+15:16*i],cout[i], OP1[32*i+31:32*i+16], OP1[32*i+15:32*i], 1'b0 );
            satAdder #(16) b(packssdw_out[16*i+15+32:16*i+32],cout[i+4], OP2[32*i+31:32*i+16], OP2[32*i+15:32*i], 1'b0 );
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
    wire [3:0] is_over_1, is_over_2, is_under_1, is_under_2, or_res_1, or_res_2, isPos_1, isPos_2, or_res_1_edge, or_res_2_edge, isNeg_1, isNeg_2;
    generate 
        for(i = 0; i < 4; i = i + 1) begin : iterate
            inv1$ (isPos_1[i], OP1[16*i+15]);
            orn #(7) (.in({OP1[16*i+14:16*i+8]}), .out(or_res_1[i]));
            or2$ (or_res_1_edge[i], or_res_1[i], OP1[i*16 + 7]);
            and2$ (is_under_1[i], or_res_1[i], OP1[15+16*i]); 
            and2$ (is_over_1[i],  or_res_1_edge[i], isPos_1[i]);
            mux4n #(8) (packsswb_out[8*i+7 : 8*i], OP1[16*i+7:16*i], 8'h7f, 8'h80, 8'd0, is_over_1[i], is_under_1[i]);
           
            inv1$ (isPos_2[i], OP2[16*i+15]);
            orn #(7) (.in({OP2[16*i+14:16*i+8]}), .out(or_res_2[i]));
            or2$ (or_res_2_edge[i], or_res_2[i], OP2[i*16 + 7]);
            and2$ (is_under_2[i], or_res_2[i], OP2[15+16*i]); 
            and2$ (is_over_2[i], or_res_2_edge[i], isPos_2[i]);
            mux4n #(8) (packsswb_out[8*i+7 +32 : 8*i+32], OP2[16*i+7:16*i], 8'h7f, 8'h80, 8'd0, is_over_2[i], is_under_2[i]);
            // satAdder #(8) a(packsswb_out[8*i+7:8*i],cout[i], OP1[16*i+15:16*i+8], OP1[16*i+7:16*i], 1'b0 );
            // satAdder #(8) b(packsswb_out[8*i+7+32:8*i+32],cout[i+4], OP2[16*i+15:16*i+8], OP2[16*i+7:16*i], 1'b0 );
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
    
    input [63:0] OP1, OP2
);
 genvar i;
 generate
    for(i = 0; i < 64; i = i + 1) begin : ord
        or2$ o1(or_out[i], OP1[i], OP2[i]);
    end
 endgenerate

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
or2$ o4 (daa_cf, cf, mux2 );

endmodule


/////////////////////////////////////////////////////////////////////////////

module CMPXCHNG_alu(
    output[63:0] cmpxchng_out,
    output swap,
    output cmpxchng_af,
    output cmpxchng_cf,
    output cmpxchng_of,
    output cmpxchng_zf,
    input [63:0] OP1, OP2, OP3,
    input [31:0] op1_orig,
    input cmpxchng_p_op

);
 
    wire isCMPXCHNG;
    wire op1_EQ_op3;
    equaln #(32) e1(OP1[31:0], OP3[31:0], op1_EQ_op3);
    // wire[4:0] alukProper;
       assign cmpxchng_zf = op1_EQ_op3;
    // inv_n #(2) in1(alukProper[4:3], aluk[4:3]);
    // assign alukProper[2:0] = aluk[2:0];
    
    wire[31:0] mux1_out;
    mux2n #(32) m1(mux1_out, 32'd0, op1_orig, op1_EQ_op3);
   
   and2$ andx(swap, op1_EQ_op3, cmpxchng_p_op);
   
    // mux2n #(32) m2(/*op1_dest*/, op1_orig, mux1_out, cmpxchng_p_op);   
    mux2n #(64) m3(cmpxchng_out, OP1, OP2, op1_EQ_op3);
   
    wire[31:0] not2;
    inv_n #(32) in1(not2, OP2[31:0]);
    wire[31:0] incB;
    wire[31:0] adderResult;
    kogeAdder #(32) a1(adderResult, cmpxchng_cf, OP1[31:0],not2 , 1'b1);
    kogeAdder #(32) a2(incB, COUT2, 32'd0,not2 , 1'b1);
    
    wire[3:0] adder_af;
    kogeAdder #(4) a3(adder_af, nulls, incB[7:4], OP1[7:4], 1'b0);
    equaln #(4) e2(adder_af[3:0], adderResult[7:4], af_outn);
    inv1$ i1(cmpxchng_af, af_outn);
    
    wire uf, of;
    calcSat cs1(of, uf, OP1[31], incB[31], adderResult[31]);
    or2$ o1(cmpxchng_of, of, uf);

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
    output af_out,
    output cf_out,
    output of_out,
    input[63:0] OP1, OP2,
    input[2:0] MUX_ADDER_IMM,
    input [1:0] size
);
    wire [31:0] mux_res;
    wire[31:0] adderResult;
    wire[3:0] adder_af;
    wire nulls;
    //mux8_n #(32) m1(mux_res, OP2[31:0], 32'd2, 32'd4, 0, 32'd6, 32'hFFFF_FFFE, 32'hFFFF_FFFC, 0, MUX_ADDER_IMM[0],MUX_ADDER_IMM[1], MUX_ADDER_IMM[2]);
    kogeAdder #(32) a1(adderResult, cf_out, OP1[31:0], OP2[31:0], 1'b0);
    
    kogeAdder #(4) a2(adder_af, nulls, OP2[7:4], OP1[7:4], 1'b0);
    equaln #(4) e1(adder_af[3:0], adderResult[7:4], af_outn);
    inv1$ i1(af_out, af_outn);
    
    wire uf, of;
     calcSat cs1(of2, uf2, OP1[31], OP2[31], adderResult[31]);
    calcSat cs2(of1, uf1, OP1[15], OP2[15], adderResult[15]);
    calcSat cs3(of0, uf0, OP1[7], OP2[7], adderResult[7]);
    mux4n cs_sel1 (of, of0, of1, of2, 1'b0, size[0], size[1]);
    mux4n cs_sel2 (uf, uf0, uf1, uf2, 1'b0, size[0], size[1]);
    or2$ o1(of_out, of, uf);
    
    assign ADD_ALU_OUT[63:32] = 32'd0;
    assign ADD_ALU_OUT[31:0] = adderResult[31:0];

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

module xor4$(output out, input a, input b, input c, input d);
    xor2$ x0(temp1, a, b);
    xor2$ x1(temp2, c, d);
    xor2$ x2(out, temp1, temp2);
endmodule