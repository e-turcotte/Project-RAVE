module reg_wb_cell(
output [63:0] resx,
output resx_mem_w,
output resx_reg_w,
input [63:0] inx,
input [1:0] sizex,
input valid, resx_wb, resx_isReg, resx_eip
);

wire[63:0] res8;wire[63:0] res16;wire[63:0] res32;wire[63:0] res64;
assign res64 = inx;

mux2n #(64) m0(res8, {56'd0,inx[7:0]}, {56'hFFFF_FFFF_FFFF_FF,inx[7:0]},inx[7] );
mux2n #(64) m1(res16, {48'd0,inx[15:0]}, {48'hFFFF_FFFF_FFFF,inx[15:0]},inx[15] );
mux2n #(64) m2(res32, {32'd0,inx[31:0]}, {32'hFFFF_FFFF,inx[31:0]},inx[31] );

mux4n #(64) m3(resx, res8, res16, res32,res64, sizex[0], sizex[1]);

inv1$ i0(val_n, valid);
inv1$ i1(resx_wb_n, resx_wb);
inv1$ i2(resx_eip_n, resx_eip);
nor4$ n1(resx_mem_w, resx_wb_n, val_n, resx_isReg, resx_eip_n);

and3$ a1(resx_reg_w, valid, resx_wb, resx_isReg);

endmodule 