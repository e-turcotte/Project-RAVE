module disp_imm_select (
    input wire [7:0] B1,
    input wire [7:0] B2,
    input wire [7:0] B3,
    input wire [7:0] B4,
    input wire [7:0] B5,
    input wire [7:0] B6,
    input wire [7:0] B7,
    input wire [7:0] B8,
    input wire [7:0] B9,
    input wire [7:0] B10,
    input wire [7:0] B11,
    input wire [7:0] B12,
    input wire [7:0] B13,
    input wire [7:0] B14,
    input wire [7:0] B15,

    input wire isDouble,
    input wire isMOD,
    input wire isSIB,
    input wire [3:0] num_prefixes_onehot
    input wire [3:0] disp_size_select,
    input wire [1:0] imm_size_select

    output wire [47:0] immediate,
    output wire [31:0] displacement

);
    //////////////////////////////////////////
    //              immediate              //
    ////////////////////////////////////////

    //immediates
    wire [7:0] imm1, imm2, imm3, imm4, imm5, imm6, imm7, imm8, imm9, imm10, imm11, imm12, imm13, imm14;
    assign imm1 = B1;
    assign imm2 = B2;
    assign imm3 = B3;
    assign imm4 = B4;
    assign imm5 = B5;
    assign imm6 = B6;
    assign imm7 = B7;
    assign imm8 = B8;
    assign imm9 = B9;
    assign imm10 = B10;
    assign imm11 = B11;
    assign imm12 = B12;
    assign imm13 = B13;
    assign imm14 = B14;


    //immediate
    wire [47:0] imm_48_first;
    wire [47:0] imm_32_first;
    wire [47:0] imm_16_first;
    wire [47:0] imm_8_first;
    assign imm_48_first = {imm6, imm5, imm4, imm3, imm2, imm1};
    sext_32_to_48 penis012313(.in({imm4, imm3, imm2, imm1}), .out(imm_32_first));
    sext_16_to_48 penis012314(.in({imm2, imm1}), .out(imm_16_first));
    sext_8_to_48 penis012315(.in(imm1), .out(imm_8_first));`
    wire [191:0] imm_1_concat;
    assign imm_1_concat = {imm_48_first, imm_32_first, imm_16_first, imm_8_first};

    //starting at byte 2
    wire [47:0] imm_48_0;
    wire [47:0] imm_32_0;
    wire [47:0] imm_16_0;
    wire [47:0] imm_8_0;
    assign imm_48_0 = {imm7, imm6, imm5, imm4, imm3, imm2};
    sext_32_to_48 penis481(.in({imm5, imm4, imm3, imm2}), .out(imm_32_0));
    sext_16_to_48 penis12(.in({imm3, imm2}), .out(imm_16_0));
    sext_8_to_48 penis13(.in(imm2), .out(imm_8_0));
    wire [191:0] imm_2_concat;
    assign imm_2_concat = {imm_48_0, imm_32_0, imm_16_0, imm_8_0};

    //starting at byte 3
    wire [47:0] imm_48_1;
    wire [47:0] imm_32_1;
    wire [47:0] imm_16_1;
    wire [47:0] imm_8_1;
    assign imm_48_1 = {imm8, imm7, imm6, imm5, imm4, imm3};
    sext_32_to_48 penis14(.in({imm6, imm5, imm4, imm3}), .out(imm_32_1));
    sext_16_to_48 penis15(.in({imm4, imm3}), .out(imm_16_1));
    sext_8_to_48 penis16(.in(imm3), .out(imm_8_1));
    wire [191:0] imm_3_concat;
    assign imm_3_concat = {imm_48_1, imm_32_1, imm_16_1, imm_8_1};
    
    //starting at byte 4
    wire [47:0] imm_48_2;
    wire [47:0] imm_32_2;
    wire [47:0] imm_16_2;
    wire [47:0] imm_8_2;
    assign imm_48_2 = {imm9, imm8, imm7, imm6, imm5, imm4};
    sext_32_to_48 penis17(.in({imm7, imm6, imm5, imm4}), .out(imm_32_2));
    sext_16_to_48 penis18(.in({imm5, imm4}), .out(imm_16_2));
    sext_8_to_48 penis19(.in(imm4), .out(imm_8_2));
    wire [191:0] imm_4_concat;
    assign imm_4_concat = {imm_48_2, imm_32_2, imm_16_2, imm_8_2};
    
    //starting at byte 6
    wire [47:0] imm_48_3;
    wire [47:0] imm_32_3;
    wire [47:0] imm_16_3;
    wire [47:0] imm_8_3;
    assign imm_48_3 = {imm11, imm10, imm9, imm8, imm7, imm6};
    sext_32_to_48 penis20(.in({imm9, imm8, imm7, imm6}), .out(imm_32_3));
    sext_16_to_48 penis21(.in({imm7, imm6}), .out(imm_16_3));
    sext_8_to_48 penis22(.in(imm6), .out(imm_8_3));
    wire [191:0] imm6_concat;
    assign imm_6_concat = {imm_48_3, imm_32_3, imm_16_3, imm_8_3};

    //starting at byte 7
    wire [47:0] imm_48_4;
    wire [47:0] imm_32_4;
    wire [47:0] imm_16_4;
    wire [47:0] imm_8_4;
    assign imm_48_4 = {imm12, imm11, imm10, imm9, imm8, imm7};
    sext_32_to_48 penis23(.in({imm10, imm9, imm8, imm7}), .out(imm_32_4));
    sext_16_to_48 penis24(.in({imm8, imm7}), .out(imm_16_4));
    sext_8_to_48 penis25(.in(imm7), .out(imm_8_4));
    wire [191:0] imm_7_concat;
    assign imm_7_concat = {imm_48_4, imm_32_4, imm_16_4, imm_8_4};

    //starting at byte 8
    wire [47:0] imm_48_5;
    wire [47:0] imm_32_5;
    wire [47:0] imm_16_5;
    wire [47:0] imm_8_5;
    assign imm_48_5 = {imm13, imm12, imm11, imm10, imm9, imm8};
    sext_32_to_48 penis26(.in({imm11, imm10, imm9, imm8}), .out(imm_32_5));
    sext_16_to_48 penis27(.in({imm9, imm8}), .out(imm_16_5));
    sext_8_to_48 penis28(.in(imm8), .out(imm_8_5));
    wire [191:0] imm_8_concat;
    assign imm_8_concat = {imm_48_5, imm_32_5, imm_16_5, imm_8_5};

    //starting at byte 9
    wire [47:0] imm_48_6;
    wire [47:0] imm_32_6;
    wire [47:0] imm_16_6;
    wire [47:0] imm_8_6;
    assign imm_48_6 = {imm14, imm13, imm12, imm11, imm10, imm9};
    sext_32_to_48 penis29(.in({imm12, imm11, imm10, imm9}), .out(imm_32_6));
    sext_16_to_48 penis30(.in({imm10, imm9}), .out(imm_16_6));
    sext_8_to_48 penis31(.in(imm9), .out(imm_8_6));
    wire [191:0] imm_9_concat;
    assign imm_9_concat = {imm_48_6, imm_32_6, imm_16_6, imm_8_6};

    //starting at byte 10
    wire [47:0] imm_48_7;
    wire [47:0] imm_32_7;
    wire [47:0] imm_16_7;
    wire [47:0] imm_8_7;
    assign imm_48_7 = {imm15, imm14, imm13, imm12, imm11, imm10};
    sext_32_to_48 penis32(.in({imm13, imm12, imm11, imm10}), .out(imm_32_7));
    sext_16_to_48 penis33(.in({imm11, imm10}), .out(imm_16_7));
    sext_8_to_48 penis34(.in(imm10), .out(imm_8_7));
    wire [191:0] imm_10_concat;
    assign imm_10_concat = {imm_48_7, imm_32_7, imm_16_7, imm_8_7};

    //starting at byte 11
    wire [47:0] imm_48_8;
    wire [47:0] imm_32_8;
    wire [47:0] imm_16_8;
    wire [47:0] imm_8_8;
    assign imm_48_8 = {8'b00000000, imm15, imm14, imm13, imm12, imm11};
    sext_32_to_48 penis35(.in({imm14, imm13, imm12, imm11}), .out(imm_32_8));
    sext_16_to_48 penis36(.in({imm12, imm11}), .out(imm_16_8));
    sext_8_to_48 penis37(.in(imm11), .out(imm_8_8));
    wire [191:0] imm_11_concat;
    assign imm_11_concat = {imm_48_8, imm_32_8, imm_16_8, imm_8_8};

    //////////////////////////////////////////
    //             displacement            //
    ////////////////////////////////////////

    //displacements
    wire [7:0] disp2, disp3, disp4, disp5, disp6, disp7, disp8, disp9, disp10;
    assign disp2 = B2;
    assign disp3 = B3;
    assign disp4 = B4;
    assign disp5 = B5;
    assign disp6 = B6;
    assign disp7 = B7;
    assign disp8 = B8;
    assign disp9 = B9;
    assign disp10 = B10;


    //starting at byte 2
    wire [31:0] disp_32_0;
    wire [31:0] disp_16_0;
    wire [31:0] disp_8_0;
    assign disp_32_0 = {disp5, disp4, disp3, disp2};
    sext_16_to_32 penis0(.in({disp3, disp2}), .out(disp_16_0));
    sext_8_to_32 penis1(.in(disp2), .out(disp_8_0));
    wire [127:0] disp_0_concat;
    assign disp_0_concat = {disp_32_0, disp_16_0, disp_8_0, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_0;
    assign imm_total_concat_0 = {imm_6_concat, imm_4_concat, imm_3_concat, imm_2_concat};

    wire [319:0] disp_imm_concat_0;
    assign disp_imm_concat_0 = {imm_total_concat_0, disp_0_concat};


    //starting at byte 3
    wire [31:0] disp_32_1;
    wire [31:0] disp_16_1;
    wire [31:0] disp_8_1;
    assign disp_32_1 = {disp6, disp5, disp4, disp3};
    sext_16_to_32 penis2(.in({disp4, disp3}), .out(disp_16_1));
    sext_8_to_32 penis3(.in(disp3), .out(disp_8_1));
    wire [127:0] disp_1_concat;
    assign disp_1_concat = {disp_32_1, disp_16_1, disp_8_1, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_1;
    assign imm_total_concat_1 = {imm_7_concat, imm_5_concat, imm_4_concat, imm_3_concat};

    wire [319:0] disp_imm_concat_1;
    assign disp_imm_concat_1 = {imm_total_concat_1, disp_1_concat};
        


    //starting at byte 4
    wire [31:0] disp_32_2;
    wire [31:0] disp_16_2;
    wire [31:0] disp_8_2;
    assign disp_32_2 = {disp7, disp6, disp5, disp4};
    sext_16_to_32 penis4(.in({disp5, disp4}), .out(disp_16_2));
    sext_8_to_32 penis5(.in(disp4), .out(disp_8_2));
    wire [127:0] disp_2_concat;
    assign disp_2_concat = {disp_32_2, disp_16_2, disp_8_2, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_2;
    assign imm_total_concat_2 = {imm_8_concat, imm_6_concat, imm_5_concat, imm_4_concat};

    wire [319:0] disp_imm_concat_2;
    assign disp_imm_concat_2 = {imm_total_concat_2, disp_2_concat};



    //starting at byte 5
    wire [31:0] disp_32_3;
    wire [31:0] disp_16_3;
    wire [31:0] disp_8_3;
    assign disp_32_3 = {disp8, disp7, disp6, disp5};
    sext_16_to_32 penis6(.in({disp6, disp5}), .out(disp_16_3));
    sext_8_to_32 penis7(.in(disp5), .out(disp_8_3));
    wire [127:0] disp_3_concat;
    assign disp_3_concat = {disp_32_3, disp_16_3, disp_8_3, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_3;
    assign imm_total_concat_3 = {imm_9_concat, imm_7_concat, imm_6_concat, imm_5_concat};

    wire [319:0] disp_imm_concat_3;
    assign disp_imm_concat_3 = {imm_total_concat_3, disp_3_concat};



    //starting at byte 6
    wire [31:0] disp_32_4;
    wire [31:0] disp_16_4;
    wire [31:0] disp_8_4;
    assign disp_32_4 = {disp9, disp8, disp7, disp6};
    sext_16_to_32 penis8(.in({disp7, disp6}), .out(disp_16_4));
    sext_8_to_32 penis9(.in(disp6), .out(disp_8_4));
    wire [127:0] disp_4_concat;
    assign disp_4_concat = {disp_32_4, disp_16_4, disp_8_4, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_4;
    assign imm_total_concat_4 = {imm_10_concat, imm_8_concat, imm_7_concat, imm_6_concat};

    wire [319:0] disp_imm_concat_4;
    assign disp_imm_concat_4 = {imm_total_concat_4, disp_4_concat};



    //starting at byte 7
    wire [31:0] disp_32_5;
    wire [31:0] disp_16_5;
    wire [31:0] disp_8_5;
    assign disp_32_5 = {disp10, disp9, disp8, disp7};
    sext_16_to_32 penis10(.in({disp8, disp7}), .out(disp_16_5));
    sext_8_to_32 penis11(.in(disp7), .out(disp_8_5));
    wire [127:0] disp_5_concat;
    assign disp_5_concat = {disp_32_5, disp_16_5, disp_8_5, 32'd0};

    //immediate
    wire [191:0] imm_total_concat_5;
    assign imm_total_concat_5 = {imm_11_concat, imm_9_concat, imm_8_concat, imm_7_concat};

    wire [319:0] disp_imm_concat_5;
    assign disp_imm_concat_5 = {imm_total_concat_5, disp_5_concat};

    wire [191:0] imm_total_concat_noMod;
    assign imm_total_concat_0 = {imm_5_concat, imm_3_concat, imm_2_concat, imm_1_concat};
    wire [319:0] disp_imm_concat_noMod;
    assign disp_imm_concat_noMod = {imm_total_concat_noMod, 128'd0};
        



    wire [6:0] packet_select
    disp_sel d_s(.num_prefixes_onehot(num_prefixes_onehot), .is_double_opcode(isDouble), .is_MOD(isMOD), .is_SIB(isSIB), .disp_sel(packet_select));

    wire [2239:0] disp_imm_concat;
    assign disp_imm_concat = {disp_imm_concat_5, disp_imm_concat_4, disp_imm_concat_3, disp_imm_concat_2, disp_imm_concat_1, disp_imm_concat_0, disp_imm_concat_noMod};

    wire [319:0] selected_packet;
    muxnm_tristate #(7, 128) mxt_disp(.in(disp_imm_concat), .sel(packet_select), .out(selected_packet));

    wire [31:0] selected_disp;
    muxnm_tristate #(4, 32) mxt_disp_32(.in(selected_packet[127:0]), .sel(disp_size_select), .out(selected_disp));

    wire [47:0] selected_imm;
    muxnm_tree #(2, 48) mxt_imm(.in(selected_packet[319:128]), .sel(imm_size_select), .out(selected_imm));

    assign immediate = selected_imm;
    assign displacement = selected_disp;
    
endmodule