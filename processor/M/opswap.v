module opswap (input [63:0] reg1_data, reg2_data, reg3_data, reg4_data,
               input [2:0] reg1_addr, reg2_addr, reg3_addr, reg4_addr,
               input [127:0] reg1_ptc, reg2_ptc, reg3_ptc, reg4_ptc,
               input [15:0] seg1_data, seg2_data, seg3_data, seg4_data,
               input [2:0] seg1_addr, seg2_addr, seg3_addr, seg4_addr,
               input [31:0] seg1_ptc, seg2_ptc, seg3_ptc, seg4_ptc,
               input [63:0] mem1_data, mem2_data,
               input [31:0] mem1_addr, mem2_addr,
               input [127:0] mem1_ptc, mem2_ptc,
               input [31:0] eip_data,
               input [47:0] imm,
               input [12:0] op1_mux, op2_mux, op3_mux, op4_mux, dest1_mux, dest2_mux, dest3_mux, dest4_mux,
               output [63:0] op1, op2, op3, op4,
               output [127:0] op1_ptcinfo, op2_ptcinfo, op3_ptcinfo, op4_ptcinfo,
               output [31:0] dest1_addr, dest2_addr, dest3_addr, dest4_addr,
               output [2:0] dest1_type, dest2_type, dest3_type, dest4_type);

    wire [255:0] reg_datas, seg_datas;
    wire [127:0] mem_datas, eip_datas;
    wire [63:0] imm_data;

    assign reg_datas = {reg4_data,reg3_data,reg2_data,reg1_data};
    assign seg_datas = {48'h000000000000,seg4_data,48'h000000000000,seg3_data,48'h000000000000,seg2_data,48'h000000000000,seg1_data};
    assign mem_datas = {mem2_data,mem1_data};
    assign eip_datas = {16'h0000,seg4_data,eip_data,32'h00000000,eip_data};
    assign imm_data = {16'h0000,imm};

    wire [831:0] datas;

    assign datas = {imm_data,eip_datas,mem_datas,seg_datas,reg_datas};

    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(64)) m0(.in(datas), .sel(op1_mux), .out(op1));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(64)) m1(.in(datas), .sel(op2_mux), .out(op2));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(64)) m2(.in(datas), .sel(op3_mux), .out(op3));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(64)) m3(.in(datas), .sel(op4_mux), .out(op4));

    wire [512:0] reg_ptcs, seg_ptcs;
    wire [255:0] mem_ptcs, eip_ptcs;
    wire [127:0] imm_ptc;

    assign reg_ptcs = {reg4_ptc,reg3_ptc,reg2_ptc,reg1_ptc};
    assign seg_ptcs = {96'h000000000000,seg4_ptc,96'h000000000000,seg3_ptc,96'h000000000000,seg2_ptc,96'h000000000000,seg1_ptc};
    assign mem_ptcs = {mem2_ptc,mem1_ptc};
    assign eip_ptcs = {32'h0000,seg4_ptc,64'h00000000,128'h0000000000000000};
    assign imm_ptc = 128'h0000000000000000;

    wire [1663:0] ptcs;

    assign ptcs = {imm_ptc,eip_ptcs,mem_ptcs,seg_ptcs,reg_ptcs};

    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(128)) m4(.in(ptcs), .sel(op1_mux), .out(op1_ptcinfo));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(128)) m5(.in(ptcs), .sel(op2_mux), .out(op2_ptcinfo));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(128)) m6(.in(ptcs), .sel(op3_mux), .out(op3_ptcinfo));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(128)) m7(.in(ptcs), .sel(op4_mux), .out(op4_ptcinfo));

    wire [127:0] reg_addrs, seg_addrs;
    wire [63:0] mem_addrs, eip_addrs;
    wire [31:0] imm_addr;

    assign reg_addrs = {29'h00000000,reg4_addr,29'h00000000,reg3_addr,29'h00000000,reg2_addr,29'h00000000,reg1_addr};
    assign seg_addrs = {29'h00000000,seg4_addr,29'h00000000,seg3_addr,29'h00000000,seg2_addr,29'h00000000,seg1_addr};
    assign mem_addrs = {mem2_addr,mem1_addr};
    assign eip_addrs = 64'h0000000000000000;
    assign imm_addr = 32'h00000000;

    wire [415:0] addrs;

    assign addrs = {imm_addr,eip_addrs,mem_addrs,seg_addrs,reg_addrs};

    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(32)) m8(.in(addrs), .sel(dest1_mux), .out(dest1_addr));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(32)) m9(.in(addrs), .sel(dest2_mux), .out(dest2_addr));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(32)) m10(.in(addrs), .sel(dest3_mux), .out(dest3_addr));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(32)) m11(.in(addrs), .sel(dest4_mux), .out(dest4_addr));

    wire [11:0] reg_types, seg_types;
    wire [5:0] mem_types, eip_types;
    wire [2:0] imm_type;

    assign reg_types = {3'b001,3'b001,3'b001};
    assign seg_types = {3'b010,3'b010,3'b010};
    assign mem_types = {3'b100,3'b100};
    assign eip_types = 6'b000000;
    assign imm_type = 3'b000;

    wire [38:0] types;

    assign types = {imm_type,eip_types,mem_types,seg_types,reg_types};

    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(3)) m12(.in(types), .sel(dest1_mux), .out(dest1_type));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(3)) m13(.in(types), .sel(dest2_mux), .out(dest2_type));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(3)) m14(.in(types), .sel(dest3_mux), .out(dest3_type));
    muxnm_tristate #(.NUM_INPUTS(13), .DATA_WIDTH(3)) m15(.in(types), .sel(dest4_mux), .out(dest4_type));

endmodule