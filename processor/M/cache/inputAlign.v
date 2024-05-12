module inputAlign(
    input[31:0] address_in,
    input[16*8-1:0] data_in,
    input [1:0] size_in,
    input r,w,sw,
    input valid_in,
    input fromBUS, sizeOVR,
    input PTC_ID_in,

    //TLB SIGNALS
    input clk,
    input [159:0] VP, PF,
    input[7:0] entry_V, entry_P, entry_RW, entry_PCD,
    
    output TLB_miss, protection_exception, TLB_hit,PCD_out,

    //endTLB SIGNALS

    output [31:0] vAddress0,
    output[14:0] address0,
    output[16*8-1:0] data0,
    output [1:0] size0,
    output r0,w0,sw0,
    output valid0,
    output fromBUS0,
    output [16*8-1:0] mask0,

    output [31:0] vAddress1,
    output[14:0] address1,
    output[16*8-1:0] data1,
    output [1:0] size1,
    output r1,w1,sw1,
    output valid1,
    output fromBUS1, 
    output [16*8-1:0] mask1,
    
    output needP1,

    output[2:0] oneSize,
   
    output[16*8-1:0] PTC_out,

    output [3:0]wake_init_vector,
    output PTC_ID_out
);
assign PTC_ID_out = PTC_ID_in
wire[3:0] shift2;
assign address1[6:4] = vAddress1[6:4];
assign address1[3:0] = 4'd0;
assign address0[6:0] = vAddress0[6:0];
assign vAddress0 = address_in;
assign address1[11:7] = vAddress1[11:7];
assign address0[11:7] = vAddress0[11:7];
assign r1 = r; assign r0 = r;
assign w1 = w; assign w0 = w;
assign sw1 =sw; assign sw0 = sw;
assign valid0 = valid_in; assign fromBUS0 = fromBUS; assign fromBUS1 = fromBUS;
bufferH256$ b12(fromMEM, fromBUS);
inv1$ asa(PCD_not,PCD_out);
wire[3:0] shift0_enc;
and2$ asv(valid0, valid_in, PCD_not);

//Adr + x10
kogeAdder #(32) a1(vAddress1, dc, address_in, 32'h0000_0010, 1'b0);

//Calc Size1
wire[3:0] size0_n;
wire[3:0] addRes;
assign size1 = addRes[1:0];
and2$ a5(valid1, valid1_t, valid_in );
wire[3:0] sizeAdd, sizeAdd2;
mux4n #(4) mxn4(sizeAdd[3:0], 4'h1, 4'h2,4'h4, 4'h8, size_in[0], size_in[1]);
mux4n #(4) mxn5(sizeAdd2[3:0], 4'h0, 4'h1,4'h3, 4'h7, size_in[0], size_in[1]);
assign baseSize = sizeAdd;
//assign oneSize = sizeAdd[2:0];//shift2[2:0];

kogeAdder #(4) a4(addRes, valid1_t, address_in[3:0], sizeAdd, 1'b0);
mux2n #(2) mx1(size0, size_in, 2'b11, sizeOVR);
assign needP1 = valid1;

inv1$ in11(size0_n[1], sizeAdd2[1]);
inv1$ in21(size0_n[0], sizeAdd2[0]);
inv1$ in41(size0_n[2], sizeAdd2[2]);
inv1$ in31(size0_n[3], sizeAdd2[3]);
kogeAdder #(4) ad22({idk,oneSize}, dc2, address0[3:0], {1'b0,size0_n[2:0]}, 1'b1);
//generate shift
wire[3:0] size1_n;
inv1$ in1(size1_n[1], addRes[1]);
inv1$ in2(size1_n[0], addRes[0]);
inv1$ in4(size1_n[2], addRes[2]);
inv1$ in3(size1_n[3], addRes[3]);
kogeAdder #(4) ad2(shift2[3:0], dc1, sizeAdd, size1_n, 1'b1);
wire[19:0] tlb0, tlb1;
//TLB Handler
TLB t1(clk, vAddress0, w,valid0, VP, PF,entry_V, entry_P, entry_RW, entry_PCD, tlb0, PCD_out0, miss0, hit0, prot_except0 );
TLB t2(clk, vAddress1, w,valid1, VP, PF, entry_V, entry_P, entry_RW, entry_PCD, tlb1, PCD_out1, miss1, hit1,  prot_except1);
or2$ a0(TLB_miss, miss0, miss1);
or2$ a2(protection_exception,prot_except1 , prot_except0);
and2$ a3(TLB_hit, hit0, hit1);
and2$ a6(PCD_out, PCD_out0, PCD_out1);

//Address gneration
assign address1[14:12] = tlb1[2:0];
assign address0[14:12] = tlb0[2:0];

//Mask generation
mux8_n #(64) m4(mask1[63:0],64'd0, 64'h00FF, 64'h0FFFF, 64'h0FF_FFFF, 64'h0_FFFF_FFFF,64'h00FF_FFFF_FFFF,64'hFFFF_FFFF_FFFF,64'h00FF_FFFF_FFFF_FFFF, addRes[0], addRes[1], addRes[2]);
assign mask1[16*8-1:64] = 0;
wire[16*8-1:0] maskSelect, maskSelect2, maskGen;
wire[15:0] adrDec;
wire[15:0] adrDecBuf;
decodern #(4) d1(addRes,adrDec);
genvar i;
assign maskSelect[16*8-1:64] = 0;



mux4n #(64) mnx(maskSelect[63:0], 64'h00FF, 64'h0FFFF, 64'h0FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF, size1[0], size1[1]);
assign mask1[16*8-1:64] = 0;

generate
    for(i = 0; i < 16; i = i + 1) begin : bufx
        bufferH16$ b(adrDecBuf[i], adrDec[i]);
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin : rotate
        lShf16  lshx({maskSelect[120+i],maskSelect[112+i], maskSelect[104+i], maskSelect[96+i], maskSelect[88+i], maskSelect[80+i], maskSelect[72+i], maskSelect[64+i], maskSelect[56+i], maskSelect[48+i], maskSelect[40+i], maskSelect[32+i], maskSelect[24+i], maskSelect[16+i], maskSelect[8+i], maskSelect[i]},shift0_enc,{maskGen[120+i],maskGen[112+i], maskGen[104+i], maskGen[96+i], maskGen[88+i], maskGen[80+i], maskGen[72+i], maskGen[64+i], maskGen[56+i], maskGen[48+i], maskGen[40+i], maskGen[32+i], maskGen[24+i], maskGen[16+i], maskGen[8+i], maskGen[i]} );
    end
endgenerate

generate
    for(i = 0; i < 16*8; i = i + 1) begin : genMask
        mux2$ mx(mask0[i], maskGen[i], 1'b1, fromMEM);
    end
endgenerate

//DATA SHIFT for Data0

mux2n #(4) mx21(shift0_enc, address0[3:0], 4'b0, fromMEM);

wire[15:0] shift0_dec;
decodern #(4) d2(shift0_enc,shift0_dec);
wire[15:0] shift0_buf;
generate
    for(i = 0; i < 16; i = i + 1) begin : bufxx
        bufferH16$ b(shift0_buf[i], shift0_dec[i]);
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin : rotate1
        lShf16  lshcxx({data_in[120+i],data_in[112+i], data_in[104+i], data_in[96+i], data_in[88+i], data_in[80+i], data_in[72+i], data_in[64+i], data_in[56+i], data_in[48+i], data_in[40+i], data_in[32+i], data_in[24+i], data_in[16+i], data_in[8+i], data_in[i]},shift0_enc,{data0[120+i],data0[112+i], data0[104+i], data0[96+i], data0[88+i], data0[80+i], data0[72+i], data0[64+i], data0[56+i], data0[48+i], data0[40+i], data0[32+i], data0[24+i], data0[16+i], data0[8+i], data0[i]} );
    end
endgenerate

//dataShift for data1
wire[3:0] shift1_enc;
mux2n #(4) mx212(shift1_enc, address0[3:0], 4'b0, fromMEM);
wire[16*8-1:0] data1_t;
wire[15:0] shift1_dec;
decodern #(4) d22(shift1_enc,shift1_dec);
wire[15:0] shift1_buf;
// generate
//     for(i = 0; i < 16; i = i + 1) begin : bufxxx
//         bufferH16$ b2(shift1_buf[i], shift1_dec[i]);
//     end
// endgenerate

// generate
//     for(i = 0; i < 8; i = i + 1) begin : rotate1x
//         rShf16 lshcxxx({data_in[120+i],data_in[112+i], data_in[104+i], data_in[96+i], data_in[88+i], data_in[80+i], data_in[72+i], data_in[64+i], data_in[56+i], data_in[48+i], data_in[40+i], data_in[32+i], data_in[24+i], data_in[16+i], data_in[8+i], data_in[i]},shift1_enc,{data1_t[112+i],data1_t[112+i], data1_t[104+i], data1_t[96+i], data1_t[88+i], data1_t[80+i], data1_t[72+i], data1_t[64+i], data1_t[56+i], data1_t[48+i], data1_t[40+i], data1_t[32+i], data1_t[24+i], data1_t[16+i], data1_t[8+i], data1_t[i]} );
//     end
// endgenerate

wire[7:0] size_dec;
decodern #(3)  dcx(shift2,size_dec);
muxnm_tristate #(8, 16*8) mxt({
{56'd0,data_in[16*8-1:56]},
{48'd0,data_in[16*8-1:48]},
{40'd0,data_in[16*8-1:40]},
{32'd0,data_in[16*8-1:32]},
{24'd0,data_in[16*8-1:24]},
{16'd0,data_in[16*8-1:16]}, 
 {8'd0,data_in[16*8-1:8]}, 
 data1_t}, 
 size_dec,data1  );



endmodule

module lShf16(
    input[15:0] a,
    input[3:0] shi,
    output[15:0] out
);
    wire[15:0] row1, row2, row3; 
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : row1x
            if(i > 0) begin
                mux2$ m1(row1[i], a[i], a[i-1],shi[0]);
            end
            else begin
                mux2$ m2(row1[i], a[i], 1'b0,shi[0]);
            end
        end 
    endgenerate

    generate
        for(i = 0; i < 16; i = i + 1) begin : row2x
            if(i > 1) begin
                mux2$ m3(row2[i], row1[i], row1[i-2],shi[1]);
            end
            else begin
                mux2$ m4(row2[i], row1[i], 1'b0,shi[1]);
            end
        end 
    endgenerate
    generate
        for(i = 0; i < 16; i = i + 1) begin : row3x
            if(i > 3) begin
                mux2$ m5(row3[i], row2[i], row2[i-4],shi[2]);
            end
            else begin
                mux2$ m6(row3[i], row2[i], 1'b0,shi[2]);
            end
        end 
    endgenerate
    generate
        for(i = 0; i < 16; i = i + 1) begin : row4
            if(i > 7) begin
                mux2$ m7(out[i], row3[i], row3[i-8],shi[3]);
            end
            else begin
                mux2$ m8(out[i], row3[i], 1'b0,shi[3]);
            end
        end 
    endgenerate
endmodule

module rShf16(
    input[15:0] a,
    input[3:0] shi,
    output[15:0] out
);
    wire[15:0] row1, row2, row3; 
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : row5
            if(i < 15) begin
                mux2$ m9(row1[i], a[i], a[i+1],shi[0]);
            end
            else begin
                mux2$ m10(row1[i], a[i], 1'b0,shi[0]);
            end
        end 
    endgenerate

    generate
        for(i = 0; i < 16; i = i + 1) begin : row6
            if(i < 14) begin
                mux2$ m11(row2[i], row1[i], row1[i+2],shi[1]);
            end
            else begin
                mux2$ m12(row2[i], row1[i], 1'b0,shi[1]);
            end
        end 
    endgenerate
    generate
        for(i = 0; i < 16; i = i + 1) begin : row7
            if(i <12) begin
                mux2$ m13(row3[i], row2[i], row2[i+4],shi[2]);
            end
            else begin
                mux2$ m14(row3[i], row2[i], 1'b0,shi[2]);
            end
        end 
    endgenerate
    generate
        for(i = 0; i < 16; i = i + 1) begin : row8
            if(i < 8) begin
                mux2$ m15(out[i], row3[i], row3[i+8],shi[3]);
            end
            else begin
                mux2$ m16(out[i], row3[i], 1'b0,shi[3]);
            end
        end 
    endgenerate




    wire[255:0] PTC0_shift;
wire[255:0] PTC_out1;
//Generate PTCout
wire[16*16-1:0] PTC0, PTC1;
generate
    for(i = 0; i < 16; i = i + 1) begin : zero
        assign PTC0[i*16+3:i*16] = i;
        
        assign PTC0[i*16+14:i*16+4] = pAddress0[14:4];
        
        assign PTC1[i*16+3:i*16] = i;
        assign PTC1[i*16+14:i*16+4] = pAddress1[14:4];
    end
endgenerate 

generate
    for(i = 0; i < 15; i = i + 1) begin : zerox
rShf16 rshfx(
    {
        PTC0[240+i], PTC0[224+i], PTC0[208+i],
        PTC0[192+i], PTC0[176+i], PTC0[160+i], PTC0[144+i],
        PTC0[128+i], PTC0[112+i], PTC0[96+i], PTC0[80+i],
        PTC0[64+i], PTC0[48+i], PTC0[32+i], PTC0[16+i],
        PTC0[i]
    },
    pAddress0[3:0],
    {
        PTC0_shift[240+i], PTC0_shift[224+i], PTC0_shift[208+i],
        PTC0_shift[192+i], PTC0_shift[176+i], PTC0_shift[160+i], PTC0_shift[144+i],
        PTC0_shift[128+i], PTC0_shift[112+i], PTC0_shift[96+i], PTC0_shift[80+i],
        PTC0_shift[64+i], PTC0_shift[48+i], PTC0_shift[32+i], PTC0_shift[16+i],
        PTC0_shift[i]
    }
);
    end
endgenerate



    wire[127:0] preVAL;
    wire [127:0]PTCDATA;
    mux8_n #(128) breakup2(
        PTCDATA, 
        PTC0_shift[127:0], 
        {PTC0[15:0], PTC0_shift[111:0]}, 
        {PTC0[31:0], PTC0_shift[95:0]},
        {PTC0[47:0], PTC0_shift[79:0]},
        {PTC0[63:0], PTC0_shift[63:0]},
        {PTC0[79:0], PTC0_shift[47:0]},
        {PTC0[95:0], PTC0_shift[31:0]},
        {PTC0[111:0],PTC0_shift[15:0]}, 
        pAddress0[0], pAddress0[1], pAddress0[2]
    );

    wire[127:0] PTC_outx;
    mux2n #(128) chosePath(PTC_outx, PTC0_shift[127:0], PTCDATA[127:0] , E_needP1 );

    mux4n #(128) mxptc(PTC_out, {112'd0, PTC_outx[15:0]}, {96'd0, PTC_outx[31:0]}, {64'd0,PTC_outx[63:0]}, PTC_outx, size_in[0], size_in[1] );
   
   mux8n #(4) wake(wake_init_vector,4'1110, 4'b1010, 4'b1011, 4'b1010, 4'b1101, 4'b0101, 4'b0111, 4'b0101   ,needP1, pAddress0[4], sw);
   
   /*4 bits
   0: ER
   1: ESW
   2: OR
   3  OSW

   */
endmodule