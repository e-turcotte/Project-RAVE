import pandas as pd
import openpyxl

df = pd.read_excel('Book2.xlsx', sheet_name=0)

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
    data_store[siganl_concat] = 0
    signals.append(siganl_concat)

for i, value in enumerate(df.iloc[:, 1]):
    data_store[signals[i]] = value

with open("length_data.v", "w") as length_data_file:
        length_data_file.write("module length_data(\n")
        length_data_file.write(f"    output wire [{4096*(8) - 1}:0] out\n")
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