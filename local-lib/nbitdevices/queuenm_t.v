module TOP;

    localparam CYCLE_TIME = 2.0;
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

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule
