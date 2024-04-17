module btb_tb;

    reg [31:0] EIP_fetch, EIP_WB, FIP_E_WB, FIP_O_WB, target_WB;
    reg LD, flush;

    wire [31:0] FIP_E_target, FIP_O_target, EIP_target;
    wire miss_hit;

    localparam cycle_time = 3.001;

    reg clk;
    initial begin
        clk = 0;
        forever
            #(cycle_time / 2) clk = ~clk;
    end


initial
	begin		
		//initialize
		$display("\n");

		flush = 1'b1;
		LD = 1'b1;

		$display("\n--------------- init complete -------------------\n");
		
		#(cycle_time)
		EIP_fetch = 32'h12345678;
		EIP_WB = 32'h99998888;
    	FIP_E_WB = 32'hAAAAAAA0;
    	FIP_O_WB = 32'hAAAAAAA1;
    	target_WB = 32'hAAAAAAA0;
    	LD = 1'b1;
    	flush = 1'b0;

		#(cycle_time)
		EIP_fetch = 32'h12345679;
		EIP_WB = 32'h99998888;
    	FIP_E_WB = 32'hAAAAAAA0;
    	FIP_O_WB = 32'hAAAAAAA1;
    	target_WB = 32'hAAAAAAA0;
    	LD = 1'b1;
    	flush = 1'b0;

		#(cycle_time)
		EIP_fetch = 32'h1234567A;
		EIP_WB = 32'h12345678;
    	FIP_E_WB = 32'h12345670;
    	FIP_O_WB = 32'h12345671;
    	target_WB = 32'hCCCCCCCC;
    	LD = 1'b1;
    	flush = 1'b0;

		#(cycle_time)
		EIP_fetch = 32'h12345678;
		EIP_WB = 32'h22224444;
    	FIP_E_WB = 32'h22224440;
    	FIP_O_WB = 32'h2222443F;
    	target_WB = 32'h76543210;
    	LD = 1'b1;
    	flush = 1'b0;

	
		$display("end test");
	end

	reg n;

	always @(posedge clk) begin
		$display("inputs:");
		$display("\t EIP_fetch: %h", EIP_fetch);
		$display("\t EIP_WB:    %h", EIP_WB);
		$display("\t FIP_E_WB:  %h", FIP_E_WB);
		$display("\t FIP_O_WB:  %h", FIP_O_WB);
		$display("\t target_WB: %h", target_WB);
		$display("\t LD: 		%h", LD);
		$display("\t flush: 	%h", flush);

		$display("outputs:");
		$display("\t FIP_E_target:  %h", FIP_E_target);
		$display("\t FIP_O_target:  %h", FIP_O_target);
		$display("\t EIP_target: 	%h", EIP_target);
		$display("\t miss/hit: 		%h", miss_hit);

		
		$display("---------------------------------------\n");    
	end

	// Run simulation for n ns.
   	initial #50 $finish;

   	// Dump all waveforms
   	initial
		begin
	 	$vcdplusfile("btb.dump.vpd");
	 	$vcdpluson(0, btb_tb); 
	end

   branch_target_buff (.clk(clk), .EIP_fetch(EIP_fetch), .EIP_WB(EIP_WB), 
						.FIP_E_WB(FIP_E_WB), .FIP_O_WB(FIP_O_WB), 
						.target_WB(target_WB), .LD(LD), .flush(flush),
						.FIP_E_target(FIP_E_target), .FIP_O_target(FIP_O_target), 
						.EIP_target(EIP_target), .miss_hit(miss_hit));


endmodule
