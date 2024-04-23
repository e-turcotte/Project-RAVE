from colHelper import *
import csv
import copy

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
                    rows[-1][9] = "32'd" +  str(i) #format(i, '032b')
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
        row[14] = "x"
        row[21] = "x"
        row[27] = "x"
        OP =  row[0].split()
        asm = row[1].split()
        opcode = asm[0]
        opH = row[2]
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
            row[40] = "1'b1"
        else:
            row[40] = "1'b0"

        #isBR
        if (opcode == "JMP" or opcode == "JNBE" or opcode == "JNE" or opcode == "RET" or opcode == "CALL" or opcode == "REtid" ):
            row[39] = "1'b1"
        else:
            row[39] = "1'b0"

        #conditionals
        if(opcode == "JNBE"):
            row[37] = "2'b11"
        elif (opcode == "JNE"):
            row[37] = "2'b10"
        elif (opcode == "JNBE"):
            row[37] = "2'b11"
        else :
            row[37] = "2'b00"

        #isImm
        if "imm" in row[1] or "rel" in row[1]:
            row[41] = "1'b1"
            for items in asm:
                if "imm" in items or "rel" in items:
                    row[42] = "2:b11" if ":" in items else "2'b10" if "32" in items else "2'b01" if "16" in items  else "2'b00"

        else:
            row[41] = "1'b0"
            row[42] = "2'b00"

        if(opH == "8'hD1" or opH == "8'hD0" ):
            row[34] = "1'b1"
        else:
            row[34] = "1'b0"

        row = helperOP(row, OP, asm)

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


if __name__ == '__main__':
    main()