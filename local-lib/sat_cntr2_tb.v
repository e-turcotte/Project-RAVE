module sat_cntr2_tb;

reg in, rst_n, set_n, enable;
wire out;
wire [1:0] S;


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
		enable = 1;
		rst_n = 1;
		set_n = 0;

		$display("\nin = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
		in = 1;
		rst_n = 1;
		set_n = 1;
		enable = 1;

		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
		in = 1;
		enable = 1;
		
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
		in = 0;
		enable = 1;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
	       	in = 1;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
		in = 0;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
		in = 0;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
                in = 1;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

                #(cycle_time)
                in = 0;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
                in = 0;
		enable = 0;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
                in = 0;
		enable = 0;
 		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
                in = 0;
		enable = 1;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);

		#(cycle_time)
                in = 1;
		enable = 1;
		$display("in = %0d", in);
		$display("enable = %0d", enable);
		$display("state = %0b\n", S);
		
		$display("end test");
	end

   // Run simulation for n ns.
   initial #500 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("decode_prefix.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("sat_cntr2.dump.vpd");
	 $vcdpluson(0, sat_cntr2_tb); 
      end // initial begin


	//sat_counter2b (.in(in), .count(count))
	sat_cntr2 (.clk(clk), .set_n(set_n), .rst_n(rst_n), .in(in), .enable(enable), .s_out(S)); 

endmodule
