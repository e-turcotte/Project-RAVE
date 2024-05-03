module dataStore(
    input valid,
    input [1:0] index,
    input[3:0] way,
    input[16*8-1:0] data_in,
    input[16*8-1:0] mask_in,
    input w, 

    output[16*8*4-1:0] data_out,
    output[16*8-1:0] cache_line
);
wire[16*8-1:0] data_toWrite, data;

inv1$ inv12(valid_n, valid);

wire [3:0] way_no, way_n, w_v;
genvar i;

generate
    for(i = 0; i < 16*8-1; i = i + 1)begin
        mux2$ mxn1(data_toWrite[i], data_out[i], data_in[i], mask_in[i]);
    end
endgenerate

generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        inv1$ xi(w_n, w);
        inv1$ i1(way_n[i], way[i]);
        nor3$ a1(way_no[i], way_n[i], w_n, valid_n);
        bufferH16$ b16(w_v[i], way_no[i]);
    end
endgenerate


generate
    for(i = 0; i <64; i =  i+1) begin : dataGen
        ram8b4w$ r(index, data_toWrite[(i*8+7)%128 : (i*8)%128], 1'b0, w_v[i/16], data_out[i*8+7: i*8] );
    end
endgenerate

muxnm_tristate #(4, 16*8) mxt(data_out,way,cache_line);

endmodule 