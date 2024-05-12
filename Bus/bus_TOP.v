module bus_TOP(input reqIE, reqIO, reqDEr, reqDEw, reqDOr, reqDOw, reqB0, reqB1, reqB2, reqB3, reqDMA,
               input [3:0] destIE, destIO, destDEr, destDEw, destDOr, destDOw, destB0, destB1, destB2, destB3, destDMA,
               input freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA,
               input relIE, relIO, relDEr, relDEw, relDOr, relDOw, relB0, relB1, relB2, relB3, relDMA,

               input clk, clr,

               inout [72:0] BUS,

               output ackIE, ackIO, ackDEr, ackDEw, ackDOr, ackDOw, ackB0, ackB1, ackB2, ackB3, ackDMA,
               output grantIE, grantIO, grantDEr, grantDEw, grantDOr, grantDOw, grantB0, grantB1, grantB2, grantB3, grantDMA,
               output recvIE, recvIO, recvDE, recvDO, recvB0, recvB1, recvB2, recvB3, recvDMA);

    wire [87:0] req_data;
    wire [10:0] req, ack;
    
    genvar i;
    generate
        for (i = 0; i < 11; i = i + 1) begin : arb_order
            case (i)
                9:  begin //I$ even read - 0x0
                        assign req_data[(i+1)*8-1:i*8] = {4'h0,destIE};
                        assign req[i] = reqIE;
                        assign ackIE = ack[i];
                    end
                8:  begin //I$ odd read - 0x1
                        assign req_data[(i+1)*8-1:i*8] = {4'h1,destIO};
                        assign req[i] = reqIO;
                        assign ackIO = ack[i];
                    end
                7:  begin //D$ even read - 0x4
                        assign req_data[(i+1)*8-1:i*8] = {4'h4,destDEr};
                        assign req[i] = reqDEr;
                        assign ackDEr = ack[i];
                    end
                6:  begin //D$ odd read - 0x6
                        assign req_data[(i+1)*8-1:i*8] = {4'h6,destDEw};
                        assign req[i] = reqDEw;
                        assign ackDEw = ack[i];
                    end
                5:  begin //D$ even write - 0x5
                        assign req_data[(i+1)*8-1:i*8] = {4'h5,destDOr};
                        assign req[i] = reqDOr;
                        assign ackDOr = ack[i];
                    end
                4:  begin //D$ odd write - 0x7
                        assign req_data[(i+1)*8-1:i*8] = {4'h7,destDOw};
                        assign req[i] = reqDOw;
                        assign ackDOw = ack[i];
                    end
                3:  begin //bank0 - 0x8
                        assign req_data[(i+1)*8-1:i*8] = {4'h8,destB0};
                        assign req[i] = reqB0;
                        assign ackB0 = ack[i];
                    end
                2:  begin //bank1 - 0x9
                        assign req_data[(i+1)*8-1:i*8] = {4'h9,destB1};
                        assign req[i] = reqB1;
                        assign ackB1 = ack[i];
                    end
                1:  begin //bank2 - 0xA
                        assign req_data[(i+1)*8-1:i*8] = {4'ha,destB2};
                        assign req[i] = reqB2;
                        assign ackB2 = ack[i];
                    end
                0:  begin //bank3 - 0xB
                        assign req_data[(i+1)*8-1:i*8] = {4'hb,destB3};
                        assign req[i] = reqB3;
                        assign ackB3 = ack[i];
                    end
                10: begin //DMA+IO - 0xC
                        assign req_data[(i+1)*8-1:i*8] = {4'hc,destDMA};
                        assign req[i] = reqDMA;
                        assign ackDMA = ack[i];
                    end
                default: begin end
            endcase
        end
    endgenerate

    wire [3:0] send, dest;
    wire qready, pullfromq;

    brq q0(.req_data(req_data), .req(req),
           .freeIE(freeIE), .freeIO(freeIO), .freeDE(freeDE), .freeDO(freeDO),
           .freeB0(freeB0), .freeB1(freeB1), .freeB2(freeB2), .freeB3(freeB3),
           .freeDMA(freeDMA),
           .pull(pullfromq), .clk(clk), .clr(clr),
           .ack(ack),
           .req_ready(qready), .send_out(send), .dest_out(dest));
    
    bau a0(.sender(send), .dest(dest), .req_ready(qready),
           .relIE(relIE), .relIO(relIO),
           .relDEr(relDEr), .relDEw(relDEw), .relDOr(relDOr), .relDOw(relDOw),
           .relB0(relB0), .relB1(relB1), .relB2(relB2), .relB3(relB3),
           .relDMA(relDMA),
           .clr(clr), .clk(clk), .pull(pullfromq),
           .grantIE(grantIE), .grantIO(grantIO),
           .grantDEr(grantDEr), .grantDEw(grantDEw), .grantDOr(grantDOr), .grantDOw(grantDOw),
           .grantB0(grantB0), .grantB1(grantB1), .grantB2(grantB2), .grantB3(grantB3),
           .grantDMA(grantDMA),
           .recvIE(recvIE), .recvIO(recvIO), .recvDE(recvDE), .recvDO(recvDO),
           .recvB0(recvB0), .recvB1(recvB1), .recvB2(recvB2), .recvB3(recvB3),
           .recvDMA(recvDMA));

endmodule