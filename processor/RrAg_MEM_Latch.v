
module RrAg_MEM_latch (
        input ld, clr,
        input clk,

        input valid_RrAg_MEM_latch_in, stall_RrAg_MEM_latch_in,
        input [1:0] opsize_RrAg_MEM_latch_in,
        input [31:0] mem_addr1_RrAg_MEM_latch_in, mem_addr2_RrAg_MEM_latch_in, mem_addr1_end_RrAg_MEM_latch_in, mem_addr2_end_RrAg_MEM_latch_in,
        input [63:0] reg1_RrAg_MEM_latch_in, reg2_RrAg_MEM_latch_in, reg3_RrAg_MEM_latch_in, reg4_RrAg_MEM_latch_in,
        input [127:0] ptc_r1_RrAg_MEM_latch_in, ptc_r2_RrAg_MEM_latch_in, ptc_r3_RrAg_MEM_latch_in, ptc_r4_RrAg_MEM_latch_in,
        input [2:0] reg1_orig_RrAg_MEM_latch_in, reg2_orig_RrAg_MEM_latch_in, reg3_orig_RrAg_MEM_latch_in, reg4_orig_RrAg_MEM_latch_in,
        input [15:0] seg1_RrAg_MEM_latch_in, seg2_RrAg_MEM_latch_in, seg3_RrAg_MEM_latch_in, seg4_RrAg_MEM_latch_in,
        input [31:0] ptc_s1_RrAg_MEM_latch_in, ptc_s2_RrAg_MEM_latch_in, ptc_s3_RrAg_MEM_latch_in, ptc_s4_RrAg_MEM_latch_in,
        input [2:0] seg1_orig_RrAg_MEM_latch_in, seg2_orig_RrAg_MEM_latch_in, seg3_orig_RrAg_MEM_latch_in, seg4_orig_RrAg_MEM_latch_in,
        input [6:0] inst_ptcid_RrAg_MEM_latch_in,
        input [12:0] op1_out_RrAg_MEM_latch_in, op2_out_RrAg_MEM_latch_in, op3_out_RrAg_MEM_latch_in, op4_out_RrAg_MEM_latch_in,
        input [12:0] dest1_out_RrAg_MEM_latch_in, dest2_out_RrAg_MEM_latch_in, dest3_out_RrAg_MEM_latch_in, dest4_out_RrAg_MEM_latch_in,
        input res1_ld_out_RrAg_MEM_latch_in, res2_ld_out_RrAg_MEM_latch_in, res3_ld_out_RrAg_MEM_latch_in, res4_ld_out_RrAg_MEM_latch_in,
        input [31:0] rep_num_RrAg_MEM_latch_in,
        input [4:0] aluk_out_RrAg_MEM_latch_in,
        input [2:0] mux_adder_out_RrAg_MEM_latch_in,
        input mux_and_int_out_RrAg_MEM_latch_in, mux_shift_out_RrAg_MEM_latch_in,
        input [36:0] p_op_out_RrAg_MEM_latch_in,
        input [17:0] fmask_out_RrAg_MEM_latch_in,
        input [15:0]  CS_out_RrAg_MEM_latch_in,
        input [1:0] conditionals_out_RrAg_MEM_latch_in,
        input is_br_out_RrAg_MEM_latch_in, is_fp_out_RrAg_MEM_latch_in,
        input [47:0] imm_out_RrAg_MEM_latch_in,
        input [1:0] mem1_rw_out_RrAg_MEM_latch_in, mem2_rw_out_RrAg_MEM_latch_in,
        input [31:0] eip_out_RrAg_MEM_latch_in,
        input IE_out_RrAg_MEM_latch_in,
        input [3:0] IE_type_out_RrAg_MEM_latch_in,
        input [31:0] BR_pred_target_out_RrAg_MEM_latch_in,
        input BR_pred_T_NT_out_RrAg_MEM_latch_in,

        output valid_RrAg_MEM_latch_out, stall_RrAg_MEM_latch_out,
        output [1:0] opsize_RrAg_MEM_latch_out,
        output [31:0] mem_addr1_RrAg_MEM_latch_out, mem_addr2_RrAg_MEM_latch_out, mem_addr1_end_RrAg_MEM_latch_out, mem_addr2_end_RrAg_MEM_latch_out,
        output [63:0] reg1_RrAg_MEM_latch_out, reg2_RrAg_MEM_latch_out, reg3_RrAg_MEM_latch_out, reg4_RrAg_MEM_latch_out,
        output [127:0] ptc_r1_RrAg_MEM_latch_out, ptc_r2_RrAg_MEM_latch_out, ptc_r3_RrAg_MEM_latch_out, ptc_r4_RrAg_MEM_latch_out,
        output [2:0] reg1_orig_RrAg_MEM_latch_out, reg2_orig_RrAg_MEM_latch_out, reg3_orig_RrAg_MEM_latch_out, reg4_orig_RrAg_MEM_latch_out,
        output [15:0] seg1_RrAg_MEM_latch_out, seg2_RrAg_MEM_latch_out, seg3_RrAg_MEM_latch_out, seg4_RrAg_MEM_latch_out,
        output [31:0] ptc_s1_RrAg_MEM_latch_out, ptc_s2_RrAg_MEM_latch_out, ptc_s3_RrAg_MEM_latch_out, ptc_s4_RrAg_MEM_latch_out,
        output [2:0] seg1_orig_RrAg_MEM_latch_out, seg2_orig_RrAg_MEM_latch_out, seg3_orig_RrAg_MEM_latch_out, seg4_orig_RrAg_MEM_latch_out,
        output [6:0] inst_ptcid_RrAg_MEM_latch_out,
        output [12:0] op1_RrAg_MEM_latch_out, op2_RrAg_MEM_latch_out, op3_RrAg_MEM_latch_out, op4_RrAg_MEM_latch_out,
        output [12:0] dest1_RrAg_MEM_latch_out, dest2_RrAg_MEM_latch_out, dest3_RrAg_MEM_latch_out, dest4_RrAg_MEM_latch_out,
        output res1_ld_out_RrAg_MEM_latch_out, res2_ld_out_RrAg_MEM_latch_out, res3_ld_out_RrAg_MEM_latch_out, res4_ld_out_RrAg_MEM_latch_out,
        output [31:0] rep_num_RrAg_MEM_latch_out,
        output [4:0] aluk_RrAg_MEM_latch_out,
        output [2:0] mux_adder_RrAg_MEM_latch_out,
        output mux_and_int_RrAg_MEM_latch_out, mux_shift_RrAg_MEM_latch_out,
        output [36:0] p_op_RrAg_MEM_latch_out,
        output [17:0] fmask_RrAg_MEM_latch_out,
        output [15:0]  CS_out_RrAg_MEM_latch_out,
        output [1:0] conditionals_RrAg_MEM_latch_out,
        output is_br_RrAg_MEM_latch_out, is_fp_RrAg_MEM_latch_out,
        output [47:0] imm_RrAg_MEM_latch_out,
        output [1:0] mem1_rw_RrAg_MEM_latch_out, mem2_rw_RrAg_MEM_latch_out,
        output [31:0] eip_RrAg_MEM_latch_out,
        output IE_RrAg_MEM_latch_out,
        output [3:0] IE_type_RrAg_MEM_latch_out,
        output [31:0] BR_pred_target_RrAg_MEM_latch_out,
        output BR_pred_T_NT_RrAg_MEM_latch_out

        );
    
    integer file;
    initial begin
        file = $fopen("RrAg_MEM_latches.out", "w");
    end

    regn #(.WIDTH(1)) r1 (.din(valid_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r2 (.din(stall_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(stall_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r3 (.din(opsize_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(opsize_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r4 (.din(mem_addr1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r5 (.din(mem_addr2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r6 (.din(mem_addr1_end_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr1_end_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r7 (.din(mem_addr2_end_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem_addr2_end_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r8 (.din(reg1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r9 (.din(reg2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r10 (.din(reg3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_RrAg_MEM_latch_out));
    regn #(.WIDTH(64)) r11 (.din(reg4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r12 (.din(ptc_r1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r1_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r13 (.din(ptc_r2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r2_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r14 (.din(ptc_r3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r3_RrAg_MEM_latch_out));
    regn #(.WIDTH(128)) r15 (.din(ptc_r4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_r4_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r16 (.din(reg1_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg1_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r17 (.din(reg2_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg2_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r18 (.din(reg3_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg3_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r19 (.din(reg4_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(reg4_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r20 (.din(seg1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r21 (.din(seg2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r22 (.din(seg3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r23 (.din(seg4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r24 (.din(ptc_s1_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s1_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r25 (.din(ptc_s2_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s2_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r26 (.din(ptc_s3_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s3_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r27 (.din(ptc_s4_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(ptc_s4_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r28 (.din(seg1_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg1_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r29 (.din(seg2_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg2_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r30 (.din(seg3_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg3_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r31 (.din(seg4_orig_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(seg4_orig_RrAg_MEM_latch_out));
    regn #(.WIDTH(7)) r32 (.din(inst_ptcid_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(inst_ptcid_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r33 (.din(op1_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op1_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r34 (.din(op2_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op2_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r35 (.din(op3_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op3_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r36 (.din(op4_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(op4_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r37 (.din(dest1_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest1_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r38 (.din(dest2_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest2_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r39 (.din(dest3_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest3_RrAg_MEM_latch_out));
    regn #(.WIDTH(13)) r40 (.din(dest4_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(dest4_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r41 (.din(res1_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res1_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r42 (.din(res2_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res2_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r43 (.din(res3_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res3_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r44 (.din(res4_ld_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(res4_ld_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r45 (.din(rep_num_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(rep_num_RrAg_MEM_latch_out));
    regn #(.WIDTH(5)) r46 (.din(aluk_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(aluk_RrAg_MEM_latch_out));
    regn #(.WIDTH(3)) r47 (.din(mux_adder_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_adder_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r48 (.din(mux_and_int_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_and_int_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r49 (.din(mux_shift_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mux_shift_RrAg_MEM_latch_out));
    regn #(.WIDTH(37)) r50 (.din(p_op_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(p_op_RrAg_MEM_latch_out));
    regn #(.WIDTH(18)) r51 (.din(fmask_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(fmask_RrAg_MEM_latch_out));
    regn #(.WIDTH(16)) r52 (.din(CS_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(CS_out_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r63 (.din(conditionals_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(conditionals_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r53 (.din(is_br_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_br_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r54 (.din(is_fp_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(is_fp_RrAg_MEM_latch_out));
    regn #(.WIDTH(48)) r55 (.din(imm_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(imm_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r56 (.din(mem1_rw_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem1_rw_RrAg_MEM_latch_out));
    regn #(.WIDTH(2)) r57 (.din(mem2_rw_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(mem2_rw_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r58 (.din(eip_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(eip_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r59 (.din(IE_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_RrAg_MEM_latch_out));
    regn #(.WIDTH(4)) r60 (.din(IE_type_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_RrAg_MEM_latch_out));
    regn #(.WIDTH(32)) r61 (.din(BR_pred_target_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_RrAg_MEM_latch_out));
    regn #(.WIDTH(1)) r62 (.din(BR_pred_T_NT_out_RrAg_MEM_latch_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_RrAg_MEM_latch_out));

    always @(posedge clk) begin
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t stall: %b", stall_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t opsize: %b", opsize_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr1: 0x%h", mem_addr1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr2: 0x%h", mem_addr2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr1_end: 0x%h", mem_addr1_end_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem_addr2_end: 0x%h", mem_addr2_end_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg1: 0x%h", reg1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg2: 0x%h", reg2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg3: 0x%h", reg3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg4: 0x%h", reg4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r1: 0x%h", ptc_r1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r2: 0x%h", ptc_r2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r3: 0x%h", ptc_r3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_r4: 0x%h", ptc_r4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg1_orig: %b", reg1_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg2_orig: %b", reg2_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg3_orig: %b", reg3_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t reg4_orig: %b", reg4_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg1: 0x%h", seg1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg2: 0x%h", seg2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg3: 0x%h", seg3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg4: 0x%h", seg4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s1: 0x%h", ptc_s1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s2: 0x%h", ptc_s2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s3: 0x%h", ptc_s3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t ptc_s4: 0x%h", ptc_s4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg1_orig: %b", seg1_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg2_orig: %b", seg2_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg3_orig: %b", seg3_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t seg4_orig: %b", seg4_orig_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t inst_ptcid: 0x%h", inst_ptcid_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op1: 0x%h", op1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op2: 0x%h", op2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op3: 0x%h", op3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t op4: 0x%h", op4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest1: 0x%h", dest1_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest2: 0x%h", dest2_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest3: 0x%h", dest3_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t dest4: 0x%h", dest4_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res1_ld_out: %h", res1_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res2_ld_out: %h", res2_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res3_ld_out: %h", res3_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t res4_ld_out: %h", res4_ld_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t rep_num: 0x%h", rep_num_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t aluk: %b", aluk_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_adder: %b", mux_adder_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_and_int: %b", mux_and_int_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mux_shift: %b", mux_shift_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t p_op: 0x%h", p_op_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t fmask: 0x%h = %b", fmask_RrAg_MEM_latch_out, fmask_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t CS: 0x%h", CS_out_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t conditionals:x%b", conditionals_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t is_br: %h", is_br_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t is_fp: %h", is_fp_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t imm: 0x%h", imm_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem1_rw: %b", mem1_rw_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t mem2_rw: %b", mem2_rw_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t eip: 0x%h", eip_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t IE: %b", IE_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t IE_type: %b", IE_type_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_RrAg_MEM_latch_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: %h", BR_pred_T_NT_RrAg_MEM_latch_out);
        
		
		$display("\n=================================================\n");    
	end

endmodule