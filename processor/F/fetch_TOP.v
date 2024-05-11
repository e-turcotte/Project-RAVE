module fetch_TOP (
    ////////////////////////////
    //     global signals     //  
    ///////////////////////////
    input wire clk,
    input wire set,
    input wire reset,
    
    ////////////////////////////
    // signals from decode   //  
    //////////////////////////
    input wire [7:0] D_length,
    input wire stall,

    /////////////////////////////
    // signals from writeback //  
    ///////////////////////////
    input wire [27:0] WB_FIP_o,
    input wire [27:0] WB_FIP_e,
    input wire [5:0] WB_BIP,
    input wire resteer,

    /////////////////////////////
    //    signals from BP     //  
    ///////////////////////////
    input wire [27:0] BP_FIP_o,
    input wire [27:0] BP_FIP_e,
    input wire [5:0] BP_BIP,
    input wire [27:0] is_BR_T_NT,

    ////////////////////////////
    // signals from init     //  
    ///////////////////////////
    input wire [31:0] init_addr,
    input wire is_init,

    /////////////////////////////
    // signals from SER and BUS//
    ////////////////////////////
    input wire SER_i$_grant_e,
    input wire SER_i$_grant_o,
    input wire SER_i$_release_o,
    input wire SER_i$_req_o,
    input wire SER_i$_release_e,
    input wire SER_i$_req_e,
    input wire DES_i$_reciever_e,
    input wire DES_i$_reciever_o,
    input wire DES_i$_free_o,
    input wire DES_i$_free_e,

    inout wire [73:0] BUS,

    ////////////////////////////////
    // signals from TLB stuff     //
    ///////////////////////////////
    input wire protection_exception_e,
    input wire TLB_MISS_EXCEPTION_e,
    input wire protection_exception_o,
    input wire TLB_MISS_EXCEPTION_o,
    input wire [159:0] VP,
    input wire [159:0] PF,
    input wire [7:0] MSHR_entry_V,
    input wire [7:0] MSHR_entry_P,
    input wire [7:0] MSHR_entry_RW,
    input wire [7:0] MSHR_entry_PCD,

    /////////////////////////////
    //    output signals      //  
    ///////////////////////////
    output wire [127:0] packet_out,
    output wire packet_out_valid
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
        .is_init(is_init),
        .BP_FIP_o(BP_FIP_o),
        .BP_FIP_e(BP_FIP_e),
        .is_BR_T_NT(is_BR_T_NT),
        .WB_FIP_o(WB_FIP_o),
        .WB_FIP_e(WB_FIP_e),
        .is_resteer(resteer),

        .even_latch_was_loaded(even_latch_was_loaded),
        .odd_latch_was_loaded(odd_latch_was_loaded),

        .VP(VP), 
        .PF(PF),
        .MSHR_entry_V(MSHR_entry_V), 
        .MSHR_entry_P(MSHR_entry_P), 
        .MSHR_entry_RW(MSHR_entry_RW), 
        .MSHR_entry_PCD(MSHR_entry_PCD),

        .clock_bus(),
        .SER_i$_grant_e(SER_i$_grant_e),
        .SER_i$_grant_o(SER_i$_grant_o),
        .DES_i$_reciever_e(DES_i$_reciever_e),
        .DES_i$_reciever_o(DES_i$_reciever_o),

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

        .BUS(BUS)
    );

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
        .packet_out(packet_out), 
        .packet_out_valid(packet_out_valid),
        .old_BIP(old_BIP),
        .new_BIP(new_BIP)
    );

    
endmodule