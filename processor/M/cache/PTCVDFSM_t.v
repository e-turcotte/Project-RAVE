module PTCVDFSM_t();
reg set,enable, rst, clk, sw, extract, wb;
PTCVDFSM p1(clk, set, rst, sw, extract, wb,enable, PTC, D, V);


// Dump all waveforms



initial begin
rst = 0; set = 1;
enable = 0; sw = 0; wb =0; extract = 0;
#10
rst = 1;
#17.5

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

#30
$finish;
end

localparam CYCLE_TIME = 5.0;

initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
 $vcdplusfile("PTCVDFSM.vpd");
 $vcdpluson(0, PTCVDFSM_t); 
end
endmodule