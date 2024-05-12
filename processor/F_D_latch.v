
module F_D_latch (
        input ld, clr,
        input clk,

        input valid_in,
        input [127:0] packet_in,
        input [5:0] BP_alias_in,
        input IE_in,
        input [3:0] IE_type_in,
        input [31:0] BR_pred_target_in,
        input BR_pred_T_NT_in,

        output valid_out,
        output [127:0] packet_out
        output [5:0] BP_alias_out
        output IE_out,
        output [3:0] IE_type_out,
        output [31:0] BR_pred_target_out,
        output BR_pred_T_NT_out,
        );
    
    integer file, cyc_cnt;
    initial begin
        file = $fopen("F_D_latch.out", "w");
        cyc_cnt = 0;
    end

    regn #(.WIDTH(1))   r1(.din(valid_in), .ld(ld), .clr(clr), .clk(clk), .dout(valid_out));
    regn #(.WIDTH(128)) r2(.din(packet_in), .ld(ld), .clr(clr), .clk(clk), .dout(packet_out));
    regn #(.WIDTH(6))   r3(.din(BP_alias_in), .ld(ld), .clr(clr), .clk(clk), .dout(BP_alias_out));
    regn #(.WIDTH(1))   r4(.din(IE_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_out));
    regn #(.WIDTH(4))   r5(.din(IE_type_in), .ld(ld), .clr(clr), .clk(clk), .dout(IE_type_out));
    regn #(.WIDTH(32))  r6(.din(BR_pred_target_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_target_out));
    regn #(.WIDTH(1))   r7(.din(BR_pred_T_NT_in), .ld(ld), .clr(clr), .clk(clk), .dout(BR_pred_T_NT_out));


    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;
        
		$fdisplay(file, "\n=============== RrAg to MEM Latch Values ===============\n");
 
        $fdisplay(file, "\t\t valid: %b", valid_out);
        $fdisplay(file, "\t\t packet: 0x%h", packet_out);
        $fdisplay(file, "\t\t BP_alias: %b", BP_alias_out);
        $fdisplay(file, "\t\t IE: %b", IE_out);
        $fdisplay(file, "\t\t IE_type: %b", IE_type_out);
        $fdisplay(file, "\t\t BR_pred_target: 0x%h", BR_pred_target_out);
        $fdisplay(file, "\t\t BR_pred_T_NT: %b", BR_pred_T_NT_out);
                
		$fdisplay("\n=================================================\n");    
	end

endmodule