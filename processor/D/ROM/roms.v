module rom (
    input [7:0] addr,
    output [255:0] data
);
    wire [7:0] row_activation;
    wire [7:0] row_activation_bar;
    wire[255:0] out [7:0];
    decoder3_8$ decoder(.SEL(addr[7:5]), .Y(row_activation), .YBAR(row_activation_bar));
    
    generate
        genvar i, j;
        for (i = 0; i < 8; i = i + 1) begin : ROM_GEN
            for(j = 0; j < 8; j = j + 1) begin : width_ROM_GEN
                rom32b32w$ ROM(
                    .A(addr[4:0]),
                    .OE(row_activation[i]),
                    .DOUT(out[i][j*32 +: 31])
                );
            end
        end
    endgenerate

    muxnm_tristate #(
        .NUM_INPUTS(8),
        .DATA_WIDTH(256)
    ) mux(
        .in({out[7], out[6], out[5], out[4], out[3], out[2], out[1], out[0]}),
        .sel(row_activation),
        .out(data)
    );

endmodule

