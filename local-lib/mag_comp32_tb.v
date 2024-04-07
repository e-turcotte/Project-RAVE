module mag_comp32_tb;

reg [31:0] A, B;
wire AGB, BGA, EQ;

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
		A = 32'hAAAAAAAA;
		B = 32'h11111111;

		#(cycle_time)
		A = 32'h23454321;
		B = 32'h98766789;

		#(cycle_time)
		A = 32'h44445555;
		B = 32'h44445555;

		#(cycle_time)
		A = 32'hFFFFFFFF;
		B = 32'hFFFFFFFF;

		#(cycle_time)
		A = 32'h11111111;
		B = 32'h11111111;

		#(cycle_time)
		A = 32'h00000000;
		B = 32'h00000000;

		#(cycle_time)
		A = 32'h80000000;
		B = 32'h00000001;

		#(cycle_time)
		A = 32'h40100000;
		B = 32'h00000001;

		#(cycle_time)
		A = 32'h40506070;
		B = 32'h04030201;


		
		$display("end test");
	end

	always @(posedge clk) begin
		$display("inputs:");
		$display("\tA = %0h", A);
		$display("\tB = %0h", B);

		$display("outputs:");
		$display("\tAGB = %0h", AGB);
		$display("\tBGA = %0h", BGA);
		$display("\tEQ = %0h", EQ);


		$display("---------------------------------------\n");
	end

   // Run simulation for n ns.
   initial #250 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("mag_comp32.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("mag_comp32.dump.vpd");
	 $vcdpluson(0, mag_comp32_tb); 
      end // initial begin

	mag_comp32 (.A(A), .B(B), .AGB(AGB), .BGA(BGA), .EQ(EQ));


endmodule
