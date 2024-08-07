module outputAlign(
    input E_valid,
    input [16*8-1:0] E_data,
    input [31:0] E_vAddress,
    input [14:0] E_pAddress,
    input [1:0] E_size,
    input [1:0]E_wake,
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
    input [1:0]O_wake,
    input O_cache_stall,
    input O_cache_miss,
    input O_oddIsGreater,
    input O_needP1,

    // output[16 * 8 -1 : 0] PTC_out,
    output [63:0] data_out,
    output valid_out,
    output [3:0] wake
);
wire[1:0] wake1, wake0;
assign wake[3:0] = {O_wake, E_wake};
wire valid0;wire [16*8-1:0] data0;wire [31:0] vAddress0;wire [14:0] pAddress0;wire [1:0] size0;wire cache_stall0;wire cache_miss0;wire oddIsGreater0;wire needP10;wire valid1;wire [16*8-1:0] data1;wire [31:0] vAddress1;wire [14:0] pAddress1;wire [1:0]  size1;wire cache_stall1;wire cache_miss1;wire oddIsGreater1;wire needP11;

and2$ val4(val1, valid1, needP10);
inv1$ val5(P1n, needP10);
and2$ val6(val2, valid0, P1n);
or2$ val7(valid_out, val1, val2);

outputSwap os(E_valid,E_data, E_vAddress, E_pAddress, E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid, O_data,O_vAddress, O_pAddress, O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1, valid0, data0, vAddress0, pAddress0, size0, wake0, cache_stall0, cache_miss0, oddIsGreater0, needP10, valid1, data1, vAddress1, pAddress1, size1, wake1, cache_stall1, cache_miss1, oddIsGreater1, needP11);
genvar i;
//Generate data
wire[3:0] shift0_enc;
wire[16*8-1:0] data0_shift;
wire[15:0] shift0_dec;
decodern #(4) d2(pAddress0[3:0],shift0_dec);
generate
    for(i = 0; i < 8; i = i + 1) begin : rotate1
        rShf16 rshfx({data0[120+i],data0[112+i], data0[104+i], data0[96+i], data0[88+i], data0[80+i], data0[72+i], data0[64+i], data0[56+i], data0[48+i], data0[40+i], data0[32+i], data0[24+i], data0[16+i], data0[8+i], data0[i]},pAddress0[3:0], {data0_shift[120+i],data0_shift[112+i], data0_shift[104+i], data0_shift[96+i], data0_shift[88+i], data0_shift[80+i], data0_shift[72+i], data0_shift[64+i], data0_shift[56+i], data0_shift[48+i], data0_shift[40+i], data0_shift[32+i], data0_shift[24+i], data0_shift[16+i], data0_shift[8+i], data0_shift[i]} );
    end
endgenerate
wire[63:0] muxData, preSext;
mux8_n #(64) breakup(muxData, data0_shift[63:0], {data1[7:0], data0_shift[55:0]}, {data1[15:0], data0_shift[47:0]},{data1[23:0], data0_shift[39:0]},{data1[31:0], data0_shift[31:0]},{data1[39:0], data0_shift[23:0]},{data1[47:0], data0_shift[15:0]},{data1[55:0], data0_shift[7:0]}, pAddress0[0], pAddress0[1], pAddress0[2]);
mux2n #(64) chossePath(preSext, data0_shift[63:0],muxData, E_needP1 );
wire sext;
mux4$ mxnb(sext, preSext[7], preSext[15], preSext[31], preSext[63], size0[0], size0[1]);
mux4n #(64) finals(data_out, {{56{sext}},preSext[7:0]},{{48{sext}},preSext[15:0]},{{32{sext}},preSext[31:0]},preSext, size0[0], size0[1]); 

//generate wake
// assign wake0 = valid0;
// assign wake1 = valid1;

//TODO: GENERATE WAKE BITS



endmodule



module outputSwap(
    input E_valid,                                  
    input [16*8-1:0] E_data,                                    
    input [31:0] E_vAddress,                                    
    input [14:0] E_pAddress,                                    
    input [1:0] E_size,                                 
    input [1:0]E_wake,                                   
    input E_cache_stall,                                    
    input E_cache_miss,                                 
    input E_oddIsGreater,                                   
    input E_needP1,                                 
                                    
    input O_valid,                                  
    input [16*8-1:0] O_data,                                    
    input [31:0] O_vAddress,                                    
    input [14:0] O_pAddress,                                    
    input [1:0]  O_size,                                    
    input [1:0]O_wake,                                   
    input O_cache_stall,                                    
    input O_cache_miss,                                 
    input O_oddIsGreater,                                   
    input O_needP1,                                 
                                    
    output valid0,                                  
    output [16*8-1:0] data0,                                    
    output [31:0] vAddress0,                                    
    output [14:0] pAddress0,                                    
    output [1:0] size0,                                 
    output [1:0]wake0,                                   
    output cache_stall0,                                    
    output cache_miss0,                                 
    output oddIsGreater0,                                   
    output needP10,                                 
                                    
    output valid1,                                  
    output [16*8-1:0] data1,                                    
    output [31:0] vAddress1,                                    
    output [14:0] pAddress1,                                    
    output [1:0]  size1,                                    
    output [1:0] wake1,                                   
    output cache_stall1,                                    
    output cache_miss1,                                 
    output oddIsGreater1,                                   
    output needP11                                  
);                                  
inv1$ ix(evenIsGreater, E_oddIsGreater);
muxnm_tristate #(2, 184) ax({E_valid,E_data,E_vAddress,E_pAddress,E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid,O_data,O_vAddress,O_pAddress,O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1},{evenIsGreater, E_oddIsGreater},{valid0, data0, vAddress0,pAddress0, size0,wake0,cache_stall0,cache_miss0,oddIsGreater0,needP10});
muxnm_tristate #(2, 184) ex({E_valid,E_data,E_vAddress,E_pAddress,E_size,E_wake,E_cache_stall,E_cache_miss,E_oddIsGreater,E_needP1,O_valid,O_data,O_vAddress,O_pAddress,O_size,O_wake,O_cache_stall,O_cache_miss,O_oddIsGreater,O_needP1},{E_oddIsGreater,evenIsGreater},{valid1, data1, vAddress1,pAddress1, size1,wake1,cache_stall1,cache_miss1,oddIsGreater1,needP11});

endmodule


