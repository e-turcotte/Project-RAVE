module TOP;

    localparam CYCLE_TIME = 100.0;
    integer k;

    reg [8:0] addr;
    reg rw, bnk_en;
    reg [127:0] din;
    wire [127:0] dout;
    reg clk;

    bank bnk(.addr(addr), .rw(rw), .bnk_en(bnk_en), .din(din), .dout(dout));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        $readmemh("initfiles/bank_test0.init", bnk.bank_slices[0].dram.sram0.mem);
        $readmemh("initfiles/bank_test0.init", bnk.bank_slices[0].dram.sram1.mem);
        $readmemh("initfiles/bank_test0.init", bnk.bank_slices[0].dram.sram2.mem);
        $readmemh("initfiles/bank_test0.init", bnk.bank_slices[0].dram.sram3.mem);
        $readmemh("initfiles/bank_test1.init", bnk.bank_slices[1].dram.sram0.mem);
        $readmemh("initfiles/bank_test1.init", bnk.bank_slices[1].dram.sram1.mem);
        $readmemh("initfiles/bank_test1.init", bnk.bank_slices[1].dram.sram2.mem);
        $readmemh("initfiles/bank_test1.init", bnk.bank_slices[1].dram.sram3.mem);
        $readmemh("initfiles/bank_test2.init", bnk.bank_slices[2].dram.sram0.mem);
        $readmemh("initfiles/bank_test2.init", bnk.bank_slices[2].dram.sram1.mem);
        $readmemh("initfiles/bank_test2.init", bnk.bank_slices[2].dram.sram2.mem);
        $readmemh("initfiles/bank_test2.init", bnk.bank_slices[2].dram.sram3.mem);
        $readmemh("initfiles/bank_test3.init", bnk.bank_slices[3].dram.sram0.mem);
        $readmemh("initfiles/bank_test3.init", bnk.bank_slices[3].dram.sram1.mem);
        $readmemh("initfiles/bank_test3.init", bnk.bank_slices[3].dram.sram2.mem);
        $readmemh("initfiles/bank_test3.init", bnk.bank_slices[3].dram.sram3.mem);
        $readmemh("initfiles/bank_test4.init", bnk.bank_slices[4].dram.sram0.mem);
        $readmemh("initfiles/bank_test4.init", bnk.bank_slices[4].dram.sram1.mem);
        $readmemh("initfiles/bank_test4.init", bnk.bank_slices[4].dram.sram2.mem);
        $readmemh("initfiles/bank_test4.init", bnk.bank_slices[4].dram.sram3.mem);
        $readmemh("initfiles/bank_test5.init", bnk.bank_slices[5].dram.sram0.mem);
        $readmemh("initfiles/bank_test5.init", bnk.bank_slices[5].dram.sram1.mem);
        $readmemh("initfiles/bank_test5.init", bnk.bank_slices[5].dram.sram2.mem);
        $readmemh("initfiles/bank_test5.init", bnk.bank_slices[5].dram.sram3.mem);
        $readmemh("initfiles/bank_test6.init", bnk.bank_slices[6].dram.sram0.mem);
        $readmemh("initfiles/bank_test6.init", bnk.bank_slices[6].dram.sram1.mem);
        $readmemh("initfiles/bank_test6.init", bnk.bank_slices[6].dram.sram2.mem);
        $readmemh("initfiles/bank_test6.init", bnk.bank_slices[6].dram.sram3.mem);
        $readmemh("initfiles/bank_test7.init", bnk.bank_slices[7].dram.sram0.mem);
        $readmemh("initfiles/bank_test7.init", bnk.bank_slices[7].dram.sram1.mem);
        $readmemh("initfiles/bank_test7.init", bnk.bank_slices[7].dram.sram2.mem);
        $readmemh("initfiles/bank_test7.init", bnk.bank_slices[7].dram.sram3.mem);
        $readmemh("initfiles/bank_test8.init", bnk.bank_slices[8].dram.sram0.mem);
        $readmemh("initfiles/bank_test8.init", bnk.bank_slices[8].dram.sram1.mem);
        $readmemh("initfiles/bank_test8.init", bnk.bank_slices[8].dram.sram2.mem);
        $readmemh("initfiles/bank_test8.init", bnk.bank_slices[8].dram.sram3.mem);
        $readmemh("initfiles/bank_test9.init", bnk.bank_slices[9].dram.sram0.mem);
        $readmemh("initfiles/bank_test9.init", bnk.bank_slices[9].dram.sram1.mem);
        $readmemh("initfiles/bank_test9.init", bnk.bank_slices[9].dram.sram2.mem);
        $readmemh("initfiles/bank_test9.init", bnk.bank_slices[9].dram.sram3.mem);
        $readmemh("initfiles/bank_test10.init", bnk.bank_slices[10].dram.sram0.mem);
        $readmemh("initfiles/bank_test10.init", bnk.bank_slices[10].dram.sram1.mem);
        $readmemh("initfiles/bank_test10.init", bnk.bank_slices[10].dram.sram2.mem);
        $readmemh("initfiles/bank_test10.init", bnk.bank_slices[10].dram.sram3.mem);
        $readmemh("initfiles/bank_test11.init", bnk.bank_slices[11].dram.sram0.mem);
        $readmemh("initfiles/bank_test11.init", bnk.bank_slices[11].dram.sram1.mem);
        $readmemh("initfiles/bank_test11.init", bnk.bank_slices[11].dram.sram2.mem);
        $readmemh("initfiles/bank_test11.init", bnk.bank_slices[11].dram.sram3.mem);
        $readmemh("initfiles/bank_test12.init", bnk.bank_slices[12].dram.sram0.mem);
        $readmemh("initfiles/bank_test12.init", bnk.bank_slices[12].dram.sram1.mem);
        $readmemh("initfiles/bank_test12.init", bnk.bank_slices[12].dram.sram2.mem);
        $readmemh("initfiles/bank_test12.init", bnk.bank_slices[12].dram.sram3.mem);
        $readmemh("initfiles/bank_test13.init", bnk.bank_slices[13].dram.sram0.mem);
        $readmemh("initfiles/bank_test13.init", bnk.bank_slices[13].dram.sram1.mem);
        $readmemh("initfiles/bank_test13.init", bnk.bank_slices[13].dram.sram2.mem);
        $readmemh("initfiles/bank_test13.init", bnk.bank_slices[13].dram.sram3.mem);
        $readmemh("initfiles/bank_test14.init", bnk.bank_slices[14].dram.sram0.mem);
        $readmemh("initfiles/bank_test14.init", bnk.bank_slices[14].dram.sram1.mem);
        $readmemh("initfiles/bank_test14.init", bnk.bank_slices[14].dram.sram2.mem);
        $readmemh("initfiles/bank_test14.init", bnk.bank_slices[14].dram.sram3.mem);
        $readmemh("initfiles/bank_test15.init", bnk.bank_slices[15].dram.sram0.mem);
        $readmemh("initfiles/bank_test15.init", bnk.bank_slices[15].dram.sram1.mem);
        $readmemh("initfiles/bank_test15.init", bnk.bank_slices[15].dram.sram2.mem);
        $readmemh("initfiles/bank_test15.init", bnk.bank_slices[15].dram.sram3.mem);

        din = 128'hffffffffffffffffffffffffffffffff;
        rw = 1'b1; bnk_en = 1'b1;
        #CYCLE_TIME;
        for (k = 0; k < 512; k = k + 1) begin
            addr = k & 9'b111111111;
            #CYCLE_TIME;
            $display("0x%h @M[0x%h]", dout, addr);            
        end
        
        rw = 1'b0; bnk_en = 1'b0;
        #CYCLE_TIME;
        for (k = 0; k < 512; k = k + 1) begin
            addr = k & 9'b111111111;
            #CYCLE_TIME;
            bnk_en = 1'b1;
            #CYCLE_TIME;
            bnk_en = 1'b0;
            #CYCLE_TIME;    
        end
        $display();

        #CYCLE_TIME;
        rw = 1'b1; bnk_en = 1'b1;
        for (k = 0; k < 512; k = k + 1) begin
            addr = k & 9'b111111111;
            #CYCLE_TIME;
            $display("0x%h @M[0x%h]", dout, addr);            
        end
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule
