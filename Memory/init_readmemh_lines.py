for b in range(0, 4):
    for c in range(0,16):
        for d in range(0, 4):
            print(f'$readmemh("initfiles/pmem_b{b}c{c}d{d}.init", pm.banks[{b}].bnk.bank_slices[{c}].dram.cells[{d}].sram.mem);')