module SW_R_SWP(
    
    input[31:0] M1, M2 ,
    input[1:0] M1_RW, M2_RW,
    input [1:0]size_in,
    input valid_rsw,
    input sizeOvr,
    input [6:0] PTC_ID_in,

    output [31:0] address_in_r,//donme
    output [1:0] size_in_r, //done
    output valid_in_r, //done
    output sizeOVR_r, //done
    output [6:0] PTC_ID_in_r,
    output r_is_m1,

    output [31:0] address_in_sw,
    output [1:0]size_in_sw,
    output valid_in_sw,
    output sizeOVR_sw,
    output [6:0] PTC_ID_in_sw,
    output sw_is_m1

);
assign PTC_ID_in_sw = PTC_ID_in;
assign PTC_ID_in_r = PTC_ID_in;
nor2$ swselalt(swSel, M1_RW[0], M2_RW[0]);
nor2$ rselalt(rSel, M1_RW[1], M2_RW[1]);
nor2$ sels(Sel, M1_RW[1], M1_RW[0]);
muxnm_tristate #(3, 32) mx0({M2, M1, 32'd0}, {M2_RW[0],M1_RW[0],swSel},address_in_sw);
muxnm_tristate #(3, 32) mx1({M2, M1, 32'd0}, {M2_RW[1],M1_RW[1],rSel},address_in_r);


inv1$ noz(M2_RW_n[1], M2_RW[1]);
inv1$ nozas(M2_RW_n[0], M2_RW[0]);

muxnm_tristate #(3, 2) mx2({2'b10, 2'b01, 2'd0}, {M1_RW[0],M1_RW[1], Sel},{sw_is_m1a, r_is_m1a});
nor2$ asxas(use_m2,sw_is_m1a, r_is_m1a );
mux2n #(2) mx34({sw_is_m1, r_is_m1}, {sw_is_m1a, r_is_m1a}, {M2_RW_n[0], M1_RW_n[1]}, use_m2 );
assign sizeOVR_sw = sizeOvr;
assign sizeOVR_r = sizeOvr;
mux2n #(2) mxsws(size_in_sw, size_in, 2'b11, sizeOvr);
mux2n #(2) mxrs(size_in_r, size_in, 2'b11, sizeOvr);

nor2$ vsw(vsw_1, M1_RW[0], M2_RW[0]);

nor2$ vr(vr_1, M1_RW[1], M2_RW[1]);
inv1$ vn(valid_rsw_n, valid_rsw);

nor2$ vsw1(valid_in_sw, vsw_1, valid_rsw_n);
nor2$ vr1(valid_in_r, vr_1, valid_rsw_n);





endmodule 