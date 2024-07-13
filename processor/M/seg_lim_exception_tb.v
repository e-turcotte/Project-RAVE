module IE_logic_tb;

    reg tlb_miss, interrupt_status, instruction_is_div;
    reg [31:0] read_address_size, divisor_operand;
    reg [20:0] seg_size;
    wire [3:0] IE_type;
    wire IE;

localparam cycle_time = 20;

    reg clk;
    initial begin
        clk = 0;
        forever
            #(cycle_time / 2) clk = ~clk;
    end


initial
	begin		
		//expected: prot
		#(cycle_time)
		read_address_size = 32'hAAAAAAAA;
		seg_size = 20'h11111;
		tlb_miss = 0;
		interrupt_status = 0;
		divisor_operand = 32'h1;
		instruction_is_div = 0;
		
		//expected: none
		#(cycle_time)
		read_address_size = 32'h00054321;
		seg_size = 20'hDE4FF;
		tlb_miss = 0;
		interrupt_status = 0;
		divisor_operand = 32'h0;
		instruction_is_div = 0;

		//expected: tlb miss
		#(cycle_time)
		read_address_size = 32'h00054321;
		seg_size = 20'hDE4FF;
		tlb_miss = 1;
		interrupt_status = 0;
		divisor_operand = 32'h0;
		instruction_is_div = 0;

		//expected: div0 and tlb miss
		#(cycle_time)
		read_address_size = 32'h00054321;
		seg_size = 20'hDE4FF;
		tlb_miss = 1;
		interrupt_status = 0;
		divisor_operand = 32'h0;
		instruction_is_div = 1;

		//expected: none
		#(cycle_time)
		read_address_size = 32'h00054321;
		seg_size = 20'hDE4FF;
		tlb_miss = 0;
		interrupt_status = 0;
		divisor_operand = 32'h1;
		instruction_is_div = 1;

		//expected: interrupt
		#(cycle_time)
		read_address_size = 32'h00054321;
		seg_size = 20'hDE4FF;
		tlb_miss = 0;
		interrupt_status = 1;
		divisor_operand = 32'h0;
		instruction_is_div = 0;
	end

	always @(posedge clk) begin
		$display("inputs:");
		$display("\t tlb_miss = %0h", tlb_miss);
		$display("\t interrupt_status = %0h", interrupt_status);
		$display("\t read_address_size = %0h", read_address_size);
		$display("\t seg_size = %0h", seg_size);
		$display("\t divisor_operand = %0h",  divisor_operand);
		$display("\t instruction_is_div = %0h", instruction_is_div);

		$display("outputs:");
		$display("\tIE_type= %0h", IE_type);
		$display("\tIE = %0h", IE);

		$display("---------------------------------------\n");
	end

   // Run simulation for n ns.
   initial #200 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 $vcdplusfile("IE_logic.dump.vpd");
	 $vcdpluson(0, IE_logic_tb); 
      end // initial begin

	
	IE_logic (.tlb_miss(tlb_miss), .interrupt_status(interrupt_status), .read_address_size(read_address_size),
		     .seg_size(seg_size), .divisor_operand(divisor_operand), .instruction_is_div(instruction_is_div),
		     .IE_type(IE_type), .IE(IE));
endmodule
