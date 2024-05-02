module prefix_d (
    //input [127:0] packet,
    input clk,
    input [7:0] prefix1, prefix2, prefix3,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_seg_override,
    output is_opsize_override,
    output [1:0] num_prefixes_encoded, //sum of all prefixes (not onehot)
    output [3:0] num_prefixes_onehot //onehot encoding of num_prefixes
    );

//num_prefixes_onehot
    //0001: 0 prefixes
    //0010: 1 prefix
    //0100: 2 prefixes
    //1000: 3 prefixes

    // assign prefix1 = packet[127:120];
    // assign prefix2 = packet[119:112];
    // assign prefix3 = packet[111:104];

    wire is_rep1_temp, is_rep2_temp, is_rep3_temp;
    wire [5:0] seg_override1_temp, seg_override2_temp, seg_override3_temp;
    wire is_seg_override1_temp, is_seg_override2_temp, is_seg_override3_temp;
    wire is_opsize_override1_temp, is_opsize_override2_temp, is_opsize_override3_temp;
    wire hit1, hit2, hit3, miss1, miss2, miss3;
    
    prefix_cmp prefix_cmp1( //0.5ns in parallel
        .prefix(prefix1),
        .is_rep(is_rep1_temp),
        .seg_override(seg_override1_temp),
        .is_seg_override(is_seg_override1_temp),
        .is_opsize_override(is_opsize_override1_temp),
        .miss(miss1),
        .hit(hit1)
    );

    prefix_cmp prefix_cmp2(
        .prefix(prefix2),
        .is_rep(is_rep2_temp),
        .seg_override(seg_override2_temp),
        .is_seg_override(is_seg_override2_temp),
        .is_opsize_override(is_opsize_override2_temp),
        .miss(miss2),
        .hit(hit2)
    );

    prefix_cmp prefix_cmp3(
        .prefix(prefix3),
        .is_rep(is_rep3_temp),
        .seg_override(seg_override3_temp),
        .is_seg_override(is_seg_override3_temp),
        .is_opsize_override(is_opsize_override3_temp),
        .miss(miss3),
        .hit(hit3)
    );

    wire [32:0] pref_packet1, pref_packet2, pref_packet3, pref_packet4, pref_packet_out;
    wire [3:0] mux_sel;

    assign        mux_sel[3] = miss1;
    and2$ a0(.out(mux_sel[2]), .in0(hit1), .in1(miss2));
    and3$ a1(.out(mux_sel[1]), .in0(hit1), .in1(hit2), .in2(miss3)); 
    and3$ a2(.out(mux_sel[0]), .in0(hit1), .in1(hit2), .in2(hit3)); 

    assign pref_packet4 = {2'b00, 4'b0001, 9'b000000000, 9'b000000000, 9'b000000000};
    assign pref_packet3 = {2'b01, 4'b0010, is_rep1_temp, seg_override1_temp, is_seg_override1_temp, is_opsize_override1_temp, 9'b000000000, 9'b000000000};
    assign pref_packet2 = {2'b10, 4'b0100, is_rep1_temp, seg_override1_temp, is_seg_override1_temp, is_opsize_override1_temp, 
                           is_rep2_temp, seg_override2_temp, is_seg_override2_temp, is_opsize_override2_temp, 9'b000000000};
    assign pref_packet1 = {2'b11, 4'b1000, is_rep1_temp, seg_override1_temp, is_seg_override1_temp, is_opsize_override1_temp, is_rep2_temp, seg_override2_temp, is_seg_override2_temp,
                           is_opsize_override2_temp, is_rep3_temp, seg_override3_temp, is_seg_override3_temp, is_opsize_override3_temp};

    muxnm_tristate #(.NUM_INPUTS(4), .DATA_WIDTH(33)) m0(.in({pref_packet4, pref_packet3, pref_packet2, pref_packet1}), .sel(mux_sel), .out(pref_packet_out));
    
    wire is_rep1, is_rep2, is_rep3;
    wire [5:0] seg_override1, seg_override2, seg_override3;
    wire is_seg_override1, is_seg_override2, is_seg_override3;
    wire is_opsize_override1, is_opsize_override2, is_opsize_override3;

    assign num_prefixes_encoded = pref_packet_out[32:31];  //2
    assign num_prefixes_onehot = pref_packet_out[30:27];   //4

    assign is_rep1 = pref_packet_out[26];                  //1  
    assign seg_override1 = pref_packet_out[25:20];         //6
    assign is_seg_override1 = pref_packet_out[19];         //1
    assign is_opsize_override1 = pref_packet_out[18];      //1

    assign is_rep2 = pref_packet_out[17];                  //1
    assign seg_override2 = pref_packet_out[16:11];         //6
    assign is_seg_override2 = pref_packet_out[10];          //1 
    assign is_opsize_override2 = pref_packet_out[9];       //1

    assign is_rep3 = pref_packet_out[8];                   //1
    assign seg_override3 = pref_packet_out[7:2];           //6
    assign is_seg_override3 = pref_packet_out[1];          //1
    assign is_opsize_override3 = pref_packet_out[0];       //1
        
    or3$ o0(.out(is_rep), .in0(is_rep1), .in1(is_rep2), .in2(is_rep3)); //0.35ns in parallel
    
    or3$ o1(.out(seg_override[0]), .in0(seg_override1[0]), .in1(seg_override2[0]), .in2(seg_override3[0]));
    or3$ o2(.out(seg_override[1]), .in0(seg_override1[1]), .in1(seg_override2[1]), .in2(seg_override3[1]));
    or3$ o3(.out(seg_override[2]), .in0(seg_override1[2]), .in1(seg_override2[2]), .in2(seg_override3[2]));
    or3$ o4(.out(seg_override[3]), .in0(seg_override1[3]), .in1(seg_override2[3]), .in2(seg_override3[3]));
    or3$ o5(.out(seg_override[4]), .in0(seg_override1[4]), .in1(seg_override2[4]), .in2(seg_override3[4]));
    or3$ o6(.out(seg_override[5]), .in0(seg_override1[5]), .in1(seg_override2[5]), .in2(seg_override3[5]));

    or3$ o7(.out(is_seg_override), .in0(is_seg_override1), .in1(is_seg_override2), .in2(is_seg_override3));

    or3$ o8(.out(is_opsize_override), .in0(is_opsize_override1), .in1(is_opsize_override2), .in2(is_opsize_override3)); 

endmodule

 
module prefix_cmp(
    input [7:0] prefix,
    output is_rep,
    output [5:0] seg_override, //onehot
    output is_seg_override,
    output is_opsize_override,
    output miss,
    output hit
    ); 
 
 //total time: 0.7ns

    wire [7:0] rep, seg_cs, seg_ss, seg_ds, seg_es, seg_fs, seg_gs, opsize;
    wire [7:0] prefix_temp;

    //hardcode known prefixes
    assign rep    = 8'hF3;
    assign seg_cs = 8'h2E;
    assign seg_ss = 8'h36;
    assign seg_ds = 8'h3E;
    assign seg_es = 8'h26;
    assign seg_fs = 8'h64;
    assign seg_gs = 8'h65;
    assign opsize = 8'h66;

    //need to buffer for fanout - done in TOP so not needed here
    //bufferH16_8b$ b0(prefix, prefix_temp); //0.24ns

    assign prefix_temp = prefix;
    equaln #(.WIDTH(8)) rep_mux(.a(rep), .b(prefix_temp), .eq(is_rep)); //0.5ns in parallel
    equaln #(.WIDTH(8)) seg_cs_mux(.a(seg_cs), .b(prefix_temp), .eq(seg_override[0]));
    equaln #(.WIDTH(8)) seg_ss_mux(.a(seg_ss), .b(prefix_temp), .eq(seg_override[1]));
    equaln #(.WIDTH(8)) seg_ds_mux(.a(seg_ds), .b(prefix_temp), .eq(seg_override[2]));
    equaln #(.WIDTH(8)) seg_es_mux(.a(seg_es), .b(prefix_temp), .eq(seg_override[3]));
    equaln #(.WIDTH(8)) seg_fs_mux(.a(seg_fs), .b(prefix_temp), .eq(seg_override[4]));
    equaln #(.WIDTH(8)) seg_gs_mux(.a(seg_gs), .b(prefix_temp), .eq(seg_override[5]));
    equaln #(.WIDTH(8)) opsize_mux(.a(opsize), .b(prefix_temp), .eq(is_opsize_override));

    wire nor_1, nor_2, nor_3;
    nor2$ n1(.out(nor_1), .in0(seg_override[0]), .in1(seg_override[1])); //0.2ns
    nor2$ n2(.out(nor_2), .in0(seg_override[2]), .in1(seg_override[3]));
    nor2$ n3(.out(nor_3), .in0(seg_override[4]), .in1(seg_override[5]));
    nand3$ n4(.out(is_seg_override), .in0(nor_1), .in1(nor_2), .in2(nor_3)); //0.2ns

    equaln #(.WIDTH(8)) has_prefix_mux(.a({is_rep, seg_override, is_opsize_override}), .b(8'h00), .eq(miss));
    inv1$ i0(.out(hit), .in(miss)); //0.15ns

endmodule


