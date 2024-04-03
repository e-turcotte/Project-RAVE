module decodern #(parameter INPUT_WIDTH=3) (input [INPUT_WIDTH-1:0] in,
                                            output [(2**INPUT_WIDTH)-1:0] out);

    wire [INPUT_WIDTH-1:0] invin;
    wire [INPUT_WIDTH*(2**INPUT_WIDTH)-1:0] codevector;

    genvar i, j;
    generate
        for (i = 0; i < INPUT_WIDTH; i = i + 1) begin : invin_wires
            inv1$ g0(.out(invin[i]), .in(in[i]));
        end
        for (i = 0; i < 2**INPUT_WIDTH; i = i + 1) begin : decoder_slices
            for (j = 0; j < INPUT_WIDTH; j = j + 1) begin : decoder_factors
                if (i & (2**j)) begin
                    assign codevector[(i*INPUT_WIDTH)+j] = in[j];
                end else begin
                    assign codevector[(i*INPUT_WIDTH)+j] = invin[j];
                end
            end
            andn #(.NUM_INPUTS(INPUT_WIDTH)) m0(.in(codevector[(i+1)*INPUT_WIDTH-1:i*INPUT_WIDTH]), .out(out[i]));
        end
    endgenerate

endmodule