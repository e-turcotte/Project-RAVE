module offcore_t();
localparam CYCLE_TIME = 12.0;
localparam CYCLE_TIME_BUS = 8;
reg clk,clk_bus, rst, set;

wire[72:0] BUS;
reg[3:0]destIE, destIO, destDEr, destDEw, destDOr, destDOw;

wire reqIE, reqIO;
wire [3:0] destIE, destIO;
wire freeIE, freeIO;
wire relIE, relIO;

wire ackIE, ackIO,
wire grantIE, grantIO,
wire recvIE, recvIO,

offcoreBus_TOP ocbt(
.clk(clk),
.rst(rst),
.set(set),
.clk_bus(clk_bus),
.freeIE(freeIE),  .freeIO(freeIO),  .freeDE(1'b1),  .freeDO(1'b1),
.reqIE(reqIE),   .reqIO(reqIO),   .reqDEr(1'b1),  .reqDEw(1'b1),  .reqDOr(1'b1),  .reqDOw(1'b0),
.relIE(relIE),   .relIO(relIO),   .relDEr(1'b0),  .relDEw(1'b0),  .relDOr(1'b0),  .relDOw(1'b0),
.destIE(destIE),  .destIO(destIO),  .destDEr(4'd0), .destDEw(4'd0), .destDOr(4'd0), .destDOw(4'd0),
.BUS(BUS),
.ackIE(ackIE),   .ackIO(ackIO),   .ackDEr(1'b0),  .ackDEw(1'b0),  .ackDOr(1'b0),  .ackDOw(1'b0),
.grantIE(grantIE), .grantIO(grantIO), .grantDEr(1'b0),.grantDEw(1'b0),.grantDOr(1'b0),.grantDOw(1'b0),
.recvIE(recvIE),  .recvIO(recvIO),  .recvDE(1'b0),  .recvDO(1'b0)
);

module DES #(parameter loc = 0) (
    //From block input
    .read(),
    .clk_bus(),
    .clk_core(),
    .rst,(),
    .set(),
    .full(),
    .pAdr(),
    .data(),
    .return(),
    .dest(),
    .rw(),
    .size(),
    .BUS(),
    .setReciever(),
    .free_bau(),

    
);




initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
    clk_bus = 1'b1;
    forever #(CYCLE_TIME_BUS / 2.0) clk_bus = ~clk_bus;
end

initial begin
 $vcdplusfile("offcore.vpd");
 $vcdpluson(0, offcore_t); 
end




endmodule