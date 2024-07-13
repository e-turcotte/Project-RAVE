module branch_target_buff(
    input clk,
    input [31:0] EIP_fetch, //used to lookup
    input [31:0] EIP_WB, //EIP of BR instr, passed from WB
    input [31:0] FIP_E_WB, 
    input [31:0] FIP_O_WB, 
    input [31:0] target_WB, //update, from WB
    input LD, //is_BR, valid bit from WB latch
    input reset,

    output [27:0] FIP_E_target,
    output [27:0] FIP_O_target,
    output [31:0] EIP_target,
    output miss,
    output hit
    );

    //a BTB entry includes: 26 bit tag, 32 bit (each) FIP_O, FIP_E, target

    //values to read BTB
    wire [31:0] tag_lookup; //26 bit tag with zext to 32b
    wire [5:0] index_lookup; //6 bit index
    assign tag_lookup = {6'b0, EIP_fetch[31:6]};
    assign index_lookup = EIP_fetch[5:0];

    //values to write to BTB
    wire [31:0] tag_write;
    wire [5:0] index_write;
    assign tag_write = {6'b0, EIP_WB[31:6]}; 
    assign index_write = EIP_WB[5:0]; //where to write in BTB

    genvar i, j;

    wire [63:0] index_write_decoded;
    wire [63:0] index_lookup_decoded;
    wire [63:0] ld_reg;

    wire [63:0] valid_out_unpacked; //64 * 1
    wire [2047:0] tag_store_out_unpacked; //64 * 32
    wire [2047:0] target_store_out_unpacked;
    wire [2047:0] FIP_E_store_out_unpacked;
    wire [2047:0] FIP_O_store_out_unpacked;

    wire [63:0] tag_compare;

    decodern #(.INPUT_WIDTH(6)) line_write_mux(.in(index_write), .out(index_write_decoded));
    decodern #(.INPUT_WIDTH(6)) line_lookup_mux(.in(index_lookup), .out(index_lookup_decoded));

    generate
        for (i = 0; i < 64; i = i + 1) begin
            and2$ a(.out(ld_reg[i]), .in0(LD), .in1(index_write_decoded[i]));
            
            regn #(.WIDTH(1)) valid_reg (.din(1'b1), 
                                        .ld(ld_reg[i]), 
                                        .clr(reset), 
                                        .clk(clk), 
                                        .dout(valid_out_unpacked[i]));

            regn #(.WIDTH(32)) tag_reg (.din(tag_write), 
                                        .ld(ld_reg[i]), 
                                        .clr(reset), 
                                        .clk(clk), 
                                        .dout(tag_store_out_unpacked[i*32 + 31 : i*32]));
                                    
            regn #(.WIDTH(32)) target_reg (.din(target_WB), 
                                           .ld(ld_reg[i]), 
                                           .clr(reset), 
                                           .clk(clk), 
                                           .dout(target_store_out_unpacked[i*32 + 31 : i*32]));

            regn #(.WIDTH(32)) FIP_E_reg (.din(FIP_E_WB),
                                            .ld(ld_reg[i]), 
                                            .clr(reset), 
                                            .clk(clk), 
                                            .dout(FIP_E_store_out_unpacked[i*32 + 31 : i*32]));                
            
            regn #(.WIDTH(32)) FIP_O_reg (.din(FIP_O_WB),
                                            .ld(ld_reg[i]), 
                                            .clr(reset), 
                                            .clk(clk), 
                                            .dout(FIP_O_store_out_unpacked[i*32 + 31 : i*32]));

            equaln #(.WIDTH(32)) tag_eq(.a(tag_lookup), .b(tag_store_out_unpacked[i*32 + 31 : i*32]), .eq(tag_compare[i]));
        end
    endgenerate

    //check if we have a miss or hit by checking if any of the tags match
    wire [63:0] hit_array;
    andn #(2) and_hit(.in({tag_compare, valid_out_unpacked}), .out(hit_array));
    equaln #(.WIDTH(64)) eq(.a(hit_array), .b(64'h0), .eq(miss)); //will be 0 if we have a hit
    inv1$ i1(.out(hit), .in(miss));

    muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_target(
        .in(target_store_out_unpacked),
        .sel(index_lookup_decoded),
        .out(EIP_target)
    );

    wire [31:0] FIP_E_target_32_bit, FIP_O_target_32_bit;
    muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_FIP_E(
        .in(FIP_E_store_out_unpacked),
        .sel(index_lookup_decoded),
        .out(FIP_E_target_32_bit)
    );
    assign FIP_E_target = FIP_E_target_32_bit[31:4];

    muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(32) ) mux_FIP_O(
        .in(FIP_O_store_out_unpacked),
        .sel(index_lookup_decoded),
        .out(FIP_O_target_32_bit)
    );
    assign FIP_O_target = FIP_O_target_32_bit[31:4];

endmodule
