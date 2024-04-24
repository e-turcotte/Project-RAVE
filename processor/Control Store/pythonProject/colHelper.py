DC = "13'h0001"
R1 = "13'h0001"
R2 = "13'h0002"
R3 = "13'h0004"
R4 = "13'h0008"
S1 = "13'h0010"
S2 = "13'h0020"
S3 = "13'h0040"
S4 = "13'h0080"
M1 = "13'h0100"
M2 = "13'h0200"
EIP  = "13'h0400"
CSEIP = "13'h0800"
IMM = "13'h1000"


z = "1'b0"
o = "1'b1"
oo = "2'b11"
zz = "2'b00"
zo = "2'b01"
oz = "2'b10"
zzz = "3'b000"
CS = "3'b000"
DS = "3'b001"
SS = "3'b010"
ES = "3'b011"
FS = "3'b100"
GS = "3'b101"
EAX = "3'b000"
EBX = "3'b001"
ECX = "3'b010"
EDX = "3'b011"
EBP = "3'b100"
ESI = "3'b101"
EDI = "3'b110"
ESP = "3'b111"




def ADD(row,op,asm):
    #CS
    row[7] = "5'b00001"  #aluk
    row[8] = "3'b000"      #MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0001"  #P_OP
    #18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_1_1_1" #FMASK

    version = 0 if "EAX" in row[1] or "AL" in row [1] else 1 if "imm" in row[1]  else 2 if "r/m" in asm[1] else 3
    #1
    row[20] =   EAX    #R1 - MODRM override
    row[24] =   DS     #S1  - MODRM DS
    row[21] =    zzz   # R2  - MODRM Base
    row[25] =    zzz      # S2 - M2 SEG
    row[22] =    EBP   # R3 - MODRM Index
    row[26] =   zzz    # S3 - FREE
    row[23] =  zzz     # R4 - FREE
    row[27] =   CS    # S4 - CS

    row[41] = zz if version == 0 else oo if version == 1 or version == 2 else oz  # M1_RW
    row[42] = zz  # M2_RW

    #OPERAND SWAP LOGIC
    #OP1
    row[28] =   R1 if version == 0 or version == 3 else M1     #op1_mux
    row[32] =    R1 if version == 0 or version == 3 else M1    #dest1_mux
    row[36] =  o      #op1_wb
    # OP2
    row[29] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # op2_mux
    row[33] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def AND(row,op,asm):
    row[7] = "5'b00000"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0010"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_0_1_1"  # FMASK
    version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz if version == 0 else oo if version == 1 or version == 2 else oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1 if version == 0 or version == 3 else M1  # op1_mux
    row[32] = R1 if version == 0 or version == 3 else M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # op2_mux
    row[33] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def BSF(row,op,asm):
    row[7] = "5'b00010"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_0100"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_1_1_1_1_1"  # FMASK
    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] =  oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1   # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] =  M1  # op2_mux
    row[33] =  M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def CALLnear(row,op,asm):
    # CS
    row[7] = "5'b00001"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0000_1000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = SS  # S1  - MODRM DS
    row[21] = ESP  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] =  zo # M1_RW
    row[42] = zz # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = EIP  # op1_mux
    row[32] = EIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM   # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = EIP  # op3_mux
    row[34] = M1  # dest3_mux
    row[38] = o  # op3_wb
    # OP4
    row[31] = R2  # op4_mux
    row[35] = R2  # dest4_mux
    row[39] = o  # op4_wb
    return

def CLD(row,op,asm):
    # CS
    row[7] = "5'b00101"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0001_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_1_00_0_0_0_0_0"  # FMASK
    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz   # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = DC # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def STD(row,op,asm):
    # CS
    row[7] = "5'b00110"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0010_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_1_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = DC  # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def CMOVC(row,op,asm):
    # CS
    row[7] = "5'b00011"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_0100_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000__0_00_0_0_0_0_0"  # FMASK

    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1   # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def CMPXCHG(row,op,asm):
    # CS
    row[7] = "5'b00111"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0000_1000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_1_1_1"  # FMASK

    version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = EAX  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = R1  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = R4  # op3_mux
    row[34] = R4  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def DAA(row,op,asm):
    # CS
    row[7] = "5'b01000"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0001_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_1_1_1_1_1"  # FMASK

    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1   # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def HLT(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0010_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 2 if "Sreg" in asm[2] else 3 if "Sreg" in asm[1] else 5 if "/" in asm[1] and "imm" in asm[
    #     2] else 4 if "imm" in asm[2] else 1 if "/" in asm[2] else 0
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = zzz  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = zzz  # R3 - MODRM Index
    row[26] = zzz  # S3 - MODRM override
    row[23] = zzz  # R4 - FREE
    row[27] = zzz  # S4 - CS

    row[41] = zz   # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = DC  # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb

    return
def IREtd(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_0100_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 2 if "Sreg" in asm[2] else 3 if "Sreg" in asm[1] else 5 if "/" in asm[1] and "imm" in asm[
    #     2] else 4 if "imm" in asm[2] else 1 if "/" in asm[2] else 0
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = zzz  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = zzz  # R3 - MODRM Index
    row[26] = zzz  # S3 - MODRM override
    row[23] = zzz  # R4 - FREE
    row[27] = zzz  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = DC  # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
def JMPnear(row,op,asm):
    row[7] = "5'b00001"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0000_1000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = SS  # S1  - MODRM DS
    row[21] = ESP  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = EIP  # op1_mux
    row[32] = EIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def JMPfar(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0001_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zo  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = EIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def MOV(row,op,asm):
    # CS
    row[7] = "5'b00011"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0010_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 2 if "Sreg" in asm[2] else 3 if "Sreg" in asm[1] else 5 if "/" in asm[1] and "imm" in asm[2] else 4 if "imm" in asm[2] else 1 if "/" in asm[2] else 0
    # 1
    row[20] = row[20]  if version == 4 else EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - MODRM override
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz if version == 4 else oz if version == 1 or version == 3 else oo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1 if version == 0 or version == 2 or version == 5 else R1 if version ==1 or version == 4 else S3  # op1_mux
    row[32] = M1 if version == 0 or version == 2 or version == 5 else R1 if version ==1 or version == 4 else S3 # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] =  R1 if version == 0 else M1 if version == 1 or version == 3 else S3 if version == 2 else IMM # op2_mux
    row[33] =  DC # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return

def MOVQ(row,op,asm):
    # CS
    row[7] = "5'b00011"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_0100_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "64" in asm[1] else 1
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oo if version == 0 else oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1 if version == 0  else R1  # op1_mux
    row[32] = M1 if version == 0  else R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = R1 if version == 0  else  M1  # op2_mux
    row[33] = R1 if version == 0  else  M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def MOVS(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0000_1000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # 1
    row[20] = zzz # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = ESI  # R2  - MODRM Base
    row[25] = ES  # S2 - M2 SEG
    row[22] = ECX  # R3 - MODRM Index
    row[26] = zzz  # S3 - MODRM override
    row[23] = EDI  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zo  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = M2  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = R2  # op2_mux
    row[33] = R2  # dest2_mux
    row[37] = o  # op2_wb
    # OP3
    row[30] = R4  # op3_mux
    row[34] = R4  # dest3_mux
    row[38] = o  # op3_wb
    # OP4
    row[31] = R3  # op4_mux
    row[35] = R3  # dest4_mux
    row[39] = z  # op4_wb
    return
def NOT(row,op,asm):
    # CS
    row[7] = "5'b01001"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0001_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] =DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def OR(row,op,asm):
    # CS
    row[7] = "5'b01010"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0010_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_0_1_1"  # FMASK

    version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz if version == 0 else oo if version == 1 or version == 2 else oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1 if version == 0 or version == 3 else M1  # op1_mux
    row[32] = R1 if version == 0 or version == 3 else M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # op2_mux
    row[33] = IMM if version == 0 or version == 1 else R1 if version == 2 else M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def PADDW(row,op,asm):
    # CS
    row[7] = "5'b01011"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_0100_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    #version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1   # op1_mux
    row[32] = R1   # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def PADDD(row,op,asm):
    # CS
    row[7] = "5'b01100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0000_1000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def PACKSSWB(row,op,asm):
    # CS
    row[7] = "5'b01101"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0001_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return

def PACKSSDW(row,op,asm):
    row[7] = "5'b01110"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0010_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return

def PUNPCKHBW(row,op,asm):
    row[7] = "5'b01111"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_0100_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def PUNPCKHWD(row, op, asm):
    row[7] = "5'b10000"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0000_1000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = R1  # op1_mux
    row[32] = R1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = M1  # op2_mux
    row[33] = M1  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return

def POP(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0001_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "/" in row[1] else 1 if "r32" in row[1] else 2
    segR = CS if "CS" in row[1] else DS if "DS" in row[1] else SS if "SS" in row[1] else ES if "ES" in row[1] else FS if "FS" in row[1] else GS
    # 1
    row[20] = row[20] if version == 1 else zzz   # R1 - MODRM override
    row[24] = segR if version == 2 else DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = DS if "DS" in row[1] else ES if "ES" in row[1]  else SS if "SS" in row[1] else FS if "FS" in row[1] else GS  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zo if version == 0 else zz   # M1_RW
    row[42] = oz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M2 # op1_mux
    row[32] = M1 if version ==0 else R1 if version == 1 else S1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = R4  # op4_mux
    row[35] = R4  # dest4_mux
    row[39] = o  # op4_wb
    return
def PUSH(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0000_0100_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "/" in row[1] else 1 if "r32" in row[1] else 3 if "imm" in row[1] else 2
    segR = CS if "CS" in row[1] else DS if "DS" in row[1] else SS if "SS" in row[1] else ES if "ES" in row[1] else FS if "FS" in row[1] else GS
    # 1
    row[20] = row[20] if version == 1 else zzz  # R1 - MODRM override
    row[24] = segR if version == 2 else DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = DS if "DS" in row[1] else ES if "ES" in row[1] else SS if "SS" in row[1] else FS if "FS" in row[
        1] else GS  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz if version == 0 else zz  # M1_RW
    row[42] = zo  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1 if version == 0 else R1 if version == 1 else IMM if version == 3 else S1  # op1_mux
    row[32] = M2  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = R4  # op4_mux
    row[35] = R4  # dest4_mux
    row[39] = o  # op4_wb
    return
def RETnear(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0001_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "imm" in row[1] else 1

    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = DC  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = oz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M2  # op1_mux
    row[32] = EIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = R4  # op4_mux
    row[35] = R4  # dest4_mux
    row[39] = o if version == o else z  # op4_wb
    return
def SAL(row,op,asm):
    # CS
    row[7] = "5'b10010"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0010_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_0_1_1"  # FMASK

    version = 1 if "CL" in asm[2] else 2 if "imm" in asm[2] else 0
    # 1
    row[20] = ECX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oo   # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC if version == 0 else R1 if version == 1 else R1  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def SAR(row,op,asm):
    # CS
    row[7] = "5'b10001"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0000_0100_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_1_0_00_1_1_0_1_1"  # FMASK

    version = 1 if "CL" in asm[2] else 2 if "imm" in asm[2] else 0
    # 1
    row[20] = ECX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = M1  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC if version == 0 else R1 if version == 1 else R1  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def JMPptr(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0001_0000_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = SS  # S1  - MODRM DS
    row[21] = ESP  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = IMM  # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def XCHG(row,op,asm):
    # CS
    row[7] = "5'b00011"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0010_0000_0000_0000_0000_0000_0000_0000_0001"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "EAX" in row[1] or "AL" in row[1] else 1
    # 1
    row[20] = row[20] if version == 0 else EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = EAX  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz if version == 0 else  oo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1 if version == 1 else R2 # op1_mux
    row[32] = M1 if version == 1 else R2 # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = R1  # op2_mux
    row[33] = R1  # dest2_mux
    row[37] = o  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = DC  # op4_mux
    row[35] = DC  # dest4_mux
    row[39] = z  # op4_wb
    return
def CALLfar(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_0100_0000_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = oz  # M1_RW
    row[42] = zo  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M1  # op1_mux
    row[32] = EIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = DC  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = EIP  # op3_mux
    row[34] = M2  # dest3_mux
    row[38] = o  # op3_wb
    # OP4
    row[31] = R4  # op4_mux
    row[35] = R4  # dest4_mux
    row[39] = o  # op4_wb
    return
def CALLptr(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b0_1000_0000_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK
    # version = 0 if "EAX" in row[1] or "AL" in row[1] else 1 if "imm" in row[1] else 2 if "r/m" in asm[1] else 3
    # 1
    row[20] = zzz  # R1 - MODRM override
    row[24] = SS  # S1  - MODRM DS
    row[21] = ESP  # R2  - MODRM Base
    row[25] = zzz  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = zzz  # S3 - FREE
    row[23] = zzz  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zo  # M1_RW
    row[42] = zz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = IMM  # op1_mux
    row[32] = DC  # dest1_mux
    row[36] = z  # op1_wb
    # OP2
    row[29] = IMM  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = CSEIP  # op3_mux
    row[34] = M1  # dest3_mux
    row[38] = o  # op3_wb
    # OP4
    row[31] = S1  # op4_mux
    row[35] = S1  # dest4_mux
    row[39] = o  # op4_wb
    return
def RETfar(row,op,asm):
    # CS
    row[7] = "5'b00100"  # aluk
    row[8] = "3'b000"  # MUX_ADDER_IMM
    row[11] = "37'b1_0000_0000_0000_0000_0000_0000_0000_0000_0000"  # P_OP
    # 18'b000000000_of_df_00_sf_zf_af_pf_cf
    row[12] = "18'b000000000_0_0_00_0_0_0_0_0"  # FMASK

    version = 0 if "imm" in row[1] else 1

    # 1
    row[20] = EAX  # R1 - MODRM override
    row[24] = DS  # S1  - MODRM DS
    row[21] = zzz  # R2  - MODRM Base
    row[25] = SS  # S2 - M2 SEG
    row[22] = EBP  # R3 - MODRM Index
    row[26] = DC  # S3 - FREE
    row[23] = ESP  # R4 - FREE
    row[27] = CS  # S4 - CS

    row[41] = zz  # M1_RW
    row[42] = oz  # M2_RW

    # OPERAND SWAP LOGIC
    # OP1
    row[28] = M2  # op1_mux
    row[32] = CSEIP  # dest1_mux
    row[36] = o  # op1_wb
    # OP2
    row[29] = IMM  # op2_mux
    row[33] = DC  # dest2_mux
    row[37] = z  # op2_wb
    # OP3
    row[30] = DC  # op3_mux
    row[34] = DC  # dest3_mux
    row[38] = z  # op3_wb
    # OP4
    row[31] = R4  # op4_mux
    row[35] = R4  # dest4_mux
    row[39] = o if version == o else z  # op4_wb
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