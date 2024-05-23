module cache_stage1(
    input clk,rst, set,
    input [3:0] cache_id,
    
    input  [31:0] vAddress_in,
    input [14:0] pAddress_in,
    input  r,w,sw,
    input  valid_in1,
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

and2$ valchk(valid_in, valid_in1, rst);

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

or2$ mvswr(smalls, r, sw); //TODO: Possible i$ d$ change
nand4$ mvW(meta_validW, smalls, MSHR_MISS, valid_out,rst);
nand3$ mvR(meta_validR, HIT, valid_out,rst);
nand2$  mvVal(meta_validt, meta_validR, meta_validW);
or2$ plzw(meta_valid, meta_validt, fromBUS);
tagStore ts(.isW(w), .w_unpulsed((~(~writeTag_out & rst))), .PTC(PTC) ,.tagData_out_hit(tag_hit), .valid(valid_in), .clk(clk), .r(r), .V(V), .index(index), .way(way), .tag_in(tag_in), .w(~(~tWrite & rst)), .tag_out(tag_read), .hit(HITS), .tag_dump(tag_dump));
metaStore ms(.clk(clk), .r(r), .rst(rst), .set(set), .valid(meta_valid), .way(way_out), .index(index), .wb(w), .sw(sw), .ex(ex_clr_buf), .ID_IN(PTC_ID_IN), .VALID_out(V), .PTC_out(PTC), .DIRTY_out(D), .LRU(LRU));
wayGeneration wg(.LRU(LRU),.valid_in(valid_in), .TAGS(tag_dump), .PTC(PTC), .V(V), .D(D), .HITS(HITS), .index(index), .w(w), .missMSHR(MSHR_MISS),.valid(valid), .PCD_in(PCD_IN), .ex_wb(ex_wb), .ex_clr(ex_clr), .stall(stall1), .way(way), .D_out(D_sel), .V_out(V_sel), .PTC_out(PTC_sel), .MISS(MISS2));
dff$ d69(.clk(clkn), .d(ex_clr), .q(ex_clr_buf),.qbar(), .r(rst), .s(1'b1));

and2$ aser0(ser1_stall, SER1_FULL, ex_clr);
and2$ aser1(ser0_stall, SER0_FULL, ex_wb);

//Stall generation
and4$ a4(stall1, PTC[0], PTC[1], PTC[2], PTC[3]);
or2$ o1(stall2, ser1_stall, ser0_stall);
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

//and2$ twhope(tWrite, MSHR_MISS, tWrite2); //TODO: MAKE SURE IT DOESNT BREAK ANYTHING

pulseGen pgT(clk, writeTag_out, rst, tWrite);
pulseGen pgD(clk, writeData_out,rst, dWrite);


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