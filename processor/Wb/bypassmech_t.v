module TOP;

    localparam CYCLE_TIME = 2.0;
    integer k;

    reg [63:0] data1, data2, data3, data4;
    reg [127:0] data1ptc, data2ptc, data3ptc, data4ptc;
    reg [63:0] op1, op2, op3, op4;
    reg [127:0] op1ptc, op2ptc, op3ptc, op4ptc;
    wire [63:0] new1, new2, new3, new4;
    wire [3:0] modify;
    reg clk;

    bypassmech #(.NUM_PROSPECTS(4), .NUM_OPERANDS(4)) bp(.prospective_data({data4,data3,data2,data1}), .prospective_ptc({data4ptc,data3ptc,data2ptc,data1ptc}), .operand_data({op4,op3,op2,op1}), .operand_ptc({op4ptc,op3ptc,op2ptc,op1ptc}), .new_data({new4,new3,new2,new1}), .modify(modify));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin
        data1 = 64'h12_56_9a_de_11_22_33_44; data1ptc = 128'h1234_5678_9abc_def0_1111_2222_3333_4444;
        data2 = 64'hcc_bb_aa_99_88_77_66_55; data2ptc = 128'hcccc_bbbb_aaaa_9999_8888_7777_6666_5555;
        data3 = 64'hdd_ee_ff_01_02_03_04_05; data3ptc = 128'hdddd_eeee_ffff_0101_0202_0303_0404_0505;
        data4 = 64'h0d_0c_0b_0a_09_08_07_06; data4ptc = 128'h0d0d_0c0c_0b0b_0a0a_0909_0808_0707_0606;
        
        op1 = 64'h00_00_00_00_00_00_00_00; op1ptc = 128'h1234_5678_9abc_def0_1111_2222_3333_4444;
        op2 = 64'h00_00_00_00_00_00_00_00; op2ptc = 128'h5555_0000_6666_0000_7777_0000_8888_0000;
        op3 = 64'h00_00_00_00_00_00_00_00; op3ptc = 128'h0c0c_0909_0b0b_2222_1234_0404_4444_dddd;
        op4 = 64'h00_00_00_00_00_00_00_00; op4ptc = 128'h0000_0000_0000_0000_0000_0000_0000_0000;

        #CYCLE_TIME;
        $display("NEWval1 = %h, modify:%b", new1, modify[0]);
        $display("NEWval2 = %h, modify:%b", new2, modify[1]);
        $display("NEWval3 = %h, modify:%b", new3, modify[2]);
        $display("NEWval4 = %h, modify:%b", new4, modify[3]);
        #CYCLE_TIME;
        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(5, TOP);
    end

endmodule
