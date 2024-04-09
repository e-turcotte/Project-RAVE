module rshfn_fixed #(parameter WIDTH=8, SHF_AMNT=0) (input [WIDTH-1:0] in,
                                                     input [SHF_AMNT-1:0] shf_val,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = SHF_AMNT; i < WIDTH; i = i + 1) begin : rshf_fixed_slices
            assign out[i-SHF_AMNT] = in[i];
        end
        if (SHF_AMNT > 0) begin
            assign out[WIDTH-1:WIDTH-SHF_AMNT] = shf_val;
        end
    endgenerate

endmodule

module lshfn_fixed #(parameter WIDTH=8, SHF_AMNT=0) (input [WIDTH-1:0] in,
                                                     input [SHF_AMNT-1:0] shf_val,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = SHF_AMNT; i < WIDTH; i = i + 1) begin : lshf_fixed_slices
            assign out[i] = in[i-SHF_AMNT];
        end
        if (SHF_AMNT > 0) begin
            assign out[SHF_AMNT-1:0] = shf_val;
        end
    endgenerate

endmodule

module rshfn_variable #(parameter WIDTH=8) (input [WIDTH-1:0] in, shf,
                                            input shf_val,
                                            output [WIDTH-1:0] out);
    
    wire [WIDTH*WIDTH-1:0] shf_outs;

    assign shf_outs[WIDTH-1:0] = in;

    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : rshf_shifters
            rshfn_fixed #(.WIDTH(WIDTH), .SHF_AMNT(i)) m0(.in(in), .shf_val({i{shf_val}}), .out(shf_outs[(i+1)*WIDTH-1:i*WIDTH]));
        end
    endgenerate

    muxnm_tristate #(.NUM_INPUTS(WIDTH), .DATA_WIDTH(WIDTH)) m1(.in(shf_outs), .sel(shf), .out(out));
endmodule

module lshfn_variable #(parameter WIDTH=8) (input [WIDTH-1:0] in, shf,
                                            input shf_val,
                                            output [WIDTH-1:0] out);
    
    wire [WIDTH*WIDTH-1:0] shf_outs;

    assign shf_outs[WIDTH-1:0] = in;

    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : lshf_shifters
            lshfn_fixed #(.WIDTH(WIDTH), .SHF_AMNT(i)) m0(.in(in), .shf_val({i{shf_val}}), .out(shf_outs[(i+1)*WIDTH-1:i*WIDTH]));
        end
    endgenerate

    muxnm_tristate #(.NUM_INPUTS(WIDTH), .DATA_WIDTH(WIDTH)) m1(.in(shf_outs), .sel(shf), .out(out));
endmodule




module rrotn_fixed #(parameter WIDTH=8, ROT_AMNT=0) (input [WIDTH-1:0] in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = ROT_AMNT; i < WIDTH; i = i + 1) begin : rrot_fixed_slices
            assign out[i-ROT_AMNT] = in[i];
        end
        if (ROT_AMNT > 0) begin
            assign out[WIDTH-1:WIDTH-ROT_AMNT] = in[ROT_AMNT-1:0];
        end
    endgenerate

endmodule

module lrotn_fixed #(parameter WIDTH=8, ROT_AMNT=0) (input [WIDTH-1:0] in,
                                                     output [WIDTH-1:0] out);

    genvar i;
    generate
        for (i = ROT_AMNT; i < WIDTH; i = i + 1) begin : lrot_fixed_slices
            assign out[i] = in[i-ROT_AMNT];
        end
        if (ROT_AMNT > 0) begin
            assign out[ROT_AMNT-1:0] = in[WIDTH-1:WIDTH-ROT_AMNT];
        end
    endgenerate

endmodule

module rrotn_variable #(parameter WIDTH=8) (input [WIDTH-1:0] in, rot,
                                            output [WIDTH-1:0] out);
    
    wire [WIDTH*WIDTH-1:0] rot_outs;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : rshf_shifters
            rrotn_fixed #(.WIDTH(WIDTH), .ROT_AMNT(i)) m0(.in(in), .out(rot_outs[(i+1)*WIDTH-1:i*WIDTH]));
        end
    endgenerate

    muxnm_tristate #(.NUM_INPUTS(WIDTH), .DATA_WIDTH(WIDTH)) m1(.in(rot_outs), .sel(rot), .out(out));
endmodule

module lrotn_variable #(parameter WIDTH=8) (input [WIDTH-1:0] in, rot,
                                            output [WIDTH-1:0] out);
    
    wire [WIDTH*WIDTH-1:0] rot_outs;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : rshf_shifters
            lrotn_fixed #(.WIDTH(WIDTH), .ROT_AMNT(i)) m0(.in(in), .out(rot_outs[(i+1)*WIDTH-1:i*WIDTH]));
        end
    endgenerate

    muxnm_tristate #(.NUM_INPUTS(WIDTH), .DATA_WIDTH(WIDTH)) m1(.in(rot_outs), .sel(rot), .out(out));
endmodule