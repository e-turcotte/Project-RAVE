import sys
import subprocess
import os
from node import node
import math
from genNode import *
from genTree import *
#'/home/ecelrc/students/jnederveld/uarch/PS2/espresso.linux'
outputFile = 'output'
finOut = ''


def printSOP(SOP ,offInpList, outList):
    print()
    for numOut in range(len(SOP)):
        print(outList[numOut], ':')
        for numSum in range (len(SOP[numOut])):
            print('(', end='')
            for numProd in range(len(SOP[numOut][numSum])):
                if(SOP[numOut][numSum][numProd] < 0):
                    print('!', end='')
                    print(offInpList[-1 * SOP[numOut][numSum][numProd]], end ='')
                else:
                    print(offInpList[SOP[numOut][numSum][numProd]], end ='')
                if(numProd != len(SOP[numOut][numSum]) -1):
                    print(' && ',end='')
            if(numSum != len(SOP[numOut])-1 ):
                 print(') || ', end='')
            else:
                print(')', end='')
        print()
        print()

def calcMin(SOPouts, x):
    mostOR = 0
    mostAND = 0
    mostGate = 0
    usedNOT = 0

    localMostOR = len(SOPouts[x])
    if(len(SOPouts[x]) > mostOR):
        mostOR =  len(SOPouts[x])
    localMostAND = 0
    #updated = false
    for y in range (len(SOPouts[x])):
        notPlus = 1 if any(number < 0 for number in SOPouts[x][y]) else 0
        if(notPlus==1):
            usedNOT = 1
        if(len(SOPouts[x][y])  > mostAND):
            mostAND =  len(SOPouts[x][y])
        if(len(SOPouts[x][y]) > localMostAND):
            localMostAND =  len(SOPouts[x][y])
        
        if(localMostAND + localMostOR > mostGate):
            mostGate = localMostAND + localMostOR 
     
    notMinLayer = usedNOT            
    andMinLayer = math.ceil(math.log(mostAND, 4))
    orMinLayer =math.ceil(math.log(mostOR,4))
    minLayer = math.ceil(math.log(mostGate,4))
    return notMinLayer, andMinLayer, orMinLayer, minLayer

def calcTerminate(andMinLayer, orMinLayer):
    evenAND = (andMinLayer % 2 == 0)
    evenOR = (orMinLayer % 2 == 0)
    if(evenAND and evenOR):
        return False, andMinLayer +orMinLayer, 'Normal'
    if(andMinLayer == 1 and orMinLayer == 1):
        return False, 2, 'AND1OR1'
    if(andMinLayer % 2 == 0 and orMinLayer == 1):
        return True, andMinLayer+1, 'AND2OR1'
    if(andMinLayer == 1 and orMinLayer %2 == 0):
        return True, 1 + orMinLayer, 'AND1OR2'
    if(andMinLayer >= 3 and andMinLayer % 2 == 1 and orMinLayer >= 3 and orMinLayer % 2 == 1):
        return False, andMinLayer + orMinLayer, 'xAND1OR1'
    if(andMinLayer %2 == 1 and orMinLayer%2 == 0):
        return True, andMinLayer + orMinLayer, 'AND3OR2'
    if(andMinLayer %2 == 0 and orMinLayer%2 == 1):
        return True, andMinLayer + orMinLayer, 'AND2OR3'
wireList = []
def toVerilog(fileName, outputList, inputList, logicTrees):
    global wireList
    notWireList = []
    fileOut = fileName + '.v'
    file = open(fileOut, 'w')
    file.write("module " + fileName + "(\n")
    io = ''
    notInp = ''
    notCheck = [0]*len(inputList)
    for x in range(len(inputList) -1):
        io += "input wire "+inputList[x+1]+",\n"
        found = False
        for y in range(len(outputList)):
            found = found or logicTrees[y].finds(-1 * (x+1))
       # print(found)
        if(found and notCheck[x] == 0):
            notCheck[x] = 1  
            notWireList.append("not"+inputList[x+1])
            notInp += "\ninv1$ n"+str(x)+"(not"+inputList[x+1]+", "+inputList[x+1]+");"
    for x in range(len(outputList)):
        if(x != len(outputList) -1):
            io += "output wire "+outputList[x] +",\n"
        else:
            io += "output wire "+outputList[x] +");\n"
    file.write(io)
    
    file.write(notInp)
    file.write('\n')
    file.write('\n')
    
    #print(notInp)
    for x in range(len(outputList)):
        file.write(printHelper(inputList, logicTrees[x], outputList[x]))
        file.write('\n')

    file.write("endmodule\n")

def toStateVerilog(fileName, outputList, inputList, logicTrees):
    global wireList
    notWireList = []
    fileOut = fileName + '.v'
    file = open(fileOut, 'w')
    file.write("module " + fileName + "(\n")
    io = ''
    notInp = ''
    notCheck = [0]*len(inputList)
    io += "input wire "+"clk"+",\n"
    io += "input wire "+"set_n"+",\n"
    io += "input wire "+"rst_n"+",\n"
    for x in range(len(inputList) -1):
        if inputList[x+1][0] != '*':
            io += "input wire "+inputList[x+1]+",\n"
        found = False
        for y in range(len(outputList)):
            found = found or logicTrees[y].finds(-1 * (x+1))
        # print(found)
        if(found and notCheck[x] == 0):
            notCheck[x] = 1  
            notWireList.append("not"+inputList[x+1])
            if(inputList[x+1][0] == '*'):
                notCheck[x] = notCheck[x]
            else:
                notInp += "\ninv1$ n"+str(x)+"(not"+inputList[x+1]+", "+inputList[x+1]+");"
    
    for x in range(len(outputList)):
        if(outputList[x][0] != '*'):
            if(x != len(outputList) -1):
                io += "output wire "+outputList[x] +",\n"
            else:
                io += "output wire "+outputList[x] +");\n"
    file.write(io)

    file.write(notInp)
    file.write("\n")
    file.write("\n")
    #print(notInp)
    for x in range(len(outputList)):
        if(outputList[x][0] == '*'):
            file.write(printHelper(inputList, logicTrees[x], outputList[x][1:]+"_NS"))
        else:
            file.write(printHelper(inputList, logicTrees[x], outputList[x]))
        file.write("\n")
    sCnt = 0
    for x in range(len(outputList)):
        if(outputList[x][0] == '*'):
            sCnt+=1
            
            file.write("dff$ s"+str(sCnt)+"(clk, " +  outputList[x][1:] +'_NS, '  + outputList[x][1:]+ ", "+ "not"+inputList[x+1][1:] + ", rst_n, set_n);\n")

    file.write("\nendmodule\n")

    
wireCnt =0
funcCnt = 0   
def  printHelper(inputList, logicTree, wire):
    global wireCnt
    global funcCnt
    if(logicTree.isOp == False):
        
        if(logicTree.value > 0):
            return inputList[logicTree.value] if inputList[logicTree.value][0] != '*' else inputList[logicTree.value][1:]
        else:
            return "not"+inputList[abs(logicTree.value)] if inputList[abs(logicTree.value)][0] != '*' else inputList[abs(logicTree.value)][1:]
    else:
        if(logicTree.children[0].isOp == True):
            numIn = 0
            inp = []
            returnVal = ''
            for x in range(logicTree.childCnt):
                numIn += 1
                wireCnt +=1
                inp.append('w'+str(wireCnt))
                returnVal += printHelper(inputList, logicTree.children[x], (inp[x]))
            funct = "inv"
            if(logicTree.op == '.'):
                funct = "nand"
            elif(logicTree.op == '@'):
                funct = "nor"
            funcCnt += 1
            
            return returnVal+ printFunc(funct, wire,logicTree.childCnt, inp, funcCnt)


        else:
            numIn = 0
            inp = []
            logicTree.printTreeLog(inputList,0)
            returnVal  = wire + ''
            for x in range(logicTree.childCnt):
                wireCnt += 1
                returnVal += ", "+ printHelper(inputList, logicTree.children[x], 'w'+str(wireCnt))
            funct = "inv"
            if(logicTree.op == '.'):
                funct = "nand"
            elif(logicTree.op == '@'):
                funct = "nor"
            funcCnt += 1

            return funct+str(logicTree.childCnt)+"$ f"+str(funcCnt)+"("+returnVal + ");\n"

def printFunc(operative, out, num_in, inp,func):
    
    global wireList     
    toOut= out
    if(out[0] == '*'):
        toOut = out[1:]
    parameters = toOut
    for x in range(num_in):
        parameters += ', '+ inp[x]
        if(inp[x][0] == 'w'):
            wireList.append(inp[x])
    return operative+str(num_in)+"$ f"+str(func)+"("+parameters + ");\n"


isOdd = False
critPath = 10000000


def main():
    isOdd = False
    fileTT = sys.argv[-1]
    inpState = sys.argv[-2]
    isState = False
    if(inpState == "-state"):
        isState = True
    #print(isState.split(r"-")[0])

    finOut = fileTT.split(r".")[0] 
    #print(finOut)

    cwd = os.getcwd()
    path = os.path.join(cwd, 'espresso.linux')
    try:
        with open(outputFile, 'w') as output:
            #'-eeat',
            subprocess.run([path ,'-eeat',   fileTT, ], stdout = output)
    except FileNotFoundError:
        print(f"Error: The executable at {path} was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
    
    with open(fileTT) as inpF, open(outputFile) as outF:
        #Get number of inputs/outputs
        inpLine = outF.readline()
        outputLine = outF.readline()
        #print(inpLine)
        inpCnt = int(inpLine.split()[1])
        outCnt = int(outputLine.split()[1])

        #Get variable names
        offInpList = outF.readline().split()
        inputList =  offInpList[1:]
        outputList = outF.readline().split()[1:]
        offInpList 

        #Copy all output rows
        rowSOP = int(outF.readline().split()[1])
        parseO = []
        for x in range(rowSOP):
            parseO.append( outF.readline().split())    
    
    #Create an array of arrays that hold all the products that make up the outputs
    # The value of a location acts as the index+1 (cant have -0) of the input it refers to
    # Negative valued numbers mean the NOT value of the referenced input
    SOPouts = []
    for x in range(outCnt):
        SOPouts.append([])
    for curRow in range(rowSOP):
        newProduct = []
        
        for curCol in range(inpCnt):
            if(parseO[curRow][0][curCol] == '1'):
                newProduct.append(1+curCol)
            if(parseO[curRow][0][curCol] == '0'):
                newProduct.append(-(1+curCol))
        for curOut in range (outCnt):
            if(parseO[curRow][1][curOut] == '1'):
                SOPouts[curOut].append(newProduct)
    
    andTrees = []
    dictList =[]
    for x in range(len(SOPouts)):
        notMinLayer, andMinLayer, orMinLayer, minLayer = calcMin(SOPouts,x)
        isInv, critPath, ending = calcTerminate(andMinLayer, orMinLayer)
        tempDict = {"andLayer": andMinLayer, "orLayer":orMinLayer, "minLayer":minLayer, "isInv":isInv, "critPath":critPath,"end":ending}
        dictList.append(tempDict)
# Inverse and Sort inputs by whether or not NOT'd
    # for x in range(len(SOPouts)):
    #     if(dictList[x]["isInv"] == True):
    #         for numProd in range(len(SOPouts[x])):
    #             for cnt in range(len(SOPouts[x][numProd])):
    #                 SOPouts[x][numProd][cnt] = -SOPouts[x][numProd][cnt] 
    #printSOP(SOPouts ,offInpList, outputList)
    for x in range(len(SOPouts)):
        for numProd in range(len(SOPouts[x])):
            SOPouts[x][numProd].sort(reverse=True)

    finalOut= [] 
    for x in range(len(SOPouts)):
        ANDOR = []
        temp = []
        #print(str(len(SOPouts[x]))+"This is the goal")
        for y in range(len(SOPouts[x])):
            
            temp += genAND(SOPouts[x][y], dictList, x)
            #genGLUE(temp, dictList, x)
       # print(len(temp))
        finalOut.append(genOR(temp, dictList, x))
      #  print(finalOut[0].printTreeLog(offInpList,0))
    # for x in range(len(SOPouts)):
    #     print(finalOut[x].printTreeLog(offInpList, 0))
        
        finalOut[x].reduce()
        if(finalOut[x].isOp and finalOut[x].op == '!'):
            finalOut[x] = finalOut[x].children[0]
        while(finalOut[x].n2not()):
            finalOut[x].reduce()
    # print("BREAKKKKKKKKKKKK")
    # print()
  #  for x in range(len(SOPouts)):
  #      print(finalOut[x].printTreeLog(offInpList, 0))


    if(isState):
        toStateVerilog(finOut, outputList, offInpList, finalOut)
    else:
        toVerilog(finOut, outputList, offInpList, finalOut)
    fname = finOut+'.v'
    with open(fname, 'r') as fin:
        print(fin.read())

    printSOP(SOPouts ,offInpList, outputList)
    critPathList = []
    for x in range(len(finalOut)):
        critPathList.append(finalOut[x].getCriticalPath())
    for x in range(len(finalOut)):
        print(outputList[x]+": "+ str(round(critPathList[x],3)))
        print(finalOut[x].printTreeLog(offInpList,1))
        print()

    for x in range(len(finalOut)):
        print("Critical Path of "+outputList[x]+": "+ str(round( critPathList[x],3)))
        
    
    print("File Generated: Please view "+finOut +".v\n")


if __name__ == '__main__':
    main()









