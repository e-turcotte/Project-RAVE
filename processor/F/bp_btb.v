module bp_btb(
    input clk,
    input reset,
    input [31:0] eip,
    input prev_BR_result,
    input [5:0] prev_BR_alias,
    input prev_is_BR,
    input LD,

    input [31:0] EIP_WB, //EIP of BR instr, passed from F
    input [31:0] FIP_E_WB, 
    input [31:0] FIP_O_WB, 
    input [31:0] target_WB, //update, from WB

    output prediction,
    output [5:0] BP_alias

    output [31:0] FIP_E_target,
    output [31:0] FIP_O_target,
    output [31:0] EIP_target,
    output miss,
    output hit
);

    branch_target_buff btb(
        .clk(clk),
        .EIP_fetch(eip), //this should be eip + length from decode
        .EIP_WB(EIP_WB),
        .FIP_E_WB(FIP_E_WB),
        .FIP_O_WB(FIP_O_WB),
        .target_WB(target_WB),
        .LD(LD),
        .reset(reset),

        .FIP_E_target(FIP_E_target),
        .FIP_O_target(FIP_O_target),
        .EIP_target(EIP_target),
        .miss(miss),
        .hit(hit)
        );

    bp_gshare bp(
        .clk(clk),
        .reset(reset),
        .eip(eip),
        .prev_BR_result(prev_BR_result),
        .prev_BR_alias(prev_BR_alias),
        .prev_is_BR(prev_is_BR),
        .LD(LD),
        .prediction(prediction),
        .BP_alias(BP_alias)
    );


endmodule