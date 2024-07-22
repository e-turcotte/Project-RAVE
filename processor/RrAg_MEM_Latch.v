
module RrAg_MEM_latch (
        input ld, clr,
        input clk,

        input         valid_in,
        input [1:0]   opsize_in,
        input [31:0]  mem_addr1_in, mem_addr2_in, mem_addr1_end_in, mem_addr2_end_in,
        input [63:0]  reg1_in, reg2_in, reg3_in, reg4_in,
        input [127:0] ptc_r1_in, ptc_r2_in, ptc_r3_in, ptc_r4_in,
        input [2:0]   reg1_orig_in, reg2_orig_in, reg3_orig_in, reg4_orig_in,
        input [15:0]  seg1_in, seg2_in, seg3_in, seg4_in,
        input [31:0]  ptc_s1_in, ptc_s2_in, ptc_s3_in, ptc_s4_in,
        input [19:0]  seg1_lim_in, seg2_lim_in, seg3_lim_in, seg4_lim_in,
        input [2:0]   seg1_orig_in, seg2_orig_in, seg3_orig_in, seg4_orig_in,
        input [6:0]   inst_ptcid_in,
        input [12:0]  op1_in, op2_in, op3_in, op4_in,
        input [12:0]  dest1_in, dest2_in, dest3_in, dest4_in,
        input         res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in,
        input [31:0]  rep_num_in,
        input         is_rep_in,
        input [4:0]   aluk_in,
        input [2:0]   mux_adder_in,
        input         mux_and_int_in, mux_shift_in,
        input [36:0]  p_op_in,
        input [17:0]  fmask_in,
        input [15:0]  CS_in,
        input [1:0]   conditionals_in,
        input         is_br_in, is_fp_in, is_imm_in,
        input [47:0]  imm_in,
        input [1:0]   mem1_rw_in, mem2_rw_in,
        input [3:0]   memsizeOVR_in,
        input [31:0]  eip_in,
        input [31:0]  latched_eip_in,
        input         IE_in,
        input [3:0]   IE_type_in,
        input         instr_is_IDTR_orig_in,
        input [31:0]  BR_pred_target_in,
        input         BR_pred_T_NT_in,
        input [5:0]   BP_alias_in, 

        output         valid_out,
        output [1:0]   opsize_out,
        output [31:0]  mem_addr1_out, mem_addr2_out, mem_addr1_end_out, mem_addr2_end_out,
        output [63:0]  reg1_out, reg2_out, reg3_out, reg4_out,
        output [127:0] ptc_r1_out, ptc_r2_out, ptc_r3_out, ptc_r4_out,
        output [2:0]   reg1_orig_out, reg2_orig_out, reg3_orig_out, reg4_orig_out,
        output [15:0]  seg1_out, seg2_out, seg3_out, seg4_out,
        output [31:0]  ptc_s1_out, ptc_s2_out, ptc_s3_out, ptc_s4_out,
        output [19:0]  seg1_lim_out, seg2_lim_out, seg3_lim_out, seg4_lim_out,
        output [2:0]   seg1_orig_out, seg2_orig_out, seg3_orig_out, seg4_orig_out,
        output [6:0]   inst_ptcid_out,
        output [12:0]  op1_out, op2_out, op3_out, op4_out,
        output [12:0]  dest1_out, dest2_out, dest3_out, dest4_out,
        output         res1_ld_out, res2_ld_out, res3_ld_out, res4_ld_out,
        output [31:0]  rep_num_out,
        output         is_rep_out,
        output [4:0]   aluk_out,
        output [2:0]   mux_adder_out,
        output         mux_and_int_out, mux_shift_out,
        output [36:0]  p_op_out,
        output [17:0]  fmask_out,
        output [15:0]  CS_out,
        output [1:0]   conditionals_out,
        output         is_br_out, is_fp_out,  is_imm_out,
        output [47:0]  imm_out,
        output [1:0]   mem1_rw_out, mem2_rw_out,
        output [3:0]   memsizeOVR_out,
        output [31:0]  eip_out,
        output [31:0]  latched_eip_out,       
        output         IE_out,
        output [3:0]   IE_type_out,
        output         instr_is_IDTR_orig_out,
        output [31:0]  BR_pred_target_out,
        output         BR_pred_T_NT_out,
        output [5:0]   BP_alias_out

        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("RrAg_MEM_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1  (.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(2))   r3  (.din(opsize_in), .ld(ld), .clr(clr), .clk(clk), .dout(opsize_out));
    regn #(.WIDTH(32))  r4  (.din(mem_addr1_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_out));
    regn #(.WIDTH(32))  r5  (.din(mem_addr2_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_out));
    regn #(.WIDTH(32))  r6  (.din(mem_addr1_end_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_end_out));
    regn #(.WIDTH(32))  r7  (.din(mem_addr2_end_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_end_out));
    regn #(.WIDTH(64))  r8  (.din(reg1_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_out));
    regn #(.WIDTH(64))  r9  (.din(reg2_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_out));
    regn #(.WIDTH(64))  r10 (.din(reg3_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_out));
    regn #(.WIDTH(64))  r11 (.din(reg4_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_out));
    regn #(.WIDTH(128)) r12 (.din(ptc_r1_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r1_out));
    regn #(.WIDTH(128)) r13 (.din(ptc_r2_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r2_out));
    regn #(.WIDTH(128)) r14 (.din(ptc_r3_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r3_out));
    regn #(.WIDTH(128)) r15 (.din(ptc_r4_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r4_out));
    regn #(.WIDTH(3))   r16 (.din(reg1_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_orig_out));
    regn #(.WIDTH(3))   r17 (.din(reg2_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_orig_out));
    regn #(.WIDTH(3))   r18 (.din(reg3_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_orig_out));
    regn #(.WIDTH(3))   r19 (.din(reg4_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_orig_out));
    regn #(.WIDTH(16))  r20 (.din(seg1_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_out));
    regn #(.WIDTH(16))  r21 (.din(seg2_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_out));
    regn #(.WIDTH(16))  r22 (.din(seg3_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_out));
    regn #(.WIDTH(16))  r23 (.din(seg4_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_out));
    regn #(.WIDTH(32))  r24 (.din(ptc_s1_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s1_out));
    regn #(.WIDTH(32))  r25 (.din(ptc_s2_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s2_out));
    regn #(.WIDTH(32))  r26 (.din(ptc_s3_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s3_out));
    regn #(.WIDTH(32))  r27 (.din(ptc_s4_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s4_out));
    regn #(.WIDTH(20))   r28lim1 (.din(seg1_lim_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_lim_out));
    regn #(.WIDTH(20))   r28lim2 (.din(seg2_lim_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_lim_out));
    regn #(.WIDTH(20))   r28lim3 (.din(seg3_lim_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_lim_out));
    regn #(.WIDTH(20))   r28lim4 (.din(seg4_lim_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_lim_out));
    regn #(.WIDTH(3))   r28 (.din(seg1_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_orig_out));
    regn #(.WIDTH(3))   r29 (.din(seg2_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_orig_out));
    regn #(.WIDTH(3))   r30 (.din(seg3_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_orig_out));
    regn #(.WIDTH(3))   r31 (.din(seg4_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_orig_out));
    regn #(.WIDTH(7))   r32 (.din(inst_ptcid_in), .ld(ld), .clr(clr), .clk(clk), .dout(inst_ptcid_out));
    regn #(.WIDTH(13))  r33 (.din(op1_in), .ld(ld), .clr(clr), .clk(clk), .dout(op1_out));
    regn #(.WIDTH(13))  r34 (.din(op2_in), .ld(ld), .clr(clr), .clk(clk), .dout(op2_out));
    regn #(.WIDTH(13))  r35 (.din(op3_in), .ld(ld), .clr(clr), .clk(clk), .dout(op3_out));
    regn #(.WIDTH(13))  r36 (.din(op4_in), .ld(ld), .clr(clr), .clk(clk), .dout(op4_out));
    regn #(.WIDTH(13))  r37 (.din(dest1_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest1_out));
    regn #(.WIDTH(13))  r38 (.din(dest2_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest2_out));
    regn #(.WIDTH(13))  r39 (.din(dest3_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest3_out));
    regn #(.WIDTH(13))  r40 (.din(dest4_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest4_out));
    regn #(.WIDTH(1))   r41 (.din(res1_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_ld_out));
    regn #(.WIDTH(1))   r42 (.din(res2_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_ld_out));
    regn #(.WIDTH(1))   r43 (.din(res3_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_ld_out));
    regn #(.WIDTH(1))   r44 (.din(res4_ld_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_ld_out));
    regn #(.WIDTH(32))  r45 (.din(rep_num_in), .ld(ld), .clr(clr), .clk(clk), .dout(rep_num_out));
    regn #(.WIDTH(1))   r46 (.din(is_rep_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_rep_out));
    regn #(.WIDTH(5))   r47 (.din(aluk_in), .ld(ld), .clr(clr), .clk(clk), .dout(aluk_out));
    regn #(.WIDTH(3))   r48 (.din(mux_adder_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_adder_out));
    regn #(.WIDTH(1))   r49 (.din(mux_and_int_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_and_int_out));
    regn #(.WIDTH(1))   r50 (.din(mux_shift_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_shift_out));
    regn #(.WIDTH(37))  r51 (.din(p_op_in), .ld(ld), .clr(clr), .clk(clk), .dout(p_op_out));
    regn #(.WIDTH(18))  r52 (.din(fmask_in), .ld(ld), .clr(clr), .clk(clk), .dout(fmask_out));
    regn #(.WIDTH(16))  r53 (.din(CS_in), .ld(ld), .clr(clr), .clk(clk), .dout(CS_out));
    regn #(.WIDTH(2))   r54 (.din(conditionals_in), .ld(ld), .clr(clr), .clk(clk), .dout(conditionals_out));
    regn #(.WIDTH(1))   r55 (.din(is_br_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_br_out));
    regn #(.WIDTH(1))   r56 (.din(is_fp_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_fp_out));
    regn #(.WIDTH(1))   r57 (.din(is_imm_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_imm_out));
    regn #(.WIDTH(48))  r58 (.din(imm_in), .ld(ld), .clr(clr), .clk(clk), .dout(imm_out));
    regn #(.WIDTH(2))   r59 (.din(mem1_rw_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem1_rw_out));
    regn #(.WIDTH(2))   r60 (.din(mem2_rw_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem2_rw_out));
    regn #(.WIDTH(4))   r61 (.din(memsizeOVR_in), .ld(ld), .clr(clr), .clk(clk), .dout(memsizeOVR_out));
    regn #(.WIDTH(32))  r62 (.din(eip_in), .ld(ld), .clr(clr), .clk(clk), .dout(eip_out));
    regn #(.WIDTH(32))  r63 (.din(latched_eip_in), .ld(ld), .clr(clr), .clk(clk), .dout(latched_eip_out));
    regn #(.WIDTH(1))   r64 (.din(IE_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_out));
    regn #(.WIDTH(4))   r65 (.din(IE_type_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_out));
    regn #(.WIDTH(1))   r66 (.din(instr_is_IDTR_orig_in), .ld(ld), .clr(clr), .clk(clk), .dout(instr_is_IDTR_orig_out));
    regn #(.WIDTH(32))  r67 (.din(BR_pred_target_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_out));
    regn #(.WIDTH(1))   r68 (.din(BR_pred_T_NT_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_out));
    regn #(.WIDTH(6))   r69 (.din(BP_alias_in), .ld(ld), .clr(clr), .clk(clk), .dout(BP_alias_out));
 
    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t opsize: %b", opsize_out);
        $fdisplay(file, "\t\t mem_addr1: 0x%h", mem_addr1_out);
        $fdisplay(file, "\t\t mem_addr2: 0x%h", mem_addr2_out);
        $fdisplay(file, "\t\t mem_addr1_end: 0x%h", mem_addr1_end_out);
        $fdisplay(file, "\t\t mem_addr2_end: 0x%h", mem_addr2_end_out);
        $fdisplay(file, "\t\t reg1: 0x%h", reg1_out);
        $fdisplay(file, "\t\t reg2: 0x%h", reg2_out);
        $fdisplay(file, "\t\t reg3: 0x%h", reg3_out);
        $fdisplay(file, "\t\t reg4: 0x%h", reg4_out);
        $fdisplay(file, "\t\t ptc_r1: 0x%h", ptc_r1_out);
        $fdisplay(file, "\t\t ptc_r2: 0x%h", ptc_r2_out);
        $fdisplay(file, "\t\t ptc_r3: 0x%h", ptc_r3_out);
        $fdisplay(file, "\t\t ptc_r4: 0x%h", ptc_r4_out);
        $fdisplay(file, "\t\t reg1_orig: %b", reg1_orig_out);
        $fdisplay(file, "\t\t reg2_orig: %b", reg2_orig_out);
        $fdisplay(file, "\t\t reg3_orig: %b", reg3_orig_out);
        $fdisplay(file, "\t\t reg4_orig: %b", reg4_orig_out);
        $fdisplay(file, "\t\t seg1: 0x%h", seg1_out);
        $fdisplay(file, "\t\t seg2: 0x%h", seg2_out);
        $fdisplay(file, "\t\t seg3: 0x%h", seg3_out);
        $fdisplay(file, "\t\t seg4: 0x%h", seg4_out);
        $fdisplay(file, "\t\t ptc_s1: 0x%h", ptc_s1_out);
        $fdisplay(file, "\t\t ptc_s2: 0x%h", ptc_s2_out);
        $fdisplay(file, "\t\t ptc_s3: 0x%h", ptc_s3_out);
        $fdisplay(file, "\t\t ptc_s4: 0x%h", ptc_s4_out);
        $fdisplay(file, "\t\t seg1_lim: %b", seg1_lim_out);
        $fdisplay(file, "\t\t seg2_lim: %b", seg2_lim_out);
        $fdisplay(file, "\t\t seg3_lim: %b", seg3_lim_out);
        $fdisplay(file, "\t\t seg4_lim: %b", seg4_lim_out);
        $fdisplay(file, "\t\t seg1_orig: %b", seg1_orig_out);
        $fdisplay(file, "\t\t seg2_orig: %b", seg2_orig_out);
        $fdisplay(file, "\t\t seg3_orig: %b", seg3_orig_out);
        $fdisplay(file, "\t\t seg4_orig: %b", seg4_orig_out);
        $fdisplay(file, "\t\t inst_ptcid: 0x%h", inst_ptcid_out);
        $fdisplay(file, "\t\t op1: 0x%h", op1_out);
        $fdisplay(file, "\t\t op2: 0x%h", op2_out);
        $fdisplay(file, "\t\t op3: 0x%h", op3_out);
        $fdisplay(file, "\t\t op4: 0x%h", op4_out);
        $fdisplay(file, "\t\t dest1: 0x%h", dest1_out);
        $fdisplay(file, "\t\t dest2: 0x%h", dest2_out);
        $fdisplay(file, "\t\t dest3: 0x%h", dest3_out);
        $fdisplay(file, "\t\t dest4: 0x%h", dest4_out);
        $fdisplay(file, "\t\t res1_ld_out: %h", res1_ld_out);
        $fdisplay(file, "\t\t res2_ld_out: %h", res2_ld_out);
        $fdisplay(file, "\t\t res3_ld_out: %h", res3_ld_out);
        $fdisplay(file, "\t\t res4_ld_out: %h", res4_ld_out);
        $fdisplay(file, "\t\t rep_num: 0x%h", rep_num_out);
        $fdisplay(file, "\t\t aluk: %b", aluk_out);
        $fdisplay(file, "\t\t mux_adder: %b", mux_adder_out);
        $fdisplay(file, "\t\t mux_and_int: %b", mux_and_int_out);
        $fdisplay(file, "\t\t mux_shift: %b", mux_shift_out);
        $fdisplay(file, "\t\t p_op: 0x%h", p_op_out);
        $fdisplay(file, "\t\t fmask: 0x%h = %b", fmask_out, fmask_out);
        $fdisplay(file, "\t\t CS: 0x%h", CS_out);
        $fdisplay(file, "\t\t conditionals:x%b", conditionals_out);
        $fdisplay(file, "\t\t is_br: %h", is_br_out);
        $fdisplay(file, "\t\t is_fp: %h", is_fp_out);
        $fdisplay(file, "\t\t imm: 0x%h", imm_out);
        $fdisplay(file, "\t\t mem1_rw: %b", mem1_rw_out);
        $fdisplay(file, "\t\t mem2_rw: %b", mem2_rw_out);
        $fdisplay(file, "\t\t memsizeOVR: %b", memsizeOVR_out);
        $fdisplay(file, "\t\t EIP: 0x%h", eip_out);
        $fdisplay(file, "\t\t latched_EIP: 0x%h", latched_eip_out);
        $fdisplay(file, "\t\t IE: %b", IE_out);
        $fdisplay(file, "\t\t IE_type: %b", IE_type_out);
        $fdisplay(file, "\t\t instr_is_IDTR_orig: %b", instr_is_IDTR_orig_out); 
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: %h", BR_pred_T_NT_out);
        $fdisplay(file, "\t\t BP_alias: %h", BP_alias_out);
		
		$fdisplay(file, "\n=================================================\n");    
	end

endmodule
