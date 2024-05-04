#To overwrite on MODRM: M1 to R1 for op2_mux/dest_mux if MOD == 3, also clear m1_RW to 00
#On S3_MOD_OR, set the value of S3 to whatever the reg specifed by MODRM is
#To overwrite on MODRM: ZZZ to EBP
#To overwrite on MODRM: Change R1 from its initial value to register specified by mod when R1_MOD_OR == 1
#M1 = "13'h0100" | R1 = "13'h0001"
#REP prefix must override OP4_WB to 1
# 0 	ADD - done
# 1 	AND - done
# 2 	BSF - done
# 3 	CALLnear - done
# 4 	CLD - done
# 5 	STD - done
# 6 	CMOVC -done
# 7 	CMPXCHG - done
# 8 	DAA - done
# 9	    HLT
# 0	    IREtd
# 11	JMPnear
# 12	JMPfar
# 13	MOV - done
# 14	MOVQ - done
# 15	MOVS -done
# 16	NOT - done
# 17	OR - done
# 18	PADDW - done
# 19	PADDD - dobne
# 20	PACKSSWB - done
# 21	PACKSSDW - done
# 22	PUNPCKHBW - done
# 23	PUNPCKHWD - done
# 24	POP - done
# 25	POP_seg //ignore4 now
# 26	PUSH -done
# 27	PUSH_seg //ignore4 now
# 28	RETnear -done
# 29	SAL - done
# 30	SAR - done
# 31      STD -done
# 32	JMPptr -done
# 33      XCHG - done
# 34      CALLfar -done
# 35 	CALLptr - done
# 36	RETfar -done
#
#
# List of signals coming from WB:
# BR_valid
# BR_taken
# BR_Correct
# BR_FIP [31:0]
# BR_FIP_p1 [31:0]
# BR_EIP [31:0]
# LD_EIP[1:0]
# LD_segReg[1:0]
# segReg_out1, 2 [15:0]
#
#
# //Include RES1-4
# RES1_valid
# RES1 [63:0]
# RES1_size [1:0]
# Res1_dest [31:0]
# RES1_isReg
# RES1_PTC[???]
# //Memory control signals for RES1/RES2 as well, but not writing them out
#
#
#
