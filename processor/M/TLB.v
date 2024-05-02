//in MEM
//  -time to get PA:          ~1.43ns
//  -time to exception logic: ~2.5ns
module TLB(
    input clk,
    input [31:0] address, //used to lookup
    input RW_in,
    input is_mem_request, //if 1, then we are doing a memory request, else - no prot exception should be thrown

    input [159:0] VP, //unpacked, do wire concatenation in TOP
    input [159:0] PF,
    input [7:0] entry_v,
    input [7:0] entry_P,
    input [7:0] entry_RW, //read or write (im guessing 0 is read only)
    input [7:0] entry_PCD, //PCD disable - 1 means this entry is disabled for normal mem accesses since it is for MMIO

    output [19:0] PF_out,
    output PCD_out,
    output miss,
    output hit, //if page is valid, present and tag hit - 1 if hit
    output protection_exception //if RW doesn't match entry_RW - 1 if exception
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
    
    wire entry_v_out, entry_p_out, entry_rw_out, entry_PCD_out;
    //mux out the PF, V, P, RW
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(20)) PF_out_mux(.in(PF), .sel(is_eq), .out(PF_out));
    
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_v_mux(.in(entry_v), .sel(is_eq), .out(entry_v_out));
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_p_mux(.in(entry_P), .sel(is_eq), .out(entry_p_out));
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_rw_mux(.in(entry_RW), .sel(is_eq), .out(entry_rw_out));
    muxnm_tristate #(.NUM_INPUTS(8), .DATA_WIDTH(1)) entry_PCD_mux(.in(entry_PCD), .sel(is_eq), .out(entry_PCD_out));

    wire hit_gen, miss_gen, present_valid, RW_match, is_mem_request_inv, RW_match_inv, hit_gen2;
    inv1$ i1(.out(is_mem_request_inv), .in(is_mem_request));
    inv1$ i2(.out(RW_match_inv), .in(RW_match));

    equaln #(.WIDTH(8)) is_miss_eqn(.a(is_eq), .b(8'h0), .eq(miss_gen)); //out will be 0 if any of the tags match
    inv1$ i0(.out(hit_gen), .in(miss_gen));

    xnor2$ x0(.out(RW_match), .in0(entry_rw_out), .in1(RW_in)); //will be 1 if they match
    and2$ a0(.out(present_valid), .in0(entry_v_out), .in1(entry_p_out)); //if entry_v_out and entry_p_out are both 1

    and2$ a1(.out(hit_gen2), .in0(hit_gen), .in1(present_valid));

    or2$ a2 (.out(hit), .in0(is_mem_request_inv), .in1(hit_gen2));
    inv1$ n0(.out(miss), .in(hit));

    andn #(.NUM_INPUTS(3)) a3(.in({hit_gen2, is_mem_request, RW_match_inv}), .out(protection_exception));

    // or2$ a3(.out(hit_gen2), .in0(hit_gen), .in1(is_mem_request_inv));
    // and2$ a4(.out(miss_gen2), .in0(miss_gen), .in1(is_mem_request));
        
    // and2$ a1(.out(hit), .in0(hit_gen2), .in1(present_valid));
    // and2$ n0(.out(miss), .in0(miss_gen2), .in1(present_valid));

    // and2$ a2(.out(protection_exception), .in0(hit_gen2), .in1(RW_match));

    assign PCD_out = entry_PCD_out;

endmodule
