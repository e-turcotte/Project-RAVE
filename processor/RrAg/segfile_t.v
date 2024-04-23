module TOP;

    localparam CYCLE_TIME = 2.0;
    localparam NUM_TESTS = 4;
    integer k;
    reg [7:0] regk [0:3];

    reg [15:0] base_in3, base_in2, base_in1, base_in0;
    reg [19:0] lim_init5, lim_init4, lim_init3, lim_init2, lim_init1, lim_init0;
    reg [2:0] ld3, ld2, ld1, ld0, rd3, rd2, rd1, rd0;
    reg [3:0] ld_en, dest;
    reg [6:0] data_ptcid, new_ptcid;
    reg clr;
    wire [15:0] base_out3, base_out2, base_out1, base_out0;
    wire [19:0] lim_out3, lim_out2, lim_out1, lim_out0;
    wire [63:0] ptc_out3, ptc_out2, ptc_out1, ptc_out0;
    reg clk;

    segfile sf(.base_in({base_in3,base_in2,base_in1,base_in0}), .lim_inits({lim_init5,lim_init4,lim_init3,lim_init2,lim_init1,lim_init0}), .ld_addr({ld3,ld2,ld1,ld0}), .rd_addr({rd3,rd2,rd1,rd0}), .ld_en(ld_en), .dest(dest), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .clk(clk), .base_out({base_out3,base_out2,base_out1,base_out0}), .lim_out({lim_out3,lim_out2,lim_out1,lim_out0}), .ptc_out({ptc_out3,ptc_out2,ptc_out1,ptc_out0}));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        clr = 1'b0;
        lim_init0 = 20'h04fff;
        lim_init1 = 20'h011ff;
        lim_init2 = 20'h04000;
        lim_init3 = 20'h003ff;
        lim_init4 = 20'h003ff;
        lim_init5 = 20'h007ff;
        #CYCLE_TIME;

        ld_en = 4'b1111; dest = 4'b1111;
        data_ptcid = 7'b0000000; new_ptcid = 7'b0000000;
        clr = 1'b1;
        rd0 = 3'b000; rd1 = 3'b001; rd2 = 3'b010; rd3 = 3'b011;
        for (k = 0; k < 8; k = k + 4) begin
            regk[0] = k & 4'hf; regk[1] = (k+1) & 4'hf; regk[2] = (k+2) & 4'hf; regk[3] = (k+3) & 4'hf;
            base_in0 = {16{regk[0]<<4}};
            base_in1 = {16{regk[1]<<4}};
            base_in2 = {16{regk[2]<<4}};
            base_in3 = {16{regk[3]<<4}};
            ld3 = regk[3][2:0]; ld2 = regk[2][2:0]; ld1 = regk[1][2:0]; ld0 = regk[0][2:0];
            #CYCLE_TIME; 
        end
        dest = 4'b0000;
        #(2*CYCLE_TIME);
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule