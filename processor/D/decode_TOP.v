module decode_TOP(
    input wire clk,
    input wire valid_in,
    input wire [31:0] EIP_in,
    input wire IE_in,                           //interrupt or exception signal
    input wire [3:0] IE_type_in,
    input wire [31:0] BR_pred_target_in,       //branch prediction target
    input wire BR_pred_T_NT_in,                //branch prediction taken or not taken
    input wire set, rst,

    input wire [127:0] packet,                  //16 Bytes

    //TODO: add more inputs

    output wire [31:0] EIP_out,
    output wire IE_out,
    output wire [3:0] IE_type_out
    output wire [31:0] BR_pred_target_out,       
    output wire BR_pred_T_NT_out,      
    //TODO: add more outputs
);
    
    assign EIP_out = EIP_in;            //EIP passed through
    assign IE_out = IE_in;              //just passed through since no exception checking is DECODE
    assign IE_type_out = IE_type_in;


    //prefix decoding:
    wire is_rep, is_seg_override, is_opsize_override;
    wire [5:0] seg_override;
    wire [1:0] num_prefixes;

	prefix_d(.packet(packet), .is_rep(is_rep), .seg_override(seg_override), 
            .is_seg_override(is_seg_override), .is_opsize_override(is_opsize_override), .num_prefixes(num_prefixes));

    //rest of intruction decoding:




endmodule