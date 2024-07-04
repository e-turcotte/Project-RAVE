mov ax, 0x0200  
mov cs, ax      
mov ax, 0x0000 
mov ds, ax      
mov ax, 0x0400 
mov ss, ax      
mov ax, 0x0b00 
mov es, ax      
mov ax, 0x0c00  
mov fs, ax      
mov ax, 0x0a00  
mov gs, ax      
mov eax, 0x00000000 
mov ecx, 0x76543210
mov dword ptr cs:[eax], 0x10000001 
mov dword ptr ds:[eax], 0x20000002
mov dword ptr ss:[eax], 0x30000003
mov dword ptr es:[eax], 0x40000004
mov dword ptr fs:[eax], 0x50000005
mov dword ptr gs:[eax], 0x60000006
mov ax, 0x0600  
mov cs, ax      
mov ax, 0x0300 
mov ds, ax   
mov eax, 0x00000000 
mov word ptr ds:[eax], 0x0007
mov word ptr cs:[eax], 0x0008
mov ax, 0x0200  
mov cs, ax      
mov ax, 0x0000 
mov ds, ax
mov eax, 0x00000000 
mov ebx, cs:[eax]
mov ecx, ds:[eax]
mov edx, ss:[eax]
mov ebp, es:[eax]
mov esi, fs:[eax]
mov edi, gs:[eax]
mov ax, 0x0600  
mov cs, ax      
mov ax, 0x0300 
mov ds, ax   
mov eax, 0x00000000 
mov esp, cs:[eax]
mov eax, ds:[eax]
hlt