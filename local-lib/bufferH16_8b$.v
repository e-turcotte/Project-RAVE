module bufferH16_8b$(
    input [7:0] in,
    output [7:0] out
    );

bufferH16$ b0(out[0], in[0]);
bufferH16$ b1(out[1], in[1]);
bufferH16$ b2(out[2], in[2]);
bufferH16$ b3(out[3], in[3]);
bufferH16$ b4(out[4], in[4]);
bufferH16$ b5(out[5], in[5]);
bufferH16$ b6(out[6], in[6]);
bufferH16$ b7(out[7], in[7]);

endmodule