module bp_gshare (
    input clk,
    input reset,
    input [31:0] eip,
    input prev_BR_result,
    input [5:0] prev_BR_alias,
    input prev_is_BR,
    input LD,

    output prediction,
    output [5:0] BP_alias
    );

    wire [63:0] out_decoder_out;
    wire [5:0] GBHR, GBHR_shifted;
    wire LD_n;

    //6 bit GBHR: output into a shifter back into BHR
    //only shift into GBHR if LD is high and prev is a branch
    and2$ ld_and(.out(LD_n), .in0(LD), .in1(prev_is_BR));

    regn #(.WIDTH(6)) BHR(.din(GBHR_shifted),
                        .ld(LD_n), .clr(reset),
                        .clk(clk),
                        .dout(GBHR));

    lshfn_fixed #(.WIDTH(6), .SHF_AMNT(1)) m0(.in(GBHR), .shf_val(prev_BR_result), .out(GBHR_shifted));

    //6bit XOR into BP_alias - 6 bit register
    //using bits 29, 23, 17, 11, 8, 2 for the XOR
    xor2$ x0(.out(BP_alias[0]), .in0(eip[29]), .in1(GBHR_shifted[5]));
    xor2$ x1(.out(BP_alias[1]), .in0(eip[23]), .in1(GBHR_shifted[4]));
    xor2$ x2(.out(BP_alias[2]), .in0(eip[17]), .in1(GBHR_shifted[3]));
    xor2$ x3(.out(BP_alias[3]), .in0(eip[11]), .in1(GBHR_shifted[2]));
    xor2$ x4(.out(BP_alias[4]), .in0(eip[8]),  .in1(GBHR_shifted[1]));
    xor2$ x5(.out(BP_alias[5]), .in0(eip[2]),  .in1(GBHR_shifted[0]));

    //6 to 64 bit decoder used to mux out prediction from PHT
    decodern #(.INPUT_WIDTH(6)) pred_out(.in(BP_alias), .out(out_decoder_out)); 
    
    //wire [63:0] counter_out[1:0];
    wire [63:0] counter_out_high, counter_out_low;

    wire [63:0] counter_en_in, counter_en;

    decodern #(.INPUT_WIDTH(6)) pred_in(.in(prev_BR_alias), .out(counter_en_in));

    //PHT
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin 

            //should only update if prev is a branch and LD is high
            and2$ a1(.out(counter_en[i]), .in0(counter_en_in[i]), .in1(LD_n));

            sat_cntr2 sat(
                .clk(clk),
                .set_n(1'b1),
                .rst_n(reset),
                .in(prev_BR_result),
                .enable(counter_en[i]),
                .s_out_high(counter_out_high[i]),
		        .s_out_low(counter_out_low[i])
            );
        end

    endgenerate

    muxnm_tristate #(.NUM_INPUTS(64), .DATA_WIDTH(1)) pred_out_mux(.in(counter_out_high), .sel(out_decoder_out), .out(prediction)); 

    //muxn1_tree #(.SEL_WIDTH(6)) pred_out_mux(.in(counter_out_high), .sel(BP_alias), .out(prediction));

endmodule
