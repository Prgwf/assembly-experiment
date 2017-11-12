; use loop in loop
data_seg segment
  _crlf db 13,10,'$'
data_seg ends

code_seg segment
main proc far
  assume cs: code_seg, ds: data_seg

start:
  push  ds
  sub  ax, ax
  push  ax

  mov  bl, 0010h
  mov  cx, 000fh
loop1:
  push  cx
  mov  cx, 0010h
loop2:
  mov  ah, 02h
  mov  dl, bl
  int  21h
  mov  dl, 20h
  int  21h
  inc  bl
  loop  loop2
; print space
  mov  ax, data_seg
  mov  ds, ax
  lea  dx, _crlf
  mov  ah, 09h
  int  21h

  pop  cx
  loop loop1
  ret
main endp
code_seg ends
end start
