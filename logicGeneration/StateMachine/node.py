class node:



    # def __init__(self, child, logOp):
    #     self.children = child
    #     self.isOp = logOp
    #     self.op = '||'
    #     self.parent = None

    def __init__(self, logOp, ops, childCnt = 0, value = 0):
        if(childCnt!=0):
            self.childCnt = childCnt
        else:
            self.childCnt = -1
        if(value == 0):
            self.children = []
            self.isOp = logOp
            self.op = ops
            self.value = 0
            self.parent = None
            
        else:
            self.children = []
            self.isOp = logOp
            self.op = 'x'
            self.value = value
            self.parent = None 
            

    def addChild(self, child):
        self.children.append(child)

    def updCurPar(self, toSwap):
         for curChild in range(len(self.parent.children)):
                if(self.parent.children[curChild] == self):
                    self.parent.children[curChild] = toSwap
    def updCurChild(self,toSwap):
         for numChild in range(len(self.children)):
              self.children[numChild].parent = toSwap      

    def and2nand(self):
        if(self.isOp and self.op == '&'):
            notA = node(True, '!')
            nandA = node(True, '.')
            
            self.updCurPar(notA)
            notA.children.append(nandA)
            
            nandA.parent = notA
            nandA.children = self.children
            self.updCurChild(nandA)
    def or2nor(self):
        if(self.isOp and self.op == '@'):
            notA = node(True, '!')
            norA = node(True, '@')
            
            self.updCurPar(notA)
            notA.children.append(norA)
            
            norA.parent = notA
            norA.children = self.children
    def __str__(self, level = 0):
        if(self.isOp == False):
            return f"Value={self.value}"     
        if(len(self.children) != 0):
            children = ''
            for x in range(len(self.children)):
                children = (children) + ' ' + str(id(self.children[x]))
            return f"Node(isOp={self.isOp}, op='{self.op}', children={children}', parent='{id(self.parent)}', self={id(self)})"      
        if(len(self.children) == 0):
            return f"Node(isOp={self.isOp}, op='{self.op}', children= NONE', parent='{id(self.parent)}', self={id(self)})"      

    def addChildList(self, children):
        for child in children:
            self.children.append(child)
            child.parent = self

    def notReduction(self):
        for child in self.children:
            if(self.childCnt == 1):
                self.op = '!'
            child.notReduction()

    def printTree(self, offInpList, level  ): 
        indentation = "    " * level
        result = f"{indentation}Node(isOp={self.isOp}, op='{self.op}', value="
        if(self.value < 0):
            result += f"!"
        result+= f"{offInpList[abs(self.value)]}, children=["
        for child in self.children:
            result += f"\n{child.printTree(offInpList, level + 1)},"

        result += f"\n{indentation}]"
        result += f", parent='{id(self.parent)}', self={id(self)})"
        return result
    
    def printTreeLog(self, offInpList, level):
        indentation = "    " * level
        printOp = ""
        val = 0.0
        if(self.isOp == True):    
            if(self.op == '!'):
                printOp = "NOT"
            elif(self.op == '.'):
                printOp = "NAND"
                if(len(self.children) == 4):
                    val = 0.25
                else:
                    val = 0.2
            elif(self.op == '&'):
                printOp = "AND"
            elif(self.op == '@'):
                printOp = "NOR"
                if(len(self.children) == 4):
                    val = 0.35
                elif(len(self.children)==3):
                    val = .25
                else:
                    val = 0.2
            elif(self.op == '|'):
                printOp = "OR"
            else:
                printOp = "Invalid OP"
        else:
            if(self.value < 0):
                printOp += "!"
                val = 0.15
            printOp += f"{offInpList[abs(self.value)]}"
            
        result = f"{indentation}{printOp}"
        result  += f"  ({round(val,3)})" #{self.childCnt},
        for child in self.children:
            result += f"\n{child.printTreeLog(offInpList, level + 1)}"

        result += f"{indentation}"
       
        return result

    def finds(self, value):
        found = False
        if(self.value == value):
            found = True
            return True
        for x in range(len(self.children)):
            found = found or self.children[x].finds(value)
        return found
    
    def reduce(self):
        if(self.isOp == False):
            return
        for x in range(len(self.children)):
            self.children[x].reduce()
        if(self.isOp == True and self.op == '!'):
            if self.parent != None:
                self.parent.children.remove(self)
                self.parent.children.append(self.children[0])
            else:
                self.parent = self
            self.children[0].parent = self.parent
            self.children[0].inverse()
    
    def inverse(self):
        #print("triggered")
        if(self.isOp == True):
            if(self.op == '.'):
                #print("swap")
                self.op = '@'
            else:
                #print("hmmm")
                self.op = '.'
            for x in range(len(self.children)):
                self.children[x].inverse()
        else:
            self.value *= -1
            return

    def n2not(self):
        again = False
        if(len(self.children) == 1 and self.isOp ):
                self.op = '!'
                again = True
        if(self.isOp):
            for x in range(len(self.children)):
                again = again or self.children[x].n2not()       
        return again
    
    def getCriticalPath(self):
        max = 0.0
        if(self.isOp == False):
            if(self.value < 0):
                return 0.15
            return 0
    
        for x in range(len(self.children)):
            path = self.children[x].getCriticalPath()
            if(path > max):
                max = path
        perDel = 0
        if(self.op == '.'):
            if(len(self.children) == 4):
                perDel = 0.25
            else:
                perDel = 0.2
        else:
            if(len(self.children) == 4):
                perDel = 0.35
            elif(len(self.children)==3):
                 perDel = .25
            else:
                perDel = 0.2
        return max + perDel
