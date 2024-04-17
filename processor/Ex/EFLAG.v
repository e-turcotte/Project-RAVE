// View page 59 of 
//https://users.ece.utexas.edu/~patt/24s.382N/handouts/x86%20Basic%20Architecture.pdf

module EFLAG(
    output[16:0] cc_out,
      
    input clk,
    input set,
    input rst,
    input val,
    input[16:0] cc_in,
    input[16:0] FMASK,
    input cc_inval
);

wire[16:0] cc_new;
wire[16:0] FMASK_v; wire cc_val;
inv1$(cc_val, cc_inval);
wire v;
and2$ a1(v, val, cc_val);
bufferH64$ b1(val_n, v);
genvar i;
generate

for(i = 0; i < 17; i = i + 1) begin : ef
    and2$ a(FMASK_v[i], val_n,FMASK[i]);
    dff$ d(cc_out[i], cc_new[i], clk, set, rst);
    mux2$ m(cc_new[i], cc_out[i], cc_in[i], FMASK_v[i]);
end

endgenerate


endmodule