module prot_exception_logic(
    input [31:0] disp_imm,
    input [31:0] calc_size, //from reg file adder
    input address_size, //how encoded?
    output [31:0] read_address_end_size
);

    //if disp_imm > seg_size, then it is a protection exception
    
    //here, just generating the read_address_size signal
    //then doing the comparison in MEM
    //so we are passing to MEM: read_address_size and seg_size

    wire cout;
    //add size of read address to disp_imm to get the ending address, not starting address,
    // then do the add with calc_size

    //kogeAdder ---------
    kogeAdder #(.WIDTH(32)) adder(.SUM(read_address_end_size), .COUT(cout), .A(calc_size), .B(disp_imm), .CIN(1'b0));

endmodule