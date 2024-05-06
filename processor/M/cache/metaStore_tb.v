module metaStore_tb();
localparam CYCLE_TIME = 18.0;
reg clk   ;
reg rst, set;
reg valid;
reg[3:0] way;
reg[1:0] index;
reg wb;
reg sw;
reg ex;
reg [6:0] ID_IN;
wire [3:0] VALID_out;
wire [3:0]PTC_out;
wire [3:0]DIRTY_out;
wire [15:0] LRU;
 integer i; integer j;

metaStore ms(.clk(clk), .rst(rst), .set(set), .valid(valid), .way(way), .index(index), .wb(wb), .sw(sw), .ex(ex), .ID_IN(ID_IN), .VALID_out(VALID_out), .PTC_out(PTC_out), .DIRTY_out(DIRTY_out), .LRU(LRU));

initial begin
    rst = 0; set = 1;
    valid = 0;
    way = 8;
    ID_IN = 7'b101011;
    index = 2; wb = 0;
    sw = 0;
    ex = 0;
    #CYCLE_TIME
    rst = 1;
   
#CYCLE_TIME
            valid <= 1;
            
            sw = 1;
            
            #CYCLE_TIME
            sw = 0; wb = 1;

            #CYCLE_TIME
            sw = 0; wb = 0; ex = 1;

            
             #CYCLE_TIME
            sw = 0; wb = 1; ex = 0;

            #CYCLE_TIME
            sw = 1; wb = 0; ex = 0;


            #CYCLE_TIME
            sw = 0; wb = 1; ex = 0;

             #CYCLE_TIME
            sw = 1; wb = 0; ex = 0;

            #CYCLE_TIME
            sw = 1; wb = 0; ex = 0;

            #CYCLE_TIME
            sw = 1; wb = 0; ex = 0;


             #CYCLE_TIME
            sw = 0; wb = 1; ex = 0;
             #CYCLE_TIME
            sw = 0; wb = 0; ex = 1;

    // for(i = 0; i <4; i = i + 1)begin :l1
    //     for(j = 0; j < 4; j = j + 1)begin : l2
        index = 1   ; 
        way = 4;
            #CYCLE_TIME

    way =2;

        #CYCLE_TIME
     way = 1;
        #CYCLE_TIME
     way = 8;
        #CYCLE_TIME
     way = 2;          


            
    //     end
    // end
    valid<=0;
    #CYCLE_TIME
    $finish;
end 


initial begin
    clk = 1'b1;
    forever #(CYCLE_TIME / 2.0) clk = ~clk;
end

initial begin
 $vcdplusfile("metaStore.vpd");
 $vcdpluson(0, metaStore_tb); 
end

endmodule