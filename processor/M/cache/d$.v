module d$(
    //GLOBAL
    input clk,
    input rst,
    input set,

    
    input[31:0] M1, M2, WB1,
    input[1:0] M1_RW, M2_RW,
    input valid_RSW,
    input sizeOVR,
    input PTC_ID_in,

    input[16*8-1:0] wb_data,
    input[31:0] wb_adr,
    input[1:0] wb_size,


);



rdIA rdIA (
    .address_in(address_in_r),
    .data_in(data_in_r),
    .size_in(size_in_r),
    .r(r_r),
    .w(w_r),
    .sw(sw_r),
    .valid_in(valid_in_r),
    .fromBUS(fromBUS_r),
    .sizeOVR(sizeOVR_r),
    
    .PTC_ID_in(PTC_ID_in_r),
    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .PTC_out(PTC_out_r),
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

rdIA rdSW (
    .address_in(address_in_sw),
    .data_in(data_in_sw),
    .size_in(size_in_sw),
    .r(r_sw),
    .w(w_sw),
    .sw(sw_sw),
    .valid_in(valid_in_sw),
    .fromBUS(fromBUS_sw),
    .sizeOVR(sizeOVR_sw),
    .PTC_ID_in(PTC_ID_in_sw),

    .clk(clk),
    .VP(VP),
    .PF(PF),
    .entry_V(entry_V),
    .entry_P(entry_P),
    .entry_RW(entry_RW),
    .entry_PCD(entry_PCD),

    .PTC_out(PTC_out_sw),
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

rdIA rdWB (
    .address_in(address_in_wb),
    .data_in(data_in_wb),
    .size_in(size_in_wb),
    .r(r_wb),
    .w(w_wb),
    .sw(sw_wb),
    .valid_in(valid_in_wb),
    .fromBUS(fromBUS_wb),
    .sizeOVR(sizeOVR_wb),
    .PTC_ID_in(PTC_ID_in_wb),
    .clk(clk_wb),
    .VP(VP_wb),
    .PF(PF_wb),
    .entry_V(entry_V_wb),
    .entry_P(entry_P_wb),
    .entry_RW(entry_RW_wb),
    .entry_PCD(entry_PCD_wb),

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


cacheaqsys cacheaqsys_inst (
    .rd_pAddress_e (addressE_r),
    .rd_pAddress_o (addressO_r),
    .sw_pAddress_e (addressE_sw),
    .sw_pAddress_o (addressO_sw),
    .wb_pAddress_e (addressE_wb),
    .wb_pAddress_o (addressO_wb),

////////////////////////
    .bus_pAddress_e(DES_pAdr_e),
    .bus_pAddress_o(DES_pAdr_o),
/////////////////////////////////
    .wb_data_e(dataE_wb),
    .wb_data_o(dataO_wb),
/////////////////////////
    .bus_data_e(DES_data_e),
    .bus_data_o(DES_data_o),
 ///////////////////////////////////////   
    .rd_size_e(sizeE_r),
    .rd_size_o(sizeO_r),
    .sw_size_e(sizeE_sw),
    .sw_size_o(sizeO_sw),
    .wb_size_e(sizeE_wb),
    .wb_size_o(sizeO_wb),
    .rd_valid_e(validE_r),
    .rd_valid_o(validO_r),
    .sw_valid_e(validE_sw),
    .sw_valid_o(validO_sw),
    .wb_valid_e(validE_wb),
    .wb_valid_o(validO_wb),

    .bus_valid_e(bus_valid_e),
    .bus_valid_o(bus_valid_o),

    .wb_mask_e(maskE_wb),
    .wb_mask_o(maskO_wb),

    .rd_ptcid(PCD_out_r),
    .sw_ptcid(PCD_out_sw),
    .wb_ptcid(PCD_out_wb),
    .rd_odd_is_greater(oddIsGreater_r),
    .sw_odd_is_greater(oddIsGreater_sw),
    .wb_odd_is_greater(oddIsGreater_wb),
    .rd_needP1(needP1_r),
    .sw_needP1(needP1_sw),
    .wb_needP1(needP1_wb),

    .rd_onesize(onesize_out_r),
    .sw_onesize(onesize_out_sw),
    .wb_onesize(onesize_out_wb),

    .rd_pcd(PCD_out_r),
    .sw_pcd(PCD_out_sw),
    .wb_pcd(PCD_out_wb),

//////////////////////////////////
    .bus_pcd(),
    .bus_isempty(),
////////////////////////////////

    .read(read),
    .rd_write(rd_write),
    .sw_write(sw_write),
    .wb_write(wb_write),

    .clk(clk),
    .clr(rst),
    
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
    
    .aq_isempty(aq_isempty),
    .rdaq_isfull(rdaq_isfull),
    .swaq_isfull(swaq_isfull),
    .wbaq_isfull(wbaq_isfull)
);

cacheBank bankE (
    .clk(clk),
    .rst(rst),
    .set(set),
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
//////////////////////
    .needP1_in(needP1_in),
//////////////////////
    .oneSize(onesize_$),

    .MSHR_HIT(MSHR_HIT),
    .MSHR_FULL(MSHR_FULL),
    .SER1_FULL(SER1_FULL),
    .SER0_FULL(SER0_FULL),

    .PCD_IN(pcd_$),

    .AQ_READ(read),

    .MSHR_valid(MSHR_valid),
    .MSHR_write(MSHR_write),
    .MSHR_pAddress(MSHR_pAddress),

    .SER_valid0(SER_valid0),
    .SER_data0(SER_data0),
    .SER_pAddress0(SER_pAddress0),
    .SER_return0(SER_return0),
    .SER_size0(SER_size0),
    .SER_rw0(SER_rw0),
    .SER_dest0(SER_dest0),

    .SER_valid1(SER_valid1),
    .SER_pAddress1(SER_pAddress1),
    .SER_return1(SER_return1),
    .SER_size1(SER_size1),
    .SER_rw1(SER_rw1),
    .SER_dest1(SER_dest1),

    .EX_valid(EX_valid),
    .EX_data(EX_data),
    .EX_vAddress(EX_vAddress),
    .EX_pAddress(EX_pAddress),
    .EX_size(EX_size),
    .EX_wake(EX_wake),
    .oddIsGreater(oddIsGreater),
    .cache_stall(cache_stall),
    .cache_miss(cache_miss),
    .needP1(needP1_out),
    .oneSize_out(oneSize_out),
    .PTC_ID_out(PTC_ID_out)
);

outputAlign oA (
    .E_valid(E_valid),
    .E_data(E_data),
    .E_vAddress(E_vAddress),
    .E_pAddress(E_pAddress),
    .E_size(E_size),
    .E_wake(E_wake),
    .E_cache_stall(E_cache_stall),
    .E_cache_miss(E_cache_miss),
    .E_oddIsGreater(E_oddIsGreater),
    .E_needP1(E_needP1),
    .oneSize(oneSize),
    .O_valid(O_valid),
    .O_data(O_data),
    .O_vAddress(O_vAddress),
    .O_pAddress(O_pAddress),
    .O_size(O_size),
    .O_wake(O_wake),
    .O_cache_stall(O_cache_stall),
    .O_cache_miss(O_cache_miss),
    .O_oddIsGreater(O_oddIsGreater),
    .O_needP1(O_needP1),
    .data_out(data_out),
    .valid_out(valid_out),
    .wake(wake_out)
);

module mshrE (input [14:0] pAddress,
             input [6:0] ptcid_in,
             input rd_or_sw_in,
             input alloc, dealloc,

             input clk, clr,
             
             output [6:0] ptcid_out,
             output rd_or_sw_out,
             output mshr_hit, mshr_full
);

module mshrO (input [14:0] pAddress,
             input [6:0] ptcid_in,
             input rd_or_sw_in,
             input alloc, dealloc,

             input clk, clr,
             
             output [6:0] ptcid_out,
             output rd_or_sw_out,
             output mshr_hit, mshr_full
             );

endmodule 