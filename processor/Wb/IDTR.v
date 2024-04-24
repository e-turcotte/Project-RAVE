module IDTR (
    input int_exc, //passed from latches from MEM
    input [3:0] type, //ditto
    input [31:0] IDTR_base_address, //from init
    input [31:0] EIP_WB, 
    input [17:0] EFLAGS_EX, //passed from latches from EX
    output [31:0] IDT_entry, //to send to MEM in WB
);

//type encoding:
    //0000: no stall
    //0001: protection (read_address > seg_max_address), vector = 13
    //0010: page fault (tlb_miss) , vector = 14 (decimal) * 8 
    //0100: div0
    //1000: interrupt

    //todo: implement seg limit checking in FETCH

    //take IDTR and add 8 * vector to it

    wire [31:0] vector_out, protection_vect, page_fault_vect, div0_vect, interrupt_vect;

    assign protection_vect = 32'd13;
    assign page_fault_vect = 32'd14;
    assign div0_vect = 32'd16; //TODO: div0 not specified in spec, so i just put it at 16
    assign interrupt_vect = 32'd15;

    //might have to reverse this order:
    //if sel is 0, breaks trisate mux but output is a don't care
    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(32)) m1(.in({protection_vect, page_fault_vect, div0_vect, interrupt_vect}), .sel(type), .out(vector_out)); 

    kogeAdder #(.WIDTH(32)) a1(.a(IDTR_base_address), .b(vector_out), .sum(IDT_entry));

    //FSM: inject 

endmodule