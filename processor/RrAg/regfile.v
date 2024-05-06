module regfile (input [255:0] din,
                input [11:0] ld_addr, rd_addr,
                input [1:0] ldsize, rdsize,
                input addressingmode,
                input [3:0] ld_en, dest,
                input [6:0] data_ptcid, new_ptcid,
                input clr, ptcclr,
                input clk,
                output [255:0] dout,
                output [127:0] addrout,
                output [511:0] ptcout,
                output [3:0] addrptc);

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

    wire [127:0] gprouts;
    wire [255:0] gprptcs;
    wire [255:0] mmxouts;
    wire [511:0] mmxptcs;

    gprfile gf(.din({din[223:192],din[159:128],din[95:64],din[31:0]}), .ld(gprld), .dest(gprdest), .rd(rd_addr), .ldsize(decodedldsize[2:0]), .rdsize(decodedrdsize[2:0]), .addressingmode(addressingmode), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .ptcclr(ptcclr), .clk(clk), .dout(gprouts), .addrout(addrout), .ptcout(gprptcs), .addrptc(addrptc));
    mmxfile mf(.din(din), .ld(mmxld), .dest(mmxdest), .rd(rd_addr), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .clr(clr), .ptcclr(ptcclr), .clk(clk), .dout(mmxouts), .ptcout(mmxptcs));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(256)) m0(.in({mmxouts,{32{gprouts[127]}},gprouts[127:96],{32{gprouts[95]}},gprouts[95:64],{32{gprouts[63]}},gprouts[63:32],{32{gprouts[31]}},gprouts[31:0]}), .sel(usemmx), .out(dout));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(512)) m1(.in({mmxptcs,{64{1'b0}},gprptcs[255:192],{64{1'b0}},gprptcs[191:128],{64{1'b0}},gprptcs[127:64],{64{1'b0}},gprptcs[63:0]}), .sel(rdsize[3]), .out(ptcout));

    integer k, cyc_cnt;
    integer file;

    initial begin
        cyc_cnt = 0;
        file = $fopen("regfile.out", "w");
    end

    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;

        $fdisplay(file, "[===GPR VALUES===]");
        k = 0;
        $fdisplay(file, "EAX = 0x%h   PTC:%b", {gf.e_out[0],gf.h_out[0],gf.l_out[0]}, {gf.e_ptc[0][30],gf.e_ptc[0][14],gf.h_ptc[0][14],gf.l_ptc[0][14]});
        k = 1;
        $fdisplay(file, "ECX = 0x%h   PTC:%b", {gf.e_out[1],gf.h_out[1],gf.l_out[1]}, {gf.e_ptc[1][30],gf.e_ptc[1][14],gf.h_ptc[1][14],gf.l_ptc[1][14]});
        k = 2;
        $fdisplay(file, "EDX = 0x%h   PTC:%b", {gf.e_out[2],gf.h_out[2],gf.l_out[2]}, {gf.e_ptc[2][30],gf.e_ptc[2][14],gf.h_ptc[2][14],gf.l_ptc[2][14]});
        k = 3;
        $fdisplay(file, "EBX = 0x%h   PTC:%b", {gf.e_out[3],gf.h_out[3],gf.l_out[3]}, {gf.e_ptc[3][30],gf.e_ptc[3][14],gf.h_ptc[3][14],gf.l_ptc[3][14]});
        k = 4;
        $fdisplay(file, "ESP = 0x%h   PTC:%b", {gf.e_out[4],gf.h_out[4],gf.l_out[4]}, {gf.e_ptc[4][30],gf.e_ptc[4][14],gf.h_ptc[4][14],gf.l_ptc[4][14]});
        k = 5;
        $fdisplay(file, "EBP = 0x%h   PTC:%b", {gf.e_out[5],gf.h_out[5],gf.l_out[5]}, {gf.e_ptc[5][30],gf.e_ptc[5][14],gf.h_ptc[5][14],gf.l_ptc[5][14]});
        k = 6;
        $fdisplay(file, "ESI = 0x%h   PTC:%b", {gf.e_out[6],gf.h_out[6],gf.l_out[6]}, {gf.e_ptc[6][30],gf.e_ptc[6][14],gf.h_ptc[6][14],gf.l_ptc[6][14]});
        k = 7;
        $fdisplay(file, "EDI = 0x%h   PTC:%b", {gf.e_out[7],gf.h_out[7],gf.l_out[7]}, {gf.e_ptc[7][30],gf.e_ptc[7][14],gf.h_ptc[7][14],gf.l_ptc[7][14]});
        
        $fdisplay(file, "[===MMX VALUES===]");
        k = 0;
        $fdisplay(file, "MM0 = 0x%h   PTC:%b", mf.outs[63:0], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 1;
        $fdisplay(file, "MM1 = 0x%h   PTC:%b", mf.outs[127:64], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 2;
        $fdisplay(file, "MM2 = 0x%h   PTC:%b", mf.outs[191:128], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 3;
        $fdisplay(file, "MM3 = 0x%h   PTC:%b", mf.outs[255:192], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 4;
        $fdisplay(file, "MM4 = 0x%h   PTC:%b", mf.outs[319:256], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 5;
        $fdisplay(file, "MM5 = 0x%h   PTC:%b", mf.outs[383:320], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 6;
        $fdisplay(file, "MM6 = 0x%h   PTC:%b", mf.outs[447:384], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});
        k = 7;
        $fdisplay(file, "MM7 = 0x%h   PTC:%b", mf.outs[511:448], {mf.ptcs[(k*128)+126],mf.ptcs[(k*128)+110],mf.ptcs[(k*128)+94],mf.ptcs[(k*128)+78],mf.ptcs[(k*128)+62],mf.ptcs[(k*128)+46],mf.ptcs[(k*128)+30],mf.ptcs[(k*128)+14]});

        $fdisplay(file, "\n");
    end

endmodule




module gprfile (input [127:0] din,
                input [31:0] ld, dest,
                input [11:0] rd,
                input [2:0] ldsize, rdsize,
                input addressingmode,
                input [6:0] data_ptcid, new_ptcid,
                input clr, ptcclr,
                input clk,
                output [127:0] dout, addrout,
                output [255:0] ptcout,
                output [3:0] addrptc);

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

    wire [255:0] outs, addrs;
    wire [511:0] ptcs;
    wire [31:0] addr_ptcs;
    wire [7:0] addr_is_ptc;
    wire [31:0] out32 [0:7], out16 [0:7], out8h [0:3], out8l [0:3];
    wire [63:0] ptc32 [0:7], ptc16 [0:7], ptc8h [0:3], ptc8l [0:3];
    wire [15:0] e_in [0:7], e_out [0:7];
    wire [31:0] e_ptc [0:7];
    wire [7:0] h_in [0:7], l_in [0:7], h_out [0:7], l_out [0:7];
    wire [15:0] h_ptc [0:7], l_ptc[0:7];
    

    generate
        for (i = 0; i < 8; i = i + 1) begin : gpr_slots
            wire [2:0] loc;

            case (i)
                0: assign loc = 3'b000;
                1: assign loc = 3'b001;
                2: assign loc = 3'b010;
                3: assign loc = 3'b011;
                4: assign loc = 3'b100;
                5: assign loc = 3'b101;
                6: assign loc = 3'b110;
                7: assign loc = 3'b111;
                default: assign loc = 3'b000;
            endcase

            wire [7:0] which_h [0:1];

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(16)) m2(.in({din[127:112],din[95:80],din[63:48],din[31:16]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(e_in[i]));

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m3(.in({din[111:104],din[79:72],din[47:40],din[15:8]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(which_h[0]));
            if (i < 4) begin
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m4(.in({din[103:96],din[71:64],din[39:32],din[7:0]}), .sel({ld[28+i],ld[20+i],ld[12+i],ld[4+i]}), .out(which_h[1]));
            end else begin
                assign which_h[1] = 8'h00;
            end
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m5(.in({which_h[1],which_h[0]}), .sel(ldsize[0]), .out(h_in[i]));

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(8)) m6(.in({din[103:96],din[71:64],din[39:32],din[7:0]}), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(l_in[i]));
    
            gpr r0(.din({e_in[i],h_in[i],l_in[i]}), .sized_ld(adjusted_sized_ld_vector[(i*3)+2:i*3]), .sized_dest(adjusted_sized_dest_vector[(i*3)+2:i*3]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .loc(loc), .clr(clr), .ptcclr(ptcclr), .clk(clk), .e_dout(e_out[i]), .h_dout(h_out[i]), .l_dout(l_out[i]), .e_ptc(e_ptc[i]), .h_ptc(h_ptc[i]), .l_ptc(l_ptc[i]));

            wire notinuserd;
            nor3$ g5(.out(notinuserd), .in0(rdsize[2]), .in1(rdsize[1]), .in2(rdsize[0]));

            assign out32[i] = {e_out[i],h_out[i],l_out[i]};
            sext_16_to_32 s0(.in({h_out[i],l_out[i]}), .out(out16[i]));
            assign ptc32[i] = {e_ptc[i],h_ptc[i],l_ptc[i]};
            assign ptc16[i] = {32'h0000,h_ptc[i],l_ptc[i]};
            if (i < 4) begin
                sext_8_to_32 s1(.in(h_out[i]), .out(out8h[i]));
                sext_8_to_32 s2(.in(l_out[i]), .out(out8l[i]));
                assign ptc8h[i] = {48'h000000,h_ptc[i]};
                assign ptc8l[i] = {48'h000000,l_ptc[i]};
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m7(.in({{32{1'b0}},out32[i],out16[i],out8l[i]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(64)) m8(.in({{64{1'b0}},ptc32[i],ptc16[i],ptc8l[i]}), .sel({notinuserd,rdsize}), .out(ptcs[(i*64)+63:i*64]));
            end else begin
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m9(.in({{32{1'b0}},out32[i],out16[i],out8h[i-4]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(64)) m10(.in({{64{1'b0}},ptc32[i],ptc16[i],ptc8h[i-4]}), .sel({notinuserd,rdsize}), .out(ptcs[(i*64)+63:i*64]));
            end
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m11(.in({out32[i],out16[i]}), .sel(addressingmode), .out(addrs[(i+1)*32-1:i*32]));
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(4)) m12(.in({ptc32[i][62],ptc32[i][46],ptc32[i][30],ptc32[i][14],2'b00,ptc16[i][30],ptc16[i][14]}), .sel(addressingmode), .out(addr_ptcs[(i+1)*4-1:i*4]));
            or4$ g6(.out(addr_is_ptc[i]), .in0(addr_ptcs[i*4]), .in1(addr_ptcs[i*4+1]), .in2(addr_ptcs[i*4+2]), .in3(addr_ptcs[i*4+3]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m13(.in(outs), .sel(rd[2:0]), .out(dout[31:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m14(.in(outs), .sel(rd[5:3]), .out(dout[63:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m15(.in(outs), .sel(rd[8:6]), .out(dout[95:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m16(.in(outs), .sel(rd[11:9]), .out(dout[127:96]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m17(.in(ptcs), .sel(rd[2:0]), .out(ptcout[63:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m18(.in(ptcs), .sel(rd[5:3]), .out(ptcout[127:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m19(.in(ptcs), .sel(rd[8:6]), .out(ptcout[191:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m20(.in(ptcs), .sel(rd[11:9]), .out(ptcout[255:192]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m21(.in(addrs), .sel(rd[2:0]), .out(addrout[31:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m22(.in(addrs), .sel(rd[5:3]), .out(addrout[63:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m23(.in(addrs), .sel(rd[8:6]), .out(addrout[95:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m24(.in(addrs), .sel(rd[11:9]), .out(addrout[127:96]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(1)) m25(.in(addr_is_ptc), .sel(rd[2:0]), .out(addrptc[0])); 
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(1)) m26(.in(addr_is_ptc), .sel(rd[5:3]), .out(addrptc[1])); 
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(1)) m27(.in(addr_is_ptc), .sel(rd[8:6]), .out(addrptc[2]));                                                 
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(1)) m28(.in(addr_is_ptc), .sel(rd[11:9]), .out(addrptc[3])); 

endmodule

module gpr (input [31:0] din,
            input [2:0] sized_ld, sized_dest,
            input [6:0] data_ptcid, new_ptcid,
            input [2:0] loc,
            input clr, ptcclr,
            input clk,
            output [15:0] e_dout,
            output [7:0] h_dout, l_dout,
            output [31:0] e_ptc,
            output [15:0] h_ptc, l_ptc);
    
    regn #(.WIDTH(16)) e_section(.din(din[31:16]), .ld(sized_ld[2]), .clr(clr), .clk(clk), .dout(e_dout));
    regn #(.WIDTH(8)) h_section(.din(din[15:8]), .ld(sized_ld[1]), .clr(clr), .clk(clk), .dout(h_dout));
    regn #(.WIDTH(8)) l_section(.din(din[7:0]), .ld(sized_ld[0]), .clr(clr), .clk(clk), .dout(l_dout));

    wire clearptc [0:2], ptcld [0:2], clr_ptc_signal;
    wire v [0:2];
    wire [6:0] id [0:2];

    and2$ g0(.out(clr_ptc_signal), .in0(clr), .in1(ptcclr));

    regn #(.WIDTH(7)) e_ptcid(.din(new_ptcid), .ld(sized_dest[2]), .clr(clr), .clk(clk), .dout(id[2]));
    equaln #(.WIDTH(7)) eq0(.a(data_ptcid), .b(id[2]), .eq(clearptc[2]));
    or2$ g1(.out(ptcld[2]), .in0(sized_dest[2]), .in1(clearptc[2]));
    regn #(.WIDTH(1)) e_ptcv(.din(sized_dest[2]), .ld(ptcld[2]), .clr(clr_ptc_signal), .clk(clk), .dout(v[2]));
    assign e_ptc = {1'b0,v[2],id[2],1'b0,loc,3'b011,
                    1'b0,v[2],id[2],1'b0,loc,3'b010};

    regn #(.WIDTH(7)) h_ptcid(.din(new_ptcid), .ld(sized_dest[1]), .clr(clr), .clk(clk), .dout(id[1]));
    equaln #(.WIDTH(7)) eq1(.a(data_ptcid), .b(id[1]), .eq(clearptc[1]));
    or2$ g2(.out(ptcld[1]), .in0(sized_dest[1]), .in1(clearptc[1]));
    regn #(.WIDTH(1)) h_ptcv(.din(sized_dest[1]), .ld(ptcld[1]), .clr(clr_ptc_signal), .clk(clk), .dout(v[1]));
    assign h_ptc = {1'b0,v[1],id[1],1'b0,loc,3'b001};

    regn #(.WIDTH(7)) l_ptcid(.din(new_ptcid), .ld(sized_dest[0]), .clr(clr), .clk(clk), .dout(id[0]));
    equaln #(.WIDTH(7)) eq2(.a(data_ptcid), .b(id[0]), .eq(clearptc[0]));
    or2$ g3(.out(ptcld[0]), .in0(sized_dest[0]), .in1(clearptc[0]));
    regn #(.WIDTH(1)) l_ptcv(.din(sized_dest[0]), .ld(ptcld[0]), .clr(clr_ptc_signal), .clk(clk), .dout(v[0]));
    assign l_ptc = {1'b0,v[0],id[0],1'b0,loc,3'b000};

endmodule



module mmxfile (input [255:0] din,
                input [31:0] ld, dest,
                input [11:0] rd,
                input [6:0] data_ptcid, new_ptcid,
                input clr, ptcclr,
                input clk,
                output [255:0] dout,
                output [511:0] ptcout);

    wire [511:0] ins, outs;
    wire [1023:0] ptcs;
    wire [7:0] ld_vector, dest_vector;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mmx_slots
            wire [2:0] loc;

            case (i)
                0: assign loc = 3'b000;
                1: assign loc = 3'b001;
                2: assign loc = 3'b010;
                3: assign loc = 3'b011;
                4: assign loc = 3'b100;
                5: assign loc = 3'b101;
                6: assign loc = 3'b110;
                7: assign loc = 3'b111;
                default: assign loc = 3'b000;
            endcase

            muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(64)) m0(.in(din), .sel({ld[24+i],ld[16+i],ld[8+i],ld[i]}), .out(ins[(i+1)*64-1:i*64]));
            or4$ g0(.out(ld_vector[i]), .in0(ld[i]), .in1(ld[8+i]), .in2(ld[16+i]), .in3(ld[24+i]));
            or4$ g1(.out(dest_vector[i]), .in0(dest[i]), .in1(dest[8+i]), .in2(dest[16+i]), .in3(dest[24+i]));
            mmx r0(.din(ins[(i+1)*64-1:i*64]), .ld(ld_vector[i]), .dest(dest_vector[i]), .data_ptcid(data_ptcid), .new_ptcid(new_ptcid), .loc(loc), .clr(clr), .ptcclr(ptcclr), .clk(clk), .dout(outs[(i+1)*64-1:i*64]), .mm_ptc(ptcs[(i+1)*128-1:i*128]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m0(.in(outs), .sel(rd[2:0]), .out(dout[63:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m1(.in(outs), .sel(rd[5:3]), .out(dout[127:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m2(.in(outs), .sel(rd[8:6]), .out(dout[191:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m3(.in(outs), .sel(rd[11:9]), .out(dout[255:192]));

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(128)) m4(.in(ptcs), .sel(rd[2:0]), .out(ptcout[127:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(128)) m5(.in(ptcs), .sel(rd[5:3]), .out(ptcout[255:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(128)) m6(.in(ptcs), .sel(rd[8:6]), .out(ptcout[383:256]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(128)) m7(.in(ptcs), .sel(rd[11:9]), .out(ptcout[511:384]));

endmodule

module mmx (input [63:0] din,
            input ld, dest,
            input [6:0] data_ptcid, new_ptcid,
            input [2:0] loc,
            input clr, ptcclr,
            input clk,
            output [63:0] dout,
            output [127:0] mm_ptc);
    
    regn #(.WIDTH(64)) mm(.din(din), .ld(ld), .clr(clr), .clk(clk), .dout(dout));
    
    wire clearptc, ptcld, clr_ptc_signal;
    wire v;
    wire [6:0] id;

    regn #(.WIDTH(7)) mm_ptcid(.din(new_ptcid), .ld(dest), .clr(clr), .clk(clk), .dout(id));
    equaln #(.WIDTH(7)) eq0(.a(data_ptcid), .b(id), .eq(clearptc));
    or2$ g0(.out(ptcld), .in0(dest), .in1(clearptc));
    and2$ g1(.out(clr_ptc_signal), .in0(clr), .in1(ptcclr));
    regn #(.WIDTH(1)) mm_ptcv(.din(dest), .ld(ptcld), .clr(clr_ptc_signal), .clk(clk), .dout(v));
    assign mm_ptc = {1'b0,v,id,1'b0,loc,3'b111,
                     1'b0,v,id,1'b0,loc,3'b110,
                     1'b0,v,id,1'b0,loc,3'b101,
                     1'b0,v,id,1'b0,loc,3'b100,
                     1'b0,v,id,1'b0,loc,3'b011,
                     1'b0,v,id,1'b0,loc,3'b010,
                     1'b0,v,id,1'b0,loc,3'b001,
                     1'b0,v,id,1'b0,loc,3'b000};

endmodule