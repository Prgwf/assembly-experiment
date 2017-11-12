data_seg segment
    mess1   db 'input two numbers!',13,10,'$'
    one     db '1$'
    crlf    db 13,10,'$'
data_seg ends

code_seg segment
  assume cs:code_seg, ds:data_seg


start:
  mov   ax, data_seg
  mov   ds, ax

  lea   dx, mess1
  mov   ah, 09
  int   21h
  mov   ah, 01
  int   21h
  lea   dx, crlf
  mov   ah, 09
  int   21h
  sub   al, 30h
  mov   bl, al
  mov   ah, 01
  int   21h
  lea   dx, crlf
  mov   ah, 09
  int   21h
  sub   al, 30h
  add   al, bl
  cmp   al, 0ah
  jns   yes
  add   al, 30h
  mov   dl, al
  mov   ah, 02
  int   21h
  lea   dx, crlf
  mov   ah, 09
  int   21h
  mov   ax, 4c00h
  int   21h
yes:
  lea   dx, one
  mov   ah, 09
  int   21h
  sub   al, 0ah
  add   al, 30h
  mov   dl, al
  mov   ah, 02
  int   21h

  lea   dx, crlf
  mov   ah, 09
  int   21h

  mov   ax, 4c00h
  int   21h
code_seg ends
end start
