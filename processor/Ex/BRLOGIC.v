module BRLOGIC(
    output val,
    output taken,
    output correct,
    output[31:0] FIP,
    output[31:0] FIP_p1,
    
    input val_in,
    input [31:0] pred_target,
    input pred_taken,
    input  [1:0] conditionals,
    input zf, cf,
    input [31:0] act_target,
    input JMPnear_P_OP, JMPfar_P_OP, JMPptr_P_OP,
    input gurBR
); 
    wire [1:0] cond_n;
    inv1$ asher(cf_n, cf);
    inv1$ ashsas(zf_n, zf);
    inv1$ i0(gurBR_n, gurBR);
    nand3$ a1(w1, conditionals[0], cf_n, cond_n[1] );
    nand3$ a2(w2, conditionals[1], zf_n, cond_n[0]);
    nand4$ a25(w3, conditionals[1], zf_n, conditionals[0],cf_n );
    nand3$ n1(taken_t, w1, w2, w3);
    or2$ n2(taken, taken_t, gurBR);
    assign FIP = act_target;
    
    or4$ o1(w3, JMPnear_P_OP, JMPfar_P_OP, JMPptr_P_OP, gurBR );
    and2$ a3(val, w3, val_in);
    
    wire match32, match48;
    equaln #(32) e1(pred_target[31:0], act_target[31:0], match32);
    
    kogeAdder #(32) inc(FIP_p1, cout, FIP, 32'h0000_0010, 1'b0);
    wire destCorrect; wire brCorrect; wire takenCor; wire notTakenCor;
    
    and3$ x1(takenCor , pred_taken, taken,match32);
    
    xnor2$ x2(notTakenCor, taken, pred_taken); //TODO: i think this should be a NOR
    
    or2$ a5(correct, notTakenCor, takenCor);
    

endmodule