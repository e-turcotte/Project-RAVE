module writeback_TOP(
    output [63:0] res1, res2, res3, res4, //done
    output  res1_reg_w,  res2_reg_w, res3_reg_w,  res4_reg_w,  //done
    output [31:0] res1_dest,res2_dest, res3_dest,res4_dest, //done
    output [1:0] res1_size, res2_size, res3_size, res4_size, //done
    output res1_isPTC, res2_isPTC, res3_isPTC, res4_isPTC, //done
    output [6:0] res1_PTC, res2_PTC, res3_PTC, res4_PTC, //done 
    output LD_EIP_CS,// done //Tells fetch that bits [47:32]is CS, [31:0] is EIP from Res1
    output LD_EIP,

    output[31:0] mem_adr, //done
    output mem_w, //done
    output[63:0] mem_data, //done
    output[1:0] mem_size, //done

    output [31:0] FIP_e, FIP_o, EIP, //done 
    output BR_valid, BR_taken, BR_correct, //done
    output [15:0] CS, //done
    output [15:0] segReg1,
    output [15:0] segReg2,

    output load_segReg1,
    output load_segReg2,

    input valid,
    input [63:0] inp1, inp2, inp3, inp4,
    input  inp1_isReg,  inp2_isReg, inp3_isReg,  inp4_isReg,  
    input [31:0] inp1_dest,inp2_dest, inp3_dest,inp4_dest,
    input [1:0] inp1_size, inp2_size, inp3_size, inp4_size,
    input inp1_isPTC, inp2_isPTC, inp3_isPTC, inp4_isPTC,
    input [6:0] inp1_PTC, inp2_PTC, inp3_PTC, inp4_PTC,
    input inp1_wb, inp2_wb, inp3_wb, inp4_wb,
    input [36:0]P_OP,

    input load_eip_in_res1,
    input load_segReg_in_res1,
    input load_eip_in_res2,
    input load_segReg_in_res2,

    input BR_valid_in, BR_taken_in, BR_correct_in,
    input[31:0] BR_FIP_in, BR_FIP_p1_in, input BR_EIP_in,
    input[15:0] CS_in
    );

    and2$   a1x(load_segReg1, load_segReg_in_res1,valid);
    or2$    ox(load_segReg1_temp, load_segReg1, LD_EIP_CS);

    and2$   ax(load_segReg2, load_segReg_in_res2,valid);
    wire res1_mem_w,res2_mem_w, res3_mem_w,res4_mem_w;

    assign CS = CS_in;
    reg_wb_cell r1(res1, res1_mem_w, res1_reg_w, inp1, inp1_size, valid, inp1_wb, inp1_isReg, load_eip_in_res1 );
    reg_wb_cell r2(res2, res2_mem_w, res2_reg_w, inp2, inp2_size, valid, inp2_wb, inp2_isReg, load_eip_in_res1);
    reg_wb_cell r3(res3, res3_mem_w, res3_reg_w, inp3, inp3_size, valid, inp3_wb, inp3_isReg, 1'b0);
    reg_wb_cell r4(res4, res4_mem_w, res4_reg_w, inp4, inp4_size, valid, inp4_wb, inp4_isReg,1'b0);

    mux_tristate #(4, 64) t1({res1, res2, res3, res4}, {res1_mem_w, res2_mem_w, res3_mem_w, res4_mem_w}, mem_data);
    mux_tristate #(4, 32) t2({inp1_dest, inp2_dest, inp3_dest, inp4_dest}, {res1_mem_w, res2_mem_w, res3_mem_w, res4_mem_w}, mem_adr);
    mux_tristate #(4, 2) t3({inp1_size, inp2_size, inp3_size, inp4_size}, {res1_mem_w, res2_mem_w, res3_mem_w, res4_mem_w}, mem_size);
    or4$ o1(mem_w, res1_mem_w, res2_mem_w, res3_mem_w, res4_mem_w);

    mux2n #(32) m1(FIP_e, {BR_FIP_in[31:4],4'd0}, {BR_FIP_p1_in, 4'd0}, BR_FIP_in[5]);
    mux2n #(32) m2(FIP_o, {BR_FIP_p1_in, 4'd0}, {BR_FIP_in[31:4],4'd0}, BR_FIP_in[5]);

    mux2n #(32) m3 (EIP,BR_EIP_IN, BR_FIP_in , BR_taken);
    assign BR_valid = BR_valid_in;
    assign BR_taken = BR_taken_in;
    assign BR_correct = BR_correct_in;

    assign res1_dest = inp1_dest;   assign res2_dest = inp2_dest;   assign res3_dest = inp3_dest;    assign res4_dest = inp4_dest;   
    assign res1_size = inp1_size;   assign res2_size = inp2_size;   assign res3_size = inp3_size;    assign res4_size = inp4_size;   
    assign res1_isPTC = inp1_isPTC; assign res2_isPTC = inp2_isPTC; assign res3_isPTC = inp3_isPTC;  assign res4_isPTC = inp4_isPTC;   
    assign res1_PTC = inp1_PTC;     assign res2_PTC = inp2_PTC;     assign res3_PTC = inp3_PTC;      assign res4_PTC = inp4_PTC;   

    or3$ o2(LD_EIP_CS, P_OP[36], P_OP[35], P_OP[32]);
    or2$ o3(LD_EIP, load_eip_in_res1, load_eip_in_res2);

    assign segReg2 = inp2[15:0];
    mux2n #(16) mxn(segReg1, inp1[15:0], inp1[47:32], LD_EIP_CS);
endmodule