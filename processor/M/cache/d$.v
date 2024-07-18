module d$(
    //GLOBAL
    input clk,
    input clk_bus,
    input rst,
    input set,
    input ptc_clear,

    //SERDES for W AQ
    inout [72:0] BUS,
    
    //BAU-DES
    input [1:0] setReciever_d,
    output [1:0]free_bau_d,

    //BAU-SER
    input [3:0] grant_d,
    input [3:0] ack_d,
    output [3:0]releases_d,
    output [3:0] req_d,
    output [15:0] dest_d,

    //R SW AQ
    input[63:0] data_m1, data_m2,
    input[31:0] M1, M2,
    input[1:0] M1_RW, M2_RW,
    input[1:0] opsize,
    input valid_RSW,
    input fwd_stall,
    input sizeOVR,
    input [6:0]PTC_ID_in,
    input [7:0] qentry_slot_in,
    output r_is_m1,
    output sw_is_m1,

    //Exceptions:
    output TLB_miss_wb,
    output TLB_pe_wb,
    output TLB_hit_wb,
    output TLB_miss_r,
    output TLB_pe_r,
    output TLB_hit_r,
    output TLB_miss_sw,
    output TLB_pe_sw,
    output TLB_hit_sw,

    //W AQ
    input[16*8-1:0] data_in_wb,
    input[31:0] address_in_wb,
    input[1:0] size_in_wb,
    input valid_in_wb,
    input [6:0] PTC_ID_in_wb,
    input [31:0] latched_eip_mem_$,
    input [6:0]  latched_ptcid_mem_$,

    //TLB handler
    input [159:0] VP, PF,
    input[7:0] entry_V, entry_P, entry_RW, entry_PCD,
    output TLB_miss, protection_exception, TLB_hit,PCD_out,

    //DESIRED pre D$
    output [127:0]ptc_info_r,
    output [127:0]ptc_info_sw,
    output [3:0]wake_init_vector_r,
    output [3:0]wake_init_vector_sw,

    //AQ outputs
    output aq_isempty, rdaq_isfull, swaq_isfull, wbaq_isfull,
    
    //Post D$ outputs
    output [3:0]wake,
    output [6:0]PTC_ID_out,
    output cache_valid,
    output [127:0] data,
    output stall, 
    output [127:0] ptcinfo_out,
    output [7:0] qentry_slot_out, //TODO:


    //MSHR outputs
    output [7:0] rd_qentry_slots_out_e, sw_qentry_slots_out_e,
    output mshr_hit_e, mshr_full_e,
    output [7:0] rd_qentry_slots_out_o, sw_qentry_slots_out_o,
    output mshr_hit_o, mshr_full_o,

    output [127:0] cacheline_e_bus_in_data, cacheline_o_bus_in_data,
    output [255:0] cacheline_e_bus_in_ptcinfo, cacheline_o_bus_in_ptcinfo,

    //MSHR_io outputs
    output [7:0] rd_qentry_slots_out_e_io, sw_qentry_slots_out_e_io,
    output mshr_hit_e_io, mshr_full_e_io,
    output [7:0] rd_qentry_slots_out_o_io, sw_qentry_slots_out_o_io,
    output mshr_hit_o_io, mshr_full_o_io
    ); 

  
    or3$ tlbm(TLB_miss, TLB_miss_r, TLB_miss_sw, TLB_miss_wb);
    or3$ tlbpe(TLB_protection_exception, TLB_protection_exception_r, TLB_protection_exception_sw, TLB_protection_exception_wb);
    or3$ tlbh(TLB_hit, TLB_hit_r, TLB_hit_sw, TLB_hit_wb);
    wire freeDO, freeDE;
    wire grantDEr, grantDEw, grantDOr, grantDOw;
    wire ackDEr, ackDEw, ackDOr, ackDOw;
    wire relDEr, relDEw, relDOr, relDOw;
    wire reqDEr, reqDEw, reqDOr, reqDOw;
    // assign setReciever_d = {recvDO, recvDE}    ;

wire [3:0] returnLoc_o,returnLoc_e;
   wire [31:0] address_in_r;
   wire [127:0] data_in_r;
   wire [1:0]size_in_r;
   wire r_r;
   wire w_r;
   wire sw_r;
   wire valid_in_r;
   wire sizeOVR_r;
   wire [6:0] PTC_ID_in_r;
   wire [6:0]PTC_ID_out_r;
   wire oddIsGreater_r;
   wire needP1_r;
   wire [2:0] oneSize_out_r;
   wire [31:0]vAddressE_r;
   wire [14:0]addressE_r;
   wire [127:0]dataE_r;
   wire [1:0]sizeE_r;
   wire rE_r;
   wire wE_r;
   wire swE_r;
   wire validE_r;
   wire fromBUSE_r;
   wire [127:0]maskE_r;
   wire [31:0]vAddressO_r;
   wire [14:0]addressO_r;
   wire [127:0] dataO_r;
   wire [1:0] sizeO_r;
   wire rO_r;
   wire wO_r;
   wire swO_r;
   wire validO_r;
   wire fromBUSO_r;
   wire [127:0]maskO_r;
   wire PCD_out_r;

   wire [31:0] address_in_sw;
   wire [127:0] data_in_sw;
   wire [1:0]size_in_sw;
   wire r_sw;
   wire w_sw;
   wire sw_sw;
   wire valid_in_sw;
   wire sizeOVR_sw;
   wire [6:0] PTC_ID_in_sw;
   wire [6:0]PTC_ID_out_sw;
   wire oddIsGreater_sw;
   wire needP1_sw;
   wire [2:0] oneSize_out_sw;
   wire [31:0]vAddressE_sw;
   wire [14:0]addressE_sw;
   wire [127:0]dataE_sw;
   wire [1:0]sizeE_sw;
   wire rE_sw;
   wire wE_sw;
   wire swE_sw;
   wire validE_sw;
   wire fromBUSE_sw;
   wire [127:0]maskE_sw;
   wire [31:0]vAddressO_sw;
   wire [14:0]addressO_sw;
   wire [127:0] dataO_sw;
   wire [1:0] sizeO_sw;
   wire rO_sw;
   wire wO_sw;
   wire swO_sw;
   wire validO_sw;
   wire fromBUSO_sw;
   wire [127:0]maskO_sw;
   wire PCD_out_sw;



   wire r_wb;
   wire w_wb;
   wire sw_wb;

   wire sizeOVR_wb;
 
   wire [6:0]PTC_ID_out_wb;
   wire oddIsGreater_wb;
   wire needP1_wb;
   wire [2:0] oneSize_out_wb;
   wire [31:0]vAddressE_wb;
   wire [14:0]addressE_wb;
   wire [127:0]dataE_wb;
   wire [1:0]sizeE_wb;
   wire rE_wb;
   wire wE_wb;
   wire swE_wb;
   wire validE_wb;
   wire fromBUSE_wb;
   wire [127:0]maskE_wb;
   wire [31:0]vAddressO_wb;
   wire [14:0]addressO_wb;
   wire [127:0] dataO_wb;
   wire [1:0] sizeO_wb;
   wire rO_wb;
   wire wO_wb;
   wire swO_wb;
   wire validO_wb;
   wire fromBUSO_wb;
   wire [127:0]maskO_wb;
   wire PCD_out_wb;

    wire [14:0] pAddress_e_$, pAddress_o_$;
    wire [16*8-1:0] data_e_$, data_o_$;
    wire [1:0] size_e_$, size_o_$;
    wire r_$, w_$, sw_$;
    wire valid_e_$, valid_o_$;
    wire fromBUS_$;
    wire [16*8-1:0] mask_e_$, mask_o_$;
    wire [6:0] ptcid_$;
    wire odd_is_greater_$, needP1_$;
    wire [2:0] onesize_$;
    wire pcd_$;
    wire [7:0] qslot_$; //TODO:

    wire MSHR_HIT_e;
    wire MSHR_FULL_e;
    wire SER1_FULL_e;
    wire SER0_FULL_e;
    wire read_e;
    


    wire [3:0] wake_init_vector_wb;
    wire SER_valid0_e;
    wire [127:0] SER_data0_e;
    wire [14:0]SER_pAddress0_e;
    wire [3:0]SER_return0_e;
    wire [15:0]SER_size0_e;
    wire SER_rw0_e;
    wire [3:0]SER_dest0_e;
    wire SER_valid1_e;
    wire [14:0]SER_pAddress1_e;
    wire [3:0]SER_return1_e;
    wire [15:0]SER_size1_e;
    wire SER_rw1_e;
    wire [3:0]SER_dest1_e;
    wire EX_valid_e;
    wire [127:0]EX_data_e;
    wire [31:0]EX_vAddress_e;
    wire [14:0]EX_pAddress_e;
    wire [1:0]EX_size_e;
    wire [1:0]EX_wake_e;
    wire oddIsGreater_e;
    wire cache_stall_e;
    wire cache_miss_e;
    wire needP1_out_e;
    wire [2:0]oneSize_out_e;
    wire [6:0]PTC_ID_out_e;
    wire [127:0] PTC_out_wb;
    wire MSHR_HIT_o;
    wire MSHR_FULL_o;
    wire SER1_FULL_o;
    wire SER0_FULL_o;
    wire read_o;
    
    wire MSHR_alloc_e;
    wire MSHR_dealloc_e;
    wire MSHR_rdsw_e;
    wire [14:0] MSHR_pAddress_e;
    wire [6:0] MSHR_ptcid_e;
    wire [7:0] MSHR_qslot_e; //TODO:
    wire MSHR_alloc_o;
    wire MSHR_dealloc_o;
    wire MSHR_rdsw_o;
    wire [14:0] MSHR_pAddress_o;
    wire [6:0] MSHR_ptcid_o;
    wire [7:0] MSHR_qslot_o; //TODO:
    
    wire MSHR_alloc_e_io;
    wire MSHR_dealloc_e_io;
    wire MSHR_rdsw_e_io;
    wire [14:0] MSHR_pAddress_e_io;
    wire [6:0] MSHR_ptcid_e_io;
    wire [7:0] MSHR_qslot_e_io; //TODO:
    wire MSHR_alloc_o_io;
    wire MSHR_dealloc_o_io;
    wire MSHR_rdsw_o_io;
    wire [14:0] MSHR_pAddress_o_io;
    wire [6:0] MSHR_ptcid_o_io;
    wire [7:0] MSHR_qslot_o_io; //TODO:

    wire SER_valid0_o;
    wire [127:0] SER_data0_o;
    wire [14:0]SER_pAddress0_o;
    wire [3:0]SER_return0_o;
    wire [15:0]SER_size0_o;
    wire SER_rw0_o;
    wire [3:0]SER_dest0_o;
    wire SER_valid1_o;
    wire [14:0]SER_pAddress1_o;
    wire [3:0]SER_return1_o;
    wire [15:0]SER_size1_o;
    wire SER_rw1_o;
    wire [3:0]SER_dest1_o;
    wire EX_valid_o;
    wire [127:0]EX_data_o;
    wire [31:0]EX_vAddress_o;
    wire [14:0]EX_pAddress_o;
    wire [1:0]EX_size_o;
    wire [1:0]EX_wake_o;
    wire oddIsGreater_o;
    wire cache_stall_o;
    wire cache_miss_o;
    wire needP1_out_o;
    wire [2:0]oneSize_out_o;
    wire [6:0]PTC_ID_out_o;

    wire bus_valid_e;
    wire bus_valid_e_nobuf;
    wire [14:0] bus_pAddress_e;
    wire [127:0] bus_data_e;

    wire recvDE, recvDO;
    wire[63:0] data_out;

    wire bus_valid_o;
    wire bus_valid_o_nobuf;
    wire [14:0] bus_pAddress_o;
    wire [127:0] bus_data_o;

  

SW_R_SWP u_SW_R_SWP (
        .M1(M1),
        .M2(M2),
        .M1_RW(M1_RW),
        .M2_RW(M2_RW),
        .valid_rsw(valid_RSW),
        .sizeOvr(sizeOVR),
        .PTC_ID_in(PTC_ID_in),
        .size_in(opsize),
        .address_in_r(address_in_r),
        .size_in_r(size_in_r),
        .valid_in_r(valid_in_r),
        .sizeOVR_r(sizeOVR_r),
        .PTC_ID_in_r(PTC_ID_in_r),
        .address_in_sw(address_in_sw),
        .size_in_sw(size_in_sw),
        .valid_in_sw(valid_in_sw),
        .sizeOVR_sw(sizeOVR_sw),
        .PTC_ID_in_sw(PTC_ID_in_sw),
        .sw_is_m1(sw_is_m1),
        .r_is_m1(r_is_m1)
    );

IA_AS rdIA (
    .address_in(address_in_r),
    .data_in(128'd0),
    .size_in(size_in_r),
    .r(valid_in_r),
    .w(1'b0),
    .sw(1'b0),
    .valid_in(valid_in_r),
    .fromBUS(1'b0),
    .sizeOVR(sizeOVR_r),
    .PTC_ID_in(PTC_ID_in_r),

    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .TLB_miss(TLB_miss_r),
    .protection_exception(TLB_pe_r),
    .TLB_hit(TLB_hit_r),

    .PTC_out(ptc_info_r),
    .wake_init_vector(wake_init_vector_r),
    .PTC_ID_out(PTC_ID_out_r),
    .oddIsGreater(oddIsGreater_r),
    .needP1(needP1_r),
    .oneSize_out(oneSize_out_r),
    .vAddressE(vAddressE_r),
    .addressE(addressE_r),
    .dataE(dataE_r),
    .sizeE(sizeE_r),
    .rE(rE_r),
    .wE(wE_r),
    .swE(swE_r),
    .validE(validE_r),
    .fromBUSE(fromBUSE_r),
    .maskE(maskE_r),
    .vAddressO(vAddressO_r),
    .addressO(addressO_r),
    .dataO(dataO_r),
    .sizeO(sizeO_r),
    .rO(rO_r),
    .wO(wO_r),
    .swO(swO_r),
    .validO(validO_r),
    .fromBUSO(fromBUSO_r),
    .maskO(maskO_r),
    .PCD_out(PCD_out_r)
);

IA_AS swIA (
    .address_in(address_in_sw),
    .data_in(128'd0),
    .size_in(size_in_sw),
    .r(1'b0),
    .w(1'b0),
    .sw(valid_in_sw),
    .valid_in(valid_in_sw),
    .fromBUS(1'b0),
    .sizeOVR(sizeOVR_sw),
    .PTC_ID_in(PTC_ID_in_sw),

    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .TLB_miss(TLB_miss_sw),
    .protection_exception(TLB_pe_sw),
    .TLB_hit(TLB_hit_sw),
    
    .PTC_out(ptc_info_sw),
    .wake_init_vector(wake_init_vector_sw),
    .PTC_ID_out(PTC_ID_out_sw),
    .oddIsGreater(oddIsGreater_sw),
    .needP1(needP1_sw),
    .oneSize_out(oneSize_out_sw),
    .vAddressE(vAddressE_sw),
    .addressE(addressE_sw),
    .dataE(dataE_sw),
    .sizeE(sizeE_sw),
    .rE(rE_sw),
    .wE(wE_sw),
    .swE(swE_sw),
    .validE(validE_sw),
    .fromBUSE(fromBUSE_sw),
    .maskE(maskE_sw),
    .vAddressO(vAddressO_sw),
    .addressO(addressO_sw),
    .dataO(dataO_sw),
    .sizeO(sizeO_sw),
    .rO(rO_sw),
    .wO(wO_sw),
    .swO(swO_sw),
    .validO(validO_sw),
    .fromBUSO(fromBUSO_sw),
    .maskO(maskO_sw),
    .PCD_out(PCD_out_sw)
);

IA_AS wbIA (
    .address_in(address_in_wb),
    .data_in(data_in_wb),
    .size_in(size_in_wb),
    .r(1'b0),
    .w(1'b1),
    .sw(1'b0),
    .valid_in(valid_in_wb),
    .fromBUS(1'b0),
    .sizeOVR(1'b0/*sizeOVR_wb*/),
    .PTC_ID_in(PTC_ID_in_wb),
    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .TLB_miss(TLB_miss_wb),
    .protection_exception(TLB_pe_wb),
    .TLB_hit(TLB_hit_wb),

    .PTC_out(PTC_out_wb),
    .wake_init_vector(wake_init_vector_wb),
    .PTC_ID_out(PTC_ID_out_wb),
    .oddIsGreater(oddIsGreater_wb),
    .needP1(needP1_wb),
    .oneSize_out(oneSize_out_wb),
    .vAddressE(vAddressE_wb),
    .addressE(addressE_wb),
    .dataE(dataE_wb),
    .sizeE(sizeE_wb),
    .rE(rE_wb),
    .wE(wE_wb),
    .swE(swE_wb),
    .validE(validE_wb),
    .fromBUSE(fromBUSE_wb),
    .maskE(maskE_wb),
    .vAddressO(vAddressO_wb),
    .addressO(addressO_wb),
    .dataO(dataO_wb),
    .sizeO(sizeO_wb),
    .rO(rO_wb),
    .wO(wO_wb),
    .swO(swO_wb),
    .validO(validO_wb),
    .fromBUSO(fromBUSO_wb),
    .maskO(maskO_wb),
    .PCD_out(PCD_out_wb)
);
dff$ desDEss(clk,aq_isempty, AQ_PREV, dcxxx , rst,set);
inv1$ asxs(aq_isempty_n, aq_isempty);
and2$ rd(readx, read_e, read_o);
or2$ chc(read, readx, AQ_check);
inv1$ inss(AQ_PREV_n, AQ_PREV);
and2$ asasf(AQ_check, AQ_PREV, aq_isempty_n);

nor2$ protdisR(cancel_r, TLB_miss_r,1'b0);
nor2$ protdisSW(cancel_sw, TLB_miss_sw,1'b0);
nor2$ protdisWB(cancel_wb, TLB_miss_wb,1'b0);

and2$ cwbe1(valE_r, cancel_r,validE_r);
and2$ cwbe2(valO_r, cancel_r,validO_r);
and2$ cwbe3(valE_sw, cancel_sw,validE_sw);
and2$ cwbe4(valO_sw, cancel_sw,validO_sw);
and2$ cwbe5(valE_wb, cancel_wb,validE_wb);
and2$ cwbe6(valO_wb, cancel_wb,validO_wb);

cacheaqsys cacheaqsys_inst (
    .rd_pAddress_e (addressE_r),
    .rd_pAddress_o (addressO_r),
    .sw_pAddress_e (addressE_sw),
    .sw_pAddress_o (addressO_sw),
    .wb_pAddress_e (addressE_wb),
    .wb_pAddress_o (addressO_wb),


    .bus_pAddress_e(bus_pAddress_e),
    .bus_pAddress_o(bus_pAddress_o),
    .wb_data_e(dataE_wb),
    .wb_data_o(dataO_wb),
    .bus_data_e(bus_data_e),
    .bus_data_o(bus_data_o),
    
    .rd_size_e(sizeE_r ),
    .rd_size_o(sizeO_r),
    .sw_size_e(sizeE_sw),
    .sw_size_o(sizeO_sw),
    .wb_size_e(sizeE_wb),
    .wb_size_o(sizeO_wb),
    .rd_valid_e(valE_r),
    .rd_valid_o(valO_r),
    .sw_valid_e(valE_sw),
    .sw_valid_o(valO_sw),
    .wb_valid_e(valE_wb),
    .wb_valid_o(valO_wb),

    .bus_valid_e(bus_valid_e),
    .bus_valid_o(bus_valid_o),

//TODO: WOAH
    .wb_mask_e(maskE_wb),
    .wb_mask_o(maskO_wb),


    .rd_ptcid(PTC_ID_out_r),
    .sw_ptcid(PTC_ID_out_sw),
    .wb_ptcid(PTC_ID_out_wb),
    .rd_odd_is_greater(oddIsGreater_r),
    .sw_odd_is_greater(oddIsGreater_sw),
    .wb_odd_is_greater(oddIsGreater_wb),
    .rd_needP1(needP1_r),
    .sw_needP1(needP1_sw),
    .wb_needP1(needP1_wb),

    .rd_onesize(oneSize_out_r),
    .sw_onesize(oneSize_out_sw),
    .wb_onesize(oneSize_out_wb),

    .rd_pcd(PCD_out_r),
    .sw_pcd(PCD_out_sw),
    .wb_pcd(PCD_out_wb),

    .rd_ptcinfo(ptc_info_r),
    .sw_ptcinfo(ptc_info_sw),

    .rd_qslot(qentry_slot_in),
    .sw_qslot(qentry_slot_in),

    .bus_pcd(bus_pcd),
    .bus_isempty(bus_isempty),


    .read(stall_n & aq_isempty_n),
    .rd_write(valid_in_r & !aq_stall ),
    .sw_write(valid_in_sw & !aq_stall),
    .wb_write(valid_in_wb),

    .clk(clk),
    .clr(rst), .ptc_clr(ptc_clear),
    
    .pAddress_e(pAddress_e_$),
    .pAddress_o(pAddress_o_$),
    .data_e(data_e_$),
    .data_o(data_o_$),
    .size_e(size_e_$),
    .size_o(size_o_$),
    .r(r_$),
    .w(w_$),
    .sw(sw_$),
    .valid_e(valid_e_$),
    .valid_o(valid_o_$),
    .fromBUS(fromBUS_$),
    .mask_e(mask_e_$),
    .mask_o(mask_o_$),
    .ptcid(ptcid_$),
    .odd_is_greater(odd_is_greater_$),
    .onesize(onesize_$),
    .pcd(pcd_$),
    .needP1(needP1_in),

    .aq_isempty(aq_isempty),
    .rdaq_isfull(rdaq_isfull),
    .swaq_isfull(swaq_isfull),
    .wbaq_isfull(wbaq_isfull),
    .ptcinfo(ptcinfo_out),
    .qslot(qslot_$)
);

cacheBank bankE (
    .clk(clk),
    .rst(rst),
    .set(set),
    .ptc_clear(ptc_clear),
    .cache_id(4'b0100),
    .vAddress(),
    .pAddress(pAddress_e_$),
    .data(data_e_$),
    .size(size_e_$),
    .r(r_$),
    .w(w_$),
    .sw(sw_$),
    .valid_in(valid_e_$),
    .fromBUS(fromBUS_$),
    .mask(mask_e_$),
    .AQ_isEMPTY(aq_isempty),
    .PTC_ID_IN(ptcid_$),
    .oddIsGreater_in(odd_is_greater_$),
    .needP1_in(needP1_in),
    .oneSize(onesize_$),

    .MSHR_HIT(mshr_hit_e),
    .MSHR_FULL(mshr_full_e),
    .SER1_FULL(SER1_FULL_e),
    .SER0_FULL(SER0_FULL_e),

    .PCD_IN(pcd_$),

    .AQ_READ(read_e),
    .MSHR_alloc(MSHR_alloc_e ),
    .MSHR_dealloc(MSHR_dealloc_e),
    .MSHR_rdsw(MSHR_rdsw_e),
    .MSHR_pAddress(MSHR_pAddress_e),
    .MSHR_ptcid(MSHR_ptcid_e),

    .MSHR_alloc_io(MSHR_alloc_e_io),
    .MSHR_dealloc_io(MSHR_dealloc_e_io),
    .MSHR_rdsw_io(MSHR_rdsw_e_io),
    .MSHR_pAddress_io(MSHR_pAddress_e_io),
    .MSHR_ptcid_io(MSHR_ptcid_e_io),

    .SER_valid0(SER_valid0_e),
    .SER_data0(SER_data0_e),
    .SER_pAddress0(SER_pAddress0_e),
    .SER_return0(SER_return0_e),
    .SER_size0(SER_size0_e),
    .SER_rw0(SER_rw0_e),
    .SER_dest0(SER_dest0_e),

    .SER_valid1(SER_valid1_e),
    .SER_pAddress1(SER_pAddress1_e),
    .SER_return1(SER_return1_e),
    .SER_size1(SER_size1_e),
    .SER_rw1(SER_rw1_e),
    .SER_dest1(SER_dest1_e),

    .EX_valid(EX_valid_e),
    .EX_data(EX_data_e),
    .EX_vAddress(EX_vAddress_e),
    .EX_pAddress(EX_pAddress_e),
    .EX_size(EX_size_e),
    .EX_wake(EX_wake_e),
    .oddIsGreater(oddIsGreater_e),
    .cache_stall(cache_stall_e),
    .cache_miss(cache_miss_e),
    .needP1(needP1_out_e),
    .oneSize_out(oneSize_out_e),
    .PTC_ID_out(PTC_ID_out_e)
);

cacheBank bankO (
    .clk(clk),
    .rst(rst),
    .set(set),
    .ptc_clear(ptc_clear),
    .cache_id(4'b0101),
    .vAddress(),
    .pAddress(pAddress_o_$),
    .data(data_o_$),
    .size(size_o_$),
    .r(r_$),
    .w(w_$),
    .sw(sw_$),
    .valid_in(valid_o_$),
    .fromBUS(fromBUS_$),
    .mask(mask_o_$),
    .AQ_isEMPTY(aq_isempty),
    .PTC_ID_IN(ptcid_$),
    .oddIsGreater_in(odd_is_greater_$),
    .needP1_in(needP1_in),
    .oneSize(onesize_$),

    .MSHR_HIT(mshr_hit_o),
    .MSHR_FULL(mshr_full_o),
    .SER1_FULL(SER1_FULL_o),
    .SER0_FULL(SER0_FULL_o),

    .PCD_IN(pcd_$),

    .AQ_READ(read_o),

    .MSHR_alloc(MSHR_alloc_o ),
    .MSHR_dealloc(MSHR_dealloc_o),
    .MSHR_rdsw(MSHR_rdsw_o),
    .MSHR_pAddress(MSHR_pAddress_o),
    .MSHR_ptcid(MSHR_ptcid_o),

    .MSHR_alloc_io(MSHR_alloc_o_io),
    .MSHR_dealloc_io(MSHR_dealloc_o_io),
    .MSHR_rdsw_io(MSHR_rdsw_o_io),
    .MSHR_pAddress_io(MSHR_pAddress_o_io),
    .MSHR_ptcid_io(MSHR_ptcid_o_io),

    .SER_valid0(SER_valid0_o),
    .SER_data0(SER_data0_o),
    .SER_pAddress0(SER_pAddress0_o),
    .SER_return0(SER_return0_o),
    .SER_size0(SER_size0_o),
    .SER_rw0(SER_rw0_o),
    .SER_dest0(SER_dest0_o),

    .SER_valid1(SER_valid1_o),
    .SER_pAddress1(SER_pAddress1_o),
    .SER_return1(SER_return1_o),
    .SER_size1(SER_size1_o),
    .SER_rw1(SER_rw1_o),
    .SER_dest1(SER_dest1_o),

    .EX_valid(EX_valid_o),
    .EX_data(EX_data_o),
    .EX_vAddress(EX_vAddress_o),
    .EX_pAddress(EX_pAddress_o),
    .EX_size(EX_size_o),
    .EX_wake(EX_wake_o),
    .oddIsGreater(oddIsGreater_o),
    .cache_stall(cache_stall_o),
    .cache_miss(cache_miss_o),
    .needP1(needP1_out_o),
    .oneSize_out(oneSize_out_o),
    .PTC_ID_out(PTC_ID_out_o)
);

outputAlign oA (
    .E_valid(EX_valid_e),
    .E_data(EX_data_e),
    .E_vAddress(EX_vAddress_e),
    .E_pAddress(EX_pAddress_e),
    .E_size(EX_size_e),
    .E_wake(EX_wake_e),
    .E_cache_stall(cache_stall_e),
    .E_cache_miss(cache_miss_e),
    .E_oddIsGreater(oddIsGreater_e),
    .E_needP1(needP1_out_e),
    .oneSize(onesize_$),
    .O_valid(EX_valid_o),
    .O_data(EX_data_o),
    .O_vAddress(EX_vAddress_o),
    .O_pAddress(EX_pAddress_o),
    .O_size(EX_size_o),
    .O_wake(EX_wake_o),
    .O_cache_stall(cache_stall_o),
    .O_cache_miss(cache_miss_o),
    .O_oddIsGreater(oddIsGreater_o),
    .O_needP1(needP1_out_o),
    .data_out(data_out),
    .valid_out(valid_out),
    .wake(wake)
);

mshr mshrE ( 
    .pAddress(MSHR_pAddress_e),
    .ptcid_in(MSHR_ptcid_e),
    .qentry_slot_in(qslot_$), //TODO:
    .rdsw_in(MSHR_rdsw_e),
    .alloc(MSHR_alloc_e),
    .dealloc(MSHR_dealloc_e & bus_valid_e_nobuf),
    .clk(clk),
    .clr(rst),
    .rd_qentry_slots_out(rd_qentry_slots_out_e),
    .sw_qentry_slots_out(sw_qentry_slots_out_e),
    .mshr_hit(mshr_hit_e),
    .mshr_full(mshr_full_e)
);

mshr mshrO ( 
    .pAddress(MSHR_pAddress_o),
    .ptcid_in(MSHR_ptcid_o),
    .qentry_slot_in(qslot_$), //TODO:
    .rdsw_in(MSHR_rdsw_o),
    .alloc(MSHR_alloc_o),
    .dealloc(MSHR_dealloc_o & bus_valid_o_nobuf),
    .clk(clk),
    .clr(rst),
    .rd_qentry_slots_out(rd_qentry_slots_out_o),
    .sw_qentry_slots_out(sw_qentry_slots_out_o),
    .mshr_hit(mshr_hit_o),
    .mshr_full(mshr_full_o)
);

mshrio mshrE_io ( 
    .pAddress(MSHR_pAddress_e_io),
    .ptcid_in(MSHR_ptcid_e_io),
    .qentry_slot_in(qslot_$), //TODO:
    .rdsw_in(MSHR_rdsw_e_io),
    .alloc(MSHR_alloc_e_io),
    .dealloc(MSHR_dealloc_e_io & bus_valid_e_nobuf),
    .clk(clk),
    .clr(rst),
    .rd_qentry_slots_out(rd_qentry_slots_out_e_io),
    .sw_qentry_slots_out(sw_qentry_slots_out_e_io),
    .mshr_hit(mshr_hit_e_io),
    .mshr_full(mshr_full_e_io)
);

mshrio mshrO_io ( 
    .pAddress(MSHR_pAddress_o_io),
    .ptcid_in(MSHR_ptcid_o_io),
    .qentry_slot_in(qslot_$), //TODO:
    .rdsw_in(MSHR_rdsw_o_io),
    .alloc(MSHR_alloc_o_io),
    .dealloc(MSHR_dealloc_o_io & bus_valid_o_nobuf),
    .clk(clk),
    .clr(rst),
    .rd_qentry_slots_out(rd_qentry_slots_out_o_io),
    .sw_qentry_slots_out(sw_qentry_slots_out_o_io),
    .mshr_hit(mshr_hit_o_io),
    .mshr_full(mshr_full_o_io)
);

assign qentry_slot_out = qslot_$;


SER DS_E_R(
    .clk_core(),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(SER_valid1_e),
    .pAdr_in(SER_pAddress1_e),
    .data_in(),
    .dest_in(SER_dest1_e),
    .return_in(4'b0100),
    .rw_in(SER_rw1_e),
    .size_in(SER_size1_e),
    .full_block(SER1_FULL_e),
    .free_block(),
    .grant(grantDEr),
    .ack(ackDEr),
    .releases(relDEr),
    .req(reqDEr),
    .BUS(BUS),
    .dest_bau(dest_d[3:0])
);  

SER DS_E_W(
    .clk_core(),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(SER_valid0_e),
    .pAdr_in(SER_pAddress0_e),
    .data_in(SER_data0_e),
    .dest_in(SER_dest0_e),
    .return_in(4'b0110),
    .rw_in(SER_rw0_e),
    .size_in(16'h8000),
    .full_block(SER0_FULL_e),
    .free_block(),
    .grant(grantDEw),
    .ack(ackDEw),
    .releases(relDEw),
    .req(reqDEw),
    .BUS(BUS),
    .dest_bau(dest_d[7:4])
); 
inv1$ invDESe(desE_empty, bus_valid_e);
inv1$ invDESo(desE_empty, bus_valid_o);
nor2$ busempty(bus_isempty,bus_valid_e,bus_valid_o  );
wire[7:0] pcd_select_e, pcd_select_o;
genvar q;
for(q = 0; q < 8; q = q + 1) begin: bus_pcds
    equaln #(3) ahf(bus_pAddress_e[14:12], PF[q*20+2: q*20], pcd_select_e[q]);
    equaln #(3) abf(bus_pAddress_o[14:12], PF[q*20+2: q*20], pcd_select_o[q]);
end
muxnm_tristate #(8, 1) adgf(entry_PCD, pcd_select_e, ePCD);
muxnm_tristate #(8, 1) adgasdasf(entry_PCD, pcd_select_o, oPCD);
orn #(8) asg(pcd_select_e, e_pcd_bus);
orn #(8) gaf(pcd_select_o, o_pcd_bus);

// equaln #(4) e12(returnLoc_e, 4'b1100, ePCD);
// equaln #(4) e13(returnLoc_o, 4'b1100, oPCD);
nand2$ opcdvale(valPCDe, ePCD, bus_valid_e);
nand2$ opcdvalo(valPCDo, oPCD, bus_valid_o);
nand2$ buspcd(bus_pcd, valPCDe, valPCDo);

dff$ desDE(clk,bus_valid_e_nobuf, bus_valid_ex, dcxx , rst,set);
dff$ desDO(clk,bus_valid_o_nobuf, bus_valid_ox, dcxxo , rst,set);
and2$ asssd(bus_valid_e, bus_valid_e_nobuf,bus_valid_ex);
and2$ asssde(bus_valid_o, bus_valid_o_nobuf,bus_valid_ox);

DES DD_E(
    .read(bus_valid_e),
    .clk_bus(clk_bus),
    .clk_core(),
    .rst(rst),
    .set(set),
    .full(bus_valid_e_nobuf),
    .pAdr(bus_pAddress_e),
    .data(bus_data_e),
    .return(returnLoc_e),
    .dest(),
    .rw(),
    .size(),
    .BUS(BUS),
    .setReciever(recvDE),
    .free_bau(freeDE)
); 
  
SER DS_O_W(
    .clk_core(clk),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(SER_valid0_o),
    .pAdr_in(SER_pAddress0_o),
    .data_in(SER_data0_o),
    .dest_in(SER_dest0_o),
    .return_in(4'b0111),
    .rw_in(SER_rw0_o),
    .size_in(16'h8000),
    .full_block(SER0_FULL_o),
    .free_block(),
    .grant(grantDOw),
    .ack(ackDOw),
    .releases(relDOw),
    .req(reqDOw),
    .BUS(BUS),
    .dest_bau(dest_d[15:12])
);  

SER DS_O_r(
    .clk_core(clk),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(SER_valid1_o),
    .pAdr_in(SER_pAddress1_o),
    .data_in(),
    .dest_in(SER_dest1_o),
    .return_in(4'b0101),
    .rw_in(SER_rw1_o),
    .size_in(SER_size1_o),
    .full_block(SER1_FULL_o),
    .free_block(),
    .grant(grantDOr),
    .ack(ackDOr),
    .releases(relDOr),
    .req(reqDOr),
    .BUS(BUS),
    .dest_bau(dest_d[11:8])
);  



DES DD_O(
    .read(bus_valid_o ),
    .clk_bus(clk_bus),
    .clk_core(clk),
    .rst(rst),
    .set(set),
    .full(bus_valid_o_nobuf),
    .pAdr(bus_pAddress_o),
    .data(bus_data_o),
    .return(returnLoc_o),
    .dest(),
    .rw(),
    .size(),
    .BUS(BUS),
    .setReciever(recvDO),
    .free_bau(freeDO)
);

assign cacheline_e_bus_in_data = bus_data_e;
assign cacheline_o_bus_in_data = bus_data_o;
genvar i;
generate
     for(i = 0; i < 16; i = i + 1) begin : cacheline_bus_in
        wire [3:0] cachelineoffs;
        assign cachelineoffs = i;
        muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(16)) busemux(.in({1'b1,bus_pAddress_e[14:4],cachelineoffs,16'h0000}), .sel(bus_valid_e_nobuf & bus_valid_e), .out(cacheline_e_bus_in_ptcinfo[(i+1)*16-1:i*16]));
        muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(16)) busomux(.in({1'b1,bus_pAddress_o[14:4],cachelineoffs,16'h0000}), .sel(bus_valid_o_nobuf & bus_valid_o), .out(cacheline_o_bus_in_ptcinfo[(i+1)*16-1:i*16]));
     end
endgenerate

    assign free_bau_d =    {freeDO, freeDE};
    assign recvDO = setReciever_d[1];
    assign recvDE = setReciever_d[0];

    //assign grant_d = {grantDEr, grantDEw, grantDOr, grantDOw};
    assign grantDEr = grant_d[3];
    assign grantDEw = grant_d[2];
    assign grantDOr = grant_d[1];
    assign grantDOw = grant_d[0];

    assign ackDEr = ack_d[3];
    assign ackDEw = ack_d[2];
    assign ackDOr = ack_d[1];
    assign ackDOw = ack_d[0];



    //assign ack_d = {ackDEr, ackDEw, ackDOr, ackDOw};
    assign releases_d = {relDEr, relDEw, relDOr, relDOw};
    assign req_d = {reqDEr, reqDEw, reqDOr, reqDOw};




    assign aq_stall = (rdaq_isfull & valid_in_r) | (swaq_isfull & valid_in_sw)  | fwd_stall;
    or2$ sta(stall, /*cache_stall_e, cache_stall_o*/ 1'b0, (rdaq_isfull & valid_in_r) | (swaq_isfull & valid_in_sw) | fwd_stall);
    nor2$ nstal(stall_n,  cache_stall_e, cache_stall_o);
    assign PTC_ID_out = PTC_ID_out_e;
    assign data = data_out;
    and2$ norss(cache_valid,valid_out, !w_$);
 
// intitial begin
//   file = $fopen("d_cache.out", "w");
//         if (file == 0) begin
//             $display("Error: Could not open file.");
//             $finish;
//         end
// end

// always @(posedge clock)
// begin 
//     $fwrite(file, "submodule2.sig2 = %0h\n", u2.bankE.cs1.ts.);
//     for (i = 0; i < N; i = i + 1) begin
//             $fwrite(file, "tagGen[%0d].r.DOUT = %0h\n", i, u2.bankE.cs1.ts.data[i*8 + 7: i*8]);
//     end  
// end
assign clk_$ = clk;
integer file_handle;
integer file_dump;
integer clk_ctr_$;
initial begin
    // Open the file for writing
    file_handle = $fopen("dcache_dump.csv", "w");
    file_dump = $fopen("dcache_cur_line.csv", "w");
    if (file_handle == 0) begin
        $display("Error: Failed to open file for eflags!");
    end
    clk_ctr_$ = 0;

    
end
always @(posedge clk) begin
      clk_ctr_$ = clk_ctr_$ + 1;
end
always @(negedge clk) begin
    // Write signal values to the file at every clock cycle
    if (valid_e_$ == 1'b1 || valid_o_$ == 1'b1) begin
        @(posedge clk)
        $fwrite(file_dump,"\n////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n");
        $fwrite(file_dump, "Cycle,%d,", clk_ctr_$);
        $fwrite(file_dump, "PTC ID,%h,", ptcid_$);
        $fwrite(file_dump, "R_SW_W,%b%b%b,RdFull: %b | SwFull: %b | WFull: %b\n", r_$, sw_$, w_$,rdaq_isfull, swaq_isfull, wbaq_isfull);
        $fwrite(file_dump, "From bus,%b,", fromBUS_$);
        $fwrite(file_dump, "PTC_INFO,%h\n", ptcinfo_out);
        
        //Even
        $fwrite(file_dump, "\nEven Info\nEven Valid,%b\n", valid_e_$);
        $fwrite(file_dump, "Even P_Address,%h,", pAddress_e_$);
        $fwrite(file_dump, "Even Data,%h,", data_e_$);
        $fwrite(file_dump, "Even Size,%h,", size_e_$);
        $fwrite(file_dump, "Even Mask,%h\n", mask_e_$);
        //Tag Store
        $fwrite(file_dump, "Write to Tag,%b\n",bankE.cs1.ts.w_unpulsed);
        $fwrite(file_dump, "Tag_in,Index,Hits,Way_in,Tag_Dump3,Tag_Dump2,Tag_Dump1,Tag_Dump0,Tag_out \n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankE.cs1.tag_in, bankE.cs1.index, bankE.cs1.ts.hit, bankE.cs1.ts.way, bankE.cs1.ts.tag_dump[31:24],bankE.cs1.ts.tag_dump[23:16],bankE.cs1.ts.tag_dump[15:8],bankE.cs1.ts.tag_dump[7:0], bankE.cs1.ts.tag_out);
        //DataStore
        $fwrite(file_dump, "Write_toDS, Index, Way, Data_in, mask_in, Data_out,cache_line3,cache_line2,cache_line1,cache_line0\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankE.cs1.ds.valid, bankE.cs1.ds.index, bankE.cs1.ds.way, bankE.cs1.ds.data_in, bankE.cs1.ds.mask_in,bankE.cs1.ds.cache_line,bankE.cs1.ds.data_out[511:384],bankE.cs1.ds.data_out[383:256],bankE.cs1.ds.data_out[255:128],bankE.cs1.ds.data_out[127:0]);
        //MetaStore
        $fwrite(file_dump, "Valid_MS, R, WB, SW, EX, PTCID_IN, V, PTC, D, LRU\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankE.cs1.ms.valid, bankE.cs1.ms.r, bankE.cs1.ms.wb, bankE.cs1.ms.sw, bankE.cs1.ms.ex, bankE.cs1.ms.ID_IN, bankE.cs1.ms.VALID_out, bankE.cs1.ms.PTC_out, bankE.cs1.ms.DIRTY_out, bankE.cs1.ms.LRU); 
        //WayGeneration
        $fwrite(file_dump, "Valid_WG, EX_WB, EX_CLR, STALL,WAY, D_OUT, V_out, PTC_out, MISS\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankE.cs1.wg.valid_in, bankE.cs1.wg.ex_wb, bankE.cs1.wg.ex_clr, bankE.cs1.wg.stall, bankE.cs1.wg.way, bankE.cs1.wg.D_out, bankE.cs1.wg.V_out, bankE.cs1.wg.PTC_out, bankE.cs1.wg.MISS);
        //SER1
        $fwrite(file_dump, "SER_V1, RET1, SIZE1, RW1, DEST1, P_ADDR1\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h\n", bankE.SER_valid1, bankE.SER_return1, bankE.SER_size1, bankE.SER_rw1, bankE.SER_dest1, bankE.SER_pAddress1);
        //SER0
        $fwrite(file_dump, "SER_V0, RET0, SIZE0, RW0, DEST0, P_ADDR0,DATA0\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h\n", bankE.SER_valid0, bankE.SER_return0, bankE.SER_size0, bankE.SER_rw0, bankE.SER_dest0, bankE.SER_pAddress0, bankE.SER_data0);
    
       
        //Odd
        $fwrite(file_dump, "\nOdd Info\nOdd Valid,%b\n", valid_o_$);
        $fwrite(file_dump, "Odd P_Address,%h,", pAddress_o_$);
        $fwrite(file_dump, "Odd Data,%h,", data_o_$);
        $fwrite(file_dump, "Odd Size,%h,", size_o_$);
        $fwrite(file_dump, "Odd Mask,%h\n", mask_o_$);
        //Tag Store
        $fwrite(file_dump, "Write to Tag,%b\n",bankO.cs1.ts.w_unpulsed);
        $fwrite(file_dump, "Tag_in,Index,Hits,Way_in,Tag_Dump3,Tag_Dump2,Tag_Dump1,Tag_Dump0,Tag_out \n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankO.cs1.tag_in, bankO.cs1.index, bankO.cs1.ts.hit, bankO.cs1.ts.way, bankO.cs1.ts.tag_dump[31:24],bankO.cs1.ts.tag_dump[23:16],bankO.cs1.ts.tag_dump[15:8],bankO.cs1.ts.tag_dump[7:0], bankO.cs1.ts.tag_out);
        //DataStore
        $fwrite(file_dump, "Write_toDS, Index, Way, Data_in, mask_in, Data_out,cache_line3,cache_line2,cache_line1,cache_line0\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankO.cs1.ds.valid, bankO.cs1.ds.index, bankO.cs1.ds.way, bankO.cs1.ds.data_in, bankO.cs1.ds.mask_in,bankO.cs1.ds.cache_line,bankO.cs1.ds.data_out[511:384],bankO.cs1.ds.data_out[383:256],bankO.cs1.ds.data_out[255:128],bankO.cs1.ds.data_out[127:0]);
        //MetaStore
        $fwrite(file_dump, "Valid_MS, R, WB, SW, EX, PTCID_IN, V, PTC, D, LRU\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankO.cs1.ms.valid, bankO.cs1.ms.r, bankO.cs1.ms.wb, bankO.cs1.ms.sw, bankO.cs1.ms.ex, bankO.cs1.ms.ID_IN, bankO.cs1.ms.VALID_out, bankO.cs1.ms.PTC_out, bankO.cs1.ms.DIRTY_out, bankO.cs1.ms.LRU); 
        //WayGeneration
        $fwrite(file_dump, "Valid_WG, EX_WB, EX_CLR, STALL,WAY, D_OUT, V_out, PTC_out, MISS\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h,%h,%h\n", bankO.cs1.wg.valid_in, bankO.cs1.wg.ex_wb, bankO.cs1.wg.ex_clr, bankO.cs1.wg.stall, bankO.cs1.wg.way, bankO.cs1.wg.D_out, bankO.cs1.wg.V_out, bankO.cs1.wg.PTC_out, bankO.cs1.wg.MISS);
        //SER1
        $fwrite(file_dump, "SER_V1, RET1, SIZE1, RW1, DEST1, P_ADDR1\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h\n", bankO.SER_valid1, bankO.SER_return1, bankO.SER_size1, bankO.SER_rw1, bankO.SER_dest1, bankO.SER_pAddress1);
        //SER0
        $fwrite(file_dump, "SER_V0, RET0, SIZE0, RW0, DEST0, P_ADDR0,DATA0\n");
        $fwrite(file_dump, "%h,%h,%h,%h,%h,%h,%h\n", bankO.SER_valid0, bankO.SER_return0, bankO.SER_size0, bankO.SER_rw0, bankO.SER_dest0, bankO.SER_pAddress0, bankO.SER_data0);
        $fwrite(file_dump,"\n////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n");



    end
end
 
always  @(posedge clk) begin
        #3
        if (valid_e_$ == 1'b1 || valid_o_$ == 1'b1 || clk_ctr_$ == 32'd700) begin
            $fwrite(file_handle, "\n/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\nCycle #,Cyc: %d\n", clk_ctr_$);
            $fwrite(file_handle, "EVEN TAG STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[3], bankE.cs1.ts.tagGen[2].r.mem[3],bankE.cs1.ts.tagGen[1].r.mem[3],bankE.cs1.ts.tagGen[0].r.mem[3]);
            $fwrite(file_handle, "2,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[2], bankE.cs1.ts.tagGen[2].r.mem[2],bankE.cs1.ts.tagGen[1].r.mem[2],bankE.cs1.ts.tagGen[0].r.mem[2]);
            $fwrite(file_handle, "1,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[1], bankE.cs1.ts.tagGen[2].r.mem[1],bankE.cs1.ts.tagGen[1].r.mem[1],bankE.cs1.ts.tagGen[0].r.mem[1]);
            $fwrite(file_handle, "0,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[0], bankE.cs1.ts.tagGen[2].r.mem[0],bankE.cs1.ts.tagGen[1].r.mem[0],bankE.cs1.ts.tagGen[0].r.mem[0]);
           
            $fwrite(file_handle, "EVEN DATA STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[3], bankE.cs1.ds.dataGen[62].r.mem[3], bankE.cs1.ds.dataGen[61].r.mem[3], bankE.cs1.ds.dataGen[60].r.mem[3], bankE.cs1.ds.dataGen[59].r.mem[3], bankE.cs1.ds.dataGen[58].r.mem[3], bankE.cs1.ds.dataGen[57].r.mem[3], bankE.cs1.ds.dataGen[56].r.mem[3], bankE.cs1.ds.dataGen[55].r.mem[3], bankE.cs1.ds.dataGen[54].r.mem[3], bankE.cs1.ds.dataGen[53].r.mem[3], bankE.cs1.ds.dataGen[52].r.mem[3], bankE.cs1.ds.dataGen[51].r.mem[3], bankE.cs1.ds.dataGen[50].r.mem[3], bankE.cs1.ds.dataGen[49].r.mem[3], bankE.cs1.ds.dataGen[48].r.mem[3]}, 
                {bankE.cs1.ds.dataGen[47].r.mem[3], bankE.cs1.ds.dataGen[46].r.mem[3], bankE.cs1.ds.dataGen[45].r.mem[3], bankE.cs1.ds.dataGen[44].r.mem[3], bankE.cs1.ds.dataGen[43].r.mem[3], bankE.cs1.ds.dataGen[42].r.mem[3], bankE.cs1.ds.dataGen[41].r.mem[3], bankE.cs1.ds.dataGen[40].r.mem[3], bankE.cs1.ds.dataGen[39].r.mem[3], bankE.cs1.ds.dataGen[38].r.mem[3], bankE.cs1.ds.dataGen[37].r.mem[3], bankE.cs1.ds.dataGen[36].r.mem[3], bankE.cs1.ds.dataGen[35].r.mem[3], bankE.cs1.ds.dataGen[34].r.mem[3], bankE.cs1.ds.dataGen[33].r.mem[3], bankE.cs1.ds.dataGen[32].r.mem[3]},
                {bankE.cs1.ds.dataGen[31].r.mem[3], bankE.cs1.ds.dataGen[30].r.mem[3], bankE.cs1.ds.dataGen[29].r.mem[3], bankE.cs1.ds.dataGen[28].r.mem[3], bankE.cs1.ds.dataGen[27].r.mem[3], bankE.cs1.ds.dataGen[26].r.mem[3], bankE.cs1.ds.dataGen[25].r.mem[3], bankE.cs1.ds.dataGen[24].r.mem[3], bankE.cs1.ds.dataGen[23].r.mem[3], bankE.cs1.ds.dataGen[22].r.mem[3], bankE.cs1.ds.dataGen[21].r.mem[3], bankE.cs1.ds.dataGen[20].r.mem[3], bankE.cs1.ds.dataGen[19].r.mem[3], bankE.cs1.ds.dataGen[18].r.mem[3], bankE.cs1.ds.dataGen[17].r.mem[3], bankE.cs1.ds.dataGen[16].r.mem[3]}, 
                {bankE.cs1.ds.dataGen[15].r.mem[3], bankE.cs1.ds.dataGen[14].r.mem[3], bankE.cs1.ds.dataGen[13].r.mem[3], bankE.cs1.ds.dataGen[12].r.mem[3], bankE.cs1.ds.dataGen[11].r.mem[3], bankE.cs1.ds.dataGen[10].r.mem[3], bankE.cs1.ds.dataGen[9].r.mem[3], bankE.cs1.ds.dataGen[8].r.mem[3], bankE.cs1.ds.dataGen[7].r.mem[3], bankE.cs1.ds.dataGen[6].r.mem[3], bankE.cs1.ds.dataGen[5].r.mem[3], bankE.cs1.ds.dataGen[4].r.mem[3], bankE.cs1.ds.dataGen[3].r.mem[3], bankE.cs1.ds.dataGen[2].r.mem[3], bankE.cs1.ds.dataGen[1].r.mem[3], bankE.cs1.ds.dataGen[0].r.mem[3]});
            $fwrite(file_handle, "2,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[2], bankE.cs1.ds.dataGen[62].r.mem[2], bankE.cs1.ds.dataGen[61].r.mem[2], bankE.cs1.ds.dataGen[60].r.mem[2], bankE.cs1.ds.dataGen[59].r.mem[2], bankE.cs1.ds.dataGen[58].r.mem[2], bankE.cs1.ds.dataGen[57].r.mem[2], bankE.cs1.ds.dataGen[56].r.mem[2], bankE.cs1.ds.dataGen[55].r.mem[2], bankE.cs1.ds.dataGen[54].r.mem[2], bankE.cs1.ds.dataGen[53].r.mem[2], bankE.cs1.ds.dataGen[52].r.mem[2], bankE.cs1.ds.dataGen[51].r.mem[2], bankE.cs1.ds.dataGen[50].r.mem[2], bankE.cs1.ds.dataGen[49].r.mem[2], bankE.cs1.ds.dataGen[48].r.mem[2]}, {bankE.cs1.ds.dataGen[47].r.mem[2], bankE.cs1.ds.dataGen[46].r.mem[2], bankE.cs1.ds.dataGen[45].r.mem[2], bankE.cs1.ds.dataGen[44].r.mem[2], bankE.cs1.ds.dataGen[43].r.mem[2], bankE.cs1.ds.dataGen[42].r.mem[2], bankE.cs1.ds.dataGen[41].r.mem[2], bankE.cs1.ds.dataGen[40].r.mem[2], bankE.cs1.ds.dataGen[39].r.mem[2], bankE.cs1.ds.dataGen[38].r.mem[2], bankE.cs1.ds.dataGen[37].r.mem[2], bankE.cs1.ds.dataGen[36].r.mem[2], bankE.cs1.ds.dataGen[35].r.mem[2], bankE.cs1.ds.dataGen[34].r.mem[2], bankE.cs1.ds.dataGen[33].r.mem[2], bankE.cs1.ds.dataGen[32].r.mem[2]}, {bankE.cs1.ds.dataGen[31].r.mem[2], bankE.cs1.ds.dataGen[30].r.mem[2], bankE.cs1.ds.dataGen[29].r.mem[2], bankE.cs1.ds.dataGen[28].r.mem[2], bankE.cs1.ds.dataGen[27].r.mem[2], bankE.cs1.ds.dataGen[26].r.mem[2], bankE.cs1.ds.dataGen[25].r.mem[2], bankE.cs1.ds.dataGen[24].r.mem[2], bankE.cs1.ds.dataGen[23].r.mem[2], bankE.cs1.ds.dataGen[22].r.mem[2], bankE.cs1.ds.dataGen[21].r.mem[2], bankE.cs1.ds.dataGen[20].r.mem[2], bankE.cs1.ds.dataGen[19].r.mem[2], bankE.cs1.ds.dataGen[18].r.mem[2], bankE.cs1.ds.dataGen[17].r.mem[2], bankE.cs1.ds.dataGen[16].r.mem[2]}, {bankE.cs1.ds.dataGen[15].r.mem[2], bankE.cs1.ds.dataGen[14].r.mem[2], bankE.cs1.ds.dataGen[13].r.mem[2], bankE.cs1.ds.dataGen[12].r.mem[2], bankE.cs1.ds.dataGen[11].r.mem[2], bankE.cs1.ds.dataGen[10].r.mem[2], bankE.cs1.ds.dataGen[9].r.mem[2], bankE.cs1.ds.dataGen[8].r.mem[2], bankE.cs1.ds.dataGen[7].r.mem[2], bankE.cs1.ds.dataGen[6].r.mem[2], bankE.cs1.ds.dataGen[5].r.mem[2], bankE.cs1.ds.dataGen[4].r.mem[2], bankE.cs1.ds.dataGen[3].r.mem[2], bankE.cs1.ds.dataGen[2].r.mem[2], bankE.cs1.ds.dataGen[1].r.mem[2], bankE.cs1.ds.dataGen[0].r.mem[2]});
            $fwrite(file_handle, "1,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[1], bankE.cs1.ds.dataGen[62].r.mem[1], bankE.cs1.ds.dataGen[61].r.mem[1], bankE.cs1.ds.dataGen[60].r.mem[1], bankE.cs1.ds.dataGen[59].r.mem[1], bankE.cs1.ds.dataGen[58].r.mem[1], bankE.cs1.ds.dataGen[57].r.mem[1], bankE.cs1.ds.dataGen[56].r.mem[1], bankE.cs1.ds.dataGen[55].r.mem[1], bankE.cs1.ds.dataGen[54].r.mem[1], bankE.cs1.ds.dataGen[53].r.mem[1], bankE.cs1.ds.dataGen[52].r.mem[1], bankE.cs1.ds.dataGen[51].r.mem[1], bankE.cs1.ds.dataGen[50].r.mem[1], bankE.cs1.ds.dataGen[49].r.mem[1], bankE.cs1.ds.dataGen[48].r.mem[1]}, {bankE.cs1.ds.dataGen[47].r.mem[1], bankE.cs1.ds.dataGen[46].r.mem[1], bankE.cs1.ds.dataGen[45].r.mem[1], bankE.cs1.ds.dataGen[44].r.mem[1], bankE.cs1.ds.dataGen[43].r.mem[1], bankE.cs1.ds.dataGen[42].r.mem[1], bankE.cs1.ds.dataGen[41].r.mem[1], bankE.cs1.ds.dataGen[40].r.mem[1], bankE.cs1.ds.dataGen[39].r.mem[1], bankE.cs1.ds.dataGen[38].r.mem[1], bankE.cs1.ds.dataGen[37].r.mem[1], bankE.cs1.ds.dataGen[36].r.mem[1], bankE.cs1.ds.dataGen[35].r.mem[1], bankE.cs1.ds.dataGen[34].r.mem[1], bankE.cs1.ds.dataGen[33].r.mem[1], bankE.cs1.ds.dataGen[32].r.mem[1]}, {bankE.cs1.ds.dataGen[31].r.mem[1], bankE.cs1.ds.dataGen[30].r.mem[1], bankE.cs1.ds.dataGen[29].r.mem[1], bankE.cs1.ds.dataGen[28].r.mem[1], bankE.cs1.ds.dataGen[27].r.mem[1], bankE.cs1.ds.dataGen[26].r.mem[1], bankE.cs1.ds.dataGen[25].r.mem[1], bankE.cs1.ds.dataGen[24].r.mem[1], bankE.cs1.ds.dataGen[23].r.mem[1], bankE.cs1.ds.dataGen[22].r.mem[1], bankE.cs1.ds.dataGen[21].r.mem[1], bankE.cs1.ds.dataGen[20].r.mem[1], bankE.cs1.ds.dataGen[19].r.mem[1], bankE.cs1.ds.dataGen[18].r.mem[1], bankE.cs1.ds.dataGen[17].r.mem[1], bankE.cs1.ds.dataGen[16].r.mem[1]}, {bankE.cs1.ds.dataGen[15].r.mem[1], bankE.cs1.ds.dataGen[14].r.mem[1], bankE.cs1.ds.dataGen[13].r.mem[1], bankE.cs1.ds.dataGen[12].r.mem[1], bankE.cs1.ds.dataGen[11].r.mem[1], bankE.cs1.ds.dataGen[10].r.mem[1], bankE.cs1.ds.dataGen[9].r.mem[1], bankE.cs1.ds.dataGen[8].r.mem[1], bankE.cs1.ds.dataGen[7].r.mem[1], bankE.cs1.ds.dataGen[6].r.mem[1], bankE.cs1.ds.dataGen[5].r.mem[1], bankE.cs1.ds.dataGen[4].r.mem[1], bankE.cs1.ds.dataGen[3].r.mem[1], bankE.cs1.ds.dataGen[2].r.mem[1], bankE.cs1.ds.dataGen[1].r.mem[1], bankE.cs1.ds.dataGen[0].r.mem[1]});
            $fwrite(file_handle, "0,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[0], bankE.cs1.ds.dataGen[62].r.mem[0], bankE.cs1.ds.dataGen[61].r.mem[0], bankE.cs1.ds.dataGen[60].r.mem[0], bankE.cs1.ds.dataGen[59].r.mem[0], bankE.cs1.ds.dataGen[58].r.mem[0], bankE.cs1.ds.dataGen[57].r.mem[0], bankE.cs1.ds.dataGen[56].r.mem[0], bankE.cs1.ds.dataGen[55].r.mem[0], bankE.cs1.ds.dataGen[54].r.mem[0], bankE.cs1.ds.dataGen[53].r.mem[0], bankE.cs1.ds.dataGen[52].r.mem[0], bankE.cs1.ds.dataGen[51].r.mem[0], bankE.cs1.ds.dataGen[50].r.mem[0], bankE.cs1.ds.dataGen[49].r.mem[0], bankE.cs1.ds.dataGen[48].r.mem[0]}, {bankE.cs1.ds.dataGen[47].r.mem[0], bankE.cs1.ds.dataGen[46].r.mem[0], bankE.cs1.ds.dataGen[45].r.mem[0], bankE.cs1.ds.dataGen[44].r.mem[0], bankE.cs1.ds.dataGen[43].r.mem[0], bankE.cs1.ds.dataGen[42].r.mem[0], bankE.cs1.ds.dataGen[41].r.mem[0], bankE.cs1.ds.dataGen[40].r.mem[0], bankE.cs1.ds.dataGen[39].r.mem[0], bankE.cs1.ds.dataGen[38].r.mem[0], bankE.cs1.ds.dataGen[37].r.mem[0], bankE.cs1.ds.dataGen[36].r.mem[0], bankE.cs1.ds.dataGen[35].r.mem[0], bankE.cs1.ds.dataGen[34].r.mem[0], bankE.cs1.ds.dataGen[33].r.mem[0], bankE.cs1.ds.dataGen[32].r.mem[0]}, {bankE.cs1.ds.dataGen[31].r.mem[0], bankE.cs1.ds.dataGen[30].r.mem[0], bankE.cs1.ds.dataGen[29].r.mem[0], bankE.cs1.ds.dataGen[28].r.mem[0], bankE.cs1.ds.dataGen[27].r.mem[0], bankE.cs1.ds.dataGen[26].r.mem[0], bankE.cs1.ds.dataGen[25].r.mem[0], bankE.cs1.ds.dataGen[24].r.mem[0], bankE.cs1.ds.dataGen[23].r.mem[0], bankE.cs1.ds.dataGen[22].r.mem[0], bankE.cs1.ds.dataGen[21].r.mem[0], bankE.cs1.ds.dataGen[20].r.mem[0], bankE.cs1.ds.dataGen[19].r.mem[0], bankE.cs1.ds.dataGen[18].r.mem[0], bankE.cs1.ds.dataGen[17].r.mem[0], bankE.cs1.ds.dataGen[16].r.mem[0]}, {bankE.cs1.ds.dataGen[15].r.mem[0], bankE.cs1.ds.dataGen[14].r.mem[0], bankE.cs1.ds.dataGen[13].r.mem[0], bankE.cs1.ds.dataGen[12].r.mem[0], bankE.cs1.ds.dataGen[11].r.mem[0], bankE.cs1.ds.dataGen[10].r.mem[0], bankE.cs1.ds.dataGen[9].r.mem[0], bankE.cs1.ds.dataGen[8].r.mem[0], bankE.cs1.ds.dataGen[7].r.mem[0], bankE.cs1.ds.dataGen[6].r.mem[0], bankE.cs1.ds.dataGen[5].r.mem[0], bankE.cs1.ds.dataGen[4].r.mem[0], bankE.cs1.ds.dataGen[3].r.mem[0], bankE.cs1.ds.dataGen[2].r.mem[0], bankE.cs1.ds.dataGen[1].r.mem[0], bankE.cs1.ds.dataGen[0].r.mem[0]});

            $fwrite(file_handle, "EVEN Meta Store - LRU_PTCID_V_PTC_D\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[15:12],bankE.cs1.ms.LRU2[15:12],bankE.cs1.ms.LRU1[15:12],bankE.cs1.ms.LRU0[15:12],bankE.cs1.ms.PTCID[127:120], bankE.cs1.ms.PTCID[119:112], bankE.cs1.ms.PTCID[111:104], bankE.cs1.ms.PTCID[103:96]   , {bankE.cs1.ms.VALID[15], bankE.cs1.ms.PTC[15], bankE.cs1.ms.DIRTY[15]},       {bankE.cs1.ms.VALID[14], bankE.cs1.ms.PTC[14], bankE.cs1.ms.DIRTY[14]} ,{bankE.cs1.ms.VALID[13], bankE.cs1.ms.PTC[13], bankE.cs1.ms.DIRTY[13]},{bankE.cs1.ms.VALID[12], bankE.cs1.ms.PTC[12], bankE.cs1.ms.DIRTY[12]},       );
            $fwrite(file_handle, "2,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[11:8],bankE.cs1.ms.LRU2[11:8],bankE.cs1.ms.LRU1[11:8],bankE.cs1.ms.LRU0[11:8],bankE.cs1.ms.PTCID[95:88],   bankE.cs1.ms.PTCID[87:80],   bankE.cs1.ms.PTCID[79:72],   bankE.cs1.ms.PTCID[71:64]   ,  {bankE.cs1.ms.VALID[11], bankE.cs1.ms.PTC[11], bankE.cs1.ms.DIRTY[11]},       {bankE.cs1.ms.VALID[10], bankE.cs1.ms.PTC[10], bankE.cs1.ms.DIRTY[10]},       {bankE.cs1.ms.VALID[9], bankE.cs1.ms.PTC[9], bankE.cs1.ms.DIRTY[9]},       {bankE.cs1.ms.VALID[8], bankE.cs1.ms.PTC[8], bankE.cs1.ms.DIRTY[8]}, );
            $fwrite(file_handle, "1,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[7:4],bankE.cs1.ms.LRU2[7:4],bankE.cs1.ms.LRU1[7:4],bankE.cs1.ms.LRU0[7:4],bankE.cs1.ms.PTCID[63:56],   bankE.cs1.ms.PTCID[55:48],   bankE.cs1.ms.PTCID[47:40],   bankE.cs1.ms.PTCID[39:32]   ,  {bankE.cs1.ms.VALID[7], bankE.cs1.ms.PTC[7], bankE.cs1.ms.DIRTY[7]},       {bankE.cs1.ms.VALID[6], bankE.cs1.ms.PTC[6], bankE.cs1.ms.DIRTY[6]},       {bankE.cs1.ms.VALID[5], bankE.cs1.ms.PTC[5], bankE.cs1.ms.DIRTY[5]},       {bankE.cs1.ms.VALID[4], bankE.cs1.ms.PTC[4], bankE.cs1.ms.DIRTY[4]}, );
            $fwrite(file_handle, "0,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[3:0],bankE.cs1.ms.LRU2[3:0],bankE.cs1.ms.LRU1[3:0],bankE.cs1.ms.LRU0[3:0],bankE.cs1.ms.PTCID[31:24],   bankE.cs1.ms.PTCID[23:16],   bankE.cs1.ms.PTCID[15:8],    bankE.cs1.ms.VALID[7:0]   , {bankE.cs1.ms.VALID[3], bankE.cs1.ms.PTC[3], bankE.cs1.ms.DIRTY[3]},       {bankE.cs1.ms.VALID[2], bankE.cs1.ms.PTC[2], bankE.cs1.ms.DIRTY[2]},       {bankE.cs1.ms.VALID[1], bankE.cs1.ms.PTC[1], bankE.cs1.ms.DIRTY[1]},       {bankE.cs1.ms.VALID[0], bankE.cs1.ms.PTC[0], bankE.cs1.ms.DIRTY[0]}, );

            $fwrite(file_handle, "ODD TAG STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[3], bankO.cs1.ts.tagGen[2].r.mem[3],bankO.cs1.ts.tagGen[1].r.mem[3],bankO.cs1.ts.tagGen[0].r.mem[3]);
            $fwrite(file_handle, "2,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[2], bankO.cs1.ts.tagGen[2].r.mem[2],bankO.cs1.ts.tagGen[1].r.mem[2],bankO.cs1.ts.tagGen[0].r.mem[2]);
            $fwrite(file_handle, "1,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[1], bankO.cs1.ts.tagGen[2].r.mem[1],bankO.cs1.ts.tagGen[1].r.mem[1],bankO.cs1.ts.tagGen[0].r.mem[1]);
            $fwrite(file_handle, "0,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[0], bankO.cs1.ts.tagGen[2].r.mem[0],bankO.cs1.ts.tagGen[1].r.mem[0],bankO.cs1.ts.tagGen[0].r.mem[0]);
           
            $fwrite(file_handle, "ODD DATA STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[3], bankO.cs1.ds.dataGen[62].r.mem[3], bankO.cs1.ds.dataGen[61].r.mem[3], bankO.cs1.ds.dataGen[60].r.mem[3], bankO.cs1.ds.dataGen[59].r.mem[3], bankO.cs1.ds.dataGen[58].r.mem[3], bankO.cs1.ds.dataGen[57].r.mem[3], bankO.cs1.ds.dataGen[56].r.mem[3], bankO.cs1.ds.dataGen[55].r.mem[3], bankO.cs1.ds.dataGen[54].r.mem[3], bankO.cs1.ds.dataGen[53].r.mem[3], bankO.cs1.ds.dataGen[52].r.mem[3], bankO.cs1.ds.dataGen[51].r.mem[3], bankO.cs1.ds.dataGen[50].r.mem[3], bankO.cs1.ds.dataGen[49].r.mem[3], bankO.cs1.ds.dataGen[48].r.mem[3]}, 
                {bankO.cs1.ds.dataGen[47].r.mem[3], bankO.cs1.ds.dataGen[46].r.mem[3], bankO.cs1.ds.dataGen[45].r.mem[3], bankO.cs1.ds.dataGen[44].r.mem[3], bankO.cs1.ds.dataGen[43].r.mem[3], bankO.cs1.ds.dataGen[42].r.mem[3], bankO.cs1.ds.dataGen[41].r.mem[3], bankO.cs1.ds.dataGen[40].r.mem[3], bankO.cs1.ds.dataGen[39].r.mem[3], bankO.cs1.ds.dataGen[38].r.mem[3], bankO.cs1.ds.dataGen[37].r.mem[3], bankO.cs1.ds.dataGen[36].r.mem[3], bankO.cs1.ds.dataGen[35].r.mem[3], bankO.cs1.ds.dataGen[34].r.mem[3], bankO.cs1.ds.dataGen[33].r.mem[3], bankO.cs1.ds.dataGen[32].r.mem[3]},
                {bankO.cs1.ds.dataGen[31].r.mem[3], bankO.cs1.ds.dataGen[30].r.mem[3], bankO.cs1.ds.dataGen[29].r.mem[3], bankO.cs1.ds.dataGen[28].r.mem[3], bankO.cs1.ds.dataGen[27].r.mem[3], bankO.cs1.ds.dataGen[26].r.mem[3], bankO.cs1.ds.dataGen[25].r.mem[3], bankO.cs1.ds.dataGen[24].r.mem[3], bankO.cs1.ds.dataGen[23].r.mem[3], bankO.cs1.ds.dataGen[22].r.mem[3], bankO.cs1.ds.dataGen[21].r.mem[3], bankO.cs1.ds.dataGen[20].r.mem[3], bankO.cs1.ds.dataGen[19].r.mem[3], bankO.cs1.ds.dataGen[18].r.mem[3], bankO.cs1.ds.dataGen[17].r.mem[3], bankO.cs1.ds.dataGen[16].r.mem[3]}, 
                {bankO.cs1.ds.dataGen[15].r.mem[3], bankO.cs1.ds.dataGen[14].r.mem[3], bankO.cs1.ds.dataGen[13].r.mem[3], bankO.cs1.ds.dataGen[12].r.mem[3], bankO.cs1.ds.dataGen[11].r.mem[3], bankO.cs1.ds.dataGen[10].r.mem[3], bankO.cs1.ds.dataGen[9].r.mem[3], bankO.cs1.ds.dataGen[8].r.mem[3], bankO.cs1.ds.dataGen[7].r.mem[3], bankO.cs1.ds.dataGen[6].r.mem[3], bankO.cs1.ds.dataGen[5].r.mem[3], bankO.cs1.ds.dataGen[4].r.mem[3], bankO.cs1.ds.dataGen[3].r.mem[3], bankO.cs1.ds.dataGen[2].r.mem[3], bankO.cs1.ds.dataGen[1].r.mem[3], bankO.cs1.ds.dataGen[0].r.mem[3]});
            $fwrite(file_handle, "2,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[2], bankO.cs1.ds.dataGen[62].r.mem[2], bankO.cs1.ds.dataGen[61].r.mem[2], bankO.cs1.ds.dataGen[60].r.mem[2], bankO.cs1.ds.dataGen[59].r.mem[2], bankO.cs1.ds.dataGen[58].r.mem[2], bankO.cs1.ds.dataGen[57].r.mem[2], bankO.cs1.ds.dataGen[56].r.mem[2], bankO.cs1.ds.dataGen[55].r.mem[2], bankO.cs1.ds.dataGen[54].r.mem[2], bankO.cs1.ds.dataGen[53].r.mem[2], bankO.cs1.ds.dataGen[52].r.mem[2], bankO.cs1.ds.dataGen[51].r.mem[2], bankO.cs1.ds.dataGen[50].r.mem[2], bankO.cs1.ds.dataGen[49].r.mem[2], bankO.cs1.ds.dataGen[48].r.mem[2]}, {bankO.cs1.ds.dataGen[47].r.mem[2], bankO.cs1.ds.dataGen[46].r.mem[2], bankO.cs1.ds.dataGen[45].r.mem[2], bankO.cs1.ds.dataGen[44].r.mem[2], bankO.cs1.ds.dataGen[43].r.mem[2], bankO.cs1.ds.dataGen[42].r.mem[2], bankO.cs1.ds.dataGen[41].r.mem[2], bankO.cs1.ds.dataGen[40].r.mem[2], bankO.cs1.ds.dataGen[39].r.mem[2], bankO.cs1.ds.dataGen[38].r.mem[2], bankO.cs1.ds.dataGen[37].r.mem[2], bankO.cs1.ds.dataGen[36].r.mem[2], bankO.cs1.ds.dataGen[35].r.mem[2], bankO.cs1.ds.dataGen[34].r.mem[2], bankO.cs1.ds.dataGen[33].r.mem[2], bankO.cs1.ds.dataGen[32].r.mem[2]}, {bankO.cs1.ds.dataGen[31].r.mem[2], bankO.cs1.ds.dataGen[30].r.mem[2], bankO.cs1.ds.dataGen[29].r.mem[2], bankO.cs1.ds.dataGen[28].r.mem[2], bankO.cs1.ds.dataGen[27].r.mem[2], bankO.cs1.ds.dataGen[26].r.mem[2], bankO.cs1.ds.dataGen[25].r.mem[2], bankO.cs1.ds.dataGen[24].r.mem[2], bankO.cs1.ds.dataGen[23].r.mem[2], bankO.cs1.ds.dataGen[22].r.mem[2], bankO.cs1.ds.dataGen[21].r.mem[2], bankO.cs1.ds.dataGen[20].r.mem[2], bankO.cs1.ds.dataGen[19].r.mem[2], bankO.cs1.ds.dataGen[18].r.mem[2], bankO.cs1.ds.dataGen[17].r.mem[2], bankO.cs1.ds.dataGen[16].r.mem[2]}, {bankO.cs1.ds.dataGen[15].r.mem[2], bankO.cs1.ds.dataGen[14].r.mem[2], bankO.cs1.ds.dataGen[13].r.mem[2], bankO.cs1.ds.dataGen[12].r.mem[2], bankO.cs1.ds.dataGen[11].r.mem[2], bankO.cs1.ds.dataGen[10].r.mem[2], bankO.cs1.ds.dataGen[9].r.mem[2], bankO.cs1.ds.dataGen[8].r.mem[2], bankO.cs1.ds.dataGen[7].r.mem[2], bankO.cs1.ds.dataGen[6].r.mem[2], bankO.cs1.ds.dataGen[5].r.mem[2], bankO.cs1.ds.dataGen[4].r.mem[2], bankO.cs1.ds.dataGen[3].r.mem[2], bankO.cs1.ds.dataGen[2].r.mem[2], bankO.cs1.ds.dataGen[1].r.mem[2], bankO.cs1.ds.dataGen[0].r.mem[2]});
            $fwrite(file_handle, "1,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[1], bankO.cs1.ds.dataGen[62].r.mem[1], bankO.cs1.ds.dataGen[61].r.mem[1], bankO.cs1.ds.dataGen[60].r.mem[1], bankO.cs1.ds.dataGen[59].r.mem[1], bankO.cs1.ds.dataGen[58].r.mem[1], bankO.cs1.ds.dataGen[57].r.mem[1], bankO.cs1.ds.dataGen[56].r.mem[1], bankO.cs1.ds.dataGen[55].r.mem[1], bankO.cs1.ds.dataGen[54].r.mem[1], bankO.cs1.ds.dataGen[53].r.mem[1], bankO.cs1.ds.dataGen[52].r.mem[1], bankO.cs1.ds.dataGen[51].r.mem[1], bankO.cs1.ds.dataGen[50].r.mem[1], bankO.cs1.ds.dataGen[49].r.mem[1], bankO.cs1.ds.dataGen[48].r.mem[1]}, {bankO.cs1.ds.dataGen[47].r.mem[1], bankO.cs1.ds.dataGen[46].r.mem[1], bankO.cs1.ds.dataGen[45].r.mem[1], bankO.cs1.ds.dataGen[44].r.mem[1], bankO.cs1.ds.dataGen[43].r.mem[1], bankO.cs1.ds.dataGen[42].r.mem[1], bankO.cs1.ds.dataGen[41].r.mem[1], bankO.cs1.ds.dataGen[40].r.mem[1], bankO.cs1.ds.dataGen[39].r.mem[1], bankO.cs1.ds.dataGen[38].r.mem[1], bankO.cs1.ds.dataGen[37].r.mem[1], bankO.cs1.ds.dataGen[36].r.mem[1], bankO.cs1.ds.dataGen[35].r.mem[1], bankO.cs1.ds.dataGen[34].r.mem[1], bankO.cs1.ds.dataGen[33].r.mem[1], bankO.cs1.ds.dataGen[32].r.mem[1]}, {bankO.cs1.ds.dataGen[31].r.mem[1], bankO.cs1.ds.dataGen[30].r.mem[1], bankO.cs1.ds.dataGen[29].r.mem[1], bankO.cs1.ds.dataGen[28].r.mem[1], bankO.cs1.ds.dataGen[27].r.mem[1], bankO.cs1.ds.dataGen[26].r.mem[1], bankO.cs1.ds.dataGen[25].r.mem[1], bankO.cs1.ds.dataGen[24].r.mem[1], bankO.cs1.ds.dataGen[23].r.mem[1], bankO.cs1.ds.dataGen[22].r.mem[1], bankO.cs1.ds.dataGen[21].r.mem[1], bankO.cs1.ds.dataGen[20].r.mem[1], bankO.cs1.ds.dataGen[19].r.mem[1], bankO.cs1.ds.dataGen[18].r.mem[1], bankO.cs1.ds.dataGen[17].r.mem[1], bankO.cs1.ds.dataGen[16].r.mem[1]}, {bankO.cs1.ds.dataGen[15].r.mem[1], bankO.cs1.ds.dataGen[14].r.mem[1], bankO.cs1.ds.dataGen[13].r.mem[1], bankO.cs1.ds.dataGen[12].r.mem[1], bankO.cs1.ds.dataGen[11].r.mem[1], bankO.cs1.ds.dataGen[10].r.mem[1], bankO.cs1.ds.dataGen[9].r.mem[1], bankO.cs1.ds.dataGen[8].r.mem[1], bankO.cs1.ds.dataGen[7].r.mem[1], bankO.cs1.ds.dataGen[6].r.mem[1], bankO.cs1.ds.dataGen[5].r.mem[1], bankO.cs1.ds.dataGen[4].r.mem[1], bankO.cs1.ds.dataGen[3].r.mem[1], bankO.cs1.ds.dataGen[2].r.mem[1], bankO.cs1.ds.dataGen[1].r.mem[1], bankO.cs1.ds.dataGen[0].r.mem[1]});
            $fwrite(file_handle, "0,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[0], bankO.cs1.ds.dataGen[62].r.mem[0], bankO.cs1.ds.dataGen[61].r.mem[0], bankO.cs1.ds.dataGen[60].r.mem[0], bankO.cs1.ds.dataGen[59].r.mem[0], bankO.cs1.ds.dataGen[58].r.mem[0], bankO.cs1.ds.dataGen[57].r.mem[0], bankO.cs1.ds.dataGen[56].r.mem[0], bankO.cs1.ds.dataGen[55].r.mem[0], bankO.cs1.ds.dataGen[54].r.mem[0], bankO.cs1.ds.dataGen[53].r.mem[0], bankO.cs1.ds.dataGen[52].r.mem[0], bankO.cs1.ds.dataGen[51].r.mem[0], bankO.cs1.ds.dataGen[50].r.mem[0], bankO.cs1.ds.dataGen[49].r.mem[0], bankO.cs1.ds.dataGen[48].r.mem[0]}, {bankO.cs1.ds.dataGen[47].r.mem[0], bankO.cs1.ds.dataGen[46].r.mem[0], bankO.cs1.ds.dataGen[45].r.mem[0], bankO.cs1.ds.dataGen[44].r.mem[0], bankO.cs1.ds.dataGen[43].r.mem[0], bankO.cs1.ds.dataGen[42].r.mem[0], bankO.cs1.ds.dataGen[41].r.mem[0], bankO.cs1.ds.dataGen[40].r.mem[0], bankO.cs1.ds.dataGen[39].r.mem[0], bankO.cs1.ds.dataGen[38].r.mem[0], bankO.cs1.ds.dataGen[37].r.mem[0], bankO.cs1.ds.dataGen[36].r.mem[0], bankO.cs1.ds.dataGen[35].r.mem[0], bankO.cs1.ds.dataGen[34].r.mem[0], bankO.cs1.ds.dataGen[33].r.mem[0], bankO.cs1.ds.dataGen[32].r.mem[0]}, {bankO.cs1.ds.dataGen[31].r.mem[0], bankO.cs1.ds.dataGen[30].r.mem[0], bankO.cs1.ds.dataGen[29].r.mem[0], bankO.cs1.ds.dataGen[28].r.mem[0], bankO.cs1.ds.dataGen[27].r.mem[0], bankO.cs1.ds.dataGen[26].r.mem[0], bankO.cs1.ds.dataGen[25].r.mem[0], bankO.cs1.ds.dataGen[24].r.mem[0], bankO.cs1.ds.dataGen[23].r.mem[0], bankO.cs1.ds.dataGen[22].r.mem[0], bankO.cs1.ds.dataGen[21].r.mem[0], bankO.cs1.ds.dataGen[20].r.mem[0], bankO.cs1.ds.dataGen[19].r.mem[0], bankO.cs1.ds.dataGen[18].r.mem[0], bankO.cs1.ds.dataGen[17].r.mem[0], bankO.cs1.ds.dataGen[16].r.mem[0]}, {bankO.cs1.ds.dataGen[15].r.mem[0], bankO.cs1.ds.dataGen[14].r.mem[0], bankO.cs1.ds.dataGen[13].r.mem[0], bankO.cs1.ds.dataGen[12].r.mem[0], bankO.cs1.ds.dataGen[11].r.mem[0], bankO.cs1.ds.dataGen[10].r.mem[0], bankO.cs1.ds.dataGen[9].r.mem[0], bankO.cs1.ds.dataGen[8].r.mem[0], bankO.cs1.ds.dataGen[7].r.mem[0], bankO.cs1.ds.dataGen[6].r.mem[0], bankO.cs1.ds.dataGen[5].r.mem[0], bankO.cs1.ds.dataGen[4].r.mem[0], bankO.cs1.ds.dataGen[3].r.mem[0], bankO.cs1.ds.dataGen[2].r.mem[0], bankO.cs1.ds.dataGen[1].r.mem[0], bankO.cs1.ds.dataGen[0].r.mem[0]});
           
            $fwrite(file_handle, "ODD Meta Store - LRU_PTCID_V_PTC_D\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[15:12],bankO.cs1.ms.LRU2[15:12],bankO.cs1.ms.LRU1[15:12],bankO.cs1.ms.LRU0[15:12],bankO.cs1.ms.PTCID[127:120], bankO.cs1.ms.PTCID[119:112], bankO.cs1.ms.PTCID[111:104], bankO.cs1.ms.PTCID[103:96]   , {bankO.cs1.ms.VALID[15], bankO.cs1.ms.PTC[15], bankO.cs1.ms.DIRTY[15]},       {bankO.cs1.ms.VALID[14], bankO.cs1.ms.PTC[14], bankO.cs1.ms.DIRTY[14]} ,{bankO.cs1.ms.VALID[13], bankO.cs1.ms.PTC[13], bankO.cs1.ms.DIRTY[13]},{bankO.cs1.ms.VALID[12], bankO.cs1.ms.PTC[12], bankO.cs1.ms.DIRTY[12]},       );
            $fwrite(file_handle, "2,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[11:8],bankO.cs1.ms.LRU2[11:8],bankO.cs1.ms.LRU1[11:8],bankO.cs1.ms.LRU0[11:8],bankO.cs1.ms.PTCID[95:88],   bankO.cs1.ms.PTCID[87:80],   bankO.cs1.ms.PTCID[79:72],   bankO.cs1.ms.PTCID[71:64]   ,  {bankO.cs1.ms.VALID[11], bankO.cs1.ms.PTC[11], bankO.cs1.ms.DIRTY[11]},       {bankO.cs1.ms.VALID[10], bankO.cs1.ms.PTC[10], bankO.cs1.ms.DIRTY[10]},       {bankO.cs1.ms.VALID[9], bankO.cs1.ms.PTC[9], bankO.cs1.ms.DIRTY[9]},       {bankO.cs1.ms.VALID[8], bankO.cs1.ms.PTC[8], bankO.cs1.ms.DIRTY[8]}, );
            $fwrite(file_handle, "1,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[7:4],bankO.cs1.ms.LRU2[7:4],bankO.cs1.ms.LRU1[7:4],bankO.cs1.ms.LRU0[7:4],bankO.cs1.ms.PTCID[63:56],   bankO.cs1.ms.PTCID[55:48],   bankO.cs1.ms.PTCID[47:40],   bankO.cs1.ms.PTCID[39:32]   ,  {bankO.cs1.ms.VALID[7], bankO.cs1.ms.PTC[7], bankO.cs1.ms.DIRTY[7]},       {bankO.cs1.ms.VALID[6], bankO.cs1.ms.PTC[6], bankO.cs1.ms.DIRTY[6]},       {bankO.cs1.ms.VALID[5], bankO.cs1.ms.PTC[5], bankO.cs1.ms.DIRTY[5]},       {bankO.cs1.ms.VALID[4], bankO.cs1.ms.PTC[4], bankO.cs1.ms.DIRTY[4]}, );
            $fwrite(file_handle, "0,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[3:0],bankO.cs1.ms.LRU2[3:0],bankO.cs1.ms.LRU1[3:0],bankO.cs1.ms.LRU0[3:0],bankO.cs1.ms.PTCID[31:24],   bankO.cs1.ms.PTCID[23:16],   bankO.cs1.ms.PTCID[15:8],    bankO.cs1.ms.VALID[7:0]   , {bankO.cs1.ms.VALID[3], bankO.cs1.ms.PTC[3], bankO.cs1.ms.DIRTY[3]},       {bankO.cs1.ms.VALID[2], bankO.cs1.ms.PTC[2], bankO.cs1.ms.DIRTY[2]},       {bankO.cs1.ms.VALID[1], bankO.cs1.ms.PTC[1], bankO.cs1.ms.DIRTY[1]},       {bankO.cs1.ms.VALID[0], bankO.cs1.ms.PTC[0], bankO.cs1.ms.DIRTY[0]}, );
            $fwrite(file_handle, "\n/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\nCycle #, clk_ctr_$\n");

             @(posedge clk)
            $fwrite(file_handle, "\n/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\nCycle #,%d\n", clk_ctr_$);
            $fwrite(file_handle, "EVEN TAG STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[3], bankE.cs1.ts.tagGen[2].r.mem[3],bankE.cs1.ts.tagGen[1].r.mem[3],bankE.cs1.ts.tagGen[0].r.mem[3]);
            $fwrite(file_handle, "2,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[2], bankE.cs1.ts.tagGen[2].r.mem[2],bankE.cs1.ts.tagGen[1].r.mem[2],bankE.cs1.ts.tagGen[0].r.mem[2]);
            $fwrite(file_handle, "1,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[1], bankE.cs1.ts.tagGen[2].r.mem[1],bankE.cs1.ts.tagGen[1].r.mem[1],bankE.cs1.ts.tagGen[0].r.mem[1]);
            $fwrite(file_handle, "0,8'h%h,8'h%h,8'h%h,8'h%h\n", bankE.cs1.ts.tagGen[3].r.mem[0], bankE.cs1.ts.tagGen[2].r.mem[0],bankE.cs1.ts.tagGen[1].r.mem[0],bankE.cs1.ts.tagGen[0].r.mem[0]);
           
            $fwrite(file_handle, "EVEN DATA STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[3], bankE.cs1.ds.dataGen[62].r.mem[3], bankE.cs1.ds.dataGen[61].r.mem[3], bankE.cs1.ds.dataGen[60].r.mem[3], bankE.cs1.ds.dataGen[59].r.mem[3], bankE.cs1.ds.dataGen[58].r.mem[3], bankE.cs1.ds.dataGen[57].r.mem[3], bankE.cs1.ds.dataGen[56].r.mem[3], bankE.cs1.ds.dataGen[55].r.mem[3], bankE.cs1.ds.dataGen[54].r.mem[3], bankE.cs1.ds.dataGen[53].r.mem[3], bankE.cs1.ds.dataGen[52].r.mem[3], bankE.cs1.ds.dataGen[51].r.mem[3], bankE.cs1.ds.dataGen[50].r.mem[3], bankE.cs1.ds.dataGen[49].r.mem[3], bankE.cs1.ds.dataGen[48].r.mem[3]}, 
                {bankE.cs1.ds.dataGen[47].r.mem[3], bankE.cs1.ds.dataGen[46].r.mem[3], bankE.cs1.ds.dataGen[45].r.mem[3], bankE.cs1.ds.dataGen[44].r.mem[3], bankE.cs1.ds.dataGen[43].r.mem[3], bankE.cs1.ds.dataGen[42].r.mem[3], bankE.cs1.ds.dataGen[41].r.mem[3], bankE.cs1.ds.dataGen[40].r.mem[3], bankE.cs1.ds.dataGen[39].r.mem[3], bankE.cs1.ds.dataGen[38].r.mem[3], bankE.cs1.ds.dataGen[37].r.mem[3], bankE.cs1.ds.dataGen[36].r.mem[3], bankE.cs1.ds.dataGen[35].r.mem[3], bankE.cs1.ds.dataGen[34].r.mem[3], bankE.cs1.ds.dataGen[33].r.mem[3], bankE.cs1.ds.dataGen[32].r.mem[3]},
                {bankE.cs1.ds.dataGen[31].r.mem[3], bankE.cs1.ds.dataGen[30].r.mem[3], bankE.cs1.ds.dataGen[29].r.mem[3], bankE.cs1.ds.dataGen[28].r.mem[3], bankE.cs1.ds.dataGen[27].r.mem[3], bankE.cs1.ds.dataGen[26].r.mem[3], bankE.cs1.ds.dataGen[25].r.mem[3], bankE.cs1.ds.dataGen[24].r.mem[3], bankE.cs1.ds.dataGen[23].r.mem[3], bankE.cs1.ds.dataGen[22].r.mem[3], bankE.cs1.ds.dataGen[21].r.mem[3], bankE.cs1.ds.dataGen[20].r.mem[3], bankE.cs1.ds.dataGen[19].r.mem[3], bankE.cs1.ds.dataGen[18].r.mem[3], bankE.cs1.ds.dataGen[17].r.mem[3], bankE.cs1.ds.dataGen[16].r.mem[3]}, 
                {bankE.cs1.ds.dataGen[15].r.mem[3], bankE.cs1.ds.dataGen[14].r.mem[3], bankE.cs1.ds.dataGen[13].r.mem[3], bankE.cs1.ds.dataGen[12].r.mem[3], bankE.cs1.ds.dataGen[11].r.mem[3], bankE.cs1.ds.dataGen[10].r.mem[3], bankE.cs1.ds.dataGen[9].r.mem[3], bankE.cs1.ds.dataGen[8].r.mem[3], bankE.cs1.ds.dataGen[7].r.mem[3], bankE.cs1.ds.dataGen[6].r.mem[3], bankE.cs1.ds.dataGen[5].r.mem[3], bankE.cs1.ds.dataGen[4].r.mem[3], bankE.cs1.ds.dataGen[3].r.mem[3], bankE.cs1.ds.dataGen[2].r.mem[3], bankE.cs1.ds.dataGen[1].r.mem[3], bankE.cs1.ds.dataGen[0].r.mem[3]});
            $fwrite(file_handle, "2,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[2], bankE.cs1.ds.dataGen[62].r.mem[2], bankE.cs1.ds.dataGen[61].r.mem[2], bankE.cs1.ds.dataGen[60].r.mem[2], bankE.cs1.ds.dataGen[59].r.mem[2], bankE.cs1.ds.dataGen[58].r.mem[2], bankE.cs1.ds.dataGen[57].r.mem[2], bankE.cs1.ds.dataGen[56].r.mem[2], bankE.cs1.ds.dataGen[55].r.mem[2], bankE.cs1.ds.dataGen[54].r.mem[2], bankE.cs1.ds.dataGen[53].r.mem[2], bankE.cs1.ds.dataGen[52].r.mem[2], bankE.cs1.ds.dataGen[51].r.mem[2], bankE.cs1.ds.dataGen[50].r.mem[2], bankE.cs1.ds.dataGen[49].r.mem[2], bankE.cs1.ds.dataGen[48].r.mem[2]}, {bankE.cs1.ds.dataGen[47].r.mem[2], bankE.cs1.ds.dataGen[46].r.mem[2], bankE.cs1.ds.dataGen[45].r.mem[2], bankE.cs1.ds.dataGen[44].r.mem[2], bankE.cs1.ds.dataGen[43].r.mem[2], bankE.cs1.ds.dataGen[42].r.mem[2], bankE.cs1.ds.dataGen[41].r.mem[2], bankE.cs1.ds.dataGen[40].r.mem[2], bankE.cs1.ds.dataGen[39].r.mem[2], bankE.cs1.ds.dataGen[38].r.mem[2], bankE.cs1.ds.dataGen[37].r.mem[2], bankE.cs1.ds.dataGen[36].r.mem[2], bankE.cs1.ds.dataGen[35].r.mem[2], bankE.cs1.ds.dataGen[34].r.mem[2], bankE.cs1.ds.dataGen[33].r.mem[2], bankE.cs1.ds.dataGen[32].r.mem[2]}, {bankE.cs1.ds.dataGen[31].r.mem[2], bankE.cs1.ds.dataGen[30].r.mem[2], bankE.cs1.ds.dataGen[29].r.mem[2], bankE.cs1.ds.dataGen[28].r.mem[2], bankE.cs1.ds.dataGen[27].r.mem[2], bankE.cs1.ds.dataGen[26].r.mem[2], bankE.cs1.ds.dataGen[25].r.mem[2], bankE.cs1.ds.dataGen[24].r.mem[2], bankE.cs1.ds.dataGen[23].r.mem[2], bankE.cs1.ds.dataGen[22].r.mem[2], bankE.cs1.ds.dataGen[21].r.mem[2], bankE.cs1.ds.dataGen[20].r.mem[2], bankE.cs1.ds.dataGen[19].r.mem[2], bankE.cs1.ds.dataGen[18].r.mem[2], bankE.cs1.ds.dataGen[17].r.mem[2], bankE.cs1.ds.dataGen[16].r.mem[2]}, {bankE.cs1.ds.dataGen[15].r.mem[2], bankE.cs1.ds.dataGen[14].r.mem[2], bankE.cs1.ds.dataGen[13].r.mem[2], bankE.cs1.ds.dataGen[12].r.mem[2], bankE.cs1.ds.dataGen[11].r.mem[2], bankE.cs1.ds.dataGen[10].r.mem[2], bankE.cs1.ds.dataGen[9].r.mem[2], bankE.cs1.ds.dataGen[8].r.mem[2], bankE.cs1.ds.dataGen[7].r.mem[2], bankE.cs1.ds.dataGen[6].r.mem[2], bankE.cs1.ds.dataGen[5].r.mem[2], bankE.cs1.ds.dataGen[4].r.mem[2], bankE.cs1.ds.dataGen[3].r.mem[2], bankE.cs1.ds.dataGen[2].r.mem[2], bankE.cs1.ds.dataGen[1].r.mem[2], bankE.cs1.ds.dataGen[0].r.mem[2]});
            $fwrite(file_handle, "1,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[1], bankE.cs1.ds.dataGen[62].r.mem[1], bankE.cs1.ds.dataGen[61].r.mem[1], bankE.cs1.ds.dataGen[60].r.mem[1], bankE.cs1.ds.dataGen[59].r.mem[1], bankE.cs1.ds.dataGen[58].r.mem[1], bankE.cs1.ds.dataGen[57].r.mem[1], bankE.cs1.ds.dataGen[56].r.mem[1], bankE.cs1.ds.dataGen[55].r.mem[1], bankE.cs1.ds.dataGen[54].r.mem[1], bankE.cs1.ds.dataGen[53].r.mem[1], bankE.cs1.ds.dataGen[52].r.mem[1], bankE.cs1.ds.dataGen[51].r.mem[1], bankE.cs1.ds.dataGen[50].r.mem[1], bankE.cs1.ds.dataGen[49].r.mem[1], bankE.cs1.ds.dataGen[48].r.mem[1]}, {bankE.cs1.ds.dataGen[47].r.mem[1], bankE.cs1.ds.dataGen[46].r.mem[1], bankE.cs1.ds.dataGen[45].r.mem[1], bankE.cs1.ds.dataGen[44].r.mem[1], bankE.cs1.ds.dataGen[43].r.mem[1], bankE.cs1.ds.dataGen[42].r.mem[1], bankE.cs1.ds.dataGen[41].r.mem[1], bankE.cs1.ds.dataGen[40].r.mem[1], bankE.cs1.ds.dataGen[39].r.mem[1], bankE.cs1.ds.dataGen[38].r.mem[1], bankE.cs1.ds.dataGen[37].r.mem[1], bankE.cs1.ds.dataGen[36].r.mem[1], bankE.cs1.ds.dataGen[35].r.mem[1], bankE.cs1.ds.dataGen[34].r.mem[1], bankE.cs1.ds.dataGen[33].r.mem[1], bankE.cs1.ds.dataGen[32].r.mem[1]}, {bankE.cs1.ds.dataGen[31].r.mem[1], bankE.cs1.ds.dataGen[30].r.mem[1], bankE.cs1.ds.dataGen[29].r.mem[1], bankE.cs1.ds.dataGen[28].r.mem[1], bankE.cs1.ds.dataGen[27].r.mem[1], bankE.cs1.ds.dataGen[26].r.mem[1], bankE.cs1.ds.dataGen[25].r.mem[1], bankE.cs1.ds.dataGen[24].r.mem[1], bankE.cs1.ds.dataGen[23].r.mem[1], bankE.cs1.ds.dataGen[22].r.mem[1], bankE.cs1.ds.dataGen[21].r.mem[1], bankE.cs1.ds.dataGen[20].r.mem[1], bankE.cs1.ds.dataGen[19].r.mem[1], bankE.cs1.ds.dataGen[18].r.mem[1], bankE.cs1.ds.dataGen[17].r.mem[1], bankE.cs1.ds.dataGen[16].r.mem[1]}, {bankE.cs1.ds.dataGen[15].r.mem[1], bankE.cs1.ds.dataGen[14].r.mem[1], bankE.cs1.ds.dataGen[13].r.mem[1], bankE.cs1.ds.dataGen[12].r.mem[1], bankE.cs1.ds.dataGen[11].r.mem[1], bankE.cs1.ds.dataGen[10].r.mem[1], bankE.cs1.ds.dataGen[9].r.mem[1], bankE.cs1.ds.dataGen[8].r.mem[1], bankE.cs1.ds.dataGen[7].r.mem[1], bankE.cs1.ds.dataGen[6].r.mem[1], bankE.cs1.ds.dataGen[5].r.mem[1], bankE.cs1.ds.dataGen[4].r.mem[1], bankE.cs1.ds.dataGen[3].r.mem[1], bankE.cs1.ds.dataGen[2].r.mem[1], bankE.cs1.ds.dataGen[1].r.mem[1], bankE.cs1.ds.dataGen[0].r.mem[1]});
            $fwrite(file_handle, "0,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankE.cs1.ds.dataGen[63].r.mem[0], bankE.cs1.ds.dataGen[62].r.mem[0], bankE.cs1.ds.dataGen[61].r.mem[0], bankE.cs1.ds.dataGen[60].r.mem[0], bankE.cs1.ds.dataGen[59].r.mem[0], bankE.cs1.ds.dataGen[58].r.mem[0], bankE.cs1.ds.dataGen[57].r.mem[0], bankE.cs1.ds.dataGen[56].r.mem[0], bankE.cs1.ds.dataGen[55].r.mem[0], bankE.cs1.ds.dataGen[54].r.mem[0], bankE.cs1.ds.dataGen[53].r.mem[0], bankE.cs1.ds.dataGen[52].r.mem[0], bankE.cs1.ds.dataGen[51].r.mem[0], bankE.cs1.ds.dataGen[50].r.mem[0], bankE.cs1.ds.dataGen[49].r.mem[0], bankE.cs1.ds.dataGen[48].r.mem[0]}, {bankE.cs1.ds.dataGen[47].r.mem[0], bankE.cs1.ds.dataGen[46].r.mem[0], bankE.cs1.ds.dataGen[45].r.mem[0], bankE.cs1.ds.dataGen[44].r.mem[0], bankE.cs1.ds.dataGen[43].r.mem[0], bankE.cs1.ds.dataGen[42].r.mem[0], bankE.cs1.ds.dataGen[41].r.mem[0], bankE.cs1.ds.dataGen[40].r.mem[0], bankE.cs1.ds.dataGen[39].r.mem[0], bankE.cs1.ds.dataGen[38].r.mem[0], bankE.cs1.ds.dataGen[37].r.mem[0], bankE.cs1.ds.dataGen[36].r.mem[0], bankE.cs1.ds.dataGen[35].r.mem[0], bankE.cs1.ds.dataGen[34].r.mem[0], bankE.cs1.ds.dataGen[33].r.mem[0], bankE.cs1.ds.dataGen[32].r.mem[0]}, {bankE.cs1.ds.dataGen[31].r.mem[0], bankE.cs1.ds.dataGen[30].r.mem[0], bankE.cs1.ds.dataGen[29].r.mem[0], bankE.cs1.ds.dataGen[28].r.mem[0], bankE.cs1.ds.dataGen[27].r.mem[0], bankE.cs1.ds.dataGen[26].r.mem[0], bankE.cs1.ds.dataGen[25].r.mem[0], bankE.cs1.ds.dataGen[24].r.mem[0], bankE.cs1.ds.dataGen[23].r.mem[0], bankE.cs1.ds.dataGen[22].r.mem[0], bankE.cs1.ds.dataGen[21].r.mem[0], bankE.cs1.ds.dataGen[20].r.mem[0], bankE.cs1.ds.dataGen[19].r.mem[0], bankE.cs1.ds.dataGen[18].r.mem[0], bankE.cs1.ds.dataGen[17].r.mem[0], bankE.cs1.ds.dataGen[16].r.mem[0]}, {bankE.cs1.ds.dataGen[15].r.mem[0], bankE.cs1.ds.dataGen[14].r.mem[0], bankE.cs1.ds.dataGen[13].r.mem[0], bankE.cs1.ds.dataGen[12].r.mem[0], bankE.cs1.ds.dataGen[11].r.mem[0], bankE.cs1.ds.dataGen[10].r.mem[0], bankE.cs1.ds.dataGen[9].r.mem[0], bankE.cs1.ds.dataGen[8].r.mem[0], bankE.cs1.ds.dataGen[7].r.mem[0], bankE.cs1.ds.dataGen[6].r.mem[0], bankE.cs1.ds.dataGen[5].r.mem[0], bankE.cs1.ds.dataGen[4].r.mem[0], bankE.cs1.ds.dataGen[3].r.mem[0], bankE.cs1.ds.dataGen[2].r.mem[0], bankE.cs1.ds.dataGen[1].r.mem[0], bankE.cs1.ds.dataGen[0].r.mem[0]});

            $fwrite(file_handle, "EVEN Meta Store - LRU_PTCID_V_PTC_D\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[15:12],bankE.cs1.ms.LRU2[15:12],bankE.cs1.ms.LRU1[15:12],bankE.cs1.ms.LRU0[15:12],bankE.cs1.ms.PTCID[127:120], bankE.cs1.ms.PTCID[119:112], bankE.cs1.ms.PTCID[111:104], bankE.cs1.ms.PTCID[103:96]   , {bankE.cs1.ms.VALID[15], bankE.cs1.ms.PTC[15], bankE.cs1.ms.DIRTY[15]},       {bankE.cs1.ms.VALID[14], bankE.cs1.ms.PTC[14], bankE.cs1.ms.DIRTY[14]} ,{bankE.cs1.ms.VALID[13], bankE.cs1.ms.PTC[13], bankE.cs1.ms.DIRTY[13]},{bankE.cs1.ms.VALID[12], bankE.cs1.ms.PTC[12], bankE.cs1.ms.DIRTY[12]},       );
            $fwrite(file_handle, "2,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[11:8],bankE.cs1.ms.LRU2[11:8],bankE.cs1.ms.LRU1[11:8],bankE.cs1.ms.LRU0[11:8],bankE.cs1.ms.PTCID[95:88],   bankE.cs1.ms.PTCID[87:80],   bankE.cs1.ms.PTCID[79:72],   bankE.cs1.ms.PTCID[71:64]   ,  {bankE.cs1.ms.VALID[11], bankE.cs1.ms.PTC[11], bankE.cs1.ms.DIRTY[11]},       {bankE.cs1.ms.VALID[10], bankE.cs1.ms.PTC[10], bankE.cs1.ms.DIRTY[10]},       {bankE.cs1.ms.VALID[9], bankE.cs1.ms.PTC[9], bankE.cs1.ms.DIRTY[9]},       {bankE.cs1.ms.VALID[8], bankE.cs1.ms.PTC[8], bankE.cs1.ms.DIRTY[8]}, );
            $fwrite(file_handle, "1,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[7:4],bankE.cs1.ms.LRU2[7:4],bankE.cs1.ms.LRU1[7:4],bankE.cs1.ms.LRU0[7:4],bankE.cs1.ms.PTCID[63:56],   bankE.cs1.ms.PTCID[55:48],   bankE.cs1.ms.PTCID[47:40],   bankE.cs1.ms.PTCID[39:32]   ,  {bankE.cs1.ms.VALID[7], bankE.cs1.ms.PTC[7], bankE.cs1.ms.DIRTY[7]},       {bankE.cs1.ms.VALID[6], bankE.cs1.ms.PTC[6], bankE.cs1.ms.DIRTY[6]},       {bankE.cs1.ms.VALID[5], bankE.cs1.ms.PTC[5], bankE.cs1.ms.DIRTY[5]},       {bankE.cs1.ms.VALID[4], bankE.cs1.ms.PTC[4], bankE.cs1.ms.DIRTY[4]}, );
            $fwrite(file_handle, "0,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankE.cs1.ms.LRU3[3:0],bankE.cs1.ms.LRU2[3:0],bankE.cs1.ms.LRU1[3:0],bankE.cs1.ms.LRU0[3:0],bankE.cs1.ms.PTCID[31:24],   bankE.cs1.ms.PTCID[23:16],   bankE.cs1.ms.PTCID[15:8],    bankE.cs1.ms.VALID[7:0]   , {bankE.cs1.ms.VALID[3], bankE.cs1.ms.PTC[3], bankE.cs1.ms.DIRTY[3]},       {bankE.cs1.ms.VALID[2], bankE.cs1.ms.PTC[2], bankE.cs1.ms.DIRTY[2]},       {bankE.cs1.ms.VALID[1], bankE.cs1.ms.PTC[1], bankE.cs1.ms.DIRTY[1]},       {bankE.cs1.ms.VALID[0], bankE.cs1.ms.PTC[0], bankE.cs1.ms.DIRTY[0]}, );

            $fwrite(file_handle, "ODD TAG STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[3], bankO.cs1.ts.tagGen[2].r.mem[3],bankO.cs1.ts.tagGen[1].r.mem[3],bankO.cs1.ts.tagGen[0].r.mem[3]);
            $fwrite(file_handle, "2,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[2], bankO.cs1.ts.tagGen[2].r.mem[2],bankO.cs1.ts.tagGen[1].r.mem[2],bankO.cs1.ts.tagGen[0].r.mem[2]);
            $fwrite(file_handle, "1,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[1], bankO.cs1.ts.tagGen[2].r.mem[1],bankO.cs1.ts.tagGen[1].r.mem[1],bankO.cs1.ts.tagGen[0].r.mem[1]);
            $fwrite(file_handle, "0,8'h%h,8'h%h,8'h%h,8'h%h\n", bankO.cs1.ts.tagGen[3].r.mem[0], bankO.cs1.ts.tagGen[2].r.mem[0],bankO.cs1.ts.tagGen[1].r.mem[0],bankO.cs1.ts.tagGen[0].r.mem[0]);
           
            $fwrite(file_handle, "ODD DATA STORE\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[3], bankO.cs1.ds.dataGen[62].r.mem[3], bankO.cs1.ds.dataGen[61].r.mem[3], bankO.cs1.ds.dataGen[60].r.mem[3], bankO.cs1.ds.dataGen[59].r.mem[3], bankO.cs1.ds.dataGen[58].r.mem[3], bankO.cs1.ds.dataGen[57].r.mem[3], bankO.cs1.ds.dataGen[56].r.mem[3], bankO.cs1.ds.dataGen[55].r.mem[3], bankO.cs1.ds.dataGen[54].r.mem[3], bankO.cs1.ds.dataGen[53].r.mem[3], bankO.cs1.ds.dataGen[52].r.mem[3], bankO.cs1.ds.dataGen[51].r.mem[3], bankO.cs1.ds.dataGen[50].r.mem[3], bankO.cs1.ds.dataGen[49].r.mem[3], bankO.cs1.ds.dataGen[48].r.mem[3]}, 
                {bankO.cs1.ds.dataGen[47].r.mem[3], bankO.cs1.ds.dataGen[46].r.mem[3], bankO.cs1.ds.dataGen[45].r.mem[3], bankO.cs1.ds.dataGen[44].r.mem[3], bankO.cs1.ds.dataGen[43].r.mem[3], bankO.cs1.ds.dataGen[42].r.mem[3], bankO.cs1.ds.dataGen[41].r.mem[3], bankO.cs1.ds.dataGen[40].r.mem[3], bankO.cs1.ds.dataGen[39].r.mem[3], bankO.cs1.ds.dataGen[38].r.mem[3], bankO.cs1.ds.dataGen[37].r.mem[3], bankO.cs1.ds.dataGen[36].r.mem[3], bankO.cs1.ds.dataGen[35].r.mem[3], bankO.cs1.ds.dataGen[34].r.mem[3], bankO.cs1.ds.dataGen[33].r.mem[3], bankO.cs1.ds.dataGen[32].r.mem[3]},
                {bankO.cs1.ds.dataGen[31].r.mem[3], bankO.cs1.ds.dataGen[30].r.mem[3], bankO.cs1.ds.dataGen[29].r.mem[3], bankO.cs1.ds.dataGen[28].r.mem[3], bankO.cs1.ds.dataGen[27].r.mem[3], bankO.cs1.ds.dataGen[26].r.mem[3], bankO.cs1.ds.dataGen[25].r.mem[3], bankO.cs1.ds.dataGen[24].r.mem[3], bankO.cs1.ds.dataGen[23].r.mem[3], bankO.cs1.ds.dataGen[22].r.mem[3], bankO.cs1.ds.dataGen[21].r.mem[3], bankO.cs1.ds.dataGen[20].r.mem[3], bankO.cs1.ds.dataGen[19].r.mem[3], bankO.cs1.ds.dataGen[18].r.mem[3], bankO.cs1.ds.dataGen[17].r.mem[3], bankO.cs1.ds.dataGen[16].r.mem[3]}, 
                {bankO.cs1.ds.dataGen[15].r.mem[3], bankO.cs1.ds.dataGen[14].r.mem[3], bankO.cs1.ds.dataGen[13].r.mem[3], bankO.cs1.ds.dataGen[12].r.mem[3], bankO.cs1.ds.dataGen[11].r.mem[3], bankO.cs1.ds.dataGen[10].r.mem[3], bankO.cs1.ds.dataGen[9].r.mem[3], bankO.cs1.ds.dataGen[8].r.mem[3], bankO.cs1.ds.dataGen[7].r.mem[3], bankO.cs1.ds.dataGen[6].r.mem[3], bankO.cs1.ds.dataGen[5].r.mem[3], bankO.cs1.ds.dataGen[4].r.mem[3], bankO.cs1.ds.dataGen[3].r.mem[3], bankO.cs1.ds.dataGen[2].r.mem[3], bankO.cs1.ds.dataGen[1].r.mem[3], bankO.cs1.ds.dataGen[0].r.mem[3]});
            $fwrite(file_handle, "2,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[2], bankO.cs1.ds.dataGen[62].r.mem[2], bankO.cs1.ds.dataGen[61].r.mem[2], bankO.cs1.ds.dataGen[60].r.mem[2], bankO.cs1.ds.dataGen[59].r.mem[2], bankO.cs1.ds.dataGen[58].r.mem[2], bankO.cs1.ds.dataGen[57].r.mem[2], bankO.cs1.ds.dataGen[56].r.mem[2], bankO.cs1.ds.dataGen[55].r.mem[2], bankO.cs1.ds.dataGen[54].r.mem[2], bankO.cs1.ds.dataGen[53].r.mem[2], bankO.cs1.ds.dataGen[52].r.mem[2], bankO.cs1.ds.dataGen[51].r.mem[2], bankO.cs1.ds.dataGen[50].r.mem[2], bankO.cs1.ds.dataGen[49].r.mem[2], bankO.cs1.ds.dataGen[48].r.mem[2]}, {bankO.cs1.ds.dataGen[47].r.mem[2], bankO.cs1.ds.dataGen[46].r.mem[2], bankO.cs1.ds.dataGen[45].r.mem[2], bankO.cs1.ds.dataGen[44].r.mem[2], bankO.cs1.ds.dataGen[43].r.mem[2], bankO.cs1.ds.dataGen[42].r.mem[2], bankO.cs1.ds.dataGen[41].r.mem[2], bankO.cs1.ds.dataGen[40].r.mem[2], bankO.cs1.ds.dataGen[39].r.mem[2], bankO.cs1.ds.dataGen[38].r.mem[2], bankO.cs1.ds.dataGen[37].r.mem[2], bankO.cs1.ds.dataGen[36].r.mem[2], bankO.cs1.ds.dataGen[35].r.mem[2], bankO.cs1.ds.dataGen[34].r.mem[2], bankO.cs1.ds.dataGen[33].r.mem[2], bankO.cs1.ds.dataGen[32].r.mem[2]}, {bankO.cs1.ds.dataGen[31].r.mem[2], bankO.cs1.ds.dataGen[30].r.mem[2], bankO.cs1.ds.dataGen[29].r.mem[2], bankO.cs1.ds.dataGen[28].r.mem[2], bankO.cs1.ds.dataGen[27].r.mem[2], bankO.cs1.ds.dataGen[26].r.mem[2], bankO.cs1.ds.dataGen[25].r.mem[2], bankO.cs1.ds.dataGen[24].r.mem[2], bankO.cs1.ds.dataGen[23].r.mem[2], bankO.cs1.ds.dataGen[22].r.mem[2], bankO.cs1.ds.dataGen[21].r.mem[2], bankO.cs1.ds.dataGen[20].r.mem[2], bankO.cs1.ds.dataGen[19].r.mem[2], bankO.cs1.ds.dataGen[18].r.mem[2], bankO.cs1.ds.dataGen[17].r.mem[2], bankO.cs1.ds.dataGen[16].r.mem[2]}, {bankO.cs1.ds.dataGen[15].r.mem[2], bankO.cs1.ds.dataGen[14].r.mem[2], bankO.cs1.ds.dataGen[13].r.mem[2], bankO.cs1.ds.dataGen[12].r.mem[2], bankO.cs1.ds.dataGen[11].r.mem[2], bankO.cs1.ds.dataGen[10].r.mem[2], bankO.cs1.ds.dataGen[9].r.mem[2], bankO.cs1.ds.dataGen[8].r.mem[2], bankO.cs1.ds.dataGen[7].r.mem[2], bankO.cs1.ds.dataGen[6].r.mem[2], bankO.cs1.ds.dataGen[5].r.mem[2], bankO.cs1.ds.dataGen[4].r.mem[2], bankO.cs1.ds.dataGen[3].r.mem[2], bankO.cs1.ds.dataGen[2].r.mem[2], bankO.cs1.ds.dataGen[1].r.mem[2], bankO.cs1.ds.dataGen[0].r.mem[2]});
            $fwrite(file_handle, "1,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[1], bankO.cs1.ds.dataGen[62].r.mem[1], bankO.cs1.ds.dataGen[61].r.mem[1], bankO.cs1.ds.dataGen[60].r.mem[1], bankO.cs1.ds.dataGen[59].r.mem[1], bankO.cs1.ds.dataGen[58].r.mem[1], bankO.cs1.ds.dataGen[57].r.mem[1], bankO.cs1.ds.dataGen[56].r.mem[1], bankO.cs1.ds.dataGen[55].r.mem[1], bankO.cs1.ds.dataGen[54].r.mem[1], bankO.cs1.ds.dataGen[53].r.mem[1], bankO.cs1.ds.dataGen[52].r.mem[1], bankO.cs1.ds.dataGen[51].r.mem[1], bankO.cs1.ds.dataGen[50].r.mem[1], bankO.cs1.ds.dataGen[49].r.mem[1], bankO.cs1.ds.dataGen[48].r.mem[1]}, {bankO.cs1.ds.dataGen[47].r.mem[1], bankO.cs1.ds.dataGen[46].r.mem[1], bankO.cs1.ds.dataGen[45].r.mem[1], bankO.cs1.ds.dataGen[44].r.mem[1], bankO.cs1.ds.dataGen[43].r.mem[1], bankO.cs1.ds.dataGen[42].r.mem[1], bankO.cs1.ds.dataGen[41].r.mem[1], bankO.cs1.ds.dataGen[40].r.mem[1], bankO.cs1.ds.dataGen[39].r.mem[1], bankO.cs1.ds.dataGen[38].r.mem[1], bankO.cs1.ds.dataGen[37].r.mem[1], bankO.cs1.ds.dataGen[36].r.mem[1], bankO.cs1.ds.dataGen[35].r.mem[1], bankO.cs1.ds.dataGen[34].r.mem[1], bankO.cs1.ds.dataGen[33].r.mem[1], bankO.cs1.ds.dataGen[32].r.mem[1]}, {bankO.cs1.ds.dataGen[31].r.mem[1], bankO.cs1.ds.dataGen[30].r.mem[1], bankO.cs1.ds.dataGen[29].r.mem[1], bankO.cs1.ds.dataGen[28].r.mem[1], bankO.cs1.ds.dataGen[27].r.mem[1], bankO.cs1.ds.dataGen[26].r.mem[1], bankO.cs1.ds.dataGen[25].r.mem[1], bankO.cs1.ds.dataGen[24].r.mem[1], bankO.cs1.ds.dataGen[23].r.mem[1], bankO.cs1.ds.dataGen[22].r.mem[1], bankO.cs1.ds.dataGen[21].r.mem[1], bankO.cs1.ds.dataGen[20].r.mem[1], bankO.cs1.ds.dataGen[19].r.mem[1], bankO.cs1.ds.dataGen[18].r.mem[1], bankO.cs1.ds.dataGen[17].r.mem[1], bankO.cs1.ds.dataGen[16].r.mem[1]}, {bankO.cs1.ds.dataGen[15].r.mem[1], bankO.cs1.ds.dataGen[14].r.mem[1], bankO.cs1.ds.dataGen[13].r.mem[1], bankO.cs1.ds.dataGen[12].r.mem[1], bankO.cs1.ds.dataGen[11].r.mem[1], bankO.cs1.ds.dataGen[10].r.mem[1], bankO.cs1.ds.dataGen[9].r.mem[1], bankO.cs1.ds.dataGen[8].r.mem[1], bankO.cs1.ds.dataGen[7].r.mem[1], bankO.cs1.ds.dataGen[6].r.mem[1], bankO.cs1.ds.dataGen[5].r.mem[1], bankO.cs1.ds.dataGen[4].r.mem[1], bankO.cs1.ds.dataGen[3].r.mem[1], bankO.cs1.ds.dataGen[2].r.mem[1], bankO.cs1.ds.dataGen[1].r.mem[1], bankO.cs1.ds.dataGen[0].r.mem[1]});
            $fwrite(file_handle, "0,128'h%h,128'h%h,128'h%h,128'h%h\n", {bankO.cs1.ds.dataGen[63].r.mem[0], bankO.cs1.ds.dataGen[62].r.mem[0], bankO.cs1.ds.dataGen[61].r.mem[0], bankO.cs1.ds.dataGen[60].r.mem[0], bankO.cs1.ds.dataGen[59].r.mem[0], bankO.cs1.ds.dataGen[58].r.mem[0], bankO.cs1.ds.dataGen[57].r.mem[0], bankO.cs1.ds.dataGen[56].r.mem[0], bankO.cs1.ds.dataGen[55].r.mem[0], bankO.cs1.ds.dataGen[54].r.mem[0], bankO.cs1.ds.dataGen[53].r.mem[0], bankO.cs1.ds.dataGen[52].r.mem[0], bankO.cs1.ds.dataGen[51].r.mem[0], bankO.cs1.ds.dataGen[50].r.mem[0], bankO.cs1.ds.dataGen[49].r.mem[0], bankO.cs1.ds.dataGen[48].r.mem[0]}, {bankO.cs1.ds.dataGen[47].r.mem[0], bankO.cs1.ds.dataGen[46].r.mem[0], bankO.cs1.ds.dataGen[45].r.mem[0], bankO.cs1.ds.dataGen[44].r.mem[0], bankO.cs1.ds.dataGen[43].r.mem[0], bankO.cs1.ds.dataGen[42].r.mem[0], bankO.cs1.ds.dataGen[41].r.mem[0], bankO.cs1.ds.dataGen[40].r.mem[0], bankO.cs1.ds.dataGen[39].r.mem[0], bankO.cs1.ds.dataGen[38].r.mem[0], bankO.cs1.ds.dataGen[37].r.mem[0], bankO.cs1.ds.dataGen[36].r.mem[0], bankO.cs1.ds.dataGen[35].r.mem[0], bankO.cs1.ds.dataGen[34].r.mem[0], bankO.cs1.ds.dataGen[33].r.mem[0], bankO.cs1.ds.dataGen[32].r.mem[0]}, {bankO.cs1.ds.dataGen[31].r.mem[0], bankO.cs1.ds.dataGen[30].r.mem[0], bankO.cs1.ds.dataGen[29].r.mem[0], bankO.cs1.ds.dataGen[28].r.mem[0], bankO.cs1.ds.dataGen[27].r.mem[0], bankO.cs1.ds.dataGen[26].r.mem[0], bankO.cs1.ds.dataGen[25].r.mem[0], bankO.cs1.ds.dataGen[24].r.mem[0], bankO.cs1.ds.dataGen[23].r.mem[0], bankO.cs1.ds.dataGen[22].r.mem[0], bankO.cs1.ds.dataGen[21].r.mem[0], bankO.cs1.ds.dataGen[20].r.mem[0], bankO.cs1.ds.dataGen[19].r.mem[0], bankO.cs1.ds.dataGen[18].r.mem[0], bankO.cs1.ds.dataGen[17].r.mem[0], bankO.cs1.ds.dataGen[16].r.mem[0]}, {bankO.cs1.ds.dataGen[15].r.mem[0], bankO.cs1.ds.dataGen[14].r.mem[0], bankO.cs1.ds.dataGen[13].r.mem[0], bankO.cs1.ds.dataGen[12].r.mem[0], bankO.cs1.ds.dataGen[11].r.mem[0], bankO.cs1.ds.dataGen[10].r.mem[0], bankO.cs1.ds.dataGen[9].r.mem[0], bankO.cs1.ds.dataGen[8].r.mem[0], bankO.cs1.ds.dataGen[7].r.mem[0], bankO.cs1.ds.dataGen[6].r.mem[0], bankO.cs1.ds.dataGen[5].r.mem[0], bankO.cs1.ds.dataGen[4].r.mem[0], bankO.cs1.ds.dataGen[3].r.mem[0], bankO.cs1.ds.dataGen[2].r.mem[0], bankO.cs1.ds.dataGen[1].r.mem[0], bankO.cs1.ds.dataGen[0].r.mem[0]});
           
            $fwrite(file_handle, "ODD Meta Store - LRU_PTCID_V_PTC_D\n");
            $fwrite(file_handle, "Index,Way3,Way2,Way1,Way0\n");
            $fwrite(file_handle, "3,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[15:12],bankO.cs1.ms.LRU2[15:12],bankO.cs1.ms.LRU1[15:12],bankO.cs1.ms.LRU0[15:12],bankO.cs1.ms.PTCID[127:120], bankO.cs1.ms.PTCID[119:112], bankO.cs1.ms.PTCID[111:104], bankO.cs1.ms.PTCID[103:96]   , {bankO.cs1.ms.VALID[15], bankO.cs1.ms.PTC[15], bankO.cs1.ms.DIRTY[15]},       {bankO.cs1.ms.VALID[14], bankO.cs1.ms.PTC[14], bankO.cs1.ms.DIRTY[14]} ,{bankO.cs1.ms.VALID[13], bankO.cs1.ms.PTC[13], bankO.cs1.ms.DIRTY[13]},{bankO.cs1.ms.VALID[12], bankO.cs1.ms.PTC[12], bankO.cs1.ms.DIRTY[12]},       );
            $fwrite(file_handle, "2,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[11:8],bankO.cs1.ms.LRU2[11:8],bankO.cs1.ms.LRU1[11:8],bankO.cs1.ms.LRU0[11:8],bankO.cs1.ms.PTCID[95:88],   bankO.cs1.ms.PTCID[87:80],   bankO.cs1.ms.PTCID[79:72],   bankO.cs1.ms.PTCID[71:64]   ,  {bankO.cs1.ms.VALID[11], bankO.cs1.ms.PTC[11], bankO.cs1.ms.DIRTY[11]},       {bankO.cs1.ms.VALID[10], bankO.cs1.ms.PTC[10], bankO.cs1.ms.DIRTY[10]},       {bankO.cs1.ms.VALID[9], bankO.cs1.ms.PTC[9], bankO.cs1.ms.DIRTY[9]},       {bankO.cs1.ms.VALID[8], bankO.cs1.ms.PTC[8], bankO.cs1.ms.DIRTY[8]}, );
            $fwrite(file_handle, "1,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[7:4],bankO.cs1.ms.LRU2[7:4],bankO.cs1.ms.LRU1[7:4],bankO.cs1.ms.LRU0[7:4],bankO.cs1.ms.PTCID[63:56],   bankO.cs1.ms.PTCID[55:48],   bankO.cs1.ms.PTCID[47:40],   bankO.cs1.ms.PTCID[39:32]   ,  {bankO.cs1.ms.VALID[7], bankO.cs1.ms.PTC[7], bankO.cs1.ms.DIRTY[7]},       {bankO.cs1.ms.VALID[6], bankO.cs1.ms.PTC[6], bankO.cs1.ms.DIRTY[6]},       {bankO.cs1.ms.VALID[5], bankO.cs1.ms.PTC[5], bankO.cs1.ms.DIRTY[5]},       {bankO.cs1.ms.VALID[4], bankO.cs1.ms.PTC[4], bankO.cs1.ms.DIRTY[4]}, );
            $fwrite(file_handle, "0,4'h%h,4'h%h,4'h%h,4'h%h,,8'h%h,8'h%h,8'h%h,8'h%h,,3'h%h,3'h%h,3'h%h,3'h%h\n",bankO.cs1.ms.LRU3[3:0],bankO.cs1.ms.LRU2[3:0],bankO.cs1.ms.LRU1[3:0],bankO.cs1.ms.LRU0[3:0],bankO.cs1.ms.PTCID[31:24],   bankO.cs1.ms.PTCID[23:16],   bankO.cs1.ms.PTCID[15:8],    bankO.cs1.ms.VALID[7:0]   , {bankO.cs1.ms.VALID[3], bankO.cs1.ms.PTC[3], bankO.cs1.ms.DIRTY[3]},       {bankO.cs1.ms.VALID[2], bankO.cs1.ms.PTC[2], bankO.cs1.ms.DIRTY[2]},       {bankO.cs1.ms.VALID[1], bankO.cs1.ms.PTC[1], bankO.cs1.ms.DIRTY[1]},       {bankO.cs1.ms.VALID[0], bankO.cs1.ms.PTC[0], bankO.cs1.ms.DIRTY[0]}, );
            $fwrite(file_handle, "\n/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\nCycle #, clk_ctr_$\n");
        end

end
endmodule

// module pulseFilter #(time) (inp, filtered);
//     delay #(3) d1(inp, inp_del);
//     xnor2$ x1(filtered, inp, inp_del);
// endmodule

/*

.read(bus_valid_e),
    .clk_bus(clk_bus),
    .clk_core(),
    .rst(rst),
    .set(set),
    .full(bus_valid_e_nobuf),
    .pAdr(bus_pAddress_e),
    .data(bus_data_e),
    .return(returnLoc_e),
    .dest(),
    .rw(1'b1),
    .size(),
    .BUS(BUS),
    .setReciever(recvDE),
    .free_bau(freeDE)

*/