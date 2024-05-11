//ADD EFLAG_Override
//ADD EIPswap
//handle EIP+CS in execute
// add {CS, EIP} to ALU - handled in rrag/mem
// swap EIP and CS to res2 - handled in rrag/mem
//Handle ESP-4 ,2 for OP4
//verify CMOVC reads both r132 and rm32
// handle push for OP3 and decrementing ESP
//allow OP4 = OP4 + OP2

//Look into how to handle skipgen when BR pred taken but actually not


module execute_TOP(
    input clk,
    input fwd_stall,
    input valid_in,                         // M
    input latch_empty,
    input [31:0] EIP_in,                    // N
    input [31:0] latched_EIP_in,            // N
    input IE_in,                            //interrupt or exception signal - N
    input [3:0] IE_type_in,                 // N
    input [31:0] BR_pred_target_in,         //branch prediction target - N
    input BR_pred_T_NT_in,                  //branch prediction taken or not taken - N
    input set, rst,                        
    input [6:0] PTCID_in,
    input res1_ld_in, res2_ld_in, res3_ld_in, res4_ld_in, //N
    


    input[63:0] op1, op2, op3, op4, //M
    input [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo, //M
    input [3:0] wake_in, //TODO: M, needs to be implemented - not implemented in TOP just yet

    input [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr, //N
    input res1_is_reg_in, res2_is_reg_in, res3_is_reg_in, res4_is_reg_in, //N
    input res1_is_seg_in, res2_is_seg_in, res3_is_seg_in, res4_is_seg_in, //N
    input res1_is_mem_in, res2_is_mem_in, res3_is_mem_in, res4_is_mem_in, //N
    input[1:0] opsize_in, //N
    
    //From ContStore
    input[4:0] aluk, //N
    input [2:0] MUX_ADDER_IMM, //N
    input MUX_AND_INT,  //N
    input MUX_SHIFT, //N
    input[36:0] P_OP, //N
    input [17:0] FMASK, //N
    input [1:0] conditionals, //N
    input isImm,
    
    //From BP
    input isBR,     //N
    input is_fp,    //N
    input is_rep_in,   //N
    input[15:0] CS, //N
    //Global

    output valid_out,
    output [31:0] EIP_out, //
    output [31:0] latched_EIP_out, 
    output IE_out,
    output [3:0] IE_type_out,
    output [31:0] BR_pred_target_out,
    output BR_pred_T_NT_out,
    output [6:0] PTCID_out,
    output is_rep_out,

    output[17:0] eflags,
    output[15:0] CS_out, 
    output [36:0] P_OP_out,
    
    output res1_wb, res2_wb, res3_wb, res4_wb,
    output [63:0] res1, res2, res3, res4, //done
    output [127:0] res1_ptcinfo, res2_ptcinfo, res3_ptcinfo, res4_ptcinfo,
    output res1_is_reg_out, res2_is_reg_out, res3_is_reg_out, res4_is_reg_out, //done
    output res1_is_seg_out, res2_is_seg_out, res3_is_seg_out, res4_is_seg_out, //done
    output res1_is_mem_out, res2_is_mem_out, res3_is_mem_out, res4_is_mem_out, //done
    output [31:0] res1_dest, res2_dest, res3_dest, res4_dest, //
    output [1:0] ressize, //done
        
    //BR Outputs
    output BR_valid, //
    output BR_taken, //
    output BR_correct,  //
    output[31:0] BR_FIP, BR_FIP_p1,
    output stall
);

    assign stall = fwd_stall;

    wire cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_val;
    wire af, cf, of, sf, pf, zf, df;
    assign EIP_out = EIP_in;
    assign latched_EIP_out = latched_EIP_in;
    assign is_rep_out = is_rep_in;
    assign res2_wb = res2_ld_in;
    assign res1_wb = res1_ld_in;
    wire swapCXC; 
    wire[63:0] res2_xchg;
    wire gBR;

    orn #(7) o1({P_OP[3], P_OP[11],P_OP[12],P_OP[34], P_OP[35], P_OP[36], P_OP[28]}, gBR );


    wire valid_internal, invempty;
    inv1$ i0(.out(invempty), .in(latch_empty));
    and2$ g9(.out(valid_internal), .in0(valid_in), .in1(invempty));

    //handle RES3/RES4
    assign ressize = opsize_in;
    assign PTCID_out = PTCID_in;
    //assign res4 = op4;
    res4Handler r4H(op4, op2, opsize_in, isImm, P_OP[26], P_OP[24],P_OP[3], P_OP[34],P_OP[35], P_OP[28], P_OP[36], P_OP[15], res4 );
    assign res4_is_reg_out = res4_is_reg_in;
    assign res4_is_seg_out = res4_is_seg_in;
    assign res4_is_mem_out = res4_is_mem_in;
    assign res4_dest = dest4_addr;
    assign res4_wb = res4_ld_in;
    assign res4_ptcinfo = op4_ptcinfo;

    //assign res3 = op3;
    res3Handler r3H(op3, opsize_in, P_OP[15], df, res3);
    assign res3_is_reg_out = res3_is_reg_in;
    assign res3_is_seg_out = res3_is_seg_in;
    assign res3_is_mem_out = res3_is_mem_in;
    assign res3_dest = dest3_addr;
    assign res3_wb = res3_ld_in;
    assign res3_ptcinfo = op3_ptcinfo;

    wire[31:0] res1_dest_out;

    //Handle RES1/RES2
    // mux4n #(64) mx1(res1_is_reg, op1_is_reg, op2_is_reg, op2_is_reg, op2_is_reg, swapCXC, P_OP[33]);
    // mux2n #(32) mx4(res1_dest, res1_dest_out, dest2_addr, P_OP[33]);
    assign res1_is_reg_out = res1_is_reg_in;
    assign res1_is_seg_out = res1_is_seg_in;
    assign res1_is_mem_out = res1_is_mem_in;
    assign res1_dest = res1_dest_out;
    assign res1_ptcinfo = op1_ptcinfo;
    
    // mux2n #(64) mx5(res2, res2_xchg, op2, P_OP[15]);
    // mux2n #(64) mx2(res2_is_reg, op2_is_reg, op1_is_reg, P_OP[33]);
    // mux2n #(32) mx3(res2_dest, dest2_addr, dest1_addr, P_OP[33]);
    res2Handler r2H(op1, op2, df, opsize_in, P_OP[15], P_OP[33], P_OP[35], P_OP[36], res2);
    assign res2_is_reg_out = res2_is_reg_in;
    assign res2_is_seg_out = res2_is_seg_in;
    assign res2_is_mem_out = res2_is_mem_in;
    assign res2_dest = dest2_addr;
    assign res2_ptcinfo = op2_ptcinfo;

    //handle ALU
    ALU_top a1(res1, res1_dest_out, res2_xchg, swapCXC, cf_out, pf_out, af_out, zf_out, sf_out, of_out, df_out, cc_inval, op1, op2, op3, dest1_addr, aluk, MUX_ADDER_IMM, MUX_AND_INT, MUX_SHIFT, P_OP[7], P_OP[2], P_OP[31],P_OP[29], P_OP[30], opsize_in,af,cf,of,zf, CS, EIP_in); 

    //Handle eflags block
    wire[17:0] eflags_ld, eflags_rd;
    assign eflags = eflags_rd;
    assign eflags_ld = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b0, of_out, df_out,  1'b0, 1'b0, sf_out, zf_out, af_out, pf_out, cf_out}; 
    assign af = eflags_rd[2]; assign cf = eflags_rd[0];  assign pf = eflags_rd[1]; assign zf = eflags_rd[3];   assign sf = eflags_rd[4];  assign df = eflags_rd[7];  assign of = eflags_rd[8];     
    EFLAG e1(eflags_rd, clk, set, rst, valid_internal, eflags_ld, FMASK, cc_inval);
    assign CS_out = CS;
    assign P_OP_out = P_OP;
    //Handle skipGen
    wire skip;
    SKIPGEN s1(skip, P_OP[6], P_OP[11], P_OP[12], cf, zf, conditionals);
    inv1$ i1(skip_n, skip);
    and2$ a2(valid_out, valid_internal, skip_n);

    //HandleBRLOGIC
    BRLOGIC b1(BR_valid, BR_taken, BR_correct, BR_FIP, BR_FIP_p1, valid_internal, BR_pred_target_in, BR_pred_T_NT_in, conditionals, zf, cf, res1[31:0], P_OP[11], P_OP[12], P_OP[32], gBR);

    //TODO: exception checking for DIV0 for FDIV
    //      - without throwing exception, result from Goldschmidt div will be 0:

    //assign IE_type_out[1:0] = IE_type_in[1:0];
    //assign IE_type_out[2] fp_div0_exception;
    //assign IE_type_out[3] = IE_type_in[3];
    //or2$ g3(.out(IE_out), .in0(IE_in), .in1(fp_div0_exception);

endmodule


module res2Handler(
    input [63:0] op1, op2,
    input df,
    input [1:0] size, 
    input P_OP_MOVS,
    input P_OP_XCHG,
    input P_OP_CALL_PTR, P_OP_RET_PTR,
    output[63:0] res2    
);

wire[31:0] add1;
wire[31:0] addResults;
wire[1:0] size_adj;

or3$ orx(size_adj[1], P_OP_CALL_PTR, P_OP_RET_PTR ,size[1]);
or3$ ory(size_adj[0], P_OP_CALL_PTR, P_OP_RET_PTR ,size[0]);

mux8_n #(32) mx(add1, 32'd1, 32'd2, 32'd4, 32'd8, 32'hFFFF, 32'hFFFE, 32'hFFFF_FFFC, 32'hFFFF_FFF8, size_adj[0], size_adj[1], df );
kogeAdder #(32) add0(addResults, dc, op2[31:0], add1, 1'b0 );



mux4n #(32) m0(res2[31:0], op2[31:0], addResults, op1[31:0], op1[31:0], P_OP_MOVS, P_OP_XCHG);
mux2n #(32) m1(res2[63:32], op2[63:32], op1[63:32], P_OP_XCHG);


endmodule

module res3Handler(
    input[63:0] op3,
    input[1:0] size,
    // input sizeOVR, 
    input P_OP_MOVS,
    input df,
    output[63:0] res3
);
    wire[31:0] add1;
    wire[31:0] addResults;
    mux8_n #(32) mx(add1, 32'd1, 32'd2, 32'd4, 32'd8, 32'hFFFF, 32'hFFFE, 32'hFFFF_FFFC, 32'hFFFF_FFF8, size[0], size[1], df );
    kogeAdder #(32) add0(addResults, dc, op3[31:0], add1, 1'b0 );

    mux2n #(32) m0(res3[31:0], op3[31:0], addResults, P_OP_MOVS);
    assign res3[63:32] = op3[63:32];
endmodule

module res4Handler(
    input[63:0] op4, 
    input[63:0] op2,
    input [1:0] size,
    input isImm,

    input P_OP_PUSH, 
    input P_OP_POP,
    input P_OP_CALL_NEAR,
    input P_OP_CALL_FAR,
    input P_OP_CALL_PTR,
    input P_OP_RET_FAR,
    input P_OP_RET_PTR,
    input P_OP_MOVS,

    output[63:0] res4
);
    wire isPush, isPop;
    wire[31:0] add1, add2,add3, addResults;
    or4$ pus(isPush, P_OP_PUSH, P_OP_CALL_NEAR, P_OP_CALL_FAR, P_OP_CALL_PTR );
    or3$ pop(isPop, P_OP_POP, P_OP_RET_FAR, P_OP_RET_PTR);
    or2$ isRET(isRet, P_OP_RET_FAR, P_OP_RET_PTR);
    and2$ immO(immOVR, isRet, isImm);
    or3$ incre(switch, isPush, isPop, P_OP_MOVS);

    mux8_n #(32) mx(add3, 32'd1, 32'd2, 32'd4, 32'd8, 32'hFFFF, 32'hFFFE, 32'hFFFF_FFFC, 32'hFFFF_FFF8, size[0], size[1], isPush );
    // mux2n #(32) mxm(add3, add1, op2[31:0],)
    mux2n #(32) mnx(add1, add3,op2[31:0],immOVR );
    mux2n #(32) mxn(add2, add1, 32'hFFFF_FFFF, P_OP_MOVS);
    kogeAdder #(32) add0(addResults, dc, op4[31:0], add2, 1'b0 );
    mux2n #(32) m0(res4[31:0], op4[31:0], addResults, immOVR);
    assign res4[63:32] = op4[63:32];

    // mux2n #(32) (res4[31:0],op4[31:0], add_Results





endmodule

/*
P_OP List/Numbering
0	ADD
1	AND
2	BSF
3	CALLnear
4	CLD
5	STD
6	CMOVC
7	CMPXCHG
8	DAA
9	HLT
0	IREtd
11	JMPnear
12	JMPfar
13	MOV
14	MOVQ
15	MOVS
16	NOT
17	OR
18	PADDW
19	PADDD
20	PACKSSWB
21	PACKSSDW
22	PUNPCKHBW
23	PUNPCKHWD
24	POP
25	POP_seg
26	PUSH
27	PUSH_seg
28	RET
29	SAL
30	SAR
31      STD
32 	JMPptr
33  XCHG
34 CALLfar
35 call ptr
36 return ptr
*/
