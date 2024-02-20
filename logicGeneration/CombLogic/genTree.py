from node import node
from genNode import *
import math

def genAND(toAND, dictList,curOut ):
    andCnt = 0
    childList = []
    end = dictList[curOut]["end"]
    inv = dictList[curOut]["isInv"]
    finAt2 = dictList[curOut]["end"] == "AND1OR2"
    finAt4 = dictList[curOut]["end"] == "AND2OR1"
    critPath = dictList[curOut]["critPath"]
    minAND = dictList[curOut]["andLayer"]
    minOR = dictList[curOut]["orLayer"]
    localMinAND = len(toAND)
    localLayer = math.ceil(math.log(localMinAND,4))
    width = 0
    op = '.' if not inv else '@'
    #print(localLayer)
    for z in range(len(toAND)):
        
        childList.append(node( False, curOut, value = toAND[z], childCnt = 0))
        width += 1
    #print(width)
    iterations = localLayer
    notBuff = False
    if(localLayer % 2 == 1):
        notBuff = True
        iterations -= 1
    if(localLayer == 0):
        return [node(True, op, childCnt=0)]
    

    # if(minAND % 2 == 0 and localLayer % 2 == 0):
    #     iterations = localLayer 
    # elif(minAND % 2 == 0 and localLayer % 2 == 1):
    #     iterations = localLayer - 1
    #     notBuff = True
    # elif (minAND % 2 == 1 and localLayer % 2 == 1):
    #     iterations = localLayer - 1
    # elif(minAND % 2 == 1 and localLayer % 2 == 0):
    #     iterations = localLayer 
    
    # if(iterations >= 2 and finAt2):
    #     iteration - 2
    # elif(iterations >= 4 and finAt4):
    #     iteration -= 4

   # print(iterations)
    curList = childList
    newList = []
    for x in range(iterations):
        #print(op)
        newList = genLevel(len(curList),op)
        merge2_noEnd(curList, newList)
        curList = newList
        op = '.' if op != '.' else '@'
    #print("break")
    if(notBuff):
        newList = genLevel(len(curList),'.')
        merge2_noEnd(curList, newList)
        curList = newList
        newList = genLevel(len(curList),'!')
        merge2_noEnd(curList, newList)
        curList = newList
    
    return curList

def genOR(toOR, dictList, curOut):
    andCnt = 0
    childList = []
    end = dictList[curOut]["end"]
    inv = dictList[curOut]["isInv"]
    finAt2 = dictList[curOut]["end"] == "AND1OR2"
    finAt4 = dictList[curOut]["end"] == "AND2OR1"
    critPath = dictList[curOut]["critPath"]
    minAND = dictList[curOut]["andLayer"]
    minOR = dictList[curOut]["orLayer"]
    
    localMinOR = len(toOR)
    localLayer = math.ceil(math.log(localMinOR,4))
    #print(localLayer)
   # print("Len of OR")
    width = 0
    op = '@' if not inv else '.'

    
    
    iterations = localLayer
    notBuff = False
    if(localLayer % 2 == 1):
        notBuff = True
        iterations -= 1
    if(localLayer == 0):
        return toOR[0]
    
    curList = toOR
    newList = []
    for x in range(iterations):
        newList = genLevel(len(curList),op)
        merge2_noEnd(curList, newList)
        curList = newList
        op = '.' if op != '.' else '@'
        
    if(notBuff):
        newList = genLevel(len(curList),'@')
        merge2_noEnd(curList, newList)
        curList = newList
        newList = genLevel(len(curList),'!')
        merge2_noEnd(curList, newList)
        curList = newList
    return curList[0]