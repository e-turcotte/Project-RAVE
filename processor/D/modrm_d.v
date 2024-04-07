module modrm_decode (
    input [7:0] byte0,
    input [7:0] byte1,
    input [7:0] byte2,
    input [7:0] byte3,
    input [7:0] byte4,
    input [2:0] prefix_sel,
    input [1:0] opcode_sel,
    output [255:0] out
);

    wire [255:0] modrm0, modrm1, modrm2, modrm3, modrm4;
    modrm_cs_gen cs_gen1(
        .byte0(byte0),
        .out(modrm0)
    );
    modrm_cs_gen cs_gen2(
        .byte0(byte1),
        .out(modrm1)
    );
    modrm_cs_gen cs_gen3(
        .byte0(byte2),
        .out(modrm2)
    );
    modrm_cs_gen cs_gen4(
        .byte0(byte3),
        .out(modrm3)
    );
    modrm_cs_gen cs_gen5(
        .byte0(byte4),
        .out(modrm4)
    );

    wire [255:0] single_op_modrm_out, double_op_modrm_out;

    muxnm_tristate #(
        .NUM_INPUTS(4),
        .DATA_WIDTH(256)
    ) mux1(
        .in({modrm0, modrm1, modrm2, modrm3}),
        .sel(prefix_sel),
        .out(single_op_modrm_out)
    );

    muxnm_tristate #(
        .NUM_INPUTS(4),
        .DATA_WIDTH(256)
    ) mux2(
        .in({modrm1, modrm2, modrm3, modrm4}),
        .sel(prefix_sel),
        .out(double_op_modrm_out)
    );

    muxnm_tristate #(
        .NUM_INPUTS(2),
        .DATA_WIDTH(256)
    ) mux3(
        .in({single_op_modrm_out, double_op_modrm_out}),
        .sel(opcode_sel),
        .out(out)
    );
    
    
endmodule

module modrm_cs_gen (
    input [7:0] byte0,
    output [255:0] out
);

    wire[255:0] modrm_lut_out;
    rom modrm_lut(.addr(byte0), .data(modrm_lut_out));
    assign out = modrm_lut_out;


    //this is dummy data and also the bit width for each row is incorrect so fix later
    initial $readmemh("rom/rom0.txt",ROM_GEN[0].ROM.mem);
    initial $readmemh("rom/rom1.txt",ROM_GEN[1].ROM.mem);
    initial $readmemh("rom/rom2.txt",ROM_GEN[2].ROM.mem);
    initial $readmemh("rom/rom3.txt",ROM_GEN[3].ROM.mem);
    initial $readmemh("rom/rom4.txt",ROM_GEN[4].ROM.mem);
    initial $readmemh("rom/rom5.txt",ROM_GEN[5].ROM.mem);
    initial $readmemh("rom/rom6.txt",ROM_GEN[6].ROM.mem);
    initial $readmemh("rom/rom7.txt",ROM_GEN[7].ROM.mem);
    
endmodule