module decode (
    input valid_in,
    input [31:0] pred_target_in,
    input pred_T_NT_in,
    input [127:0] packet,

    output valid_out,
    output seg_switch,
    output [2:0] seg_switch_to,
    output [1:0] op_size,
    output rep,
    output [2:0] BaseR,
    output [2:0] IndexR,
    output [1:0] scale,
    output [31:0] disp,
    output [31:0] imm,
    output rm_is_reg,
    output [1:0] dest,
    output [4:0] aluk,
    output [1:0] val_sel,
    output [9:0] P_OP,
    output load_EIP,
    output load_SegReg,
    output [16:0] FMASK,
    output pred_T_NT_out,
    output [31:0] pred_target_out
    output reg_or_SegReg,
    output [1:0] BR_CC,
    output is_BR,
    output is_fp,
    output [31:0] instruction_length

);

    //do this later after all signals are finalized it'll just end up being the following steps
    // 1. buffer the input packet based on how many times used,
    // 2. perform all the necessary decode computations
    // 3. assign the length
    // 4. clean up the signals and override them if necessary
    // 5. assign the output signals
    
endmodule