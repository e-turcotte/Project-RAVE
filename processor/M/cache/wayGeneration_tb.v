module wayGeneration_tb();
localparam CYCLE_TIME = 18.0;
reg clk   ;
reg rst, set;

reg [15:0]LRU;
reg [31:0]TAGS;
reg[3:0] PTC,V, D;
reg[3:0] HITS;
reg[1:0] index;
reg w;
reg missMSHR;
reg valid;
reg PCD_in;
wire ex_wb, ex_clr, stall;
wire[3:0] way;
wire D_out, V_out, PTC_out;
wire MISS;
 integer i; integer j;

wayGeneration wayGen_inst (
    .LRU(LRU),
    .TAGS(TAGS),
    .PTC(PTC),
    .V(V),
    .D(D),
    .HITS(HITS),
    .index(index),
    .w(w),
    .missMSHR(missMSHR),
    .valid(valid),
    .PCD_in(PCD_in),

    .ex_wb(ex_wb),
    .ex_clr(ex_clr),
    .stall(stall),
    .way(way),
    .D_out(D_out),
    .V_out(V_out),
    .PTC_out(PTC_out),
    .MISS(MISS)
);

initial begin
    PCD_in = 0;
    valid = 1;
    missMSHR = 1;
    w = 0;
    index = 2'b00;
    LRU = 16'h8421;
    HITS = 0;PTC = 0; V = 0; D = 0;TAGS = 32'hxxxxxA0;

    for(i = 0 ; i < 4; i = i + 1)begin :wrkplz
        #CYCLE_TIME
        HITS = i;
        
    end


    
    $finish;

end


initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end
// initial begin
//     $readmemh("cache.init", ts.r[0]);
//     $readmemh("cache.init", ts.r[1]);
//     $readmemh("cache.init", ts.r[2]);
//     $readmemh("cache.init", ts.r[3]);
// end
initial begin
 $vcdplusfile("wayGeneration.vpd");
 $vcdpluson(0, wayGeneration_tb); 
end
endmodule
