module muxnm_tree #(parameter SEL_WIDTH=1, DATA_WIDTH=1) (input [(2**SEL_WIDTH)*DATA_WIDTH-1:0] in,
                                                              input [SEL_WIDTH-1:0] sel,
                                                              output [DATA_WIDTH-1:0] out);

    wire [(2**SEL_WIDTH)*DATA_WIDTH-1:0] datavector;

    genvar i, j;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : treemux_dataslices
            for (j = 0; j < (2**SEL_WIDTH); j = j + 1) begin : datavector_splits
                assign datavector[(i*(2**SEL_WIDTH))+j] = in[(DATA_WIDTH*j)+i];
            end
            muxn1_tree #(.SEL_WIDTH(SEL_WIDTH)) m0(.in(datavector[(i+1)*(2**SEL_WIDTH)-1:i*(2**SEL_WIDTH)]), .sel(sel), .out(out[i]));
        end
    endgenerate

endmodule

module muxn1_tree #(parameter SEL_WIDTH=1) (input [(2**SEL_WIDTH)-1:0] in,
                                            inout [SEL_WIDTH-1:0] sel,
                                            output out);

    wire [(2**(SEL_WIDTH-1))-1:0] layer_out;
    
    genvar i;
    generate
        if (SEL_WIDTH % 2 == 0) begin
            for (i = 0; i < 2**SEL_WIDTH; i = i + 4) begin : treemux4_structslices
                mux4$ g0(.outb(layer_out[i/4]), .in0(in[i]), .in1(in[i+1]), .in2(in[i+2]), .in3(in[i+3]), .s0(sel[0]), .s1(sel[1]));
            end
            if (SEL_WIDTH == 2) begin
                assign out = layer_out[0];
            end else begin
                muxn1_tree #(.SEL_WIDTH(SEL_WIDTH-2)) m0(.in(layer_out[(2**(SEL_WIDTH-2))-1:0]), .sel(sel[SEL_WIDTH-1:2]), .out(out));
            end
        end else begin
            for (i = 0; i < 2**SEL_WIDTH; i = i + 2) begin : treemux2_structslices
                mux2$ g1(.outb(layer_out[i/2]), .in0(in[i]), .in1(in[i+1]), .s0(sel[0]));
            end
            if (SEL_WIDTH == 1) begin
                assign out = layer_out[0];
            end else begin
                muxn1_tree #(.SEL_WIDTH(SEL_WIDTH-1)) m1(.in(layer_out[(2**(SEL_WIDTH-1))-1:0]), .sel(sel[SEL_WIDTH-1:1]), .out(out));
            end
        end
    endgenerate
                                            
endmodule




module muxnm_tristate #(parameter NUM_INPUTS=2, DATA_WIDTH=1) (input [NUM_INPUTS*DATA_WIDTH-1:0] in,
                                                               input [NUM_INPUTS-1:0] sel,
                                                               output [DATA_WIDTH-1:0] out);
    
    wire [NUM_INPUTS*DATA_WIDTH-1:0] datavector;
    wire [NUM_INPUTS-1:0] invsel;

    genvar i, j;
    generate
        for (j = 0; j < NUM_INPUTS; j = j + 1) begin : invsel_wires
            inv1$ g0(.out(invsel[j]), .in(sel[j]));
        end
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : tristatemux_dataslices
            for (j = 0; j < NUM_INPUTS; j = j + 1) begin : datavector_splits
                assign datavector[(i*NUM_INPUTS)+j] = in[(DATA_WIDTH*j)+i];
            end
            muxn1_tristate #(.NUM_INPUTS(NUM_INPUTS)) m0(.in(datavector[(i+1)*NUM_INPUTS-1:i*NUM_INPUTS]), .sel(invsel), .out(out[i]));
        end
    endgenerate

endmodule

module muxn1_tristate #(parameter NUM_INPUTS=2) (input [NUM_INPUTS-1:0] in, sel,
                                                 output out);

    wire bus;

    genvar i;
    generate
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin : tristatemux_structslices
            tristateL$ t0(.enbar(sel[i]), .in(in[i]), .out(bus));
        end
    endgenerate

    assign out = bus;

endmodule