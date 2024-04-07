module opcode_decode ( // keep in mind tristate mux can be very buggy, so just put a hot swap for a normal mux if needed. This current implementation
    input [7:0] byte0, // is assuming a 4 bit one hot encoding from prefix decode with states being 0001, 0010, 0100, 1000 for 0 prefix, 1 prefix, 2 prefix,
    input [7:0] byte1, // and 3 prefix respectively. This is just a template, so you can change the inputs to be whatever you want
    input [7:0] byte2,
    input [7:0] byte3,
    input [7:0] byte4,
    input [7:0] byte5,
    input [3:0] sel,
    output [255:0] out
);
    wire [255:0] opcode0, opcode1, opcode2, opcode3;
    opcode_cs_gen cs_gen1(
        .byte0(byte0),
        .byte1(byte1),
        .byte2(byte2),
        .out(opcode0)
    );
    opcode_cs_gen cs_gen2(
        .byte0(byte1),
        .byte1(byte2),
        .byte2(byte3),
        .out(opcode1)
    );
    opcode_cs_gen cs_gen3(
        .byte0(byte2),
        .byte1(byte3),
        .byte2(byte4),
        .out(opcode2)
    );
    opcode_cs_gen cs_gen4(
        .byte0(byte3),
        .byte1(byte4),
        .byte2(byte5),
        .out(opcode3)
    );

    muxnm_tristate #(
        .NUM_INPUTS(4),
        .DATA_WIDTH(256)
    ) mux(
        .in({opcode0, opcode1, opcode2, opcode3}),
        .sel(sel),
        .out(out)
    );


endmodule

module opcode_cs_gen(
    input [7:0] byte0,
    input [7:0] byte1,
    input [7:0] byte2,
    output [256:0] out
);
    wire is_double_op;
    wire [255:0] single_op_lut_out;
    wire [255:0] double_op_lut_out;
    wire [255:0] lut_out;
    equaln #(.WIDTH(8)) double_op(.a(byte0), .b(8'h0F), .eq(is_double_op));
    rom single_op_lut(.addr(byte0), .data(single_op_lut_out));
    rom double_op_lut(.addr(byte1), .data(double_op_lut_out));
    muxnm_tristate #(
        .NUM_INPUTS(2),
        .DATA_WIDTH(256)
    ) mux(
        .in({single_op_lut_out, double_op_lut_out}),
        .sel(is_double_op),
        .out(lut_out)
    ); //up until here you get the output of the LUTS, if there is a single or double opcode

    // after this point change this stuff after everything is finalized,  this is just a template; essentially we want a mux to 
    //select signals based on the extended opcode (not double opcode) to override certain signals, rn its just a mux, but might need to make a LUT for this too
    wire mux_out;
    muxnm_tristate #(
        .NUM_INPUTS(32),
        .DATA_WIDTH(1)
    ) mux2(
        .in({lut_out, byte2}),
        .sel(is_double_op),
        .out(mux_out)
    );

    assign out[255:0] = lut_out;
    assign out[256] = mux_out;

    //this was the readmemh when each rom only had 32 bits per row, but now they have 256 bits per row, so you're just gonna have to tweak it

    //also realize if you can cutting down the bits per row should not rlly do anything in terms of  how fast you can clock the CPU
    //bc the width is in parallel

    initial $readmemh("rom/rom0.txt",ROM_GEN[0].ROM.mem);
    initial $readmemh("rom/rom1.txt",ROM_GEN[1].ROM.mem);
    initial $readmemh("rom/rom2.txt",ROM_GEN[2].ROM.mem);
    initial $readmemh("rom/rom3.txt",ROM_GEN[3].ROM.mem);
    initial $readmemh("rom/rom4.txt",ROM_GEN[4].ROM.mem);
    initial $readmemh("rom/rom5.txt",ROM_GEN[5].ROM.mem);
    initial $readmemh("rom/rom6.txt",ROM_GEN[6].ROM.mem);
    initial $readmemh("rom/rom7.txt",ROM_GEN[7].ROM.mem);



    
endmodule