module cache_tb();

reg clk;
reg set, rst;
localparam CYCLE_TIME = 12.0;

//inputAlign
reg[31:0] address_in;
reg[16*8-1:0] data_in;//done;
reg[1:0] size_in; //done
reg r, w, sw;
reg valid_in;
reg fromBUS, sizeOVR;//done
    reg [7:0] entry_V, entry_P,  entry_RW, entry_PCD;//DONE
reg [19:0] VP_0, VP_1, VP_2, VP_3, VP_4, VP_5, VP_6, VP_7;
reg [19:0] PF_0, PF_1, PF_2, PF_3, PF_4, PF_5, PF_6, PF_7;
reg [159:0] VP, PF; 
//cachebank
reg MSHR_HIT, MSHR_FULL, SER_FULL; //DONE
reg[2:0] cache_id; //DONE
reg [6:0] PTC_ID_IN;
reg AQ_EMPTY;

initial begin
    rst = 0;
    set = 1;
    valid_in = 0;
    clk = 0;
    PTC_ID_IN = 0;
    AQ_EMPTY = 0;
    VP_0 = 20'h00000;
    VP_1 = 20'h02000;
    VP_2 = 20'h04000;
    VP_3 = 20'h0b000;
    VP_4 = 20'h0c000;
    VP_5 = 20'h0a000;
    VP_6 = 20'h06000;
    VP_7 = 20'h03000;

    PF_0 = 20'h00000;
    PF_1 = 20'h00002;
    PF_2 = 20'h00005;
    PF_3 = 20'h00004;
    PF_4 = 20'h00007;
    PF_5 = 20'h00005;
    PF_6 = 20'h00006;
    PF_7 = 20'h00003;
    MSHR_HIT = 0; MSHR_FULL = 0; SER_FULL = 0;
    sizeOVR = 0; fromBUS = 0;
    entry_V = 8'b10111111;
    entry_P = 8'b11110111;
    entry_RW= 8'b11010101;
    entry_PCD = 8'b00000011;
    size_in = 2'b10;
    data_in = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
    r = 0; w = 0; sw = 0;
    address_in = 32'h0400_000F;
    VP = {VP_7, VP_6, VP_5, VP_4, VP_3, VP_2, VP_1, VP_0};
    PF = {PF_7, PF_6, PF_5, PF_4, PF_3, PF_2, PF_1, PF_0};

    #CYCLE_TIME
    rst = 1;
    #CYCLE_TIME
    #CYCLE_TIME
    #CYCLE_TIME

    r = 1;
    sw = 1;
    valid_in = 1;
    #CYCLE_TIME
    r = 0; sw = 0; w = 1;fromBUS = 1;
    address_in = 32'h0400_0000;
    #CYCLE_TIME
    address_in = 32'h0400_0010;
    data_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
    #CYCLE_TIME
    address_in = 32'h0400_000F;
    r = 1; sw = 0; w = 0; fromBUS = 0;
    data_in = 128'd0;
    #CYCLE_TIME
    valid_in = 0;
    #CYCLE_TIME
       #CYCLE_TIME
    #CYCLE_TIME
    $finish;
end








//Input align outputs
wire TLB_miss, protection_exception, TLB_hit;
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
wire needP1;
wire[2:0] oneSize;
wire PCD_out;

//Input swap outputs
wire  oddIsGreaters;
wire  needP1s;
wire [2:0] oneSize_outs;
wire  [31:0] vAddressE;
wire [14:0] addressE;
wire [16*8-1:0] dataE;
wire  [1:0] sizeE;
wire  rE,wE,swE;
wire  validE;
wire  fromBUSE;
wire  [16*8-1:0] maskE;
wire  [31:0] vAddressO;
wire [14:0] addressO;
wire [16*8-1:0] dataO;
wire  [1:0] sizeO;
wire  rO,wO,swO;
wire  validO;
wire  fromBUSOs;
wire  [16*8-1:0] maskO;

wire  oddIsGreaters_t;
wire  needP1s_t;
wire [2:0] oneSize_outs_t;
wire  [31:0] vAddressE_t;
wire [14:0] addressE_t;
wire [16*8-1:0] dataE_t;
wire  [1:0] sizeE_t;
wire  rE,wE,swE_t;
wire  validE_t;
wire  fromBUSE_t;
wire  [16*8-1:0] maskE_t;
wire  [31:0] vAddressO_t;
wire [14:0] addressO_t;
wire [16*8-1:0] dataO_t;
wire  [1:0] sizeO_t;
wire  rO,wO,swO_t;
wire  validO_t;
wire  fromBUSOs_t;
wire  [16*8-1:0] maskO_t;
   

//cachebank outputs
wire AQ_READE;
wire MSHR_validE;
wire [14:0] MSHR_pAddressE;
wire SER_valid0E;
wire[16*8-1:0] SER_data0E;
wire[14:0] SER_pAddress0E;
wire[2:0] SER_return0E;
wire[15:0] SER_size0E;
wire SER_rw0E;
wire [2:0] SER_dest0E;
wire SER_valid1E;
wire[14:0] SER_pAddress1E;
wire[2:0] SER_return1E;
wire[15:0] SER_size1E;
wire SER_rw1E;
wire SER_dest1E;
wire EX_validE;
wire [16*8-1:0] EX_dataE;
wire [31:0] EX_vAddressE;
wire [14:0] EX_pAddressE;
wire [1:0] EX_sizeE;
wire EX_wakeE;
wire oddIsGreaterE;
wire cache_stallE;
wire cache_missE;
wire needP1_alignE;
wire [2:0]oneSize_outE;

//ODD
wire AQ_READO;
wire MSHR_validO;
wire [14:0] MSHR_pAddressO;
wire SER_valid0O;
wire[16*8-1:0] SER_data0O;
wire[14:0] SER_pAddress0O;
wire[2:0] SER_return0O;
wire[15:0] SER_size0O;
wire SER_rw0O;
wire [2:0] SER_dest0O;
wire SER_valid1O;
wire[14:0] SER_pAddress1O;
wire[2:0] SER_return1O;
wire[15:0] SER_size1O;
wire SER_rw1O;
wire SER_dest1O;
wire EX_validO;
wire [16*8-1:0] EX_dataO;
wire [31:0] EX_vAddressO;
wire [14:0] EX_pAddressO;
wire [1:0] EX_sizeO;
wire EX_wakeO;
wire oddIsGreaterO;
wire cache_stallO;
wire cache_missO;
wire needP1_alignO;
wire [2:0]oneSize_outO;

//outputAlign outputs
wire [16 * 8 -1 : 0] PTC_out;
wire [63:0] data_out;
wire valid_out;
wire wake1, wake0;

inputAlign iA(
    .address_in(address_in), 
    .data_in(data_in),
    .size_in(size_in),
    .r(r), 
    .w(w),
    .sw(sw),
    .valid_in(valid_in),
    .fromBUS(fromBUS),
    .sizeOVR(sizeOVR),
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
    .PCD_out(PCD_outss),
    
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
    .address1(address1), 
    .data1(data1), 
    .size1(size1), 
    .r1(r1), 
    .w1(w1), 
    .sw1(sw1), 
    .valid1(valid1),
    .fromBUS1(fromBUS1), 
    .mask1(mask1), 
    .needP1(needP1), 
    .oneSize(oneSize));

adrSwap adrSwap_instance (
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
    .PCD_in(PCD_outss),
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

    .oddIsGreater(oddIsGreater_t),
    .needP1(needP1s_t),
    .oneSize_out(oneSize_outs_t),
    .vAddressE(vAddressE_t),
    .addressE(addressE_t),
    .dataE(dataE_t),
    .sizeE(sizeE_t),
    .rE(rE_t),
    .wE(wE_t),
    .swE(swE_t),
    .validE(validE_t),
    .fromBUSE(fromBUSE_t),
    .maskE(maskE_t),
    .vAddressO(vAddressO_t),
    .addressO(addressO_t),
    .dataO(dataO_t),
    .sizeO(sizeO_t),
    .rO(rO_t),
    .wO(wO_t),
    .swO(swO_t),
    .validO(validO_t),
    .fromBUSO(fromBUSOs_t),
    .maskO(maskO_t),
    .PCD_out(PCD_in_t)
);

regn #(626) rrr(
    {
    oddIsGreater_t, needP1s_t, oneSize_outs_t,
    vAddressE_t, addressE_t, dataE_t, sizeE_t, rE_t, wE_t, swE_t, validE_t, fromBUSE_t, maskE_t,
    vAddressO_t, addressO_t, dataO_t, sizeO_t, rO_t, wO_t, swO_t, validO_t, fromBUSOs_t, maskO_t, PCD_in_t
},
1'b1, rst, clk,
{
    oddIsGreater, needP1s, oneSize_outs,
    vAddressE, addressE, dataE, sizeE, rE, wE, swE, validE, fromBUSE, maskE,
    vAddressO, addressO, dataO, sizeO, rO, wO, swO, validO, fromBUSOs, maskO, PCD_in
}

);

cacheBank cacheBank_E (
    .clk(clk),
    .rst(rst),
    .set(set),
    .cache_id(3'b011),
    .vAddress(vAddressE),
    .pAddress(addressE),
    .data(dataE),
    .size(sizeE),
    .r(rE),
    .w(wE),
    .sw(swE),
    .valid_in(validE),
    .fromBUS(fromBUSE),
    .mask(maskE),
    
    .AQ_isEMPTY(AQ_EMPTY),
    .PTC_ID_IN(PTC_ID_IN),

    .oddIsGreater_in(oddIsGreater),
    
    .needP1_in(needP1s),
    .oneSize(oneSize_outs),
    .MSHR_HIT(MSHR_HIT),
    .MSHR_FULL(MSHR_FULL),
    .SER0_FULL(SER_FULL),
    .SER1_FULL(SER_FULL),

    .PCD_IN(PCD_in),

    .AQ_READ(AQ_READE),
    .MSHR_valid(MSHR_validE),
    .MSHR_pAddress(MSHR_pAddressE),
    .SER_valid0(SER_valid0E),
    .SER_data0(SER_data0E),
    .SER_pAddress0(SER_pAddress0E),
    .SER_return0(SER_return0E),
    .SER_size0(SER_size0E),
    .SER_rw0(SER_rw0E),
    .SER_dest0(SER_dest0E),
    .SER_valid1(SER_valid1E),
    .SER_pAddress1(SER_pAddress1E),
    .SER_return1(SER_return1E),
    .SER_size1(SER_size1E),
    .SER_rw1(SER_rw1E),
    .SER_dest1(SER_dest1E),
    .EX_valid(EX_validE),
    .EX_data(EX_dataE),
    .EX_vAddress(EX_vAddressE),
    .EX_pAddress(EX_pAddressE),
    .EX_size(EX_sizeE),
    .EX_wake(EX_wakeE),
    .oddIsGreater(oddIsGreaterE),
    .cache_stall(cache_stallE),
    .cache_miss(cache_missE),
    .needP1(needP1E),
    .oneSize_out(oneSize_outE)
);

cacheBank cacheBank_O (
    .clk(clk),
    .rst(rst),
    .set(set),
    .cache_id(3'b011),
    .vAddress(vAddressO),
    .pAddress(addressO),
    .data(dataO),
    .size(sizeO),
      .r(rO),
      .w(wO),
    .sw(swO),
    .valid_in(validO),
    .fromBUS(fromBUSOs),
    .mask(maskO),
    
    .AQ_isEMPTY(AQ_EMPTY),
    .PTC_ID_IN(PTC_ID_IN),

    .oddIsGreater_in(oddIsGreater),
    .PCD_IN(PCD_in),
    .needP1_in(needP1s),
    .oneSize(oneSize_outs),
    .MSHR_HIT(MSHR_HIT),
    .MSHR_FULL(MSHR_FULL),
    .SER1_FULL(SER_FULL),
    .SER0_FULL(SER_FULL),
    
    .AQ_READ(AQ_READO),
    .MSHR_valid(MSHR_validO),
    .MSHR_pAddress(MSHR_pAddressO),
    .SER_valid0(SER_valid0O),
    .SER_data0(SER_data0O),
    .SER_pAddress0(SER_pAddress0O),
    .SER_return0(SER_return0O),
    .SER_size0(SER_size0O),
    .SER_rw0(SER_rw0O),
    .SER_dest0(SER_dest0O),
    .SER_valid1(SER_valid1O),
    .SER_pAddress1(SER_pAddress1O),
    .SER_return1(SER_return1O),
    .SER_size1(SER_size1O),
    .SER_rw1(SER_rw1O),
    .SER_dest1(SER_dest1O),
    .EX_valid(EX_validO),
    .EX_data(EX_dataO),
    .EX_vAddress(EX_vAddressO),
    .EX_pAddress(EX_pAddressO),
    .EX_size(EX_sizeO),
    .EX_wake(EX_wakeO),
    .oddIsGreater(EX_oddIsGreaterO),
    .cache_stall(cache_stallO),
    .cache_miss(cache_missO),
    .needP1(needP1O),
    .oneSize_out(oneSize_outO)
);
outputAlign outputAlign_instance (
    .E_valid(EX_validE),
     .E_data(EX_dataE),
    .E_vAddress(EX_vAddressE),
    .E_pAddress(EX_pAddressE),
    .E_size(EX_sizeE),
    .E_wake(EX_wakeE),
    .E_cache_stall(cache_stallE),
    .E_cache_miss(cache_missE),
    .E_oddIsGreater(oddIsGreaterE),
    .E_needP1(needP1E),
    .oneSize(oneSize_outO),
    .O_valid(EX_validO),
    .O_data(EX_dataO),
    .O_vAddress(EX_vAddressO),
    .O_pAddress(EX_pAddressO),
    .O_size(EX_sizeO),
    .O_wake(EX_wakeO),
    .O_cache_stall(cache_stallO),
    .O_cache_miss(cache_missO),
    .O_oddIsGreater(EX_oddIsGreaterO),
    .O_needP1(needP1O),
    .PTC_out(PTC_out),
    .data_out(data_out),
    .valid_out(valid_out),
    .wake1(wake1),
    .wake0(wake0)
);




initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
 $vcdplusfile("cache.vpd");
 $vcdpluson(0, cache_tb); 
end




endmodule