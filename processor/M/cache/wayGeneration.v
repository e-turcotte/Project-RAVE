module wayGeneration(
    input [15:0]LRU,
    input [31:0]TAGS,
    input[3:0] PTC,V, D,
    input[3:0] HITS,
    input[1:0] index,
    input w,
    input missMSHR,
    input valid,
    input PCD_in,

    output ex_wb, ex_clr, stall, 
    output[3:0] way, 
    output D_out, V_out, PTC_out,
    output MISS
);
wire HIT; or4$ a1(HIT, HITS[1],HITS[2],HITS[3],HITS[0]);
wire  MISST; nor4$ o1(MISS,HITS[1],HITS[2],HITS[3],HITS[0] );

wire[31:0] tag_next;
wire [3:0] ptc_next, v_next, d_next;



//Twist PTC,V,D by LRU
wire[15:0] way_next; 
genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin: twist
        muxnm_tristate #(4, 8) mx1(TAGS, {LRU[12+i], LRU[8+i], LRU[4+i], LRU[i]}, tag_next[i*8+7:i*8] );
        muxnm_tristate #(4, 1) mx2(PTC, {LRU[12+i], LRU[8+i], LRU[4+i], LRU[i]}, ptc_next[i] );
        muxnm_tristate #(4, 1) mx3(V, {LRU[12+i], LRU[8+i], LRU[4+i], LRU[i]}, v_next[i] );
        muxnm_tristate #(4, 1) mx4(D, {LRU[12+i], LRU[8+i], LRU[4+i], LRU[i]}, d_next[i] );
        muxnm_tristate #(4, 4) mx6({4'b1000, 4'b0100, 4'b0010, 4'b0001}, {LRU[12+i], LRU[8+i], LRU[4+i], LRU[i]}, way_next[i*4+3: i*4] );
    end
endgenerate

///////////////////////
wire[2:0] lru_mux_select; wire stall_if_miss;
pencoder8_3v$ p1(1'b0, {4'd0, ptc_next}, lru_mux_select, dc );
wire ptc_comp;
and4$ a4(ptc_comp, PTC[0], PTC[1], PTC[2], PTC[3]);
and2$ a5(stall, MISS, ptc_comp);

//Way gen for extract
wire[3:0] way_read_1, way_read, way_write, way_write_1;
mux4n #(4) mx4(way_read_1, way_next[3:0], way_next[7:4], way_next[11:8], way_next[15:12], lru_mux_select[0], lru_mux_select[1]);
mux2n #(4) mx41(way_read, HITS, way_read_1, MISS);


//way generation for writes
wire[3:0] p_n, penc_Vn_PTC;
wire[2:0] way_mux_select;
generate
    for(i = 0; i < 4; i = i + 1) begin : helpmeplziwanttokillmyself
        inv1$ ix(p_n[i], PTC[i]);
        nor2$  n(penc_Vn_PTC[i], V[i], p_n[i]);
    end
endgenerate
pencoder8_3v$ p2(1'b0, {4'd0, penc_Vn_PTC}, way_mux_select, dc1 );
mux4n #(4) mx12(way_write_1, 4'b0001, 4'b0010, 4'b0100, 4'b100, way_mux_select[0], way_mux_select[1]);
mux2n #(4) mx13(way_write, HITS, way_write_1, MISS);

//Select which way
mux2n #(4) mx14(way, way_read, way_write,w);
muxnm_tristate #(4,1) mxt1(D, way, D_out);
muxnm_tristate #(4,1) mxt2(V, way, V_out);
muxnm_tristate #(4,1) mxt3(PTC, way, PTC_out);

and4$ andEx(ex_wb, MISS, missMSHR, D_out, valid);
and3$ andExClr(ex_clr, MISS, missMSHR, valid);
endmodule

