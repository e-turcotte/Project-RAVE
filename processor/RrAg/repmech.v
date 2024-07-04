module repmech(input [31:0] mem1, mem2,
               input [31:0] creg,
               input is_rep,
               input [1:0] opsize,
               input pop4, pop5,
               input valid, no_other_stall,
               input rstdflag, rstdflagval,
               input clr,
               input clk,
               output [31:0] mem_addr1, mem_addr2,
               output rep_stall);

    wire invpop4, clrdflag, setdflag, newdflagval;
    wire dflag;
    wire [31:0] incdec;

    inv1$ g0(.out(invpop4), .in(pop4));
    and2$ g1(.out(clrdflag), .in0(invpop4), .in1(clr));
    or2$ g2(.out(setdflag), .in0(pop5), .in1(rstdflag));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(1)) m0(.in({rstdflagval,1'b1}), .sel(rstdflag), .out(newdflagval));
    regn #(.WIDTH(1)) r0(.din(newdflagval), .ld(setdflag), .clr(clrdflag), .clk(clk), .dout(dflag));
    muxnm_tree #(.SEL_WIDTH(3), .DATA_WIDTH(32)) m1(.in({32'h0000_0000,32'hffff_fffc,32'hffff_fffe,32'hffff_ffff,
                                                         32'h0000_0000,32'h0000_0004,32'h0000_0002,32'h0000_0001}), .sel({dflag,opsize}), .out(incdec));
    
    wire [31:0] cnt, nextcnt, regcnt;
    wire cntnotzero;
    wire userepaddr;

    regn #(.WIDTH(1)) r1(.din(is_rep), .ld(valid), .clr(clr), .clk(clk), .dout(regis_rep));
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m2(.in({regcnt,creg}), .sel(regis_rep), .out(cnt));
    kogeAdder #(.WIDTH(32)) add0(.SUM(nextcnt), .COUT(), .A(cnt), .B(32'hffff_ffff), .CIN(1'b0));
    regn #(.WIDTH(32)) r2(.din(nextcnt), .ld(no_other_stall), .clr(clr), .clk(clk), .dout(regcnt));
    orn #(.NUM_INPUTS(32)) g3(.in(nextcnt), .out(cntnotzero));
    and3$ g4(.out(rep_stall), .in0(cntnotzero), .in1(is_rep), .in2(valid));
    and2$ g5(.out(userepaddr), .in0(regis_rep), .in1(rep_stall));

    wire [31:0] nextmem1, regmem1;
    wire [31:0] nextmem2, regmem2;
    
    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m3(.in({regmem1,mem1}), .sel(userepaddr), .out(mem_addr1));
    kogeAdder #(.WIDTH(32)) add1(.SUM(nextmem1), .COUT(), .A(mem_addr1), .B(incdec), .CIN(1'b0));
    regn #(.WIDTH(32)) r3(.din(nextmem1), .ld(no_other_stall), .clr(clr), .clk(clk), .dout(regmem1));

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(32)) m4(.in({regmem2,mem2}), .sel(userepaddr), .out(mem_addr2));
    kogeAdder #(.WIDTH(32)) add2(.SUM(nextmem2), .COUT(), .A(mem_addr2), .B(incdec), .CIN(1'b0));
    regn #(.WIDTH(32)) r4(.din(nextmem2), .ld(no_other_stall), .clr(clr), .clk(clk), .dout(regmem2));

endmodule