module offcoreBus_TOP(
    input clk, rst, set,
    input clk_bus,
    
    input freeIE, freeIO, freeDE, freeDO,
    input reqIE, reqIO, reqDEr, reqDEw, reqDOr, reqDOw,
    input relIE, relIO, relDEr, relDEw, relDOr, relDOw,

    input [3:0] destIE, destIO, destDEr, destDEw, destDOr, destDOw,

    inout [72:0] BUS,

    output ackIE, ackIO, ackDEr, ackDEw, ackDOr, ackDOw,
    output grantIE, grantIO, grantDEr, grantDEw, grantDOr, grantDOw,
    output recvIE, recvIO, recvDE, recvDO
);

    wire reqB0, reqB1, reqB2, reqB3, reqDMA;
    wire [3:0]  destB0, destB1, destB2, destB3, destDMA;
    wire freeB0, freeB1, freeB2, freeB3, freeDMA;
    wire relB0, relB1, relB2, relB3, relDMA;

    wire  ackB0, ackB1, ackB2, ackB3, ackDMA;
    wire  grantB0, grantB1, grantB2, grantB3, grantDMA;
    wire  recvB0, recvB1, recvB2, recvB3, recvDMA;

bus_TOP bus(
    reqIE, reqIO, reqDEr, reqDEw, reqDOr, reqDOw, reqB0, reqB1, reqB2, reqB3, reqDMA,
    destIE, destIO, destDEr, destDEw, destDOr, destDOw, destB0, destB1, destB2, destB3, destDMA,
    freeIE, freeIO, freeDE, freeDO, freeB0, freeB1, freeB2, freeB3, freeDMA,
    relIE, relIO, relDEr, relDEw, relDOr, relDOw, relB0, relB1, relB2, relB3, relDMA,

    clk_bus, rst,

    BUS,

    ackIE, ackIO, ackDEr, ackDEw, ackDOr, ackDOw, ackB0, ackB1, ackB2, ackB3, ackDMA,
    grantIE, grantIO, grantDEr, grantDEw, grantDOr, grantDOw, grantB0, grantB1, grantB2, grantB3, grantDMA,
    recvIE, recvIO, recvDE, recvDO, recvB0, recvB1, recvB2, recvB3, recvDMA
    );


IO_top io(
    .clk_bus(clk_bus), 
    .set(set), 
    .rst(rst),

    //from bus input
    .BUS(BUS),

    //BAU-DES
    .setReciever_io(recvDMA),
    .free_bau_io(freeDMA),
    //BAU-SE(),
    .grant_io(grantDMA),
    .ack_io(ackDMA),

    .releases_io(relDMA),
    .req_io(reqDMA)
);

pmem_TOP  pmem(
    .recvB({recvB3, recvB2, recvB1,recvB0}),
    .grantB({grantB3, grantB2, grantB1,grantB0}),
    .ackB({ackB3, ackB2, ackB1,ackB0}),
    .bus_clk(bus_clk),
    .clr(rst),
    .BUS(BUS),

    .freeB({freeB3, freeB2, freeB1,freeB0}),
    .relB({relB3, relB2, relB1,relB0}),
    .reqB({reqB3, reqB2, reqB1,reqB0})
);


endmodule