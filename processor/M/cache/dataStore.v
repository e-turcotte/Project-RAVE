module dataStore(
    input valid,
    input [1:0] index,
    input[3:0] way,
    input[16*8-1:0] data_in,
    input[16*8-1:0] mask_in,
    input w, 
    input clk,
    output[16*8*4-1:0] data_out,
    output[16*8-1:0] cache_line
);
wire[16*8-1:0] data_toWrite, data;
inv1$ clkinv(clkn, clk);
inv1$ inv12(valid_n, valid);
wire [16*8-1:0] not_mask;
genvar i;

generate
    for(i = 0; i < 128; i =  i+1) begin : maskflip
        inv1$ flipm(not_mask[i], mask_in[i]);
    end
endgenerate
wire [3:0] way_no, way_n, w_v,way_non, write;
wire [3:0] buf1, buf2, buf3, buf4, buf5, buf6, buf7, buf8, buf9, buf10, buf11;
generate
    for(i = 0; i < 16*8; i = i + 1)begin
        // mux2$ mxn1(data_toWrite[i], data_out[i], data_in[i], mask_in[i]);
        assign data_toWrite[i] = data_in[i];
    end
endgenerate

generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        inv1$ in(way_n[i], way[i]);
        or3$ orin(write[i], w, valid_n, way_n[i]);
        bufferH16$ b16(w_v[i], write[i]);
    end
endgenerate


wire [63:0] toWrite;
generate
    for(i = 0; i <64; i =  i+1) begin : dataGen
        or2$ masks(toWrite[i], w_v[i/16], not_mask[(i%16)*8]);
        ram8b4w$ r(index, data_toWrite[(i*8+7)%128 : (i*8)%128], 1'b0, toWrite[i], data_out[i*8+7: i*8] );
    end
endgenerate

muxnm_tristate #(4, 16*8) mxt(data_out,way,cache_line);

endmodule 