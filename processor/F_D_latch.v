
module F_D_latch (
        input ld, clr,
        input clk,

        input valid_in,
        input [127:0] packet_in,
        input [7:0] BP_alias_in,
        input IE_in,
        input [3:0] IE_type_in,
        input [31:0] BR_pred_target_in,
        input BR_pred_T_NT_in,
        input instr_is_IDTR_orig_in,
        input IDTR_is_POP_EFLAGS_in,
        input P_OP_1_2_override_in,
        input P_OP_21_22_override_in,
        input P_OP_22_23_override_in,
        input invalidate_op1_wb_in,

        output valid_out,
        output [127:0] packet_out,
        output [7:0] BP_alias_out,
        output IE_out,
        output [3:0] IE_type_out,
        output [31:0] BR_pred_target_out,
        output BR_pred_T_NT_out,
        output instr_is_IDTR_orig_out,
        input IDTR_is_POP_EFLAGS_out,
        output P_OP_1_2_override,
        output P_OP_21_22_override,
        output P_OP_22_23_override,
        output invalidate_op1_wb
        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("F_D_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1(.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(128)) r2(.din(packet_in), .ld(ld), .clr(clr), .clk(clk), .dout(packet_out));
    regn #(.WIDTH(8))   r3(.din(BP_alias_in), .ld(ld), .clr(clr), .clk(clk), .dout(BP_alias_out));
    regn #(.WIDTH(1))   r4(.din(IE_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_out));
    regn #(.WIDTH(4))   r5(.din(IE_type_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_out));
    regn #(.WIDTH(32))  r6(.din(BR_pred_target_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_out));
    regn #(.WIDTH(1))   r7(.din(BR_pred_T_NT_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_out));
    regn #(.WIDTH(1))   r8(.din(instr_is_IDTR_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(instr_is_IDTR_orig_out));
    regn #(.WIDTH(1))   r9(.din(IDTR_is_POP_EFLAGS_in), .ld(ld), .clr(clr), .clk(clk), .dout(IDTR_is_POP_EFLAGS_out));
    regn #(.WIDTH(1))   r10(.din(P_OP_1_2_override_in), .ld(ld), .clr(clr), .clk(clk), .dout(P_OP_1_2_override));
    regn #(.WIDTH(1))   r11(.din(P_OP_21_22_override_in), .ld(ld), .clr(clr), .clk(clk), .dout(P_OP_21_22_override));
    regn #(.WIDTH(1))   r12(.din(P_OP_22_23_override_in), .ld(ld), .clr(clr), .clk(clk), .dout(P_OP_22_23_override));
    regn #(.WIDTH(1))   r13(.din(invalidate_op1_wb_in), .ld(ld), .clr(clr), .clk(clk), .dout(invalidate_op1_wb));


    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=================== F to D Latch Values ===================\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t packet: 0x%h", packet_out);
        $fdisplay(file, "\t\t BP_alias: %b", BP_alias_out);
        $fdisplay(file, "\t\t IE: %b", IE_out);
        $fdisplay(file, "\t\t IE_type: %b", IE_type_out);
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: %b", BR_pred_T_NT_out);
        $fdisplay(file, "\t\t instr_is_IDTR_orig: %b", instr_is_IDTR_orig_out);
        $fdisplay(file, "\t\t IDTR_is_POP_EFLAGS: %b", IDTR_is_POP_EFLAGS_out);         
		$fdisplay(file, "\n=================================================\n");    
	end

endmodule