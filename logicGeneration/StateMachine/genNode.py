from node import node
import math

def getOptSize(product):
    
    
    if(math.ceil(math.log(product,2)) <= math.ceil(math.log((product),3)) and math.ceil(math.log(product,2)) <= math.ceil(math.log((product),4)) ):
        return 2
    elif(math.ceil(math.log((product),3)) <= math.ceil(math.log((product),4))):
        return 3
    else:
        return 4

def gen1Level(bool, syb, cnt,size):
    nodes = []
    for x in range(cnt):
        nodeTemp = node(bool, syb,childCnt = size)
        nodes.append(nodeTemp)
    return nodes
    
def genLevel (inputs, l1):
    optSize = getOptSize(inputs)
    tempInp = inputs
    optGateCnt = 0
    totGat = 0
    if(inputs == 1):
        return [node(True,'!',childCnt = 1)]
    while(tempInp - optSize >= 2 or tempInp - optSize == 0 ):
        optGateCnt += 1
        tempInp -= optSize
    firstLayer = gen1Level(True, l1, optGateCnt, optSize)
    totGat += optGateCnt
    if(tempInp == 5):
        firstLayer.append(node(True, l1, childCnt = 3))
        firstLayer.append(node(True, l1, childCnt = 2))
        totGat += 2
    elif(tempInp == 4):
        firstLayer.append(node(True, l1, childCnt = 2))
        firstLayer.append(node(True, l1, childCnt = 2))
        totGat += 2
    elif(tempInp == 3):
        firstLayer.append(node(True, l1, childCnt = 3))
        totGat +=1
    elif(tempInp == 2):
        firstLayer.append(node(True, l1, childCnt = 2))
        totGat += 1
    return firstLayer

def gen2Level(inputs, l1, l2):
    firstLayer = genLevel(inputs,l1)
    
    out = node(True, l2, childCnt = len(firstLayer))
    out.addChildList(firstLayer)
    return out

def gen3Level(inputs, l1, l2, l3):
    firstLayer = genLevel(inputs,l1)
    finalLayers = gen2Level(len(firstLayer), l2, l3)
    totChild = 0
    for x in range(finalLayers.childCnt):
        for y in range(finalLayers.children[x].childCnt):
            finalLayers.children[x].addChild(firstLayer[totChild])
            firstLayer[totChild].parent = finalLayers.children[x]
            totChild +=1
    return finalLayers
   
def gen4Level(inputs, l1, l2, l3, l4):
    
    firstLayer = genLevel(inputs, l1)
    finalLayers = gen3Level(len(firstLayer),l2,l3,l4)
    totChild = 0
    for x in range(finalLayers.childCnt):
        for y in range(finalLayers.children[x].childCnt):
            for z in range(finalLayers.children[x].children[y].childCnt):
                finalLayers.children[x].children[y].addChild(firstLayer[totChild])
                firstLayer[totChild].parent = finalLayers.children[x].children[y]
                totChild += 1
    return finalLayers

def genNodeList(bool, syb, cnt):
    nodes = []
    for x in range(cnt):
        nodeTemp = node(bool, syb)
        nodes.append(nodeTemp)
    return nodes

def merge2_noEnd(bottom, top, cnt = 0):
    num = 0
    for x in range (len(top)):
        for y in range((top[x].childCnt)):
            top[x].addChild(bottom[num])
            bottom[num].parent = top[x]
            num += 1

def genAND1OR3(inputs):
    return gen4Level(inputs,'.','.','@', '.')

def genAND1OR1(inputs):
    return gen2Level(inputs, '.', '.')

def genAND1OR2(inputs):
    return gen3Level(inputs, '@','@','.')

def genAND2OR1(inputs):
    return gen3Level(inputs, '@','.','.')

def genAND3(inputs):
    return gen3Level(inputs, '@','.','.')
    
def genOR3(inputs):
    return gen3Level(inputs, '.','@','.')