module tagStore_tb();

reg valid, w;
reg [1:0] index;
reg[7:0] tag_in;
reg[3:0] way;
reg r;

wire[7:0] tag_out;
wire[3:0] hit;
wire[31:0] tag_dump;
reg[3:0] V;
reg clk;
reg set, rst;
localparam CYCLE_TIME = 18.0;
integer i; integer j;

tagStore ts(.clk(clk),.V(V),.valid(valid), .r(r), .index(index), .way(way), .tag_in(tag_in), .w(w), .tag_out(tag_out), .hit(hit), .tag_dump(tag_dump));

initial begin
    r<= 0;
    w<= 0;
    way<= 1;
    #CYCLE_TIME
    valid <= 1;
    r <= 1;
    index = 0;
    tag_in <= 8'ha1;
    #CYCLE_TIME
    valid <= 0;
    V <= 0;
    index <= 0;
    tag_in <= 8'ha0;
    way <= #0 1;
    w <=#2 1;

    

    for(i = 0; i <4; i = i + 1)begin :l1
        for(j = 0; j < 4; j = j + 1)begin : l2
            #(CYCLE_TIME/2)
            valid <= 1;
            index <= i;
            way <= 2**j;
            tag_in <= tag_in + 1;  
             w <= #2  1;
            $display(tag_out);
             #(CYCLE_TIME/2)   
            w <= 0;
        end
    end
    valid = 0;
    #CYCLE_TIME
    valid <= 1;
    r <= 1;
    index = 0;
    tag_in <= 8'ha1;
    #CYCLE_TIME
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
 $vcdplusfile("tagStore.vpd");
 $vcdpluson(0, tagStore_tb); 
end

endmodule