module bp_gshare (
    input clk,
    input set,
    input reset,
    input [31:0] eip,
    input prev_BR_result,
    input [5:0] prev_BR_alias,
    input prev_is_BR,
    output prediction,
    output [5:0] BP_alias_out
);

    wire [63:0] out_decoder_out;
    wire [5:0] BP_alias, BP_alias_out, GBHR, GBHR_shifted;

    //6 bit GBHR: output into a shifter back into BHR
    regn #(.WIDTH(6)) BHR(.din(GBHR_shifted),
                        .ld(set), clr(reset),
                        .clk(clk),
                        .dout(GBHR));

    lshfn_fixed #(.WIDTH(6), .SHF_AMNT(1)) m0(.in(GBHR), .shf_val(prev_BR_result),.out(GBHR_shifted));

    //6bit XOR into BP_alias 6 bit register
    //using bits 29, 23, 17, 11, 8, 2 for the XOR

    xor2$ (.out(BP_alias[0]), .in0(eip[29]), .in1(GBHR[5]));
    xor2$ (.out(BP_alias[1]), .in0(eip[23]), .in1(GBHR[4]));
    xor2$ (.out(BP_alias[2]), .in0(eip[17]), .in1(GBHR[3]));
    xor2$ (.out(BP_alias[3]), .in0(eip[11]), .in1(GBHR[2]));
    xor2$ (.out(BP_alias[4]), .in0(eip[8]),  .in1(GBHR[1]));
    xor2$ (.out(BP_alias[5]), .in0(eip[2]),  .in1(GBHR[0]));

    regn #(.WIDTH(6)) BP_alias_reg(.din(BP_alias),
                        .ld(set), clr(reset),
                        .clk(clk),
                        .dout(BP_alias_out));

    //6 to 64 bit decoder used to mux out prediction from PHT
    decodern #(.INPUT_WIDTH(6)) pred_out(.in(BP_alias_out), .out(out_decoder_out)); 
    
    wire [1:0] counter_out[63:0];
    wire counter_en_in[63:0];

    decodern #(.INPUT_WIDTH(6)) pred_in(.in(prev_BR_alias), .out(counter_en_in));

    //PHT
    generate
        for (i = 0; i < 64; i = i + 1) begin : 
            sat_cntr2$ cntr[i](
                .clk(clk),
                .set_n(set),
                .rst_n(reset),
                .in(prev_BR_result),
                .enable(counter_en_in[i])
                .s_out(counter_out[i])
            );
        end
    endgenerate

    //mux out prediction
    wire mux_pred_out;
    
    muxn1_tristate #(.NUM_INPUTS(6)) pred_out_mux(.in(counter_out[63:0][1]), .sel(out_decoder_out), .out(mux_pred_out));
    and2$ g0(.out(prediction), .in0(mux_pred_out), .in1(prev_is_BR));

endmodule