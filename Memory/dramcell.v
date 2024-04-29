module dramcell (input [4:0] addr,
                 input rw, ce,
                 inout [127:0] dio);

    wire rd, wr;

    inv1$ g0(.out(rd), .in(rw));
    assign wr = rw;

    sram32x32$ sram0(.A(addr), .DIO(dio[31:0]), .OE(rd), .WR(wr), .CE(ce));
    sram32x32$ sram1(.A(addr), .DIO(dio[63:32]), .OE(rd), .WR(wr), .CE(ce));
    sram32x32$ sram2(.A(addr), .DIO(dio[95:64]), .OE(rd), .WR(wr), .CE(ce));
    sram32x32$ sram3(.A(addr), .DIO(dio[127:96]), .OE(rd), .WR(wr), .CE(ce));

endmodule