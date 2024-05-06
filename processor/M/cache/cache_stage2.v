module cache_stage2(
    input clk,
    input [1:0] index_in
    input [7:0] tag_data_read,
    input [7:0] tag_data_in,
    input [16*8-1:0] data_in,
    input [16*8-1:0] mask_in,

    //inputut writeTag_out,
    input dWrite,
    input [3:0] way_in,
    input MISS,
    input valid_in,

  

  
);

wire[16*8*4 -1 :0] data_dump;
dataStore ds(.clk(clk), 
.valid(valid_in), 
.index(index_in), 
.way(way_in), 
.data_in(data_in), 
.mask_in(mask), 
.w(dWrite), .
data_out(data_dump),
 .cache_line(cache_line) );

/////////////////////////////////////////////

endmodule