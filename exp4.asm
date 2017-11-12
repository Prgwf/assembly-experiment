data_seg segment
  str1  db  128, 0, 128 dup(?)
  str2  db  16, 0, 16 dup(?)
  len1  db  ?
  len2  db  ?
  cont dw  ?
data_seg ends

code_seg segment
main proc far
  assume  cs: code_seg, ds: data_seg

start:
  push  ds
  sub  ax, ax
  push  ax

; 存数据段在ds中
  mov  ax, data_seg
  mov  ds, ax

  lea  dx, str1
  mov  ah, 0ah
  int  21h
  call  crlf

  lea  dx, str2
  mov  ah, 0ah
  int  21h
  call crlf

  mov  ch, 0
  mov  cl, str1 + 1
  lea  bx, str1 + 2
  add  bx, cx
  mov  byte ptr[bx], '$' ; 在字符串结束加上'$'，即把回车换成结束符
  mov  len1, cl ;保存长度

  mov  ch, 0
  mov  cl, str2 + 1
  lea  bx, str2 + 2
  add  bx, cx
  mov  byte ptr[bx], '$'
  mov  len2, cl

; for debug
  ; lea  dx, str1 + 2
  ; mov  ah, 09h
  ; int  21h
  ; call  crlf
  ; lea  dx, str2 + 2
  ; mov  ah, 09h
  ; int  21h
  ; call  crlf
  ; mov  al, len1
  ; mov  ah, 0
  ; call  print_dec
  ; mov  al, len2
  ; mov  ah, 0
  ; call  print_dec

  mov  ch, 0
  mov  cont, 0
  lea  bx, str1 + 1
  cld

_find_:
; 搞一个临时的缓存池，取len2长的一段出来，再用repz?

_up_:
  inc  cont
  jmp  _find_

_out_:
  mov  ax, cont
  call  print_dec
  mov  ax, 4c00h
  int  21h
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
  mov  ah, 02h
  mov  dl, 13
  int  21h
  mov  ah, 02h
  mov  dl, 10
  int  21h
  ret
crlf endp

code_seg ends
end start
