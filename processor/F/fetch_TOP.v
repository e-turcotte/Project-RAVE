module fetch_TOP (
    ////////////////////////////
    //     global signals     //  
    ///////////////////////////
    input wire clk,
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
    //    output signals      //  
    ///////////////////////////
    output wire [127:0] packet_out,
    output wire packet_out_valid
);

    wire even_latch_was_loaded, odd_latch_was_loaded;
    wire [127:0] even_line, odd_line;
    wire cache_miss_even, cache_miss_odd;
    wire [1:0] FIP_o_lsb, FIP_e_lsb;
    fetch_1 f1(
        .clk(clk), 
        .reset(reset), 
        .init_addr(32'd0), 
        .is_init(is_init), 
        .BP_FIP_o(BP_FIP_o), 
        .BP_FIP_e(BP_FIP_e), 
        .is_BR_T_NT(is_BR_T_NT), 
        .WB_FIP_o(WB_FIP_o), 
        .WB_FIP_e(WB_FIP_e), 
        .is_resteer(resteer), 
        .even_latch_was_loaded(even_latch_was_loaded), 
        .odd_latch_was_loaded(odd_latch_was_loaded), 
        .even_line_out(even_line), 
        .odd_line_out(odd_line), 
        .cache_miss_even(cache_miss_even), 
        .cache_miss_odd(cache_miss_odd),
        .FIP_o_lsb(FIP_o_lsb),
        .FIP_e_lsb(FIP_e_lsb)
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
    )

    
endmodule