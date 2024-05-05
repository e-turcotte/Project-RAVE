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

wire [3:0] way_no, way_n, w_v,way_non;
genvar i;
wire [3:0] buf1, buf2, buf3, buf4, buf5, buf6, buf7, buf8, buf9, buf10, buf11;
generate
    for(i = 0; i < 16*8; i = i + 1)begin
        mux2$ mxn1(data_toWrite[i], data_out[i], data_in[i], mask_in[i]);
    end
endgenerate

generate
    for(i = 0; i <4; i =  i+1) begin : writeGen
        and3$ as(way_no[i], way[i], w, valid);
        inv1$ kms(buf11[i], way_no[i]);
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
    

        or2$ a4(way_non[i], buf1[i], buf8[i] );
        bufferH16$ b16(w_v[i], way_non[i]);
    end
endgenerate


generate
    for(i = 0; i <64; i =  i+1) begin : dataGen
        ram8b4w$ r(index, data_toWrite[(i*8+7)%128 : (i*8)%128], 1'b0, w_v[i/16], data_out[i*8+7: i*8] );
    end
endgenerate

muxnm_tristate #(4, 16*8) mxt(data_out,way,cache_line);

endmodule 