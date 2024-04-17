module segfile (input [15:0] base_in,
                input [2:0] ld_addr,
                input [5:0] rd_addr,
                input ld_en, clr,
                input clk,
                output [31:0] base_out,
                output [39:0] lim_out);

    wire [7:0] decodedld;

    decodern #(.INPUT_WIDTH(3)) d0(.in(ld_addr), .out(decodedld)); 

    wire [95:0] base_outs;
    wire [119:0] lim_outs;

    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : seg_slots
            wire [19:0] lim_in;

            case (i)
                3'b000:     assign lim_in = 20'h04fff; //CS
                3'b001:     assign lim_in = 20'h011ff; //DS
                3'b010:     assign lim_in = 20'h04000; //SS
                3'b011:     assign lim_in = 20'h003ff; //ES
                3'b100:     assign lim_in = 20'h003ff; //FS
                3'b101:     assign lim_in = 20'h007ff; //GS
                default:    assign lim_in = 0;
            endcase

            wire segld;

            and2$ g0(.out(segld), .in0(decodedld[i]), .in1(ld_en));

            seg r0(.base_in(base_in), .lim_in(lim_in), .ld(segld), .clr(clr), .clk(clk), .base_out(base_outs[(i+1)*16-1:i*16]), .lim_out(lim_outs[(i+1)*20-1:i*20]));
        end
    endgenerate

    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m0(.in({{32{1'b0}},base_outs}), .sel(rd_addr[2:0]), .out(base_out[15:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m1(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[2:0]), .out(lim_out[19:0]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(16)) m2(.in({{32{1'b0}},base_outs}), .sel(rd_addr[5:3]), .out(base_out[31:16]));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(20)) m3(.in({{40{1'b0}},lim_outs}), .sel(rd_addr[5:3]), .out(lim_out[39:20]));

    always @(posedge clk) begin
        #1;
        $display("CS = 0x%0h, lim:0x%0h", base_outs[15:0], lim_outs[19:0]);
        $display("DS = 0x%0h, lim:0x%0h", base_outs[31:16], lim_outs[39:20]);
        $display("SS = 0x%0h, lim:0x%0h", base_outs[47:32], lim_outs[59:40]);
        $display("ES = 0x%0h, lim:0x%0h", base_outs[63:48], lim_outs[79:60]);
        $display("FS = 0x%0h, lim:0x%0h", base_outs[79:64], lim_outs[99:80]);
        $display("GS = 0x%0h, lim:0x%0h", base_outs[95:80], lim_outs[119:100]);
    end

endmodule

module seg (input [15:0] base_in,
            input [19:0] lim_in,
            input ld, clr,
            input clk,
            output [15:0] base_out,
            output [19:0] lim_out);

    wire invclr;

    inv1$ g0(.out(invclr), .in(clr));
    
    regn #(.WIDTH(16)) base(.din(base_in), .ld(ld), .clr(clr), .clk(clk), .dout(base_out));
    regn #(.WIDTH(20)) lim(.din(lim_in), .ld(invclr), .clr(1'b1), .clk(clk), .dout(lim_out));

endmodule