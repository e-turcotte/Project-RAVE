module outputAlign(
    input E_valid,
    input [16*8-1:0] E_data,
    input [31:0] E_vAddress,
    input [14:0] E_pAddress,
    input [1:0] E_size,
    input E_wake,
    input E_cache_stall,
    input E_cache_miss,
    input E_oddIsGreater,
    input E_needP1,
    input [2:0] oneSize,

    input O_valid,
    input [16*8-1:0] O_data,
    input [31:0] O_vAddress,
    input [14:0] O_pAddress,
    input [1:0]  O_size,
    input O_wake,
    input O_cache_stall,
    input O_cache_miss,
    input O_oddIsGreater,
    input O_needP1,

    output[16 * 8 -1 : 0] PTC_out,
    output [63:0] data_out,
    output valid_out,
    output wake1, wake0
);
wire valid0;wire [16*8-1:0] data0;wire [31:0] vAddress0;wire [14:0] pAddress0;wire [1:0] size0;wire cache_stall0;wire cache_miss0;wire oddIsGreater0;wire needP10;wire valid1;wire [16*8-1:0] data1;wire [31:0] vAddress1;wire [14:0] pAddress1;wire [1:0]  size1;wire cache_stall1;wire cache_miss1;wire oddIsGreater1;wire needP11;

outputSwap os(E_valid,E_data, E_vAddress, E_pAddress, E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid, O_data,O_vAddress, O_pAddress, O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1, valid0, data0, vAddress0, pAddress0, size0, wake0, cache_stall0, cache_miss0, oddIsGreater0, needP10, valid1, data1, vAddress1, pAddress1, size1, wake1, cache_stall1, cache_miss1, oddIsGreater1, needP11);
genvar i;
//Generate data
wire[3:0] shift0_enc;
wire[16*8-1:0] data0_shift;
wire[15:0] shift0_dec;
decodern #(4) d2(pAddress0[3:0],shift0_dec);
generate
    for(i = 0; i < 8; i = i + 1) begin : rotate1
        rshfn_variable #(16) rshfx({data0[120+i],data0[112+i], data0[104+i], data0[96+i], data0[88+i], data0[80+i], data0[72+i], data0[64+i], data0[56+i], data0[48+i], data0[40+i], data0[32+i], data0[24+i], data0[16+i], data0[8+i], data0[i]},shift0_dec,1'b0, {data0_shift[120+i],data0_shift[112+i], data0_shift[104+i], data0_shift[96+i], data0_shift[88+i], data0_shift[80+i], data0_shift[72+i], data0_shift[64+i], data0_shift[56+i], data0_shift[48+i], data0_shift[40+i], data0_shift[32+i], data0_shift[24+i], data0_shift[16+i], data0_shift[8+i], data0_shift[i]} );
    end
endgenerate
wire[63:0] muxData, preSext;
mux8_n #(64) breakup(muxData, data0_shift[63:0], {data1[7:0], data0_shift[55:0]}, {data1[15:0], data0_shift[47:0]},{data1[23:0], data0_shift[39:0]},{data1[31:0], data0_shift[31:0]},{data1[39:0], data0_shift[23:0]},{data1[47:0], data0_shift[15:0]},{data1[55:0], data0_shift[7:0]}, oneSize[0], oneSize[1], oneSize[2]);
mux2n #(64) chossePath(preSext, data0_shift[63:0],muxData, E_needP1 );
wire sext;
mux4$ mxnb(sext, preSext[7], preSext[15], preSext[31], preSext[63], size0[0], size0[1]);
mux4n #(64) finals(data_out, {{56{sext}},preSext[7:0]},{{48{sext}},preSext[15:0]},{{32{sext}},preSext[31:0]},preSext, size0[0], size0[1]); 

//generate wake
assign wake0 = valid0;
assign wake1 = valid1;
wire[255:0] PTC0_shift;
//Generate PTCout
wire[16*16-1:0] PTC0, PTC1;
generate
    for(i = 0; i < 16; i = i + 1) begin : zero
        assign PTC0[i*16+3:i*16] = i;
        assign PTC0[i*16+14:i*16+4] = pAddress0[14:4];
        assign PTC1[i*16+3:i*16] = i;
        assign PTC1[i*16+14:i*16+4] = pAddress1[14:4];
    end
endgenerate 

generate
    for(i = 0; i < 16; i = i + 1) begin : zerox
rshfn_variable #(16) rshfx(
    {
        PTC0[240+i], PTC0[224+i], PTC0[208+i],
        PTC0[192+i], PTC0[176+i], PTC0[160+i], PTC0[144+i],
        PTC0[128+i], PTC0[112+i], PTC0[96+i], PTC0[80+i],
        PTC0[64+i], PTC0[48+i], PTC0[32+i], PTC0[16+i],
        PTC0[i]
    },
    shift0_dec,
    1'b0,
    {
        PTC0_shift[240+i], PTC0_shift[224+i], PTC0_shift[208+i],
        PTC0_shift[192+i], PTC0_shift[176+i], PTC0_shift[160+i], PTC0_shift[144+i],
        PTC0_shift[128+i], PTC0_shift[112+i], PTC0_shift[96+i], PTC0_shift[80+i],
        PTC0_shift[64+i], PTC0_shift[48+i], PTC0_shift[32+i], PTC0_shift[16+i],
        PTC0_shift[i]
    }
);
    end
endgenerate
wire[127:0] preVAL;
wire [127:0]PTCDATA;
mux8_n #(128) breakup2(
    PTCDATA, 
    data0_shift[127:0], 
    {data1[15:0], PTC0_shift[111:0]}, 
    {data1[31:0], PTC0_shift[95:0]},
    {data1[47:0], PTC0_shift[79:0]},
    {data1[63:0], PTC0_shift[63:0]},
    {data1[79:0], PTC0_shift[47:0]},
    {data1[95:0], PTC0_shift[31:0]},
    {data1[111:0],PTC0_shift[15:0]}, 
    oneSize[0], oneSize[1], oneSize[2]
);

mux2n #(128) chosePath(PTC_out, PTC0_shift[127:0], PTCDATA[127:0] , E_needP1 );

mux4n #(8) results({PTC_out[127],PTC_out[111],PTC_out[95],PTC_out[79],PTC_out[63],PTC_out[47],PTC_out[31],PTC_out[15]},8'h01, 8'h03, 8'h0f, 8'hff, size0[0], size0[1] );

endmodule



module outputSwap(
    input E_valid,
    input [16*8-1:0] E_data,
    input [31:0] E_vAddress,
    input [14:0] E_pAddress,
    input [1:0] E_size,
    input E_wake,
    input E_cache_stall,
    input E_cache_miss,
    input E_oddIsGreater,
    input E_needP1,

    input O_valid,
    input [16*8-1:0] O_data,
    input [31:0] O_vAddress,
    input [14:0] O_pAddress,
    input [1:0]  O_size,
    input O_wake,
    input O_cache_stall,
    input O_cache_miss,
    input O_oddIsGreater,
    input O_needP1,

    output valid0,
    output [16*8-1:0] data0,
    output [31:0] vAddress0,
    output [14:0] pAddress0,
    output [1:0] size0,
    output wake0,
    output cache_stall0,
    output cache_miss0,
    output oddIsGreater0,
    output needP10,

    output valid1,
    output [16*8-1:0] data1,
    output [31:0] vAddress1,
    output [14:0] pAddress1,
    output [1:0]  size1,
    output wake1,
    output cache_stall1,
    output cache_miss1,
    output oddIsGreater1,
    output needP11
);
inv1$ ix(evenIsGreater, E_oddIsGreater);
muxnm_tristate #(2, 183) ax({E_valid,E_data,E_vAddress,E_pAddress,E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid,O_data,O_vAddress,O_pAddress,O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1},{evenIsGreater, E_oddIsGreater},{valid0, data0, vAddress0,pAddress0, size0,wake0,cache_stall0,cache_miss0,oddIsGreater0,needP10});
muxnm_tristate #(2, 183) ex({E_valid,E_data,E_vAddress,E_pAddress,E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid,O_data,O_vAddress,O_pAddress,O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1},{E_oddIsGreater,evenIsGreater},{valid1, data1, vAddress1,pAddress1, size1,wake1,cache_stall1,cache_miss1,oddIsGreater1,needP11});



endmodule

