from colHelper import *
import csv
import copy
from cs_data import *
fields = []
rows = []
numRows = 0
numCols = 0
def main():

    print("huh")
    with open('opcodes.csv', 'r', newline='') as CS_CSV:
        csvreader = csv.reader(CS_CSV)
        fields2 = next(csvreader)
        fields = next(csvreader)
        skip = True
        for row in csvreader:
            if '+' in row[0]:
                for i in range (8):
                    rows.append(copy.deepcopy(row))
                    # rows[-1][0] = rows[-1][0].sp
                    temp = rows[-1][0].split()
                    temp[0] = format(int(temp[0][:-2] + "0",16)+(int(temp[0][-2],16) + i), '02X').upper()
                    rows[-1][2] = str("8'h" + (temp[0]))

                    # rows[-1][2] = int(rows[-1][0].split()[0],16) + i
                    rows[-1][20] = "3'd" +  str(i) #format(i, '032b')
            else:
                if(not "REP" in row[1]):
                    rows.append(row)
                    rows[-1][2] = "8'h" + rows[-1][0].split()[0]
                #rows[-1][9] = "3'b000"

        numRows = csvreader.line_num
    print('Field names are:' + ', '.join(field for field in fields))

    skip = True
    for row in rows:
        # parsing each column of a row
        OP =  row[0].split()
        asm = row[1].split()
        print(asm)
        opcode = asm[0]
        opH = row[2]
        row[19] = "2'b11" if "64" in row[1] else "2'b10" if "32" in row[1] or "EAX" in row[1] else "2'b00"
        if ("Sreg" in row[1] ) :
            row[19] = "2'b01"
        if ( "GS" in row[1] or "FS" in row[1] or "SS" in row[1] or "ES" in row[1] or "DS" in row[1] or "CS" in row[1]):
            row[19] = "2'b10"
        row[9] = "1'b0"  # MUX_AND_INT

        if "?" in row[0]:
            row[47] = "3'd" + row[0][row[0].find("/") + 1]
            row[46] = "1'b1"
        else:
            row[46] = "1'b0"
            row[47] = "3'd0"
        if "0F" in row[0]:
            row[6] = "8'h" + row[0][row[0].find("F") + 2] + row[0][row[0].find("F") + 3]
        else:
            row[6] = "8'h00"

        #HANDLE isMOD
        if  '/' in row[1]:
            row[3] = "1'b1"
            if '/' in asm[1]:
                row[4] = "1'b0"
            else:
                row[4] = "1'b1"
        else:
            row[3] = "1'b0"
            row[4] = "1'b0"

        if OP[0] == "0F":
            row[5] = "1'b1"
        else:
            row[5] = "1'b0"

        #isFP
        if(opcode == "FDIV" or opcode == "FMUL" or opcode == "FADD"):
            row[16] = "1'b1"
        else:
            row[16] = "1'b0"

        #isBR
        if (opcode == "JMP" or opcode == "JNBE" or opcode == "JNE" or opcode == "RET" or opcode == "CALL" or opcode == "REtid" ):
            row[15] = "1'b1"
        else:
            row[15] = "1'b0"

        #conditionals
        if(opcode == "JNBE"):
            row[13] = "2'b11"
        elif (opcode == "JNE"):
            row[13] = "2'b10"
        elif (opcode == "JNBE"):
            row[13] = "2'b11"
        elif(opcode == "CMOVC"):
            row[13] = "2'b01"
        else :
            row[13] = "2'b00"

        #isImm
        if "imm" in row[1] or "rel" in row[1]:
            row[17] = "1'b1"
            for items in asm:
                if "imm" in items or "rel" in items:
                    row[18] = "2:b11" if ":" in items else "2'b10" if "32" in items else "2'b01" if "16" in items  else "2'b00"

        else:
            row[17] = "1'b0"
            row[18] = "2'b00"

        if(opH == "8'hD1" or opH == "8'hD0" ):
            row[10] = "1'b1"
        else:
            row[10] = "1'b0"
        
        
        if ("r/m8" in row[1] and "r8" in row[1]) or ("r/m16" in row[1] and "Sreg" in row[1]) or ("r/m32" in row[1] and "r32" in row[1]) or ("m64" in row[1] ):
            row[40] = "1'b1"
        else:
            row[40] = "1'b0"
        if("r/m16" in row[1]):
            if("Sreg" in row[1]):
                print(row[40])
        if(len(asm) > 1 and (("r/m8" in asm[1]) or ("r/m32" in asm[1]) or ("r/m16" in asm[1]) or ("m64" in asm[1]))): #if MODRM first operand, overwrite OP1 to either MOD or REG mux select
            row[43] = "2'b01"
        elif (len(asm) > 2 and (("r/m8" in asm[2]) or ("r/m32" in asm[2]) or  ("r/m16" in asm[2])or ("m64" in asm[2]))): #if MODRM second operand, overwrite OP1 to either MOD or REG mux select
            row[43] = "2'b10"
        else:
            row[43] = "2'b00"

        if(opH == "8'h8E" or opH == "8'h8C"):
            row[44] = "1'b1"
        else:
            row[44] = "1'b0"
        helperOP(row, OP, asm)

        if opH == "8'hCA" or opH == "8'hCB" or opH == "8'h9A":
            row[45] = "4'b1000"
            row[19] = "2'b10"
        elif opH == "8'hA4":
            row[45] = "4'b0001"
            row[19] = "2'b10"
        elif opH == "8'hA5":
            row[45] = "4'b0100"
            row[19] = "2'b10"
        else:
            row[45] = "4'b0000"
        row[14] = "1'b0"
    numRows = 1

    with open('output.csv', 'w', newline='') as output_file:
        csvwriter = csv.writer(output_file)

        # Write field names
        csvwriter.writerow(fields)
        csvwriter.writerow(fields2)


        # Write rows
        for row in rows:
            csvwriter.writerow(row)

    print("Data has been written to output.csv")

    generateVerilog(rows, fields)

if __name__ == '__main__':
    main()