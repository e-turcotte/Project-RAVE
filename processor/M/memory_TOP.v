module MEM(
    input wire clk,
    input wire valid_in,
    input wire [31:0] EIP_in,
    input wire IE_in,                           //interrupt or exception signal
    input wire [3:0] IE_type_in,
    input wire [31:0] BR_pred_target_in,       //branch prediction target
    input wire BR_pred_T_NT_in,                //branch prediction taken or not taken
    input wire set, rst,

    //related to checking prot exception for seg_size:
    input wire [31:0] read_address_end_size,   
    input wire [19:0] seg_size,

    //TLB stuff:
    input wire [159:0] VP_in,                  
    input wire [159:0] PF_in,                  //unpacked, do wire concatenation in TOP
    input wire [7:0] entry_v_in,
    input wire [7:0] entry_P_in,
    input wire [7:0] entry_RW_in,              //read or write (im guessing 0 is read only)

    //TODO: add more inputs

    output wire [31:0] EIP_out,
    output wire IE_out,
    output wire [3:0] IE_type_out,
    output wire [31:0] BR_pred_target_out,       
    output wire BR_pred_T_NT_out    
    
    //TODO: add more outputs
);
    assign EIP_out = EIP_in;                //EIP passed through

    wire TLB_prot, TLB_miss, TLB_hit;
    TLB(.clk(clk), .address(/*TODO*/), .RW_in(/*TODO*/), .VP(VP_in), .PF(PF_in),  //TODO: finish signals
        .entry_v(entry_v_in), .entry_P(entry_P_in), .entry_RW(entry_RW_in), 
        .PF_out(/*TODO*/), .miss(TLB_miss), .hit(TLB_hit), .protection_exception(TLB_prot));                   


    //exception and interrupt checking:
    wire RA_gt_SS, RA_lt_SS, EQ, prot_seg;  //related to checking prot exception for seg_size

    mag_comp32 (.A(read_address_end_size), .B({12'b0, seg_size}), .AGB(RA_gt_SS), .BGA(RA_lt_SS), .EQ(EQ));
    or2$ (.out(prot_seg), .in0(EQ), .in1(RA_gt_SS));                                    //if read_address_end_size >= seg_size
    
    or2$ (.out(IE_type_out[0]), .in0(prot_seg), .in1(TLB_prot));                        //update protection exception
    assign IE_type_out[1] = TLB_miss;                                                   //update page fault exception
    assign IE_type_out[3:2] = IE_type_in[3:2];                                          //pass along
    or4$ (.out(IE_out), .in1(IE_in), .in2(prot_seg), .in3(TLB_miss), .in4(TLB_prot));   //update IE_out

    

endmodule