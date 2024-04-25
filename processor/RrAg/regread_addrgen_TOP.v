module RrAg(
    input wire clk,
    input wire valid_in,
    input wire [31:0] EIP_in,
    input wire IE_in,                           //interrupt or exception signal
    input wire [3:0] IE_type_in,
    input wire [31:0] BR_pred_target_in,       //branch prediction target
    input wire BR_pred_T_NT_in,                //branch prediction taken or not taken
    input wire set, rst,

    //TODO: add more inputs

    output wire [31:0] EIP_out,
    output wire IE_out,
    output wire [3:0] IE_type_out
    output wire [31:0] BR_pred_target_out,       
    output wire BR_pred_T_NT_out,                

    output wire [31:0] read_address_end_size,
    output wire [19:0] seg_size,               //read from segfile, to cmp in MEM
    //TODO: add more outputs
    );

    assign EIP_out = EIP_in;                    //EIP passed through

    //TODO: calculate read_address_end_size (ie disp_imm + calc_size + 2**address_size)
    //      note: address_size is encoded as 1hot for 1, 2, 4, 8 bytes
    prot_exception_logic(.disp_imm(), .calc_size(), .address_size(), .read_address_end_size(read_address_end_size)); 
    assign IE_out = IE_in;                      //just passed through
    assign IE_type_out = IE_type_in;            

endmodule