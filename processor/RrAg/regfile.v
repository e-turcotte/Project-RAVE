module regfile (input [127:0] din,
                input [5:0] ld_addr,
                input [11:0] rd_addr,
                input [3:0] ldsize, rdsize,
                input [1:0] ld_en,
                input clr,
                input clk,
                output [255:0] dout);

    wire usegpr, usemmx;
    
    inv1$ g0(.out(usegpr), .in(ldsize[3]));
    assign usemmx = ldsize[3];

    wire [15:0] gprld, mmxld, decodedld;

    decodern #(.INPUT_WIDTH(3)) d0(.in(ld_addr[2:0]), .out(decodedld[7:0]));
    decodern #(.INPUT_WIDTH(3)) d1(.in(ld_addr[5:3]), .out(decodedld[15:8])); 

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : ld_slices
            if (i < 8) begin
                and3$ g2(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[0]));
                and3$ g3(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[0]));
            end else begin
                and3$ g4(.out(mmxld[i]), .in0(decodedld[i]), .in1(usemmx), .in2(ld_en[1]));
                and3$ g5(.out(gprld[i]), .in0(decodedld[i]), .in1(usegpr), .in2(ld_en[1]));
            end
        end
    endgenerate

    wire [127:0] gprouts;
    wire [255:0] mmxouts;

    gprfile gf(.din({din[95:64],din[31:0]}), .ld(gprld), .rd(rd_addr), .ldsize(ldsize[2:0]), .rdsize(rdsize[2:0]), .clr(clr), .clk(clk), .dout(gprouts));
    mmxfile mf(.din(din), .ld(mmxld), .rd(rd_addr), .clr(clr), .clk(clk), .dout(mmxouts));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(256)) m0(.in({mmxouts,{32{1'b0}},gprouts[127:96],{32{1'b0}},gprouts[95:64],{32{1'b0}},gprouts[63:32],{32{1'b0}},gprouts[31:0]}), .sel(rdsize[3]), .out(dout));

endmodule




module gprfile (input [63:0] din,
                input [15:0] ld,
                input [11:0] rd,
                input [2:0] ldsize, rdsize,
                input clr,
                input clk,
                output [127:0] dout);

    wire [23:0] sized_ld_vector [0:2], adjusted_sized_ld_vector;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sized_ld_slices
            if (i < 4) begin
                or2$ g0(.out(sized_ld_vector[0][i*3]), .in0(ld[i]), .in1(ld[8+i]));
                or2$ g1(.out(sized_ld_vector[0][(i*3)+1]), .in0(ld[4+i]), .in1(ld[12+i]));
            end else begin
                assign sized_ld_vector[0][i*3] = 1'b0;
                assign sized_ld_vector[0][(i*3)+1] = 1'b0;
            end
            assign sized_ld_vector[0][(i*3)+2] = 1'b0;

            or2$ g2(.out(sized_ld_vector[1][i*3]), .in0(ld[i]), .in1(ld[8+i]));
            assign sized_ld_vector[1][(i*3)+1] = sized_ld_vector[1][i*3];
            assign sized_ld_vector[1][(i*3)+2] = 1'b0;

            or2$ g3(.out(sized_ld_vector[2][i*3]), .in0(ld[i]), .in1(ld[8+i]));
            assign sized_ld_vector[2][(i*3)+1] = sized_ld_vector[2][i*3];
            assign sized_ld_vector[2][(i*3)+2] = sized_ld_vector[2][i*3];
        end
    endgenerate

    wire notinuseld;
    nor3$ g4(.out(notinuseld), .in0(ldsize[2]), .in1(ldsize[1]), .in2(ldsize[0]));
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(24)) m0(.in({{24{1'b0}},sized_ld_vector[2],sized_ld_vector[1],sized_ld_vector[0]}), .sel({notinuseld,ldsize}), .out(adjusted_sized_ld_vector));

    wire [255:0] outs;
    wire [31:0] out32 [0:7], out16 [0:7], out8h [0:3], out8l [0:3];
    wire [15:0] e_in [0:7], e_out [0:7];
    wire [7:0] h_in [0:7], l_in [0:7], h_out [0:7], l_out [0:7];
    

    generate
        for (i = 0; i < 8; i = i + 1) begin : gpr_slots
            wire [7:0] which_h [0:1];

            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(16)) m1(.in({din[63:48],din[31:16]}), .sel(ld[8+i]), .out(e_in[i]));

            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m2(.in({din[47:40],din[15:8]}), .sel(ld[8+i]), .out(which_h[0]));
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m3(.in({din[7:0],din[39:32]}), .sel(ld[4+i]), .out(which_h[1]));
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m4(.in({which_h[1],which_h[0]}), .sel(ldsize[0]), .out(h_in[i]));

            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) m5(.in({din[39:32],din[7:0]}), .sel(ld[8+i]), .out(l_in[i]));
    
            gpr r0(.din({e_in[i],h_in[i],l_in[i]}), .sized_ld(adjusted_sized_ld_vector[(i*3)+2:i*3]), .clr(clr), .clk(clk), .e_dout(e_out[i]), .h_dout(h_out[i]), .l_dout(l_out[i]));

            wire notinuserd;
            nor3$ g5(.out(notinuserd), .in0(rdsize[2]), .in1(rdsize[1]), .in2(rdsize[0]));

            assign out32[i] = {e_out[i],h_out[i],l_out[i]};
            assign out16[i] = {16'h0000,h_out[i],l_out[i]};
            if (i < 4) begin
                assign out8h[i] = {24'h000000,h_out[i]};
                assign out8l[i] = {24'h000000,l_out[i]};
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m6(.in({{32{1'b0}},out32[i],out16[i],out8l[i]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
            end else begin
                muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m7(.in({{32{1'b0}},out32[i],out16[i],out8h[i-4]}), .sel({notinuserd,rdsize}), .out(outs[(i*32)+31:i*32]));
            end
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m8(.in(outs), .sel(rd[2:0]), .out(dout[31:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m9(.in(outs), .sel(rd[5:3]), .out(dout[63:32]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m10(.in(outs), .sel(rd[8:6]), .out(dout[95:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m11(.in(outs), .sel(rd[11:9]), .out(dout[127:96]));

    always @(posedge clk) begin
        #1;
        $display("EAX = 0x%0h", {e_out[0],h_out[0],l_out[0]});
        $display("ECX = 0x%0h", {e_out[1],h_out[1],l_out[1]});
        $display("EDX = 0x%0h", {e_out[2],h_out[2],l_out[2]});
        $display("EBX = 0x%0h", {e_out[3],h_out[3],l_out[3]});
        $display("ESP = 0x%0h", {e_out[4],h_out[4],l_out[4]});
        $display("EBP = 0x%0h", {e_out[5],h_out[5],l_out[5]});
        $display("ESI = 0x%0h", {e_out[6],h_out[6],l_out[6]});
        $display("EDI = 0x%0h", {e_out[7],h_out[7],l_out[7]});
    end
endmodule

module gpr (input [31:0] din,
            input [2:0] sized_ld,
            input clr,
            input clk,
            output [15:0] e_dout,
            output [7:0] h_dout, l_dout);
    
    regn #(.WIDTH(16)) e_section(.din(din[31:16]), .ld(sized_ld[2]), .clr(clr), .clk(clk), .dout(e_dout));
    regn #(.WIDTH(8)) h_section(.din(din[15:8]), .ld(sized_ld[1]), .clr(clr), .clk(clk), .dout(h_dout));
    regn #(.WIDTH(8)) l_section(.din(din[7:0]), .ld(sized_ld[0]), .clr(clr), .clk(clk), .dout(l_dout));

endmodule



module mmxfile (input [127:0] din,
                input [15:0] ld,
                input [11:0] rd,
                input clr,
                input clk,
                output [255:0] dout);

    wire [511:0] ins, outs;
    wire [7:0] ld_vector;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mmx_slots
            muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(64)) m0(.in(din), .sel(ld[8+i]), .out(ins[(i+1)*64-1:i*64]));
            or2$ g0(.out(ld_vector[i]), .in0(ld[i]), .in1(ld[8+i]));
            mmx r0(.din(ins[(i+1)*64-1:i*64]), .ld(ld_vector[i]), .clr(clr), .clk(clk), .dout(outs[(i+1)*64-1:i*64]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m0(.in(outs), .sel(rd[2:0]), .out(dout[63:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m1(.in(outs), .sel(rd[5:3]), .out(dout[127:64]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m2(.in(outs), .sel(rd[8:6]), .out(dout[191:128]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(64)) m3(.in(outs), .sel(rd[11:9]), .out(dout[255:192]));

    always @(posedge clk) begin
        #2;
        $display("MM0 = 0x%0h", outs[63:0]);
        $display("MM1 = 0x%0h", outs[127:64]);
        $display("MM2 = 0x%0h", outs[191:128]);
        $display("MM3 = 0x%0h", outs[255:192]);
        $display("MM4 = 0x%0h", outs[319:256]);
        $display("MM5 = 0x%0h", outs[383:320]);
        $display("MM6 = 0x%0h", outs[447:384]);
        $display("MM7 = 0x%0h", outs[511:448]);
    end

endmodule

module mmx (input [63:0] din,
            input ld, clr,
            input clk,
            output [63:0] dout);
    
    regn #(.WIDTH(64)) mm(.din(din), .ld(ld), .clr(clr), .clk(clk), .dout(dout));

endmodule