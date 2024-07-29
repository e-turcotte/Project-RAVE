module IDTR_FSM_2(
    input clk,
    input rst,
    input rrag_stall,

    input is_IE,
    input is_IRET,
    input [2:0] IE_type_in, 
    input [31:0] IDTR_base_address, //from init

    input valid_wb,
    input [15:0] cs_WB,
    input [31:0] eip_WB,
    input [18:0] eflags_EX_old,
    input [63:0] OP1_wb,
    input [36:0] P_OP_wb,

    output P_OP_1_2_override,
    output P_OP_21_22_override ,
    output P_OP_22_23_override ,
    output invalidate_op1_wb,

    output [127:0] packet_out,
    output packet_select,
    output flush_pipe,
    output PTC_clear,
    output allow_fetch
);
wire block_fetch;
wire state1_in;
assign flush_pipe = state1_in;
assign PTC_clear = state1_in;
// assign packet_select = ;
wire idle;
wire PUSH_EF;
wire PUSH_CS;
wire PUSH_EIP;
wire MOV_ISHR_2_TEMP_L;
wire MOV_ISHR_2_TEMP_H;
wire nop_wait_1;
wire JMP_IMM;

wire idle_middle;

wire MOV_EF_MEM;
wire MOV_EIP_2_TEMP_L;
wire MOV_CS_2_TEMP_H;
wire POP_1;
wire POP_2;
wire POP_3;
wire nop_wait_2;
wire JMP_TEMP_L_TEMP_H;

wire[63:0] temp_reg_l; //Hold temporary values to avoid using regs
wire[63:0] temp_reg_h; // Ditto
wire[31:0] EIP_store, eflags_store;
wire[15:0] CS_store;
///////////////////////////////
//Begin Rohan                //
///////////////////////////////
wire [31:0] protection_vect, page_fault_vect, interrupt_vect;
wire [31:0] vector_out, vector_out_shifted, IDT_entry_address, IDT_entry_address4;
wire [31:0] IDT_entry_address4_final, IDT_entry_address_final;
assign protection_vect = 32'd13;
assign page_fault_vect = 32'd14;
assign interrupt_vect = 32'd15;

wire [2:0] IE_type_not, IE_type_internal;
invn #(.NUM_INPUTS(3)) i0(.out(IE_type_not), .in(IE_type_in));
assign IE_type_internal[0] = IE_type_in[0];
andn #(.NUM_INPUTS(2)) an0(.out(IE_type_internal[1]), .in({IE_type_in[1], IE_type_not[0]}));
andn #(.NUM_INPUTS(3)) an1(.out(IE_type_internal[2]), .in({IE_type_in[2], IE_type_not[1:0]})); 

//if sel is 0, breaks trisate mux but output is a don't care
muxnm_tristate #(.NUM_INPUTS(3), .DATA_WIDTH(32)) m1(.in({interrupt_vect, page_fault_vect, protection_vect}), .sel(IE_type_internal), .out(vector_out)); 
lshfn_fixed #(.WIDTH(32), .SHF_AMNT(3)) s1(.in(vector_out), .shf_val(3'b0), .out(vector_out_shifted));

kogeAdder #(.WIDTH(32)) ad2(.A(IDTR_base_address), .B(vector_out_shifted), .CIN(1'b0), .SUM(IDT_entry_address), .COUT());
kogeAdder #(.WIDTH(32)) ad3(.A(IDT_entry_address), .B(32'h4), .CIN(1'b0), .SUM(IDT_entry_address4), .COUT());
///////////////////////////////
//End Rohan                  //
///////////////////////////////

inv1$ invrag(rrag_stall_n, rrag_stall);
and3$ (endStall_l, valid_wb, P_OP_wb[21], P_OP_wb[22]);
and3$ (endStall_h, valid_wb, P_OP_wb[22], P_OP_wb[23]);
orn #(8) ({MOV_ISHR_2_TEMP_L, MOV_ISHR_2_TEMP_H, MOV_EF_MEM, MOV_EIP_2_TEMP_L, MOV_CS_2_TEMP_H, POP_1, POP_2, POP_3},invalidate_op1_wb );
nor2$ (packet_select,idle_middle, idle);
// or3$ (allow_fetch,idle_middle,idle, rrag_stall_n  );
assign allow_fetch = 1'b1;
assign block_fetch = 1'b0;
wire [63:0] jmp_ie_immediate, jmp_retd_immediate;

assign jmp_ie_immediate = {16'd0, temp_reg_l[31:16], temp_reg_h[31:16], temp_reg_l[15:0]};
assign jmp_retd_immediate = {16'd0, temp_reg_h[15:0], temp_reg_l[31:0]} ;


//Override P_OP for POP EFLAG //TODO:
assign P_OP_1_2_override = MOV_EF_MEM;
or2$ (P_OP_21_22_override, MOV_EIP_2_TEMP_L, MOV_ISHR_2_TEMP_L);
or2$ (P_OP_22_23_override, MOV_CS_2_TEMP_H, MOV_ISHR_2_TEMP_H);


regn #(64)  (OP1_wb, endStall_l, rst, clk, temp_reg_l);
regn #(64)  (OP1_wb, endStall_h, rst, clk, temp_reg_h);
regn #(32)  (eip_WB, is_IE, rst, clk, EIP_store);
regn #(32)  ({16'd0, cs_WB}, is_IE, rst, clk, CS_store);
regn #(32)  (IDT_entry_address, is_IE, rst, clk, IDT_entry_address_final);
regn #(32)  (IDT_entry_address4, is_IE, rst, clk, IDT_entry_address4_final);
regn #(32)  ({14'd0,eflags_EX_old}, is_IE, rst, clk, eflags_store);

//Label States to instructions
wire[16:0] state;
assign idle =               state[0];

//IE States
assign PUSH_EF =            state[1];
assign PUSH_CS =            state[2];
assign PUSH_EIP =           state[3];
assign MOV_ISHR_2_TEMP_L =  state[4];
assign MOV_ISHR_2_TEMP_H =  state[5];
assign nop_wait_1        =  state[6];
assign JMP_IMM =            state[7];

assign idle_middle =        state[8];

//IRETD States
//assign pop_eip_temp_l = state[9]
//assign pop_cs_temp_l = state[10]
//assign pop_eflag     = state[11]
assign MOV_EIP_2_TEMP_L =   state[9];  //Changed to POP
assign MOV_CS_2_TEMP_H  =   state[10]; //Changed to POP
assign MOV_EF_MEM =         state[11]; //Changed to POP
assign POP_1 =              state[12]; //switched to NOP
assign POP_2 =              state[13]; //switched to NOP
assign POP_3 =              state[14]; //switched to NOP
assign nop_wait_2 =         state[15];
assign JMP_TEMP_L_TEMP_H =  state[16];


//Choosing next state logic
//Interrupt/Exception
and2$ a0(state0_in, state[16], rrag_stall_n);
and2$ a1(state1_in, state[0], is_IE );
and2$ a2(state2_in, state[1], rrag_stall_n );
and2$ a3(state3_in, state[2], rrag_stall_n );
and2$ a4(state4_in, state[3], rrag_stall_n );
and2$ a5(state5_in, state[4], rrag_stall_n );
and2$ a6(state6_in, state[5], rrag_stall_n ); //Wait for previous reads
and2$ a7(state7_in, state[6], endStall_h ); //JMP IMM

//IDLE
and2$ a8(state8_in, state[7], rrag_stall_n );

//IRETD
and2$ a9(state9_in,  state[8], is_IRET );
and2$ a10(state10_in, state[9], rrag_stall_n );
and2$ a11(state11_in, state[10], rrag_stall_n );
and2$ a12(state12_in, state[11], rrag_stall_n );
and2$ a13(state13_in, state[12], rrag_stall_n );
and2$ (state14_in, state[13], rrag_stall_n );
and2$ (state15_in, state[14], rrag_stall_n );
and2$ (state16_in, state[15], endStall_h);


//Loading next state Logic
or2$ o0(state0_ld, state0_in, state1_in);
//IE
or2$ o1(state1_ld, state1_in, state2_in);
or2$ o2(state2_ld, state2_in, state3_in);
or2$ o3(state3_ld, state3_in, state4_in);
or2$ o4(state4_ld, state4_in, state5_in);
or2$ o5(state5_ld, state5_in, state6_in);
or2$ o6(state6_ld, state6_in, state7_in);
or2$ o7(state7_ld, state7_in, state8_in);
//IDLE
or2$ o8(state8_ld, state8_in, state9_in);
//IRETD
or2$ o9(state9_ld, state9_in, state10_in);
or2$ o10(state10_ld, state10_in, state11_in);
or2$ o11(state11_ld, state11_in, state12_in);
or2$ o12(state12_ld, state12_in, state13_in);
or2$ o13(state13_ld, state13_in, state14_in);
or2$ o14(state14_ld, state14_in, state15_in);
or2$ o15(state15_ld, state15_in, state16_in);
or2$ o16(state16_ld, state16_in, state0_in);


//STATE Registers
regn #(1) r16 (state16_in, state16_ld, rst, clk, state[16]);
regn #(1) r15 (state15_in, state15_ld, rst, clk, state[15]);
regn #(1) r14 (state14_in, state14_ld, rst, clk, state[14]);
regn #(1) r13 (state13_in, state13_ld, rst, clk, state[13]);
regn #(1) r12 (state12_in, state12_ld, rst, clk, state[12]);
regn #(1) r11 (state11_in, state11_ld, rst, clk, state[11]);
regn #(1) r10 (state10_in, state10_ld, rst, clk, state[10]);
regn #(1) r9 (state9_in,  state9_ld,  rst, clk, state[9]);
regn #(1) r8 (state8_in,  state8_ld,  rst, clk, state[8]);
regn #(1) r7 (state7_in,  state7_ld,  rst, clk, state[7]);
regn #(1) r6 (state6_in,  state6_ld,  rst, clk, state[6]);
regn #(1) r5 (state5_in,  state5_ld,  rst, clk, state[5]);
regn #(1) r4 (state4_in,  state4_ld,  rst, clk, state[4]);
regn #(1) r3 (state3_in,  state3_ld,  rst, clk, state[3]);
regn #(1) r2 (state2_in,  state2_ld,  rst, clk, state[2]);
regn #(1) r1 (state1_in,  state1_ld,  rst, clk, state[1]);
mux2$ g0(.outb(state0_ina), .in0(state[0]), .in1(state0_in), .s0(state0_ld));
dff$ g1(.clk(clk), .d(state0_ina), .q(state[0]), .qbar(), .r(1'b1), .s(rst));

////////////////////////
//Packet Generation   //
////////////////////////
wire [127:0] packet_idle;
assign packet_idle = {8'h90, 120'd0};

//BEGIN IE OPERATIONS
wire [127:0] packet_push_ef;
wire[31:0] eflags_store_endian;
endian_swap32_2 ({eflags_store},  eflags_store_endian);
assign packet_push_ef = {8'h68, eflags_store_endian, 88'd0};

wire [127:0] packet_push_cs;
wire[31:0] CS_store_endian;
endian_swap32_2 ({CS_store}, CS_store_endian);
assign packet_push_cs = {8'h68, CS_store_endian, 88'd0};

wire [127:0] packet_push_eip;
wire[31:0] eip_store_endian;
endian_swap32_2 ({EIP_store},  eip_store_endian);
assign packet_push_eip = {8'h68, eip_store_endian, 88'd0};

wire [127:0] packet_MOV_ISHR_2_TEMP_L;
wire[31:0] IDT_entry_address_final_endian;
endian_swap32_2 ({IDT_entry_address_final},  IDT_entry_address_final_endian);
assign packet_MOV_ISHR_2_TEMP_L = {16'h8b15, IDT_entry_address_final_endian, 80'd0};

wire [127:0] packet_MOV_ISHR_2_TEMP_H;
wire[31:0] IDT_entry_address4_final_endian;
endian_swap32_2 ({IDT_entry_address4_final},  IDT_entry_address4_final_endian);
assign packet_MOV_ISHR_2_TEMP_H = {16'h8b15, IDT_entry_address4_final_endian, 80'd0};

wire [127:0] packet_nop_wait_1;
assign packet_nop_wait_1 = {8'h90, 120'd0};

wire [127:0] packet_jmp_imm;
wire[63:0] jmp_imm_endian;
endian_swap64_2 ({jmp_ie_immediate},  jmp_imm_endian);
assign packet_jmp_imm = {8'hea, jmp_imm_endian, 56'd0};

//END IE OPERATIONS
wire [127:0] packet_idle_middle;
assign packet_idle_middle = {8'h90, 120'd0};

//BEGIN IRET OPERATIONS
wire [127:0] packet_mov_ef_mem;
assign packet_mov_ef_mem = {8'h58, 120'd0};//{32'h8b44_2408, 96'd0};

wire [127:0] packet_MOV_EIP_2_TEMP_L;
assign packet_MOV_EIP_2_TEMP_L = {8'h58, 120'd0};//{24'h8b_0424, 104'd0};

wire [127:0] packet_MOV_EIP_2_TEMP_H;
assign packet_MOV_EIP_2_TEMP_H = {8'h58, 120'd0}; //{24'h8b44_2404, 96'd0};

wire [127:0] packet_pop1;
assign packet_pop1 = {8'h90, 120'd0};

wire [127:0] packet_pop2;
assign packet_pop2 = {8'h90, 120'd0};

wire [127:0] packet_pop3;
assign packet_pop3 = {8'h90, 120'd0};

wire [127:0] packet_nop_wait_2;
assign packet_nop_wait_2 = {8'h90, 120'd0};

wire [127:0] packet_jmp_iret, packet_out_no_stall;
wire[63:0] jmp_iret_endian;
endian_swap64_2 ({jmp_retd_immediate},  jmp_iret_endian);
assign packet_jmp_iret = {8'hea, jmp_iret_endian, 56'd0};

muxnm_tristate #(17, 128) ({packet_jmp_iret,
                            packet_nop_wait_2, 
                            packet_pop3, 
                            packet_pop2, 
                            packet_pop1,
                            packet_MOV_EIP_2_TEMP_H,  
                            packet_MOV_EIP_2_TEMP_L, 
                            packet_mov_ef_mem ,
                            packet_idle_middle, 
                            packet_jmp_imm,
                            packet_nop_wait_1,
                            packet_MOV_ISHR_2_TEMP_H,
                            packet_MOV_ISHR_2_TEMP_L,
                            packet_push_eip, 
                            packet_push_cs,  
                            packet_push_ef, 
                            packet_idle},
                            {JMP_TEMP_L_TEMP_H,
                            nop_wait_2,
                            POP_3,
                            POP_2,
                            POP_1,
                            MOV_CS_2_TEMP_H,
                            MOV_EIP_2_TEMP_L,
                            MOV_EF_MEM,
                            idle_middle,
                            JMP_IMM,
                            nop_wait_1,
                            MOV_ISHR_2_TEMP_H,
                            MOV_ISHR_2_TEMP_L,
                            PUSH_EIP,
                            PUSH_CS,
                            PUSH_EF,
                            idle},
                            packet_out_no_stall);
    mux2n #(128) (packet_out, packet_out_no_stall, {8'h90, 120'd0},rrag_stall);
endmodule 

module endian_swap32_2 (
    input [31:0] in,
    output [31:0] out
);
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule

module endian_swap64_2 (
    input [63:0] in,
    output [63:0] out
);
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24], in[39:32], in[47:40], in[55:48], in[63:56]};

endmodule


