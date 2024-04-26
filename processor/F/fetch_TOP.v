module fetch_TOP (
    ////////////////////////////
    //     global signals     //  
    ///////////////////////////
    input wire clk,
    input wire reset,

    ////////////////////////////
    // signals from decode   //  
    //////////////////////////
    input wire [31:0] D_EIP,

    /////////////////////////////
    // signals from writeback //  
    ///////////////////////////
    input wire [27:0] WB_FIP_o,
    input wire [27:0] WB_FIP_e,
    input wire resteer,

    /////////////////////////////
    //    signals from BP     //  
    ///////////////////////////
    input wire [27:0] BP_FIP_o,
    input wire [27:0] BP_FIP_e,
    input wire [27:0] is_BR,

    ////////////////////////////
    // signals from init     //  
    ///////////////////////////
    input wire [31:0] init_addr,
    input wire is_init,

    /////////////////////////////
    //    output signals      //  
    ///////////////////////////
    output wire [127:0] packet_out
);

    fetch_1 f1(
        .clk(clk), 
        .init_addr(), 
        .resteer_addr(), 
        .D_EIP(), 
        .is_resteer(), 
        .is_init(), 
        .v_00_in(), 
        .v_01_in(), 
        .v_10_in(), 
        .v_11_in(), 
        .line_1_out(), 
        .line_2_out(), 
        .line_3_out(), 
        .line_4_out()
    );

    iBuff_latch ibl(
        .clk(clk), 
        .reset(reset), 
        .CF(), 
        .line_even_fetch1(), 
        .line_odd_fetch1(), 
        .FIP_o_lsb_fetch1(), 
        .FIP_e_lsb_fetch1(), 
        .cache_miss_even_fetch1(), 
        .cache_miss_odd_fetch1(), 
        .new_BIP_fetch2(), 
        .old_BIP_fetch2(), 
        .line_00(), 
        .line_00_valid(), 
        .line_01(), 
        .line_01_valid(), 
        .line_10(), 
        .line_10_valid(), 
        .line_11(), 
        .line_11_valid()
    );

    fetch_2 f2(
        .clk(clk), 
        .reset(reset), 
        .line_00(), 
        .line_00_valid(), 
        .line_01(), 
        .line_01_valid(), 
        .line_10(), 
        .line_10_valid(), 
        .line_11(), 
        .line_11_valid(), 
        .D_length(), 
        .packet_out(), 
        .packet_out_valid()
    );

    
endmodule