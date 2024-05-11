module dramcell (input [4:0] addr,
                 input rw, ce,
                 inout [127:0] dio);

    wire rd, wr;

    inv1$ g0(.out(rd), .in(rw));
    assign wr = rw;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cells
            sram32x32$ sram(.A(addr), .DIO(dio[(i+1)*32-1:i*32]), .OE(rd), .WR(wr), .CE(ce));
        end
    endgenerate

endmodule