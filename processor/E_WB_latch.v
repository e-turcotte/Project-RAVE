
module E_WB_latch (
            input ld, clr,
            input clk,

            input valid_in,
            input [31:0] EIP_in,
            input [31:0] latched_EIP_in, 
            input IE_in,
            input [3:0] IE_type_in,
            input [31:0] BR_pred_target_in,
            input BR_pred_T_NT_in,
            input [6:0] PTCID_in,
            input is_rep_in,
            input [17:0] eflags_in,
            input [15:0] CS_in, 
            input [36:0] P_OP_in,
            input res1_wb_in, res2_wb_in, res3_wb_in, res4_wb_in,
            input [63:0] res1_in, res2_in, res3_in, res4_in, //done
            input [127:0] res1_ptcinfo_in, res2_ptcinfo_in, res3_ptcinfo_in, res4_ptcinfo_in,
            input res1_is_reg_in, res2_is_reg_in, res3_is_reg_in, res4_is_reg_in, //done
            input res1_is_seg_in, res2_is_seg_in, res3_is_seg_in, res4_is_seg_in, //done
            input res1_is_mem_in, res2_is_mem_in, res3_is_mem_in, res4_is_mem_in, //done
            input [31:0] res1_dest_in, res2_dest_in, res3_dest_in, res4_dest_in, //
            input [1:0] ressize_in, 
            input BR_valid_in,
            input BR_taken_in,
            input BR_correct_in, 
            input [31:0] BR_FIP_in, BR_FIP_p1_in,

            output valid_out,
            output [31:0] EIP_out,
            output [31:0] latched_EIP_out, 
            output IE_out,
            output [3:0] IE_type_out,
            output [31:0] BR_pred_target_out,
            output BR_pred_T_NT_out,
            output [6:0] PTCID_out,
            output is_rep_out,
            output [17:0] eflags_out,
            output [15:0] CS_out, 
            output [36:0] P_OP_out,
            output res1_wb_out, res2_wb_out, res3_wb_out, res4_wb_out,
            output [63:0] res1_out, res2_out, res3_out, res4_out,
            output [127:0] res1_ptcinfo_out, res2_ptcinfo_out, res3_ptcinfo_out, res4_ptcinfo_out,
            output res1_is_reg_out, res2_is_reg_out, res3_is_reg_out, res4_is_reg_out, 
            output res1_is_seg_out, res2_is_seg_out, res3_is_seg_out, res4_is_seg_out,
            output res1_is_mem_out, res2_is_mem_out, res3_is_mem_out, res4_is_mem_out,
            output [31:0] res1_dest_out, res2_dest_out, res3_dest_out, res4_dest_out,
            output [1:0] ressize_out,
            output BR_valid_out, //
            output BR_taken_out, //
            output BR_correct_out,  //
            output [31:0] BR_FIP_out, BR_FIP_p1_out
        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("E_WB_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1(.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(32))  r2(.din(EIP_in), .ld(ld), .clr(clr), .clk(clk), .dout(EIP_out));
    regn #(.WIDTH(32))  r3(.din(latched_EIP_in), .ld(ld), .clr(clr), .clk(clk), .dout(latched_EIP_out));
    regn #(.WIDTH(1))   r4(.din(IE_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_out));
    regn #(.WIDTH(4))   r5(.din(IE_type_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_out));
    regn #(.WIDTH(32))  r6(.din(BR_pred_target_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_out));
    regn #(.WIDTH(1))   r7(.din(BR_pred_T_NT_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_out));
    regn #(.WIDTH(7))   r8(.din(PTCID_in), .ld(ld), .clr(clr), .clk(clk), .dout(PTCID_out));
    regn #(.WIDTH(1))   r9(.din(is_rep_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_rep_out));
    regn #(.WIDTH(18))  r10(.din(eflags_in), .ld(ld), .clr(clr), .clk(clk), .dout(eflags_out));
    regn #(.WIDTH(16))  r11(.din(CS_in), .ld(ld), .clr(clr), .clk(clk), .dout(CS_out));
    regn #(.WIDTH(37))  r12(.din(P_OP_in), .ld(ld), .clr(clr), .clk(clk), .dout(P_OP_out));
    regn #(.WIDTH(1))   r13(.din(res1_wb_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_wb_out));
    regn #(.WIDTH(1))   r14(.din(res2_wb), .ld(ld), .clr(clr), .clk(clk), .dout(res2_wb_out));
    regn #(.WIDTH(1))   r15(.din(res3_wb), .ld(ld), .clr(clr), .clk(clk), .dout(res3_wb_out));
    regn #(.WIDTH(1))   r16(.din(res4_wb), .ld(ld), .clr(clr), .clk(clk), .dout(res4_wb_out));
    regn #(.WIDTH(64))  r17(.din(res1_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_out));
    regn #(.WIDTH(64))  r18(.din(res2_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_out));
    regn #(.WIDTH(64))  r19(.din(res3_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_out));
    regn #(.WIDTH(64))  r20(.din(res4_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_out));
    regn #(.WIDTH(128)) r21(.din(res1_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_ptcinfo_out));
    regn #(.WIDTH(128)) r22(.din(res2_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_ptcinfo_out));
    regn #(.WIDTH(128)) r23(.din(res3_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_ptcinfo_out));
    regn #(.WIDTH(128)) r24(.din(res4_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_ptcinfo_out));
    regn #(.WIDTH(1))   r25(.din(res1_is_reg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_is_reg_out));
    regn #(.WIDTH(1))   r26(.din(res2_is_reg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_is_reg_out));
    regn #(.WIDTH(1))   r27(.din(res3_is_reg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_is_reg_out));
    regn #(.WIDTH(1))   r28(.din(res4_is_reg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_is_reg_out));
    regn #(.WIDTH(1))   r29(.din(res1_is_seg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_is_seg_out));
    regn #(.WIDTH(1))   r30(.din(res2_is_seg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_is_seg_out));
    regn #(.WIDTH(1))   r31(.din(res3_is_seg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_is_seg_out));
    regn #(.WIDTH(1))   r32(.din(res4_is_seg_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_is_seg_out));
    regn #(.WIDTH(1))   r33(.din(res1_is_mem_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_is_mem_out));
    regn #(.WIDTH(1))   r34(.din(res2_is_mem_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_is_mem_out));
    regn #(.WIDTH(1))   r35(.din(res3_is_mem_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_is_mem_out));
    regn #(.WIDTH(1))   r36(.din(res4_is_mem_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_is_mem_out));
    regn #(.WIDTH(32))  r37(.din(res1_dest_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_dest_out));
    regn #(.WIDTH(32))  r38(.din(res2_dest_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_dest_out));
    regn #(.WIDTH(32))  r39(.din(res3_dest_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_dest_out));
    regn #(.WIDTH(32))  r40(.din(res4_dest_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_dest_out));
    regn #(.WIDTH(2))   r41(.din(ressize_in), .ld(ld), .clr(clr), .clk(clk), .dout(ressize_out));
    regn #(.WIDTH(1))   r42(.din(BR_valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_valid_out));
    regn #(.WIDTH(1))   r43(.din(BR_taken_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_taken_out));
    regn #(.WIDTH(1))   r44(.din(BR_correct_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_correct_out));
    regn #(.WIDTH(32))  r45(.din(BR_FIP_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_FIP_out));
    regn #(.WIDTH(32))  r46(.din(BR_FIP_p1_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_FIP_p1_out));


    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t EIP: 0x%h", EIP_out);
        $fdisplay(file, "\t\t latched_EIP: 0x%h", latched_EIP_out);
        $fdisplay(file, "\t\t IE: %b", IE_out);
        $fdisplay(file, "\t\t IE_type: %b", IE_type_out);
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: %b", BR_pred_T_NT_out);
        $fdisplay(file, "\t\t PTCID: %b", PTCID_out);
        $fdisplay(file, "\t\t is_rep: %b", is_rep_out);
        $fdisplay(file, "\t\t eflags: %b", eflags_out);
        $fdisplay(file, "\t\t CS: %b", CS_out);
        $fdisplay(file, "\t\t P_OP: %b", P_OP_out);
        $fdisplay(file, "\t\t res1_wb: %b", res1_wb_out);
        $fdisplay(file, "\t\t res2_wb: %b", res2_wb_out);
        $fdisplay(file, "\t\t res3_wb: %b", res3_wb_out);
        $fdisplay(file, "\t\t res4_wb: %b", res4_wb_out);
        $fdisplay(file, "\t\t res1: 0x%h", res1_out);
        $fdisplay(file, "\t\t res2: 0x%h", res2_out);
        $fdisplay(file, "\t\t res3: 0x%h", res3_out);
        $fdisplay(file, "\t\t res4: 0x%h", res4_out);
        $fdisplay(file, "\t\t res1_ptcinfo: %b", res1_ptcinfo_out);
        $fdisplay(file, "\t\t res2_ptcinfo: %b", res2_ptcinfo_out);
        $fdisplay(file, "\t\t res3_ptcinfo: %b", res3_ptcinfo_out);
        $fdisplay(file, "\t\t res4_ptcinfo: %b", res4_ptcinfo_out);
        $fdisplay(file, "\t\t res1_is_reg: %b", res1_is_reg_out);
        $fdisplay(file, "\t\t res2_is_reg: %b", res2_is_reg_out);
        $fdisplay(file, "\t\t res3_is_reg: %b", res3_is_reg_out);
        $fdisplay(file, "\t\t res4_is_reg: %b", res4_is_reg_out);
        $fdisplay(file, "\t\t res1_is_seg: %b", res1_is_seg_out);
        $fdisplay(file, "\t\t res2_is_seg: %b", res2_is_seg_out);
        $fdisplay(file, "\t\t res3_is_seg: %b", res3_is_seg_out);
        $fdisplay(file, "\t\t res4_is_seg: %b", res4_is_seg_out);
        $fdisplay(file, "\t\t res1_is_mem: %b", res1_is_mem_out);
        $fdisplay(file, "\t\t res2_is_mem: %b", res2_is_mem_out);
        $fdisplay(file, "\t\t res3_is_mem: %b", res3_is_mem_out);
        $fdisplay(file, "\t\t res4_is_mem: %b", res4_is_mem_out);
        $fdisplay(file, "\t\t res1_dest: 0x%h", res1_dest_out);
        $fdisplay(file, "\t\t res2_dest: 0x%h", res2_dest_out);
        $fdisplay(file, "\t\t res3_dest: 0x%h", res3_dest_out);
        $fdisplay(file, "\t\t res4_dest: 0x%h", res4_dest_out);
        $fdisplay(file, "\t\t ressize: %b", ressize_out);
        $fdisplay(file, "\t\t BR_valid: %b", BR_valid_out);
        $fdisplay(file, "\t\t BR_taken: %b", BR_taken_out);
        $fdisplay(file, "\t\t BR_correct: %b", BR_correct_out);
        $fdisplay(file, "\t\t BR_FIP: 0x%h", BR_FIP_out);
        $fdisplay(file, "\t\t BR_FIP_p1: 0x%h", BR_FIP_p1_out);

        $fdisplay(file, "\n=================================================\n");

	end

endmodule