; use only one loop
data_seg segment
  len  db  16
  CL_RF  db  13, 10, '$'
data_seg ends

code_seg segment
main proc far
  assume cs: code_seg, ds: data_seg
start:
  push  ds
  sub  ax, ax
  push  ax

  mov  ax, data_seg
  mov  ds, ax
  mov  bl, 10h
  mov  cx, 00f0h

loop1:
  mov  ax, cx
  div  len
  cmp  ah, 0
  jnz continue
  call crlf
continue:
  mov  ah, 02h
  mov  dl, bl
  int  21h
  mov  dl, 20h
  int  21h
  inc  bl
  loop loop1
  ret
main endp

; subproc  print '\r\n'
crlf proc near
  mov  ax, data_seg
  mov  ds, ax
  lea dx, CL_RF
  mov  ah, 09h
  int  21h
  ret
crlf endp
code_seg ends
end start
