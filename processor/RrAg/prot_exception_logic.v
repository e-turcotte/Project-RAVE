module prot_exception_logic(
    input [31:0] disp_imm,
    input [31:0] calc_size, //from reg file adder
    input [3:0] address_size, //should be onehot as shown below
    output [31:0] read_address_end_size
);

    //assuming address_size is encoded as follows:
    //0001: 1 byte
    //0010: 2 bytes
    //0100: 4 bytes
    //1000: 8 bytes

    //if disp_imm + calc_size + 2^address_size > seg_size, then it is a protection exception
    //add size of read address to disp_imm to get the ending address, not starting address,
    // then do the add with calc_size

    wire cout0, cout1;
    wire [31:0] address_size_shifted, addr_sum1;

    //to find address_size in bits, left shift a 1 by address_size 
    lshfn_variable #(.WIDTH(32)) shf(.in(32'b1), .shf({28'b0, address_size}), .shf_val(1'b1), .out(address_size_shifted));
    
    kogeAdder #(.WIDTH(32)) adder0(.SUM(addr_sum1), .COUT(cout0), .A(address_size_shifted), .B(disp_imm), .CIN(1'b0));
    kogeAdder #(.WIDTH(32)) adder1(.SUM(read_address_end_size), .COUT(cout1), .A(calc_size), .B(addr_sum1), .CIN(cout0));


   

endmodule