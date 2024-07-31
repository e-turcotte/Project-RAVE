module IO_top(
    input clk_bus, clk_core,
    set, 
    rst,

    //from bus input
    inout [72:0] BUS,

    //BAU-DES
    input setReciever_io,
    output free_bau_io,

    //BAU-SER
    input grant_io,
    input ack_io,
    output releases_io,
    output req_io,
    output [3:0] dest_io,
    output interrupt_core
);





 //DES
    wire read_d;

    wire full_d;
    wire [14:0] pAdr_d;
    wire [127:0] data_d;
    wire [3:0]return_d;
    wire [3:0] dest_d;
    wire rw_d;
    wire [15:0] size_d;
    //SE;
    wire valid_s;
    wire [14:0] pAdr_s;
    wire [16*8-1:0] data_s;
    wire [3:0] dest_s;
    wire [3:0]return_s;
    wire rw_s;
    wire [15:0] size_s;
    
    wire full_block_s;
    wire free_block_s;
    //DIS;
    wire [127:0] data_disc;
    wire finished_disc;
    wire [32:0] adr_disc;
    //KEYBOAR;
    wire [7:0] data_kb;
    wire read_kb;
    //COR;
    //wire interrupt_core;

    reg valid_in_kb;
    reg[7:0] data_in_kb;

SER ioSER(
    .clk_core(clk_core),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(valid_s),
    .pAdr_in(pAdr_s),
    .data_in(data_s),
    .dest_in(dest_s),
    .return_in(return_s),
    .rw_in(rw_s),
    .size_in(size_s),
    .full_block(full_block_s),
    .free_block(free_block_s),
    .grant(grant_io),
    .ack(ack_io),
    .releases(releases_io),
    .req(req_io),
    .BUS(BUS),
    .dest_bau(dest_io)
);  

DES ioDES(
    .read(read_d),
    .clk_bus(clk_bus),
    .clk_core(clk_core),
    .rst(rst),
    .set(set),
    .full(full_d),
    .pAdr(pAdr_d),
    .data(data_d),
    .return(return_d),
    .dest(dest_d),
    .rw(rw_d),
    .size(size_d),
    .BUS(BUS),
    .setReciever(setReciever_io),
    .free_bau(free_bau_io)
);

disc disc1(
    .clk(clk_bus), 
    .adr_disc(adr_disc),
    .finished_disc(finished_disc),
    .data_disc(data_disc),
    .rst(rst),
    .read_disc(read_disc)
);

kb kb1(
    .clk(clk_bus),
    .rst(rst),
    .data_kb(data_kb),
    .read_kb(read_kb)
);

DMA DMA1 (
     .clk(clk_bus),
    .set(set),
    .rst(rst),

    .read_d(read_d),
    .full_d(full_d),
    .pAdr_d(pAdr_d),
    .data_d(data_d),
    .return_d(return_d),
    .dest_d(dest_d),
    .rw_d(rw_d),
    .size_d(size_d),

    .valid_s(valid_s),
    .pAdr_s(pAdr_s),
    .data_s(data_s),
    .dest_s(dest_s),
    .return_s(return_s),
    .rw_s(rw_s),
    .size_s(size_s),
    .full_block_s(full_block_s),
    .free_block_s(free_block_s),

    .data_disc(data_disc),
    .finished_disc(finished_disc),
    .adr_disc(adr_disc),
    .read_disc(read_disc),

    .data_kb(data_kb),
    .read_kb(read_kb),

    .interrupt_core(interrupt_core)
);

endmodule