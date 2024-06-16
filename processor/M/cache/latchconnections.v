module latchconnections #(parameter MSIZE=128) (input [63:0] cache_out_data,
                                                input [127:0] cache_out_ptcinfo,
                                                input cache_out_valid,
                                                input [3:0] cache_wake,
                                                input [6:0] cache_ptcid,

                                                input [3:0] mshr_wake,
                                                input [6:0] mshr_ptcid_e, mshr_ptcid_o,
                                                input [7:0] mshr_qslot_e_in, mshr_qslot_o_in, mshr_qslot_e_out, mshr_qslot_o_out,

                                                input [127:0] cacheline_e_bus_in_data, cacheline_o_bus_in_data,
                                                input [255:0] cacheline_e_bus_in_ptcinfo, cacheline_o_bus_in_ptcinfo,
                         
                                                input [MSIZE*8-1:0] new_m_M_EX, old_m_M_EX,
                                                input [7:0] modify_M_EX_latch,
                                                
                                                input [63:0] wb_res1, wb_res2, wb_res3, wb_res4,
                                                input [127:0] wb_res1_ptcinfo, wb_res2_ptcinfo, wb_res3_ptcinfo, wb_res4_ptcinfo);

    wire [6:0] old_inst_ptcid [0:7];
    wire [3:0] old_wake [0:7], new_wake [0:7];
    wire [255:0] old_ops [0:7], new_ops [0:7];
    wire [511:0] old_op_ptcinfos [0:7];
    wire old_valid [0:7], new_valid [0:7];

    wire [7:0] cache_qslot;
    wire [3:0] guarded_cache_wake [0:7], guarded_mshr_wake [0:7];
    wire [127:0] guarded_cache_out_ptcinfo;

    muxnm_tree #(.SEL_WIDTH(1), .DATA_WIDTH(128)) m1fhgcvbhj(.in({cache_out_ptcinfo,128'h0}), .sel(cache_out_valid), .out(guarded_cache_out_ptcinfo));

    wire [63:0] fwd_cache_data;
    wire cache_mod_vect;

    bypassmech #(.NUM_PROSPECTS(4), .NUM_OPERANDS(1)) cacheoutdf(.prospective_data({wb_res4,wb_res3,wb_res2,wb_res1}), .prospective_ptc({wb_res4_ptcinfo,wb_res3_ptcinfo,wb_res2_ptcinfo,wb_res1_ptcinfo}),
                                                                 .operand_data(cache_out_data), .operand_ptc({guarded_cache_out_ptcinfo}),
                                                                 .new_data(fwd_cache_data), .modify(cache_mod_vect));

    genvar i;
    generate

        for (i = 0; i < 8; i = i + 1) begin : M_EX_q_modifiers

            assign old_inst_ptcid[i] = old_m_M_EX[i*MSIZE + 779:i*MSIZE + 773];
            assign old_wake[i] = old_m_M_EX[i*MSIZE + 772:i*MSIZE + 769];
            assign old_ops[i] = old_m_M_EX[i*MSIZE + 768:i*MSIZE + 513];
            assign old_op_ptcinfos[i] = old_m_M_EX[i*MSIZE + 512:i*MSIZE + 1];
            assign old_valid[i] = old_m_M_EX[i*MSIZE];

            assign new_valid[i] = old_valid[i]; //TODO:

            assign new_m_M_EX[MSIZE*(i+1)-1:MSIZE*i] = {old_inst_ptcid[i],new_wake[i],new_ops[i],old_op_ptcinfos[i],new_valid[i]};

            wire [3:0] op_mod_vect;

            bypassmech #(.NUM_PROSPECTS(9), .NUM_OPERANDS(4)) mexqdf(.prospective_data({wb_res4,wb_res3,wb_res2,wb_res1,fwd_cache_data,cacheline_e_bus_in_data,cacheline_o_bus_in_data}),
                                                                     .prospective_ptc({wb_res4_ptcinfo,wb_res3_ptcinfo,wb_res2_ptcinfo,wb_res1_ptcinfo,guarded_cache_out_ptcinfo,cacheline_e_bus_in_ptcinfo,cacheline_o_bus_in_ptcinfo}),
                                                                     .operand_data({old_ops[i]}), .operand_ptc({old_op_ptcinfos[i]}),
                                                                     .new_data({new_ops[i]}), .modify(op_mod_vect));

            equaln #(.WIDTH(7)) eq123(.a(old_inst_ptcid[i]), .b(cache_ptcid), .eq(cache_qslot[i]));
            equaln #(.WIDTH(7)) eq456(.a(old_inst_ptcid[i]), .b(mshr_ptcid_e), .eq(mshr_qslot_e_in[i]));
            equaln #(.WIDTH(7)) eq789(.a(old_inst_ptcid[i]), .b(mshr_ptcid_o), .eq(mshr_qslot_o_in[i]));

            and2$ gabc(.out(guarded_cache_wake[i][0]), .in0(cache_qslot[i]), .in1(cache_wake[0]));
            and2$ gdef(.out(guarded_cache_wake[i][1]), .in0(cache_qslot[i]), .in1(cache_wake[1]));
            and2$ gghi(.out(guarded_cache_wake[i][2]), .in0(cache_qslot[i]), .in1(cache_wake[2]));
            and2$ gjkl(.out(guarded_cache_wake[i][3]), .in0(cache_qslot[i]), .in1(cache_wake[3]));
            and2$ gmno(.out(guarded_mshr_wake[i][0]), .in0(mshr_qslot_e_out[i]), .in1(mshr_wake[0]));
            and2$ gpqr(.out(guarded_mshr_wake[i][1]), .in0(mshr_qslot_e_out[i]), .in1(mshr_wake[1]));
            and2$ gstu(.out(guarded_mshr_wake[i][2]), .in0(mshr_qslot_o_out[i]), .in1(mshr_wake[2]));
            and2$ gvwx(.out(guarded_mshr_wake[i][3]), .in0(mshr_qslot_o_out[i]), .in1(mshr_wake[3]));

            or3$ gx0(.out(new_wake[i][0]), .in0(old_wake[i][0]), .in1(guarded_cache_wake[i][0]), .in2(guarded_mshr_wake[i][0]));
            or3$ gx1(.out(new_wake[i][1]), .in0(old_wake[i][1]), .in1(guarded_cache_wake[i][1]), .in2(guarded_mshr_wake[i][1]));
            or3$ gx2(.out(new_wake[i][2]), .in0(old_wake[i][2]), .in1(guarded_cache_wake[i][2]), .in2(guarded_mshr_wake[i][2]));
            or3$ gx3(.out(new_wake[i][3]), .in0(old_wake[i][3]), .in1(guarded_cache_wake[i][3]), .in2(guarded_mshr_wake[i][3]));

            orn #(.NUM_INPUTS(7)) or0(.in({mod_vect,cache_qslot[i],mshr_qslot_e_out[i],mshr_qslot_o_out[i]}), .out(modify_M_EX_latch[i]));
        end
    endgenerate

endmodule