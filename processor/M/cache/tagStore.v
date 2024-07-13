module tagStore( 
    input clk,
input valid,
input [1:0] index,
input [3:0] way,
input [7:0] tag_in,
input [3:0]V,
input [3:0] PTC,
input w_unpulsed,
input w,
input r,
input isW,
input isSW,
input ex_miss,
input PCD_IN,

output[7:0] tag_out, 
output[3:0] hit,
output[31:0] tag_dump,
output[7:0] tagData_out_hit,
output[3:0] way_sw


);
wire[7:0] tagData_based_on_hit;
wire [3:0] wNot;
wire[3:0] hit1, hit_buf;
genvar i;
genvar j;
wire[3:0] writeSel;
wire[32-1:0] data;
wire[3:0] w_v;
inv1$ inv12(valid_n, valid);
wire read[3:0];
inv1$ inv123(R_not, r);
wire[3:0] way_n, write;
assign tag_dump = data;
inv1$ invc(clkn, clk);
wire [3:0] way_sw1, way_sw2, buf1, buf2, buf3, buf4, buf5, buf6, buf7, buf8, buf9, buf10, buf11, boabw, hmm;
generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        inv1$ in(way_n[i], way[i]);
        or3$ orin(write[i], w, valid_n, way_n[i]); //TODO:LOOK AT PLZ
        bufferH16$ b16(w_v[i], write[i]);;
    end
endgenerate
generate
    for(i = 0; i <4; i =  i+1) begin : tagGen
        and2$ and123(read[i], R_not,way_n[i]);
        ram8b4w$ r(.A(index), .DIN(tag_in), .OE(1'b0), .WR(w_v[i]), .DOUT(data[i*8+7: i*8]));
        equaln #(8) e(tag_in, data[i*8+7: i*8], hit1[i]);
        and2$ plz(hmm[i], PTC[i], isW);
        or2$ plz2(boabw[i], V[i], hmm[i]);
        and2$ andV(hit_buf[i], hit1[i], boabw[i]);
        and3$ asher(way_sw1[i], isSW, PTC[i], hit1[i]);
    end
  
endgenerate
    nor4$ allmiss(way_sel_sw_noptc, PTC[0], PTC[1], PTC[2], PTC[3]);
    nor4$ nomiss(way_sel_sw_nomiss, hit[0], hit[1], hit[2], hit[3]);
    and2$ swovr(way_sw_ov,way_sel_sw_noptc, way_sel_sw_nomiss);
    mux2n #(4) way_sw_swap(way_sw, way_sw1, way_sw1, way_sw_ov);
    mux2n #(4) (hit, hit_buf, 4'b0000, ex_miss & !isW | PCD_IN);
//Cycle 144
nor4$ n1(miss, hit[3], hit[2], hit[1], hit[0]);

muxnm_tristate #(4, 8) asb(data, way, tag_out);
muxnm_tristate #(4, 8) asbc(data, hit, tagData_out_hit);

// initial begin
//     $readmemh("cache.init",tagGen[0].r.mem );
//     $readmemh("cache.init",tagGen[1].r.mem );
//     $readmemh("cache.init",tagGen[2].r.mem );
//     $readmemh("cache.init",tagGen[3].r.mem );
// end

endmodule