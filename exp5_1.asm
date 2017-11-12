data_seg segment
  freq   dw 262,294,330,262,262,294,330,262;
         dw 330,349,392,330,349,392,392,440
         dw 392,349,330,262,392,440,392,349
         dw 330,262,294,196,262,294,196,262

  beat   dw 2500,2500,2500,2500,2500,2500,2500,2500,2500,2500;
         dw 5000,2500,2500,5000,1200,1200,1200,1200,2500,2500
         dw 1200,1200,1200,1200,2500,2500,2500,2500,5000,2500,2500,5000

  note   db 31h,32h,33h,31h,31h,32h,33h,31h,33h,34h,35h,33h,34h,35h,35h,36h;
         db 35h,34h,33h,31h,35h,36h,35h,34h,33h,31h,32h,35h,31h,32h,35h,31h,'$'
data_seg ends

code_seg segment
main proc far
  assume  cs: code_seg, ds:data_seg
start:
  push  ds
  xor  ax, ax
  push  ax
  mov  ax, data_seg
  mov  ds, ax
  lea  di, freq
  lea  bx, beat
  lea  si, note
  mov  cx, 32d
next:
  push  cx
  call  sound
  add  di, 2
  add  bx, 2
  add  si, 1
  mov  cx, 0ffffh
silence:
  loop  silence
  pop  cx
  loop  next
  ret
main endp
sound proc near
  mov  ah, 02h
  and  si, 00ffh
  mov  dx, si
  int  21h
  in  al, 61h
  and  al, 11111100b
sing:
  xor  al, 2
  out  61h, al
  push  ax
  call interval
  pop  ax
  mov  cx, dx
weight:
  loop  weight
  dec  word ptr [bx]
  jnz  sing
  and  al, 11111100b
  out  61h, al
  ret
sound endp

interval proc near
  mov  ax, 2801
  push  bx
  mov  bx, 50
  mul  bx
  div  word ptr [di]
  mov  dx, ax
  pop  bx
  ret
interval endp
code_seg ends
end start
