module bufferH16_8b$(
    input [7:0] in,
    output [7:0] out
    );

bufferH16$ b0(.out(out[0]), .in(in[0]));
bufferH16$ b1(.out(out[1]), .in(in[1]));
bufferH16$ b2(.out(out[2]), .in(in[2]));
bufferH16$ b3(.out(out[3]), .in(in[3]));
bufferH16$ b4(.out(out[4]), .in(in[4]));
bufferH16$ b5(.out(out[5]), .in(in[5]));
bufferH16$ b6(.out(out[6]), .in(in[6]));
bufferH16$ b7(.out(out[7]), .in(in[7]));

endmodule

module bbufferH64_8b$ (
    input [7:0] in,
    output [7:0] out
);

bufferH64$ b0(.out(out[0]), .in(in[0]));
bufferH64$ b1(.out(out[1]), .in(in[1]));
bufferH64$ b2(.out(out[2]), .in(in[2]));
bufferH64$ b3(.out(out[3]), .in(in[3]));
bufferH64$ b4(.out(out[4]), .in(in[4]));
bufferH64$ b5(.out(out[5]), .in(in[5]));
bufferH64$ b6(.out(out[6]), .in(in[6]));
bufferH64$ b7(.out(out[7]), .in(in[7])); 
    
endmodule