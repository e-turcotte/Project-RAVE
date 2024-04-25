module ptc_generator (input next, clr,
                      input clk,
                      output [6:0] ptcid);

    wire [6:0] next_ptcid;

    regn #(.WIDTH(7)) ptcgen(.din(next_ptcid), .ld(next), .clr(clr), .clk(clk), .dout(ptcid));
    kogeAdder #(.WIDTH(7)) a0(.SUM(next_ptcid), .COUT(), .A(ptcid), .B(7'b0000001), .CIN(1'b0));

endmodule