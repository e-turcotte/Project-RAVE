module adrSwap(
    input [31:0] vAddress0,
    input[14:0] address0,
    input[16*8-1:0] data0,
    input [1:0] size0,
    input r0,w0,sw0,
    input valid0,
    input fromBUS0,
    input [16*8-1:0] mask0,

    input PCD_in,

    input [31:0] vAddress1,
    input[14:0] address1,
    input[16*8-1:0] data1,
    input [1:0] size1,
    input r1,w1,sw1,
    input valid1,
    input fromBUS1, 
    input [16*8-1:0] mask1,

    input needP1_in,
    input [2:0]oneSize,

    output oddIsGreater,
    output needP1,
    output[2:0] oneSize_out,

    output [31:0] vAddressE,
    output[14:0] addressE,
    output[16*8-1:0] dataE,
    output [1:0] sizeE,
    output rE,wE,swE,
    output validE,
    output fromBUSE,
    output [16*8-1:0] maskE,

    output [31:0] vAddressO,
    output[14:0] addressO,
    output[16*8-1:0] dataO,
    output [1:0] sizeO,
    output rO,wO,swO,
    output validO,
    output fromBUSO, 
    output [16*8-1:0] maskO,

    output PCD_out
);
assign PCD_out = PCD_in;
wire even, odd, vaddress4_inv;
inv1$ INVS(.in(vAddress0[4]), .out(vaddress4_inv));

andn #(2) ya(.in( {vAddress0[4], valid0 }), .out(odd));
andn #(2) aa(.in( {vaddress4_inv, valid0 }), .out(even));

assign needP1 = needP1_in;
wire [326:0]CA;
nor2$ orsz(oth, valid0, valid1);
muxnm_tristate #(3, 310) mxE({vAddress0,address0,data0,size0,  r0,w0,sw0,valid0, fromBUS0,mask0,vAddress1,address1,data1,size1,  r1,w1,sw1,valid1, fromBUS1,mask1, 310'd0},{even, odd, oth},{vAddressE,addressE,dataE,sizeE,  rE,wE,swE,validE, fromBUSE,maskE});
muxnm_tristate #(3, 310) mxO({vAddress0,address0,data0,size0,  r0,w0,sw0,valid0, fromBUS0,mask0,vAddress1,address1,data1,size1,  r1,w1,sw1,valid1, fromBUS1,mask1, 310'd0},{odd, even, oth},{vAddressO,addressO,dataO,sizeO,  rO,wO,swO,validO, fromBUSO,maskO});


assign oddIsGreater = vAddress0[4];
assign oneSize_out = oneSize;
endmodule