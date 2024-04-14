module bp_tb;

reg reset, set, prev_BR_result, prev_is_BR;
reg [5:0] prev_BR_alias;
reg [31:0] eip;
wire prediction;
wire [5:0] BP_alias, GBHR;

integer i;


localparam cycle_time = 20;

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
		
		for (i = 0; i < 64; i = i + 1)begin
			#(cycle_time)
			set = 1;
			reset = 0;
			eip = i;
			prev_BR_alias = i;
 			prev_BR_result = 1;
			prev_is_BR = 1;
		end
	
		$display("\n--------------- init complete -------------------\n");

		#(cycle_time)
		reset = 1;
		set = 1;
		eip = 32'h12345678;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hF1E2D3C4;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 0;
		prev_is_BR = 0;

		#(cycle_time)
		eip = 32'hF1E2D999;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 0;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'h11112222;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;


		
		$display("end test");
	end

	reg n;

	always @(posedge clk) begin
	    if (i > 60) begin
		$display("inputs:");
		$display("\tset = %0d", set);
		$display("\treset = %0d", reset);
		$display("\teip = %0h , in bin: %0b", eip, eip);
		$display("\tprev_BR_result = %0d", prev_BR_result);
		$display("\tprev_BR_alias = %0h , in bin: %0b", prev_BR_alias, prev_BR_alias);
		$display("\tprev_is_BR = %0d", prev_is_BR);

		$display("outputs:");
		$display("\tprediction: %0d", prediction);
		$display("\tBP_alias: %0h", BP_alias);
		$display("\tGBHR: %0h", GBHR);
		$display("---------------------------------------\n");
	    end
	    
	end

   // Run simulation for n ns.
   initial #2000 $finish;

   // Dump all waveforms to decode_prefix.dump.vpd
   initial
      begin
	 //$dumpfile ("decode_prefix.dump");
	 //$dumpvars (0, TOP);
	 $vcdplusfile("bp_test.dump.vpd");
	 $vcdpluson(0, bp_tb); 
      end // initial begin

   bp_gshare (.clk(clk), .set(set), .reset(reset), .eip(eip), .prev_BR_result(prev_BR_result), .prev_BR_alias(prev_BR_alias), .prev_is_BR(prev_is_BR), .prediction(prediction), .BP_alias(BP_alias), .GBHR(GBHR));

   //bp_behavioral (.clk(clk), .eip(eip), .prev_BR_result(prev_BR_result), .prev_BR_alias(prev_BR_alias),
   //		   .prev_is_BR(prev_is_BR), .prediction(prediction), .BR_alias(BR_alias_out));


endmodule
