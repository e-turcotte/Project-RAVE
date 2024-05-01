module tagStore( 
input valid,
input [1:0] index,
input [3:0] way,
input [7:0] tag_in,
input r,sw,  w, extract,
output[7:0] tag_out, 
output[3:0] hit,
output[31:0] tag_dump


);
genvar i;
genvar j;
wire[3:0] writeSel;
wire[32-1:0] data;
wire[3:0] w_v;
assign tag_dump = data;
generate
    for(i = 0; i <4; i =  i+1) begin : tagGen
        ram8b4w$ r(index, tag_in, 1'b0, w_v[i], data[i*8+7: i*8] );
        equaln #(8) e(tag_in, data[i*8+7: i*8], hit[i]);
    end
endgenerate

wire[3:0] way_n;
generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        inv1$ i(w_n, w);
        inv1$ i1(way_n[i], way[i]);
        
        nor2$ a(w_v[i], way_n[i], w_n);
    end
endgenerate

nor4$ n1(miss, hit[3], hit[2], hit[1], hit[0]);

muxnm_tristate #(4, 8)(data, way, tag_out);


endmodule