module fetch_TOP (
    ////////////////////////////
    //     global signals     //  
    ///////////////////////////
    input wire clk,
    input wire set,
    input wire reset,
    input wire bus_clk,
    input wire [15:0] cs, 
    
    ////////////////////////////
    // signals from decode   //  
    //////////////////////////
    input wire [7:0] D_length,
    input wire stall,

    /////////////////////////////
    // signals from writeback //  
    ///////////////////////////
    input wire [31:0] WB_FIP_o,
    input wire [31:0] WB_FIP_e,
    input wire [5:0] WB_BIP,
    input wire resteer,

    /////////////////////////////
    //    signals from BP     //  
    ///////////////////////////
    input wire [31:0] BP_FIP_o,
    input wire [31:0] BP_FIP_e,
    input wire [5:0] BP_BIP,
    input wire [31:0] BP_target,
    input wire is_BR_T_NT,
    input wire [5:0] BP_update_alias,

    ////////////////////////////
    // signals from init     //  
    ///////////////////////////
    input wire [31:0] init_addr,
    input wire is_init,

    ////////////////////////////
    // signals from IDTR     //  
    ///////////////////////////

    input wire [127:0] IDTR_packet,
    input wire packet_select,
    input wire WB_IE_val,
    input wire IDTR_LD_info_regs,
    input wire IDTR_is_POP_EFLAGS_in,
    input wire IDTR_invalidate_fetch, //active low

    /////////////////////////////
    // signals from SER and BUS//
    ////////////////////////////
    input wire SER_i$_grant_e,
    input wire SER_i$_grant_o,
    output wire SER_i$_release_o,
    output wire SER_i$_req_o,
    output wire SER_i$_release_e,
    output wire SER_i$_req_e,
    input wire DES_i$_reciever_e,
    input wire DES_i$_reciever_o,
    input wire SER_i$_ack_e,
    input wire SER_i$_ack_o,
    output wire DES_i$_free_o,
    output wire DES_i$_free_e,
    output wire [3:0] SER_dest_o,
    output wire [3:0] SER_dest_e,

    inout wire [72:0] BUS,

    ////////////////////////////////
    // signals from TLB stuff     //
    ///////////////////////////////
    input wire protection_exception_e,
    input wire TLB_MISS_EXCEPTION_e,
    input wire protection_exception_o,
    input wire TLB_MISS_EXCEPTION_o,
    input wire [159:0] VP,
    input wire [159:0] PF,
    input wire [7:0] TLB_entry_V,
    input wire [7:0] TLB_entry_P,
    input wire [7:0] TLB_entry_RW,
    input wire [7:0] TLB_entry_PCD,

    /////////////////////////////
    //    output signals      //  
    ///////////////////////////
    output wire [127:0] packet_out,
    output wire packet_valid_out,
    output wire is_BR_T_NT_out,
    output wire [31:0] BP_target_out,
    output wire [5:0] BP_update_alias_out,

    output wire IE_out,
    output wire [3:0] IE_type_out,
    output wire instr_is_IDTR_orig,
    output wire IDTR_is_POP_EFLAGS_out
);

    wire even_latch_was_loaded, odd_latch_was_loaded;
    wire [127:0] even_line, odd_line;
    wire cache_miss_even, cache_miss_odd;
    wire evenW, oddW;
    wire [1:0] FIP_o_lsb, FIP_e_lsb;
    fetch_1 f1(
        .clk(clk),
        .set(set), 
        .reset(reset),
        .init_addr(init_addr),
        .cs(cs),
        .is_init(is_init),
        .BP_FIP_o(BP_FIP_o[31:4]),
        .BP_FIP_e(BP_FIP_e[31:4]),
        .is_BR_T_NT(is_BR_T_NT),
        .WB_FIP_o(WB_FIP_o[31:4]),
        .WB_FIP_e(WB_FIP_e[31:4]),
        .is_resteer(resteer),

        .even_latch_was_loaded(even_latch_was_loaded),
        .odd_latch_was_loaded(odd_latch_was_loaded),

        .VP(VP), 
        .PF(PF),
        .TLB_entry_V(TLB_entry_V), 
        .TLB_entry_P(TLB_entry_P), 
        .TLB_entry_RW(TLB_entry_RW), 
        .TLB_entry_PCD(TLB_entry_PCD),

        .clock_bus(bus_clk),
        .SER_i$_grant_e(SER_i$_grant_e),
        .SER_i$_grant_o(SER_i$_grant_o),
        .DES_i$_reciever_e(DES_i$_reciever_e),
        .DES_i$_reciever_o(DES_i$_reciever_o),
        .SER_i$_ack_e(SER_i$_ack_e),
        .SER_i$_ack_o(SER_i$_ack_o),

        .protection_exception_e(protection_exception_e),
        .TLB_MISS_EXCEPTION_e(TLB_MISS_EXCEPTION_e),    
        .protection_exception_o(protection_exception_o),
        .TLB_MISS_EXCEPTION_o(TLB_MISS_EXCEPTION_o),    

        .line_even_out(even_line),
        .line_odd_out(odd_line),

        .cache_miss_even_out(cache_miss_even),
        .cache_miss_odd_out(cache_miss_odd),

        .evenW_out(evenW), //this signal is in case the cache is in the state where it is writing back to a line
        .oddW_out(oddW), //  in which case it would not be outputing valid lines out

        .FIP_o_lsb(FIP_o_lsb),
        .FIP_e_lsb(FIP_e_lsb),

        .SER_i$_release_o(SER_i$_release_o),
        .SER_i$_req_o(SER_i$_req_o),
        .SER_i$_release_e(SER_i$_release_e),    
        .SER_i$_req_e(SER_i$_req_e),
        .DES_i$_free_o(DES_i$_free_o),
        .DES_i$_free_e(DES_i$_free_e),
        .destIO(SER_dest_o),
        .destIE(SER_dest_e),

        .BUS(BUS)
    );

    wire prot_ex, tlb_miss;
    or2$ o183(.out(prot_ex), .in0(protection_exception_e), .in1(protection_exception_o));
    or2$ o124(.out(tlb_miss), .in0(TLB_MISS_EXCEPTION_e), .in1(TLB_MISS_EXCEPTION_o));

    or2$ o12e3(.out(IE_out), .in0(tlb_miss), .in1(prot_ex));
    assign IE_type_out[0] = prot_ex;
    assign IE_type_out[1] = tlb_miss;
    assign IE_type_out[3:2] = 0;

    wire [127:0] line_00_out, line_01_out, line_10_out, line_11_out;
    wire line_00_valid_out, line_01_valid_out, line_10_valid_out, line_11_valid_out;

    wire [5:0] old_BIP, new_BIP;
    iBuff_latch ibl(
        .clk(clk), 
        .reset(reset), 
        .is_BR_T_NT(is_BR_T_NT), 
        .is_resteer(resteer), 
        .is_init(is_init), 
        .line_even_fetch1(even_line), 
        .line_odd_fetch1(odd_line), 
        .stall(stall),
        .FIP_o_lsb_fetch1(FIP_o_lsb), 
        .FIP_e_lsb_fetch1(FIP_e_lsb), 
        .cache_miss_even_fetch1(cache_miss_even), 
        .cache_miss_odd_fetch1(cache_miss_odd),
        .evenW_fetch1(evenW),
        .oddW_fetch1(oddW),
        .new_BIP_fetch2(new_BIP), 
        .old_BIP_fetch2(old_BIP), 
        .line_00(line_00_out), 
        .line_00_valid(line_00_valid_out), 
        .line_01(line_01_out), 
        .line_01_valid(line_01_valid_out), 
        .line_10(line_10_out), 
        .line_10_valid(line_10_valid_out), 
        .line_11(line_11_out), 
        .line_11_valid(line_11_valid_out), 
        .even_latch_was_loaded(even_latch_was_loaded), 
        .odd_latch_was_loaded(odd_latch_was_loaded)
    );

    fetch_2 f2(
        .clk(clk), 
        .reset(reset), 
        .line_00(line_00_out), 
        .line_00_valid(line_00_valid_out), 
        .line_01(line_01_out), 
        .line_01_valid(line_01_valid_out), 
        .line_10(line_10_out), 
        .line_10_valid(line_10_valid_out), 
        .line_11(line_11_out), 
        .line_11_valid(line_11_valid_out), 
        .D_length(D_length), 
        .stall(stall), 
        .WB_BIP(WB_BIP), 
        .is_resteer(resteer), 
        .BP_BIP(BP_BIP), 
        .is_BR_T_NT(is_BR_T_NT), 
        .init_BIP(6'd0), 
        .is_init(is_init), 
        .IDTR_packet(IDTR_packet),
        .packet_select(packet_select),
        .WB_IE_val(WB_IE_val),
        .IDTR_LD_info_regs(IDTR_LD_info_regs),
        .IDTR_invalidate_fetch(IDTR_invalidate_fetch),
        .packet_out(packet_out), 
        .packet_out_valid(packet_valid_out),
        .old_BIP(old_BIP),
        .new_BIP(new_BIP)
    );


    assign is_BR_T_NT_out = is_BR_T_NT;
    assign BP_target_out = BP_target;
    assign BP_update_alias_out = BP_update_alias;
    assign instr_is_IDTR_orig = packet_select;
    assign IDTR_is_POP_EFLAGS_out = IDTR_is_POP_EFLAGS_in;

    
endmodule