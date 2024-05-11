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
    wire [3:0] des_read;
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
            inv1$ g0(.out(bnk_en[i]), .in(buf_des_full[i]));
            and2$ g1(.out(undelay_rw[i]), .in0(des_rw[i]), .in1(buf_des_full[i]));
            pmem_delays35ns del35(.undelay_sig(undelay_rw[i]), .delay_sig(delay_rw[i]));
            nand2$ g2(.out(rw[i]), .in0(delay_rw[i]), .in1(buf_des_full[i]));
            pmem_delays70ns del70(.undelay_sig(buf_des_full[i]), .delay_sig(delay_des_full[i]));
            and3$ g3(.out(des_read[i]), .in0(buf_des_full[i]), .in1(delay_des_full[i]), .in2(ser_empty[i]));

            bank bnk(.addr(addr[(i+1)*15-1:i*15+6]), .rw(rw[i]), .bnk_en(bnk_en[i]), .din(din[(i+1)*128-1:i*128]), .dout(dout[(i+1)*128-1:i*128]));

            SER s(.clk_core(), .clk_bus(bus_clk), .rst(clr), .set(1'b1),
                  .valid_in(rw[i]), .pAdr_in(addr[(i+1)*15-1:i*15]), .data_in(dout[(i+1)*128-1:i*128]),
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

module pmem_delays70ns(input undelay_sig,
                       output delay_sig);

    genvar i;
    generate
        wire [13:0] delay_wires;
        assign delay_wires[0] = undelay_sig;
        assign delay_sig = delay_wires[6];

        for (i = 1; i < 14; i = i + 1) begin : rw0_delay
            tristate_bus_driver1$ t0(.enbar(1'b0), .in(delay_wires[i-1]), .out(delay_wires[i]));
        end
    endgenerate

endmodule