module ROM_tb();

reg [7:0] addr;

initial
	begin
		//packet should be 16Byte - 0xMMMM MMMM MMMM MMMM MMMM MMMM MMMM MMMM
		#10

		//nothing
		addr = 8'h30;
		#20

		//garbage, REP, garbage
		addr = 8'hFA;
		#20

		//SS seg override, size override, garbage
		addr = 8'hC4;
		#20

		//size override, GS seg override, REP
		addr = 8'hDA;
		#20

		//all garbage/partial matches
		addr = 8'hCE;
		#20

		//REP, seg size override, ES seg override
		addr = 8'h01;
		#20

		addr = 8'h14;
	end


   // Run simulation for n ns.
   initial #150 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("decode_prefix.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("decode_ROM.dump.vpd");
	 $vcdpluson(0, ROM_tb); 
      end // initial begin

      wire [24:0] out;

	single_op_ROM r1(.addr(addr), .data(out));

endmodule
