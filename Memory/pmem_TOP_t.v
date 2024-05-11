module TOP;

    reg [3:0] recvB, grantB, ackB;
    reg bus_clk, clr;
    wire [72:0] BUS;
    wire [3:0] freeB, relB, reqB;

    pmem_TOP pm(.recvB(recvB), .grantB(grantB), .ackB(ackB), .bus_clk(bus_clk), .clr(clr),
                .BUS(BUS), .freeB(freeB), .relB(relB), .reqB(reqB));

    integer b, c, d;
    initial begin
        for (b = 0; b < 4; b = b + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                for (d = 0; d < 4; d = d + 1) begin
                    $readmemh($sformatf("initfiles/pmem_b%dc%dd%d.init", b, c, d), pm.banks[b].bnk.bank_slices[c].dram.cells[d].sram.mem); 
                end
            end
        end
    end

endmodule