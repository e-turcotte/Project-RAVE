module DMA(
    input clk,
    input set, rst,
    
    //DES
    output reg read_d,
    
    input full_d,
    input [14:0] pAdr_d,
    input [16*8-1:0] data_d,
    input [3:0]return_d,
    input [3:0] dest_d,
    input rw_d,
    input [15:0] size_d,

    //S
    output reg valid_s,
    output reg [14:0] pAdr_s,
    output reg [16*8-1:0] data_s,
    output reg [3:0] dest_s,
    output reg [3:0]return_s,
    output reg rw_s,
    output reg [15:0] size_s,

    input full_block_s,
    input free_block_s,

    //DISC
    input [127:0] data_disc,
    input finished_disc,
    output reg [32:0] adr_disc,
    output reg read_disc,

    //KEYBOARD
    input [7:0] data_kb,
    output reg read_kb,

    //CORE
    output wire interrupt_core
);
//ADDRESS_LIST
//readCHAR: x1000
//Disc Source: x1010
//Memory destination: x1020
//Disc size: x1030
//Initialize: x1040
//ClearInterrupt x1050
reg interrupt;
assign interrupt_core = interrupt;

reg[31:0] discSource;
reg[14:0] memDest;
reg[11:0] discSize;
reg inUse;
wire[127:0] ldSER , ldSER2;

reg [127:0] discBuffer  ;
reg[3:0] state;

concat_io a(discSize[3:0], data_d, discBuffer[127:0], ldSER);
concat_io_init b(
    .discSize(discSize),
    .fromMem(data_d),
    .fromDisc_in(discBuffer[127:0]), 
    .memAddress(memDest[3:0]),
    .toMem2(ldSER2));

reg[4095:0] upCnt;
always @(posedge clk) begin
    if(!rst) begin
        inUse = 0;
        memDest = 0;
        discSource = 0;
        discSize = 0;
        valid_s = 0;
        read_d = 0;
        interrupt = 0;
        discBuffer = 0;
        upCnt = 0;
        state = 0;
        adr_disc = 33'h1_0000_0000;
        read_disc = 0;

    end
    else begin 
        discBuffer = data_disc;
        case(state)
            4'b0000: begin
                read_kb = 0;
                read_d = 0;
                valid_s = 0;
                if(full_d) begin 
                    case (pAdr_d[6:4])
                        3'b000: begin                          
                                read_kb = 1;
                                state = 1;
                                read_d = 1;
                        end

                        3'b001: begin
                            discSource = data_d[31:0];
                            read_d = 1;
                        end

                        3'b010: begin
                            memDest = data_d[14:0];
                            read_d = 1;
                        end

                        3'b011: begin
                            discSize = data_d[11:0];
                            read_d = 1;
                        end

                        3'b100: begin
                                
                                if(discSize < 16 || (|memDest[3:0])) begin
                                    state = 4'b1010;
                                end
                                else begin
                                   state = 4; 
                                end
                                read_d = 1;
                                adr_disc = {1'b0,discSource};
                                upCnt = 0;
                            
                        end

                        3'b101: begin
                            interrupt = 0;
                            read_d = 1'b1;
                        end
                        default: begin
                            read_d = 1'b1;
                        end
                    endcase
                end
            else begin
                read_kb = 0;
                read_d = 0;
                valid_s = 0;
            end
            end
            
            4'b0001:begin //Handle kb entry
                read_kb = 0;
                read_d = 0;
                valid_s = 0;
                if(free_block_s) begin
                    valid_s=1;
                    pAdr_s = pAdr_d;
                    data_s = {120'd0, data_kb};
                    return_s = 4'b1100;
                    dest_s = return_d;
                    rw_s = 1'b1;
                    size_s = 16'h8000;
                    state = 0;
                end
            end

            4'b0011: begin //Handle kb entry during mem operation
                valid_s = 0;
                read_d = 0;
                read_disc = 0;
                if(free_block_s) begin
                    valid_s=1;
                    pAdr_s = pAdr_d;
                    data_s = {120'd0, data_kb};
                    return_s = 4'b1100;
                    dest_s = return_d;
                    rw_s =  1'b1;
                    size_s = 16'h8000;
                    state = 4'b0100;
                end
            end

            4'b0100: begin //Read from disc
                valid_s = 0;
                read_d = 0;
                read_disc = 1;
                inUse = 1;
                read_d = 1;
                adr_disc = {1'b0,discSource};
                upCnt = 0;
                if(finished_disc)begin
                    read_disc = 0;
                    if(discSize > 16) state = 4'b0110;
                  else state = 4'b0111;
                end
            end

            4'b0110: begin //Transmit disc
                valid_s = 0;
                read_d = 0;
                read_disc = 0;
                if(free_block_s) begin 
                    if(pAdr_d == 15'h1000)begin
                        valid_s=1;
                        pAdr_s = pAdr_d;
                        data_s = {120'd0, data_kb};
                        return_s = 4'b1100;
                        dest_s = return_d;
                        rw_s =  1'b1;
                        size_s = 16'h8000;
                        read_d = 1;
                    end
                    else begin
                        valid_s <=1 ;
                        pAdr_s <= memDest;
                        data_s <= discBuffer;
                        return_s <= 4'b1100;
                        dest_s <= {2'b10, memDest[5:4]};
                        rw_s <= 1'b1;
                        size_s <= 16'h8000;
                        upCnt <= upCnt + 127;
                        discSource <= discSource + 32'h0010;
                        memDest <= memDest + 16;
                        if(discSize > 16) state <= 4'b0100;
                        else state <= 4'b0111;
                        discSize <= discSize - 16;
                    end
                end
            end

        4'b0111: begin //Read from mem if unaligned at the end
            valid_s = 0;
                read_d = 0;
                read_disc = 0;
            if(free_block_s) begin
                valid_s =1 ;
                pAdr_s = memDest;
                data_s = discBuffer[  127 : 0];
                return_s = 4'b1100;
                dest_s = {2'b10, memDest[5:4]};
                rw_s = 1'b0;
                size_s = 16'h1000;
                upCnt = upCnt + 127;
                // discSource = discSource + 32'h0010;
                // memDest = memDest + 16;
                discSize = discSize - 16;
                state = 4'b1000;
            end
        end
        4'b1000: begin //Concat disc and unaligned mem
            read_kb = 0;
                read_d = 0;
                valid_s = 0;
            if(free_block_s)begin
                if(full_d) begin
                    valid_s =1 ;
                    pAdr_s = memDest;
                    data_s = ldSER;
                    return_s = 4'b1100;
                    dest_s = {2'b10, memDest[5:4]};
                    rw_s = 1'b1;
                    size_s = 16'h8000;
                    upCnt = upCnt + 127;
                    discSize = 0;
                    memDest = memDest + 16;
                    interrupt = 1;
                    state = 4'b1001;
                end
            end
        end

        4'b1001: begin //reset
            read_kb = 0;
                read_d = 0;
                valid_s = 0;
            state = 0; 
            interrupt = 0;
            inUse = 0;
            end  
        4'b1010: begin
            valid_s = 0;
            read_d = 0;
            read_disc = 0;
            if(free_block_s) begin
                valid_s =1 ;
                pAdr_s = memDest;
                data_s = discBuffer[  127 : 0];
                return_s = 4'b1100;
                dest_s = {2'b10, memDest[5:4]};
                rw_s = 1'b0;
                size_s = 16'h1000;
                upCnt = upCnt + 127;
                state = 4'b1011;
                // discSource = discSource + 32'h0010;
            end
        end   
        4'b1011: begin
            read_kb = 0;
            read_d = 0 ;
            valid_s = 0;
            if(free_block_s)begin
                if(full_d) begin
                    valid_s =1 ;
                    pAdr_s = memDest;
                    data_s = ldSER2;
                    return_s = 4'b1100;
                    dest_s = {2'b10, memDest[5:4]};
                    rw_s = 1'b1;
                    size_s = 16'h8000;
                    upCnt = upCnt + 127;
                    read_d = 1;
                    if(discSize >= 32) begin
                        state = 4'b0100;
                    end
                    else if (discSize > 16) begin
                        state = 4'b0111;
                    end
                    else begin 
                        interrupt = 1;
                        state = 9;
                    end
                    @(posedge clk)
                    discSize = discSize - (16- memDest[3:0]);
                    discSource = discSource + (16 - memDest[3:0]);
                    memDest = (memDest + 16) & 15'h7ff0;
                end
            end
        end      
        endcase
    end
end 



endmodule



module concat_io(
    input[3:0] discSize,
    input [127:0] fromMem,
    input[127:0] fromDisc, 
    output reg [127:0] toMem);

    always @(*) begin
        case(discSize)
        4'd0: toMem = fromDisc;
        4'd1: toMem = {fromMem[127:8],fromDisc[7:0]};
        4'd2: toMem = {fromMem[127:16],fromDisc[15:0]};
        4'd3: toMem = {fromMem[127:24],fromDisc[23:0]};
        4'd4: toMem = {fromMem[127:32],fromDisc[31:0]};
        4'd5: toMem = {fromMem[127:40],fromDisc[39:0]};
        4'd6: toMem = {fromMem[127:48],fromDisc[47:0]};
        4'd7: toMem = {fromMem[127:56],fromDisc[55:0]};
        4'd8: toMem = {fromMem[127:64],fromDisc[63:0]};
        4'd9: toMem = {fromMem[127:72],fromDisc[71:0]};
        4'd10: toMem = {fromMem[127:80],fromDisc[79:0]};
        4'd11: toMem = {fromMem[127:88],fromDisc[87:0]};
        4'd12: toMem = {fromMem[127:96],fromDisc[95:0]};
        4'd13: toMem = {fromMem[127:104],fromDisc[103:0]};
        4'd14: toMem = {fromMem[127:112],fromDisc[111:0]};
        4'd15: toMem = {fromMem[127:120],fromDisc[119:0]};
        default: toMem = fromDisc;
        endcase
    end
endmodule
module concat_io_init(
    input[11:0] discSize,
    input [127:0] fromMem,
    input[127:0] fromDisc_in, 
    input[3:0] memAddress,
    output reg [127:0] toMem2);
    reg [255:0] fromDiscR, fromDiscL ;
    wire [127:0] fromMemL, fromMemR;
    wire [127:0] fromDisc;
    reg[127:0] toMem;
    // assign fromDisc = fromDisc_in << (memAddress * 8);

    rotate_behave casa(fromDisc_in, memAddress,fromDisc);

    always @(*) begin
        case(memAddress)
        4'd1: toMem =  {     fromDisc[127:8],     fromMem[7:0]}; 
        4'd2: toMem =  {     fromDisc[127:16],    fromMem[15:0]};
        4'd3: toMem = {     fromDisc[127:24],    fromMem[23:0]};
        4'd4:    toMem =   {     fromDisc[127:32],    fromMem[31:0]};
        4'd5: toMem =  {     fromDisc[127:40],    fromMem[39:0]};
        4'd6: toMem = {     fromDisc[127:48],    fromMem[47:0]};
        4'd7: toMem =  {     fromDisc[127:56],    fromMem[55:0]};
        4'd8: toMem =  {     fromDisc[127:64],    fromMem[63:0]};
        4'd9: toMem =  {     fromDisc[127:72],    fromMem[71:0]};
        4'd10: toMem =  {    fromDisc[127:80],    fromMem[79:0]};
        4'd11: toMem =  {    fromDisc[127:88],    fromMem[87:0]};
        4'd12: toMem =  {    fromDisc[127:96],    fromMem[95:0]};
        4'd13: toMem =  {    fromDisc[127:104],   fromMem[103:0]};
        4'd14: toMem =  {    fromDisc[127:112],   fromMem[111:0]};
        4'd15: toMem =  {    fromDisc[127:120],   fromMem[119:0]};
        4'd0: toMem = fromDisc;
        default: toMem = fromDisc;
        endcase
        case(discSize + memAddress)
        4'd1: toMem2 =  {       fromMem[127:8],     toMem[7:0]}; 
        4'd2: toMem2 =  {       fromMem[127:16],    toMem[15:0]};
        4'd3: toMem2 = {        fromMem[127:24],    toMem[23:0]};
        4'd4:  toMem2 =   {          fromMem[127:32],    toMem[31:0]};
        4'd5: toMem2 =  {       fromMem[127:40],    toMem[39:0]};
        4'd6: toMem2 = {        fromMem[127:48],    toMem[47:0]};
        4'd7: toMem2 =  {       fromMem[127:56],    toMem[55:0]};
        4'd8: toMem2 =  {       fromMem[127:64],    toMem[63:0]};
        4'd9: toMem2 =  {       fromMem[127:72],    toMem[71:0]};
        4'd10: toMem2 =  {      fromMem[127:80],    toMem[79:0]};
        4'd11: toMem2 =  {      fromMem[127:88],    toMem[87:0]};
        4'd12: toMem2 =  {      fromMem[127:96],    toMem[95:0]};
        4'd13: toMem2 =  {      fromMem[127:104],   toMem[103:0]};
        4'd14: toMem2 =  {      fromMem[127:112],   toMem[111:0]};
        4'd15: toMem2 =  {      fromMem[127:120],   toMem[119:0]};
        4'd0: toMem2 = fromMem;
        default: toMem2 = fromDisc;
        endcase
    end

endmodule

module rotate_behave (
    input [127:0] in,
     input [3:0] rot,
     output reg [127:0] out );

    always @(*) begin
        case(rot)
        4'd0:  out = in;
        4'd1:  out = { in[119:0],        8'd0 };
        4'd2:  out = { in[111:0],      16'd0  };
        4'd3:  out = { in[103:0],      24'd0  };
        4'd4:  out = { in[95:0],      32'd0  };
        4'd5:  out = { in[87:0],      40'd0  };
        4'd6:  out = { in[79:0],      48'd0  };
        4'd7:  out = { in[71:0],      56'd0  };
        4'd8:  out = { in[63:0],      64'd0  };
        4'd9:  out = { in[55:0],      72'd0  };
        4'd10: out = {in [47:0],      80'd0  };
        4'd11: out = {in [39:0],      88'd0  };
        4'd12: out = {in [31:0],      96'd0  };
        4'd13: out = {in [23:0],     104'd0  };
        4'd14: out = {in [15:0],     112'd0  };
        4'd15: out = {in [7:0],     120'd0  };
        default: out = in;
    endcase
    end
endmodule