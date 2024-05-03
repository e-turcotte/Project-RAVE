module rrag (input valid_in,
             input [2:0] reg_addr1, reg_addr2, reg_addr3, reg_addr4, seg_addr1, seg_addr2, seg_addr3, seg_addr4,
             input [1:0] opsize_in,
             input addressingmode, //1 for 32b addressing mode, 0 for 16b
             input [12:0] op1_in, op2_in, op3_in, op4_in,
             input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in, //better op1-4_wb
             input [12:0] dest1_in, dest2_in, dest3_in, dest4_in,
             input [31:0] disp,
             input [1:0] reg3_shfamnt,
             input usereg2, usereg3,
             input rep,

             input clr, clk,
             input [19:0] lim_init5, lim_init4, lim_init3, lim_init2, lim_init1, lim_init0,

             input [4:0] aluk_in,
             input [2:0] mux_adder_in,
             input mux_and_int_in, mux_shift_in,
             input [36:0] p_op_in,
             input [17:0] fmask_in,
             input [1:0] conditionals_in,
             input is_br_in, is_fp_in,
             input [47:0] imm_in,
             input [1:0] mem1_rw_in, mem2_rw_in,
             input [31:0] eip_in,
             input IE_in,
             input [3:0] IE_type_in,
             input [31:0] BR_pred_target_in,
             input BR_pred_T_NT_in,

             input [63:0] wb_data1, wb_data2, wb_data3, wb_data4,
             input [15:0] wb_segdata1, wb_segdata2, wb_segdata3, wb_segdata4,
             input [2:0] wb_addr1, wb_addr2, wb_addr3, wb_addr4, wb_segaddr1, wb_segaddr2, wb_segaddr3, wb_segaddr4,
             input [1:0] wb_opsize,
             input [3:0] wb_regld, wb_segld,
             input [6:0] wb_inst_ptcid,
             input fwd_stall,

             output valid_out, stall,
             output [1:0] opsize_out,
             output [31:0] mem_addr1, mem_addr2, mem_addr1_end, mem_addr2_end,
             output [63:0] reg1, reg2, reg3, reg4,
             output [127:0] ptc_r1, ptc_r2, ptc_r3, ptc_r4,
             output [2:0] reg1_orig, reg2_orig, reg3_orig, reg4_orig,
             output [15:0] seg1, seg2, seg3, seg4,
             output [31:0] ptc_s1, ptc_s2, ptc_s3, ptc_s4,
             output [2:0] seg1_orig, seg2_orig, seg3_orig, seg4_orig,
             output [6:0] inst_ptcid,
             output [12:0] op1_out, op2_out, op3_out, op4_out,
             output [12:0] dest1_out, dest2_out, dest3_out, dest4_out,
             output res1_ld_out, res2_ld_out, res3_ld_out, res4_ld_out,
             output [31:0] rep_num,
             
             output [4:0] aluk_out,
             output [2:0] mux_adder_out,
             output mux_and_int_out, mux_shift_out,
             output [36:0] p_op_out,
             output [17:0] fmask_out,
             output [1:0] conditionals_out,
             output is_br_out, is_fp_out,
             output [47:0] imm_out,
             output [1:0] mem1_rw_out, mem2_rw_out,
             output [31:0] eip_out,
             output IE_out,
             output [3:0] IE_type_out,
             output [31:0] BR_pred_target_out,
             output BR_pred_T_NT_out);

    wire invstall;

    inv1$ g0(.out(invstall), .in(stall));

    ptc_generator ptcgen(.next(invstall), .clr(clr), .clk(clk), .ptcid(inst_ptcid));

    wire [13:0] collated_dest_vector;

    genvar i;
    generate
        for (i = 0; i < 13; i = i + 1) begin : sized_ld_dest_slices
            or4$ g1(.out(collated_dest_vector[i]), .in0(dest1_in[i]), .in1(dest2_in[i]), .in2(dest3_in[i]), .in3(dest4_in[i]));
        end
    endgenerate

    wire [19:0] lim_out1, lim_out2, lim_out3, lim_out4;
    wire [31:0] regformem1, regformem2, regformem3, regformem4;
    wire regformem1ptc, regformem2ptc, regformem3ptc, regformem4ptc;

    regfile rf(.din({wb_data4,wb_data3,wb_data2,wb_data1}), .ld_addr({wb_addr4,wb_addr3,wb_addr2,wb_addr1}), .rd_addr({reg_addr4,reg_addr3,reg_addr2,reg_addr1}), .ldsize(wb_opsize), .rdsize(opsize_in), .addressingmode(addressingmode), .ld_en(wb_regld), .dest(collated_dest_vector[7:4]), .data_ptcid(wb_inst_ptcid), .new_ptcid(inst_ptcid), .clr(clr), .clk(clk), .dout({reg4,reg3,reg2,reg1}), .addrout({regformem4,regformem3,regformem2,regformem1}), .ptcout({ptc_r4,ptc_r3,ptc_r2,ptc_r1}), .addrptc({regformem4ptc,regformem3ptc,regformem2ptc,regformem1ptc}));
    segfile sf(.base_in({wb_segdata4,wb_segdata3,wb_segdata2,wb_segdata1}), .lim_inits({lim_init5,lim_init4,lim_init3,lim_init2,lim_init1,lim_init0}), .ld_addr({wb_segaddr4,wb_segaddr3,wb_segaddr2,wb_segaddr1}), .rd_addr({seg_addr4,seg_addr3,seg_addr2,seg_addr1}), .ld_en(wb_segld), .dest(collated_dest_vector[3:0]), .data_ptcid(wb_inst_ptcid), .new_ptcid(inst_ptcid), .clr(clr), .clk(clk), .base_out({seg4,seg3,seg2,seg1}), .lim_out({lim_out4,lim_out3,lim_out2,lim_out1}), .ptc_out({ptc_s4,ptc_s3,ptc_s2,ptc_s1}));

    wire [31:0] shfseg1, shfseg2;

    assign shfseg1 = {seg1,16'h0000};
    assign shfseg2 = {seg2,16'h0000};

    wire [31:0] mul2, mul4, mul8;
    wire [31:0] shfreg3;

    lshfn_fixed #(.WIDTH(32), .SHF_AMNT(1)) s0(.in(regformem3), .shf_val(1'b0), .out(mul2));
    lshfn_fixed #(.WIDTH(32), .SHF_AMNT(2)) s1(.in(regformem3), .shf_val(2'b00), .out(mul4));
    lshfn_fixed #(.WIDTH(32), .SHF_AMNT(3)) s2(.in(regformem3), .shf_val(3'b000), .out(mul8));
    muxnm_tree #(.SEL_WIDTH(2), .DATA_WIDTH(32)) m0(.in({mul8,mul4,mul2,regformem3}), .sel(reg3_shfamnt), .out(shfreg3));

    wire [31:0] rmbaseval, modsibcalc, segoffs, segdisp;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m1(.in({regformem2,32'h00000000}), .sel(usereg2), .out(rmbaseval));
    kogeAdder #(.WIDTH(32)) add0(.SUM(modsibcalc), .COUT(), .A(rmbaseval), .B(shfreg3));
    kogeAdder #(.WIDTH(32)) add1(.SUM(segdisp), .COUT(), .A(disp), .B(shfseg1));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m2(.in({modsibcalc,regformem2}), .sel(usereg3), .out(segoffs));
    kogeAdder #(.WIDTH(32)) add2(.SUM(mem_addr1), .COUT(), .A(segoffs), .B(segdisp));
    kogeAdder #(.WIDTH(32)) add3(.SUM(mem_addr2), .COUT(), .A(regformem4), .B(shfseg2));

    assign reg1_orig = reg_addr1;
    assign reg2_orig = reg_addr2;
    assign reg3_orig = reg_addr3;
    assign reg4_orig = reg_addr4;
    assign seg1_orig = seg_addr1;
    assign seg2_orig = seg_addr2;
    assign seg3_orig = seg_addr3;
    assign seg4_orig = seg_addr4;

    assign op1_out = op1_in;
    assign op2_out = op2_in;
    assign op3_out = op3_in;
    assign op4_out = op4_in;
    assign dest1_out = dest1_in;
    assign dest2_out = dest2_in;
    assign dest3_out = dest3_in;
    assign dest4_out = dest4_in;

    assign re1_ld_out = res1_ld_in;
    assign re2_ld_out = res2_ld_in;
    assign re3_ld_out = res3_ld_in;
    assign re4_ld_out = res4_ld_in;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m3(.in({regformem4,32'h00000000}), .sel(rep), .out(rep_num));

    wire [3:0] decodedsize;

    decodern #(.INPUT_WIDTH(2)) d0(.in(opsize_in), .out(decodedsize));
    prot_exception_logic p0(.disp_imm(disp), .calc_size(segoffs), .address_size(decodedsize), .read_address_end_size(mem_addr1_end));
    prot_exception_logic p1(.disp_imm(32'h00000000), .calc_size(regformem4), .address_size(decodedsize), .read_address_end_size(mem_addr2_end));

    assign aluk_out = aluk_in;
    assign mux_add_out = mux_adder_in;
    assign mux_and_int_out = mux_and_int_in;
    assign mux_shift_out = mux_shift_in;
    assign p_op_out = p_op_in;
    assign fmask_out = fmask_in;
    assign conditionals_out = conditionals_in;
    assign is_br_out = is_br_in;
    assign is_fp_out = is_fp_in;
    assign imm_out = imm_in;
    assign mem1_rw_out = mem1_rw_in;
    assign mem2_rw_out = mem2_rw_in;
    assign eip_out = eip_in;
    assign IE_out = IE_in;
    assign IE_type_out = IE_type_in;
    assign BR_pred_target_out = BR_pred_target_in;
    assign BR_pred_T_NT_out = BR_pred_T_NT_in;

    wire mem1_use, mem2_use, rm_ptc, sib_ptc, actualsib_ptc, mem1_ptc, mem2_ptc, mem1_stall, mem2_stall;

    or2$ g2(.out(mem1_use), .in0(mem1_rw_in[1]), .in1(mem1_rw_in[0]));
    or2$ g3(.out(mem2_use), .in0(mem2_rw_in[1]), .in1(mem2_rw_in[0]));
    and2$ g4(.out(modrm_ptc), .in0(usereg2), .in1(regformem2ptc));
    and2$ g5(.out(sib_ptc), .in0(usereg3), .in1(regformem3ptc));
    or2$ g6(.out(modrmsib_ptc), .in0(modrm_ptc), .in1(sib_ptc));
    and2$ g7(.out(mem1_stall), .in0(mem1_use), .in1(modrmsib_ptc));
    and2$ g8(.out(mem2_stall), .in0(mem2_use), .in1(regformem4ptc));
    or3$ g10(.out(stall), .in0(fwd_stall), .in1(mem1_stall), .in2(mem2_stall));
endmodule