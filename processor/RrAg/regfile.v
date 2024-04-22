module regfile (input [255:0] din,
                input [11:0] ld_addr, rd_addr,
                input [1:0] ldsize, rdsize,
                input [3:0] ld_en, dest,
                input [6:0] data_ptcid, new_ptcid,
                input clr,
                input clk,
                output [255:0] dout, ptcout);

    wire [3:0] decodedldsize, decodedrdsize;

    decodern #(.INPUT_WIDTH(2)) d0(.in(ldsize), .out(decodedldsize));
    decodern #(.INPUT_WIDTH(2)) d1(.in(rdsize), .out(decodedrdsize));
    wire usegpr, usemmx;
    
    inv1$ g0(.out(usegpr), .in(decodedldsize[3]));
    assign usemmx = decodedldsize[3];

    wire [31:0] gprld, mmxld, decodedld, gprdest, mmxdest, decodedrd;

    decodern #(.INPUT_WIDTH(3)) d2(.in(ld_addr[2:0]), .out(decodedld[7:0]));
    decodern #(.INPUT_WIDTH(3)) d3(.in(ld_addr[5:3]), .out(decodedld[15:8])); 
    decodern #(.INPUT_WIDTH(3)) d4(.in(ld_addr[8:6]), .out(decodedld[23:16]));
    decodern #(.INPUT_WIDTH(3)) d5(.in(ld_addr[11:9]), .out(decodedld[31:24]));

    decodern #(.INPUT_WIDTH(3)) d6(.in(rd_addr[2:0]), .out(decodedrd[7:0]));
    decodern #(.INPUT_WIDTH(3)) d7(.in(rd_addr[5:3]), .out(decodedrd[15:8])); 
    decodern #(.INPUT_WIDTH(3)) d8(.in(rd_addr[8:6]), .out(decodedrd[23:16]));
    decodern #(.INPUT_WIDTH(3)) d9(.in(rd_addr[11:9]), .out(decodedrd[31:24]));

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : ld_slices
            if (i < 8) begin
                and3$ g2(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[0]));
                and3$ g3(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[0]));
                and3$ g4(.out(mmxdest[i]), .in0(decodedrd[i]), .in1(usemmx), .in2(dest[0]));
                and3$ g5(.out(gprdest[i]), .in0(decodedrd[i]), .in1(usegpr), .in2(dest[0]));
            end else if (8 <= i < 16) begin
                and3$ g6(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[1]));
                and3$ g7(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[1]));
                and3$ g8(.out(mmxdest[i]), .in0(decodedrd[i]), .in1(usemmx), .in2(dest[1]));
                and3$ g9(.out(gprdest[i]), .in0(decodedrd[i]), .in1(usegpr), .in2(dest[1]));
            end else if (16 <= i < 24) begin
                and3$ g10(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[2]));
                and3$ g11(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[2]));
                and3$ g12(.out(mmxdest[i]), .in0(decodedrd[i]), .in1(usemmx), .in2(dest[2]));
                and3$ g13(.out(gprdest[i]), .in0(decodedrd[i]), .in1(usegpr), .in2(dest[2]));
            end else begin
                and3$ g14(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[3]));
                and3$ g15(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[3]));
                and3$ g16(.out(mmxdest[i]), .in0(decodedrd[i]), .in1(usemmx), .in2(dest[3]));
                and3$ g17(.out(gprdest[i]), .in0(decodedrd[i]), .in1(usegpr), .in2(dest[3]));
            end
        end
    endgenerate

    wire [127:0] gprouts, gprptcs;
    wire [255:0] mmxouts, mmxptcs;

    gprfile gf(.din({din[223:192],din[159:128],din[95:64],din[31:0]}), .ld(gprld), .dest(gprdest), .rd(rd_addr), .ldsize(decodedldsize[2:0]), .rdsize(decodedrdsize[2:0]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .clk(clk), .dout(gprouts), .ptcout(gprptcs));
    mmxfile mf(.din(din), .ld(mmxld), .dest(mmxdest), .rd(rd_addr), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .clk(clk), .dout(mmxouts), .ptcout(mmxptcs));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(256)) m0(.in({mmxouts,{32{1'b0}},gprouts[127:96],{32{1'b0}},gprouts[95:64],{32{1'b0}},gprouts[63:32],{32{1'b0}},gprouts[31:0]}), .sel(rdsize[3]), .out(dout));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(256)) m1(.in({mmxptcs,{32{1'b0}},gprptcs[127:96],{32{1'b0}},gprptcs[95:64],{32{1'b0}},gprptcs[63:32],{32{1'b0}},gprptcs[31:0]}), .sel(rdsize[3]), .out(ptcout));

endmodule




module gprfile (input [127:0] din,
                input [31:0] ld, dest,
                input [11:0] rd,
                input [2:0] ldsize, rdsize,
                input [6:0] data_ptcid, new_ptcid,
                input clr,
                input clk,
                output [127:0] dout, ptcout);

    wire [23:0] sized_ld_vector [0:2], adjusted_sized_ld_vector, sized_dest_vector [0:2], adjusted_sized_dest_vector;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sized_ld_dest_slices
            if (i < 4) begin
                or4$ g0(.out(sized_ld_vector[0][i*3]), .in0(ld[i]), .in1(ld[8+i]), .in2(ld[16+i]), .in3(ld[24+i]));
                or4$ g1(.out(sized_ld_vector[0][(i*3)+1]), .in0(ld[4+i]), .in1(ld[12+i]), .in2(ld[20+i]), .in3(ld[28+i]));
                or4$ g2(.out(sized_dest_vector[0][i*3]), .in0(dest[i]), .in1(dest[8+i]), .in2(dest[16+i]), .in3(dest[24+i]));
                or4$ g3(.out(sized_dest_vector[0][(i*3)+1]), .in0(dest[4+i]), .in1(dest[12+i]), .in2(dest[20+i]), .in3(dest[28+i]));
            end else begin
                assign sized_ld_vector[0][i*3] = 1'b0;
                assign sized_ld_vector[0][(i*3)+1] = 1'b0;
                assign sized_dest_vector[0][i*3] = 1'b0;
                assign sized_dest_vector[0][(i*3)+1] = 1'b0;
            end
            assign sized_ld_vector[0][(i*3)+2] = 1'b0;
            assign sized_dest_vector[0][(i*3)+2] = 1'b0;

            or4$ g4(.out(sized_ld_vector[1][i*3]), .in0(ld[i]), .in1(ld[8+i]), .in2(ld[16+i]), .in3(ld[24+i]));
            assign sized_ld_vector[1][(i*3)+1] = sized_ld_vector[1][i*3];
            assign sized_ld_vector[1][(i*3)+2] = 1'b0;
            or4$ g5(.out(sized_dest_vector[1][i*3]), .in0(dest[i]), .in1(dest[8+i]), .in2(dest[16+i]), .in3(dest[24+i]));
            assign sized_dest_vector[1][(i*3)+1] = sized_dest_vector[1][i*3];
            assign sized_dest_vector[1][(i*3)+2] = 1'b0;

            or4$ g6(.out(sized_ld_vector[2][i*3]), .in0(ld[i]), .in1(ld[8+i]), .in2(ld[16+i]), .in3(ld[24+i]));
            assign sized_ld_vector[2][(i*3)+1] = sized_ld_vector[2][i*3];
            assign sized_ld_vector[2][(i*3)+2] = sized_ld_vector[2][i*3];
            or4$ g7(.out(sized_dest_vector[2][i*3]), .in0(dest[i]), .in1(dest[8+i]), .in2(dest[16+i]), .in3(dest[24+i]));
            assign sized_dest_vector[2][(i*3)+1] = sized_dest_vector[2][i*3];
            assign sized_dest_vector[2][(i*3)+2] = sized_dest_vector[2][i*3];
        end
    endgenerate

    wire notinuseld, notinuserd;
    nor3$ g8(.out(notinuseld), .in0(ldsize[2]), .in1(ldsize[1]), .in2(ldsize[0]));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(24)) m0(.in({{24{1'b0}},sized_ld_vector[2],sized_ld_vector[1],sized_ld_vector[0]}), .sel({notinuseld,ldsize}), .out(adjusted_sized_ld_vector));
    nor3$ g9(.out(notinuserd), .in0(rdsize[2]), .in1(rdsize[1]), .in2(rdsize[0]));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(24)) m1(.in({{24{1'b0}},sized_dest_vector[2],sized_dest_vector[1],sized_dest_vector[0]}), .sel({notinuserd,rdsize}), .out(adjusted_sized_dest_vector));

    wire [255:0] outs, ptcs;
    wire [31:0] out32 [0:7], out16 [0:7], out8h [0:3], out8l [0:3], ptc32 [0:7], ptc16 [0:7], ptc8h [0:3], ptc8l [0:3];
    wire [15:0] e_in [0:7], e_out [0:7], e_ptc [0:7];
    wire [7:0] h_in [0:7], l_in [0:7], h_out [0:7], l_out [0:7], h_ptc [0:7], l_ptc[0:7];
    

    generate
        for (i = 0; i < 8; i = i + 1) begin : gpr_slots
            wire [7:0] which_h [0:1];

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(16)) m2(.in({din[127:112],din[95:80],din[63:48],din[31:16]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(e_in[i]));

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m3(.in({din[111:104],din[79:72],din[47:40],din[15:8]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(which_h[0]));
            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m4(.in({din[103:96],din[71:64],din[39:32],din[7:0]}), .sel({ld[28+i],ld[20+i],ld[12+i],ld[4+i]}), .out(which_h[1]));
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m5(.in({which_h[1],which_h[0]}), .sel(ldsize[0]), .out(h_in[i]));

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m6(.in({din[103:96],din[71:64],din[39:32],din[7:0]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(l_in[i]));
    
            gpr r0(.din({e_in[i],h_in[i],l_in[i]}), .sized_ld(adjusted_sized_ld_vector[(i*3)+2:i*3]), .sized_dest(adjusted_sized_dest_vector[(i*3)+2:i*3]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .clk(clk), .e_dout(e_out[i]), .e_ptc(e_ptc[i]), .h_dout(h_out[i]), .h_ptc(h_ptc[i]), .l_dout(l_out[i]) ,.l_ptc(l_ptc[i]));

            wire notinuserd;
            nor3$ g5(.out(notinuserd), .in0(rdsize[2]), .in1(rdsize[1]), .in2(rdsize[0]));

            assign out32[i] = {e_out[i],h_out[i],l_out[i]};
            assign out16[i] = {16'h0000,h_out[i],l_out[i]};
            assign ptc32[i] = {e_ptc[i],h_ptc[i],l_ptc[i]};
            assign ptc16[i] = {16'h0000,h_ptc[i],l_ptc[i]};
            if (i < 4) begin
                assign ptc8h[i] = {24'h000000,h_ptc[i]};
                assign ptc8l[i] = {24'h000000,l_ptc[i]};
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m7(.in({{32{1'b0}},out32[i],out16[i],out8l[i]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m8(.in({{32{1'b0}},ptc32[i],ptc16[i],ptc8l[i]}), .sel({notinuserd,rdsize}), .out(ptcs[(i*32)+31:i*32]));
            end else begin
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m9(.in({{32{1'b0}},out32[i],out16[i],out8h[i-4]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m10(.in({{32{1'b0}},ptc32[i],ptc16[i],ptc8h[i-4]}), .sel({notinuserd,rdsize}), .out(ptcs[(i*32)+31:i*32]));
            end
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m11(.in(outs), .sel(rd[2:0]), .out(dout[31:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m12(.in(outs), .sel(rd[5:3]), .out(dout[63:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m13(.in(outs), .sel(rd[8:6]), .out(dout[95:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m14(.in(outs), .sel(rd[11:9]), .out(dout[127:96]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m15(.in(ptcs), .sel(rd[2:0]), .out(ptcout[31:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m16(.in(ptcs), .sel(rd[5:3]), .out(ptcout[63:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m17(.in(ptcs), .sel(rd[8:6]), .out(ptcout[95:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m18(.in(ptcs), .sel(rd[11:9]), .out(ptcout[127:96]));

    integer k;
    always @(posedge clk) begin
        #1;
        k = 0;
        $display("EAX = 0x%h   PTC:%b", {e_out[0],h_out[0],l_out[0]}, {e_ptc[0][15],e_ptc[0][7],h_ptc[0][7],l_ptc[0][7]});
        k = 1;
        $display("ECX = 0x%h   PTC:%b", {e_out[1],h_out[1],l_out[1]}, {e_ptc[1][15],e_ptc[1][7],h_ptc[1][7],l_ptc[1][7]});
        k = 2;
        $display("EDX = 0x%h   PTC:%b", {e_out[2],h_out[2],l_out[2]}, {e_ptc[2][15],e_ptc[2][7],h_ptc[2][7],l_ptc[2][7]});
        k = 3;
        $display("EBX = 0x%h   PTC:%b", {e_out[3],h_out[3],l_out[3]}, {e_ptc[3][15],e_ptc[3][7],h_ptc[3][7],l_ptc[3][7]});
        k = 4;
        $display("ESP = 0x%h   PTC:%b", {e_out[4],h_out[4],l_out[4]}, {e_ptc[4][15],e_ptc[4][7],h_ptc[4][7],l_ptc[4][7]});
        k = 5;
        $display("EBP = 0x%h   PTC:%b", {e_out[5],h_out[5],l_out[5]}, {e_ptc[5][15],e_ptc[5][7],h_ptc[5][7],l_ptc[5][7]});
        k = 6;
        $display("ESI = 0x%h   PTC:%b", {e_out[6],h_out[6],l_out[6]}, {e_ptc[6][15],e_ptc[6][7],h_ptc[6][7],l_ptc[6][7]});
        k = 7;
        $display("EDI = 0x%h   PTC:%b", {e_out[7],h_out[7],l_out[7]}, {e_ptc[7][15],e_ptc[7][7],h_ptc[7][7],l_ptc[7][7]});
    end
endmodule

module gpr (input [31:0] din,
            input [2:0] sized_ld, sized_dest,
            input [6:0] data_ptcid, new_ptcid,
            input clr,
            input clk,
            output [15:0] e_dout, e_ptc,
            output [7:0] h_dout, l_dout, h_ptc, l_ptc);
    
    regn #(.WIDTH(16)) e_section(.din(din[31:16]), .ld(sized_ld[2]), .clr(clr), .clk(clk), .dout(e_dout));
    regn #(.WIDTH(8)) h_section(.din(din[15:8]), .ld(sized_ld[1]), .clr(clr), .clk(clk), .dout(h_dout));
    regn #(.WIDTH(8)) l_section(.din(din[7:0]), .ld(sized_ld[0]), .clr(clr), .clk(clk), .dout(l_dout));

    wire clearptc [0:2], ptcld [0:2];
    wire ptc [0:2];
    wire [6:0] id [0:2];

    regn #(.WIDTH(7)) e_ptcid(.din(new_ptcid), .ld(sized_dest[2]), .clr(clr), .clk(clk), .dout(id[2]));
    equaln #(.WIDTH(7)) eq0(.a(data_ptcid), .b(id[2]), .eq(clearptc[2]));
    or2$ g0(.out(ptcld[2]), .in0(sized_dest[2]), .in1(clearptc[2]));
    regn #(.WIDTH(1)) e_ptcv(.din(sized_dest[2]), .ld(ptcld[2]), .clr(clr), .clk(clk), .dout(ptc[2]));
    assign e_ptc = {2{ptc[2],id[2]}};

    regn #(.WIDTH(7)) h_ptcid(.din(new_ptcid), .ld(sized_dest[1]), .clr(clr), .clk(clk), .dout(id[1]));
    equaln #(.WIDTH(7)) eq1(.a(data_ptcid), .b(id[1]), .eq(clearptc[1]));
    or2$ g1(.out(ptcld[1]), .in0(sized_dest[1]), .in1(clearptc[1]));
    regn #(.WIDTH(1)) h_ptcv(.din(sized_dest[1]), .ld(ptcld[1]), .clr(clr), .clk(clk), .dout(ptc[1]));
    assign h_ptc = {ptc[1],id[1]};

    regn #(.WIDTH(7)) l_ptcid(.din(new_ptcid), .ld(sized_dest[0]), .clr(clr), .clk(clk), .dout(id[0]));
    equaln #(.WIDTH(7)) eq2(.a(data_ptcid), .b(id[0]), .eq(clearptc[0]));
    or2$ g2(.out(ptcld[0]), .in0(sized_dest[0]), .in1(clearptc[0]));
    regn #(.WIDTH(1)) l_ptcv(.din(sized_dest[0]), .ld(ptcld[0]), .clr(clr), .clk(clk), .dout(ptc[0]));
    assign l_ptc = {ptc[0],id[0]};

endmodule



module mmxfile (input [255:0] din,
                input [31:0] ld, dest,
                input [11:0] rd,
                input [6:0] data_ptcid, new_ptcid,
                input clr,
                input clk,
                output [255:0] dout, ptcout);

    wire [511:0] ins, outs, ptcs;
    wire [7:0] ld_vector, dest_vector;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mmx_slots
            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(64)) m0(.in(din), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(ins[(i+1)*64-1:i*64]));
            or4$ g0(.out(ld_vector[i]), .in0(ld[i]), .in1(ld[8+i]), .in2(ld[16+i]), .in3(ld[24+i]));
            or4$ g1(.out(dest_vector[i]), .in0(dest[i]), .in1(dest[8+i]), .in2(dest[16+i]), .in3(dest[24+i]));
            mmx r0(.din(ins[(i+1)*64-1:i*64]), .ld(ld_vector[i]), .dest(dest_vector[i]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .clk(clk), .dout(outs[(i+1)*64-1:i*64]), .mm_ptc(ptcs[(i+1)*64-1:i*64]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m0(.in(outs), .sel(rd[2:0]), .out(dout[63:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m1(.in(outs), .sel(rd[5:3]), .out(dout[127:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m2(.in(outs), .sel(rd[8:6]), .out(dout[191:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m3(.in(outs), .sel(rd[11:9]), .out(dout[255:192]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m4(.in(ptcs), .sel(rd[2:0]), .out(ptcout[63:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m5(.in(ptcs), .sel(rd[5:3]), .out(ptcout[127:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m6(.in(ptcs), .sel(rd[8:6]), .out(ptcout[191:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m7(.in(ptcs), .sel(rd[11:9]), .out(ptcout[255:192]));

    integer k;
    always @(posedge clk) begin
        #2;
        k = 0;
        $display("MM0 = 0x%h   PTC:%b", outs[63:0], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 1;
        $display("MM1 = 0x%h   PTC:%b", outs[127:64], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 2;
        $display("MM2 = 0x%h   PTC:%b", outs[191:128], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 3;
        $display("MM3 = 0x%h   PTC:%b", outs[255:192], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 4;
        $display("MM4 = 0x%h   PTC:%b", outs[319:256], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 5;
        $display("MM5 = 0x%h   PTC:%b", outs[383:320], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 6;
        $display("MM6 = 0x%h   PTC:%b", outs[447:384], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
        k = 7;
        $display("MM7 = 0x%h   PTC:%b", outs[511:448], {ptcs[(k*64)+63],ptcs[(k*64)+55],ptcs[(k*64)+47],ptcs[(k*64)+39],ptcs[(k*64)+31],ptcs[(k*64)+23],ptcs[(k*64)+15],ptcs[(k*64)+7]});
    end

endmodule

module mmx (input [63:0] din,
            input ld, dest,
            input [6:0] data_ptcid, new_ptcid,
            input clr,
            input clk,
            output [63:0] dout, mm_ptc);
    
    regn #(.WIDTH(64)) mm(.din(din), .ld(ld), .clr(clr), .clk(clk), .dout(dout));
    
    wire clearptc, ptcld;
    wire ptc;
    wire [6:0] id;

    regn #(.WIDTH(7)) mm_ptcid(.din(new_ptcid), .ld(dest), .clr(clr), .clk(clk), .dout(id));
    equaln #(.WIDTH(7)) eq0(.a(data_ptcid), .b(id), .eq(clearptc));
    or2$ g0(.out(ptcld), .in0(dest), .in1(clearptc));
    regn #(.WIDTH(1)) mm_ptcv(.din(dest), .ld(ptcld), .clr(clr), .clk(clk), .dout(ptc));
    assign mm_ptc = {8{ptc,id}};

endmodule