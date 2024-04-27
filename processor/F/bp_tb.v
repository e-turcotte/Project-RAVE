module bp_tb;

reg reset, prev_BR_result, prev_is_BR, LD;
reg [5:0] prev_BR_alias;
reg [31:0] eip;
wire prediction;
wire [5:0] BP_alias, GBHR;

integer i;


localparam cycle_time = 2;

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
		//for (i = 0; i < 64; i = i + 1) begin
			i = 0;
			#(cycle_time)
			reset = 0;
			eip = i;
			prev_BR_alias = i;
 			prev_BR_result = 1;
			prev_is_BR = 1;
			LD = 1;
		//end
		$display("\n--------------- init complete -------------------\n");

		#(cycle_time)
		reset = 1;
		eip = 32'h12345678;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hF1E2D3C4;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 0;
		prev_is_BR = 0;
		LD = 1;

		#(cycle_time)
		eip = 32'hF1E2D999;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 0;
		prev_is_BR = 1;
		LD = 1;		

		#(cycle_time)
		eip = 32'h11112222;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias =  BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		#(cycle_time)
		eip = 32'hA1884294;
		prev_BR_alias = BP_alias;
 		prev_BR_result = 1;
		prev_is_BR = 1;
		LD = 1;

		
		$display("end test");
	end

	reg n;

	always @(posedge clk) begin

		$display("inputs:");
		$display("\t reset = %0d", reset);
		$display("\t eip = %0h , in bin: %0b", eip, eip);
		$display("\t prev_BR_result = %0d", prev_BR_result);
		$display("\t prev_BR_alias = %0h , in bin: %0b", prev_BR_alias, prev_BR_alias);
		$display("\t prev_is_BR = %0d", prev_is_BR);
		$display("\t LD = %0d", LD);

		$display("outputs:");
		$display("\tprediction: %0d", prediction);
		$display("\tBP_alias: %0h", BP_alias);
		$display("---------------------------------------\n");
	    
	end

   // Run simulation for n ns.
   initial #100 $finish;

   initial
      begin
	 $vcdplusfile("bp_test.dump.vpd");
	 $vcdpluson(0, bp_tb); 
      end

   bp_gshare bp(.clk(clk), .reset(reset), .eip(eip), .prev_BR_result(prev_BR_result), 
			  .prev_BR_alias(prev_BR_alias), .prev_is_BR(prev_is_BR), .LD(LD), 
			  .prediction(prediction), .BP_alias(BP_alias));

endmodule
