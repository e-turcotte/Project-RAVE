module prot_exception_logic(
    input [159:0] VP, PF,
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

    wire [31:0] read_address_end_size_V;

    //to find address_size in bits, left shift a 1 by address_size 
    lshfn_variable #(.WIDTH(32)) shf(.in(32'b1), .shf({28'b0, address_size}), .shf_val(1'b1), .out(address_size_shifted));
    
    kogeAdder #(.WIDTH(32)) adder0(.SUM(addr_sum1), .COUT(cout0), .A(address_size_shifted), .B(disp_imm), .CIN(1'b0));
    kogeAdder #(.WIDTH(32)) adder1(.SUM(read_address_end_size_V), .COUT(cout1), .A(calc_size), .B(addr_sum1), .CIN(cout0));

    
    //run read_address_end_size through a TLB to get physical read_address_end_size
    wire[7:0] tag_select;
    wire [19:0] entry_P;

    genvar i;
    for(i = 0; i < 8; i = i + 1) begin
        equaln #(20) ahf(VP[i*20 + 19 : i*20], read_address_end_size_V[31:12], tag_select[i]);
    end
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(20)) adgf(.in(PF), .sel(tag_select), .out(entry_P));
    
    orn #(8) asg(.in(tag_select), .out(tlb_valid));

    assign read_address_end_size = {entry_P, read_address_end_size_V[11:0]};


endmodule