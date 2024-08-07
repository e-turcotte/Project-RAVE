module branch_target_buff(
    input clk,
    input [31:0] EIP_fetch, //used to lookup
    input [31:0] EIP_of_branch_alias_WB, //EIP of BR instr, passed from WB
    input [31:0] FIP_E_WB, 
    input [31:0] FIP_O_WB, 
    input [31:0] D_EIP_WB, //update, from WB
    input LD, //is_BR, valid bit from WB latch
    input reset,

    output [27:0] FIP_E_target,
    output [27:0] FIP_O_target,
    output [31:0] EIP_target,
    output miss,
    output hit
    );

    wire [31:0] tag_in_write, tag_in_read;
    assign tag_in_write = EIP_of_branch_alias_WB;
    assign tag_in_read = EIP_fetch;

    wire [7:0] ld_shift_reg_out, ld_shift_reg_out_shifted;
    regn_with_set_lsb_FIP #(.PARITY(1), .WIDTH(8)) shift_reg(
        .din(ld_shift_reg_out_shifted),
        .ld(LD),
        .clr(reset),
        .clk(clk),
        .dout(ld_shift_reg_out)
    );

    lshfn_fixed #(.WIDTH(8), .SHF_AMNT(1)) reg_shifter(
        .in(ld_shift_reg_out),
        .shf_val(1'b0),
        .out(ld_shift_reg_out_shifted)
    );

    genvar i;
    wire [7:0] ld_reg;

    wire [7:0] valid_out_unpacked; //8 * 1
    wire [255:0] tag_store_out_unpacked; //8 * 32
    wire [255:0] D_EIP_store_out_unpacked;
    wire [255:0] FIP_E_store_out_unpacked;
    wire [255:0] FIP_O_store_out_unpacked;

    wire [7:0] tag_compare_read, tag_compare_write, tag_compare_validated_read, tag_compare_validated_write;

    generate
        for (i = 0; i < 8; i = i + 1) begin
            wire actual_ld_signal_LOL;
            and2$ a0(.out(actual_ld_signal_LOL), .in0(LD), .in1(ld_reg[i]));
            regn #(.WIDTH(1)) valid_reg (.din(1'b1), 
                                        .ld(actual_ld_signal_LOL), 
                                        .clr(reset), 
                                        .clk(clk), 
                                        .dout(valid_out_unpacked[i]));

            regn #(.WIDTH(32)) tag_reg (.din(tag_in_write), 
                                        .ld(actual_ld_signal_LOL), 
                                        .clr(reset), 
                                        .clk(clk), 
                                        .dout(tag_store_out_unpacked[i*32 + 31 : i*32]));
                                    
            regn #(.WIDTH(32)) D_EIP_reg (.din(D_EIP_WB), 
                                           .ld(actual_ld_signal_LOL), 
                                           .clr(reset), 
                                           .clk(clk), 
                                           .dout(D_EIP_store_out_unpacked[i*32 + 31 : i*32]));

            regn #(.WIDTH(32)) FIP_E_reg (.din(FIP_E_WB),
                                            .ld(actual_ld_signal_LOL), 
                                            .clr(reset), 
                                            .clk(clk), 
                                            .dout(FIP_E_store_out_unpacked[i*32 + 31 : i*32]));                
            
            regn #(.WIDTH(32)) FIP_O_reg (.din(FIP_O_WB),
                                            .ld(actual_ld_signal_LOL), 
                                            .clr(reset), 
                                            .clk(clk), 
                                            .dout(FIP_O_store_out_unpacked[i*32 + 31 : i*32]));

            equaln #(.WIDTH(32)) tag_eq_read(.a(tag_in_read), .b(tag_store_out_unpacked[i*32 + 31 : i*32]), .eq(tag_compare_read[i]));
            equaln #(.WIDTH(32)) tag_eq_write(.a(tag_in_write), .b(tag_store_out_unpacked[i*32 + 31 : i*32]), .eq(tag_compare_write[i]));
            andn #(2) a1(.out(tag_compare_validated_read[i]), .in({tag_compare_read[i], valid_out_unpacked[i]}));
            andn #(2) a2(.out(tag_compare_validated_write[i]), .in({tag_compare_write[i], valid_out_unpacked[i]}));

        end
    endgenerate

    wire btb_tag_hit_read, btb_tag_miss_read, btb_tag_hit_write, btb_tag_miss_write;
    orn #(8) or1(.out(btb_tag_hit_read), .in(tag_compare_validated_read));
    inv1$ i1(.out(btb_tag_miss_read), .in(btb_tag_hit_read));

    orn #(8) or2(.out(btb_tag_hit_write), .in(tag_compare_validated_write));
    inv1$ i2(.out(btb_tag_miss_write), .in(btb_tag_hit_write));




    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) ld_signal_select(
        .in({tag_compare_validated_write, ld_shift_reg_out}),
        .sel(btb_tag_hit_write),
        .out(ld_reg)
    );

    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(32) ) mux_target(
        .in(D_EIP_store_out_unpacked),
        .sel(tag_compare_validated_read),
        .out(EIP_target)
    );

    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(32) ) mux_FIP_E(
        .in(FIP_E_store_out_unpacked),
        .sel(tag_compare_validated_read),
        .out(FIP_E_target)
    );

    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(32) ) mux_FIP_O(
        .in(FIP_O_store_out_unpacked),
        .sel(tag_compare_validated_read),
        .out(FIP_O_target)
    );

    assign miss = btb_tag_miss_read;
    assign hit = btb_tag_hit_read;

    // //a BTB entry includes: 26 bit tag, 32 bit (each) FIP_O, FIP_E, target

    // //values to read BTB
    // wire [31:0] tag_lookup; //26 bit tag with zext to 32b
    // wire [5:0] index_lookup; //6 bit index
    // assign tag_lookup = {6'b0, EIP_fetch[31:6]};
    // assign index_lookup = EIP_fetch[5:0];

    // //values to write to BTB
    // wire [31:0] tag_write;
    // wire [5:0] index_write;
    // assign tag_write = {6'b0, EIP_WB[31:6]}; 
    // assign index_write = EIP_WB[5:0]; //where to write in BTB

    // genvar i, j;

    // wire [63:0] index_write_decoded;
    // wire [63:0] index_lookup_decoded;
    // wire [63:0] ld_reg;

    // wire [63:0] valid_out_unpacked; //64 * 1
    // wire [2047:0] tag_store_out_unpacked; //64 * 32
    // wire [2047:0] target_store_out_unpacked;
    // wire [2047:0] FIP_E_store_out_unpacked;
    // wire [2047:0] FIP_O_store_out_unpacked;

    // wire [63:0] tag_compare;

    // decodern #(.INPUT_WIDTH(6)) line_write_mux(.in(index_write), .out(index_write_decoded));
    // decodern #(.INPUT_WIDTH(6)) line_lookup_mux(.in(index_lookup), .out(index_lookup_decoded));

    // generate
    //     for (i = 0; i < 64; i = i + 1) begin
    //         and2$ a(.out(ld_reg[i]), .in0(LD), .in1(index_write_decoded[i]));
            
    //         regn #(.WIDTH(1)) valid_reg (.din(1'b1), 
    //                                     .ld(ld_reg[i]), 
    //                                     .clr(reset), 
    //                                     .clk(clk), 
    //                                     .dout(valid_out_unpacked[i]));

    //         regn #(.WIDTH(32)) tag_reg (.din(tag_write), 
    //                                     .ld(ld_reg[i]), 
    //                                     .clr(reset), 
    //                                     .clk(clk), 
    //                                     .dout(tag_store_out_unpacked[i*32 + 31 : i*32]));
                                    
    //         regn #(.WIDTH(32)) target_reg (.din(target_WB), 
    //                                        .ld(ld_reg[i]), 
    //                                        .clr(reset), 
    //                                        .clk(clk), 
    //                                        .dout(target_store_out_unpacked[i*32 + 31 : i*32]));

    //         regn #(.WIDTH(32)) FIP_E_reg (.din(FIP_E_WB),
    //                                         .ld(ld_reg[i]), 
    //                                         .clr(reset), 
    //                                         .clk(clk), 
    //                                         .dout(FIP_E_store_out_unpacked[i*32 + 31 : i*32]));                
            
    //         regn #(.WIDTH(32)) FIP_O_reg (.din(FIP_O_WB),
    //                                         .ld(ld_reg[i]), 
    //                                         .clr(reset), 
    //                                         .clk(clk), 
    //                                         .dout(FIP_O_store_out_unpacked[i*32 + 31 : i*32]));

    //         equaln #(.WIDTH(32)) tag_eq(.a(tag_lookup), .b(tag_store_out_unpacked[i*32 + 31 : i*32]), .eq(tag_compare[i]));
    //     end
    // endgenerate

    // //check if we have a miss or hit by checking if any of the tags match
    // wire [63:0] hit_array;
    // generate
    //     for (j = 0; j < 64; j = j + 1) begin
    //         and2$ and_hit(.out(hit_array[j]), .in0(tag_compare[j]), .in1(valid_out_unpacked[j]));
    //     end
    // endgenerate
    // equaln #(.WIDTH(64)) eq(.a(hit_array), .b(64'h0), .eq(miss)); //will be 0 if we have a hit
    // inv1$ i1(.out(hit), .in(miss));

    // muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_target(
    //     .in(target_store_out_unpacked),
    //     .sel(index_lookup_decoded),
    //     .out(EIP_target)
    // );

    // wire [31:0] FIP_E_target_32_bit, FIP_O_target_32_bit;
    // muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_FIP_E(
    //     .in(FIP_E_store_out_unpacked),
    //     .sel(index_lookup_decoded),
    //     .out(FIP_E_target_32_bit)
    // );
    // assign FIP_E_target = FIP_E_target_32_bit[31:4];

    // muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_FIP_O(
    //     .in(FIP_O_store_out_unpacked),
    //     .sel(index_lookup_decoded),
    //     .out(FIP_O_target_32_bit)
    // );
    // assign FIP_O_target = FIP_O_target_32_bit[31:4];

endmodule
