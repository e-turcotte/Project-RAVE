module IDTR_FSM (
    input IE_in, //interrupt or exception from WB
    input [3:0] IE_type_in, 
    input [31:0] IDTR_base_address, //from init
    input [31:0] EIP_WB,
    input [16:0] EFLAGS_WB,
    input [15:0] CS_WB,
    input is_IRETD_WB,

);

//type encoding:
    //0000: no stall
    //0001: protection (read_address > seg_max_address), vector = 13
    //0010: page fault (tlb_miss) , vector = 14 (decimal) * 8 
    //0100: div0
    //1000: interrupt

    //todo: implement seg limit checking in FETCH

    //take IDTR and add 8 * vector to it

    wire [31:0] protection_vect, page_fault_vect, div0_vect, interrupt_vect;
    wire [31:0] vector_out, vector_out_shifted, IDT_entry_address;

    assign protection_vect = 32'd13;
    assign page_fault_vect = 32'd14;
    assign div0_vect = 32'd16; //TODO: div0 not specified in spec, so i just put it at 16
    assign interrupt_vect = 32'd15;

    //might have to reverse this order:
    //if sel is 0, breaks trisate mux but output is a don't care
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m1(.in({protection_vect, page_fault_vect, div0_vect, interrupt_vect}), .sel(type), .out(vector_out)); 

    lshfn_fixed #(.WIDTH(32), SHF_AMNT(3)) s1(.in(vector_out), .shf_val(2'b0), .out(vector_out_shifted));

    kogeAdder #(.WIDTH(32)) a1(.a(IDTR_base_address), .b(vector_out_shifted), .sum(IDT_entry_address));

    //FSM: inject 

endmodule