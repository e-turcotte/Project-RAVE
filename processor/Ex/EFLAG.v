// View page 59 of 
//https://users.ece.utexas.edu/~patt/24s.382N/handouts/x86%20Basic%20Architecture.pdf
// 18'b000000000_of_df_00_sf_zf_af_pf_cf

module EFLAG(
    output[17:0] cc_out,
      
    input clk,
    input set,
    input rst,
    input val,
    input[17:0] cc_in,
    input[17:0] FMASK,
    input cc_inval
);

assign cf = cc_out[0];
assign pf = cc_out[1];
assign af = cc_out[2];
assign zf = cc_out[3];
assign sf = cc_out[4];
assign df = cc_out[7];
assign of = cc_out[8];
wire[17:0] cc_new;
wire[17:0] FMASK_v; wire cc_val;
inv1$ inv1(cc_val, cc_inval);
wire v;
and2$ a1(v, val, cc_val);
bufferH64$ b1(val_n, v);
genvar i;
wire[17:0] cc_not;
generate

for(i = 0; i < 18; i = i + 1) begin : ef
    and2$ a(FMASK_v[i], val_n,FMASK[i]);
    dff$ d(clk, cc_new[i], cc_out[i], cc_not[i], rst, set);
    mux2$ m(cc_new[i], cc_out[i], cc_in[i], FMASK_v[i]);
end

endgenerate

integer file_handle;
integer instr_ctr;
integer clk_ctr;
initial begin
    // Open the file for writing
    file_handle = $fopen("eflag.out", "w");
    if (file_handle == 0) begin
        $display("Error: Failed to open file for eflags!");
    end
    clk_ctr = 0;
    instr_ctr = 0;
    
end

always @(posedge clk) begin
    // Write signal values to the file at every clock cycle
    clk_ctr = clk_ctr + 1;
    if (val == 1'b1) begin
        instr_ctr = instr_ctr + 1;
        $fwrite(file_handle, "\n\n////////////////////////////\n");
        $fwrite(file_handle, "Cycle: %d\n", clk_ctr);
        $fwrite(file_handle, "Instruction #: %d\n", instr_ctr);
        $fwrite(file_handle, "Currently Latched:\n");
        $fwrite(file_handle, "cf=%b\npf=%b\naf=%b\nzf=%b\nsf=%b\ndf=%b\nof=%b\n", cf, pf, af, zf, sf, df, of);
        $fwrite(file_handle, "\nLoaded Values:\n");
        $fwrite(file_handle, "cf=%b\npf=%b\naf=%b\nzf=%b\nsf=%b\ndf=%b\nof=%b\n", cc_new[0], cc_new[1], cc_new[2], cc_new[3], cc_new[4], cc_new[7], cc_new[8]);

        $fwrite(file_handle, "////////////////////////////");
    end
end

endmodule