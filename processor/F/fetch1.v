module fetch_1 (
    input wire clk,
    input wire set, reset,
    input wire [31:0] init_addr,
    input wire is_init,
    input wire [27:0] BP_FIP_o,
    input wire [27:0] BP_FIP_e,
    input wire is_BR_T_NT,
    input wire [27:0] WB_FIP_o,
    input wire [27:0] WB_FIP_e,
    input wire is_resteer,

    input wire even_latch_was_loaded,
    input wire odd_latch_was_loaded,

    input wire [159:0] VP, PF,
    input wire [7:0]TLB_entry_V, TLB_entry_P, TLB_entry_RW, TLB_entry_PCD,

    input wire clock_bus,
    input wire SER_i$_grant_e,
    input wire SER_i$_grant_o,
    input wire DES_i$_reciever_e,
    input wire DES_i$_reciever_o,

    output wire protection_exception_e,
    output wire TLB_MISS_EXCEPTION_e,    
    output wire protection_exception_o,
    output wire TLB_MISS_EXCEPTION_o,    

    output wire [127:0] line_even_out,
    output wire [127:0] line_odd_out,

    output wire cache_miss_even_out,
    output wire cache_miss_odd_out,

    output wire evenW_out, //this signal is in case the cache is in the state where it is writing back to a line
    output wire oddW_out, //  in which case it would not be outputing valid lines out

    output wire [1:0] FIP_o_lsb,
    output wire [1:0] FIP_e_lsb,

    output wire SER_i$_release_o,
    output wire SER_i$_req_o,
    output wire SER_i$_release_e,    
    output wire SER_i$_req_e,
    output wire DES_i$_free_o,
    output wire DES_i$_free_e,
    output wire [3:0] destIE,
    output wire [3:0] destIO,

    inout wire [72:0] BUS
    
);

// CF priority arbitration
wire [2:0] select_CF_mux;
wire select_CF_mux_0, select_CF_mux_1, select_CF_mux_2;
assign select_CF_mux_2 = is_init;
wire not_is_init;
inv1$ i0(.in(is_init), .out(not_is_init));
andn #(2) a0(.in({not_is_init, is_resteer}), .out(select_CF_mux_1));
wire not_is_resteer;
inv1$ i1(.in(is_resteer), .out(not_is_resteer));
andn #(3) a1(.in({not_is_init, not_is_resteer, is_BR_T_NT}), .out(select_CF_mux_0));
assign select_CF_mux = {select_CF_mux_2, select_CF_mux_1, select_CF_mux_0};

wire is_CF;
orn #(3) o0(.in({is_init, is_resteer, is_BR_T_NT}), .out(is_CF));

// init FIP addr calculation
wire [27:0] init_FIP_o, init_FIP_e;

wire [31:0] init_addr_plus_1;
kogeAdder #(.WIDTH(32)) a02e35rwgsr(.SUM(init_addr_plus_1), .COUT(), .A({init_addr}), .B(32'd16), .CIN(1'b0));

muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(28)) m0(.in({init_addr, init_addr_plus_1}), .sel(init_addr[4]), .out(init_FIP_o));
muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(28)) m1(.in({init_addr_plus_1, init_addr}), .sel(init_addr[4]), .out(init_FIP_e));

// ld_FIP reg even calculation
wire ld_FIP_reg_even;
assign ld_FIP_reg_even = even_latch_was_loaded;

// ld_FIP reg odd calculation
wire ld_FIP_reg_odd;
assign ld_FIP_reg_odd = odd_latch_was_loaded;

wire [27:0] FIP_o;
wire [27:0] FIP_e;

select_address_ICache sel_odd(.clk(clk), .init_FIP(init_FIP_o), .BP_FIP(BP_FIP_o), .WB_FIP(WB_FIP_o), .sel_CF(select_CF_mux), .ld_FIP_reg(ld_FIP_reg_odd), 
                                       .clr_FIP_reg(reset), .is_ctrl_flow(is_CF), .output_addr(FIP_o));
select_address_ICache sel_even(.clk(clk), .init_FIP(init_FIP_e), .BP_FIP(BP_FIP_e), .WB_FIP(WB_FIP_e), .sel_CF(select_CF_mux), .ld_FIP_reg(ld_FIP_reg_even), 
                                       .clr_FIP_reg(reset), .is_ctrl_flow(is_CF), .output_addr(FIP_e));

assign FIP_o_lsb = FIP_o[5:4];
assign FIP_e_lsb = FIP_e[5:4];


I$ icache(
    .FIP_o({FIP_o, 4'b0}),
    .FIP_e({FIP_e, 4'b0}),
    .line_even_out(line_even_out),
    .line_odd_out(line_odd_out),
    .cache_miss_even(cache_miss_even_out),
    .cache_miss_odd(cache_miss_odd_out),
    .evenW(evenW_out),
    .oddW(oddW_out),
    .clk(clk),
    .set(set),
    .reset(reset),
    .VP(VP),
    .PF(PF),
    .TLB_entry_V(TLB_entry_V),
    .TLB_entry_P(TLB_entry_P),
    .TLB_entry_RW(TLB_entry_RW),
    .TLB_entry_PCD(TLB_entry_PCD),
    .protection_exception_e(protection_exception_e),
    .TLB_MISS_EXCEPTION_e(TLB_MISS_EXCEPTION_e),
    .protection_exception_o(protection_exception_o),
    .TLB_MISS_EXCEPTION_o(TLB_MISS_EXCEPTION_o),
    .clock_bus(clock_bus),
    .SER_i$_grant_e(SER_i$_grant_e),
    .SER_i$_grant_o(SER_i$_grant_o),
    .DES_i$_reciever_e(DES_i$_reciever_e),
    .DES_i$_reciever_o(DES_i$_reciever_o),
    .SER_i$_release_o(SER_i$_release_o),
    .SER_i$_req_o(SER_i$_req_o),
    .SER_i$_release_e(SER_i$_release_e),
    .SER_i$_req_e(SER_i$_req_e),
    .SER_dest_o(SER_dest_o),
    .SER_dest_e(SER_dest_e),
    .destIO(destIO),
    .destIE(destIE),
    .BUS(BUS)
);


    
endmodule

module select_address_ICache (
   input wire clk,
   input wire [27:0] init_FIP,
   input wire [27:0] BP_FIP,
   input wire [27:0] WB_FIP,
   input wire [2:0] sel_CF,
   input wire ld_FIP_reg,
   input wire clr_FIP_reg,
   input wire is_ctrl_flow,
   output wire [27:0] output_addr
);

wire [27:0] ctrl_flow_addr;
wire [31:0] addr_plus_2;
wire [27:0] FIP_reg_data_out;

muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(28)) m0(.in({init_FIP, WB_FIP, BP_FIP}), .sel(sel_CF), .out(ctrl_flow_addr));
kogeAdder #(.WIDTH(32)) a0(.SUM(addr_plus_2), .COUT(), .A({4'b0000, output_addr}), .B(32'd2), .CIN(1'b0));
regn #(.WIDTH(28)) r0(.din(addr_plus_2[27:0]), .ld(ld_FIP_reg), .clr(clr_FIP_reg), .clk(clk), .dout(FIP_reg_data_out));

muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(28)) m1(.in({ctrl_flow_addr, FIP_reg_data_out}), .sel(is_ctrl_flow), .out(output_addr));
    
endmodule


module I$ (
    input wire [31:0] FIP_o,
    input wire [31:0] FIP_e,
    
    output wire [127:0] line_even_out,
    output wire [127:0] line_odd_out,

    output wire cache_miss_even,
    output wire cache_miss_odd,

    output evenW,
    output oddW,

    ///////////////////////////////////////
    input clk,
    input set, reset,

    
    //////////////////////////////////////
    //TLB I/O
    input [159:0] VP, PF,
    input [7:0]TLB_entry_V, TLB_entry_P, TLB_entry_RW, TLB_entry_PCD,

    output protection_exception_e,
    output TLB_MISS_EXCEPTION_e,
    output protection_exception_o,
    output TLB_MISS_EXCEPTION_o,

    /////////////////////////////////////
    //SERDES IO

    //SERDES GLOBAL
    input clock_bus,

    //From bau input
    input SER_i$_grant_e,
    input SER_i$_grant_o,
    input DES_i$_reciever_e,
    input DES_i$_reciever_o,
    input SER_i$_ack_e,
    input SER_i$_ack_o,
    //to bau output
   
    output SER_i$_release_o,
    output SER_i$_req_o,
    output SER_i$_release_e,
    output SER_i$_req_e,
    // output wire [3:0] SER_dest_o,
    // output wire [3:0] SER_dest_e,
    
    //DES_o
    output DES_i$_free_o,

    //DES_e
    output DES_i$_free_e,
    
    //BUS
    inout [72:0] BUS
);

wire [31:0] odd_access_address_VA, even_access_address_VA;
assign odd_access_address_VA = {FIP_o[27:0], 4'b0000};
assign even_access_address_VA = {FIP_e[27:0], 4'b0000};
/*FILL OUT THESE SIGNALS*/

wire DES_read_o;
wire DES_full_o;
wire [14:0] DES_pAdr_o;
wire [16*8-1:0]DES_DATA_o;
wire [3:0] DES_return_o;
wire [3:0]DES_dest_o;
wire DES_rw_o;
wire [15:0] DES_size_o;
wire DES_free_o;

wire DES_read_e;
wire DES_full_e;
wire [14:0] DES_pAdr_e;
wire [16*8-1:0]DES_DATA_e;
wire [3:0] DES_return_e;
wire [3:0]DES_dest_e;
wire DES_rw_e;
wire [15:0] DES_size_e;
wire DES_free_e;

wire SER_valid_e;
wire[14:0] SER_pAddress_e;
wire[2:0] SER_return_e;
wire[15:0] SER_size_e;
wire SER_rw_e;


wire SER_valid_o;
wire[14:0] SER_pAddress_o;
wire[3:0] SER_return_o;
wire[15:0] SER_size_o;
wire SER_rw_o;


wire SER_full_e, SER_full_o;

wire[19:0] pf_e, pf_o;
wire[14:0] pAddress_e, pAddress_o;
assign pAddress_e = {pf_e[2:0], FIP_e[11:0]};
assign pAddress_o = {pf_o[2:0], FIP_o[11:0]};

TLB tlb_even(
    .clk(clk),
    .address(FIP_e[31:12]), //used to lookup
    .RW_in(0),
    .is_mem_request(1'b1), //if 1, then we are doing a memory request, else - no prot exception should be thrown
    .VP(VP), //unpacked, do wire concatenation in TOP
    .PF(PF),
    .entry_v(TLB_entry_V),
    .entry_P(TLB_entry_P),
    .entry_RW(TLB_entry_RW), //read or write (im guessing 0 is read only)
    .entry_PCD(TLB_entry_PCD), //PCD disable - 1 means this entry is disabled for normal mem accesses since it is for MMIO
    .PF_out(pf_e),
    .PCD_out(),
    .miss(TLB_MISS_EXCEPTION_e),
    .hit(), //if page is valid, present and tag hit - 1 if hit
    .protection_exception(protection_exception_e) //if RW doesn't match entry_RW - 1 if exception
);
TLB tlb_odd(
    .clk(clk),
    .address(FIP_e[31:12]), //used to lookup
    .RW_in(0),
    .is_mem_request(1'b1), //if 1, then we are doing a memory request, else - no prot exception should be thrown
    .VP(VP), //unpacked, do wire concatenation in TOP
    .PF(PF),
    .entry_v(TLB_entry_V),
    .entry_P(TLB_entry_P),
    .entry_RW(TLB_entry_RW), //read or write (im guessing 0 is read only)
    .entry_PCD(TLB_entry_PCD), //PCD disable - 1 means this entry is disabled for normal mem accesses since it is for MMIO
    .PF_out(pf_o),
    .PCD_out(),
    .miss(TLB_MISS_EXCEPTION_o),
    .hit(), //if page is valid, present and tag hit - 1 if hit
    .protection_exception(protection_exception_o) //if RW doesn't match entry_RW - 1 if exception
);

wire DES_full_ne, DES_full_no;
wire[14:0] pAddr_e, pAddr_o;
mux2n #(15) sadasd(pAddr_e, pAddress_e, DES_pAdr_e, DES_full_e);
mux2n #(15) dsfse(pAddr_o, pAddress_o, DES_pAdr_o, DES_full_o);
inv1$ invx(DES_full_ne, DES_full_e);
inv1$ inx(DES_full_no, DES_full_o);

wire DES_full_e_notbuf, DES_full_o_notbuf;
regn #(1) r0(DES_full_e_notbuf, 1'b1, clk, reset, DES_full_e); 
regn #(1) r0asdfasf(DES_full_o_notbuf, 1'b1, clk, reset, DES_full_o); 

wire mshr_e_hit, mshr_e_full, mshr_e_write;
wire [14:0] mshr_e_paddr;

cacheBank even$(
    .clk(clk),
    .rst(reset), 
    .set(set),
    .cache_id(4'b0000),
    .vAddress({FIP_e,4'd0}),
    .pAddress(pAddr_e),
    .data(DES_DATA_e),
    .size(2'b00),
    .r(DES_full_ne),
    .w(DES_full_e),
    .sw(1'b0),
    .valid_in(1'b1),
    .fromBUS(1'b1), 
    .mask(128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
    
    .AQ_isEMPTY(1'b0),
    .PTC_ID_IN(7'b0000000),
    .oddIsGreater_in(1'b0),
    .needP1_in(1'b0),
    .oneSize(3'b0),

    .MSHR_HIT(mshr_e_hit),
    .MSHR_FULL(mshr_e_full),
    
    .SER1_FULL(SER_full_e),
    .SER0_FULL(1'b0),
    .PCD_IN(1'b0),

    .AQ_READ(),
    //.MSHR_valid(/*TODO*/),
    .MSHR_pAddress(mshr_e_paddr),
    //.MSHR_write(mshr_e_write),

    .SER_valid0(1'b0),                  
    .SER_data0(),                   
    .SER_pAddress0(),                   
    .SER_return0(),                 
    .SER_size0(),                   
    .SER_rw0(),                 
    .SER_dest0(),                   

    .SER_valid1(SER_valid_e),         
    .SER_pAddress1(SER_pAddress_e),   
    .SER_return1(SER_dest_e),         
    .SER_size1(SER_size_e),           
    .SER_rw1(SER_rw_e),               
    .SER_dest1(SER_dest_e),           

    .EX_valid(),
    .EX_data(line_even_out),
    .EX_pAddress(),
    .EX_size(),
    .EX_wake(cache_miss_even),

    .oddIsGreater(),
    .cache_stall(),
    .cache_miss(),
    .needP1(),
    .oneSize_out()
);
assign evenW = DES_full_e;
mshr mshre(.pAddress(mshr_e_paddr), .ptcid_in(7'b0), .qentry_slot_in(), .rdsw_in(1'b0),
           .alloc(mshr_e_write), .dealloc(/*todo make signal for this*/),
           .clk(clk), .clr(reset),
           .ptcid_out(), .qentry_slots_out(), .wake_vector_out(),
           .mshr_hit(mshr_e_hit), .mshr_full(mshr_e_full));

wire mshr_o_hit, mshr_o_full, mshr_o_write;
wire [14:0] mshr_o_paddr;

cacheBank odd$(
    .clk(clk),
    .rst(reset), 
    .set(set),
    .cache_id(4'b0001),
    .vAddress({FIP_o,4'd0}),
    .pAddress(pAddr_o),
    .data(DES_DATA_o),
    .size(2'b00),
    .r(DES_full_no),
    .w(DES_full_o),
    .sw(1'b0),
    .valid_in(1'b1),
    .fromBUS(1'b1), 
    .mask(128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF),
    
    .AQ_isEMPTY(1'b0),
    .PTC_ID_IN(7'b0000000),
    .oddIsGreater_in(1'b0),
    .needP1_in(1'b0),
    .oneSize(3'b0),

    .MSHR_HIT(mshr_o_hit),
    .MSHR_FULL(mshr_o_full),
    
    .SER1_FULL(SER_full_o),
    .SER0_FULL(1'b0),
    .PCD_IN(1'b0),

    .AQ_READ(),
    //.MSHR_valid(/*TODO*/),
    .MSHR_pAddress(mshr_o_paddr),
    //.MSHR_write(mshr_o_write),

    .SER_valid0(1'b0),                  
    .SER_data0(),                   
    .SER_pAddress0(),                   
    .SER_return0(),                 
    .SER_size0(),                   
    .SER_rw0(),                 
    .SER_dest0(),                   

    .SER_valid1(SER_valid_o),         
    .SER_pAddress1(SER_pAddress_o),   
    .SER_return1(SER_dest_o),         
    .SER_size1(SER_size_o),           
    .SER_rw1(SER_rw_o),               
    .SER_dest1(SER_dest_o),           

    .EX_valid(),
    .EX_data(line_odd_out),
    .EX_pAddress(),
    .EX_size(),
    .EX_wake(cache_miss_odd),

    .oddIsGreater(),
    .cache_stall(),
    .cache_miss(),
    .needP1(),
    .oneSize_out()
);
assign oddW = DES_full_o;
mshr mshro(.pAddress(mshr_o_paddr), .ptcid_in(7'b0), .qentry_slot_in(), .rdsw_in(1'b0),
           .alloc(mshr_o_write), .dealloc(/*todo make signal for this*/),
           .clk(clk), .clr(reset),
           .ptcid_out(), .qentry_slots_out(), .wake_vector_out(),
           .mshr_hit(mshr_o_hit), .mshr_full(mshr_o_full));
    
SER SER_e(
    .clk_bus(clock_bus),
    .clk_core(clk),
    .set(set), .rst(reset),

    .valid_in(SER_valid_e),
    .pAdr_in(SER_pAddress_e),
    .dest_in(SER_dest_e),
    .return_in(SER_return_e),
    .rw_in(SER_rw_e),
    .size_in(SER_size_e),
    .data_in(),

    .grant(SER_i$_grant_e),

    .full_block(SER_full_e),
    .free_block(),

    .releases(SER_i$_release_e),
    .req(SER_i$_req_e),
    .dest_bau(destIO),
    .BUS(BUS),

    .ack(SER_i$_ack_e)
);


SER SER_o(
    .clk_bus(clock_bus),
    .clk_core(clk),
    .set(set), .rst(reset),

    .valid_in(SER_valid_o),
    .pAdr_in(SER_pAddress_o),
    .dest_in(SER_dest_o),
    .return_in(SER_return_o),
    .rw_in(SER_rw_o),
    .size_in(SER_size_o),
    .data_in(),

    .grant(SER_i$_grant_o),

    .full_block(SER_full_o),
    .free_block(),

    .releases(SER_i$_release_o),
    .req(SER_i$_req_o),

    .BUS(BUS),
    .dest_bau(destIO),
    .ack(SER_i$_ack_o)
);

DES DES_e(
    .read(DES_read_e),
    .clk_bus(clock_bus),
    .clk_core(clk),
    .set(set), .rst(reset),

    .BUS(BUS),
    
    .full(DES_full_e_notbuf),
    .pAdr(DES_pAdr_e),
    .data(DES_DATA_e),
    .return(DES_return_e),
    .dest(DES_dest_e),
    .rw(DES_rw_e),
    .size(DES_size_e),

    .setReciever(DES_i$_reciever_e),
    .free_bau(DES_i$_free_e)
);

DES DES_o(
    .clk_bus(clock_bus),
    .clk_core(clk),
    .set(set), .rst(reset),

    .read(DES_read_o),

    .BUS(BUS),
    
    .full(DES_full_o_notbuf),
    .pAdr(DES_pAdr_o),
    .data(DES_DATA_o),
    .return(DES_return_o),
    .dest(DES_dest_o),
    .rw(DES_rw_o),
    .size(DES_size_o),
    
    
    .setReciever(DES_i$_reciever_o),
    .free_bau(DES_i$_free_o)
);

endmodule