module SKIPGEN(
    output skip,
    
    input CMOVC_P_OP,
    input JMPnear_P_OP, JMPfar_P_OP,
    input cf, zf,
    input[1:0] conditionals
);
    
   wire skip1; wire cf_n;
   inv1$ i1(cf_n,cf);
   and2$ a1(skip1, cf_n, CMOVC_P_OP);
    
   wire isJMP,  isCF, isZF, misCon, skip2;
   or2$ o1(isJMP, JMPnear_P_OP, JMPfar_P_OP);
   and2$ a2(isCF, conditionals[0], cf);
   and2$ a3(isZF, conditionals[1], zf);
   or2$ o2(misCon, isCF, isZF);
   and2$ a4(skip2, isJMP, misCon);
   assign skip = skip1;
//    or2$ o3(skip, skip1, skip2);
endmodule