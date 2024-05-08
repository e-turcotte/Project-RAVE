
module F_D_latch (
        input ld, clr,
        input clk,

        input valid_in,
        input [127:0] packet_in,

        output valid_out,
        output [127:0] packet_out
        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("F_D_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1(.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(128)) r2(.din(packet_in), .ld(ld), .clr(clr), .clk(clk), .dout(packet_out));

    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t packet: 0x%h", packet_out);
        
		$fdisplay("\n=================================================\n");    
	end

endmodule