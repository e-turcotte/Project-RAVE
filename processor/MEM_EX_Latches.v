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


      queuenm #(M_WIDTH, N_WIDTH, Q_LENGTH) q0(.m_din(m_din), .n_din(n_din), 
                .new_m_vector(new_m_vector), .wr(wr), .rd(rd), .modify_vector(modify_vector), 
                .clr(clr), .clk(clk), .full(full), .empty(empty), .old_m_vector(old_m_vector), .dout(dout));                                                                 

    integer file, cyc_cnt;
    initial begin
        cyc_cnt = 0;
        file = $fopen("MEM_EX_latches.out", "w");
    end

    parameter mlen = M_WIDTH;
    parameter nlen = N_WIDTH;
    parameter qlen = Q_LENGTH;

    reg [(0+1)*(mlen+nlen)-1:0*(mlen+nlen)] all_outs[Q_LENGTH-1:0];
    integer k, latch_num;

    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;

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

		$fdisplay(file, "\n=============== MEM to EX Latch Values ===============\n");

        $fdisplay(file, "\t Queue values: ");
        $fdisplay(file, "\t read: %b", rd);
        $fdisplay(file, "\t write: %b", wr);
        $fdisplay(file, "\t clear: %b", clr);
        $fdisplay(file, "\t full: %b", full);
        $fdisplay(file, "\t empty: %b", empty);

        for (latch_num = 0; latch_num < qlen; latch_num = latch_num + 1) begin
            $fdisplay(file, "\n\t ==LATCH==: %d", latch_num);
            $fdisplay(file, "\t modifiable signals:");

            $fdisplay(file, "\t\t PTC_ID: %b", all_outs[latch_num][1632:1626]);
            $fdisplay(file, "\t\t wake: %b", all_outs[latch_num][1625:1622]);
            $fdisplay(file, "\t\t op1_val: 0x%h", all_outs[latch_num][1621:1558]);
            $fdisplay(file, "\t\t op2_val: 0x%h", all_outs[latch_num][1557:1494]);
            $fdisplay(file, "\t\t op3_val: 0x%h", all_outs[latch_num][1493:1430]);
            $fdisplay(file, "\t\t op4_val: 0x%h\n", all_outs[latch_num][1429:1366]); 

            $fdisplay(file, "\t\t op1_ptcinfo: 0x%d", all_outs[latch_num][1365:1238]);
            $fdisplay(file, "\t\t op2_ptcinfo: 0x%h", all_outs[latch_num][1237:1110]);
            $fdisplay(file, "\t\t op3_ptcinfo: 0x%h", all_outs[latch_num][1106:982]);
            $fdisplay(file, "\t\t op4_ptcinfo: 0x%h", all_outs[latch_num][981:854]);
            $fdisplay(file, "\t\t valid: %d", all_outs[latch_num][853]);
            
            $fdisplay(file, "\n\t non-modifiable signals:");
            
            $fdisplay(file, "\t\t BP_alias: %b", all_outs[latchnum][852:847]);
            $fdisplay(file, "\t\t is_rep: %d", all_outs[latch_num][846]);
            $fdisplay(file, "\t\t is_imm: %d", all_outs[latch_num][845]);
            $fdisplay(file, "\t\t eip: 0x%h", all_outs[latch_num][844:813]);
            $fdisplay(file, "\t\t latched_eip: 0x%h", all_outs[latch_num][812:781]);
            $fdisplay(file, "\t\t IE: %d", all_outs[latch_num][780]);
            $fdisplay(file, "\t\t IE_type: %b", all_outs[latch_num][779:776]);
            $fdisplay(file, "\t\t BR_pred_target: 0x%h", all_outs[latch_num][775:744]);
            $fdisplay(file, "\t\t BR_pred_T_NT: %d", all_outs[latch_num][743]);
            $fdisplay(file, "\t\t opsize: %b\n", all_outs[latch_num][742:741]); 

            $fdisplay(file, "\t\t dest1_addr: 0x%h", all_outs[latch_num][740:709]);
            $fdisplay(file, "\t\t dest2_addr: 0x%h", all_outs[latch_num][708:677]);
            $fdisplay(file, "\t\t dest3_addr: 0x%h", all_outs[latch_num][676:645]);
            $fdisplay(file, "\t\t dest4_addr: 0x%h\n", all_outs[latch_num][644:613]);

            $fdisplay(file, "\t\t dest1_ptcinfo: 0x%h\n", all_outs[latch_num][612:485]);
            $fdisplay(file, "\t\t dest2_ptcinfo: 0x%h\n", all_outs[latch_num][484:357]);
            $fdisplay(file, "\t\t dest3_ptcinfo: 0x%h\n", all_outs[latch_num][356:229]);
            $fdisplay(file, "\t\t dest4_ptcinfo: 0x%h\n", all_outs[latch_num][228:101]);

            $fdisplay(file, "\t\t dest1_is_reg: %d", all_outs[latch_num][100]);
            $fdisplay(file, "\t\t dest2_is_reg: %d", all_outs[latch_num][99]);
            $fdisplay(file, "\t\t dest3_is_reg: %d", all_outs[latch_num][98]);
            $fdisplay(file, "\t\t dest4_is_reg: %d", all_outs[latch_num][97]);
            $fdisplay(file, "\t\t dest1_is_seg: %d", all_outs[latch_num][96]);
            $fdisplay(file, "\t\t dest2_is_seg: %d", all_outs[latch_num][95]);
            $fdisplay(file, "\t\t dest3_is_seg: %d", all_outs[latch_num][94]);
            $fdisplay(file, "\t\t dest4_is_seg: %d", all_outs[latch_num][93]);
            $fdisplay(file, "\t\t dest1_is_mem: %d", all_outs[latch_num][92]);
            $fdisplay(file, "\t\t dest2_is_mem: %d", all_outs[latch_num][91]);
            $fdisplay(file, "\t\t dest3_is_mem: %d", all_outs[latch_num][90]);
            $fdisplay(file, "\t\t dest4_is_mem: %d", all_outs[latch_num][89]);
            $fdisplay(file, "\t\t res1_ld_out: %d", all_outs[latch_num][88]);
            $fdisplay(file, "\t\t res2_ld_out: %d", all_outs[latch_num][87]);
            $fdisplay(file, "\t\t res3_ld_out: %d", all_outs[latch_num][86]);
            $fdisplay(file, "\t\t res4_ld_out: %b\n", all_outs[latch_num][85]); 

            $fdisplay(file, "\t\t aluk: %b", all_outs[latch_num][84:80]);
            $fdisplay(file, "\t\t mux_adder: %b", all_outs[latch_num][79:77]);
            $fdisplay(file, "\t\t mux_and_int: %d", all_outs[latch_num][76]);
            $fdisplay(file, "\t\t mux_shift: %d", all_outs[latch_num][75]);
            $fdisplay(file, "\t\t p_op: 0x%h", all_outs[latch_num][74:38]);
            $fdisplay(file, "\t\t fmask: 0x%h = %b", all_outs[latch_num][37:20], all_outs[latch_num][36:20]); 
            $fdisplay(file, "\t\t conditionals: %b", all_outs[latch_num][19:18]);
            $fdisplay(file, "\t\t is_br: %d", all_outs[latch_num][17]);
            $fdisplay(file, "\t\t is_fp: %d", all_outs[latch_num][16]);
            $fdisplay(file, "\t\t CS: 0x%h", all_outs[latch_num][15:0]);
        end
        
        $fdisplay(file, "\n");
    end
endmodule 

//  for reference, these are the outputs from MEM coming into the latch:

    //modifiable signals:
    //  [6:0] ptcid              //[1120:1014]
    //  [3:0] wake               //[1113:1110]
    //  [63:0] op1_val           //[1109:1046]
    //  [63:0] op2_val           //[1045:982]
    //  [63:0] op3_val           //[981:918]
    //  [63:0] op4_val           //[917:854]
    //  [127:0] op1_ptcinfo      //[853:726]
    //  [127:0] op2_ptcinfo      //[725:598]
    //  [127:0] op3_ptcinfo      //[597:470]
    //  [127:0] op4_ptcinfo      //[469:342]
    //  valid_out                //[341]

    //non-modifiable signals:
    //BP_alias                      //[340:335]
    //  is_rep                      //[334]
    //  is_imm                      //[333]
    //  [31:0] eip_out              //[332:301]
    //  [31:0] latched_eip_out      //[300:269]
    //  IE_out                      //[268]
    //  [3:0] IE_type_out           //[267:264]
    //  [31:0] BR_pred_target_out   //[263:232]
    //  BR_pred_T_NT_out            //[231]

    //  [1:0] opsize_out         //[230:229]
    //  [31:0] dest1_addr        //[228:197]
    //  [31:0] dest2_addr        //[196:165]
    //  [31:0] dest3_addr        //[164:133]
    //  [31:0] dest4_addr        //[132:101]
    //  [1227:0] dest1_ptcinfo      //im not changing those numbers
    //  [1227:0] dest2_ptcinfo      //im not changing those numbers
    //  [1227:0] dest3_ptcinfo      //im not changing those numbers
    //  [1227:0] dest4_ptcinfo      //im not changing those numbers
    //  dest1_is_reg             //[100]
    //  dest2_is_reg             //[99]
    //  dest3_is_reg             //[98]
    //  dest4_is_reg             //[97]
    //  dest1_is_seg             //[96]
    //  dest2_is_seg             //[95]
    //  dest3_is_seg             //[94]
    //  dest4_is_seg             //[93]
    //  dest1_is_mem             //[92]  
    //  dest2_is_mem             //[91]
    //  dest3_is_mem             //[90]
    //  dest4_is_mem             //[89]
    //  res1_ld_out              //[88]
    //  res2_ld_out              //[87]
    //  res3_ld_out              //[86]
    //  res4_ld_out              //[85]

    //  [4:0] aluk_out,           //[84:80]  
    //  [2:0] mux_adder_out       //[79:77]
    //  mux_and_int_out           //[76]
    //  mux_shift_out             //[75]
    //  [36:0] p_op_out           //[74:38]  
    //  [17:0] fmask_out          //[37:20]
    //  [1:0] conditionals_out    //[19:18]
    //  is_br_out,                //[17]
    //  is_fp_out                 //[16]
    //  [15:0] CS_out             //[15:0]
