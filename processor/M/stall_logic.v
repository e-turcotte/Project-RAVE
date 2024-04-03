module stall_logic(
    input tlb_miss,
    input interrupt_status,
    input prot_exception,
    input divisor_operand,
    output[3:0] stall_type,
    output stall
);

//onehot encoding for stall_type, from highest pri to lowest pri (i think)
    //0000: no stall
    //0001: protection (read_address > seg_max_address)
    //0010: page fault (tlb_miss)
    //0100: div0
    //1000: interrupt

    wire [31:0] zero;
    wire divisor_is_zero;
    wire nor_1, nor_2;

    assign zero = 32'b0;

    equaln #(.WIDTH(32)) op_zero_check(.a(zero), .b(divisor_operand), .eq(divisor_is_zero));    

    //assuming each of the signals are active high:
    nor2$ (.out(nor_1), .in0(prot_exception), .in1(tlb_miss));
    nor2$ (.out(nor_2), .in0(divisor_is_zero), .in1(interrupt_status));
    
    assign stall_type[0] = prot_exception;
    assign stall_type[1] = tlb_miss;
    assign stall_type[2] = divisor_is_zero;
    assign stall_type[3] = interrupt_status;

endmodule