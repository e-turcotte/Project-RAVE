module pmem_TOP (input [8:0] addr3, addr2, addr1, addr0,
                 input rw3, rw2, rw1, rw0,
                 input bnk3_en, bnk2_en, bnk1_en, bnk0_en,
                 input [127:0] din3, din2, din1, din0,
                 output [127:0] dout3, dout2, dout1, dout0);

    bank bnk0(.addr(addr0), .rw(rw0), .bnk_en(bnk0_en), .din(din0), .dout(dout0));
    bank bnk1(.addr(addr1), .rw(rw1), .bnk_en(bnk1_en), .din(din1), .dout(dout1));
    bank bnk2(.addr(addr2), .rw(rw2), .bnk_en(bnk2_en), .din(din2), .dout(dout2));
    bank bnk3(.addr(addr3), .rw(rw3), .bnk_en(bnk3_en), .din(din3), .dout(dout3));

endmodule