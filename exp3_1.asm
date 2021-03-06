data_seg segment
  str1  db  '12ABCDE#!@Y(78)=(1).','$'
  len1  equ  $-str1
  ; str1  db  '12ABCD E#! @Y(78)=(1).','$'
  ; len1  equ  $-str1
  str_letter  db  'letter=','$'
  str_digit  db  'digit=','$'
  str_other  db  'other=','$'
  str_pos  db  'pos=','$'
  str_no  db 'N', '$'
  letter  db  0
  digit  db  0
  pos  db  ?
  rhs  db  0
  false  db  1
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
  mov  bx, 0
  mov  si, 0
loop1:
  cmp  si, len1
  je  show_info
  mov  al, str1[si]
  inc  si
  cmp  al, 30h
  jb  less_0 ; < 0
  cmp  al, 39h
  ja  greater_9 ; > 9
  jmp  dig_count ; 0~9 --> digit++

; similar to loop1

less_0:
  cmp  al, 20h ;  == ' '?
  jz  pos_help
  ja  rhs_count ; other++
  loop  loop1

greater_9:
  cmp  al, 41h
  jb  rhs_count ; < A
  cmp  al, 5ah
  ja  greater_Z ; > Z
  jmp  let_count ; A~Z --> letter++

greater_Z:
  cmp  al, 61h
  jb  rhs_count ; < a
  cmp  al, 7ah
  ja  rhs_count ; > z
  jmp  let_count ; a~z --> letter++

dig_count:
  inc  digit
  loop  loop1

let_count:
  inc  letter
  loop  loop1

rhs_count:
  inc  rhs
  loop  loop1

pos_help:
  cmp  false, 0
  je  loop1
  mov  bx, si
  mov  false, 0
  push  bx
  loop  loop1

show_info:
  call crlf
; show letter number
  lea  dx, str_letter
  mov  ah, 09h
  int  21h
  mov  ax, 0
  mov  al, letter
  call  show_help
  call  crlf
; show digit number
  lea  dx, str_digit
  mov  ah, 09h
  int  21h
  mov  ax, 0
  mov  al, digit
  call  show_help
  call  crlf
; show other number
  lea  dx, str_other
  mov  ah, 09h
  int  21h
  mov  ax, 0
  mov  al, rhs
  call  show_help
  call  crlf

; check if there is a ' '
  cmp  false, 1
  je not_found
; show the pos of ' ' if exist
  pop  bx
  lea  dx, str_pos
  mov  ah, 09h
  int  21h
  mov  ax, 0
  lea  ax, [bx]
  call  show_help
  call  crlf
  ret
not_found:
  mov  ah, 02h
  mov  dl, 4eh
  int  21h
  ret
main endp

; subproc show 'N'

; subproc show help
show_help proc near
  push  bx
  mov  bl, 10
  div  bl
  push  ax
  mov  dl, al
  cmp  dl, 0
  jz  nxt
  add  dl, 30h
  mov  ah, 02h
  int  21h
nxt:
  pop  ax
  mov  dl, ah
  add  dl, 30h
  mov  ah, 02h
  int  21h
  pop  bx
  ret
show_help endp

; subproc  print '\r\n'
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
