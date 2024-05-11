module bypassmech #(parameter NUM_PROSPECTS=4, NUM_OPERANDS=4) (input [NUM_PROSPECTS*64-1:0] prospective_data,
                                                                input [NUM_PROSPECTS*128-1:0] prospective_ptc,
                                                                input [NUM_OPERANDS*64-1:0] operand_data,
                                                                input [NUM_OPERANDS*128-1:0] operand_ptc,
                                                                output [NUM_OPERANDS*64-1:0] new_data,
                                                                output [NUM_OPERANDS-1:0] modify);

    wire [NUM_OPERANDS*8-1:0] expandedmodify_vector;
    
    genvar i, j;
    generate
        for (i = 0; i < NUM_OPERANDS*8; i = i + 1) begin : operand_slices

            wire [(NUM_PROSPECTS*8+1)*8-1:0] data_vector;

            assign data_vector = {operand_data[(i+1)*8-1:i*8],prospective_data};

            wire [NUM_PROSPECTS*8:0] replace_vector;

            for (j = 0; j < NUM_PROSPECTS*8; j = j + 1) begin : testing_slices

                wire valid_ptc, eq_ptc;
                
                orn #(.NUM_INPUTS(16)) or0(.in(prospective_ptc[(j+1)*16-1:j*16]), .out(valid_ptc));
                equaln #(.WIDTH(16)) eq0(.a(prospective_ptc[(j+1)*16-1:j*16]), .b(operand_ptc[(i+1)*16-1:i*16]), .eq(eq_ptc));
                and2$ g0(.out(replace_vector[j]), .in0(valid_ptc), .in1(eq_ptc));

            end

            orn #(.NUM_INPUTS(NUM_PROSPECTS*8)) or1(.in(replace_vector[NUM_PROSPECTS*8-1:0]), .out(expandedmodify_vector[i]));
            inv1$ g1(.out(replace_vector[NUM_PROSPECTS*8]), .in(expandedmodify_vector[i]));

            muxnm_tristate #(.NUM_INPUTS(NUM_PROSPECTS*8+1), .DATA_WIDTH(8)) m0(.in(data_vector), .sel(replace_vector), .out(new_data[(i+1)*8-1:i*8]));

        end

        for (i = 0; i < NUM_OPERANDS; i = i + 1) begin : condensemodify_slices
            
            orn #(.NUM_INPUTS(8)) or2(.in(expandedmodify_vector[(i+1)*8-1:i*8]), .out(modify[i]));

        end
    endgenerate

endmodule