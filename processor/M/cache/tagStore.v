module tagStore( 
    input clk,
input valid,
input [1:0] index,
input [3:0] way,
input [7:0] tag_in,
input [3:0]V,
input w,
input r,
output[7:0] tag_out, 
output[3:0] hit,
output[31:0] tag_dump


);
wire[7:0] tagData_based_on_hit;
wire [3:0] wNot;
wire[3:0] hit1;
genvar i;
genvar j;
wire[3:0] writeSel;
wire[32-1:0] data;
wire[3:0] w_v;
inv1$ inv12(valid_n, valid);
wire read[3:0];
inv1$ inv123(R_not, r);
wire[3:0] way_n;
assign tag_dump = data;
inv1$ invc(clkn, clk);
wire [3:0] buf1, buf2, buf3, buf4, buf5, buf6, buf7, buf8, buf9, buf10, buf11;
generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        inv1$ i2(w_n, w);
        inv1$ i1(way_n[i], way[i]);
        and3$ as(w_v[i], way[i], w, valid);
        inv1$ inv12(buf11[i], w_v[i]);
        and2$ buff10(buf10[i], buf11[i], buf11[i]);
        and2$ buff11(buf1[i], buf10[i], buf10[i]);

        and2$ buff1(buf2[i], clkn, clkn);
        and2$ buff2(buf3[i], buf2[i], buf2[i]);
        and2$ buff3(buf4[i], buf3[i], buf3[i]);
        and2$ buff4(buf5[i], buf4[i], buf4[i]);
        and2$ buff5(buf6[i], buf5[i], buf5[i]);
        and2$ buff7(buf7[i], buf6[i], buf6[i]);
        and2$ buff9(buf8[i], buf7[i], buf7[i]);
        and2$ buff8(buf9[i], buf8[i], buf8[i]);
        or2$ buff6(wNot[i], buf9[i], buf1[i]);
    end
endgenerate
generate
    for(i = 0; i <4; i =  i+1) begin : tagGen
        and2$ and123(read[i], R_not,way_n[i]);
        ram8b4w$ r(.A(index), .DIN(tag_in), .OE(1'b0), .WR(wNot[i]), .DOUT(data[i*8+7: i*8]));
        equaln #(8) e(tag_in, data[i*8+7: i*8], hit1[i]);
        and2$ andV(hit[i], hit1[i], V[i]);
    end
endgenerate




nor4$ n1(miss, hit[3], hit[2], hit[1], hit[0]);

muxnm_tristate #(4, 8) asb(data, way, tag_out);
muxnm_tristate #(4, 8) asbc(data, hit, tagData_based_on_hit);

// initial begin
//     $readmemh("cache.init",tagGen[0].r.mem );
//     $readmemh("cache.init",tagGen[1].r.mem );
//     $readmemh("cache.init",tagGen[2].r.mem );
//     $readmemh("cache.init",tagGen[3].r.mem );
// end

endmodule