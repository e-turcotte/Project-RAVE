module cacheBank (
    input prefetch,
    input clk,
    input rst, set,
    input [3:0] cache_id,
    input ptc_clear,

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
    output MSHR_alloc,
    output MSHR_dealloc,
    output MSHR_rdsw,
    output [14:0] MSHR_pAddress,
    output [6:0] MSHR_ptcid,

    output MSHR_alloc_io,
    output MSHR_dealloc_io,
    output MSHR_rdsw_io,
    output [14:0] MSHR_pAddress_io,
    output [6:0] MSHR_ptcid_io,


    //output to SERDES
    //SER0 only for extracts, not reads
    output SER_valid0,
    output[16*8-1:0] SER_data0,
    output[14:0] SER_pAddress0,
    output[3:0] SER_return0,
    output[15:0] SER_size0,
    output SER_rw0,
    output [3:0] SER_dest0,

    //SER1 only used for reads, not extracts
    output SER_valid1,
    output[14:0] SER_pAddress1,
    output[3:0] SER_return1,
    output[15:0] SER_size1,
    output SER_rw1,
    output [3:0] SER_dest1,

    

    //Output to outputAlign (data converted to 64 bits there)
    output EX_valid,
    output [16*8-1:0] EX_data,
    output [31:0] EX_vAddress,
    output [14:0] EX_pAddress,
    output [1:0] EX_size,
    output [1:0] EX_wake,
    output oddIsGreater,

    output cache_stall,
    output cache_miss,
    output needP1,
    output [2:0]oneSize_out,

    output [6:0]PTC_ID_out

);
assign PTC_ID_out = PTC_ID_IN;
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
inv1$ inv1(stall_n, stall);
inv1$ inv12(valid_in_n, valid_in);
wire valid;
//nor3$ nor1(valid, valid_in_n,stall, AQ_isEMPTY);
assign AQ_READ = valid;

wire stall;
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

inv1$ invx(clkn, clk);

wire[14:0] extAddress;
cache_stage1 cs1(.clk(clk), 
.rst(rst),
 .set(set), 
 .cache_id(cache_id), 
 .ptc_clear(ptc_clear),
 .vAddress_in(vAddress),
  .pAddress_in(pAddress),
  .r(r), 
  .w(w), 
  .sw(sw),
  .valid_in1(valid_in),
  .fromBUS(fromBUS),
  .PTC_ID_IN(PTC_ID_IN),
  .data_in(data),
  .mask_in(mask),
  .MSHR_MISS(MSHR_MISS),
  .SER0_FULL(SER0_FULL),
  .SER1_FULL(SER1_FULL),
  .cache_line(cache_line),
  .MSHR_FULL(MSHR_FULL),
  .MISS(MISS),
  .ex_clr(ex_clr),
  .ex_wb(ex_wb), 
  .HIT(HIT),
  .stall(stall),
  .valid_out(valid),
  .extAddress(extAddress),
  .PCD_IN(PCD_IN),
  .ex_wb_light(ex_wb_light)
  );
inv1$ (ex_clr_n, ex_clr);
inv1$ (ex_wb_n, ex_wb);
inv1$ (SER_0FULL_n, SER0_FULL);
inv1$ (SER_1FULL_n, SER1_FULL);

nand2$ (clr_sr1f, ex_clr, SER_1FULL_n);
nand2$ (ser1_stall_1, clr_sr1f, ex_clr_n);

nand2$ (clr_sr2f, ex_wb, SER_0FULL_n);
nand2$ (ser1_stall_2, clr_sr2f, ex_wb_n);
inv1$ (clk_n, clk);

inv1$ (PCD_IN_n, PCD_IN);
inv1$ (fromBUS_n, fromBUS);
inv1$ (stall_n, stall);
//Handle MSHR
inv1$ msn(MSHR_MISS, MSHR_HIT);
assign MSHR_pAddress = pAddress;
nand2$ (ex_clr_check, MISS, SER1_FULL);
nand2$ (ex_wb_check, ex_wb_light, SER0_FULL);
and4$ msh(MSHR_alloc_noser, valid_in, rst, MISS, MSHR_MISS); //TODO: was and2$ msh(MSHR_alloc, valid, MISS, MSHR_MISS);  not really sure if I fixed this correctly
// and4$ mshs(MSHR_alloc,PCD_IN_n, MSHR_alloc_noser, ser1_stall_2, ser1_stall_1);
and4$ mshs(MSHR_alloc,PCD_IN_n, MSHR_alloc_noser, ex_clr_check,  ex_wb_check);

assign MSHR_rdsw = sw;
and3$ mshD(MSHR_dealloc, valid_in, fromBUS, PCD_IN_n );
assign MSHR_ptcid = PTC_ID_IN;

//Handle MSHR_io
assign MSHR_pAddress_io = pAddress;
and4$ mshas(MSHR_alloc_noser_io, valid_in, rst, MISS, PCD_R); //TODO: was and2$ msh(MSHR_alloc, valid, MISS, MSHR_MISS);  not really sure if I fixed this correctly
and4$ mshsas(MSHR_alloc_io, r, MSHR_alloc_noser_io,  ex_clr_check, ex_wb_check);
assign MSHR_rdsw_io = sw;
and3$ mshDas(MSHR_dealloc_io, valid_in, fromBUS, PCD_IN);
assign MSHR_ptcid = PTC_ID_IN;


//Handle SERDES
and2$ (PCD_W, PCD_IN, w);
nand3$ (serval0_1, MISS, ex_wb_light, helper_for_Ser1);
and3$ help(helper_for_Ser1, MSHR_MISS, valid_in, stall_n);
mux2n #(128) datasel(SER_data0, cache_line, data, PCD_IN);
 mux2n #(15) addressSel(SER_pAddress0, extAddress, pAddress[14:0], PCD_IN);
nand2$ orSER(SER_valid0, serval0_1, serval0_2);
// and2$ plzwrkrkas(SER_valid0, SER_valid0a, clk_n);
inv1$ inv123(w_not, w);
 nand4$ andwp(serval0_2, PCD_W,  fromBUS_n, valid_in, stall_n);
assign SER_return0 = cache_id;
assign SER_size0 = 16'h8000;
mux2n #(1)  cba(SER_rw0, 1'b1, w, PCD_IN);
mux2n #(4)  abc(SER_dest0,{2'b10,pAddress[5],pAddress[4]}, 4'b1100, PCD_IN);


and2$ (PCD_R, PCD_IN, r);
and2$ (rst_val, rst, valid_in );
assign SER_pAddress1 = {pAddress[14:0]};
//assign SER_valid1 = ex_clr;
nand3$ andSER(SER_valid11, MISS, stall_n,SERvalid11a);
and4$ fixSERplz(SERvalid11a,w_not, rst, MSHR_MISS, valid_in );
nand4$ andser1(SER_valid12, w_not, PCD_R,rst_val, stall_n);
nand2$ andSER21(SER_valid1, SER_valid11, SER_valid12);
// and2$ plzwrkrk(SER_valid1, SER_valid1a, clk_n);
assign SER_return1 = cache_id;
assign SER_size1 = 16'h1000;
assign SER_rw1 = 1'b0;
mux2n #(4)  abcde(SER_dest1,{2'b10,pAddress[5],pAddress[4]}, 4'b1100, PCD_IN);


//Handle outputAlign
// assign EX_valid = valid; 
and2$ (EX_valid_temp, valid, HIT);
mux2$ (EX_valid, EX_valid_temp, 1'b0, prefetch);
assign EX_data = cache_line;
 assign EX_vAddress = vAddress;
assign EX_pAddress = pAddress;
assign EX_size = size;
wire [1:0] EX_wake2;

mux2n #(2) mxWake(EX_wake, {1'b0, HIT}, {HIT,1'b0}, sw);

endmodule