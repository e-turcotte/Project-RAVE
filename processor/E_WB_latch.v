
module E_WB_latch (
            input ld, clr,
            input clk,

            input valid_in,
            input latched_EIP_in,
            input [63:0] res1_in, res2_in, res3_in, res4_in, mem_data_in,
            input [127:0] res1_ptcinfo_in, res2_ptcinfo_in, res3_ptcinfo_in, res4_ptcinfo_in,
            input [1:0] ressize_in, memsize_in,
            input [11:0] reg_addr_in, seg_addr_in,
            input [31:0] mem_addr_in,
            input [3:0] reg_ld_in, seg_ld_in,
            input mem_ld_in,
            input [6:0] inst_ptcid_in,
            input [31:0] newFIP_e_in, newFIP_o_in, newEIP_in,
            input BR_valid_in, BR_taken_in, BR_correct_in,
            input BP_alias_in,
            input is_resteer_in,
            input [15:0] CS_in,
            input stall_in,
            input final_IE_val_in,
            input [3:0] final_IE_type_in,
            
            output valid_out,
            output latched_EIP_out,
            output [63:0] res1_out, res2_out, res3_out, res4_out, mem_data_out,
            output [127:0] res1_ptcinfo_out, res2_ptcinfo_out, res3_ptcinfo_out, res4_ptcinfo_out,
            output [1:0] ressize_out, memsize_out,
            output [11:0] reg_addr_out, seg_addr_out,
            output [31:0] mem_addr_out,
            output [3:0] reg_ld_out, seg_ld_out,
            output mem_ld_out,
            output [6:0] inst_ptcid_out,
            output [31:0] newFIP_e_out, newFIP_o_out, newEIP_out, 
            output BR_valid_out, BR_taken_out, BR_correct_out,
            output BP_alias_out,
            output is_resteer_out,
            output [15:0] CS_out,
            output stall_out,
            output final_IE_val_out,
            output [3:0] final_IE_type_out
        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("E_WB_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1(.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(64))  r2(.din(latched_EIP_in), .ld(ld), .clr(clr), .clk(clk), .dout(latched_EIP_out));
    regn #(.WIDTH(64))  r3(.din(res1_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_out));
    regn #(.WIDTH(64))  r4(.din(res2_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_out));
    regn #(.WIDTH(64))  r5(.din(res3_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_out));
    regn #(.WIDTH(64))  r6(.din(res4_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_out));

    regn #(.WIDTH(128)) r7(.din(res1_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_ptcinfo_out));
    regn #(.WIDTH(128)) r8(.din(res2_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_ptcinfo_out));
    regn #(.WIDTH(128)) r9(.din(res3_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_ptcinfo_out));
    regn #(.WIDTH(128)) r10(.din(res4_ptcinfo_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_ptcinfo_out));

    regn #(.WIDTH(2))   r11(.din(ressize_in), .ld(ld), .clr(clr), .clk(clk), .dout(ressize_out));
    regn #(.WIDTH(2))   r12(.din(memsize_in), .ld(ld), .clr(clr), .clk(clk), .dout(memsize_out));

    regn #(.WIDTH(12))  r13(.din(reg_addr_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg_addr_out));
    regn #(.WIDTH(12))  r14(.din(seg_addr_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg_addr_out));
    regn #(.WIDTH(32))  r15(.din(mem_addr_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr_out));

    regn #(.WIDTH(4))   r16(.din(reg_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg_ld_out));
    regn #(.WIDTH(4))   r17(.din(seg_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg_ld_out));
    regn #(.WIDTH(1))   r18(.din(mem_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_ld_out));

    regn #(.WIDTH(7))   r19(.din(inst_ptcid_in), .ld(ld), .clr(clr), .clk(clk), .dout(inst_ptcid_out));
    regn #(.WIDTH(32))  r20(.din(newFIP_e_in), .ld(ld), .clr(clr), .clk(clk), .dout(newFIP_e_out));
    regn #(.WIDTH(32))  r21(.din(newFIP_o_in), .ld(ld), .clr(clr), .clk(clk), .dout(newFIP_o_out));
    regn #(.WIDTH(32))  r22(.din(newEIP_in), .ld(ld), .clr(clr), .clk(clk), .dout(newEIP_out));

    regn #(.WIDTH(1))   r23(.din(BR_valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_valid_out));
    regn #(.WIDTH(1))   r24(.din(BR_taken_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_taken_out));
    regn #(.WIDTH(1))   r25(.din(BR_correct_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_correct_out));
    regn #(.WIDTH(1))   r26(.din(BP_alias_in), .ld(ld), .clr(clr), .clk(clk), .dout(BP_alias_out));

    regn #(.WIDTH(1))   r27(.din(is_resteer_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_resteer_out));
    regn #(.WIDTH(16))  r28(.din(CS_in), .ld(ld), .clr(clr), .clk(clk), .dout(CS_out));
    regn #(.WIDTH(1))   r29(.din(stall_in), .ld(ld), .clr(clr), .clk(clk), .dout(stall_out));
    regn #(.WIDTH(1))   r30(.din(final_IE_val_in), .ld(ld), .clr(clr), .clk(clk), .dout(final_IE_val_out));
    regn #(.WIDTH(4))   r31(.din(final_IE_type_in), .ld(ld), .clr(clr), .clk(clk), .dout(final_IE_type_out));


    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t latched_EIP: 0x%h", latched_EIP_out);

        $fdisplay(file, "\t\t res1: 0x%h", res1_out);
        $fdisplay(file, "\t\t res2: 0x%h", res2_out);
        $fdisplay(file, "\t\t res3: 0x%h", res3_out);
        $fdisplay(file, "\t\t res4: 0x%h", res4_out);

        $fdisplay(file, "\t\t res1_ptcinfo: 0x%h", res1_ptcinfo_out);
        $fdisplay(file, "\t\t res2_ptcinfo: 0x%h", res2_ptcinfo_out);
        $fdisplay(file, "\t\t res3_ptcinfo: 0x%h", res3_ptcinfo_out);
        $fdisplay(file, "\t\t res4_ptcinfo: 0x%h", res4_ptcinfo_out);

        $fdisplay(file, "\t\t ressize: %b", ressize_out);
        $fdisplay(file, "\t\t memsize: %b", memsize_out);

        $fdisplay(file, "\t\t reg_addr: %d", reg_addr_out);
        $fdisplay(file, "\t\t seg_addr: %d", seg_addr_out);
        $fdisplay(file, "\t\t mem_addr: %d", mem_addr_out);

        $fdisplay(file, "\t\t reg_ld: %b", reg_ld_out);
        $fdisplay(file, "\t\t seg_ld: %b", seg_ld_out);
        $fdisplay(file, "\t\t mem_ld: %b", mem_ld_out);
        $display(file, "\t\t inst_ptcid: %d", inst_ptcid_out);

        $fdisplay(file, "\t\t newFIP_e: 0x%h", newFIP_e_out);
        $fdisplay(file, "\t\t newFIP_o: 0x%h", newFIP_o_out);
        $fdisplay(file, "\t\t newEIP: 0x%h", newEIP_out);

        $fdisplay(file, "\t\t BR_valid: %b", BR_valid_out);
        $fdisplay(file, "\t\t BR_taken: %b", BR_taken_out);
        $fdisplay(file, "\t\t BR_correct: %b", BR_correct_out);
        $fdisplay(file, "\t\t BP_alias: %b", BP_alias_out);

        $fdisplay(file, "\t\t is_resteer: %b", is_resteer_out);
        $fdisplay(file, "\t\t CS: 0x%h", CS_out);
        $fdisplay(file, "\t\t stall: %b", stall_out);
        $fdisplay(file, "\t\t final_IE_val: %b", final_IE_val_out);
        $fdisplay(file, "\t\t final_IE_type: %d", final_IE_type_out);
            
		$fdisplay("\n=================================================\n");    
	end

endmodule