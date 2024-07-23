module dumper (input [31:0] eip, latch_eip,
               input [6:0] ptcid,
               input [63:0] res1, res2, res3, res4,
               input [31:0] dest1, dest2, dest3, dest4,
               input [3:0] reg_wb, seg_wb, mem_wb,
               input eip_wb, is_halt,
               input br_pred_tnt,
               input [31:0] br_pred_target,
               input [6:0] eflags,
               input [255:0] gpf_out,
               input [511:0] mmf_out,
               input [95:0] sf_out,
               input clk, valid);

    integer cyc_cnt;
    integer file;

    initial begin
        cyc_cnt = 0;
        file = $fopen("dumpy.out");
    end

    always @(posedge clk) begin
        cyc_cnt = cyc_cnt + 1;
        if(valid) begin
            $fdisplay(file, "cycle number: %d", cyc_cnt);
            $fdisplay(file, "\n");

            $fdisplay(file, "[===INSTRUCTION===]");
            $fdisplay(file, "EIP         = %h", eip);
            $fdisplay(file, "LATCHED EIP = %h", latch_eip);
            $fdisplay(file, "PTCID       = %h", ptcid);
            $fdisplay(file, "[===WB DATA===]");
            $fdisplay(file, "RES1 = 0x%h   DEST1 = 0x%h   REG/SEG/MEM/EIP = %b", res1, dest1, {reg_wb[0],seg_wb[0],mem_wb[0],eip_wb});
            $fdisplay(file, "RES2 = 0x%h   DEST2 = 0x%h   REG/SEG/MEM/EIP = %b", res2, dest2, {reg_wb[1],seg_wb[1],mem_wb[1],1'b0});
            $fdisplay(file, "RES3 = 0x%h   DEST3 = 0x%h   REG/SEG/MEM/EIP = %b", res3, dest3, {reg_wb[2],seg_wb[2],mem_wb[2],1'b0});
            $fdisplay(file, "RES4 = 0x%h   DEST4 = 0x%h   REG/SEG/MEM/EIP = %b", res4, dest4, {reg_wb[3],seg_wb[3],mem_wb[3],1'b0});
            $fdisplay(file, "HALT = %b", is_halt);
            $fdisplay(file, "[===BR PREDICTION===]");
            $fdisplay(file, "BR_PRED T/NT = %b", br_pred_tnt);
            $fdisplay(file, "BR_PRED TARGET = %h", br_pred_target);
            $fdisplay(file, "[===EFLAGS===]");
            $fdisplay(file, "CF = %b", eflags[0]);
            $fdisplay(file, "PF = %b", eflags[1]);
            $fdisplay(file, "AF = %b", eflags[2]);
            $fdisplay(file, "ZF = %b", eflags[3]);
            $fdisplay(file, "SF = %b", eflags[4]);
            $fdisplay(file, "DF = %b", eflags[5]);
            $fdisplay(file, "OF = %b", eflags[6]);
            $fdisplay(file, "[===GPR VALUES===]");
            $fdisplay(file, "EAX = 0x%h", gpf_out[31:0]);
            $fdisplay(file, "ECX = 0x%h", gpf_out[63:32]);
            $fdisplay(file, "EDX = 0x%h", gpf_out[95:64]);
            $fdisplay(file, "EBX = 0x%h", gpf_out[127:96]);
            $fdisplay(file, "ESP = 0x%h", gpf_out[159:128]);
            $fdisplay(file, "EBP = 0x%h", gpf_out[191:160]);
            $fdisplay(file, "ESI = 0x%h", gpf_out[223:192]);
            $fdisplay(file, "EDI = 0x%h", gpf_out[255:224]);
            $fdisplay(file, "[===MMX VALUES===]");
            $fdisplay(file, "MM0 = 0x%h", mmf_out[63:0]);
            $fdisplay(file, "MM1 = 0x%h", mmf_out[127:64]);
            $fdisplay(file, "MM2 = 0x%h", mmf_out[191:128]);
            $fdisplay(file, "MM3 = 0x%h", mmf_out[255:192]);
            $fdisplay(file, "MM4 = 0x%h", mmf_out[319:256]);
            $fdisplay(file, "MM5 = 0x%h", mmf_out[383:320]);
            $fdisplay(file, "MM6 = 0x%h", mmf_out[447:384]);
            $fdisplay(file, "MM7 = 0x%h", mmf_out[511:448]);
            $fdisplay(file, "[===SEG VALUES===]");
            $fdisplay(file, "ES = 0x%h", sf_out[15:0]);
            $fdisplay(file, "CS = 0x%h", sf_out[31:16]);
            $fdisplay(file, "SS = 0x%h", sf_out[47:32]);
            $fdisplay(file, "DS = 0x%h", sf_out[63:48]);
            $fdisplay(file, "FS = 0x%h", sf_out[79:64]);
            $fdisplay(file, "GS = 0x%h", sf_out[95:80]);
            $fdisplay(file, "\n");
        end
    end

endmodule
