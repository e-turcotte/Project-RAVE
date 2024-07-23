module dumper ();

    integer cyc_cnt;
    integer k;
    integer file;

    initial begin
        cyc_cnt = 0;
        file = $fopen("full_dump.out");
    end

    always @(posedge clk) begin
        $fdisplay(file, "cycle number: %d", cyc_cnt);
        cyc_cnt = cyc_cnt + 1;

        $fdisplay(file, "[===EIP VALUE===]");
        $fdisplay(file, "[===PTC_ID===]");

        $fdisplay(file, "[===BR PREDICTION===]");
        

        $fdisplay(file, "[===GPR VALUES===]");
        $fdisplay(file, "EAX = 0x%h   PTC:%b", {rf_e_out[0],rf_h_out[0],rf_l_out[0]}, {rf_e_ptcv[0],rf_e_ptcv[0],rf_h_ptcv[0],rf_l_ptcv[0]});
        $fdisplay(file, "ECX = 0x%h   PTC:%b", {rf_e_out[1],rf_h_out[1],rf_l_out[1]}, {rf_e_ptcv[1],rf_e_ptcv[1],rf_h_ptcv[1],rf_l_ptcv[1]});
        $fdisplay(file, "EDX = 0x%h   PTC:%b", {rf_e_out[2],rf_h_out[2],rf_l_out[2]}, {rf_e_ptcv[2],rf_e_ptcv[2],rf_h_ptcv[2],rf_l_ptcv[2]});
        $fdisplay(file, "EBX = 0x%h   PTC:%b", {rf_e_out[3],rf_h_out[3],rf_l_out[3]}, {rf_e_ptcv[3],rf_e_ptcv[3],rf_h_ptcv[3],rf_l_ptcv[3]});
        $fdisplay(file, "ESP = 0x%h   PTC:%b", {rf_e_out[4],rf_h_out[4],rf_l_out[4]}, {rf_e_ptcv[4],rf_e_ptcv[4],rf_h_ptcv[4],rf_l_ptcv[4]});
        $fdisplay(file, "EBP = 0x%h   PTC:%b", {rf_e_out[5],rf_h_out[5],rf_l_out[5]}, {rf_e_ptcv[5],rf_e_ptcv[5],rf_h_ptcv[5],rf_l_ptcv[5]});
        $fdisplay(file, "ESI = 0x%h   PTC:%b", {rf_e_out[6],rf_h_out[6],rf_l_out[6]}, {rf_e_ptcv[6],rf_e_ptcv[6],rf_h_ptcv[6],rf_l_ptcv[6]});
        $fdisplay(file, "EDI = 0x%h   PTC:%b", {rf_e_out[7],rf_h_out[7],rf_l_out[7]}, {rf_e_ptcv[7],rf_e_ptcv[7],rf_h_ptcv[7],rf_l_ptcv[7]});
        $fdisplay(file, "[===MMX VALUES===]");
        $fdisplay(file, "MM0 = 0x%h   PTC:%b", mf_out[63:0],    {8{mf_ptcv[0]}});
        $fdisplay(file, "MM1 = 0x%h   PTC:%b", mf_out[127:64],  {8{mf_ptcv[1]}});
        $fdisplay(file, "MM2 = 0x%h   PTC:%b", mf_out[191:128], {8{mf_ptcv[2]}});
        $fdisplay(file, "MM3 = 0x%h   PTC:%b", mf_out[255:192], {8{mf_ptcv[3]}});
        $fdisplay(file, "MM4 = 0x%h   PTC:%b", mf_out[319:256], {8{mf_ptcv[4]}});
        $fdisplay(file, "MM5 = 0x%h   PTC:%b", mf_out[383:320], {8{mf_ptcv[5]}});
        $fdisplay(file, "MM6 = 0x%h   PTC:%b", mf_out[447:384], {8{mf_ptcv[6]}});
        $fdisplay(file, "MM7 = 0x%h   PTC:%b", mf_out[511:448], {8{mf_ptcv[7]}});
        $fdisplay(file, "\n");

        $fdisplay(file, "[===SEG VALUES===]");
        $fdisplay(file, "ES = 0x%h, lim:0x%h   PTC:%b", seg_base_out[15:0],  seg_lim_out[19:0],    {seg_ptc_out[30], seg_ptc_out[14] });
        $fdisplay(file, "CS = 0x%h, lim:0x%h   PTC:%b", seg_base_out[31:16], seg_lim_out[39:20],   {seg_ptc_out[62], seg_ptc_out[46] });
        $fdisplay(file, "SS = 0x%h, lim:0x%h   PTC:%b", seg_base_out[47:32], seg_lim_out[59:40],   {seg_ptc_out[94], seg_ptc_out[78] });
        $fdisplay(file, "DS = 0x%h, lim:0x%h   PTC:%b", seg_base_out[63:48], seg_lim_out[79:60],   {seg_ptc_out[126],seg_ptc_out[110]});
        $fdisplay(file, "FS = 0x%h, lim:0x%h   PTC:%b", seg_base_out[79:64], seg_lim_out[99:80],   {seg_ptc_out[158],seg_ptc_out[142]});
        $fdisplay(file, "GS = 0x%h, lim:0x%h   PTC:%b", seg_base_out[95:80], seg_lim_out[119:100], {seg_ptc_out[190],seg_ptc_out[174]});
        $fdisplay(file, "\n");
    end

endmodule