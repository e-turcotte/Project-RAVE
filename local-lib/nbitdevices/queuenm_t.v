module TOP;

    localparam CYCLE_TIME = 2.5;
    integer k, l;

    localparam mlen = 16;
    localparam nlen = 16;
    localparam qlen = 16;

    reg [3:0] regk;

    reg [mlen-1:0] m_din;
    reg [nlen-1:0] n_din;
    wire [mlen*qlen-1:0] new_m_vector;
    reg wr, rd;
    reg [qlen-1:0] modify_vector;
    reg clr;
    wire full, empty;
    wire [mlen*qlen-1:0] old_m_vector;
    wire [mlen+nlen-1:0] dout;
    reg clk;

    queuenm #(.M_WIDTH(mlen), .N_WIDTH(nlen), .Q_LENGTH(qlen)) q0(.m_din(m_din), .n_din(n_din), .new_m_vector(new_m_vector), .wr(wr), .rd(rd), .modify_vector(modify_vector), .clr(clr), .clk(clk), .full(full), .empty(empty), .old_m_vector(old_m_vector), .dout(dout));

    genvar i;
    generate
        for (i = 0; i < qlen; i = i + 1) begin
            lshfn_fixed #(.WIDTH(mlen), .SHF_AMNT(2)) sh0(.in(old_m_vector[(i+1)*mlen-1:i*mlen]), .shf_val(2'b00), .out(new_m_vector[(i+1)*mlen-1:i*mlen]));
        end
    endgenerate


    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        wr = 1'b0; rd = 1'b0;
        clr = 1'b0;
        m_din = {mlen{1'b1}};
        modify_vector = {qlen{1'b0}};
        #CYCLE_TIME;
        wr = 1'b1; rd = 1'b0;
        clr = 1'b1;
        for (k = 0; k < 9; k = k + 1) begin
            regk = k & 8'hf;
            n_din = {4{regk}};
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;
        wr = 1'b0; rd = 1'b1;
        modify_vector = {qlen{1'b1}};
        for (k = 0; k < 12; k = k + 1) begin
            
            #CYCLE_TIME; 
        end
        wr = 1'b1; rd = 1'b0;
        clr = 1'b1;
        modify_vector = {qlen{1'b0}};
        for (k = 9; k < 16; k = k + 1) begin
            regk = k & 8'hf;
            n_din = {4{regk}};
            #CYCLE_TIME; 
        end
        #CYCLE_TIME;
        wr = 1'b0; rd = 1'b1;
        modify_vector = {qlen{1'b1}};
        for (k = 0; k < 12; k = k + 1) begin
            
            #CYCLE_TIME; 
        end
        $finish;
    end

    integer cyc_cnt;
    integer file;
    integer latch_num;

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);

        cyc_cnt = 0;
        file = $fopen("queued_latch.out", "w");
    end

     wire [mlen+nlen-1:0] all_outs [qlen-1:0];
     integer j;

    always @(posedge clk) begin
		// for (j = 0; j < qlen; j = j + 1) begin
        // 	assign all_outs[j] = q0.outs[(latch_num+1)*(mlen+nlen)-1:latch_num*(mlen+nlen)];
        // end

        
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        $fdisplay(file, "[===QUEUED LATCHES VALUES===]");

        cyc_cnt = cyc_cnt + 1;
        for (latch_num = 0; latch_num < qlen; latch_num = latch_num + 1) begin
            $fdisplay(file, "LATCH %d outs: %h", latch_num, all_outs[latch_num]);
        end
        
        latch_num = 0;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(0+1)*(mlen+nlen)-1:0*(mlen+nlen)]);
        latch_num = 1;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(1+1)*(mlen+nlen)-1:1*(mlen+nlen)]);
        latch_num = 2;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(2+1)*(mlen+nlen)-1:2*(mlen+nlen)]);
        latch_num = 3;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(3+1)*(mlen+nlen)-1:3*(mlen+nlen)]);
        latch_num = 4;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(4+1)*(mlen+nlen)-1:4*(mlen+nlen)]);
        latch_num = 5;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(5+1)*(mlen+nlen)-1:5*(mlen+nlen)]);
        latch_num = 6;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(6+1)*(mlen+nlen)-1:6*(mlen+nlen)]);
        latch_num = 7;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(7+1)*(mlen+nlen)-1:7*(mlen+nlen)]);
        latch_num = 8;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(8+1)*(mlen+nlen)-1:8*(mlen+nlen)]);
        latch_num = 9;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(9+1)*(mlen+nlen)-1:9*(mlen+nlen)]);
        latch_num = 10;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(10+1)*(mlen+nlen)-1:10*(mlen+nlen)]);
        latch_num = 11;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(11+1)*(mlen+nlen)-1:11*(mlen+nlen)]);
        latch_num = 12;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(12+1)*(mlen+nlen)-1:12*(mlen+nlen)]);
        latch_num = 13;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(13+1)*(mlen+nlen)-1:13*(mlen+nlen)]);
        latch_num = 14;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(14+1)*(mlen+nlen)-1:14*(mlen+nlen)]);
        latch_num = 15;
        $fdisplay(file, "LATCH %d outs: %h", latch_num, q0.outs[(15+1)*(mlen+nlen)-1:15*(mlen+nlen)]);
        
        $fdisplay(file, "\n");
    end

endmodule
