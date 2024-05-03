import pandas as pd
import openpyxl

df = pd.read_excel('lengths.xlsx', sheet_name=0)

data_store = {}
signals = []

for value in df.iloc[:, 0]:
    # print(value.split(','))
    temp = value.split(',')
    pref = temp[0].split('=')
    pref_val = pref[1].strip()
    isDouble = temp[1].split('=')
    isDouble_val = isDouble[1].strip()
    isImm = temp[2].split('=')
    isImm_val = isImm[1].strip()
    immSize = temp[3].split('=')
    immSize_val = immSize[1].strip()
    modSIBmux = temp[4].split('=')
    modSIBmux_val = modSIBmux[1].strip()
    siganl_concat = pref_val + isDouble_val + isImm_val + immSize_val + modSIBmux_val
    # print(siganl_concat)
    data_store[siganl_concat] = 0
    signals.append(siganl_concat)

for i, value in enumerate(df.iloc[:, 1]):
    data_store[signals[i]] = value

total_output_bits = len(data_store.keys())

with open("../length_data.v", "w") as length_data_file:
    length_data_file.write("module length_data(\n")
    length_data_file.write(f"    output wire [{(8*total_output_bits) - 1}:0] out\n")
    length_data_file.write(");\n")

    length_data_file.write(f"    wire [{total_output_bits - 1}:0]")
    for i, key in enumerate(data_store.keys()):
        length_data_file.write(f'wire{i}, ' if (i < total_output_bits - 1) else f'wire{i};\n')
    
    
    for i, key in enumerate(data_store.keys()):
        length_data_file.write(f"    assign wire{i} = " + "{")
        length_data_file.write(f"8'd" + f'{data_store[key]}')
        length_data_file.write("};\n")

    length_data_file.write(f"    wire [{(8*total_output_bits) - 1}:0] data_concat;\n")
    length_data_file.write("    assign data_concat = {")
    for i in range(total_output_bits):
        length_data_file.write(f"wire{total_output_bits - i}, " if (i < total_output_bits) else f"wire{total_output_bits - i}")
    length_data_file.write("};\n")

    length_data_file.write("    assign out = data_concat;\n")

    length_data_file.write("\n\nendmodule\n\n")


with open("../select_length.v", "w") as sel_file:
    sel_file.write("module select_length(\n")
    sel_file.write(f"    input wire [{(8*total_output_bits) - 1}:0] data,\n")
    sel_file.write("    input wire [11:0] sel,\n")
    sel_file.write(f"    output wire [{total_output_bits - 1}:0] out\n")
    sel_file.write(");\n")
    sel_file.write(f"    wire [{total_output_bits - 1}:0] sel_out;\n")
    sel_file.write("    select_signal s0(.sel(sel), .out(sel_out));\n")
    sel_file.write(f"    muxnm_tristate #({total_output_bits}, {8}) mxt1(.in(data), .sel(sel_out) ,.out(out));")
    sel_file.write("\n\nendmodule\n\n")

    

    sel_file.write("module select_signal(\n")
    sel_file.write("    input wire [11:0] sel,\n")
    sel_file.write(f"    output wire [{total_output_bits - 1}:0] out\n")
    sel_file.write(");\n")
    sel_file.write("    wire [11:0] buffered_input;\n")
    sel_file.write("    bufferH1024_nb$ #(12) buff(.in(sel), .out(buffered_input));\n")
    
    for i, key in enumerate(data_store.keys()):
        #concatenate the bits in the key
        key_str = "12'b" + key
        sel_file.write(f"    equaln #(12) e{i}(.a(buffered_input), .b({key_str}), .eq(weq{i}));\n")

    sel_file.write("    assign out = {")
    for i in range(total_output_bits):
        sel_file.write(f"weq{total_output_bits - i}, " if (i < total_output_bits) else f"weq{total_output_bits - i}")
    sel_file.write("};\n")
    sel_file.write("\n\nendmodule")