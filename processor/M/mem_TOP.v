module mem (input valid_in,
            input [1:0] opsize_in,
            input [31:0] mem_addr1, mem_addr2, mem_addr1_end, mem_addr2_end,
            input [63:0] reg1, reg2, reg3, reg4,
            input [127:0] ptc_r1, ptc_r2, ptc_r3, ptc_r4,
            input [2:0] reg1_orig, reg2_orig, reg3_orig, reg4_orig,
            input [15:0] seg1, seg2, seg3, seg4,
            input [31:0] ptc_s1, ptc_s2, ptc_s3, ptc_s4,
            output [2:0] seg1_orig, seg2_orig, seg3_orig, seg4_orig,
            input [6:0] inst_ptcid,
            input [12:0] op1_sel, op2_sel, op3_sel, op4_sel,
            input [12:0] dest1_sel, dest2_sel, dest3_sel, dest4_sel,
            input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in,
            input [31:0] rep_num,

            input [159:0] VP_in,                  
            input [159:0] PF_in,
            input [7:0] entry_v_in,
            input [7:0] entry_P_in,
            input [7:0] entry_RW_in,
            input [7:0] entry_PCD_in,
            
            input [4:0] aluk_in,
            input [2:0] mux_adder_in,
            input mux_and_int_in, mux_shift_in,
            input [36:0] p_op_in,
            input [17:0] fmask_in,
            input [15:0] CS_in,
            input [1:0] conditionals_in,
            input is_br_in, is_fp_in,
            input [47:0] imm,
            input [1:0] mem1_rw, mem2_rw,
            input [31:0] eip_in,
            input IE_in,
            input [3:0] IE_type_in,
            input [31:0] BR_pred_target_in,
            input BR_pred_T_NT_in,

            input clr,
            input clk,
           
            output valid_out,
            output [31:0] eip_out,
            output IE_out,
            output [3:0] IE_type_out,
            output [31:0] BR_pred_target_out,
            output BR_pred_T_NT_out,
            
            output [1:0] opsize_out,
            output [63:0] op1_val, op2_val, op3_val, op4_val,
            output [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo,
            output [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr,
            output dest1_is_reg, dest2_is_reg, dest3_is_reg, dest4_is_reg,
            output dest1_is_seg, dest2_is_seg, dest3_is_seg, dest4_is_seg,
            output dest1_is_mem, dest2_is_mem, dest3_is_mem, dest4_is_mem,
            output res1_ld_out, res2_ld_out, res3_ld_out, res4_ld_out,
            
            output [4:0] aluk_out,
            output [2:0] mux_adder_out,
            output mux_and_int_out, mux_shift_out,
            output [36:0] p_op_out,
            output [16:0] fmask_out,
            output [1:0] conditionals_out,
            output is_br_out, is_fp_out
            output [15:0] CS_out
            );

    //wire TLB_prot, TLB_miss, TLB_hit;
    //TLB tlb(.clk(clk), .address(/*TODO*/), .RW_in(/*TODO*/), is_mem_request(/*TODO*/), .VP(VP_in), .PF(PF_in),  //TODO: finish signals
    //        .entry_v(entry_v_in), .entry_P(entry_P_in), .entry_RW(entry_RW_in), .entry_PCD(entry_PCD_in),
    //        .PF_out(/*TODO*/), .miss(TLB_miss), .hit(TLB_hit), .protection_exception(TLB_prot));                   


    //exception and interrupt checking:
    //wire RA_gt_SS, RA_lt_SS, EQ, prot_seg;  //related to checking prot exception for seg_size

    //mag_comp32 mag(.A(read_address_end_size), .B({12'b0, seg_size}), .AGB(RA_gt_SS), .BGA(RA_lt_SS), .EQ(EQ));
    //or2$ g0(.out(prot_seg), .in0(EQ), .in1(RA_gt_SS));                                    //if read_address_end_size >= seg_size
    
    //or2$ g1(.out(IE_type_out[0]), .in0(prot_seg), .in1(TLB_prot));                        //update protection exception
    //assign IE_type_out[1] = TLB_miss;                                                   //update page fault exception
    //assign IE_type_out[3:2] = IE_type_in[3:2];                                          //pass along
    //or4$ g2(.out(IE_out), .in1(IE_in), .in2(prot_seg), .in3(TLB_miss), .in4(TLB_prot));   //update IE_out

    opswap os(.reg1_data(reg1), .reg2_data(reg2), .reg3_data(reg3), .reg4_data(reg4),
              .reg1_addr(reg1_orig), .reg2_addr(reg2_orig), .reg3_addr(reg3_orig), .reg4_addr(reg4_orig),
              .reg1_ptc(ptc_r1), .reg2_ptc(ptc_r2), .reg3_ptc(ptc_r3), .reg4_ptc(ptc_r4),
              .seg1_data(seg1), .seg2_data(seg2), .seg3_data(seg3), .seg4_data(seg4),
              .seg1_addr(seg1_orig), .seg2_addr(seg2_orig), .seg3_addr(seg3_orig), .seg4_addr(seg4_orig),
              .seg1_ptc(ptc_s1), .seg2_ptc(ptc_s2), .seg3_ptc(ptc_s3), .seg4_ptc(ptc_s4),
              .mem1_data(), .mem2_data(),
              .mem1_addr(), .mem2_addr(),
              .mem1_ptc(), .mem2_ptc(),
              .eip_data(eip_in), .imm(imm),
              .op1_mux(op1_sel), .op2_mux(op2_sel), .op3_mux(op3_sel), .op4_mux(op4_sel),
              .dest1_mux(dest1_sel), .dest2_mux(dest2_sel), .dest3_mux(dest3_sel), .dest4_mux(dest4_sel),
              .op1(op1_val), .op2(op2_val), .op3(op3_val), .op4(op4_val),
              .op1_ptcinfo(op1_ptcinfo), .op2_ptcinfo(op2_ptcinfo), .op3_ptcinfo(op3_ptcinfo), .op4_ptcinfo(op4_ptcinfo),
              .dest1_addr(dest1_addr), .dest2_addr(dest2_addr), .dest3_addr(dest3_addr), .dest4_addr(dest4_addr),
              .dest1_type({dest1_is_mem,dest1_is_seg,dest1_is_reg}), .dest2_type({dest2_is_mem,dest2_is_seg,dest2_is_reg}), .dest3_type({dest3_is_mem,dest3_is_seg,dest3_is_reg}), .dest4_type({dest4_is_mem,dest4_is_seg,dest4_is_reg}));
    
    assign re1_ld_out = res1_ld_in;
    assign re2_ld_out = res2_ld_in;
    assign re3_ld_out = res3_ld_in;
    assign re4_ld_out = res4_ld_in;
    
    assign valid_out = valid_in;
    assign eip_out = eip_in;
    assign BR_pred_target_out = BR_pred_target_in;
    assign BR_pred_T_NT_out = BR_pred_T_NT_in;
    assign aluk_out = aluk_in;
    assign mux_adder_out = mux_adder_in;
    assign mux_and_int_out = mux_and_int_in;
    assign mux_shift_out = mux_shift_in;
    assign p_op_out = p_op_in;
    assign fmask_out = fmask_in;
    assign conditionals_out = conditionals_in;
    assign is_br_out = is_br_in;
    assign is_fp_out = is_fp_in;
    assign CS_out = CS_in;

endmodule