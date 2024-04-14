module branch_target_buff(
    input wire clk,
    input wire reset,
    input wire [31:0] EIP,
    input wire [31:0] target,
    input wire LD,
    input wire flush,
    output wire [31:0] target_out,
    output wire valid_out
    );

    wire [26] tag;
    wire index;

    assign tag = EIP[31:6];
    assign index = EIP[5:2];

    //BTB entries are TAG, FIP_E[], FIP_O[], ETP_str[]

endmodule