#!/bin/python3

def main():
    code = ''
    for chip in range(0,16):
        for cloch in range(0,32):
            code += '$fdisplay(file, \"[0x%h]:    %0h %0h %0h %0h    %0h %0h %0h %0h    %0h %0h %0h %0h    %0h %0h %0h %0h\", {4\'b'+('{:04b}'.format(chip))+',5\'b'+('{:05b}'.format(cloch))+',2\'b00,4\'b0000}, '
            for bank in range(0,4):
                for dram in range(0,4):
                    code += 'banks['+str(bank)+'].bnk.bank_slices['+str(chip)+'].dram.cells['+str(dram)+'].sram.mem['+str(cloch)+']'
                    code += ');' if dram == 3 and bank == 3 else ', '
            print(code)
            code = ''

if __name__ == '__main__':
    main()    