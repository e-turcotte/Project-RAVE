module inputAlign(
    input[31:0] address_in,
    input[16*8-1:0] data_in,
    input [1:0] size_in,
    input r,w,sw,
    input valid_in,
    input fromBUS, sizeOVR,

    //TLB SIGNALS
    input clk,
    input [159:0] VP, PF,
    input[7:0] entry_V, entry_P, entry_RW,
    
    output TLB_miss, protection_exception, TLB_hit,

    //endTLB SIGNALS

    output [31:0] vAddress0,
    output[31:0] address0,
    output[16*8-1:0] data0,
    output [1:0] size0,
    output r0,w0,sw0,
    output valid0,
    output fromBUS0,
    output [16*8-1:0] mask0,

    output [31:0] vAddress1,
    output[31:0] address1,
    output[16*8-1:0] data1,
    output [1:0] size1,
    output r1,w1,sw1,
    output valid1,
    output fromBUS1, 
    output [16*8-1:0] mask1
);
wire[19:0] tlb1, tl02;
assign address1[6:4] = vAddress1[6:4];
assign address1[3:0] = 4'd0;
assign address0[6:0] = vAddress0[6:0];
assign vAddress0 = address0;
assign r1 = r; assign r0 = r;
assign w1 = w; assign w0 = w;
assign sw1 =sw; assign sw0 = sw;
assign valid0 = valid_in; assign fromBUS0 = fromBUS; assign fromBUS1 = fromBUS;
bufferH256$ b12(fromMEM, fromBUS);

//Adr + x10
kogeAdder #(32) a1(vAddress1, dc, address_in, 32'h0000_0010, 1'b0);

//Calc Size1
wire[3:0] addRes;
assign size1 = addRes[1:0];
and2$ a5(valid1, valid1_t, valid_in );
kogeAdder #(4) a4(addRes, valid1_t, address_in[3:0], {2'b0, size_in}, 1'b0);
mux2n #(2) mx1(size0, size_in, 2'b11, sizeOVR);

//generate shift
wire[1:0] shift2,size1_n;
inv1$ in1(size1_n[1], size1[1]);
inv1$ in2(size1_n[0], size1[0]);
adder2Bit ad2(shift2, dc1, size0, size1, 1'b1);

//TLB Handler
TLB t1(clk, vAddress0, w, VP, PF,entry_V, entry_P, entry_RW, tlb0, miss0, hit0, prot_except0 );
TLB t2(clk, vAddress1, w, VP, PF, entry_V, entry_P, entry_RW, tlb1, miss1, hit1,  prot_except1);
and2$ a0(TLB_miss, miss0, miss1);
and2$ a2(hit, , miss1);
and2$ a3(TLB_hit, TLB_hit0, TLB_hit1);

//Address gneration
assign address1[15:7] = tlb1[7:0];
assign address0[15:7] = tlb0[7:0];

//Mask generation
mux4n #(64) m4(mask1[63:0], 64'h00FF, 64'h0FFFF, 64'h0FF_FFFF, 64'h0_FFFF_FFFF, size1[0], size1[1]);
assign mask1[16*8-1:64] = 0;
wire[16*8-1:0] maskSelect, maskGen;
wire[15:0] adrDec;
wire[15:0] adrDecBuf;
decordern #(4) d1(size1,adrDec);
genvar i;
assign maskSelect[16*8-1:64] = 0;
mux4n #(64) (maskSelect[63:0], 64'h00FF, 64'h0FFFF, 64'h0FF_FFFF, 64'h0_FFFF_FFFF, size1[0], size1[1]);
assign mask1[16*8-1:64] = 0;

generate
    for(i = 0; i < 16; i = i + 1) begin : bufx
        bufferH16$ b(adrDecBuf[i], adrDec[i]);
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin : rotate
        lshfn_variable #(16) lshx({maskSelect[112+i], maskSelect[104+i], maskSelect[96+i], maskSelect[88+i], maskSelect[80+i], maskSelect[72+i], maskSelect[64+i], maskSelect[56+i], maskSelect[48+i], maskSelect[40+i], maskSelect[32+i], maskSelect[24+i], maskSelect[16+i], maskSelect[8+i], maskSelect[i]},adrDecBuf,1'b0,maskGen );
    end
endgenerate

generate
    for(i = 0; i < 16*8; i = i + 1) begin : genMask
        mux2n #(16*8) mx(mask0[i], maskSelect[i], 1'b1, fromMEM);
    end
endgenerate

//DATA SHIFT for Data0
wire[3:0] shift0_enc;
mux2n #(4) mx21(shift0_enc, address0[3:0], 4'b0, fromMEM);

wire[15:0] shift0_dec;
decordern #(4) d2(shift0_dec,shift0_enc);
wire[15:0] shift0_buf;
generate
    for(i = 0; i < 16; i = i + 1) begin : bufxx
        bufferH16$ b(shift0_buf[i], shift0_dec[i]);
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin : rotate1
        lshfn_variable #(16) lshcxx({data_in[112+i], data_in[104+i], data_in[96+i], data_in[88+i], data_in[80+i], data_in[72+i], data_in[64+i], data_in[56+i], data_in[48+i], data_in[40+i], data_in[32+i], data_in[24+i], data_in[16+i], data_in[8+i], data_in[i]},shift0_buf,1'b0,data0 );
    end
endgenerate

//dataShift for data1
wire[3:0] shift1_enc;
mux2n #(4) mx212(shift1_enc, address0[3:0], 4'b0, fromMEM);
wire[16*8-1:0] data1_t;
wire[15:0] shift1_dec;
decordern #(4) d22(shift1_dec,shift1_enc);
wire[15:0] shift1_buf;
generate
    for(i = 0; i < 16; i = i + 1) begin : bufxxx
        bufferH16$ b2(shift1_buf[i], shift1_dec[i]);
    end
endgenerate

generate
    for(i = 0; i < 8; i = i + 1) begin : rotate1x
        rshfn_variable #(16) lshcxxx({data_in[112+i], data_in[104+i], data_in[96+i], data_in[88+i], data_in[80+i], data_in[72+i], data_in[64+i], data_in[56+i], data_in[48+i], data_in[40+i], data_in[32+i], data_in[24+i], data_in[16+i], data_in[8+i], data_in[i]},shift1_buf,1'b0,data1_t );
    end
endgenerate

wire[3:0] size_dec;
decodern #(2)  (size_dec,shift2);
muxnm_tristate #(4, 16*8) mxt({{3'b000,data1_t[16*8-1:3]}, {2'b00,data1_t[16*8-1:2]}, {1'b0,data1_t[16*8-1:1]}, data1_t}, size_dec,data1  );


endmodule

module adder2Bit(
    output [1:0] out,
    output cout,
    input [1:0] a,b,
    input cin
);
fulladder0(a[0], b[0]. cin, out[0], cout1);    
fulladder1(a[1], b[1], cout1, out[1], cout);
    
endmodule