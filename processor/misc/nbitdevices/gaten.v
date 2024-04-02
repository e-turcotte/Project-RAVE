module andn #(parameter NUM_INPUTS=2) (input [NUM_INPUTS-1:0] in,
                                       output out);

    localparam NUM_NAND_OUTPUTS = (NUM_INPUTS%4 == 0)? NUM_INPUTS/4 : ((NUM_INPUTS-1)/3)+1;
    localparam NUM_NOR_OUTPUTS = (NUM_NAND_OUTPUTS%4 == 0)? NUM_NAND_OUTPUTS/4 : ((NUM_NAND_OUTPUTS-1)/3)+1;
    
    wire [NUM_NAND_OUTPUTS-1:0] nandlayer_outs;

    treelayer #(.NUM_INPUTS(NUM_INPUTS), .NUM_OUTPUTS(NUM_NAND_OUTPUTS), .AND_OR(1)) m0(.layer_in(in), .layer_out(nandlayer_outs));

    generate
        if(NUM_NAND_OUTPUTS == 1) begin
            inv1$ g0(.out(out), .in(nandlayer_outs[0]));
        end else begin
            wire [NUM_NOR_OUTPUTS-1:0] norlayer_outs;
            
            treelayer #(.NUM_INPUTS(NUM_NAND_OUTPUTS), .NUM_OUTPUTS(NUM_NOR_OUTPUTS), .AND_OR(0)) m1(.layer_in(nandlayer_outs), .layer_out(norlayer_outs));

            if(NUM_NOR_OUTPUTS == 1) begin
                assign out = norlayer_outs[0];
            end else begin
                andn #(NUM_NOR_OUTPUTS) m2(.in(norlayer_outs), .out(out));
            end
        end
    endgenerate

endmodule

module orn #(parameter NUM_INPUTS=2) (input [NUM_INPUTS-1:0] in,
                                      output out);

    localparam NUM_NOR_OUTPUTS = (NUM_INPUTS%4 == 0)? NUM_INPUTS/4 : ((NUM_INPUTS-1)/3)+1;
    localparam NUM_NAND_OUTPUTS = (NUM_NOR_OUTPUTS%4 == 0)? NUM_NOR_OUTPUTS/4 : ((NUM_NOR_OUTPUTS-1)/3)+1;
    
    wire [NUM_NOR_OUTPUTS-1:0] norlayer_outs;

    treelayer #(.NUM_INPUTS(NUM_INPUTS), .NUM_OUTPUTS(NUM_NOR_OUTPUTS), .AND_OR(0)) m0(.layer_in(in), .layer_out(norlayer_outs));

    generate
        if(NUM_NOR_OUTPUTS == 1) begin
            inv1$ g0(.out(out), .in(norlayer_outs[0]));
        end else begin
            wire [NUM_NAND_OUTPUTS-1:0] nandlayer_outs;
            
            treelayer #(.NUM_INPUTS(NUM_NOR_OUTPUTS), .NUM_OUTPUTS(NUM_NAND_OUTPUTS), .AND_OR(1)) m1(.layer_in(norlayer_outs), .layer_out(nandlayer_outs));

            if(NUM_NAND_OUTPUTS == 1) begin
                assign out = nandlayer_outs[0];
            end else begin
                orn #(NUM_NAND_OUTPUTS) m2(.in(nandlayer_outs), .out(out));
            end
        end
    endgenerate

endmodule





module treelayer #(parameter NUM_INPUTS=2, NUM_OUTPUTS=2, AND_OR=1) (input [NUM_INPUTS-1:0] layer_in,
                                                                     output [NUM_OUTPUTS-1:0] layer_out);

    genvar i;
    generate
        if (NUM_INPUTS % 4 == 0) begin
            treelayer_4gate #(.NUM_INPUTS(NUM_INPUTS), .NUM_OUTPUTS(NUM_OUTPUTS), .AND_OR(AND_OR)) m0(.layer_in(layer_in), .layer_out(layer_out));
        end else begin
            treelayer_23gate #(.NUM_INPUTS(NUM_INPUTS), .NUM_OUTPUTS(NUM_OUTPUTS), .AND_OR(AND_OR)) m0(.layer_in(layer_in), .layer_out(layer_out));
        end
    endgenerate
endmodule

module treelayer_4gate #(parameter NUM_INPUTS=2, NUM_OUTPUTS=2, AND_OR=1) (input [NUM_INPUTS-1:0] layer_in,
                                                                           output [NUM_OUTPUTS-1:0] layer_out);
                                                                           
    genvar i;
    generate
        for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin : tree_layer_gate
            if (AND_OR) begin
                nand4$ g0(.out(layer_out[i]), .in0(layer_in[i*4]), .in1(layer_in[(i*4)+1]), .in2(layer_in[(i*4)+2]), .in3(layer_in[(i*4)+3]));
            end else begin
                nor4$ g1(.out(layer_out[i]), .in0(layer_in[i*4]), .in1(layer_in[(i*4)+1]), .in2(layer_in[(i*4)+2]), .in3(layer_in[(i*4)+3]));
            end
        end 
    endgenerate
endmodule

module treelayer_23gate #(parameter NUM_INPUTS=2, NUM_OUTPUTS=2, AND_OR=1) (input [NUM_INPUTS-1:0] layer_in,
                                                                           output [NUM_OUTPUTS-1:0] layer_out);
                                                                           
    generate
        if (NUM_INPUTS % 2 == 1 || NUM_INPUTS > 4) begin
            if (AND_OR) begin
                nand3$ g2(.out(layer_out[0]), .in0(layer_in[0]), .in1(layer_in[1]), .in2(layer_in[2]));
            end else begin
                nor3$ g3(.out(layer_out[0]), .in0(layer_in[0]), .in1(layer_in[1]), .in2(layer_in[2]));
            end
            if (NUM_OUTPUTS > 1) begin
                treelayer_23gate #(.NUM_INPUTS(NUM_INPUTS-3), .NUM_OUTPUTS(NUM_OUTPUTS-1), .AND_OR(AND_OR)) m0(.layer_in(layer_in[NUM_INPUTS-1:3]), .layer_out(layer_out[NUM_OUTPUTS-1:1]));
            end
        end else begin
            if (AND_OR) begin
                nand2$ g4(.out(layer_out[0]), .in0(layer_in[0]), .in1(layer_in[1]));
            end else begin
                nor2$ g5(.out(layer_out[0]), .in0(layer_in[0]), .in1(layer_in[1]));
            end
            if (NUM_OUTPUTS > 1) begin
                treelayer_23gate #(.NUM_INPUTS(NUM_INPUTS-2), .NUM_OUTPUTS(NUM_OUTPUTS-1), .AND_OR(AND_OR)) m0(.layer_in(layer_in[NUM_INPUTS-1:2]), .layer_out(layer_out[NUM_OUTPUTS-1:1]));
            end
        end
    endgenerate
endmodule