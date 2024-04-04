module twob_sat_tb;

reg in, rst_n, set_n;
wire out;
wire [1:0] S, NS;


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

		//nothing
		in = 0;
		rst_n = 1;
		set_n = 0;

		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
		$display("next state = %0b", NS);

		#(cycle_time)
		in = 1;
		rst_n = 1;
		set_n = 1;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
		in = 1;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
		in = 0;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
	       	in = 1;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
		in = 0;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
		in = 0;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
                in = 1;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

                #(cycle_time)
                in = 0;
		$display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);
		
		#(cycle_time)
                in = 0;
                $display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
                in = 0;
                $display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);
		
		#(cycle_time)
                in = 0;
                $display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);

		#(cycle_time)
                in = 1;
                $display("in = %0d, out = : %0d ", in, out);
		$display("state = %0b", S);
                $display("next state = %0b", NS);
		
		
		$display("end test");
	end

   // Run simulation for n ns.
   initial #500 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("decode_prefix.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("twob_sat.dump.vpd");
	 $vcdpluson(0, twob_sat_tb); 
      end // initial begin


	//sat_counter2b (.in(in), .count(count))
	cnt_sat (.clk(clk), .set_n(set_n), .rst_n(rst_n), .in(in), .out(out), .s_out(S), .ns_out(NS)); 

endmodule
