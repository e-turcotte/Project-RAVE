module metaStore(
    input clk,    
    input rst, set,
    input valid,
    
    input[3:0] way,
    input[1:0] index,

    input r,
    input wb,
    input sw,
    input ex,
    input [6:0] ID_IN,

    output [3:0] VALID_out,
    output [3:0]PTC_out,
    output [3:0]DIRTY_out,
    output [15:0] LRU
    
);

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
wire[3:0] indDec;
mux4n #(16) mx1(LRU,  {LRU3[3:0],LRU2[3:0],LRU1[3:0],LRU0[3:0]},{LRU3[7:4],LRU2[7:4],LRU1[7:4],LRU0[7:4]},
 {LRU3[11:8],LRU2[11:8],LRU1[11:8],LRU0[11:8]},{LRU3[15:12],LRU2[15:12],LRU1[15:12],LRU0[15:12]},index[0], index[1]);
 muxnm_tristate #(4, 4) m1(PTC, indDec, PTC_out);


decodern #(2) d78 (index, indDec );


muxnm_tristate #(4, 4) m2(DIRTY, indDec, DIRTY_out);
muxnm_tristate #(4, 4) m3(VALID, indDec, VALID_out);
//generate load signal for next state
wire transit;
wire v_not;
nor3$ n1(transit, wb, sw, ex);
inv1$ i1(v_not, valid);
wire[7*16 -1 :0] PTCID;
wire [15:0]enable, lineSel;
wire[1:0] index_n;
wire[15:0] enable3;
inv1$ i2(index_n[1], index[1]); inv1$ i3(index_n[0], index[0]);

genvar i;
generate 
    for(i = 0; i < 4; i = i +1) begin : l1
        nand4$ n(lineSel[i],index_n[0], index_n[1], way[i], valid );
    end
endgenerate

generate 
    for(i = 0; i < 4; i = i +1) begin : l2
        nand4$ n(lineSel[i+4],index[0], index_n[1], way[i], valid );
    end
endgenerate

generate 
    for(i = 0; i < 4; i = i +1) begin : l3
        nand4$ n(lineSel[i+8],index_n[0], index[1], way[i] , valid);
    end
endgenerate

generate 
    for(i = 0; i < 4; i = i +1) begin : l4
        nand4$ n(lineSel[i+12],index[0], index[1], way[i], valid );
    end
endgenerate

generate 
    for(i = 0; i < 16; i = i +1) begin : l5
        nor2$ n(enable3[i],transit, lineSel[i] );
    end
endgenerate



wire[15:0] PTCID_LD;
wire[15:0] enable2, enable4, nandTemp, norTemp, VALID_n, PTC_not,fixTemp;

//Generate cahce signals
genvar j;
generate
    for(j = 0; j <4; j = j + 1) begin : outer
        equaln #(3)  e1(comp[j*3+2: j*3], {valid, index},equals[j]);
        LRU_FSM  L0(LRU0[j*4+3:j*4] , clk, rst, set, way                , equals[j] );
        LRU_FSM1 L1(LRU1[j*4+3:j*4] , clk, rst, set, way   , equals[j] );
        LRU_FSM2 L2(LRU2[j*4+3:j*4] , clk, rst, set, way   , equals[j] );
        LRU_FSM3 L3(LRU3[j*4+3:j*4] , clk, rst, set, way   , equals[j] );
//     {way[0],   way[3:1]}
// {way[1:0], way[3:2]}
// {way[2:0], way[3]}  
    
        for(i= 0; i <4; i = i +1) begin : inner
            PTCVDFSM p(.clk(clk), .set(set), .rst(rst),.r(r), .sw(sw), .ex(ex), .wb(wb), .enable(enable[j*4+i]), .V(VALID[j*4+i]),.D(DIRTY[j*4+i]), .PTC(PTC[j*4+i]) );  
            //[j*7*4+i*4+6:j*7*4+i*4]
            and3$ a(PTCID_LD[j*4+i],sw, way[i],equals[j] );
            equaln #(7) r1(ID_IN, PTCID[j*7*4+i*7+6:j*7*4+i*7],enable2[j*4+i]);
            
            nand3$ nands(nandTemp[j*4+i], VALID[j*4+i], enable2[j*4+i], PTC[j*4+i]);
            inv1$ inv(VALID_n[j*4+i], VALID[j*4+i]);
            inv1$ inv1(PTC_not[j*4+i], PTC[j*4+i]);
            nor2$ nors(norTemp[j*4+i], PTC_not[j*4+i], VALID_n[j*4+i]);

            nand3$ rFix(fixTemp[j*4+i], r, VALID_n[j*4+i], PTC_not[j*4+i] );

            nand3$ nors1(enable4[j*4+i], norTemp[j*4+i], nandTemp[j*4+i], fixTemp[j*4+i] );

            
            and2$ a1(enable[j*4+i],enable4[j*4+i],enable3[j*4+i] );
            regn #(7) r(ID_IN, PTCID_LD[j*4+i],rst, clk, PTCID[j*7*4+i*7+6:j*7*4+i*7]);
            
        end
    end
endgenerate

endmodule


