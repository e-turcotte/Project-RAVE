module MEM_EX_Queued_Latches #(parameter M_WIDTH=8, N_WIDTH=8, Q_LENGTH=8) (input [M_WIDTH-1:0] m_din,
                                                                               input [N_WIDTH-1:0] n_din,
                                                                               input [M_WIDTH*Q_LENGTH-1:0] new_m_vector,
                                                                               input wr, rd,
                                                                               input [Q_LENGTH-1:0] modify_vector,
                                                                               input clr,
                                                                               input clk,
                                                                               output full, empty,
                                                                               output [M_WIDTH*Q_LENGTH-1:0] old_m_vector,
                                                                               output [M_WIDTH+N_WIDTH-1:0] dout);

      queuenm #(M_WIDTH, N_WIDTH, Q_LENGTH) q0(.m_din(m_din), .n_din(n_din), .new_m_vector(new_m_vector), .wr(wr), .rd(rd), .modify_vector(modify_vector), .clr(clr), .clk(clk), .full(full), .empty(empty), .old_m_vector(old_m_vector), .dout(dout));                                                                 

    integer file;
    initial begin
        file = $fopen("MEM_EX_latches.out", "w");
    end

    parameter mlen = M_WIDTH;
    parameter nlen = N_WIDTH;
    parameter qlen = Q_LENGTH;

    reg [(0+1)*(mlen+nlen)-1:0*(mlen+nlen)] all_outs[Q_LENGTH-1:0];
    integer k, latch_num;

    always @(posedge clk) begin        
        k = 0;
        all_outs[k] = q0.outs[(0+1)*(mlen+nlen)-1:0*(mlen+nlen)];
        k = 1;
        all_outs[k] = q0.outs[(1+1)*(mlen+nlen)-1:1*(mlen+nlen)];
        k = 2;
        all_outs[k] = q0.outs[(2+1)*(mlen+nlen)-1:2*(mlen+nlen)];
        k = 3;
        all_outs[k] = q0.outs[(3+1)*(mlen+nlen)-1:3*(mlen+nlen)];
        k = 4;
        all_outs[k] = q0.outs[(4+1)*(mlen+nlen)-1:4*(mlen+nlen)];
        k = 5;
        all_outs[k] = q0.outs[(5+1)*(mlen+nlen)-1:5*(mlen+nlen)];
        k = 6;
        all_outs[k] = q0.outs[(6+1)*(mlen+nlen)-1:6*(mlen+nlen)];
        k = 7;
        all_outs[k] = q0.outs[(7+1)*(mlen+nlen)-1:7*(mlen+nlen)];

		$display(file, "\n=============== MEM to EX Latch Values ===============\n");

        for (latch_num = 0; latch_num < qlen; latch_num = latch_num + 1) begin
            $fdisplay(file, "\t ==LATCH==: %d", latch_num);
            $fdisplay(file, "\t modifiable signals:");

            $fdisplay(file, "\t\t wake: %d", all_outs[latch_num][1072:1069]);
            $fdisplay(file, "\t\t op1_val: %d", all_outs[latch_num][1068:1005]);
            $fdisplay(file, "\t\t op2_val: %d", all_outs[latch_num][1004:941]);
            $fdisplay(file, "\t\t op3_val: %d", all_outs[latch_num][940:877]);
            $fdisplay(file, "\t\t op4_val: %d\n", all_outs[latch_num][876:813]); 

            $fdisplay(file, "\t\t op1_ptcinfo: %d", all_outs[latch_num][812:685]);
            $fdisplay(file, "\t\t op2_ptcinfo: %d", all_outs[latch_num][684:557]);
            $fdisplay(file, "\t\t op3_ptcinfo: %d", all_outs[latch_num][556:429]);
            $fdisplay(file, "\t\t op4_ptcinfo: %d", all_outs[latch_num][428:301]);

            $fdisplay(file, "\n\t non-modifiable signals:");

            $fdisplay(file, "\t\t valid: %d", all_outs[latch_num][300]);
            $fdisplay(file, "\t\t eip: %d", all_outs[latch_num][299:268]);
            $fdisplay(file, "\t\t IE: %d", all_outs[latch_num][267]);
            $fdisplay(file, "\t\t IE_type: %d", all_outs[latch_num][266:263]);
            $fdisplay(file, "\t\t BR_pred_target: %d", all_outs[latch_num][262:231]);
            $fdisplay(file, "\t\t BR_pred_T_NT: %d", all_outs[latch_num][230]);
            $fdisplay(file, "\t\t opsize: %d\n", all_outs[latch_num][229:228]); 

            $fdisplay(file, "\t\t dest1_addr: %d", all_outs[latch_num][227:196]);
            $fdisplay(file, "\t\t dest2_addr: %d", all_outs[latch_num][195:164]);
            $fdisplay(file, "\t\t dest3_addr: %d", all_outs[latch_num][163:132]);
            $fdisplay(file, "\t\t dest4_addr: %d\n", all_outs[latch_num][131:100]); 

            $fdisplay(file, "\t\t dest1_is_reg: %d", all_outs[latch_num][99]);
            $fdisplay(file, "\t\t dest2_is_reg: %d", all_outs[latch_num][98]);
            $fdisplay(file, "\t\t dest3_is_reg: %d", all_outs[latch_num][97]);
            $fdisplay(file, "\t\t dest4_is_reg: %d", all_outs[latch_num][96]);
            $fdisplay(file, "\t\t dest1_is_seg: %d", all_outs[latch_num][95]);
            $fdisplay(file, "\t\t dest2_is_seg: %d", all_outs[latch_num][94]);
            $fdisplay(file, "\t\t dest3_is_seg: %d", all_outs[latch_num][93]);
            $fdisplay(file, "\t\t dest4_is_seg: %d", all_outs[latch_num][92]);
            $fdisplay(file, "\t\t dest1_is_mem: %d", all_outs[latch_num][91]);
            $fdisplay(file, "\t\t dest2_is_mem: %d", all_outs[latch_num][90]);
            $fdisplay(file, "\t\t dest3_is_mem: %d", all_outs[latch_num][89]);
            $fdisplay(file, "\t\t dest4_is_mem: %d", all_outs[latch_num][88]);
            $fdisplay(file, "\t\t res1_ld_out: %d", all_outs[latch_num][87]);
            $fdisplay(file, "\t\t res2_ld_out: %d", all_outs[latch_num][86]);
            $fdisplay(file, "\t\t res3_ld_out: %d", all_outs[latch_num][85]);
            $fdisplay(file, "\t\t res4_ld_out: %d\n", all_outs[latch_num][84]); 

            $fdisplay(file, "\t\t aluk: %d", all_outs[latch_num][83:79]);
            $fdisplay(file, "\t\t mux_adder: %d", all_outs[latch_num][78:76]);
            $fdisplay(file, "\t\t mux_and_int: %d", all_outs[latch_num][75]);
            $fdisplay(file, "\t\t mux_shift: %d", all_outs[latch_num][74]);
            $fdisplay(file, "\t\t p_op: %d", all_outs[latch_num][73:37]);
            $fdisplay(file, "\t\t fmask: %d", all_outs[latch_num][36:20]); 
            $fdisplay(file, "\t\t conditionals: %d", all_outs[latch_num][19:18]);
            $fdisplay(file, "\t\t is_br: %d", all_outs[latch_num][17]);
            $fdisplay(file, "\t\t is_fp: %d", all_outs[latch_num][16]);
            $fdisplay(file, "\t\t CS: %d", all_outs[latch_num][15:0]);
        end

        
        $fdisplay(file, "\n");
    end
endmodule 

//  for reference, these are the outputs from MEM coming into the latch:

//modifiable signals:
//  [3:0] wake               //[1072:1069]
//  [63:0] op1_val           //[1068:1005]
//  [63:0] op2_val           //[1004:941]
//  [63:0] op3_val           //[940:877]
//  [63:0] op4_val           //[876:813]
//  [127:0] op1_ptcinfo      //[812:685]
//  [127:0] op2_ptcinfo      //[684:557]
//  [127:0] op3_ptcinfo      //[556:429]
//  [127:0] op4_ptcinfo      //[428:301]

//non-modifiable signals:

//  valid_out                   //[300]
//  [31:0] eip_out              //[299:268]
//  IE_out                      //[267]
//  [3:0] IE_type_out           //[266:263]
//  [31:0] BR_pred_target_out   //[262:231]
//  BR_pred_T_NT_out            //[230]

//  [1:0] opsize_out         //[229:228]
//  [31:0] dest1_addr        //[227:196]
//  [31:0] dest2_addr        //[195:164]
//  [31:0] dest3_addr        //[163:132]
//  [31:0] dest4_addr        //[131:100]
//  dest1_is_reg             //[99]
//  dest2_is_reg             //[98]
//  dest3_is_reg             //[97]
//  dest4_is_reg             //[96]
//  dest1_is_seg             //[95]
//  dest2_is_seg             //[94]
//  dest3_is_seg             //[93]
//  dest4_is_seg             //[92]
//  dest1_is_mem             //[91]  
//  dest2_is_mem             //[90]
//  dest3_is_mem             //[89]
//  dest4_is_mem             //[88]
//  res1_ld_out              //[87]
//  res2_ld_out              //[86]
//  res3_ld_out              //[85]
//  res4_ld_out              //[84]

//  [4:0] aluk_out,           //[83:79]  
//  [2:0] mux_adder_out       //[78:76]
//  mux_and_int_out           //[75]
//  mux_shift_out             //[74]
//  [36:0] p_op_out           //[73:37]  
//  [16:0] fmask_out          //[36:20]
//  [1:0] conditionals_out    //[19:18]
//  is_br_out,                //[17]
//  is_fp_out                 //[16]
//  [15:0] CS_out             //[15:0]
