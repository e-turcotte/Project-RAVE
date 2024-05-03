module sext_8_to_32 (
    input wire [7:0] in,
    output wire [31:0] out
);
wire msb_buffered;
bufferH16$ b0(.out(msb_buffered), .in(in[7]));
genvar i;
generate
    for (i = 31; i > 7; i = i - 1) begin : sext_slices
        assign out[i] = msb_buffered;
    end
    assign out[7:0] = in;
endgenerate

endmodule

module sext_8_to_48 (
    input wire [7:0] in,
    output wire [47:0] out
);
wire msb_buffered;
bufferH16$ b0(.out(msb_buffered), .in(in[7]));
genvar i;
generate
    for (i = 47; i > 7; i = i - 1) begin : sext_slices
        assign out[i] = msb_buffered;
    end
    assign out[7:0] = in;
endgenerate


endmodule

module sext_16_to_32 (
    input wire [15:0] in,
    output wire [31:0] out
);
wire msb_buffered;
bufferH16$ b0(.out(msb_buffered), .in(in[15]));
genvar i;
generate
    for (i = 31; i > 15; i = i - 1) begin : sext_slices
        assign out[i] = msb_buffered;
    end
    assign out[15:0] = in;
endgenerate

endmodule

module sext_16_to_48 (
    input wire [15:0] in,
    output wire [47:0] out
);
wire msb_buffered;
bufferH16$ b0(.out(msb_buffered), .in(in[15]));
genvar i;
generate
    for (i = 47; i > 15; i = i - 1) begin : sext_slices
        assign out[i] = msb_buffered;
    end
    assign out[15:0] = in;
endgenerate

endmodule

module sext_32_to_48 (
    input wire [31:0] in,
    output wire [47:0] out
);
wire msb_buffered;
bufferH16$ b0(.out(msb_buffered), .in(in[31]));
genvar i;
generate
    for (i = 47; i > 31; i = i - 1) begin : sext_slices
        assign out[i] = msb_buffered;
    end
    assign out[31:0] = in;
endgenerate

endmodule
