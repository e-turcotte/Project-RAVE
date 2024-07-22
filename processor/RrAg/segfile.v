module segfile (input [63:0] base_in,
                input [119:0] lim_inits,
                input [11:0] ld_addr, rd_addr,
                input [3:0] ld_en, dest,
                input [6:0] data_ptcid, new_ptcid,
                input clr, ptcclr,
                input clk,
                output [63:0] base_out,
                output [79:0] lim_out,
                output [127:0] ptc_out);

    wire [7:0] decodedld [0:3], decodedrd [0:3];

    decodern #(.INPUT_WIDTH(3)) d0(.in(ld_addr[2:0]), .out(decodedld[0]));
    decodern #(.INPUT_WIDTH(3)) d1(.in(ld_addr[5:3]), .out(decodedld[1])); 
    decodern #(.INPUT_WIDTH(3)) d2(.in(ld_addr[8:6]), .out(decodedld[2])); 
    decodern #(.INPUT_WIDTH(3)) d3(.in(ld_addr[11:9]), .out(decodedld[3]));

    decodern #(.INPUT_WIDTH(3)) d6(.in(rd_addr[2:0]), .out(decodedrd[0]));
    decodern #(.INPUT_WIDTH(3)) d7(.in(rd_addr[5:3]), .out(decodedrd[1])); 
    decodern #(.INPUT_WIDTH(3)) d8(.in(rd_addr[8:6]), .out(decodedrd[2]));
    decodern #(.INPUT_WIDTH(3)) d9(.in(rd_addr[11:9]), .out(decodedrd[3]));

    wire [95:0] base_ins, base_outs;
    wire [119:0] lim_ins, lim_outs;
    wire [191:0] ptc_outs;
    wire [5:0] ld_vector, dest_vector;

    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : seg_slots
            wire [2:0] loc;

            case (i)
                0: assign loc = 3'b000;
                1: assign loc = 3'b001;
                2: assign loc = 3'b010;
                3: assign loc = 3'b011;
                4: assign loc = 3'b100;
                5: assign loc = 3'b101;
                default: assign loc = 3'b000;
            endcase

            assign lim_ins = lim_inits;

            wire [3:0] ld, markdest;

            and2$ g0(.out(ld[0]), .in0(decodedld[0][i]), .in1(ld_en[0]));
            and2$ g1(.out(ld[1]), .in0(decodedld[1][i]), .in1(ld_en[1]));
            and2$ g2(.out(ld[2]), .in0(decodedld[2][i]), .in1(ld_en[2]));
            and2$ g3(.out(ld[3]), .in0(decodedld[3][i]), .in1(ld_en[3]));

            and2$ g4(.out(markdest[0]), .in0(decodedrd[0][i]), .in1(dest[0]));
            and2$ g5(.out(markdest[1]), .in0(decodedrd[1][i]), .in1(dest[1]));
            and2$ g6(.out(markdest[2]), .in0(decodedrd[2][i]), .in1(dest[2]));
            and2$ g7(.out(markdest[3]), .in0(decodedrd[3][i]), .in1(dest[3]));

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(16)) m0(.in(base_in), .sel({ld[3],ld[2],ld[1],ld[0]}), .out(base_ins[(i+1)*16-1:i*16]));
            or4$ g8(.out(ld_vector[i]), .in0(ld[3]), .in1(ld[2]), .in2(ld[1]), .in3(ld[0]));
            or4$ g9(.out(dest_vector[i]), .in0(markdest[3]), .in1(markdest[2]), .in2(markdest[1]), .in3(markdest[0]));
            seg s0(.base_in(base_ins[(i+1)*16-1:i*16]), .lim_in(lim_ins[(i+1)*20-1:i*20]), .ld(ld_vector[i]), .dest(dest_vector[i]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .loc(loc), .clr(clr), .ptcclr(ptcclr), .clk(clk), .base_out(base_outs[(i+1)*16-1:i*16]), .lim_out(lim_outs[(i+1)*20-1:i*20]), .ptc_out(ptc_outs[(i+1)*32-1:i*32]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m1(.in({{32{1'b0}},base_outs}), .sel(rd_addr[2:0]), .out(base_out[15:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m2(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[2:0]), .out(lim_out[19:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m3(.in({{64{1'b0}},ptc_outs}), .sel(rd_addr[2:0]), .out(ptc_out[31:0]));
    
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m4(.in({{32{1'b0}},base_outs}), .sel(rd_addr[5:3]), .out(base_out[31:16]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m5(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[5:3]), .out(lim_out[39:20]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m6(.in({{64{1'b0}},ptc_outs}), .sel(rd_addr[2:0]), .out(ptc_out[63:32]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m7(.in({{32{1'b0}},base_outs}), .sel(rd_addr[8:6]), .out(base_out[47:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m8(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[8:6]), .out(lim_out[59:40]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m9(.in({{64{1'b0}},ptc_outs}), .sel(rd_addr[2:0]), .out(ptc_out[95:64]));
    
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m10(.in({{32{1'b0}},base_outs}), .sel(rd_addr[11:9]), .out(base_out[63:48]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m11(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[11:9]), .out(lim_out[79:60]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m12(.in({{64{1'b0}},ptc_outs}), .sel(rd_addr[2:0]), .out(ptc_out[127:96]));
    
    integer cyc_cnt;
    integer file;

    initial begin
        cyc_cnt = 0;
        file = $fopen("segfile.out", "w");
    end

    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;

        $fdisplay(file, "[===SEGR VALUES===]");
        $fdisplay(file, "ES = 0x%h, lim:0x%h   PTC:%b", base_outs[15:0], lim_outs[19:0], {ptc_outs[30],ptc_outs[14]});
        $fdisplay(file, "CS = 0x%h, lim:0x%h   PTC:%b", base_outs[31:16], lim_outs[39:20], {ptc_outs[62],ptc_outs[46]});
        $fdisplay(file, "SS = 0x%h, lim:0x%h   PTC:%b", base_outs[47:32], lim_outs[59:40], {ptc_outs[94],ptc_outs[78]});
        $fdisplay(file, "DS = 0x%h, lim:0x%h   PTC:%b", base_outs[63:48], lim_outs[79:60], {ptc_outs[126],ptc_outs[110]});
        $fdisplay(file, "FS = 0x%h, lim:0x%h   PTC:%b", base_outs[79:64], lim_outs[99:80], {ptc_outs[158],ptc_outs[142]});
        $fdisplay(file, "GS = 0x%h, lim:0x%h   PTC:%b", base_outs[95:80], lim_outs[119:100], {ptc_outs[190],ptc_outs[174]});
    
        $fdisplay(file, "\n");
    end

endmodule

module seg (input [15:0] base_in,
            input [19:0] lim_in,
            input ld, dest,
            input [6:0] data_ptcid, new_ptcid,
            input [2:0] loc,
            input clr, ptcclr,
            input clk,
            output [15:0] base_out,
            output [19:0] lim_out,
            output [31:0] ptc_out);

    wire invclr;

    inv1$ g0(.out(invclr), .in(clr));
    
    regn #(.WIDTH(16)) base(.din(base_in), .ld(ld), .clr(clr), .clk(clk), .dout(base_out));
    regn #(.WIDTH(20)) lim(.din(lim_in), .ld(invclr), .clr(1'b1), .clk(clk), .dout(lim_out));

    wire ptcmatch, clearptc, ptcld, clr_ptc_signal;
    wire v;
    wire [6:0] id;

    regn #(.WIDTH(7)) ptcid(.din(new_ptcid), .ld(dest), .clr(clr), .clk(clk), .dout(id));
    equaln #(.WIDTH(7)) eq0(.a(data_ptcid), .b(id), .eq(ptcmatch));
    and2$ g1(.out(clearptc), .in0(ptcmatch), .in1(ld));
    or2$ g2(.out(ptcld), .in0(dest), .in1(clearptc));
    and2$ g3(.out(clr_ptc_signal), .in0(clr), .in1(ptcclr));
    regn #(.WIDTH(1)) ptcv(.din(dest), .ld(ptcld), .clr(clr_ptc_signal), .clk(clk), .dout(v));
    assign ptc_out = {1'b0,v,id,1'b1,loc,3'b001,
                      1'b0,v,id,1'b1,loc,3'b000};

endmodule