module TOP;

    localparam CYCLE_TIME = 2.0;
    
    reg [127:0] line_00_in;
    reg [127:0] line_01_in;
    reg [127:0] line_10_in;
    reg [127:0] line_11_in;
    reg [5:0] length_to_rotate;
    reg clk;

    wire [127:0] line_out;
    rotate_I_Buff r0(.line_00_in(line_00_in), .line_01_in(line_01_in), .line_10_in(line_10_in), 
                        .line_11_in(line_11_in), .length_to_rotate(length_to_rotate), .line_out(line_out));

    initial begin
        clk = 1'b1;
        forever #(CYCLE_TIME / 2.0) clk = ~clk;
    end

    initial begin

        line_00_in = 128'h1234567890abcdef1234567890abcdef;
        line_01_in = 128'h1234567890abcdef1234567890abcdef;
        line_10_in = 128'h1234567890abcdef1234567890abcdef;
        line_11_in = 128'h1234567890abcdef1234567890abcdef;

        length_to_rotate = 6'b000000;

        #(cycle_time)

        length_to_rotate = 6'b000001;

        #(cycle_time)

        length_to_rotate = 6'b000010;

        #(cycle_time)

        length_to_rotate = 6'b000011;

        #(cycle_time)

        length_to_rotate = 6'b001000;

        #(cycle_time)

        length_to_rotate = 6'b001001;

        #(cycle_time)

        length_to_rotate = 6'b001010;

        #(cycle_time)

        length_to_rotate = 6'b001011;

        #(cycle_time)

        length_to_rotate = 6'b010000;

        #(cycle_time)

        length_to_rotate = 6'b010001;

        #(cycle_time)

        length_to_rotate = 6'b000010;

        $finish;
    end

    initial begin
        $dumpfile("test.fst");
        $dumpvars(2, TOP);
    end

endmodule