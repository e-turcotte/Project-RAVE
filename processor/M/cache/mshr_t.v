module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [14:0] pAddress;
    reg [6:0] ptcid;
    reg rd_or_sw;
    reg alloc, dealloc;
    reg clr;
    wire [6:0] ptcid_out;
    wire rd_or_sw_out;
    wire mshr_hit, mshr_full; 
    reg clk;

    mshr m0(.pAddress(pAddress), .ptcid_in(ptcid), .rd_or_sw_in(rd_or_sw), .alloc(alloc), .dealloc(dealloc),
            .clk(clk), .clr(clr), .ptcid_out(ptcid_out), .rd_or_sw_out(rd_or_sw_out), .mshr_hit(mshr_hit), .mshr_full(mshr_full));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        alloc = 1'b0; dealloc = 1'b0;
        #CYCLE_TIME;
        clr = 1'b1;
        alloc = 1'b1; dealloc = 1'b0;

        pAddress = 15'h0000;
        rd_or_sw = 1'b0;
        ptcid = 7'h00;
        #CYCLE_TIME;
        pAddress = 15'h1111;
        rd_or_sw = 1'b0;
        ptcid = 7'h11;
        #CYCLE_TIME;
        pAddress = 15'h2222;
        rd_or_sw = 1'b0;
        ptcid = 7'h22;
        #CYCLE_TIME;
        pAddress = 15'h3333;
        rd_or_sw = 1'b0;
        ptcid = 7'h33;
        #CYCLE_TIME;
        pAddress = 15'h4444;
        rd_or_sw = 1'b0;
        ptcid = 7'h44;
        #CYCLE_TIME;
        pAddress = 15'h5555;
        rd_or_sw = 1'b0;
        ptcid = 7'h55;
        #CYCLE_TIME;
        pAddress = 15'h6666;
        rd_or_sw = 1'b0;
        ptcid = 7'h66;
        #CYCLE_TIME;
        pAddress = 15'h7777;
        rd_or_sw = 1'b0;
        ptcid = 7'h77;
        #CYCLE_TIME;
        alloc = 1'b0; dealloc = 1'b1;

        pAddress = 15'h4444;
        #CYCLE_TIME;
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