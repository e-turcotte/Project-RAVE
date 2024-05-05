module D_RrAg_Queued_Latches #(parameter M_WIDTH=8, N_WIDTH=8, Q_LENGTH=8) (input [M_WIDTH-1:0] m_din,
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

    integer file, cyc_cnt;
    initial begin
        cyc_cnt = 0;
        file = $fopen("D_RrAg_latches.out", "w");
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

		$fdisplay(file, "\n=============== D to RrAg Latch Values ===============\n");

        for (latch_num = 0; latch_num < qlen; latch_num = latch_num + 1) begin
            $fdisplay(file, "\n\t ==LATCH==: %d", latch_num);
            $fdisplay(file, "\t modifiable signals:");

            $fdisplay(file, "\t\t valid: %d", all_outs[latch_num][361]);

            $fdisplay(file, "\n\t non-modifiable signals:");

            $fdisplay(file, "\t\t reg_addr1: %b", all_outs[latch_num][360:358]);
            $fdisplay(file, "\t\t reg_addr2: %b", all_outs[latch_num][357:355]);
            $fdisplay(file, "\t\t reg_addr3: %b", all_outs[latch_num][354:352]);
            $fdisplay(file, "\t\t reg_addr4: %b", all_outs[latch_num][351:349]);
            
            $fdisplay(file, "\t\t seg_addr1: %b", all_outs[latch_num][348:346]);
            $fdisplay(file, "\t\t seg_addr2: %b", all_outs[latch_num][347:345]);
            $fdisplay(file, "\t\t seg_addr3: %b", all_outs[latch_num][344:342]);
            $fdisplay(file, "\t\t seg_addr4: %b", all_outs[latch_num][341:339]);

            $fdisplay(file, "\t\t opsize: %b", all_outs[latch_num][338:337]);
            $fdisplay(file, "\t\t addressing mode: %d", all_outs[latch_num][336]);
            $fdisplay(file, "\t\t op1: 0x%d", all_outs[latch_num][335:323]);
            $fdisplay(file, "\t\t op2: 0x%d", all_outs[latch_num][322:310]);
            $fdisplay(file, "\t\t op3: 0x%d", all_outs[latch_num][309:297]);
            $fdisplay(file, "\t\t op4: 0x%d", all_outs[latch_num][296:284]);

            $fdisplay(file, "\t\t res1_ld: %d", all_outs[latch_num][283]);
            $fdisplay(file, "\t\t res2_ld: %d", all_outs[latch_num][282]);
            $fdisplay(file, "\t\t res3_ld: %d", all_outs[latch_num][281]);
            $fdisplay(file, "\t\t res4_ld: %d", all_outs[latch_num][280]);

            $fdisplay(file, "\t\t dest1: 0x%h", all_outs[latch_num][279:267]);
            $fdisplay(file, "\t\t dest2: 0x%h", all_outs[latch_num][266:254]);
            $fdisplay(file, "\t\t dest3: 0x%h", all_outs[latch_num][253:241]);
            $fdisplay(file, "\t\t dest4: 0x%h", all_outs[latch_num][240:228]);
            $fdisplay(file, "\t\t disp: 0x%h", all_outs[latch_num][227:196]);

            $fdisplay(file, "\t\t reg3_shfamnt: %b", all_outs[latch_num][195:194]);
            $fdisplay(file, "\t\t usereg2: %d", all_outs[latch_num][193]);
            $fdisplay(file, "\t\t usereg3: %d", all_outs[latch_num][192]);
            $fdisplay(file, "\t\t rep: %d", all_outs[latch_num][191]);
            $fdisplay(file, "\t\t aluk: %b", all_outs[latch_num][190:186]);
            $fdisplay(file, "\t\t mux_adder: %b", all_outs[latch_num][185:183]);
            $fdisplay(file, "\t\t mux_and_int: %d", all_outs[latch_num][182]);
            $fdisplay(file, "\t\t mux_shift: %d", all_outs[latch_num][181]);
            $fdisplay(file, "\t\t p_op: 0x%h", all_outs[latch_num][180:144]);
            $fdisplay(file, "\t\t fmask: 0x%h = %b", all_outs[latch_num][143:126], all_outs[latch_num][143:126]);
            $fdisplay(file, "\t\t conditionals: %b", all_outs[latch_num][125:124]);
            $fdisplay(file, "\t\t is_br: %d", all_outs[latch_num][123]);
            $fdisplay(file, "\t\t is_fp: %d", all_outs[latch_num][122]);
            $fdisplay(file, "\t\t imm: 0x%h", all_outs[latch_num][121:74]);

            $fdisplay(file, "\t\t mem1_rw: %b", all_outs[latch_num][73:72]);
            $fdisplay(file, "\t\t mem2_rw: %b", all_outs[latch_num][71:70]);
            $fdisplay(file, "\t\t EIP: 0x%h", all_outs[latch_num][69:38]);
            $fdisplay(file, "\t\t IE: %b", all_outs[latch_num][37]);
            $fdisplay(file, "\t\t IE_type: %b", all_outs[latch_num][36:33]);
            $fdisplay(file, "\t\t BR_pred_target: 0x%h", all_outs[latch_num][32:1]);
            $fdisplay(file, "\t\t BR_pred_T_NT: %d", all_outs[latch_num][0]);

        end
        
        $fdisplay(file, "\n");
    end
endmodule 

//  for reference, these are the outputs from MEM coming into the latch:

//modifiable signals:
//          valid_out               [361]

//non-modifiable signals:

// [2:0]    reg_addr1               [360:358]
// [2:0]    reg_addr2               [357:355]
// [2:0]    reg_addr3               [354:352]
// [2:0]    reg_addr4               [351:349]

// [2:0]    seg_addr1               [348:346]
// [2:0]    seg_addr2               [347:345]
// [2:0]    seg_addr3               [344:342]
// [2:0]    seg_addr4               [341:339]

// [1:0]    opsize                  [338:337]
//          addressingmode          [336]
// [12:0]   op1                     [335:323]
// [12:0]   op2                     [322:310]
// [12:0]   op3                     [309:297]
// [12:0]   op4                     [296:284]

//          res1_ld                 [283]
//          res2_ld                 [282]
//          res3_ld                 [281]
//          res4_ld                 [280]

// [12:0]   dest1                   [279:267]
// [12:0]   dest2                   [266:254]
// [12:0]   dest3                   [253:241]
// [12:0]   dest4                   [240:228]
// [31:0]   disp                    [227:196]

// [1:0]    reg3_shfamnt            [195:194]
//          usereg2                 [193]
//          usereg3                 [192]
//          rep                     [191]
// [4:0]    aluk                    [190:186]
// [2:0]    mux_adder               [185:183]
//          mux_and_int             [182]
//          mux_shift               [181]
// [36:0]   p_op                    [180:144]
// [17:0]   fmask                   [143:126]
// [1:0]    conditionals            [125:124]
//          is_br                   [123]
//          is_fp                   [122]
// [47:0]   imm                     [121:74]

// [1:0]    mem1_rw                 [73:72]
// [1:0]    mem2_rw                 [71:70]
// [31:0]   eip                     [69:38]
//          IE                      [37]
// [3:0]    IE_type                 [36:33]
// [31:0]   BR_pred_target          [32:1]
//          BR_pred_T_NT            [0]
