module disc(
    input clk,
    input rst, 
    input [32:0] adr_disc,
    input read_disc,
        output reg finished_disc,
    output  [127:0] data_disc
    
);
    reg [127:0] discMem[0:255];
    reg [127:0]data_next;
    reg [127:0]data_cur;

    
    reg [32:0] prev_adr;

    OVR o1(adr_disc[3:0], data_cur, data_next, data_disc);

  integer i;
    always @(posedge clk) begin
        if(!rst) begin
            finished_disc = 0;
            prev_adr = 33'h1_0000_0000;
        end
        else begin 
            // for(i = 0; i < 128; i = i + 1) begin
                // $display("%0h" ,adr_disc[11:4]);
                // $display("mem = %0h" ,discMem[adr_disc[11:4]]);
                 
                data_cur = discMem[adr_disc[11:4]];
                data_next = discMem[adr_disc[11:4]+1];
            // end
            
            if(read_disc) finished_disc = 0;
            if (adr_disc != prev_adr && prev_adr == 33'h1_0000_0000) begin
                    #750;
                    finished_disc = 1;
                    // Assuming this delay is sufficient for your application
            end
            else if(adr_disc!= prev_adr) begin
                finished_disc = 1;
            end
            prev_adr = adr_disc;
        end
    end

    initial begin
        $readmemh("IO/disc.init", discMem);
        // for(i = 0; i < 256; i = i + 1) begin
        //     $display("hmm = %0h" ,discMem[i]);
        // end
    end


endmodule

module OVR(
    input[3:0] discSize,
    input [127:0] cur,
    input[127:0] next, 
    output reg [127:0] toDMA);

    always @(*) begin
        case(discSize)
        4'd0: toDMA = cur;
        4'd1: toDMA =  { next   [7:0] ,cur[127:8]};
        4'd2: toDMA =  { next  [15:0] ,cur[127:16]};
        4'd3: toDMA =  { next  [23:0] ,cur[127:24]};
        4'd4: toDMA =  { next  [31:0] ,cur[127:32]};
        4'd5: toDMA =  { next  [39:0] ,cur[127:40]};
        4'd6: toDMA =  { next  [47:0] ,cur[127:48]};
        4'd7: toDMA =  { next  [55:0] ,cur[127:56]};
        4'd8: toDMA =  { next  [63:0] ,cur[127:64]};
        4'd9: toDMA =  { next  [71:0] ,cur[127:72]};
        4'd10: toDMA = { next  [79:0] ,cur[127:80]};
        4'd11: toDMA = { next  [87:0] ,cur[127:88]};
        4'd12: toDMA = { next  [95:0] ,cur[127:96]};
        4'd13: toDMA = { next  [103:0],cur[127:104]};
        4'd14: toDMA = { next  [111:0],cur[127:112]};
        4'd15: toDMA = { next  [119:0],cur[127:120]};
        endcase
    end
endmodule
