module TOP;

    localparam CYCLE_TIME = 2.0;

    reg [63:0] reg1_data, reg2_data, reg3_data, reg4_data;
    reg [2:0] reg1_addr, reg2_addr, reg3_addr, reg4_addr;
    reg [127:0] reg1_ptc, reg2_ptc, reg3_ptc, reg4_ptc;
    reg [15:0] seg1_data, seg2_data, seg3_data, seg4_data;
    reg [2:0] seg1_addr, seg2_addr, seg3_addr, seg4_addr;
    reg [31:0] seg1_ptc, seg2_ptc, seg3_ptc, seg4_ptc;
    reg [63:0] mem1_data, mem2_data;
    reg [31:0] mem1_addr, mem2_addr;
    reg [127:0] mem1_ptc, mem2_ptc;
    reg [31:0] eip_data;
    reg [47:0] imm;
    reg [12:0] op1_mux, op2_mux, op3_mux, op4_mux, dest1_mux, dest2_mux, dest3_mux, dest4_mux;
    wire [63:0] op1, op2, op3, op4;
    wire [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo;
    wire [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr;
    wire [2:0] dest1_type, dest2_type, dest3_type, dest4_type;
    reg clk;

    opswap opsw0(.reg1_data(reg1_data), .reg2_data(reg2_data), .reg3_data(reg3_data), .reg4_data(reg4_data),
                 .reg1_addr(reg1_addr), .reg2_addr(reg2_addr), .reg3_addr(reg3_addr), .reg4_addr(reg4_addr),
                 .reg1_ptc(reg1_ptc), .reg2_ptc(reg2_ptc), .reg3_ptc(reg3_ptc), .reg4_ptc(reg4_ptc),
                 .seg1_data(seg1_data), .seg2_data(seg2_data), .seg3_data(seg3_data), .seg4_data(seg4_data),
                 .seg1_addr(seg1_addr), .seg2_addr(seg2_addr), .seg3_addr(seg3_addr), .seg4_addr(seg4_addr),
                 .seg1_ptc(seg1_ptc), .seg2_ptc(seg2_ptc), .seg3_ptc(seg3_ptc), .seg4_ptc(seg4_ptc),
                 .mem1_data(mem1_data), .mem2_data(mem2_data),
                 .mem1_addr(mem1_addr), .mem2_addr(mem2_addr),
                 .mem1_ptc(mem1_ptc), .mem2_ptc(mem2_ptc),
                 .eip_data(eip_data), .imm(imm),
                 .op1_mux(op1_mux), .op2_mux(op2_mux), .op3_mux(op3_mux), .op4_mux(op4_mux),
                 .dest1_mux(dest1_mux), .dest2_mux(dest2_mux), .dest3_mux(dest3_mux), .dest4_mux(dest4_mux),
                 .op1(op1), .op2(op2), .op3(op3), .op4(op4),
                 .op1_ptcinfo(op1_ptcinfo), .op2_ptcinfo(op2_ptcinfo), .op3_ptcinfo(op3_ptcinfo), .op4_ptcinfo(op4_ptcinfo),
                 .dest1_addr(dest1_addr), .dest2_addr(dest2_addr), .dest3_addr(dest3_addr), .dest4_addr(dest4_addr),
                 .dest1_type(dest1_type), .dest2_type(dest2_type), .dest3_type(dest3_type), .dest4_type(dest4_type));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        reg1_data = 4'h1; reg2_data = 4'h2; reg3_data = 4'h3; reg4_data = 4'h4;
        reg1_addr = 8'h10; reg2_addr = 8'h20; reg3_addr = 8'h30; reg4_addr = 8'h40;
        reg1_ptc = 12'h100; reg2_ptc = 12'h200; reg3_ptc = 12'h300; reg4_ptc = 12'h400;
        seg1_data = 4'h5; seg2_data = 4'h6; seg3_data = 4'h7; seg4_data = 4'h8;
        seg1_addr = 8'h50; seg2_addr = 8'h60; seg3_addr = 8'h70; seg4_addr = 8'h80;
        seg1_ptc = 12'h500; seg2_ptc = 12'h600; seg3_ptc = 12'h700; seg4_ptc = 12'h800;
        mem1_data = 4'h9; mem2_data = 4'ha;
        mem1_addr = 8'h90; mem2_addr = 8'ha0;
        mem1_ptc = 12'h900; mem2_ptc = 12'ha00;
        eip_data = 4'hb;
        imm = 4'hc;
        op1_mux = 13'b0000000000001; op2_mux = 13'b0000000000010; op3_mux = 13'b0000000000100; op4_mux = 13'b0000000001000;
        dest1_mux = 13'b0000000001000; dest2_mux = 13'b0000000000100; dest3_mux = 13'b0000000000010; dest4_mux = 13'b0000000000001;
        #CYCLE_TIME;
        $display("OP1val = %h, OP1ptc = %h", op1, op1_ptcinfo);
        $display("OP2val = %h, OP2ptc = %h", op2, op2_ptcinfo);
        $display("OP3val = %h, OP3ptc = %h", op3, op3_ptcinfo);
        $display("OP4val = %h, OP4ptc = %h", op4, op4_ptcinfo);
        $display("RES1addr = %h, RES1type = %h", dest1_addr, dest1_type);
        $display("RES2addr = %h, RES2type = %h", dest2_addr, dest2_type);
        $display("RES3addr = %h, RES3type = %h", dest3_addr, dest3_type);
        $display("RES3addr = %h, RES4type = %h", dest4_addr, dest4_type);
        op1_mux = 13'b0000000010000; op2_mux = 13'b0000000100000; op3_mux = 13'b0000001000000; op4_mux = 13'b0000010000000;
        dest1_mux = 13'b0000010000000; dest2_mux = 13'b0000001000000; dest3_mux = 13'b0000000100000; dest4_mux = 13'b0000000010000;
        #CYCLE_TIME;
        $display("OP1val = %h, OP1ptc = %h", op1, op1_ptcinfo);
        $display("OP2val = %h, OP2ptc = %h", op2, op2_ptcinfo);
        $display("OP3val = %h, OP3ptc = %h", op3, op3_ptcinfo);
        $display("OP4val = %h, OP4ptc = %h", op4, op4_ptcinfo);
        $display("RES1addr = %h, RES1type = %h", dest1_addr, dest1_type);
        $display("RES2addr = %h, RES2type = %h", dest2_addr, dest2_type);
        $display("RES3addr = %h, RES3type = %h", dest3_addr, dest3_type);
        $display("RES3addr = %h, RES4type = %h", dest4_addr, dest4_type);
        op1_mux = 13'b0000100000000; op2_mux = 13'b0001000000000; op3_mux = 13'b0010000000000; op4_mux = 13'b0100000000000;
        dest1_mux = 13'b0100000000000; dest2_mux = 13'b0010000000000; dest3_mux = 13'b0001000000000; dest4_mux = 13'b0000100000000;
        #CYCLE_TIME;
        $display("OP1val = %h, OP1ptc = %h", op1, op1_ptcinfo);
        $display("OP2val = %h, OP2ptc = %h", op2, op2_ptcinfo);
        $display("OP3val = %h, OP3ptc = %h", op3, op3_ptcinfo);
        $display("OP4val = %h, OP4ptc = %h", op4, op4_ptcinfo);
        $display("RES1addr = %h, RES1type = %h", dest1_addr, dest1_type);
        $display("RES2addr = %h, RES2type = %h", dest2_addr, dest2_type);
        $display("RES3addr = %h, RES3type = %h", dest3_addr, dest3_type);
        $display("RES3addr = %h, RES4type = %h", dest4_addr, dest4_type);
        op1_mux = 13'b1000000000000; op2_mux = 13'b1000000000000; op3_mux = 13'b1000000000000; op4_mux = 13'b1000000000000;
        dest1_mux = 13'b1000000000000; dest2_mux = 13'b1000000000000; dest3_mux = 13'b1000000000000; dest4_mux = 13'b1000000000000;
        #CYCLE_TIME;
        $display("OP1val = %h, OP1ptc = %h", op1, op1_ptcinfo);
        $display("OP2val = %h, OP2ptc = %h", op2, op2_ptcinfo);
        $display("OP3val = %h, OP3ptc = %h", op3, op3_ptcinfo);
        $display("OP4val = %h, OP4ptc = %h", op4, op4_ptcinfo);
        $display("RES1addr = %h, RES1type = %h", dest1_addr, dest1_type);
        $display("RES2addr = %h, RES2type = %h", dest2_addr, dest2_type);
        $display("RES3addr = %h, RES3type = %h", dest3_addr, dest3_type);
        $display("RES3addr = %h, RES4type = %h", dest4_addr, dest4_type);
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(6, TOP);
    end

endmodule