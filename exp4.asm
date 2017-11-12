data_seg segment
  str1  db  128, 0, 128 dup(?)
  str2  db  16, 0, 16 dup(?)
  str3  db  16, 0, 16 dup(?)
  len1  db  ?
  len2  db  ?
  cont dw  ?
  str_debug  db 'run here!!!!', 13, 10, '$'
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

  mov  cx, 0000h
  mov  cont, 0
  lea  bx, str1 + 1

_find_:
  inc  bx
  cmp  byte ptr [bx], '$' ; 这里细节处理懒得去搞了
  jl  _out_
; 取长度len2的一段出来放入一个buffer
  lea  di, str3 + 2
  mov  si, bx
  mov  cl, len2
  cld
  rep  movsb
; 比较取出来的段和str2串
  lea  si, str2 + 2
  lea  di, str3 + 2
  mov  cl, len2
  cld
  repz  cmpsb
  jnz  _find_
  inc  cont
  jmp  _find_

_out_:
  call  print_dec
  mov  ax, 4c00h
  int  21h
main endp

print_dec proc near
;
  push  ax
  push  bx
  push  dx
;
  mov  ax, cont
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
  pop  ax
;
  ret
print_dec endp

crlf proc near
;
  push  ax
  push  dx
;
  mov  ah, 02h
  mov  dl, 13
  int  21h
  mov  ah, 02h
  mov  dl, 10
  int  21h
;
  pop  dx
  pop  ax
;
  ret
crlf endp

code_seg ends
end start
