module prot_exception_logic(
    input [31:0] disp_imm,
    input [20:0] seg_size //max seg size is 1MB
    output prot_exception,
);

    //if disp_imm > seg_size, then it is a protection exception

    wire [31:0] seg_size_32;

    //zexting seg_size to 32 bits
    assign seg_size_32 = {12'b0, seg_size};

    wire disp_G_seg_0, disp_L_seg_0, 
         disp_G_seg_1, disp_L_seg_1, 
         disp_G_seg_2, disp_L_seg_2, 
         disp_G_seg_3, disp_L_seg_3;
        
    mag_comp8(.A(disp_imm), .B(seg_size_32), .EQ(prot_exception));


    

endmodule