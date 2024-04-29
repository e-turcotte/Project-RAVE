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

reg_bits = 9

num_outputs = 2 # length and length_no_imm
length_bit_size = 4 # 4 bits for length
length_no_imm_bit_size = 4 # 4 bits for length_no_imm

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
                    if key[reg_bits] == 1 and key[reg_bits+1] == 0 and key[reg_bits+2] == 1: #disp16
                        length += 2
                        length_no_imm += 2
                else: #32 bit
                    if key[reg_bits] == 1 and key[reg_bits+1] == 0 and key[reg_bits+2] == 0: #SIB
                        length += 1
                        length_no_imm += 1
                    if key[reg_bits] == 1 and key[reg_bits+1] == 0 and key[reg_bits+2] == 1: #disp32
                        length += 4
                        length_no_imm += 4


            elif key[mod_bits] == 0 and key[mod_bits+1] == 1:
                if(key[is_opsize_override] == 1): # 16 bit
                    length += 1
                    length_no_imm += 1
                else: #32 bit
                    if key[reg_bits] == 1 and key[reg_bits+1] == 0 and key[reg_bits+2] == 0: #SIB
                        length += 1
                        length_no_imm += 1
                    length += 1
                    length_no_imm += 1


            elif key[mod_bits] == 1 and key[mod_bits+1] == 0:
                if(key[is_opsize_override] == 1): # 16 bit
                    length += 2
                    length_no_imm += 2
                else: #32 bit
                    if key[reg_bits] == 1 and key[reg_bits+1] == 0 and key[reg_bits+2] == 0: #SIB
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
    print("module instruction_length(")
    print("    input wire [11:0] in,")
    print(f"    output wire [{length_bit_size + length_no_imm_bit_size - 1}:0] out")
    print(");")
    print("    wire [11:0] buffered_input;")
    print('    ', end="")
    print(f"wire [{length_bit_size + length_no_imm_bit_size - 1}:0] ", end="")
    for i, key in enumerate(truth_table.keys()):
        print(f'wire{i}, ' if (i < 4095) else f'wire{i};', end="")
    print()
    print("    bufferH4096_12b$(.in(in), .out(buffered_input));")
    for i, key in enumerate(truth_table.keys()):
        print(f"    assign wire{i} = " + "{" , end="")
        for j in range(num_outputs):
            print(f"{length_bit_size}'d" + f'{truth_table[key][0]}' + ", " if (j < num_outputs - 1) else f"{length_no_imm_bit_size}'d" + f'{truth_table[key][1]}', end="")
        print("};")

    print()
    print()

    for i, key in enumerate(truth_table.keys()):
        #concatenate the bits in the key
        key_str = "12'b" + "".join(str(x) for x in key)
        print(f"    equaln #(12) e{i}(.a(buffered_input), .b({key_str}), .eq(weq{i}));")

    print()
    print()

    print("    wire [4095:0] weq_concat;")
    print("    assign weq_concat = {", end="")
    for i in range(4096):
        print(f"weq{4095 - i}, " if (i < 4095) else f"weq{4095 - i}", end="")
    print("};")

    print()
    

    print(f"    wire [{4096*(length_bit_size + length_no_imm_bit_size) - 1}:0] data_concat;")
    print("    assign data_concat = {", end="")
    for i in range(4096):
        print(f"wire{4095 - i}, " if (i < 4095) else f"wire{4095 - i}", end="")
    print("};")

    print()

    print(f"    muxnm_tristate #({4096}, {length_bit_size + length_no_imm_bit_size}) mxt1(.in(data_concat), .sel(weq_concat) ,.out(out));")


    print("endmodule")



if __name__ == "__main__":
    num_bits = 12
    truth_table = generate_truth_table(num_bits)
    generate_lengths(truth_table)
    output_verilog(truth_table)