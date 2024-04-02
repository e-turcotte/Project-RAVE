module rshfn_fixed #(parameter WIDTH=8, SHF_AMNT=0) (input [WIDTH-1:0] in,
                                                     input [SHF_AMNT-1:0] shf_in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = SHF_AMNT; i < WIDTH; i = i + 1) begin : rshf_fixed_slices
            assign out[i-SHF_AMNT] = in[i];
        end
        if (SHF_AMNT > 0) begin
            assign out[WIDTH-1:WIDTH-SHF_AMNT] = shf_in;
        end
    endgenerate

endmodule

module lshfn_fixed #(parameter WIDTH=8, SHF_AMNT=0) (input [WIDTH-1:0] in,
                                                     input [SHF_AMNT-1:0] shf_in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = SHF_AMNT; i < WIDTH; i = i + 1) begin : lshf_fixed_slices
            assign out[i] = in[i-SHF_AMNT];
        end
        if (SHF_AMNT > 0) begin
            assign out[SHF_AMNT-1:0] = shf_in;
        end
    endgenerate

endmodule




module rrotn_fixed #(parameter WIDTH=8, ROT_AMNT=0) (input [WIDTH-1:0] in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = ROT_AMNT; i < WIDTH; i = i + 1) begin : rrot_fixed_slices
            assign out[i-ROT_AMNT] = in[i];
        end
        if (ROT_AMNT > 0) begin
            assign out[WIDTH-1:WIDTH-ROT_AMNT] = in[ROT_AMNT-1:0];
        end
    endgenerate

endmodule

module lrotn_fixed #(parameter WIDTH=8, ROT_AMNT=0) (input [WIDTH-1:0] in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = ROT_AMNT; i < WIDTH; i = i + 1) begin : lrot_fixed_slices
            assign out[i] = in[i-ROT_AMNT];
        end
        if (ROT_AMNT > 0) begin
            assign out[ROT_AMNT-1:0] = in[WIDTH-1:WIDTH-ROT_AMNT];
        end
    endgenerate

endmodule