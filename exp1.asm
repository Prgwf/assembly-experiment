data_seg segment
  str1  db 'input a number: ', '$'
data_seg ends

code_seg segment
main proc far
  assume  cs: code_seg, ds:data_seg
start:
  push  ds
  sub  ax, ax
  push  ax

  mov  ax,  data_seg
  mov ds, ax

  lea  dx, str1
  mov  ah, 09h
  int  21h
  mov  ah, 01h
  int  21h
  call  crlf
  sub  al, 30h
  mov  bl, al

  lea  dx, str1
  mov  ah, 09h
  int  21h
  mov  ah, 01h
  int  21h
  call  crlf
  sub  al, 30h
  mov  ah, 00h
  add  al, bl

  call  print_dec
  ret
main endp

print_dec proc near
;
  push  bx
  push  dx
;
  mov  bl, 10
  mov  bh, 0
  div  bl
  push  ax
  mov  dl, al
  cmp  dl, 0
  jz  lt_10
  add  dl, 30h
  mov  ah, 02h
  int  21h
lt_10:
  pop  ax
  mov  dl, ah
  add  dl, 30h
  mov  ah, 02h
  int  21h

  call  crlf
;
  pop  dx
  pop  bx
;
  ret
print_dec endp

crlf proc near
  push  ax
  push  dx
  mov  ah, 02h
  mov  dl, 13
  int  21h
  mov  ah, 02h
  mov  dl, 10
  int  21h
  pop  dx
  pop  ax
  ret
crlf endp
code_seg ends
end start
