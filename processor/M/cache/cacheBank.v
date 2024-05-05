module cacheBank (
    input clk,
    input rst, set,
    input [2:0] cache_id,
    //Input from AQ
    input  [31:0] vAddress,
    input [14:0] pAddress,
    input [16*8-1:0] data,
    input  [1:0] size,
    input  r,w,sw,
    input  valid_in,
    input  fromBUS, 
    input  [16*8-1:0] mask,
    input  AQ_isEMPTY,
    input  [6:0] PTC_ID_IN,
    input oddIsGreater_in,
    input needP1_in,
    input [2:0] oneSize,
    
    //INPUT from MSHR
    input MSHR_HIT,
    input MSHR_FULL,

    //INPUT from SERDES
    input SER1_FULL,
    input SER0_FULL,
    input PCD_IN,

    //output to AQ
    output AQ_READ,

    //output to MSHR
    output MSHR_valid,
    output [14:0] MSHR_pAddress,
    
    //output to SERDES
    //SER0 only for extracts, not reads
    output SER_valid0,
    output[16*8-1:0] SER_data0,
    output[14:0] SER_pAddress0,
    output[2:0] SER_return0,
    output[15:0] SER_size0,
    output SER_rw0,
    output [2:0] SER_dest0,

    //SER1 only used for reads, not extracts
    output SER_valid1,
    output[14:0] SER_pAddress1,
    output[2:0] SER_return1,
    output[15:0] SER_size1,
    output SER_rw1,
    output SER_dest1,

    

    //Output to outputAlign (data converted to 64 bits there)
    output EX_valid,
    output [16*8-1:0] EX_data,
    output [31:0] EX_vAddress,
    output [14:0] EX_pAddress,
    output [1:0] EX_size,
    output EX_wake,
    output oddIsGreater,

    output cache_stall,
    output cache_miss,
    output needP1,
    output [2:0]oneSize_out

);
assign oneSize_out = oneSize;

//IO DETECTION
wire[1:0] index; wire[3:0] offset; wire stall1, stall2, stall3;
wire[16*8*4-1:0] data_dump;
wire[16*8-1:0] cache_line;
wire stall_n, valid_in_n, extract;
wire[3:0] way, HITS; 
wire [7:0] tag_in, tag_read;
wire[31:0] tag_dump; 
wire ex_clr, ex_wb, MISS;
inv1$ inv2(MSHR_MISS,MSHR_HIT);

inv1$ inv1(valid_in_n, valid_in);
wire valid;
nor3$ nor1(valid, valid_in_n,stall, AQ_isEMPTY);
assign AQ_READ = valid;


assign offset = pAddress[3:0];
assign index = pAddress[6:5];
assign tag_in = pAddress[14:7];
assign oddIsGreater = oddIsGreater_in;
assign cache_stall = stall;
assign cache_miss = MISS;
assign needP1 = needP1_in;

wire[3:0] V, D, PTC;
wire[15:0] LRU;
wire D_sel, V_sel, PTC_sel;

tagStore ts(.valid(valid_in), .clk(clk), .r(r), .V(V), .index(index), .way(way), .tag_in(tag_in), .w(ex_clr), .tag_out(tag_read), .hit(HITS), .tag_dump(tag_dump));
dataStore ds(.clk(clk), .valid(valid), .index(index), .way(way), .data_in(data), .mask_in(mask), .w(w), .data_out(data_dump), .cache_line(cache_line) );
metaStore ms(.clk(clk), .rst(rst), .set(set), .valid(valid_in), .way(way), .index(index), .wb(w), .sw(sw), .ex(ex_clr), .ID_IN(PTC_ID_IN), .VALID_out(V), .PTC_out(PTC), .DIRTY_out(D), .LRU(LRU));
wayGeneration wg(.LRU(LRU), .TAGS(tag_dump), .PTC(PTC), .V(V), .D(D), .HITS(HITS), .index(index), .w(w), .missMSHR(MSHR_MISS),.valid(valid), .PCD_in(PCD_IN), .ex_wb(ex_wb), .ex_clr(ex_clr), .stall(stall1), .way(way), .D_out(D_sel), .V_out(V_sel), .PTC_out(PTC_sel), .MISS(MISS));

//stall logic
inv1$ inv(stall1_n, stall1);
nand3$ a1(stall2, SER1_FULL,SER0_FULL, MISS);
nand2$ a2(stall3, MSHR_FULL, MISS);
nand3$ or1(stall, stall1_n, stall2, stall3);

//Handle MSHR
and2$ an1(MSHR_valid1, valid, MISS);
or2$ mshr(MSHR_valid,MSHR_valid1, checkVal);
assign MSHR_pAddress = pAddress;

//Handle SERDES
mux2n #(128) datasel(SER_data0, cache_line, data, PCD_IN);
mux2n #(15) addressSel(SER_pAddress0, {tag_read, pAddress[6:0]}, pAddress[14:0], PCD_IN);
or2$ orSER(SER_valid0, ex_wb, checkVal);
inv1$ inv123(w_not, w);
and2$ andwp(checkVal, PCD_IN, w_not);
assign SER_return0 = cache_id;
assign SER_size0 = 16'h8000;
mux2n #(1)  cba(SER_rw0, 1'b1, w, PCD_IN);
mux2n #(3)  abc(SER_dest0,{1'b0,pAddress[5],pAddress[4]}, 3'b110, PCD_IN);

assign SER_pAddress1 = {pAddress[14:0]};
assign SER_valid1 = ex_clr;
and2$ andSER(SER_valid1, ex_clr, w_not);
assign SER_return1 = cache_id;
assign SER_size1 = 16'h0001;
assign SER_rw1 = 1'b0;
assign SER_dest1 = {1'b0,pAddress[5],pAddress[4]};

//Handle outputAlign
inv1$ in12(HIT, MISS);
assign EX_valid = valid; 
assign EX_data = cache_line;
assign EX_vAddress = vAddress;
assign EX_pAddress = pAddress;
assign EX_size = size;
assign EX_wake = HIT;

endmodule