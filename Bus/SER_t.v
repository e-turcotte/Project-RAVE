module SER_t();
localparam CYCLE_TIME_BUS = 18.0;
localparam CYCLE_TIME_CORE = 12.0;
   reg clk_core;
reg clk_bus;

initial begin
    clk_core = 1'b1;
    forever #(CYCLE_TIME_BUS / 2.0) clk_core = ~clk_core;
end
initial begin
    clk_bus = 1'b1;
    forever #(CYCLE_TIME_CORE / 2.0) clk_bus = ~clk_bus;
end

initial begin
 $vcdplusfile("SER.vpd");
 $vcdpluson(0, SER_t); 
end

reg read;
reg rst, set;
reg valid_in;
reg [14:0] pAdr_in;
reg [16*8-1:0] data_in;
reg [3:0] dest_in;
reg [3:0]return_in;
reg rw_in;
reg [15:0] size_in;
reg setReciever;

wire full_block;
wire free_block;
//From bau inpu;
reg grant;
reg ack;
//to bau outpu;
wire releases;
wire req;
//to BUS outpu;
wire valid_bus;
wire [14:0] pAdr_bus;
wire [31:0] data_bus;
wire [3:0]return_bus;
wire [3:0] dest_bus;
wire rw_bus;
wire [15:0] size_bus;

wire full;
wire [14:0] pAdr;
wire [16*8-1:0] data;
wire [3:0]return;
wire [3:0] dest;
wire rw;
wire [15:0] size;
wire free_bau;

SER SER_instance (
    .clk_core(clk_core),
    .clk_bus(clk_bus),
    .rst(rst),
    .set(set),
    .valid_in(valid_in),
    .pAdr_in(pAdr_in),
    .data_in(data_in),
    .dest_in(dest_in),
    .return_in(return_in),
    .rw_in(rw_in),
    .size_in(size_in),
    .full_block(full_block),
    .free_block(free_block),
    .grant(grant),
    .ack(ack),
    .releases(releases),
    .req(req),
    .valid_bus(valid_bus),
    .pAdr_bus(pAdr_bus),
    .data_bus(data_bus),
    .return_bus(return_bus),
    .dest_bus(dest_bus),
    .rw_bus(rw_bus),
    .size_bus(size_bus)
);

DES #(4'b0101) DES_instance (
    .read(read),
    .clk_bus(clk_bus),
    .clk_core(clk_core),
    .rst(rst),
    .set(set),
    .full(full),
    .pAdr(pAdr),
    .data(data),
    .return(return),
    .dest(dest),
    .rw(rw),
    .size(size),
    .valid_bus(valid_bus),
    .pAdr_bus(pAdr_bus),
    .data_bus(data_bus),
    .return_bus(return_bus),
    .dest_bus(dest_bus),
    .rw_bus(rw_bus),
    .size_bus(size_bus),
    .free_bau(free_bau),
    .setReciever(setReciever)
);

initial begin
    read = 0;
    set = 1;
    ack = 0; grant = 0;
    rst = 0;
    valid_in = 0;
    setReciever = 0;
    #CYCLE_TIME_CORE
    rst = 1;
    valid_in = 1;
    pAdr_in = 15'h7A7A;
    data_in = 128'hABCD_1234_5678_9ABC_DEF0_7575_8484_9090;
    dest_in = 4'b0101;
    return_in = 4'b0001;
    rw_in = 1;
    size_in = 16'h8000;
    #CYCLE_TIME_CORE
    #CYCLE_TIME_BUS
    valid_in = 0;
    ack = 1;

    #CYCLE_TIME_CORE
    ack = 0;
    #CYCLE_TIME_BUS
    grant = 1;
    setReciever =1;
        #CYCLE_TIME_CORE
    #CYCLE_TIME_BUS
    setReciever = 0;
        #CYCLE_TIME_CORE
    #CYCLE_TIME_BUS
        #CYCLE_TIME_CORE
    read = 1;
    #CYCLE_TIME_BUS
        #CYCLE_TIME_CORE
        read = 0;
    #CYCLE_TIME_BUS

    valid_in = 1;
    #CYCLE_TIME_CORE
    #CYCLE_TIME_BUS
    ack = 1;
    #CYCLE_TIME_BUS
    grant =1; ack =0; valid_in = 0;
    #CYCLE_TIME_CORE
    #CYCLE_TIME_BUS

    $finish;



end

endmodule