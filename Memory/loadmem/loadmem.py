#!/bin/python3

import sys;

def main():
    asmdict = parsefile()
    mem = loadmemarray(asmdict)
    printinitfile(mem)

def printinitfile(mem):
    for bank in range(0, 4):
        for chip in range(0, 16):
            for dram in range(0, 4):
                filename = "initfiles/pmem_b"+str(bank)+"c"+str(chip)+"d"+str(dram)+".init"
                f = open(filename, "w")
                addr = bank*16 + chip*2048 + dram*4
                for i in range(0, 32):
                    f.write(mem[addr+3] + mem[addr+2] + mem[addr+1] + mem[addr+0] + "\n")
                    addr += 64





def loadmemarray(asmdict):
    mem = []
    for i in range(0, 2**15):
        mem.append("00")
    for loc in asmdict.keys():
        addr = int(loc, 0)
        data = asmdict[loc].split(" ")
        for byte in data:
            mem[addr] = byte
            addr += 1
    #for i in range(0, 2**15, 16):
    #    print("@M[" + hex(i) + "]:\t", mem[i], mem[i+1], mem[i+2], mem[i+3], mem[i+4], mem[i+5], mem[i+6], mem[i+7], mem[i+8], mem[i+9], mem[i+10], mem[i+11], mem[i+12], mem[i+13], mem[i+14], mem[i+15])
    return mem



def parsefile():
    filename = sys.stdin.read().strip()
    f = open(filename, "r")
    asm = f.read().strip().split("\n")
    asmdict = {}
    appendslot = ""
    for line in asm:
        if not (len(line) == 0 or line[0] == "/" or line[0] == "\n"):
            #print(line)
            assignment = line.split("//")[0]
            if ":" in assignment:
                appendslot = assignment.split(":")[0].strip()
                asmdict[appendslot] = assignment.split(":")[1].strip()
            elif len(assignment.strip()) > 0:
                asmdict[appendslot] += " " + assignment.strip()
    f.close()
    return asmdict



if __name__ == '__main__':
    main()