module TOP;

    localparam CYCLE_TIME = 100.0;
    integer k;

    reg [4:0] addr;
    reg rw, ce;
    reg [127:0] din;
    wire [127:0] dio;
    reg clk;

    dramcell d0(.addr(addr), .rw(rw), .ce(ce), .dio(dio));
    assign dio = rw ? 128'hz : din;

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        $readmemh("initfiles/dram_test.init", d0.cells[0].sram.mem);
        $readmemh("initfiles/dram_test.init", d0.cells[1].sram.mem);
        $readmemh("initfiles/dram_test.init", d0.cells[2].sram.mem);
        $readmemh("initfiles/dram_test.init", d0.cells[3].sram.mem);
        ce = 1'b0;
        din = 128'hffffffffffffffffffffffffffffffff;
        rw = 1'b1;
        #CYCLE_TIME;
        
        for (k = 0; k < 32; k = k + 1) begin
            addr = k & 5'b11111;
            #CYCLE_TIME;
            $display("0x%h @M[0x%h]", dio, addr);            
        end

        for (k = 0; k < 32; k = k + 1) begin
            addr = k & 5'b11111;
            #CYCLE_TIME;
            rw = 1'b0;
            #CYCLE_TIME;
            rw = 1'b1;           
        end
        $display();

        for (k = 0; k < 32; k = k + 1) begin
            addr = k & 5'b11111;
            #CYCLE_TIME;
            $display("0x%h @M[0x%h]", dio, addr);            
        end
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule
