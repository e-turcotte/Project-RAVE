module pulseGen(
    input clk,
    input signal,
    output pulse
);

or2$ pipeGen(toPipeline, signal, signal);

wire buf1, buf2, buf3,buf4, buf5, buf6, buf7;

or2$ hlp(a, toPipeline,clk);
inv1$ a1(buf1, a);
inv1$ a2(buf2, buf1);
inv1$ a3(buf3, buf2);
inv1$ a4(buf4, buf3);
inv1$ a5(buf5, buf4);
inv1$ a6(buf6, buf5);
inv1$ a7(buf7, buf6);
or2$ a8(pulse, buf7, signal);
// or2$  a7(pulse, clk, pulse_out);
endmodule