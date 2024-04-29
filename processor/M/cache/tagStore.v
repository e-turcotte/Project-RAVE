module tagStore(
input clk,    
input rst, set,
input valid,
input [1:0] index,
input [3:0] way,
input [7:0] tag_in,
input r, sw, input [3:0]w, 
input  [3:0]extract,
output[7:0] tag_out, 
output[3:0] hit,
output[3:0] toRemove

);
genvar i;
genvar j;
wire[3:0] writeSel;
wire[32*8-1:0] data;

generate
    for(i = 0; i <4; i =  i+1) begin : tagGen
        ram8b4w$ r(index, tag_in, r, w[i], data[i*8+7, i*8] );
        equaln #(8) e(tag_in, data[i*8+7, i*8], hit[i]);
    end
endgenerate

muxnm_tristate #(4, 8)(data, hit, tag_out);

wire[15*4*4-1:0] tagMetaData;
wire[4*4 -1:0] LRU0;
wire[4*4 -1:0] LRU1;
wire[4*4 -1:0] LRU2;
wire[4*4 -1:0] LRU3;
wire[3:0] equals;
wire[11:0] comp = 12'b111_110_101_100; 
wire[15:0] PTC;
wire[15:0] DIRTY;
wire[15:0] VALID;
wire[15:0] valid, valid0, valid1,val_data;
generate
    for(j = 0; j <4; j = j + 1) begin : outer
    equaln #(3) (comp[j*3+2, j*3], {valid, index},equals);
    LRU_FSM  L0(LRU0[j*4+3,j*4] , clk, rst, set, hit,                , equals[j] );
    LRU_FSM1 L1(LRU1[j*4+3,j*4] , clk, rst, set, {hit[2:0], hit[3]}  , equals[j] );
    LRU_FSM2 L2(LRU2[j*4+3,j*4] , clk, rst, set, {hit[1:0], hit[3:2]}, equals[j] );
    LRU_FSM3 L3(LRU3[j*4+3,j*4] , clk, rst, set, {hit[0],   hit[3:1]}, equals[j] );
    
    
    for(i= 0; i <4; i = i +1) begin : inner
        nand2$ n(valid0[j*4+i], enable[j], w[j]);
        and2$ n1(valid1[j*4+i], enable[j], extract[j]);
        nand2$ n2(valid[j*4+i], valid1[j*4+i], valid0[j*4+i]);
        mux2$ mx1(val_data[j*4+i], 1'b0, 1'b1, valid1[j*4+i])

        regn #(1) r1(val_data ,valid[j*4+i],   ,rst  ,clk,    VALID[j*4 + i] );
        regn #(1) r2(    ,clk,    DIRTY[j*4 + i] )
        regn #(1) r3(    ,clk,    PTC[j*4 + i] )

        end
    end
endgenerate
endmodule