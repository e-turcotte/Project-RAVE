module bp_gshare (
    input clk,
    input reset,
    input [31:0] eip,
    input prev_BR_result,
    input [7:0] GBHR_restore_val,
    input prev_is_BR,
    input prev_BR_correct,
    input wb_valid,
    input LD,

    output prediction,
    output [7:0] BP_alias
    );

    //***************************************************************************//
    //*************************** TWO LEVEL PREDICTOR *******************************//
    wire [63:0] out_decoder_out;
    wire [7:0] GBHR, GBHR_shifted, GBHR_restore_shifted_by_actual_branch, selected_GBHR;

    //6 bit GBHR: output into a shifter back into BHR
    //only shift into GBHR if LD is high and prev is a branch
    wire is_GBHR_restore, prev_BR_incorrect;
    inv1$ inv0(.out(prev_BR_incorrect), .in(prev_BR_correct));
    and3$ restore_GBR(.out(is_GBHR_restore), .in0(prev_BR_incorrect), .in1(prev_is_BR), .in2(wb_valid));


    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) GBHR_sel_mux(.in({GBHR_restore_shifted_by_actual_branch, GBHR_shifted}), .sel(is_GBHR_restore), .out(selected_GBHR));

    regn #(.WIDTH(8)) BHR(.din(selected_GBHR),
                        .ld(1'b1), .clr(reset),
                        .clk(clk),
                        .dout(GBHR));

    lshfn_fixed #(.WIDTH(8), .SHF_AMNT(1)) m0(.in(GBHR_restore_val), .shf_val(prev_BR_result), .out(GBHR_restore_shifted_by_actual_branch));
    lshfn_fixed #(.WIDTH(8), .SHF_AMNT(1)) m1(.in(GBHR), .shf_val(prediction), .out(GBHR_shifted));

    //6bit XOR into BP_alias - 8 bit register
    //using bits 29, 23, 17, 11, 8, 3 for the XOR
    wire [7:0] GBHR_xored_with_eip_read, GBHR_xored_with_eip_write;
    xor2$ x0(.out(GBHR_xored_with_eip_read[0]), .in0(1'b0/*eip_decode[29]*/), .in1(GBHR[0]));
    xor2$ x1(.out(GBHR_xored_with_eip_read[1]), .in0(1'b0/*eip_decode[23]*/), .in1(GBHR[1]));
    xor2$ x2(.out(GBHR_xored_with_eip_read[2]), .in0(1'b0/*eip_decode[17]*/), .in1(GBHR[2]));
    xor2$ x3(.out(GBHR_xored_with_eip_read[3]), .in0(1'b0/*eip_decode[11]*/), .in1(GBHR[3]));
    xor2$ x4(.out(GBHR_xored_with_eip_read[4]), .in0(1'b0/*eip_decode[8]*/),  .in1(GBHR[4]));
    xor2$ x5(.out(GBHR_xored_with_eip_read[5]), .in0(1'b0/*eip_decode[3]*/),  .in1(GBHR[5]));
    xor2$ x6(.out(GBHR_xored_with_eip_read[6]), .in0(1'b0/*eip_decode[2]*/),  .in1(GBHR[6]));
    xor2$ x7(.out(GBHR_xored_with_eip_read[7]), .in0(1'b0/*eip_decode[1]*/),  .in1(GBHR[7]));

    xor2$ x8( .out(GBHR_xored_with_eip_write[0]), .in0(1'b0/*eip_decode[29]**/), .in1(GBHR_restore_val[0]));
    xor2$ x9( .out(GBHR_xored_with_eip_write[1]), .in0(1'b0/*eip_decode[23]**/), .in1(GBHR_restore_val[1]));
    xor2$ x10(.out(GBHR_xored_with_eip_write[2]), .in0(1'b0/*eip_decode[17]**/), .in1(GBHR_restore_val[2]));
    xor2$ x11(.out(GBHR_xored_with_eip_write[3]), .in0(1'b0/*eip_decode[11]**/), .in1(GBHR_restore_val[3]));
    xor2$ x12(.out(GBHR_xored_with_eip_write[4]), .in0(1'b0/*eip_decode[8]*/),   .in1(GBHR_restore_val[4]));
    xor2$ x13(.out(GBHR_xored_with_eip_write[5]), .in0(1'b0/*eip_decode[3]*/),   .in1(GBHR_restore_val[5]));
    xor2$ x14(.out(GBHR_xored_with_eip_write[6]), .in0(1'b0/*eip_decode[2]*/),   .in1(GBHR_restore_val[6]));
    xor2$ x15(.out(GBHR_xored_with_eip_write[7]), .in0(1'b0/*eip_decode[1]*/),   .in1(GBHR_restore_val[7]));

    //8 to 256 bit decoder used to mux out prediction from PHT
    wire [255:0] prediction_write_decoder_out;
    decodern #(.INPUT_WIDTH(8)) pred_out_w(.in(GBHR_xored_with_eip_write), .out(prediction_write_decoder_out));

    //PHT
    wire [255:0] counter_out_high, counter_out_low;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin 
            wire enable_read, enable_write;
            and3$ a2(.out(enable_write), .in0(prediction_write_decoder_out[i]), .in1(wb_valid), .in2(prev_is_BR));

            sat_cntr2 sat(
                .clk(clk),
                .set_n(1'b1),
                .rst_n(reset),
                .in(prev_BR_result),
                .enable(enable_write),
                .s_out_high(counter_out_high[i]),
                .s_out_low()
            );
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(8), .DATA_WIDTH(1)) pred_out_mux(.in(counter_out_high), .sel(GBHR_xored_with_eip_read), .out(prediction));
    assign BP_alias = GBHR;
    //***************************************************************************//

    //***************************************************************************//
    //*************************** TWO BIT SAT PREDICTOR *******************************//
    // sat_cntr2 sat(
    //             .clk(clk),
    //             .set_n(1'b1),
    //             .rst_n(reset),
    //             .in(prev_BR_result),
    //             .enable(LD),
    //             .s_out_high(prediction),
	// 	        .s_out_low()
    //         );
    //***************************************************************************//

    // wire [63:0] out_decoder_out;
    // wire [5:0] GBHR, GBHR_shifted;
    // wire LD_n;

    // //6 bit GBHR: output into a shifter back into BHR
    // //only shift into GBHR if LD is high and prev is a branch
    // and2$ ld_and(.out(LD_n), .in0(LD), .in1(prev_is_BR));

    // regn #(.WIDTH(6)) BHR(.din(GBHR_shifted),
    //                     .ld(clk), .clr(reset),
    //                     .clk(clk),
    //                     .dout(GBHR));

    // lshfn_fixed #(.WIDTH(6), .SHF_AMNT(1)) m0(.in(GBHR), .shf_val(prediction), .out(GBHR_shifted));

    // //6bit XOR into BP_alias - 6 bit register
    // //using bits 29, 23, 17, 11, 8, 2 for the XOR
    // xor2$ x0(.out(BP_alias[0]), .in0(eip[29]), .in1(GBHR[5]));
    // xor2$ x1(.out(BP_alias[1]), .in0(eip[23]), .in1(GBHR[4]));
    // xor2$ x2(.out(BP_alias[2]), .in0(eip[17]), .in1(GBHR[3]));
    // xor2$ x3(.out(BP_alias[3]), .in0(eip[11]), .in1(GBHR[2]));
    // xor2$ x4(.out(BP_alias[4]), .in0(eip[8]),  .in1(GBHR[1]));
    // xor2$ x5(.out(BP_alias[5]), .in0(eip[2]),  .in1(GBHR[0]));

    // //6 to 64 bit decoder used to mux out prediction from PHT
    // decodern #(.INPUT_WIDTH(6)) pred_out(.in(BP_alias), .out(out_decoder_out)); 
    
    // //wire [63:0] counter_out[1:0];
    // wire [63:0] counter_out_high, counter_out_low;

    // wire [63:0] counter_en_in, counter_en;

    // decodern #(.INPUT_WIDTH(6)) pred_in(.in(prev_BR_alias), .out(counter_en_in));

    // //PHT
    // genvar i;
    // generate
    //     for (i = 0; i < 64; i = i + 1) begin 

    //         //should only update if prev is a branch and LD is high
    //         and2$ a1(.out(counter_en[i]), .in0(counter_en_in[i]), .in1(LD_n));

    //         sat_cntr2 sat(
    //             .clk(clk),
    //             .set_n(1'b1),
    //             .rst_n(reset),
    //             .in(prev_BR_result),
    //             .enable(counter_en[i]),
    //             .s_out_high(counter_out_high[i]),
	// 	        .s_out_low(counter_out_low[i])
    //         );
    //     end

    // endgenerate

    // muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(1)) pred_out_mux(.in(counter_out_high), .sel(out_decoder_out), .out(prediction)); 

    // //muxn1_tree #(.SEL_WIDTH(6)) pred_out_mux(.in(counter_out_high), .sel(BP_alias), .out(prediction));

endmodule
