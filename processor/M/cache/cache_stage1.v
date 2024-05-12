module cache_stage1(
    input clk,rst, set,
    input [2:0] cache_id,
    
    input  [31:0] vAddress_in,
    input [14:0] pAddress_in,
    input  r,w,sw,
    input  valid_in,
    input  fromBUS, 
    input  [6:0] PTC_ID_IN,
    input [16*8-1:0] data_in,
    input [16*8-1:0] mask_in,
    input PCD_IN,

    //FROM MSHR
    input MSHR_FULL,
    input MSHR_MISS,
    input SER0_FULL,
    input SER1_FULL,

    //Outputs
    output[16*8-1:0] cache_line,
    output MISS,
    output ex_clr,
    output ex_wb,
    output HIT,
    output stall,
    output valid_out,

    output [14:0] extAddress

);


wire[1:0] index; wire stall1, stall2, stall3;
wire[16*8*4-1:0] data_dump;

wire stall_n, valid_in_n;
wire[3:0] way, HITS, way_out, PTC, D; 
wire [7:0] tag_in, tag_read, tag_hit,tag_data_read;
wire[31:0] tag_dump; 

wire [15:0] LRU;

wire[3:0] V;
inv1$ invQ(clkn, clk);
inv1$ invS(valn, valid_in);

wire[3:0] index_out;
assign index = pAddress_in[6:5];
assign index_out = index;


assign tag_in = pAddress_in[14:7];

assign extAddress = {tag_read, index,4'b0};


tagStore ts(.isW(w), .PTC(PTC) ,.tagData_out_hit(tag_hit), .valid(valid_in), .clk(clk), .r(r), .V(V), .index(index), .way(way), .tag_in(tag_in), .w(tWrite), .tag_out(tag_read), .hit(HITS), .tag_dump(tag_dump));
metaStore ms(.clk(clk), .r(r), .rst(rst), .set(set), .valid(valid_out), .way(way), .index(index), .wb(w), .sw(sw), .ex(ex_clr), .ID_IN(PTC_ID_IN), .VALID_out(V), .PTC_out(PTC), .DIRTY_out(D), .LRU(LRU));
wayGeneration wg(.LRU(LRU), .TAGS(tag_dump), .PTC(PTC), .V(V), .D(D), .HITS(HITS), .index(index), .w(w), .missMSHR(MSHR_MISS),.valid(valid_in), .PCD_in(PCD_IN), .ex_wb(ex_wb), .ex_clr(ex_clr), .stall(stall1), .way(way), .D_out(D_sel), .V_out(V_sel), .PTC_out(PTC_sel), .MISS(MISS2));


//Stall generation
and4$ a4(stall1, PTC[0], PTC[1], PTC[2], PTC[3]);
or2$ o1(stall2, SER1_FULL, SER0_FULL);
or3$ o2(stall_pos, stall1, stall2, MSHR_FULL);
and2$ a5(stall, stall_pos, MISS);
inv1$ inv2(stalln, stall);

and2$ valGen(valid_dff, stalln, valid_in);

//Generate data write:
inv1$ hit(HIT, MISS);
nor4$ n1(MISS, HITS[0], HITS[1], HITS[2], HITS[3]);
and3$ a1(writeData_p, HIT, w, stalln);
inv1$ invWD(writeData, writeData_p);

//Generate tag write
and2$ wt(writeTag_p, ex_clr, stalln);
inv1$ wtn(writeTag, writeTag_p);

//Send to latches
dff$ d3(.clk(clkn), .d(valid_dff), .q(valid_out),.qbar(), .r(rst), .s(1'b1));

dff$ d1(.clk(clkn), .d(writeTag), .q(writeTag_out), .qbar(), .r(rst), .s(1'b1));
dff$ d2(.clk(clkn), .d(writeData), .q(writeData_out), .qbar(), .r(rst), .s(1'b1));
regn #(4) r1(.din(way), .ld(1'b1), .clr(rst), .clk(clkn), .dout(way_out));
// regn #(8) r2(.din(tag_in), .ld(1'b1), .clr(rst), .clk(clkn), .dout(tag_data_in));
regn #(8) r3(.din(tag_in), .ld(1'b1), .clr(rst), .clk(clkn), .dout(tag_data_read));

pulseGen pgT(clk, writeTag_out, tWrite);
pulseGen pgD(clk, writeData_out, dWrite);


dataStore ds(.clk(clk), 
.valid(valid_out), 
.index(index), 
.way(way_out), 
.data_in(data_in), 
.mask_in(mask_in), 
.w(dWrite), 
.data_out(data_dump),
.cache_line(cache_line) 
 );



endmodule 