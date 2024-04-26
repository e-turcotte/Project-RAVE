module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k;
    reg [7:0] regk [0:3];

    reg [63:0] in0, in1, in2, in3;
    reg [2:0] ld0, ld1, ld2, ld3, rd0, rd1, rd2, rd3;
    reg [1:0] ldsize, rdsize;
    reg [3:0] ld_en, dest;
    reg [6:0] data_ptcid, new_ptcid;
    reg clr, ptcclr;
    wire [63:0] out0, out1, out2, out3;
    wire [127:0] ptc0, ptc1, ptc2, ptc3;
    reg clk;

    regfile rf(.din({in3,in2,in1,in0}), .ld_addr({ld3,ld2,ld1,ld0}), .rd_addr({rd3,rd2,rd1,rd0}), .ldsize(ldsize), .rdsize(rdsize), .ld_en(ld_en), .dest(dest), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .ptcclr(ptcclr), .clk(clk), .dout({out3,out2,out1,out0}), .ptcout({ptc3,ptc2,ptc1,ptc0}));


    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        rd0 = 0; rd1 = 0; rd2 = 0; rd3 = 0;
        ld0 = 0; ld1 = 0; ld2 = 0; ld3 = 0;
        ldsize = 2'b10; rdsize = 2'b10;
        ld_en = 4'b1111; dest = 4'b1111;
        data_ptcid = 7'b0000000; new_ptcid = 7'b1111111;
        clr = 1'b0; ptcclr = 1'b1;
        #CYCLE_TIME;
        clr = 1'b1;
        for (k = 0; k < 8; k = k + 4) begin
            regk[0] = k & 8'hff; regk[1] = (k+1) & 8'hff; regk[2] = (k+2) & 8'hff; regk[3] = (k+3) & 8'hff;
            in0 = {64{regk[0]}};
            in1 = {64{regk[1]}};
            in2 = {64{regk[2]}};
            in3 = {64{regk[3]}};
            rd0 = ld0; rd1 = ld1; rd2 = ld2; rd3 = ld3;
            ld0 = regk[0][2:0]; ld1 =regk[1][2:0]; ld2 = regk[2][2:0]; ld3 =regk[3][2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;

        ldsize = 2'b11; rdsize = 2'b11;
        for (k = 0; k < 8; k = k + 4) begin
            regk[0] = k & 8'hff; regk[1] = (k+1) & 8'hff; regk[2] = (k+2) & 8'hff; regk[3] = (k+3) & 8'hff;
            in0 = {64{regk[0]<<4}};
            in1 = {64{regk[1]<<4}};
            in2 = {64{regk[2]<<4}};
            in3 = {64{regk[3]<<4}};
            rd0 = ld0; rd1 = ld1; rd2 = ld2; rd3 = ld3;
            ld0 = regk[0][2:0]; ld1 =regk[1][2:0]; ld2 = regk[2][2:0]; ld3 =regk[3][2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;

        ldsize = 2'b01; rdsize = 4'b01;
        for (k = 0; k < 8; k = k + 4) begin
            regk[0] = k & 8'hff; regk[1] = (k+1) & 8'hff; regk[2] = (k+2) & 8'hff; regk[3] = (k+3) & 8'hff;
            in0 = {64{1'b1}};
            in1 = {64{1'b1}};
            in2 = {64{1'b1}};
            in3 = {64{1'b1}};
            rd0 = ld0; rd1 = ld1; rd2 = ld2; rd3 = ld3;
            ld0 = regk[0][2:0]; ld1 =regk[1][2:0]; ld2 = regk[2][2:0]; ld3 =regk[3][2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;

        ldsize = 2'b00; rdsize = 2'b00;
        ld_en = 4'b0110;
        for (k = 0; k < 8; k = k + 4) begin
            regk[0] = k & 8'hff; regk[1] = (k+1) & 8'hff; regk[2] = (k+2) & 8'hff; regk[3] = (k+3) & 8'hff;
            in0 = {64{regk[0]<<4}};
            in1 = {64{regk[1]<<4}};
            in2 = {64{regk[2]<<4}};
            in3 = {64{regk[3]<<4}};
            rd0 = ld0; rd1 = ld1; rd2 = ld2; rd3 = ld3;
            ld0 = regk[0][2:0]; ld1 =regk[1][2:0]; ld2 = regk[2][2:0]; ld3 =regk[3][2:0];
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;
        ptcclr = 1'b0;
        #(2*CYCLE_TIME);
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule