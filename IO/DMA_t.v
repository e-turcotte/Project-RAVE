module DMA_t();
localparam CYCLE_TIME = 12.0;
reg clk, rst, set;
    
    //DES
    wire read_d;

    reg full_d;
    reg [14:0] pAdr_d;
    reg [127:0] data_d;
    reg [3:0]return_d;
    reg [3:0] dest_d;
    reg rw_d;
    reg [15:0] size_d;
    //SE;
    wire valid_s;
    wire [14:0] pAdr_s;
    wire [16*8-1:0] data_s;
    wire [3:0] dest_s;
    wire [3:0]return_s;
    wire rw_s;
    wire [15:0] size_s;
    
    reg full_block_s;
    reg free_block_s;
    //DIS;
    wire [127:0] data_disc;
    wire finished_disc;
    wire [32:0] adr_disc;
    //KEYBOAR;
    wire [7:0] data_kb;
    wire read_kb;
    //COR;
    wire interrupt_core;

    reg valid_in_kb;
    reg[7:0] data_in_kb;

initial begin
    rst = 0; set = 1; 
    full_d = 0;
    pAdr_d = 0;
    data_d = 0;
    return_d = 0;
    dest_d = 0;
    rw_d = 0;
    size_d = 0;
    
    valid_in_kb =0;
    data_in_kb = 0;

    full_block_s = 0;
    free_block_s = 1;
    #CYCLE_TIME
    #CYCLE_TIME

    valid_in_kb = 1;
    data_in_kb = 8'hBE;
    rst = 1;
    #CYCLE_TIME

    full_d = 1;

    pAdr_d = 15'h1010;
    data_d = 32'h4;
    rw_d = 1;
    size_d = 16'h8000;
    return_d = 4'b0100;
    dest_d = 4'b1100;

    #CYCLE_TIME
    pAdr_d = 15'h1020;
    data_d = 15'h2000;

    #CYCLE_TIME
    pAdr_d = 15'h1030;
    data_d = 15'h0101;

    #CYCLE_TIME
    pAdr_d = 15'h1040;
    data_d = 15'h0001;

    #CYCLE_TIME
    data_d = 15'h1FFF;
    pAdr_d = 15'h1030;
    full_d = 0;
    free_block_s = 0;

    #1000
    
    #CYCLE_TIME
    #CYCLE_TIME
    free_block_s = 1;
    #CYCLE_TIME
    full_d = 1;
    data_d = 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA;
    #CYCLE_TIME
    #3000
    #CYCLE_TIME
    $finish;

end

initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
 $vcdplusfile("DMA.vpd");
 $vcdpluson(0, DMA_t); 
end

disc disc1(
.clk(clk), 
.adr_disc(adr_disc),
.finished_disc(finished_disc),
.data_disc(data_disc),
.rst(rst),
.read_disc(read_disc)
);

kb kb1(
    .clk(clk),
    .rst(rst),
    .data_kb(data_kb),
    .read_kb(read_kb),

);

DMA DMA1 (
    .clk(clk),
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

// wire [31:0] eip;
// wire [31:0] eip_le;

// assign eip_le[31:24] = eip[7:0];
// assign eip_le[23:16] = eip[15:8];
// assign eip_le[15:8] = eip[23:16];
// assign eip_le[7:0] = eip[31:24]