def ADD(row,op,asm):
    #OP1
    row[6] = "1'b1"    #op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  #op1_size
    row[9] = "32'd0"                                                    #Op1_orig
    row[10] =  "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"                   #op1_isReg
    row[11] = "1'b0"                                                                   #op1_isSegReg
    row[12] = "1'b0"                                                    #op1_loadEIP
    row[43] = "1'b0"                        #op1_isMem
    row[49] = "1'b0"      #op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if "r" in asm[2] else "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0" #op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    #CS
    row[31] = "6'b000001"  #aluk
    row[32] = "3'b000"      #MUX_ADDER_IMM
    row[33] = "1'b0"  #MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0001"  #P_OP
    #17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_1_0_00_1_1_1_1_1"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00" #pushEIP_CS (one hot)

    return
def AND(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0" #op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if "r" in asm[2] else "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw

    # CS
    row[31] = "6'b000000"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0010"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_1_0_00_1_1_0_1_1" #mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def BSF(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1"   # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] =  "2'b10"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b000010"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0100"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_1_0_0_0"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)

    return
def CALLnear(row,op,asm):
    return

def CLD(row,op,asm):
    # OP1
    row[6] = "1'b0"  # op1_wb
    row[8] = "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b000101"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0001_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_1_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def STD(row,op,asm):

        # OP1
        row[6] = "1'b0"  # op1_wb
        row[8] = "2'b00"  # op1_size
        row[9] = "32'd0"  # Op1_orig
        row[10] = "1'b0"  # op1_isReg
        row[11] = "1'b0"  # op1_isSegReg
        row[12] = "1'b0"  # op1_loadEIP
        row[43] = "1'b0"  # op1_isMem
        row[49] = "1'b0"  # op_rw
        # OP2
        row[13] = "1'b0"  # op2_wb
        row[15] = "2'b00"  # op2_size
        row[16] = "32'd0"  # Op2_orig
        row[17] = "1'b0"  # op2_isReg
        row[18] = "1'b0"  # op2_isSegReg
        row[19] = "1'b0"  # op2_loadEIP
        row[44] = "1'b0"  # op2_isMem
        row[50] = "1'b0"  # op_rw

        # OP3
        row[20] = "1'b0"  # op3_wb
        row[22] = "2'b00"  # op3_size
        row[23] = "32'd0"  # Op3_orig
        row[24] = "1'b0"  # op3_isReg
        row[25] = "1'b0"  # op3_isSegReg
        row[45] = "1'b0"  # op3_isMem
        row[51] = "1'b0"  # op_rw

        # OP4
        row[26] = "1'b0"  # op4_wb
        row[28] = "2'b00"  # op4_size
        row[29] = "32'd0"  # Op4_orig
        row[30] = "1'b0"  # op4_isReg
        row[47] = "1'b0"  # op4_isSegReg
        row[46] = "1'b0"  # op4_isMem
        row[52] = "1'b0"  # op_rw

        # CS
        row[31] = "6'b000110"  # aluk
        row[32] = "3'b000"  # MUX_ADDER_IMM
        row[33] = "1'b0"  # MUX_AND_INT
        row[35] = "37'b0_0000_1000_0000_0000_0000_0000_0000_0010_0000"  # P_OP
        # 17'b000000000_of_df_00_sf_zf_af_pf_cf
        row[36] = "17'b000000000_0_1_00_0_0_0_0_0"  # mask for EFLAGS
        row[38] = "1'b0"  # swapEIP
        row[48] = "2'b00"  # pushEIP_CS (one hot)
        return
def CMOVC(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if "r" in asm[2] else "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b000011"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0100_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def CMPXCHG(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1"   # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b10" if "32" in asm[2] else "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b1"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b000111"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0000_1000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_1_0_0_0"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def DAA(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1"   # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] =  "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] =  "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b001000"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0000_0001_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_1_1_1_1_1"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def HLT(row,op,asm):
    return
def IREtd(row,op,asm):
    return
def JMPnear(row,op,asm):
    return
def JMPfar(row,op,asm):
    return
def MOV(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0" if not "+" in op[0] else row[9] # Op1_orig
    row[10] = "1'b1" if ("EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] ) and not "Sreg" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b1" if "Sreg" in asm[1] else "1'b0"   # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if (not "Sreg" in asm[2])  and (not "imm" in asm[2]) and (not "/" in asm[2])else "1'b0"  # op2_isReg
    row[18] = "1'b1" if "Sreg" in asm[2] else "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b000011"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0010_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)


def MOVQ(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b11"  # op1_size
    row[9] = "32'd0" if not "+" in op[0] else row[9]  # Op1_orig
    row[10] = "1'b1" if ("EAX" in row[1] or "AL" in row[1] or not "/" in asm[1]) and not "Sreg" in asm[
        1] else "1'b0"  # op1_isReg
    row[11] = "1'b1" if "Sreg" in asm[1] else "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b11"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if (not "Sreg" in asm[2]) and (not "imm" in asm[2]) and (
        not "/" in asm[2]) else "1'b0"  # op2_isReg
    row[18] = "1'b1" if "Sreg" in asm[2] else "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b000011"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0000_0010_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
def MOVS(row,op,asm):
    return
def NOT(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b010001"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0001_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
def OR(row,op,asm):
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1" if "r" in asm[2] else "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b001010"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0010_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_1_1_00_1_1_0_1_1"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
def PADDW(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b11"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b11"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b001011"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0000_0100_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def PADDD(row,op,asm):
        # OP1
        row[6] = "1'b1"  # op1_wb
        row[8] = "2'b11"  # op1_size
        row[9] = "32'd0"  # Op1_orig
        row[10] = "1'b1"  # op1_isReg
        row[11] = "1'b0"  # op1_isSegReg
        row[12] = "1'b0"  # op1_loadEIP
        row[43] = "1'b0"  # op1_isMem
        row[49] = "1'b0"  # op_rw
        # OP2
        row[13] = "1'b0"  # op2_wb
        row[15] = "2'b11"  # op2_size
        row[16] = "32'd0"  # Op2_orig
        row[17] = "1'b0"  # op2_isReg
        row[18] = "1'b0"  # op2_isSegReg
        row[19] = "1'b0"  # op2_loadEIP
        row[44] = "1'b0"  # op2_isMem
        row[50] = "1'b0"  # op_rw
        # OP3
        row[20] = "1'b0"  # op3_wb
        row[22] = "2'b00"  # op3_size
        row[23] = "32'd0"  # Op3_orig
        row[24] = "1'b0"  # op3_isReg
        row[25] = "1'b0"  # op3_isSegReg
        row[45] = "1'b0"  # op3_isMem
        row[51] = "1'b0"  # op_rw
        # OP4
        row[26] = "1'b0"  # op4_wb
        row[28] = "2'b00"  # op4_size
        row[29] = "32'd0"  # Op4_orig
        row[30] = "1'b0"  # op4_isReg
        row[47] = "1'b0"  # op4_isSegReg
        row[46] = "1'b0"  # op4_isMem
        row[52] = "1'b0"  # op_rw
        # CS
        row[31] = "6'b001100"  # aluk
        row[32] = "3'b000"  # MUX_ADDER_IMM
        row[33] = "1'b0"  # MUX_AND_INT
        row[35] = "37'b0_0000_0000_0000_0000_1000_0000_0000_0000_0000"  # P_OP
        # 17'b000000000_of_df_00_sf_zf_af_pf_cf
        row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
        row[38] = "1'b0"  # swapEIP
        row[48] = "2'b00"  # pushEIP_CS (one hot)
        return
def PACKSSWB(row,op,asm):
        # OP1
        row[6] = "1'b1"  # op1_wb
        row[8] = "2'b11"  # op1_size
        row[9] = "32'd0"  # Op1_orig
        row[10] = "1'b1"  # op1_isReg
        row[11] = "1'b0"  # op1_isSegReg
        row[12] = "1'b0"  # op1_loadEIP
        row[43] = "1'b0"  # op1_isMem
        row[49] = "1'b0"  # op_rw
        # OP2
        row[13] = "1'b0"  # op2_wb
        row[15] = "2'b11"  # op2_size
        row[16] = "32'd0"  # Op2_orig
        row[17] = "1'b0"  # op2_isReg
        row[18] = "1'b0"  # op2_isSegReg
        row[19] = "1'b0"  # op2_loadEIP
        row[44] = "1'b0"  # op2_isMem
        row[50] = "1'b0"  # op_rw
        # OP3
        row[20] = "1'b0"  # op3_wb
        row[22] = "2'b00"  # op3_size
        row[23] = "32'd0"  # Op3_orig
        row[24] = "1'b0"  # op3_isReg
        row[25] = "1'b0"  # op3_isSegReg
        row[45] = "1'b0"  # op3_isMem
        row[51] = "1'b0"  # op_rw
        # OP4
        row[26] = "1'b0"  # op4_wb
        row[28] = "2'b00"  # op4_size
        row[29] = "32'd0"  # Op4_orig
        row[30] = "1'b0"  # op4_isReg
        row[47] = "1'b0"  # op4_isSegReg
        row[46] = "1'b0"  # op4_isMem
        row[52] = "1'b0"  # op_rw
        # CS
        row[31] = "6'b001101"  # aluk
        row[32] = "3'b000"  # MUX_ADDER_IMM
        row[33] = "1'b0"  # MUX_AND_INT
        row[35] = "37'b0_0000_0000_0000_0001_0000_0000_0000_0000_0000"  # P_OP
        # 17'b000000000_of_df_00_sf_zf_af_pf_cf
        row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
        row[38] = "1'b0"  # swapEIP
        row[48] = "2'b00"  # pushEIP_CS (one hot)
        return
def PACKSSDW(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b11"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b11"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b001110"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_0010_0000_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def PUNPCKHBW(row,op,asm):
    def PACKSSDW(row, op, asm):
        # OP1
        row[6] = "1'b1"  # op1_wb
        row[8] = "2'b11"  # op1_size
        row[9] = "32'd0"  # Op1_orig
        row[10] = "1'b1"  # op1_isReg
        row[11] = "1'b0"  # op1_isSegReg
        row[12] = "1'b0"  # op1_loadEIP
        row[43] = "1'b0"  # op1_isMem
        row[49] = "1'b0"  # op_rw
        # OP2
        row[13] = "1'b0"  # op2_wb
        row[15] = "2'b11"  # op2_size
        row[16] = "32'd0"  # Op2_orig
        row[17] = "1'b0"  # op2_isReg
        row[18] = "1'b0"  # op2_isSegReg
        row[19] = "1'b0"  # op2_loadEIP
        row[44] = "1'b0"  # op2_isMem
        row[50] = "1'b0"  # op_rw
        # OP3
        row[20] = "1'b0"  # op3_wb
        row[22] = "2'b00"  # op3_size
        row[23] = "32'd0"  # Op3_orig
        row[24] = "1'b0"  # op3_isReg
        row[25] = "1'b0"  # op3_isSegReg
        row[45] = "1'b0"  # op3_isMem
        row[51] = "1'b0"  # op_rw
        # OP4
        row[26] = "1'b0"  # op4_wb
        row[28] = "2'b00"  # op4_size
        row[29] = "32'd0"  # Op4_orig
        row[30] = "1'b0"  # op4_isReg
        row[47] = "1'b0"  # op4_isSegReg
        row[46] = "1'b0"  # op4_isMem
        row[52] = "1'b0"  # op_rw
        # CS
        row[31] = "6'b001111"  # aluk
        row[32] = "3'b000"  # MUX_ADDER_IMM
        row[33] = "1'b0"  # MUX_AND_INT
        row[35] = "37'b0_0000_0000_0000_0100_0000_0000_0000_0000_0000"  # P_OP
        # 17'b000000000_of_df_00_sf_zf_af_pf_cf
        row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
        row[38] = "1'b0"  # swapEIP
        row[48] = "2'b00"  # pushEIP_CS (one hot)
        return
def PUNPCKHWD(row,op,asm):
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b11"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b1"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b11"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b0"  # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b010000"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0000_0000_1000_0000_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def POP(row,op,asm):
    return
def PUSH(row,op,asm):
    return
def RETnear(row,op,asm):
    return
def SAL(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0" # Op1_orig
    row[10] = "1'b0"  # op1_isReg
    row[11] = "1'b1" if "Sreg" in asm[1] else "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd2" if "CL" in asm[2] else "32'd0"  # Op2_orig
    row[17] = "1'b1" if "CL" in asm[2] else "32'd0"  # op2_isReg
    row[18] = "1'b1" if "Sreg" in asm[2] else "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b010010"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0010_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_1_0_00_1_1_0_1_1"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def SAR(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0"  # Op1_orig
    row[10] = "1'b0"  # op1_isReg
    row[11] = "1'b1" if "Sreg" in asm[1] else "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op1_rw

    # OP2
    row[13] = "1'b0"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd2" if "CL" in asm[2] else "32'd0"  # Op2_orig
    row[17] = "1'b1" if "CL" in asm[2] else "32'd0"  # op2_isReg
    row[18] = "1'b1" if "Sreg" in asm[2] else "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op1_rw

    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op1_rw

    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op1_rw

    # CS
    row[31] = "6'b010001"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0000_0100_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_1_0_00_1_1_0_1_1"
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def JMPptr(row,op,asm):
    return
def XCHG(row,op,asm):
    # OP1
    row[6] = "1'b1"  # op1_wb
    row[8] = "2'b10" if "EAX" in row[1] or "32" in asm[1] else "2'b00"  # op1_size
    row[9] = "32'd0" if "+" not in op[0] else row[9]  # Op1_orig
    row[10] = "1'b1" if "EAX" in row[1] or "AL" in row[1] or not "/" in asm[1] else "1'b0"  # op1_isReg
    row[11] = "1'b0"  # op1_isSegReg
    row[12] = "1'b0"  # op1_loadEIP
    row[43] = "1'b0"  # op1_isMem
    row[49] = "1'b0"  # op_rw
    # OP2
    row[13] = "1'b1"  # op2_wb
    row[15] = "2'b10" if "32" in asm[2] else "2'b00"  # op2_size
    row[16] = "32'd0"  # Op2_orig
    row[17] = "1'b1"   # op2_isReg
    row[18] = "1'b0"  # op2_isSegReg
    row[19] = "1'b0"  # op2_loadEIP
    row[44] = "1'b0"  # op2_isMem
    row[50] = "1'b0"  # op_rw
    # OP3
    row[20] = "1'b0"  # op3_wb
    row[22] = "2'b00"  # op3_size
    row[23] = "32'd0"  # Op3_orig
    row[24] = "1'b0"  # op3_isReg
    row[25] = "1'b0"  # op3_isSegReg
    row[45] = "1'b0"  # op3_isMem
    row[51] = "1'b0"  # op_rw
    # OP4
    row[26] = "1'b0"  # op4_wb
    row[28] = "2'b00"  # op4_size
    row[29] = "32'd0"  # Op4_orig
    row[30] = "1'b0"  # op4_isReg
    row[47] = "1'b0"  # op4_isSegReg
    row[46] = "1'b0"  # op4_isMem
    row[52] = "1'b0"  # op_rw
    # CS
    row[31] = "6'b000011"  # aluk
    row[32] = "3'b000"  # MUX_ADDER_IMM
    row[33] = "1'b0"  # MUX_AND_INT
    row[35] = "37'b0_0010_0000_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 17'b000000000_of_df_00_sf_zf_af_pf_cf
    row[36] = "17'b000000000_0_0_00_0_0_0_0_0"  # mask for EFLAGS
    row[38] = "1'b0"  # swapEIP
    row[48] = "2'b00"  # pushEIP_CS (one hot)
    return
def CALLfar(row,op,asm):
    return
def CALLptr(row,op,asm):
    return
def RETfar(row,op,asm):
    return



def helperOP(row, op, asm):
    opcode = asm[0]
    opH = row[2]

    if(opcode == "ADD"):
        ADD(row,op,asm)
    elif (opcode == "AND"):
        AND(row, op, asm)
    elif(opcode == "BSF"):
        BSF(row, op, asm)
    elif (opcode == "CLD"):
        CLD(row, op, asm)
    elif (opcode == "STD"):
        STD(row, op, asm)
    elif (opcode == "CMOVC"):
        CMOVC(row, op, asm)
    elif (opcode == "CMPXCHG"):
        CMPXCHG(row, op, asm)
    elif (opcode == "DAA"):
        DAA(row, op, asm)
    elif (opcode == "HLT"):
        HLT(row, op, asm)
    elif (opcode == "IREtd"):
        IREtd(row, op, asm)
    elif (opcode == "MOV"):
        MOV(row, op, asm)
    elif (opcode == "MOVQ"):
        MOVQ(row, op, asm)
    elif (opcode == "MOVS"):
        MOVS(row, op, asm)
    elif (opcode == "NOT"):
        NOT(row, op, asm)
    elif (opcode == "OR"):
        OR(row, op, asm)
    elif(opcode == "PADDW"):
        PADDW(row, op, asm)
    elif (opcode == "PADDD"):
        PADDD(row, op, asm)
    elif (opcode == "PACKSSWB"):
        PACKSSWB(row, op, asm)
    elif (opcode == "PACKSSDW"):
        PACKSSDW(row, op, asm)
    elif (opcode == "PUNPCKHBW"):
        PUNPCKHBW(row, op, asm)
    elif (opcode == "PUNPCKHWD"):
        PUNPCKHWD(row, op, asm)
    elif (opcode == "POP"):
        POP(row, op, asm)
    elif (opcode == "PUSH"):
        PUSH(row, op, asm)
    elif (opH == "8'hC3" or opH == "8'hC2" ):
        RETnear(row, op, asm)
    elif (opcode == "RET"):
        RETfar(row, op, asm)
    elif (opcode == "SAL"):
        SAL(row, op, asm)
    elif (opcode == "SAR"):
        SAR(row, op, asm)
    elif (opcode == "STD"):
        STD(row, op, asm)
    elif (opcode == "XCHG"):
        XCHG(row, op, asm)
    elif(opH == "8'hFF"):
        CALLfar(row, op, asm)
    elif (opH == "8'h9A"):
        CALLptr(row, op, asm)
    elif (opH == "8'hE8"):
        CALLnear(row, op, asm)
    elif (opH == "8'hFF"):
        JMPfar(row, op, asm)
    elif (opH == "8'hEA"):
        JMPptr(row, op, asm)
    elif (opcode == "JMP" or opcode == "JNE" or opcode == "JNBE"):
        JMPnear(row, op, asm)
    else:
        print(opcode)
    #
    row[7] = "x"

    # if(len(asm) > 1 and not(opcode == "CALL" or opcode == "JNBE" or opcode == "JNE" or opcode == "JMP" or opcode == "MOVS"  or opcode == "PUSH"  or opcode == "RET" or opcode == "XCHG" or opH ) or opH == "86" or opH == "87"):
    #     row[6] = "1'b1"
    #     row[8] = "2'b10" if  "32" in asm[1]  else "2'b11" if "64" in asm[1] or "mm" in asm[1] else "2'b00"
    #
    # if opcode == "STD" or opcode == "CLD":
    #     row[6] = "1'b0"
    #     row[8] = "2'b00"
    #
    # if (int(opH,16) >= 0x90) and (int(opH,16) <= 0x97):
    #     row[9] = "3'b000"
    #     row[8] = "2'b10"
    #     row[6] = "1'b1"
    #
    #
    # if len(asm) > 1 and not(opcode == "JMP" or opcode == "JNE" or  opcode == "JNBE" or  opcode == "CALL" or  opcode == "RET" or   opcode == "IREtd" ):
    #     if(asm[1] == "AL" or asm[1] == "EAX" or asm[1] == "r8" or asm[1] == "r16" or asm[1] == "r32" or asm[1] == "mm" or asm[1] == "EAX")