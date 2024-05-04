module prefix_tb;

reg [127:0] packet;

initial
	begin
		//packet should be 16Byte - 0xMMMM MMMM MMMM MMMM MMMM MMMM MMMM MMMM
		#10

		//nothing
		packet = 128'h00000000000000000000000000000000;
		#20

		//garbage, REP, garbage
		packet = 128'hABF34600000000000000000000000000;
		#20

		//SS seg override, size override, garbage
		packet = 128'h3666AB00000000000000000000000000;
		#20

		//size override, GS seg override, REP
		packet = 128'h6665F300000000000000000000000000;
		#20

		//all garbage/partial matches
		packet = 128'h6AFBE200000000000000000000000000;
		#20

		//REP, seg size override, ES seg override
		packet = 128'hF3662600000000000000000000000000;
		#20

		packet = 128'h0;
	end


   // Run simulation for n ns.
   initial #150 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("decode_prefix.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("decode_prefix.dump.vpd");
	 $vcdpluson(0, prefix_tb); 
      end // initial begin

      wire is_rep, is_seg_override, is_opsize_override;
      wire [5:0] seg_override;
      wire [1:0] num_prefixes_encoded;
	  wire [3:0] num_prefixes_onehot;

	prefix_d pd(.prefix1(packet[127:120]), .prefix2(packet[119:112]), .prefix3(packet[111:104]), 
			 .is_rep(is_rep), .seg_override(seg_override), .is_seg_override(is_seg_override),
			 .is_opsize_override(is_opsize_override), .num_prefixes_encoded(num_prefixes_encoded),
			 .num_prefixes_onehot(num_prefixes_onehot));

endmodule
