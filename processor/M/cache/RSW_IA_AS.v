module IA_AS(
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

    output [16*8-1:0] PTC_out,
    output  [3:0]wake_init_vector,
    output  [6:0]PTC_ID_out,

    output TLB_miss,
    output protection_exception,
    output TLB_hit,
    
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
    

    wire [31:0] vAddress0;
    wire[14:0] address0;
    wire[16*8-1:0] data0;
    wire [1:0] size0;
    wire r0,w0,sw0;
    wire valid0;
    wire fromBUS0;
    wire [16*8-1:0] mask0;

    wire [31:0] vAddress1;
    wire[14:0] address1;
    wire[16*8-1:0] data1;
    wire [1:0] size1;
    wire r1,w1,sw1;
    wire valid1;
    wire fromBUS1;
    wire [16*8-1:0] mask1;


    wire[2:0] oneSize;
   
    

inputAlign IA(
    .address_in(address_in),
    .data_in(data_in),
    .size_in(size_in),
    .r(r),
    .w(w),
    .sw(sw),
    .valid_in(valid_in),
    .fromBUS(fromBUS), 
    .sizeOVR(sizeOVR),
    .PTC_ID_in(PTC_ID_in),

    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .TLB_miss(TLB_miss),
    .protection_exception(protection_exception),
    .TLB_hit(TLB_hit),

    .PCD_out(PCD_out),
    .vAddress0(vAddress0),
    .address0(address0),
    .data0(data0),
    .size0(size0),
    .r0(r0),
    .w0(w0),
    .sw0(sw0),
    .valid0(valid0),
    .fromBUS0(fromBUS0),
    .mask0(mask0),
    .vAddress1(vAddress1),
    .address1(address0),
    .data1(data1),
    .size1(size1),
    .r1(r1),
    .w1(w1),
    .sw1(sw1),
    .valid1(valid1),
    .fromBUS1(fromBUS1),
    .mask1 (mask1),
    .needP1(needP1),
    .oneSize(oneSize),
    .PTC_out(PTC_out),
    .wake_init_vector(wake_init_vector),
    .PTC_ID_out(PTC_ID_out)
);

adrSwap AS(
    .vAddress0(vAddress0),
    .address0(address0),
    .data0(data0),
    .size0(size0),
    .r0(r0),
    .w0(w0),
    .sw0(sw0),
    .valid0(valid0),
    .fromBUS0(fromBUS0),
    .mask0(mask0),
    .PCD_in(PCD_out),
    .vAddress1(vAddress1),
    .address1(address1),
    .data1(data1),
    .size1(size1),
    .r1(r1),
    .w1(w1),
    .sw1(sw1),
    .valid1(valid1),
    .fromBUS1(fromBUS1),
    .mask1(mask1),
    .needP1_in(needP1),
    .oneSize(oneSize),
    .oddIsGreater(oddIsGreater),
    .needP1(needP1_dc),
    .oneSize_out(oneSize_out),
    .vAddressE(vAddressE),
    .addressE(addressE),
    .dataE(dataE),
    .sizeE(sizeE),
    .rE(rE),
    .wE(wE),
    .swE(swE),
    .validE(validE),
    .fromBUSE(fromBUSE),
    .maskE(maskE),
    .vAddressO(vAddressO),
    .addressO(addressO),
    .dataO(dataO),
    .sizeO(sizeO),
    .rO(rO),
    .wO(wO),
    .swO(swO),
    .validO(validO),
    .fromBUSO(fromBUSO),
    .maskO(maskO),
    .PCD_out(PCD_out1)
);









endmodule 