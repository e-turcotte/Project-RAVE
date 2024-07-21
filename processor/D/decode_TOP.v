module decode_TOP(
    ////////////////////////////
    //     global signals     //
    ///////////////////////////
    input wire clk,
    input wire reset,

    ////////////////////////////
    // signals from fetch_2 //
    ///////////////////////////
    input wire valid_in,
    input wire [127:0] packet_in, //16 bytes
    input wire IE_in,
    input wire [3:0] IE_type_in,
    // input wire [5:0] BP_alias_in,
    // input wire [31:0] BR_pred_target_in,
    // input wire BR_pred_T_NT_in,

    ////////////////////////////
    //     signals from BP   //
    ///////////////////////////
    input wire [31:0] BP_EIP,
    input wire is_BR_T_NT,
    input wire [5:0] BP_alias_in,
    input wire [31:0] BP_BR_pred_target_in,

    ////////////////////////////
    //    writeback signals   //
    ///////////////////////////
    input wire [31:0] WB_EIP,
    input wire is_resteer,

    ////////////////////////////
    //    init signals      //
    ///////////////////////////
    input wire [31:0] init_EIP,
    input wire is_init,

    ////////////////////////////
    //     stall signal      //
    ///////////////////////////
    input queue_full_stall,

    ////////////////////////////
    //    outputs to RRAG    //
    ///////////////////////////
    output valid_out,
    output [2:0] reg_addr1_out, reg_addr2_out, reg_addr3_out, reg_addr4_out, seg_addr1_out, seg_addr2_out, seg_addr3_out, seg_addr4_out,
    output [1:0] opsize_out,
    output addressingmode_out, //1 for 32b addressing mode, 0 for 16b
    output [12:0] op1_out, op2_out, op3_out, op4_out,
    output res1_ld_out, res2_ld_out, res3_ld_out, res4_ld_out, //better op1-4_wb
    output [12:0] dest1_out, dest2_out, dest3_out, dest4_out,
    output [31:0] disp_out,
    output [1:0] reg3_shfamnt_out,
    output usereg2_out, usereg3_out,
    output rep_out,
    output [5:0] BP_alias_out,

    output [4:0] aluk_out,
    output [2:0] mux_adder_out,
    output mux_and_int_out, mux_shift_out,
    output [36:0] p_op_out,
    output [17:0] fmask_out,
    output [1:0] conditionals_out,
    output is_br_out, is_fp_out,
    output [47:0] imm_out,
    output [1:0] mem1_rw_out, mem2_rw_out,
    output [31:0] latched_eip_out,
    output [31:0] eip_out,
    output IE_out,
    output [3:0] IE_type_out,
    output [31:0] BR_pred_target_out,
    output BR_pred_T_NT_out,
    output isImm_out,
    output [3:0] memSizeOVR,

    ////////////////////////////
    //    outputs to fetch_2  //
    ///////////////////////////
    output stall_out,
    output wire [7:0] D_length

);
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                     buffer input bytes                                         */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [7:0] byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8, byte9, byte10, byte11, byte12, byte13, byte14, byte15;
    assign byte0 = packet_in[127:120];
    assign byte1 = packet_in[119:112];
    assign byte2 = packet_in[111:104];
    assign byte3 = packet_in[103:96];
    assign byte4 = packet_in[95:88];
    assign byte5 = packet_in[87:80];
    assign byte6 = packet_in[79:72];
    assign byte7 = packet_in[71:64];
    assign byte8 = packet_in[63:56];
    assign byte9 = packet_in[55:48];
    assign byte10 = packet_in[47:40];
    assign byte11 = packet_in[39:32];
    assign byte12 = packet_in[31:24];
    assign byte13 = packet_in[23:16];
    assign byte14 = packet_in[15:8];
    assign byte15 = packet_in[7:0];

    //0.3 ns
    wire [7:0] buffered_byte0, buffered_byte1, buffered_byte2, buffered_byte3, buffered_byte4, buffered_byte5, buffered_byte6, buffered_byte7, buffered_byte8, buffered_byte9, buffered_byte10, buffered_byte11, buffered_byte12, buffered_byte13, buffered_byte14, buffered_byte15;
    bufferH64_8b$ b0(.out(buffered_byte0), .in(byte0));
    bufferH64_8b$ b1(.out(buffered_byte1), .in(byte1));
    bufferH64_8b$ b2(.out(buffered_byte2), .in(byte2));
    bufferH64_8b$ b3(.out(buffered_byte3), .in(byte3));
    bufferH64_8b$ b4(.out(buffered_byte4), .in(byte4));
    bufferH64_8b$ b5(.out(buffered_byte5), .in(byte5));
    bufferH64_8b$ b6(.out(buffered_byte6), .in(byte6));
    bufferH64_8b$ b7(.out(buffered_byte7), .in(byte7));
    bufferH64_8b$ b8(.out(buffered_byte8), .in(byte8));
    bufferH64_8b$ b9(.out(buffered_byte9), .in(byte9));
    bufferH64_8b$ b10(.out(buffered_byte10), .in(byte10));
    bufferH64_8b$ b11(.out(buffered_byte11), .in(byte11));
    bufferH64_8b$ b12(.out(buffered_byte12), .in(byte12));
    bufferH64_8b$ b13(.out(buffered_byte13), .in(byte13));
    bufferH64_8b$ b14(.out(buffered_byte14), .in(byte14));
    bufferH64_8b$ b15(.out(buffered_byte15), .in(byte15));
    

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                        PREFIX DECODE:                                          */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [7:0] prefix1, prefix2, prefix3;
    assign prefix1 = buffered_byte0;
    assign prefix2 = buffered_byte1;
    assign prefix3 = buffered_byte2;
    wire is_rep;
    wire [5:0] seg_override; //onehot
    wire is_seg_override;
    wire is_opsize_override;
    wire [3:0] num_prefixes_onehot; //onehot encoding of num_prefixes
    wire [1:0] num_prefixes_encoded;

    //1.8 ns 
    prefix_d prefix(.prefix1(prefix1), .prefix2(prefix2), .prefix3(prefix3), .is_rep(is_rep), 
                        .seg_override(seg_override), .is_seg_override(is_seg_override), 
                        .is_opsize_override(is_opsize_override), .num_prefixes_onehot(num_prefixes_onehot),
                        .num_prefixes_encoded(num_prefixes_encoded));

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                        OPCODE DECODE:                                          */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    //outputs
    wire [0:0] isMOD;
    wire [0:0] modSWAP; //unused
    wire [0:0] isDouble; 
    wire [7:0] OPCext; 
    wire [4:0] aluk; 
    wire [2:0] MUX_ADDER_IMM; 
    wire [0:0] MUX_AND_INT; 
    wire [0:0] MUX_SHIFT; 
    wire [36:0] P_OP; 
    wire [17:0] FMASK; 
    wire [1:0] conditionals; 
    wire [0:0] swapEIP; //unused
    wire [0:0] isBR; 
    wire [0:0] isFP; 
    wire [0:0] isImm; 
    wire [1:0] immSize; 
    wire [1:0] size; 
    wire [2:0] R1; 
    wire [2:0] R2; // either R/M or Base from SIB
    wire [2:0] R3; // Index from SIB
    wire [2:0] R4; 
    wire [2:0] S1; 
    wire [2:0] S2; 
    wire [2:0] S3; 
    wire [2:0] S4; 
    wire [12:0] op1_mux; 
    wire [12:0] op2_mux; 
    wire [12:0] op3_mux; 
    wire [12:0] op4_mux; 
    wire [12:0] dest1_mux; 
    wire [12:0] dest2_mux; 
    wire [12:0] dest3_mux; 
    wire [12:0] dest4_mux; 
    wire [0:0] op1_wb; 
    wire [0:0] op2_wb; 
    wire [0:0] op3_wb; 
    wire [0:0] op4_wb; 
    wire [0:0] R1_MOD_OVR; 
    wire [1:0] M1_RW; 
    wire [1:0] M2_RW; 
    wire [1:0] OP_MOD_OVR; 
    wire [0:0] S3_MOD_OVR; 
    // wire [3:0] memSizeOVR; 

    //inputs
    wire[7:0] B1, B2, B3, B4, B5, B6;
    assign B1 = buffered_byte0;
    assign B2 = buffered_byte1;
    assign B3 = buffered_byte2;
    assign B4 = buffered_byte3;
    assign B5 = buffered_byte4;
    assign B6 = buffered_byte5;

    wire isREP, isSIZE, isSEG;
    assign isREP = is_rep;
    assign isSIZE = is_opsize_override;
    assign isSEG = is_seg_override;

    wire[3:0] prefSize;
    assign prefSize = num_prefixes_onehot;

    wire[5:0] segSEL;
    assign segSEL = seg_override;

    //~1.5 ns
    cs_top opcode(.isMOD(isMOD), .modSWAP(modSWAP), .isDouble(isDouble), .OPCext(OPCext), .aluk(aluk), .MUX_ADDER_IMM(MUX_ADDER_IMM), 
                .MUX_AND_INT(MUX_AND_INT), .MUX_SHIFT(MUX_SHIFT), .P_OP(P_OP), .FMASK(FMASK), .conditionals(conditionals), .swapEIP(swapEIP), 
                .isBR(isBR), .isFP(isFP), .isImm(isImm), .immSize(immSize), .size(size), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .S1(S1), .S2(S2), 
                .S3(S3), .S4(S4), .op1_mux(op1_mux), .op2_mux(op2_mux), .op3_mux(op3_mux), .op4_mux(op4_mux), .dest1_mux(dest1_mux), .dest2_mux(dest2_mux), 
                .dest3_mux(dest3_mux), .dest4_mux(dest4_mux), .op1_wb(op1_wb), .op2_wb(op2_wb), .op3_wb(op3_wb), .op4_wb(op4_wb), .R1_MOD_OVR(R1_MOD_OVR), 
                .M1_RW(M1_RW), .M2_RW(M2_RW), .OP_MOD_OVR(OP_MOD_OVR), .S3_MOD_OVR(S3_MOD_OVR), .memSizeOVR(memSizeOVR), .B1(B1), .B2(B2), .B3(B3), .B4(B4), 
                .B5(B5), .B6(B6), .isREP(isREP), .isSIZE(isSIZE), .isSEG(isSEG), .prefSize(prefSize), .segSEL(segSEL));


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                    length and modrm DECODE:                                    */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [5:0] length_of_mod_sib_disp;
    wire [3:0] disp_size;
    wire [2:0] R2_modrm;
    wire useR2;
    wire [2:0] R3_modrm;
    wire useR3;
    wire isSIB;
    wire [1:0] R3_scale;
    addressing_decode addr_dec(
        .packet1(buffered_byte1),
        .packet2(buffered_byte2),
        .packet3(buffered_byte3),
        .packet4(buffered_byte4),
        .packet5(buffered_byte5),
        .packet6(buffered_byte6),
        .isMod(isMOD),
        .num_prefixes_onehot(num_prefixes_onehot),
        .isDoubleOp(isDouble),
        .is_opsize_override(is_opsize_override),

        .length_of_mod_sib_disp(length_of_mod_sib_disp),
        .disp_size(disp_size),
        .R2_override_val(R2_modrm),
        .use_R2(useR2),
        .shift_R3_amount(R3_scale),
        .R3_override_val(R3_modrm),
        .use_R3(useR3),
        .isSIB(isSIB)
    );

    wire [11:0] identify_length_signal;
    assign identify_length_signal = {num_prefixes_encoded, isDouble, isImm, immSize, length_of_mod_sib_disp};
    wire [7:0] decoded_instr_length;
    select_length sel_len(
        .sel(identify_length_signal),
        .out(decoded_instr_length)
    );


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                      little endian BS:                                         */    
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [47:0] immediate;
    wire [31:0] displacement;

    disp_imm_select dis(
        .B1(buffered_byte1),
        .B2(buffered_byte2),
        .B3(buffered_byte3),
        .B4(buffered_byte4),
        .B5(buffered_byte5),
        .B6(buffered_byte6),
        .B7(buffered_byte7),
        .B8(buffered_byte8),
        .B9(buffered_byte9),
        .B10(buffered_byte10),
        .B11(buffered_byte11),
        .B12(buffered_byte12),
        .B13(buffered_byte13),
        .B14(buffered_byte14),
        .B15(buffered_byte15),
        .isDouble(isDouble),
        .isMOD(isMOD),
        .isSIB(isSIB),
        .num_prefixes_onehot(num_prefixes_onehot),
        .disp_size_select(disp_size),
        .imm_size_select(immSize),

        .immediate(immediate),
        .displacement(displacement)
    );


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                        EIP BS:                                                 */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [2:0] select_CF_mux;

    wire select_CF_mux_0, select_CF_mux_1, select_CF_mux_2;
    assign select_CF_mux_2 = is_init;
    
    wire not_is_init;
    inv1$ i0(.in(is_init), .out(not_is_init));
    andn #(2) a0(.in({not_is_init, is_resteer}), .out(select_CF_mux_1));

    wire not_is_resteer;
    inv1$ i1(.in(is_resteer), .out(not_is_resteer));
    andn #(3) a1(.in({not_is_init, not_is_resteer, is_BR_T_NT}), .out(select_CF_mux_0));

    wire [31:0] CF_EIP;
    muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(32)) m0(
        .in({init_EIP, WB_EIP, BP_EIP}), 
        .sel({select_CF_mux_2, select_CF_mux_1, select_CF_mux_0}), 
        .out(CF_EIP)
    );

    wire is_CF, not_is_CF;
    orn #(3) o0(.in({is_init, is_resteer, is_BR_T_NT}), .out(is_CF));
    inv1$ i2(.in(is_CF), .out(not_is_CF));

    wire [31:0] latched_EIP, EIP_plus_length, mux_EIP_to_load;
    muxnm_tristate #(.NUM_INPUTS(2), .DATA_WIDTH(32)) m1(
        .in({EIP_plus_length, CF_EIP}), 
        .sel({not_is_CF, is_CF}), 
        .out(mux_EIP_to_load)
    );

    wire not_stall, ld_BIP;
    wire ld_EIP_without_CF;
    wire ld_EIP;
    inv1$ i0234235(.in(queue_full_stall), .out(not_stall));
    andn #(2) a2(.in({not_stall, valid_in}), .out(ld_EIP_without_CF));
    orn #(2) o2(.in({ld_EIP_without_CF, is_CF}), .out(ld_EIP));
    
    regn #(.WIDTH(32)) EIP_reg(.din(mux_EIP_to_load), .ld(ld_EIP), .clk(clk), .clr(reset), .dout(latched_EIP));

    wire [7:0] instruction_length;
    wire pass_length;
    // andn #(2) a3qlwkhrkj1ho23(.in({not_is_CF, valid_in}), .out(pass_length));
    assign pass_length = valid_in;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(8)) muuxewuxee1(
        .in({decoded_instr_length, 8'b00000000}), 
        .sel(pass_length), 
        .out(instruction_length)
    );

    kogeAdder #(.WIDTH(32)) add0(.A(latched_EIP), .B({24'b000000000000000000000000, instruction_length}), .CIN(1'b0), .SUM(EIP_plus_length), .COUT());



    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                        ASSIGN OUTPUTS:                                         */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    /*                                                                                                */
    ////////////////////////////////////////////////////////////////////////////////////////////////////

    assign valid_out = valid_in;
    assign reg_addr1_out = R1;
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(3)) m0234(.in({R2_modrm, R2}), .sel(isMOD), .out(reg_addr2_out));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(3)) m11234(.in({R3_modrm, R3}), .sel(isMOD), .out(reg_addr3_out));
    assign reg_addr4_out = R4;
    assign seg_addr1_out = S1;
    assign seg_addr2_out = S2;
    assign seg_addr3_out = S3;
    assign seg_addr4_out = S4;
    assign opsize_out = size;
    inv1$ wehwehweh(.in(is_opsize_override), .out(addressingmode_out));//1 for 32b addressing mode, 0 for 16b
    assign op1_out = op1_mux;
    assign op2_out = op2_mux;
    assign op3_out = op3_mux;
    assign op4_out = op4_mux;
    assign res1_ld_out = op1_wb;
    assign res2_ld_out = op2_wb;
    assign res3_ld_out = op3_wb;
    assign res4_ld_out = op4_wb; //better op1-4_wb
    assign dest1_out = dest1_mux;
    assign dest2_out = dest2_mux;
    assign dest3_out = dest3_mux; 
    assign dest4_out = dest4_mux;
    assign disp_out = displacement;
    assign reg3_shfamnt_out = R3_scale;
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m2(.in({useR2, 1'b1}), .sel(isMOD), .out(usereg2_out));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m3(.in({useR3, 1'b0}), .sel(isMOD), .out(usereg3_out));
    assign rep_out = is_rep;

    assign aluk_out = aluk;
    assign mux_adder_out = MUX_ADDER_IMM;
    assign mux_and_int_out = MUX_AND_INT;
    assign mux_shift_out = MUX_SHIFT;
    assign p_op_out = P_OP;
    assign fmask_out = FMASK;
    assign conditionals_out = conditionals;
    assign is_br_out = isBR;
    assign is_fp_out = isFP;
    assign imm_out = immediate;
    assign mem1_rw_out = M1_RW;
    assign mem2_rw_out = M2_RW;
    assign eip_out = EIP_plus_length;
    assign IE_out = IE_in;
    assign IE_type_out = IE_type_in;
    

    assign D_length = instruction_length;
    assign stall_out = queue_full_stall;
    assign isImm_out = isImm;

    assign latched_eip_out = latched_EIP;

    regn #(1) BP_alias_reg(.din(BP_alias_in), .ld(valid_out), .clk(clk), .clr(reset), .dout(BP_alias_out));
    regn #(32) BR_pred_target_reg(.din(BP_BR_pred_target_in), .ld(valid_out), .clk(clk), .clr(reset), .dout(BR_pred_target_out));
    regn #(1) BR_pred_T_NT_reg(.din(is_BR_T_NT), .ld(valid_out), .clk(clk), .clr(reset), .dout(BR_pred_T_NT_out));




endmodule
