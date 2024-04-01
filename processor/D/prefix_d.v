module prefix_d (
    input clk,
    input reset,
    input [127:0] instruction,
    output [1:0] num_prefixes,
    output is_rep,
    output is_seg_override,
    output is_opsiz_override;
    );

    wire [7:0] prefix1, prefix2, prefix3;

    buffer8$(instruction[127:120], prefix1) //high byte
    buffer8$(instruction[119:112], prefix2) //middle byte
    buffer8$(instruction[111:104], prefix3) //low byte

    //compare each prefix to the known prefixes in lookup table
    
    //do a  128b mux for comparison results
    

endmodule