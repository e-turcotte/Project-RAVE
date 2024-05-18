module pmem_TOP (input [3:0] recvB,
                 input [3:0] grantB,
                 input [3:0] ackB,
    
                 input bus_clk,
                 input clr,

                 inout [72:0] BUS,
                 
                 output [3:0] freeB,
                 output [3:0] relB,
                 output [3:0] reqB);

    wire [59:0] addr;
    wire [3:0] rw;
    wire [3:0] bnk_en;
    wire [511:0] din;
    wire [511:0] dout;

    wire [3:0] des_full;
    wire [3:0] buf_des_full;
    wire [3:0] delay_des_full;
    wire [3:0] des_read, ser_read;
    wire [3:0] des_rw;
    wire [3:0] undelay_rw;
    wire [3:0] delay_rw;
    wire [3:0] ser_empty;

    wire [15:0] send;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : banks

            wire [3:0] bnkid;

            case (i)
                0: assign bnkid = 4'h8;
                1: assign bnkid = 4'h9;
                2: assign bnkid = 4'ha;
                3: assign bnkid = 4'hb;
                default: assign bnkid = 4'h0;
            endcase

            DES #(.loc(8)) d(.read(des_read[i]), .clk_bus(bus_clk), .clk_core(), .rst(clr), .set(1'b1),
                             .full(des_full[i]), .pAdr(addr[(i+1)*15-1:i*15]), .data(din[(i+1)*128-1:i*128]),
                             .return(send[3:0]), .dest(), .rw(des_rw[i]),
                             .size(),
                             .BUS(BUS),
                             .setReciever(recvB[i]),
                             .free_bau(freeB[i]));

            bufferH16$ b0(.out(buf_des_full[i]), .in(des_full[i]));
            //inv1$ g0(.out(bnk_en[i]), .in(buf_des_full[i]));
            and2$ g1(.out(undelay_rw[i]), .in0(des_rw[i]), .in1(buf_des_full[i]));
            pmem_delays35ns del35(.undelay_sig(undelay_rw[i]), .delay_sig(delay_rw[i]));
            nand2$ g2(.out(rw[i]), .in0(delay_rw[i]), .in1(buf_des_full[i]));
            pmem_delays70ns del110(.undelay_sig(buf_des_full[i]), .delay_sig(delay_des_full[i]));
            and3$ g3(.out(des_read[i]), .in0(buf_des_full[i]), .in1(delay_des_full[i]), .in2(ser_empty[i]));

            bank bnk(.addr(addr[(i+1)*15-1:i*15+6]), .rw(rw[i]), .bnk_en(buf_des_full[i]), .din(din[(i+1)*128-1:i*128]), .dout(dout[(i+1)*128-1:i*128]));

            and2$ g4(.out(ser_read[i]), .in0(des_read[i]), .in1(rw[i]));

            SER s(.clk_core(), .clk_bus(bus_clk), .rst(clr), .set(1'b1),
                  .valid_in(ser_read[i]), .pAdr_in(addr[(i+1)*15-1:i*15]), .data_in(dout[(i+1)*128-1:i*128]),
                  .dest_in(send[3:0]), .return_in(bnkid), .rw_in(1'b1),
                  .size_in(16'h8000),
                  .full_block(), .free_block(ser_empty[i]),
                  .grant(grantB[i]), .ack(ackB[i]), .releases(relB[i]), .req(reqB[i]), .BUS(BUS));
        
        end
    endgenerate

endmodule




module pmem_delays35ns(input undelay_sig,
                       output delay_sig);

    genvar i;
    generate
        wire [6:0] delay_wires;
        assign delay_wires[0] = undelay_sig;
        assign delay_sig = delay_wires[6];

        for (i = 1; i < 7; i = i + 1) begin : rw0_delay
            tristate_bus_driver1$ t0(.enbar(1'b0), .in(delay_wires[i-1]), .out(delay_wires[i]));
        end
    endgenerate

endmodule

module pmem_delays110ns(input undelay_sig,
                       output delay_sig);

    genvar i;
    generate
        wire [13:0] delay_wires;
        assign delay_wires[0] = undelay_sig;
        assign delay_sig = delay_wires[6];

        for (i = 1; i < 22; i = i + 1) begin : rw0_delay
            tristate_bus_driver1$ t0(.enbar(1'b0), .in(delay_wires[i-1]), .out(delay_wires[i]));
        end
    endgenerate

initial begin
        $readmemh("Memory/initfiles/pmem_b0c0d0.init", banks[0].bnk.bank_slices[0].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c0d1.init", banks[0].bnk.bank_slices[0].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c0d2.init", banks[0].bnk.bank_slices[0].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c0d3.init", banks[0].bnk.bank_slices[0].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c1d0.init", banks[0].bnk.bank_slices[1].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c1d1.init", banks[0].bnk.bank_slices[1].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c1d2.init", banks[0].bnk.bank_slices[1].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c1d3.init", banks[0].bnk.bank_slices[1].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c2d0.init", banks[0].bnk.bank_slices[2].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c2d1.init", banks[0].bnk.bank_slices[2].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c2d2.init", banks[0].bnk.bank_slices[2].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c2d3.init", banks[0].bnk.bank_slices[2].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c3d0.init", banks[0].bnk.bank_slices[3].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c3d1.init", banks[0].bnk.bank_slices[3].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c3d2.init", banks[0].bnk.bank_slices[3].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c3d3.init", banks[0].bnk.bank_slices[3].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c4d0.init", banks[0].bnk.bank_slices[4].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c4d1.init", banks[0].bnk.bank_slices[4].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c4d2.init", banks[0].bnk.bank_slices[4].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c4d3.init", banks[0].bnk.bank_slices[4].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c5d0.init", banks[0].bnk.bank_slices[5].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c5d1.init", banks[0].bnk.bank_slices[5].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c5d2.init", banks[0].bnk.bank_slices[5].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c5d3.init", banks[0].bnk.bank_slices[5].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c6d0.init", banks[0].bnk.bank_slices[6].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c6d1.init", banks[0].bnk.bank_slices[6].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c6d2.init", banks[0].bnk.bank_slices[6].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c6d3.init", banks[0].bnk.bank_slices[6].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c7d0.init", banks[0].bnk.bank_slices[7].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c7d1.init", banks[0].bnk.bank_slices[7].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c7d2.init", banks[0].bnk.bank_slices[7].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c7d3.init", banks[0].bnk.bank_slices[7].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c8d0.init", banks[0].bnk.bank_slices[8].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c8d1.init", banks[0].bnk.bank_slices[8].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c8d2.init", banks[0].bnk.bank_slices[8].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c8d3.init", banks[0].bnk.bank_slices[8].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c9d0.init", banks[0].bnk.bank_slices[9].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c9d1.init", banks[0].bnk.bank_slices[9].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c9d2.init", banks[0].bnk.bank_slices[9].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c9d3.init", banks[0].bnk.bank_slices[9].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c10d0.init", banks[0].bnk.bank_slices[10].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c10d1.init", banks[0].bnk.bank_slices[10].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c10d2.init", banks[0].bnk.bank_slices[10].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c10d3.init", banks[0].bnk.bank_slices[10].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c11d0.init", banks[0].bnk.bank_slices[11].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c11d1.init", banks[0].bnk.bank_slices[11].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c11d2.init", banks[0].bnk.bank_slices[11].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c11d3.init", banks[0].bnk.bank_slices[11].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c12d0.init", banks[0].bnk.bank_slices[12].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c12d1.init", banks[0].bnk.bank_slices[12].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c12d2.init", banks[0].bnk.bank_slices[12].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c12d3.init", banks[0].bnk.bank_slices[12].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c13d0.init", banks[0].bnk.bank_slices[13].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c13d1.init", banks[0].bnk.bank_slices[13].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c13d2.init", banks[0].bnk.bank_slices[13].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c13d3.init", banks[0].bnk.bank_slices[13].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c14d0.init", banks[0].bnk.bank_slices[14].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c14d1.init", banks[0].bnk.bank_slices[14].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c14d2.init", banks[0].bnk.bank_slices[14].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c14d3.init", banks[0].bnk.bank_slices[14].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c15d0.init", banks[0].bnk.bank_slices[15].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c15d1.init", banks[0].bnk.bank_slices[15].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c15d2.init", banks[0].bnk.bank_slices[15].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b0c15d3.init", banks[0].bnk.bank_slices[15].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c0d0.init", banks[1].bnk.bank_slices[0].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c0d1.init", banks[1].bnk.bank_slices[0].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c0d2.init", banks[1].bnk.bank_slices[0].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c0d3.init", banks[1].bnk.bank_slices[0].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c1d0.init", banks[1].bnk.bank_slices[1].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c1d1.init", banks[1].bnk.bank_slices[1].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c1d2.init", banks[1].bnk.bank_slices[1].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c1d3.init", banks[1].bnk.bank_slices[1].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c2d0.init", banks[1].bnk.bank_slices[2].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c2d1.init", banks[1].bnk.bank_slices[2].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c2d2.init", banks[1].bnk.bank_slices[2].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c2d3.init", banks[1].bnk.bank_slices[2].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c3d0.init", banks[1].bnk.bank_slices[3].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c3d1.init", banks[1].bnk.bank_slices[3].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c3d2.init", banks[1].bnk.bank_slices[3].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c3d3.init", banks[1].bnk.bank_slices[3].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c4d0.init", banks[1].bnk.bank_slices[4].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c4d1.init", banks[1].bnk.bank_slices[4].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c4d2.init", banks[1].bnk.bank_slices[4].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c4d3.init", banks[1].bnk.bank_slices[4].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c5d0.init", banks[1].bnk.bank_slices[5].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c5d1.init", banks[1].bnk.bank_slices[5].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c5d2.init", banks[1].bnk.bank_slices[5].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c5d3.init", banks[1].bnk.bank_slices[5].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c6d0.init", banks[1].bnk.bank_slices[6].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c6d1.init", banks[1].bnk.bank_slices[6].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c6d2.init", banks[1].bnk.bank_slices[6].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c6d3.init", banks[1].bnk.bank_slices[6].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c7d0.init", banks[1].bnk.bank_slices[7].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c7d1.init", banks[1].bnk.bank_slices[7].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c7d2.init", banks[1].bnk.bank_slices[7].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c7d3.init", banks[1].bnk.bank_slices[7].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c8d0.init", banks[1].bnk.bank_slices[8].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c8d1.init", banks[1].bnk.bank_slices[8].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c8d2.init", banks[1].bnk.bank_slices[8].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c8d3.init", banks[1].bnk.bank_slices[8].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c9d0.init", banks[1].bnk.bank_slices[9].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c9d1.init", banks[1].bnk.bank_slices[9].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c9d2.init", banks[1].bnk.bank_slices[9].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c9d3.init", banks[1].bnk.bank_slices[9].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c10d0.init", banks[1].bnk.bank_slices[10].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c10d1.init", banks[1].bnk.bank_slices[10].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c10d2.init", banks[1].bnk.bank_slices[10].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c10d3.init", banks[1].bnk.bank_slices[10].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c11d0.init", banks[1].bnk.bank_slices[11].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c11d1.init", banks[1].bnk.bank_slices[11].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c11d2.init", banks[1].bnk.bank_slices[11].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c11d3.init", banks[1].bnk.bank_slices[11].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c12d0.init", banks[1].bnk.bank_slices[12].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c12d1.init", banks[1].bnk.bank_slices[12].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c12d2.init", banks[1].bnk.bank_slices[12].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c12d3.init", banks[1].bnk.bank_slices[12].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c13d0.init", banks[1].bnk.bank_slices[13].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c13d1.init", banks[1].bnk.bank_slices[13].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c13d2.init", banks[1].bnk.bank_slices[13].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c13d3.init", banks[1].bnk.bank_slices[13].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c14d0.init", banks[1].bnk.bank_slices[14].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c14d1.init", banks[1].bnk.bank_slices[14].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c14d2.init", banks[1].bnk.bank_slices[14].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c14d3.init", banks[1].bnk.bank_slices[14].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c15d0.init", banks[1].bnk.bank_slices[15].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c15d1.init", banks[1].bnk.bank_slices[15].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c15d2.init", banks[1].bnk.bank_slices[15].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b1c15d3.init", banks[1].bnk.bank_slices[15].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c0d0.init", banks[2].bnk.bank_slices[0].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c0d1.init", banks[2].bnk.bank_slices[0].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c0d2.init", banks[2].bnk.bank_slices[0].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c0d3.init", banks[2].bnk.bank_slices[0].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c1d0.init", banks[2].bnk.bank_slices[1].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c1d1.init", banks[2].bnk.bank_slices[1].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c1d2.init", banks[2].bnk.bank_slices[1].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c1d3.init", banks[2].bnk.bank_slices[1].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c2d0.init", banks[2].bnk.bank_slices[2].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c2d1.init", banks[2].bnk.bank_slices[2].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c2d2.init", banks[2].bnk.bank_slices[2].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c2d3.init", banks[2].bnk.bank_slices[2].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c3d0.init", banks[2].bnk.bank_slices[3].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c3d1.init", banks[2].bnk.bank_slices[3].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c3d2.init", banks[2].bnk.bank_slices[3].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c3d3.init", banks[2].bnk.bank_slices[3].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c4d0.init", banks[2].bnk.bank_slices[4].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c4d1.init", banks[2].bnk.bank_slices[4].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c4d2.init", banks[2].bnk.bank_slices[4].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c4d3.init", banks[2].bnk.bank_slices[4].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c5d0.init", banks[2].bnk.bank_slices[5].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c5d1.init", banks[2].bnk.bank_slices[5].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c5d2.init", banks[2].bnk.bank_slices[5].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c5d3.init", banks[2].bnk.bank_slices[5].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c6d0.init", banks[2].bnk.bank_slices[6].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c6d1.init", banks[2].bnk.bank_slices[6].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c6d2.init", banks[2].bnk.bank_slices[6].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c6d3.init", banks[2].bnk.bank_slices[6].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c7d0.init", banks[2].bnk.bank_slices[7].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c7d1.init", banks[2].bnk.bank_slices[7].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c7d2.init", banks[2].bnk.bank_slices[7].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c7d3.init", banks[2].bnk.bank_slices[7].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c8d0.init", banks[2].bnk.bank_slices[8].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c8d1.init", banks[2].bnk.bank_slices[8].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c8d2.init", banks[2].bnk.bank_slices[8].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c8d3.init", banks[2].bnk.bank_slices[8].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c9d0.init", banks[2].bnk.bank_slices[9].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c9d1.init", banks[2].bnk.bank_slices[9].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c9d2.init", banks[2].bnk.bank_slices[9].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c9d3.init", banks[2].bnk.bank_slices[9].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c10d0.init", banks[2].bnk.bank_slices[10].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c10d1.init", banks[2].bnk.bank_slices[10].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c10d2.init", banks[2].bnk.bank_slices[10].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c10d3.init", banks[2].bnk.bank_slices[10].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c11d0.init", banks[2].bnk.bank_slices[11].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c11d1.init", banks[2].bnk.bank_slices[11].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c11d2.init", banks[2].bnk.bank_slices[11].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c11d3.init", banks[2].bnk.bank_slices[11].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c12d0.init", banks[2].bnk.bank_slices[12].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c12d1.init", banks[2].bnk.bank_slices[12].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c12d2.init", banks[2].bnk.bank_slices[12].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c12d3.init", banks[2].bnk.bank_slices[12].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c13d0.init", banks[2].bnk.bank_slices[13].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c13d1.init", banks[2].bnk.bank_slices[13].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c13d2.init", banks[2].bnk.bank_slices[13].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c13d3.init", banks[2].bnk.bank_slices[13].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c14d0.init", banks[2].bnk.bank_slices[14].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c14d1.init", banks[2].bnk.bank_slices[14].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c14d2.init", banks[2].bnk.bank_slices[14].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c14d3.init", banks[2].bnk.bank_slices[14].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c15d0.init", banks[2].bnk.bank_slices[15].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c15d1.init", banks[2].bnk.bank_slices[15].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c15d2.init", banks[2].bnk.bank_slices[15].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b2c15d3.init", banks[2].bnk.bank_slices[15].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c0d0.init", banks[3].bnk.bank_slices[0].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c0d1.init", banks[3].bnk.bank_slices[0].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c0d2.init", banks[3].bnk.bank_slices[0].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c0d3.init", banks[3].bnk.bank_slices[0].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c1d0.init", banks[3].bnk.bank_slices[1].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c1d1.init", banks[3].bnk.bank_slices[1].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c1d2.init", banks[3].bnk.bank_slices[1].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c1d3.init", banks[3].bnk.bank_slices[1].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c2d0.init", banks[3].bnk.bank_slices[2].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c2d1.init", banks[3].bnk.bank_slices[2].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c2d2.init", banks[3].bnk.bank_slices[2].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c2d3.init", banks[3].bnk.bank_slices[2].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c3d0.init", banks[3].bnk.bank_slices[3].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c3d1.init", banks[3].bnk.bank_slices[3].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c3d2.init", banks[3].bnk.bank_slices[3].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c3d3.init", banks[3].bnk.bank_slices[3].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c4d0.init", banks[3].bnk.bank_slices[4].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c4d1.init", banks[3].bnk.bank_slices[4].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c4d2.init", banks[3].bnk.bank_slices[4].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c4d3.init", banks[3].bnk.bank_slices[4].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c5d0.init", banks[3].bnk.bank_slices[5].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c5d1.init", banks[3].bnk.bank_slices[5].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c5d2.init", banks[3].bnk.bank_slices[5].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c5d3.init", banks[3].bnk.bank_slices[5].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c6d0.init", banks[3].bnk.bank_slices[6].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c6d1.init", banks[3].bnk.bank_slices[6].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c6d2.init", banks[3].bnk.bank_slices[6].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c6d3.init", banks[3].bnk.bank_slices[6].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c7d0.init", banks[3].bnk.bank_slices[7].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c7d1.init", banks[3].bnk.bank_slices[7].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c7d2.init", banks[3].bnk.bank_slices[7].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c7d3.init", banks[3].bnk.bank_slices[7].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c8d0.init", banks[3].bnk.bank_slices[8].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c8d1.init", banks[3].bnk.bank_slices[8].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c8d2.init", banks[3].bnk.bank_slices[8].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c8d3.init", banks[3].bnk.bank_slices[8].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c9d0.init", banks[3].bnk.bank_slices[9].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c9d1.init", banks[3].bnk.bank_slices[9].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c9d2.init", banks[3].bnk.bank_slices[9].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c9d3.init", banks[3].bnk.bank_slices[9].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c10d0.init", banks[3].bnk.bank_slices[10].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c10d1.init", banks[3].bnk.bank_slices[10].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c10d2.init", banks[3].bnk.bank_slices[10].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c10d3.init", banks[3].bnk.bank_slices[10].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c11d0.init", banks[3].bnk.bank_slices[11].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c11d1.init", banks[3].bnk.bank_slices[11].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c11d2.init", banks[3].bnk.bank_slices[11].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c11d3.init", banks[3].bnk.bank_slices[11].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c12d0.init", banks[3].bnk.bank_slices[12].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c12d1.init", banks[3].bnk.bank_slices[12].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c12d2.init", banks[3].bnk.bank_slices[12].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c12d3.init", banks[3].bnk.bank_slices[12].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c13d0.init", banks[3].bnk.bank_slices[13].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c13d1.init", banks[3].bnk.bank_slices[13].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c13d2.init", banks[3].bnk.bank_slices[13].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c13d3.init", banks[3].bnk.bank_slices[13].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c14d0.init", banks[3].bnk.bank_slices[14].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c14d1.init", banks[3].bnk.bank_slices[14].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c14d2.init", banks[3].bnk.bank_slices[14].dram.cells[2].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c14d3.init", banks[3].bnk.bank_slices[14].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c15d0.init", banks[3].bnk.bank_slices[15].dram.cells[0].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c15d1.init", banks[3].bnk.bank_slices[15].dram.cells[1].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c15d3.init", banks[3].bnk.bank_slices[15].dram.cells[3].sram.mem);
        $readmemh("Memory/initfiles/pmem_b3c15d2.init", banks[3].bnk.bank_slices[15].dram.cells[2].sram.mem);
    end

endmodule