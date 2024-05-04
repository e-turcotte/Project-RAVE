import itertools
from enum import Enum
# 12 bits
is_rep = 0

is_seg_override = 1

is_opsize_override = 2

isDoubleOp = 3

isModRM = 4

immSize = 5

mod_bits = 7

rm_bits = 9

num_outputs = 2 # length and length_no_imm
length_bit_size = 5 # 5 bits for length
length_no_imm_bit_size = 5 # 5 bits for length_no_imm
total_output_bits = length_bit_size + length_no_imm_bit_size

# definition of each signal with its index in the array


def generate_truth_table(num_bits):
    table = {}
    for combination in itertools.product([0, 1], repeat=num_bits):
        table[combination] = [0] * num_outputs
    return table

def print_truth_table(truth_table):
    print(truth_table)

def generate_lengths(truth_table):
    for key in truth_table.keys():
        length = 1
        length_no_imm = 1
        if key[is_rep] == 1:
            length += 1
            length_no_imm += 1
        if key[is_seg_override] == 1:
            length += 1
            length_no_imm += 1
        if key[is_opsize_override] == 1:
            length += 1
            length_no_imm += 1
        if key[isDoubleOp] == 1:
            length += 1
            length_no_imm += 1
        if key[isModRM] == 1:
            length += 1
            length_no_imm += 1

            if key[mod_bits] == 0 and key[mod_bits+1] == 0:
                if(key[is_opsize_override] == 1): # 16 bit
                    if key[rm_bits] == 1 and key[rm_bits+1] == 0 and key[rm_bits+2] == 1: #disp16
                        length += 2
                        length_no_imm += 2
                else: #32 bit
                    if key[rm_bits] == 1 and key[rm_bits+1] == 0 and key[rm_bits+2] == 0: #SIB
                        length += 1
                        length_no_imm += 1
                    if key[rm_bits] == 1 and key[rm_bits+1] == 0 and key[rm_bits+2] == 1: #disp32
                        length += 4
                        length_no_imm += 4


            elif key[mod_bits] == 0 and key[mod_bits+1] == 1:
                if(key[is_opsize_override] == 1): # 16 bit
                    length += 1
                    length_no_imm += 1
                else: #32 bit
                    if key[rm_bits] == 1 and key[rm_bits+1] == 0 and key[rm_bits+2] == 0: #SIB
                        length += 1
                        length_no_imm += 1
                    length += 1
                    length_no_imm += 1


            elif key[mod_bits] == 1 and key[mod_bits+1] == 0:
                if(key[is_opsize_override] == 1): # 16 bit
                    length += 2
                    length_no_imm += 2
                else: #32 bit
                    if key[rm_bits] == 1 and key[rm_bits+1] == 0 and key[rm_bits+2] == 0: #SIB
                        length += 1
                        length_no_imm += 1
                    length += 4
                    length_no_imm += 4


        if key[immSize] == 0 and key[immSize+1] == 0:
            length += 1
        elif key[immSize] == 0 and key[immSize+1] == 1:
            length += 2
        elif key[immSize] == 1 and key[immSize+1] == 0:
            length += 4
        else:
            length += 6
                
        truth_table[key][0] = length
        truth_table[key][1] = length_no_imm

def output_verilog(truth_table):
    with open("select_length.v", "w") as sel_file:
        sel_file.write("module select_length(\n")
        sel_file.write(f"    input wire [{4096*(total_output_bits) - 1}:0] data,\n")
        sel_file.write("    input wire [11:0] sel,\n")
        sel_file.write(f"    output wire [{total_output_bits - 1}:0] out\n")
        sel_file.write(");\n")
        sel_file.write("    wire [4095:0] sel_out;\n")
        sel_file.write("    select_signal s0(.sel(sel), .out(sel_out));\n")
        sel_file.write(f"    muxnm_tristate #({4096}, {total_output_bits}) mxt1(.in(data), .sel(sel_out) ,.out(out));")
        sel_file.write("\n\nendmodule\n\n")

        

        sel_file.write("module select_signal(\n")
        sel_file.write("    input wire [11:0] sel,\n")
        sel_file.write("    output wire [4095:0] out\n")
        sel_file.write(");\n")
        sel_file.write("    wire [11:0] buffered_input;\n")
        sel_file.write("    bufferH4096_12b$ buff(.in(sel), .out(buffered_input));\n")
       
        for i, key in enumerate(truth_table.keys()):
            #concatenate the bits in the key
            key_str = "12'b" + "".join(str(x) for x in key)
            sel_file.write(f"    equaln #(12) e{i}(.a(buffered_input), .b({key_str}), .eq(weq{i}));\n")

        sel_file.write("    assign out = {")
        for i in range(4096):
            sel_file.write(f"weq{4095 - i}, " if (i < 4095) else f"weq{4095 - i}")
        sel_file.write("};\n")
        sel_file.write("\n\nendmodule")

    with open("length_data.v", "w") as length_data_file:
        length_data_file.write("module length_data(\n")
        length_data_file.write(f"    output wire [{4096*(total_output_bits) - 1}:0] out\n")
        length_data_file.write(");\n")

        length_data_file.write(f"    wire [{total_output_bits - 1}:0] ")
        for i, key in enumerate(truth_table.keys()):
            length_data_file.write(f'wire{i}, ' if (i < 4095) else f'wire{i};\n')
        
        
        for i, key in enumerate(truth_table.keys()):
            length_data_file.write(f"    assign wire{i} = " + "{")
            for j in range(num_outputs):
                length_data_file.write(f"{length_bit_size}'d" + f'{truth_table[key][0]}' + ", " if (j < num_outputs - 1) else f"{length_no_imm_bit_size}'d" + f'{truth_table[key][1]}')
            length_data_file.write("};\n")

        length_data_file.write(f"    wire [{4096*(total_output_bits) - 1}:0] data_concat;\n")
        length_data_file.write("    assign data_concat = {")
        for i in range(4096):
            length_data_file.write(f"wire{4095 - i}, " if (i < 4095) else f"wire{4095 - i}")
        length_data_file.write("};\n")

        length_data_file.write("    assign out = data_concat;\n")

        length_data_file.write("\n\nendmodule\n\n")

    with open("modrm_d.v", "w") as modrm_file:
        modrm_file.write("module modrm_d(\n")
        modrm_file.write("    input wire [7:0] B1,\n")
        modrm_file.write("    input wire [7:0] B2,\n")
        modrm_file.write("    input wire [7:0] B3,\n")
        modrm_file.write("    input wire [7:0] B4,\n")
        modrm_file.write("    input wire [7:0] B5,\n")
        modrm_file.write("    input wire is_rep,\n")
        modrm_file.write("    input wire is_seg_override,\n")
        modrm_file.write("    input wire is_opsize_override,\n")
        modrm_file.write("    input wire [3:0] prefSize,\n")
        modrm_file.write("    input wire isDoubleOp,\n")
        modrm_file.write("    input wire isModRM,\n")
        modrm_file.write("    input wire [1:0] immSize,\n")
        modrm_file.write("    input wire isImm,\n\n")
        
        modrm_file.write("    output wire [7:0] length,\n")
        modrm_file.write("    output wire [7:0] length_no_imm,\n")
        modrm_file.write("    output wire isSIB,\n")
        modrm_file.write("    output wire [2:0] dispSize\n")

        modrm_file.write(");\n")
        modrm_file.write("    wire [40959:0] data;\n")
        modrm_file.write("    length_data ld(.out(data));\n")
        modrm_file.write("    wire [40959:0] buffered_data;\n")
        modrm_file.write("    bufferH16_nb$ #(.WIDTH(40960)) buff(.in(data), .out(buffered_data));\n\n")


        modrm_file.write("    wire [11:0] sel0;\n")
        modrm_file.write("    assign sel0 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B1[7:6], B1[2:0]};\n")
        modrm_file.write("    wire [9:0] chosen_data0;\n")
        modrm_file.write("    select_length sl0(.data(buffered_data), .sel(sel0), .out(chosen_data0));\n\n")


        modrm_file.write("    wire [11:0] sel1;\n")
        modrm_file.write("    assign sel1 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B2[7:6], B2[2:0]};\n")
        modrm_file.write("    wire [9:0] chosen_data1;\n")
        modrm_file.write("    select_length sl1(.data(buffered_data), .sel(sel1), .out(chosen_data1));\n\n")


        modrm_file.write("    wire [11:0] sel2;\n")
        modrm_file.write("    assign sel2 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B3[7:6], B3[2:0]};\n")
        modrm_file.write("    wire [9:0] chosen_data2;\n")
        modrm_file.write("    select_length sl2(.data(buffered_data), .sel(sel2), .out(chosen_data2));\n\n")

        modrm_file.write("    wire [11:0] sel3;\n")
        modrm_file.write("    assign sel3 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B4[7:6], B4[2:0]};\n")
        modrm_file.write("    wire [9:0] chosen_data3;\n")
        modrm_file.write("    select_length sl3(.data(buffered_data), .sel(sel3), .out(chosen_data3));\n\n")

        modrm_file.write("    wire [11:0] sel4;\n")
        modrm_file.write("    assign sel4 = {is_rep, is_seg_override, is_opsize_override, isDoubleOp, isModRM, immSize, B5[7:6], B5[2:0]};\n")
        modrm_file.write("    wire [9:0] chosen_data4;\n")
        modrm_file.write("    select_length sl4(.data(buffered_data), .sel(sel4), .out(chosen_data4));\n\n")

        modrm_file.write("    wire [39:0] concat_no_double_data;\n")
        modrm_file.write("    assign concat_no_double_data = {chosen_data3, chosen_data2, chosen_data1, chosen_data0};\n")
        modrm_file.write("    wire [39:0] concat_double_data;\n")
        modrm_file.write("    assign concat_double_data = {chosen_data4, chosen_data3, chosen_data2, chosen_data1};\n\n")


        modrm_file.write("    wire [9:0] no_double_data;\n")
        modrm_file.write(f"    muxnm_tristate #({4}, {10}) mxt1(.in(concat_no_double_data), .sel(prefSize) ,.out(no_double_data));\n")
        modrm_file.write("    wire [9:0] double_data;\n")
        modrm_file.write(f"    muxnm_tristate #({4}, {10}) mxt2(.in(concat_double_data), .sel(prefSize) ,.out(double_data));\n")

        modrm_file.write("    wire [9:0] actual_selected_data;\n")
        modrm_file.write("    muxnm_tree #(1, 10) mxt3(.in({double_data, no_double_data}), .sel(isDoubleOp) ,.out(actual_selected_data));\n\n")

        modrm_file.write("    assign length = {3'b000, actual_selected_data[9:5]};\n")
        modrm_file.write("    assign length_no_imm = {3'b000, actual_selected_data[4:0]};\n")







        






        modrm_file.write("\n\nendmodule\n\n")




if __name__ == "__main__":
    num_bits = 12
    truth_table = generate_truth_table(num_bits)
    generate_lengths(truth_table)
    output_verilog(truth_table)