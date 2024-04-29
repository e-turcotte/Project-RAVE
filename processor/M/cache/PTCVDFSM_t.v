module PTCVDFSM_t();
reg set, rst, clk, sw, extract, wb;
PTCVDFSM p1(clk, set_n, rst_n, sw, extract, wb,enable, PTC, D, V);
localparam CYCLE_TIME = 5.0;

// Dump all waveforms
initial
begin
 $vcdplusfile("PTCVDFSM.vpd");
 $vcdpluson(0, PTCVDFSM_t); 
end


initial begin
rst = 0; set = 1;
enable = 0; sw = 0; wb =0; extract = 0;
#10
rst = 1;
#20

enable = 1;
sw = 1;
#5;
enable = 0;


#10
enable =1 ;
sw = 0;
wb= 1;

#5
extract = 1;
wb = 0;

#5
wb = 1; extract = 0;

#5
sw =1; wb = 0;

#5
wb = 1; sw = 0;

#5
sw = 1;
wb =0;

#5
wb = 1;
sw = 0;

#5
extract = 1; wb = 0;


end

initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end
endmodule