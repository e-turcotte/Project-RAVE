module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [29:0] rd_pAddress, sw_pAddress, wb_pAddress, bus_pAddress;
    reg [16*16-1:0] wb_data, bus_data;
    reg [3:0] rd_size, sw_size, wb_size;
    reg [1:0] rd_valid, sw_valid, wb_valid, bus_valid;
    reg [16*16-1:0] wb_mask;
    reg [6:0] rd_ptcid, sw_ptcid, wb_ptcid;
    reg rd_oig, sw_oig, wb_oig;
    reg rd_np1, sw_np1, wb_np1;
    reg [2:0] rd_os, sw_os, wb_os;
    reg rd_pcd, sw_pcd, wb_pcd, bus_pcd;
    reg bus_isempty;
    reg read, rd_write, sw_write, wb_write;
    reg clr;
    wire [29:0] pAddress;
    wire [16*16-1:0] data;
    wire [3:0] size;
    wire r, w, sw;
    wire [1:0] valid;
    wire fromBUS;
    wire [16*16-1:0] mask;
    wire [6:0] ptcid;
    wire oig;
    wire [2:0] os;
    wire pcd;
    wire aqempty, rdaqfull, swaqfull, wbaqfull; 
    reg clk;

    cacheaqsys caqsys(.rd_pAddress_e(rd_pAddress[29:15]), .rd_pAddress_o(rd_pAddress[14:0]),
                      .sw_pAddress_e(sw_pAddress[29:15]), .sw_pAddress_o(sw_pAddress[14:0]),
                      .wb_pAddress_e(wb_pAddress[29:15]), .wb_pAddress_o(wb_pAddress[14:0]),
                      .bus_pAddress_e(bus_pAddress[29:15]), .bus_pAddress_o(bus_pAddress[14:0]),
                      .wb_data_e(wb_data[16*16-1:16*8]), .wb_data_o(wb_data[16*8-1:0]),
                      .bus_data_e(bus_data[16*16-1:16*8]), .bus_data_o(bus_data[16*8-1:0]),
                      .rd_size_e(rd_size[3:2]), .rd_size_o(rd_size[1:0]),
                      .sw_size_e(sw_size[3:2]), .sw_size_o(sw_size[1:0]),
                      .wb_size_e(wb_size[3:2]), .wb_size_o(wb_size[1:0]),
                      .rd_valid_e(rd_valid[1]), .rd_valid_o(rd_valid[0]),
                      .sw_valid_e(sw_valid[1]), .sw_valid_o(sw_valid[0]),
                      .wb_valid_e(wb_valid[1]), .wb_valid_o(wb_valid[0]),
                      .bus_valid_e(bus_valid[1]), .bus_valid_o(bus_valid[0]),
                      .wb_mask_e(wb_mask[16*16-1:16*8]) ,.wb_mask_o(wb_mask[16*8-1:0]),
                      .rd_ptcid(rd_ptcid), .sw_ptcid(sw_ptcid), .wb_ptcid(wb_ptcid),
                      .rd_odd_is_greater(rd_oig), .sw_odd_is_greater(sw_oig), .wb_odd_is_greater(wb_oig),
                      .rd_needP1(rd_np1), .sw_needP1(sw_np1), .wb_needP1(wb_np1),
                      .rd_onesize(rd_os), .sw_onesize(sw_os), .wb_onesize(wb_os),
                      .rd_pcd(rd_pcd), .sw_pcd(sw_pcd), .wb_pcd(wb_pcd), .bus_pcd(bus_pcd),
                      .bus_isempty(bus_isempty),
                      .read(read), .rd_write(rd_write), .sw_write(sw_write), .wb_write(wb_write),
                      .clk(clk), .clr(clr),
                      .pAddress_e(pAddress[29:15]), .pAddress_o(pAddress[14:0]),
                      .data_e(data[16*16-1:16*8]), .data_o(data[16*8-1:0]),
                      .size_e(size[3:2]) ,.size_o(size[1:0]),
                      .r(r), .w(w), .sw(sw),
                      .valid_e(valid[1]), .valid_o(valid[0]),
                      .fromBUS(fromBUS),
                      .mask_e(mask[16*16-1:16*8]), .mask_o(mask[16*8-1:0]),
                      .ptcid(ptcid), .odd_is_greater(oig), .onesize(os), .pcd(pcd),
                      .aq_isempty(aqempty), .rdaq_isfull(rdaqfull), .swaq_isfull(swaqfull), .wbaq_isfull(wbaqfull));


    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        wb_data = 256'h0; bus_data = 256'h0;
        rd_size = 4'h1; sw_size = 4'h2; wb_size = 4'h3;
        rd_valid = 2'b01; sw_valid = 2'b10; wb_valid = 2'b11; bus_valid = 2'b00;
        wb_mask = 256'h0;
        rd_oig = 1'b0; sw_oig = 1'b0; wb_oig = 1'b0;
        rd_np1 = 1'b0; sw_np1 = 1'b0; wb_np1 = 1'b0;
        rd_os = 1'b0; sw_os = 1'b0; wb_os = 1'b0;
        rd_pcd = 1'b0; sw_pcd = 1'b0; wb_pcd = 1'b0; bus_pcd = 1'b0;
        #CYCLE_TIME;
        $display("asdasdads");
        clr = 1'b1;
        
        rd_pAddress = 30'h11111111; sw_pAddress = 30'h22222222; wb_pAddress = 30'h33333333; bus_pAddress = 30'h00000000;
        rd_ptcid = 7'b0000111; sw_ptcid = 7'b0001110; wb_ptcid = 7'b0011100;
        bus_isempty = 1'b0;
        read = 1'b1; rd_write = 1'b1; sw_write = 1'b1; wb_write = 1'b1;
        #CYCLE_TIME;

        rd_pAddress = 30'h01010101; sw_pAddress = 30'h02020202; wb_pAddress = 30'h03030303; bus_pAddress = 30'h00000000;
        rd_ptcid = 7'b0000111; sw_ptcid = 7'b0001110; wb_ptcid = 7'b0011100;
        bus_isempty = 1'b0;
        read = 1'b1; rd_write = 1'b1; sw_write = 1'b1; wb_write = 1'b1;
        #CYCLE_TIME;

        bus_isempty = 1'b1;
        read = 1'b1; rd_write = 1'b0; sw_write = 1'b0; wb_write = 1'b0;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule