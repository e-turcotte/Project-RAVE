module bank (input [8:0] addr,
             input rw, bnk_en,
             input [127:0] din,
             output [127:0] dout);

    wire [15:0] ce_vector, invce_vector;

    decodern #(.INPUT_WIDTH(4)) d0(.in(addr[8:5]), .out(ce_vector));

    wire buf_rw, buf_bnk_en;

    bufferH256_nb$ #(.WIDTH(1)) buf0(.in(rw), .out(buf_rw));
    bufferH256_nb$ #(.WIDTH(1)) buf1(.in(bnk_en), .out(buf_bnk_en));

    wire [127:0] dio;

    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : dio_slices
            tristateL$ ts0(.enbar(buf_rw), .in(din[i]), .out(dio[i]));
        end

        for (i = 0; i < 16; i = i + 1) begin : bank_slices
            nand2$ g0(.out(invce_vector[i]), .in0(ce_vector[i]), .in1(buf_bnk_en));
            dramcell dram(.addr(addr[4:0]), .rw(buf_rw), .ce(invce_vector[i]), .dio(dio));
        end
    endgenerate

    assign dout = dio;

endmodule