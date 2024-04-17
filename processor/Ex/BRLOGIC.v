module BRLOGIC(
    output val,
    output taken,
    output correct,
    output[47:0] final_dest,
    output[47:0] final_dest_one,
    
    input val_in,
    input [47:0] pred_target,
    input pred_taken,
    input  [1:0] conditionals,
    input zf, cf,
    input [47:0] act_target,
    input JMPnear_P_OP, JMPfar_P_OP, JMPptr_P_OP  
);
    and2$ a1(w1, conditionals[0], cf);
    and2$ a2(w2, conditionals[1], zf);
    nor2$ n1(taken, w1, w2);
    
    or3$ o1(w3, JMPnear_P_OP, JMPfar_P_OP, JMPptr_P_OP );
    and2$ a3(val, w3, val_in);
    
    wire match32, match48;
    equaln #(32) e1(pred_target[31:0], act_target[31:0], match32);
    equaln #(48) e2(pred_target[47:0], act_target[47:0], match48);
    
    wire destCorrect; wire brCorrect; wire takenCor; wire notTakenCor;
    mux2$ m1(destCorrect, match32, match48, JMPptr_P_OP);
    and3$ x1(takenCor , pred_taken, taken,destCorrect);
    
    xnor2$ x2(notTakenCor, taken, pred_taken);
    
    and2$ a5(correct, notTakenCor, takenCor);
    

endmodule