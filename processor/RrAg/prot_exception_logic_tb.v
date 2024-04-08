module prot_exception_logic_tb;

    reg [31:0] disp_imm, calc_size;
    reg  [3:0] address_size;
    wire [31:0] read_address_end_size;

localparam cycle_time = 20;

    reg clk;
    initial begin
        clk = 0;
        forever
            #(cycle_time / 2) clk = ~clk;
    end


initial
	begin		
		#(cycle_time)
		disp_imm = 32'hAAAAAAAA;
		calc_size = 32'h11111111;
		address_size = 4'b0001;
		
		#(cycle_time)
		disp_imm = 32'hAAAAAAAA;
		calc_size = 32'h11111111;
		address_size = 4'b1000;
		
		#(cycle_time)
		disp_imm = 32'h0;
		calc_size = 32'hABCDEFEE;
		address_size = 4'b0010;


	end

	always @(posedge clk) begin
		$display("inputs:");
		$display("\t disp_imm = %0h", disp_imm);
		$display("\t calc_size = %0h", calc_size);
		$display("\t address_size = %0b", address_size);

		$display("outputs:");
		$display("\t read_address_end_size= %0h", read_address_end_size);

		$display("---------------------------------------\n");
	end

   // Run simulation for n ns.
   initial #200 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 $vcdplusfile("prot_exception_logic.dump.vpd");
	 $vcdpluson(0, prot_exception_logic_tb); 
      end // initial begin

    prot_exception_logic(.disp_imm(disp_imm), .calc_size(calc_size), .address_size(address_size), 
    			 .read_address_end_size(read_address_end_size));
	

endmodule
