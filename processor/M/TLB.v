//in MEM
//  -time to get PA:          ~1.43ns
//  -time to exception logic: ~2.5ns
module TLB(
    input wire clk,
    input wire [31:0] address, //used to lookup
    input wire RW_in,

    input wire [159:0] VP, //unpacked, do wire concatenation in TOP
    input wire [159:0] PF,
    input wire [7:0] entry_v,
    input wire [7:0] entry_P,
    input wire [7:0] entry_RW, //read or write (im guessing 0 is read only)

    output wire [19:0] PF_out,
    output wire miss,
    output wire hit, //if page is valid, present and tag hit - 1 if hit
    output wire protection_exception //if RW doesn't match entry_RW - 1 if exception
    );

    wire [19:0] vp_to_lookup; //20 bit VPN
    wire [7:0] is_eq;

    assign vp_to_lookup = address[31:12];
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : tag_compare
            equaln #(.WIDTH(20)) eq0(.a(vp_to_lookup), .b(VP[i*20 + 19 : i*20]), .eq(is_eq[i]));
        end
    endgenerate
    
    wire entry_v_out, entry_p_out, entry_rw_out;
    //mux out the PF, V, P, RW
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(20)) PF_out_mux(.in(PF), .sel(is_eq), .out(PF_out));
    
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_v_mux(.in(entry_v), .sel(is_eq), .out(entry_v_out));
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_p_mux(.in(entry_P), .sel(is_eq), .out(entry_p_out));
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_rw_mux(.in(entry_RW), .sel(is_eq), .out(entry_rw_out));

    wire hit_gen, miss_gen, present_valid, RW_match;
    equaln #(.WIDTH(8)) is_miss_eqn(.a(is_eq), .b(8'h0), .eq(miss_gen)); //out will be 0 if any of the tags match
    inv1$ i0(.out(hit_gen), .in(miss_gen));

    xor2$ x0(.out(RW_match), .in0(entry_rw_out), .in1(RW_in)); //will be 1 if they match
    and2$ a0(.out(present_valid), .in0(entry_v_out), .in1(entry_p_out)); //if entry_v_out and entry_p_out are both 1
        
    and2$ a1(.out(hit), .in0(hit_gen), .in1(present_valid));
    nand2$ n0(.out(miss), .in0(hit_gen), .in1(present_valid));

    and2$ a2(.out(protection_exception), .in0(hit_gen), .in1(RW_match));

endmodule
