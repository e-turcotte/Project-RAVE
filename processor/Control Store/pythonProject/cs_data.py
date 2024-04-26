toAdapt = ["dest1_mux", "op1_mux", "dest2_mux", "op2_mux", "R1","R2" "S3", "M1_RW", "S1", "SIZE"]
def generateVerilog(rows, fields):
    allFields = ""
    fieldList = []
    # with open("CS_Adapter.v", "w") as file:
    #     output = genOutput2(rows, fields)
    #     inputs = "input [226:0] toSplit"
    #     file.write("module csAdapter(\n" + output + "\n" + inputs + "\n);\n")

    #     assigns = ""
    #     index = 0
    #     for i in range(len(fields) - 2):
    #         if (i < 3):
    #             continue

    #         length = int(rows[0][i].split("'")[0])
    #         assigns += "assign " + fields[i] + "=" + "toSplit[" + str(index + length - 1) + ":" + str(index) + "];\n"
    #         allFields += fields[i] + "/"
    #         index += int(rows[0][i].split("'")[0])
    #     fieldList = allFields.split("/")

    #     file.write(assigns)
    #     file.write("endmodule")
    assigns = ""
    index = 0
    for i in range(len(fields) - 2):
        if (i < 3):
            continue

        length = int(rows[0][i].split("'")[0])
        assigns += "assign " + fields[i] + "=" + "toSplit[" + str(index + length - 1) + ":" + str(index) + "];\n"
        allFields += fields[i] + "/"
        index += int(rows[0][i].split("'")[0])
    fieldList = allFields.split("/")

    # with open("cs_data.v", "w") as file:
    #     length = 0
    #     output = genOutput(rows, fields)
    #     wireCnt = 0

    #     #inputs = "input [7:0] B1, B2, B3,\ninput isPref"

    #     file.write("module cs_data(\n" + output + ");\n")

    #     for row in rows:
    #         wireVal = genWireConcat(row, fields)
    #         #file.write("wire[227:0] w" + str(wireCnt) + ";\n")
    #         file.write("assign w" + str(wireCnt) + " = " + wireVal)
    #         wireCnt += 1
    #     file.write("\nendmodule")

    with open("cs_select.v","w") as file:
        input = genInput2(rows,fields) + "input [7:0] B1, B2, B3"
        output = "output[227:0] chosen,\n"
        file.write("module cs_select(\n" + output + "\n" + input + ");\n\n")
        eCNT = 0
        wCNT = 0
        for row in rows:
            equals = genEqual(row, fields, eCNT, wCNT, "B1", "B2", "B3")
            file.write(equals + "\n")
            wCNT += 1
            eCNT += 1

        buf, tri, dCat, sCat = genTriM(eCNT, "chosen", str(0))
        file.write(buf)
        file.write(dCat)
        file.write(sCat)
        file.write(tri)
        file.write("\nendmodule")

    # with open("cs_top.v","w") as file:
    #     input = "input[7:0] B1, B2, B3, B4, B5, B6,\n input isREP, isSIZE, isSEG,\n input[3:0] prefSize, \n input[5:0] segSEL "
    #     output = genOutput2(rows,fields)
    #     file.write("module cs_top(\n" + output + "\n" + input + ");\n\n")
    #     wires = genWire2(fields, rows)
    #     file.write(wires)
    #     w = genW()

    #     file.write("cs_data cs1("+w+");\n")

    #     file.write("wire[227:0] chosen, chosen1, chosen2, chosen3, chosen4;\n ")
    #     file.write("wire[23:0] chosen5;\n")

    #     file.write("cs_select css1(" + w + ", .chosen(chosen1), .B1(B1), .B2(B2), .B3(B3));\n")
    #     file.write("cs_select css2(" + w + ", .chosen(chosen2), .B1(B2), .B2(B3), .B3(B4));\n")
    #     file.write("cs_select css3(" + w + ", .chosen(chosen3), .B1(B3), .B2(B4), .B3(B5));\n")
    #     file.write("cs_select css4(" + w + ", .chosen(chosen4), .B1(B4), .B2(B5), .B3(B6));\n")
    #     file.write("muxnm_tree #(2, 24) mxt420({{B6,B5,B4}, {B5, B4, B3}, {B4,B3,B2}, {B3,B2,B1}}, prefSize,chosen5);\n")
    #     file.write("muxnm_tree #(2, 277) mxt69({chosen4, chosen3, chosen2,chosen1}, prefSize,chosen);\n")
    #     file.write("cs_overwrite cso1("+genOUT(fieldList)+" .chosen(chosen), .B1(chosen5[23:16]), .B2(chosen5[15:8]), .B3(chosen5[7:0]), .isREP(isREP), .isSIZE(isSIZE), .isSEG(isSEG), .prefSize(prefSize), .segSEL(segSEL));\n\n")
    #     file.write("//cs_top cst1("+genOUT(fieldList)+");")

    #     file.write("\nendmodule")



    # with open("cs_overwrite.v", "w") as file:
    #     input = "input [227:0] chosen,\n input isREP, isSIZE, isSEG,\n input[3:0] prefSize, \n input[5:0] segSEL"
    #     output = genOutput2(rows, fields)
    #     file.write("module cs_overwrite(\n" + output + "\n" + input + ",\ninput [7:0] B1, B2, B3);\n\n")
    #     file.write("inv1$ inv1(size_n, isSIZE);\ninv1$ inv2(size1_n, size0[1]);\nnand3$ n1(size_s, size_n, size1_n, size[0]);\nmux2n mx12(size, size, 2'b01, size_s);\n")
    #     csAdapt = genBranchOut(fieldList, 0, "chosen")
    #     wires = genWires(rows,fields, 0)
    #     file.write(wires + "\n")
    #     file.write(csAdapt)
    #     override = "mux2n  # (8)(m, B2, B3, isDouble0);\nmux2$ mx1(m1, B2[6], B3[6], isDouble0);\nmux2$ mx2(m2, B2[7], B3[7], isDouble0);\nand3$ a1(m1rw_s, isMOD0, m1, m2);\nmux2n  # (2) mx3(M1_RW, M1_RW0, 2'b00, m1rw_s);\nand4$ a2(s3_s, isMOD0, m1, m2, S3_MOD_OVR0);\nmux2n  # (3)  mx4(S3, S30, m[5:3], s3_s);\nand4$ a3(r1_s, isMOD0, m1, m2, R1_MOD_OVR0);\nmux2n  # (3)  mx5(R1, R10, m[5:3], r1_s);\nand2$ a4(d1_s, dest1_mux0[8], OP_MOD_OVR0[0]);\nand2$ a5(op1_s, dest1_mux0[8], OP_MOD_OVR0[0]);\nand2$ a6(d2_s, dest2_mux0[8], OP_MOD_OVR0[1]);\nand2$ a7(op2_s, dest2_mux0[8], OP_MOD_OVR0[1]);\nmux2n  # (3) mx6(dest1_mux, dest1_mux0, 13'h0002);\nmux2n  # (3) mx7(dest2_mux, dest2_mux0, 13'h0002);\nmux2n  # (3) mx8(op1_mux, op1_mux0, 13'h0002);\nmux2n  # (3) mx9(op1_mux, op1_mux0, 13'h0002);\nmux2n #(3) mx10(R2, R20, m[2:0], m1rw_s);\nwire [2:0] s_out; \n muxmn_tree #(3,3) mxtr( {3'd7, 3'd6, 3'd5, 3'd4, 3'd3, 3'd2,3'd1, 3'd0},{2'b00, segSEL}, s_out );\nand2$(seg_sel, isMOD0, isSEG); \n mux2n #(3) mx11(S1, S10, s_out, seg_sel);"
    #     file.write(override)
    #     file.write("\nendmodule")

# def genModOverwrite(row, unqID):
def genW():
    output = ""
    for i in range(140):
        if(i != 139):
            output += ".w" +str(i) + "(w" + str(i) + "), "
        else:
            output += ".w" + str(i) + "(w" + str(i) + ") "
    return output
def genOUT(fieldList):
    output = ""
    for s in fieldList:
        if s == "":
            continue
        output += "." +s + "(" + s + "), "
    return output
def genBranchOut(allFields, unqID, toSplit):
    # print(allFields)
    csAdaptorCall = "csAdapter csa" + str(unqID) + "(." + allFields[0] + "(" + allFields[0] + str(unqID) + ")"
    for i in range(len(allFields) - 1):
        if (i == 0):
            continue
        if(allFields[i] in toAdapt):
            csAdaptorCall += ", ." + allFields[i] + "(" + allFields[i] + str(unqID) + ")"
        else:
            csAdaptorCall += ", ." + allFields[i] + "(" + allFields[i] +")"
    csAdaptorCall += ", " + "." + toSplit + "(" + toSplit + "));"
    # print(csAdaptorCall)
    return csAdaptorCall


def genTriM(eCNT, retStr, catCNT):
    buf = ""
    tri = ""
    sigCat = "wire[139:0] sigCat" + catCNT + ";\nassign sigCat = {beq0"
    dataCat = "wire[31779:0] dataCat" + catCNT + ";\n assign dataCat ={w0"

    for i in range(eCNT):
        buf += "bufferH256$ b" + str(i) + "(beq" + str(i) + ", w" + str(i) + ");\n"
        if (i == 0):
            continue
        sigCat += ", beq" + str(i)
        dataCat += ", w" + str(i)
    dataCat += "};\n"
    sigCat += "};\n"

    tri = "muxnm_tree #(8, 227) mxt1(dataCat" + catCNT + ", sigCat" + catCNT + " ," + retStr + ");\n"

    return buf, tri, sigCat, dataCat


def genEqual(row, fields, eCNT, wCNT, B1, B2, B3):
    o = "1'b1"
    z = "1'b0"

    if (row[5] == o and row[46] == o):
        return "equaln #(19) e" + str(eCNT) + "({" + B1 + ", " + B2 + ", " + B3 + "[5:3]}, {" + row[2] + ", " + row[
            6] + ", " + row[47] + "}, weq" + str(wCNT) + ");"
    elif row[5] == o and row[46] == z:
        return "equaln #(16) e" + str(eCNT) + "({" + B1 + ", " + B2 + "}, {" + row[2] + ", " + row[6] + "}, weq" + str(
            wCNT) + ");"
    elif row[5] == z and row[46] == o:
        return "equaln #(11) e" + str(eCNT) + "({" + B1 + ", " + B2 + "[5:3]}, {" + row[2] + ", " + row[
            47] + "}, weq" + str(wCNT) + ");"
    else:
        return "equaln #(8) e" + str(eCNT) + "({" + B1 + "}, {" + row[2] + "}, weq" + str(wCNT) + ");"


def genWireConcat(row, fields):
    wireVal = "{"
    i = 0
    for i in range(len(row) - 2):
        if (i < 3):
            continue
        if (i > 3):
            wireVal += ", "
        wireVal += str(row[i])
        # print(wireVal)

    wireVal += "};\n"
    return wireVal


def genOutput(rows, fields):
    output = ""
    for i in range(140):
        output += "output [" + "227:0] w" + str(i) + ",\n"
    return output

def genInput2(rows, fields):
    output = ""
    for i in range(140):
        output += "input [" + "227:0] w" + str(i) + ",\n"
    return output

def genWire2(rows, fields):
    output = ""
    for i in range(140):
        output += "wire [" + "227:0] w" + str(i) + "; "
    output += "\n"
    return output


def genWires(rows, fields, unqID):
    output = ""
    for i in range(len(fields) - 2):
        if (i < 3):
            continue
        # print(str(i))
        # print(rows[0][i])
        output += "wire [" + str(int(rows[0][i].split("'")[0]) - 1) + ":0] " + fields[i] + str(unqID) + "; "
    return output

def genOutput2(rows,fields):
    output = ""
    for i in range(len(fields) - 2):
        if (i < 3):
            continue
        output += "output [" + str(int(rows[0][i].split("'")[0]) - 1) + ":0] " + fields[i] + ",\n"
    return output