module stall_logic(
    input tlb_miss,
    input interrupt_status,
    input [31:0] read_address_size,
    input [20:0] seg_size, //need to zext to 32b
    input [31:0] divisor_operand,
    input instruction_is_div, //need from decode?
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
    wire divisor_is_zero, prot_exception, div0;
    wire nor_1, nor_2;

    assign zero = 32'b0;

    //check for div0
    equaln #(.WIDTH(32)) op_zero_check(.a(zero), .b(divisor_operand), .eq(divisor_is_zero));
    and2$ (.out(div0), .in0(instruction_is_div), .in1(divisor_is_zero));   

    //TODO: is seg_size allowed to be equal to read_address_size

    wire RA_gt_SS, RA_lt_SS;
    mag_comp32 (.A(read_address_size), .B({12'b0, seg_size}), .AGB(prot_exception), .BGA(RA_lt_SS));
    

    //assuming each of the signals are active high:
    or2$ (.out(nor_1), .in0(prot_exception), .in1(tlb_miss));
    or2$ (.out(nor_2), .in0(div0), .in1(interrupt_status));
    or2$ (.out(stall), .in0(nor_1), .in1(nor_2));
    
    assign stall_type[0] = prot_exception;
    assign stall_type[1] = tlb_miss;
    assign stall_type[2] = div0;
    assign stall_type[3] = interrupt_status;

endmodule
