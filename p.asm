[org 0x0100]

jmp start

arr: dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
sco:dw 0
oldisr: dd 0
message1:db'TIME'
time:db'00 0'
score:db'0'
message2:db'SCORE'
message3:db'UPCOMING BRICK'  
; row0: db '-------------------------------------',0
; row1: db '| ******  ******  *      *  ******  |',0
; row2: db '| *       *    *  * *  * *  *       |',0
; row3: db '| *  ***  ******  *  **  *  ******  |',0
; row4: db '| *    *  *    *  *      *  *       |',0
; row5: db '| ******  *    *  *      *  ******  |',0

; rowc: db '|                                   |',0

; row6: db '| ******  *     * ******  *****  ** |',0
; row7: db '| *    *  *     * *       *   *  ** |',0
; row8: db '| *    *   *   *  ******  *****  ** |',0
; row9: db '| *    *    * *   *       *  *      |',0
; row10: db '| ******     *    ******  *   *  ** |',0

; row11: db '-------------------------------------',0


row0: db '   _____          __  __ ______   ', 0
row1: db '  / ____|   /\   |  \/  |  ____|  ', 0
row2: db ' | |  __   /  \  | \  / | |__     ', 0
row3: db ' | | |_ | / /\ \ | |\/| |  __|    ', 0
row4: db ' | |__| |/ ____ \| |  | | |____   ', 0
row5: db '  \_____/_/    \_\_|  |_|______|  ', 0
rowc: db '   ______      ________ _____  _  ', 0
row6: db '  / __ \ \    / /  ____|  __ \| | ', 0
row7: db ' | |  | \ \  / /| |__  | |__) | | ', 0
row8: db ' | |  | |\ \/ / |  __| |  _  /| | ', 0
row9: db ' | |__| | \  /  | |____| | \ \|_| ', 0
row10:db '  \____/   \/   |______|_|  \_(_) ', 0
row11:db '                                  ', 0



r0: db ' /######## /######## /######## /######## /######  /####### ', 0
r1: db '|__  ##__/| ##_____/|__  ##__/| ##__  ##|_  ##_/ /##__   ##', 0
r2: db '   | ##   | ##         | ##   | ##  \ ##  | ##  | ##  \__/ ', 0
r3: db '   | ##   | ########   | ##   | #######/  | ##  |  ####### ', 0
r4: db '   | ##   | ##__/      | ##   | ##__  ##  | ##   \____  ## ', 0
r5: db '   | ##   | ##         | ##   | ##  \ ##  | ##   /##  \ ## ', 0
r6: db '   | ##   | ########   | ##   | ##  | ## /######|  ######/ ', 0
r7: db '   |__/   |________/   |__/   |__/  |__/|______/ \______/  ', 0








; r0: db ' ####### ####### #######  #######   #####  ###### ', 0
; r1: db '    #    #          #     #     #     #    #      ', 0
; r2: db '    #    #          #     #     #     #    #      ', 0
; r3: db '    #    ######     #     ######      #    ###### ', 0
; r4: db '    #    #          #     #   #       #         # ', 0
; r5: db '    #    #          #     #    #      #         # ', 0
; r6: db '    #    #######    #     #     #   #####  ###### ', 0



r8: db 'INSERT TOKEN TO PLAY O', 0
tickcount: dw 0
ticksec: dw 0
tickmin:dw 0

RANDGEN:         ; generate a rand no using the system time
    push ax
	push cx
	   MOV AH, 00h  ; interrupts to get system time        
	   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
	   mov  ax, dx
	   xor  dx, dx
	   mov  cx, 6    
	   div  cx       ; here dx contains the remainder of the division - from 0 to 5
	 
	   
	   
	 
     pop cx
     pop ax	 
	RET
	
clrscr1: 
 push es
 push ax
 push di 
 mov ax, 0xb800
 mov es, ax                        
 mov di, 294                       
 
 mov word [es:di], 0x0720         
                       
 pop di
 pop ax
 pop es
 ret
timer:
push di 
push ax 

inc word [cs:tickcount]; increment tick count
;push word [cs:tickcount]

cmp word[cs:tickcount],18
jb normal
inc word [cs:ticksec]
mov word [cs:tickcount],0
cmp word [cs:ticksec],60
jb normal
mov word [cs:ticksec],0
inc word[cs:tickmin]


call clrscr1
normal:
mov di,286
push di
push word[cs:tickmin]
push word[cs:ticksec]
call printnum2
 mov al, 0x20
 out 0x20, al ; end of interrupt
 pop ax
 pop di

 jmp far [cs:oldisr] ; return from interrupt




printnum2:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax,[bp+4]
mov bx,10
mov cx,0
nextdigit68:
mov dx,0
div bx
add dl,0x30
push dx
inc cx
cmp ax,0
jnz nextdigit68

push ax
push bx
push dx
mov ax,[bp+6]
mov bx,10
mov dx,0
div bx
add dl,0x30
mov dh,0x07
mov di,[bp+8]
mov [es:di],dx
mov dl,0x3A
add di,2
mov [es:di],dx
pop dx
pop bx
pop ax

add di,4

nextpos68:
pop dx
mov dh,0x07
mov [es:di],dx
add di,2
loop nextpos68
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6



 
endscreen2:
push bp
mov bp,sp
sub sp,4
push ds
push es
push dx
push cx
push di
push si
push ax
push bx

mov ax,0xb800
mov es,ax
mov ds,ax
mov cx,80
mov di,0
mov si,3840
mov bx,8
mov dx,1
mov [bp-2],bx
mov [bp-4],dx
upverical:

push di

line1:
mov word[es:di],0x81DB
add di,160
dec bx
jnz line1
pop di
push si
line2:
mov word[ds:si],0x8cDB
sub si,160
dec dx
jnz line2
pop si

mov bx,[bp-2]
dec bx
cmp bx,0
jnz donotsetlimit1
mov bx,8
donotsetlimit1:
mov [bp-2],bx

mov dx,[bp-4]
inc dx
cmp dx,9
jne donotsetlimit2
mov dx,1
donotsetlimit2:
mov [bp-4],dx

add di,2
add si,2

loop upverical

pop bx
pop ax
pop si
pop di
pop cx
pop dx
pop es
pop ds
pop bp
pop bp
pop bp
ret

printstart:
	push bp
	mov bp,sp
	push ax
	call pausetime
	
	mov ax, 14
	push ax ; col
	mov ax, 8
	push ax ; row
	mov ax, 9; blue on black attribute
	push ax ; push attribute
	mov ax, r0
	push ax
	call printstr
    call pausetime
	mov ax, 14
	push ax ; col
	mov ax, 9
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r1
	push ax
	call printstr
    call pausetime
	mov ax, 14
	push ax ; col
	mov ax, 10
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r2
	push ax
	call printstr
    call pausetime
	mov ax, 14
	push ax ; col
	mov ax, 11
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r3
	push ax
	call printstr
    call pausetime
	mov ax, 14
	push ax ; col
	mov ax, 12
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r4
	push ax
	call printstr
    call pausetime
	mov ax,14
	push ax ; col
	mov ax, 13
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r5
	push ax
	call printstr
    call pausetime
	
	mov ax, 14
	push ax ; col
	mov ax, 14
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r6
	push ax
	call printstr
    call pausetime
	
	mov ax, 14
	push ax ; col
	mov ax, 15
	push ax ; row
	mov ax, 9 ; blue on black attribute
	push ax ; push attribute
	mov ax, r7
	push ax
	call printstr
    call pausetime
	
	mov ax, 31
	push ax ; col
	mov ax, 17
	push ax ; row
	mov ax, 0x89 ; blue on black attribute
	push ax ; push attribute
	mov ax, r8
	push ax
	call printstr
    call pausetime
	
	pop ax
    pop bp
    ret		
	
	
	colourscr:
	push ax
	push es
	push di
	push si
	push ds
	mov ax,0xb800
	mov es,ax
	mov ds,ax
	mov di,0
	mov si,3998
	
	ul:
	    call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x0FDB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x01DB
		sub si,2
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x04DB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x08DB
		sub si,2
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x02DB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x03DB
		sub si,2
		cmp di,1994
		jne ul
		
	pop ds
	pop si
	pop di
	pop es
	pop ax
	ret
	
	colourscr1:
	push ax
	push es
	push di
	push si
	push ds
	mov ax,0xb800
	mov es,ax
	mov ds,ax
	mov di,0
	mov si,3998
	
	ul1:
	    call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x02DB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x05DB
		sub si,2
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x04DB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x09DB
		sub si,2
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[es:di],0x07DB
		add di,2
		
		call pausetime2
		call pausetime2
		call pausetime2
		
		mov word[ds:si],0x03DB
		sub si,2
		cmp di,1994
		jne ul1
		
	pop ds
	pop si
	pop di
	pop es
	pop ax
	ret
	
	pausetime2:
push ax
push cx
mov ax,0x1
mov cx,ax
lllll:
llllll:
loop llllll
dec ax
jnz lllll
pop cx
pop ax
ret 


; music_length: dw 10000
; music_data: incbin "getthem.imf"

; music:
		; push si
		; push dx
		; push ax
		; push bx
		; push cx
		; mov si, 678
	; .next_note:
		; mov dx, 388h
		; mov al, [si + music_data + 0]
		; out dx, al
		; mov dx, 389h
		; mov al, [si + music_data + 1]
		; out dx, al
		; mov bx, [si + music_data + 2]
		; add si, 4
	; .repeat_delay:
		; mov cx, 610
	; .delay:
		; mov ah, 1
		; int 16h
		; jnz st
		; loop .delay
		; dec bx
		; jg .repeat_delay
		; cmp si, [music_length]
		; jb .next_note
	; st:
		; mov dx, 388h
		; mov al, 0
		; out dx, al
		; mov dx, 389h
		; mov al, 0
		; out dx, al
		; mov bx, 0
		; pop cx
		; pop bx
		; pop ax
		; pop dx
		; pop si
; ret












clearscreen:
	push ax
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,0
	l1:
		mov word[es:di],0x0720
		add di,2
		cmp di,4000
		jne l1
	pop di
	pop es
	pop ax
	ret
printstr: 
	    push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di
		push ds
		pop es ; load ds in es
		mov di, [bp+4] ; point di to string
		mov cx, 0xffff ; load maximum number in cx
		xor al, al ; load a zero in al
		repne scasb ; find zero in the string
		mov ax, 0xffff ; load maximum number in ax
		sub ax, cx ; find change in cx
		dec ax ; exclude null from length
		jz exit ; no printing if string is empty
		mov cx, ax ; load string length in cx
		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov al, 80 ; load al with columns per row
		mul byte [bp+8] ; multiply with y position
		add ax, [bp+10] ; add x position
		shl ax, 1 ; turn into byte offset
		mov di,ax ; point di to required location
		mov si, [bp+4] ; point si to string
		mov ah, [bp+6] ; load attribute in ah
		cld ; auto increment mode
		nextchar: lodsb ; load next char in al
		stosw ; print char/attribute pair
		loop nextchar ; repeat for the whole string
		exit: pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 8
printend:
	push bp
	mov bp,sp
	push ax
	call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 4
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row0
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 5
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row1
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 6
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row2
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 7
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row3
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 8
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row4
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 9
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row5
	push ax
	call printstr
	call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 10
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, rowc
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 11
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row6
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 12
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row7
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 13
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row8
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 14
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row9
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 15
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row10
	push ax
	call printstr
    call pausetime
	mov ax, 23
	push ax ; col
	mov ax, 16
	push ax ; row
	mov ax, 1 ; blue on black attribute
	push ax ; push attribute
	mov ax, row11
	push ax
	call printstr
   
	pop ax
    pop bp
    ret
	
drawborder:
	push bp
	mov bp,sp
	push ax
	push cx
	push di
	push es
	push si
	mov ax,0xb800
	mov es,ax
	mov di,0
	mov ax,0x0FDB
	mov cx,60
	l2:
	mov word[es:di],ax
	add di,2;
	sub cx,1;
	cmp cx,0
	jne l2
	mov ax,0xb800
	mov es,ax
	mov di,3840
	mov ax,0x0FDB
	mov cx,61
	l3:
	mov word[es:di],ax
	add di,2;
	sub cx,1;
	cmp cx,0
	jne l3
	mov ax,0xb800
	mov es,ax
	mov di,0
	mov ax,0x0FDB
	mov cx,24
	l4:
	mov word[es:di],ax
	add di,160
	sub cx,1;
	cmp cx,0
	jne l4
	mov ax,0xb800
	mov es,ax
	mov di,120
	mov ax,0x0FDB
	mov cx,24
	l5:
	mov word[es:di],ax
	add di,160
	sub cx,1
	cmp cx,0
	jne l5
	mov ax,0xb800
	mov es,ax
	mov di,126                                             
	mov ah,0x01
	mov cx,4
	mov si,message1
	l6:                          ; printing ""time" at top row and di 140
	mov al,[si]
	mov word[es:di],ax
	add di,2
	add si,1
	sub cx,1
	cmp cx,0
	jne l6

	mov ax,0xb800
	mov es,ax
	mov di,126 
	add di,480                                             
	mov ah,0x01
	mov cx,5
	mov si,message2
	l7:                          
	mov al,[si]
	mov word[es:di],ax
	add di,2
	add si,1
	sub cx,1
	cmp cx,0
	jne l7
    mov ax,0xb800
	mov es,ax
	mov di,126 
	add di,960                                              
	mov ah,0x01
	mov cx,14
	mov si,message3
	l8:                          
	mov al,[si]
	mov word[es:di],ax
	add di,2
	add si,1
	sub cx,1
	cmp cx,0
	jne l8

    mov ax,0xb800
	mov es,ax
	mov di,126 
    add di,640	
	mov ah,0x07
	mov cx,1
	mov si,score
	l10:                          
	mov al,[si]
	mov word[es:di],ax
	add di,2
	add si,1
	sub cx,1
	cmp cx,0
	jne l10
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x0fDB
	mov di,922
    mov cx,20
    l20:
	mov word[es:di],ax
	add di,2
    loop l20
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x0fDB
	mov di,440
    mov cx,20
    l21:
	mov word[es:di],ax
	add di,2
    loop l21
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x0fDB
	mov di,3960
    mov cx,20
    l22:
	mov word[es:di],ax
	add di,2
    loop l22
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x0fDB
	mov di,158
    mov cx,24
    l23:
	mov word[es:di],ax
	add di,160
    loop l23
	
		mov ax,0xb800
	mov es,ax
	mov ax,0x0fDB
	mov di,156
    mov cx,24
    l24:
	mov word[es:di],ax
	add di,160
    loop l24

    mov ax,0xb800
	mov es,ax
	mov ax,0x0FDB
	mov di,160
    mov cx,23
	l15:
    push di
	mov bx,7
	l15inner:
	mov word[es:di],ax
	add di,2
	sub bx,1
	cmp bx,0
	jne l15inner
    pop di
    add di,160	
	loop l15
	
	
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x09DB
	mov di,172
    mov cx,23
	l16:
    push di
	mov bx,8
	l16inner:
	mov word[es:di],ax
	add di,2
	sub bx,1
	cmp bx,0
	jne l16inner
    pop di
    add di,160	
	loop l16
	
	
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x0FDB
	mov di,278
    mov cx,23
	l17:
    push di
	mov bx,7
	l17inner:
	mov word[es:di],ax
	sub di,2
	sub bx,1
	cmp bx,0
	jne l17inner
    pop di
    add di,160	
	loop l17
	
	mov ax,0xb800
	mov es,ax
	mov ax,0x09DB
	mov di,266
    mov cx,23
	l18:
    push di
	mov bx,8
	l18inner:
	mov word[es:di],ax
	sub di,2
	sub bx,1
	cmp bx,0
	jne l18inner
    pop di
    add di,160	
	loop l18
    




	
	pop si
	pop es
	pop di
	pop cx
	pop ax
	pop bp
	ret





	

	
	
printshape0:            ;square
	push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ah,64
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+4],ax
	mov word[es:di+6],ax                           ;a square is 4 blocks horizontaly and 1 vertically
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
    mov word[es:di+166],ax
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printshape1:
    push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800                               ; the l goes 2 blocks right on the top and 4 blocks right on the bottom and 1 block vertically
	mov es,ax
	mov ah,01110000b
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+2],ax

	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
	mov word[es:di+166],ax
	mov word[es:di+168],ax
	mov word[es:di+170],ax
    
	
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printshape2:
    push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ah,00100000b
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+2],ax
    
	mov word[es:di+160],ax
	mov word[es:di+320],ax
	

	
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printshape3:
    push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ah,01010000b
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+322],ax

	

	
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printshape4:
    push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ah,11100000b
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+160],ax
    mov word[es:di+320],ax

	

	
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printshape5:
    push bp
	mov bp,sp
	push ax
	push es
	push di

	mov ax,0xb800
	mov es,ax
	mov ah,00110000b
	mov al,0
	mov di,[bp+4]
	mov word[es:di],ax
	mov word[es:di+2],ax
    mov word[es:di+4],ax
	mov word[es:di+6],ax
	mov word[es:di+8],ax

	

	
	pop di
	pop es
	pop ax
	pop bp
	ret 2
printupcomingshape:
	push bp
	mov bp,sp
	push ax 
	push word 1410
	mov al,[bp+4]
    cmp al,0
	je p0
	cmp al,1
	je p1
	cmp al,2
	je p2
	cmp al,3
	je p3
	cmp al,4
	je  p4
	cmp al,5
	je p5
	
    p0:
	call printshape0
	jmp skip
	p1:
	call printshape1
	jmp skip
	p2:
	call printshape2
	jmp skip
	p3:
	call printshape3
	jmp skip
    p4:
	call printshape4
	jmp skip
    p5:
	call printshape5
	jmp skip
	
	skip:
	pop ax
	pop bp 
	ret 
	
	
printshapeontop:
	push bp
	mov bp,sp
	push ax 
	push word 214
	mov al,[bp+4]
    cmp al,0
	je p00
	cmp al,1
	je p11
	cmp al,2
	je p22
	cmp al,3
	je p33
	cmp al,4
	je  p44
	cmp al,5
	je p55
	
    p00:
	call printshape0
	jmp skip1
	p11:
	call printshape1
	jmp skip1
	p22:
	call printshape2
	jmp skip1
	p33:
	call printshape3
	jmp skip1
    p44:
	call printshape4
	jmp skip1
    p55:
	call printshape5
	jmp skip1
	
	skip1:
	pop ax
	pop bp 
	ret 
delay:
	push bp
	mov bp,sp
	push ax
	push cx
	mov ax,200
	mov cx,0xfff
	jmp outerloop
	innerloop:
	  loop innerloop
	  jmp outerloop

	 outerloop:
	   mov cx,0xfff
	   sub ax,1
	   jnz innerloop
	pop cx
	pop ax
	pop bp
	ret


shapedelay:
	push bp
	mov bp,sp
	push ax
	push cx
	mov ax,30
	mov cx,0xfff
	jmp oloop
	iloop:
	  loop iloop
	  jmp oloop

	 oloop:
	   mov cx,0xfff
	   sub ax,1
	   jnz iloop
	pop cx
	pop ax
	pop bp
	ret
pausetime:
push ax
push cx
mov ax,0xa
mov cx,ax
lll:
llll:
loop llll
dec ax
jnz lll
pop cx
pop ax
ret 
clearupcomingshape:
	push ax
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,1410
	l11:
		mov word[es:di],0x0720
		add di,2
		cmp di,1430
		jne l11
	mov di,1570
		l12:
		mov word[es:di],0x0720
		add di,2
		cmp di,1590
		jne l12
	mov di,1730
		l13:
		mov word[es:di],0x0720
		add di,2
		cmp di,1750
		jne l13
	mov di,1890
		l14:
		mov word[es:di],0x0720
		add di,2
		cmp di,1910
		jne l14
	
	pop di
	pop es
	pop ax
	ret
	
	
enterkey:
	push bx
	push cx
	Mov ah,0x0c
    Int 0x21
	mov bx,0x5
	mov cx,bx
	llll1:
	lllll1:
	Mov ah,0x01
    Int 0x16
	loop lllll1
	dec bx
	jnz llll1
	pop cx
	pop bx
	ret
shapescrolldown:
	push bp
	mov bp,sp
	push ax
    push bx
    push es
    push di
    push si	
	push ds
	push dx
	
	
	mov ax,0xb800
	mov es,ax
	mov ds,ax
	mov ax,[bp+4]
	
	cmp ax,0
	je p000
	jmp skiptocheck1
	
	p000:
	mov dx,374
	mov si,534
	cld
	scrollloop1:	
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagain0
	jmp skip2
	checkagain0:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagain00
	jmp skip2
	checkagain00:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagain000
	jmp skip2
	checkagain000:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je p0000
	jmp skip2
	
	
	p0000:
	call enterkey
	cmp ah,0x4b   ;left key
	je l0c1
	jmp next
	l0c1:
	
	mov di,dx
	sub di,162
    mov word ax,[es:di]
	cmp ax,0x0720
	je l0c2
	jmp next
	l0c2:
	add di,160
	
	mov word ax,[es:di]
	cmp ax,0x0720
	je l0c3
	jmp next
	l0c3:
	
	
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+4],ax
	mov word[es:di+6],ax 
 
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
    mov word[es:di+166],ax
    sub dx,2
	sub si,2
	mov di,dx
	sub di,160
	push di
	call printshape0
	jmp p0000
	
	next:
	cmp ah,0x4d ;right key
	jne next1
	mov di,dx
	sub di,160
	mov word ax,[es:di+8]
	cmp ax,0x0720
    je l0r1
	jmp next1
	l0r1:
	mov word ax,[es:di+168]
	
	cmp ax,0x0720
	je l0r2
	jmp next1
	l0r2:
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+4],ax
	mov word[es:di+6],ax 
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
    mov word[es:di+166],ax
	add dx,2
	add si,2
	mov di,dx
	sub di,160
	push di
	call printshape0
	jmp p0000
	next1:
	
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagainf0
	jmp skip2
	checkagainf0:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagainf00
	jmp skip2
	checkagainf00:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagainf000
	jmp skip2
	checkagainf000:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je fprint0
	jmp skip2
	fprint0:
	
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+4],ax
	mov word[es:di+6],ax 

	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
    mov word[es:di+166],ax

	push dx 
	call printshape0
    mov dx,si
	add si,160
    jmp scrollloop1	
	
	              
	
	skiptocheck1:
	cmp ax,1
	je p111
	jmp skiptocheck2
	p111:
	mov dx,374
	mov si,534
	
	scrollloop2:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagain1
	jmp skip2
	checkagain1:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagain2
	jmp skip2
	checkagain2:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagain3
	jmp skip2
	checkagain3:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je checkagain4
	jmp skip2
	checkagain4:
	mov ax,word[ds:si+8]
	cmp ax,0x0720
	je checkagain5
	jmp skip2
	checkagain5:
	mov ax,word[ds:si+10]
	cmp ax,0x0720
	je p1111
	jmp skip2
	p1111:
	
	call enterkey
	
	cmp ah,0x4b   ;left key
	je l1l1
	jmp nexts1
	l1l1:
	mov di,dx
	sub di,162
    mov word ax,[es:di]
	cmp ax,0x0720
	je l1l2
	jmp nexts1
	l1l2:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je l1l3
	jmp nexts1
	l1l3:
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
	mov word[es:di+166],ax
	mov word[es:di+168],ax
	mov word[es:di+170],ax
	sub dx,2
	sub si,2
	mov di,dx
	sub di,160
	push di
	call printshape1
	jmp p1111

	nexts1:
	cmp ah,0x4d ;right key
	jne nexts11
	mov word ax,[es:di+4]
	cmp ax,0x0720
	je l1r1
	jmp nexts11
	l1r1:
	mov word ax,[es:di+172]
	cmp ax,0x0720
	je l1r2
	jmp nexts11
	l1r2:
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
	mov word[es:di+166],ax
	mov word[es:di+168],ax
	mov word[es:di+170],ax
	add dx,2
	add si,2
	mov di,dx
	sub di,160
	push di
	call printshape1
	jmp p1111
	
    nexts11:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagains1
	jmp skip2
	checkagains1:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagains2
	jmp skip2
	checkagains2:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagains3
	jmp skip2
	checkagains3:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je checkagains4
	jmp skip2
	checkagains4:
	mov ax,word[ds:si+8]
	cmp ax,0x0720
	je checkagains5
	jmp skip2
	checkagains5:
	mov ax,word[ds:si+10]
	cmp ax,0x0720
	je fp1
	jmp skip2
	fp1:
	
	mov di,dx
	sub di,160
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+164],ax
	mov word[es:di+166],ax
	mov word[es:di+168],ax
	mov word[es:di+170],ax
	push dx 
	call printshape1
	mov dx,si
	add si,160
    jmp scrollloop2	
	
	
	skiptocheck2:
	cmp ax,2
	je p222
	jmp skiptocheck3
	p222:
	mov dx,534
	mov si,694
	cld
	scrollloop3:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je skip2check44
	jmp skip2
	skip2check44:
	sub si,318
	mov ax,word[ds:si]
	add si,318
	cmp ax,0x0720
	je p2222
	jmp skip2
	

	p2222:
	call enterkey
	
	cmp ah,0x4b   ;left key
	je s2l0
	jmp nexts2
	s2l0:
	mov di,dx
	sub di,322
    mov word ax,[es:di]
	cmp ax,0x0720
	je s2l1
	jmp nexts2
	s2l1:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je s2l2
	jmp nexts2
	s2l2:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je s2l3
	jmp nexts2
	s2l3:
	mov di,dx
	sub di,320
	mov word[es:di],ax 
	mov word[es:di+2],ax 
	mov word[es:di+160],ax
	mov word[es:di+320],ax
    sub dx,2
	sub si,2
	
	mov di,dx
	sub di,320
	push di
	call printshape2
	jmp p2222
	
	
	nexts2:
	cmp ah,0x4d           ;right key
	je s2r0
	jmp nexts22
	s2r0:
	mov di,dx
	sub di,320
	mov word ax,[es:di+4]
	cmp ax,0x0720
	je s2r1
	jmp nexts22
	s2r1:
	mov word ax,[es:di+162]
	cmp ax,0x0720
	je s2r2
	jmp nexts22
	s2r2:
	mov word ax,[es:di+322]
	cmp ax,0x0720
	je s2r3
	jmp nexts22
	s2r3:
	mov di,dx
	sub di,320
	mov word[es:di],ax 
	mov word[es:di+2],ax 
	mov word[es:di+160],ax
	mov word[es:di+320],ax
    add dx,2
	add si,2
	
	mov di,dx
	sub di,320
	push di
	call printshape2
	jmp p2222
	
	nexts22:
	
	mov ax,word[ds:si]
	cmp ax,0x0720
	je skip2checkt44
	jmp skip2
	skip2checkt44:
	sub si,318
	mov ax,word[ds:si]
	add si,318
	cmp ax,0x0720
	je fp2
	jmp skip2
	fp2:
	
	mov di,dx
	sub di,320
	mov ax,0x0720
	mov word[es:di],ax 
	mov word[es:di+2],ax 
	mov word[es:di+160],ax
	mov word[es:di+320],ax
	sub dx,160
	push dx 
	call printshape2
	add dx,160
	mov dx,si
	add si,160
    jmp scrollloop3



	skiptocheck3:
	cmp ax,3
	je p333
	jmp skiptocheck4
	p333:
	mov dx,536
	mov si,696
	cld
	scrollloop4:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je skipcheck33
	jmp skip2
	skipcheck33:
	sub si,162
	mov ax,word[ds:si]
	add si,162
	cmp ax,0x0720
	je p3333
	jmp skip2
	p3333:
	call enterkey
	
	cmp ah,0x4b   ;left key
	je s3l0
	jmp nexts3
	s3l0:

	mov di,dx
	sub di,324
    mov word ax,[es:di]
	cmp ax,0x0720
	je s3l1
	jmp nexts3
	s3l1:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je s3l2
	jmp nexts3
	s3l2:
	add di,162
	mov word ax,[es:di]
	cmp ax,0x0720
	je s3l3
	jmp nexts3
	s3l3:
	mov di,dx
	sub di,322
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+322],ax
    sub dx,2
	sub si,2
	
	mov di,dx
	sub di,322
	push di 
	call printshape3
	jmp p3333
	
	nexts3:
	cmp ah,0x4d ;right key
	je s3r0
	jmp nexts33
	s3r0:
	mov di,dx
	sub di,322
	mov word ax,[es:di+2]
	cmp ax,0x0720
	je s3r1
	jmp nexts33
	s3r1:
	mov word ax,[es:di+164]
	cmp ax,0x0720
	je s3r2
	jmp nexts33
	s3r2:
	mov word ax,[es:di+324]
	cmp ax,0x0720
	je s3r3
	jmp nexts33
	s3r3:
	mov di,dx
	sub di,322
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+322],ax
    add dx,2
	add si,2
	
	mov di,dx
	sub di,322
	push di 
	call printshape3
	jmp p3333
	
	nexts33:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je skipcheckf33
	jmp skip2
	skipcheckf33:
	sub si,162
	mov ax,word[ds:si]
	add si,162
	cmp ax,0x0720
	je fp3
	jmp skip2
	fp3:
	
	mov di,dx
	sub di,322
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
	mov word[es:di+162],ax
	mov word[es:di+322],ax
	add di,160
	push di	
	call printshape3
	mov dx,si
	add si,160
    jmp scrollloop4
	
	
	skiptocheck4:
	cmp ax,4
	je p444
	jmp skiptocheck5
	p444:
	mov dx,534
	mov si,694
	cld
	scrollloop5:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je p4444
	jmp skip2
	p4444:
	call enterkey
	
	cmp ah,0x4b   ;left key
	je s4l0
	jmp nexts4
	s4l0:

	mov di,dx
	sub di,322
    mov word ax,[es:di]
	cmp ax,0x0720
	je s4l1
	jmp nexts4
	s4l1:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je s4l2
	jmp nexts4
	s4l2:
	add di,160
	mov word ax,[es:di]
	cmp ax,0x0720
	je s4l3
	jmp nexts4
	s4l3:
	mov di,dx
	sub di,320
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
    mov word[es:di+320],ax

    sub dx,2
	sub si,2
	
	mov di,dx
	sub di,320
	push di
	call printshape4
	jmp p4444
	
	nexts4:
	cmp ah,0x4d ;right key
	je s4r0
	jmp nexts44
	s4r0:
	mov di,dx
	sub di,320
	mov word ax,[es:di+2]
	cmp ax,0x0720
	je s4r1
	jmp nexts44
	s4r1:
	mov word ax,[es:di+162]
	cmp ax,0x0720
	je s4r2
	jmp nexts44
	s4r2:
	mov word ax,[es:di+322]
	cmp ax,0x0720
	je s4r3
	jmp nexts44
	s4r3:
	mov di,dx
	sub di,320
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
    mov word[es:di+320],ax

    add dx,2
	add si,2
	
	mov di,dx
	sub di,320
	push di
	call printshape4
	jmp p4444
	
	nexts44:
	
	mov ax,word[ds:si]
	cmp ax,0x0720
	je fp4
	jmp skip2
	fp4:
	
	mov di,dx
	sub di,320
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+160],ax
    mov word[es:di+320],ax
	add di,160
	push di	
	call printshape4
	mov dx,si
	add si,160
    jmp scrollloop5
	
	
	skiptocheck5:
	mov dx,214
	mov si,374
	cld
	scrollloop6:
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagain6
	jmp skip2
	checkagain6:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagain7
	jmp skip2
	checkagain7:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagain8
	jmp skip2
	checkagain8:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je checkagain9
	jmp skip2
	checkagain9:
	mov ax,word[ds:si+8]
	cmp ax,0x0720
	je p5555
	jmp skip2
	p5555:
	call enterkey
	
	cmp ah,0x4b   ;left key
	je s5l0
	jmp nexts5
	s5l0:

	mov di,dx
	sub di,2
    mov word ax,[es:di]
	cmp ax,0x0720
	je s5l1
	jmp nexts5
	s5l1:
	mov di,dx
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
    mov word[es:di+4],ax
	mov word[es:di+6],ax
	mov word[es:di+8],ax

    sub dx,2
	sub si,2
	
	mov di,dx
	push di
	call printshape5
	jmp p5555
	
	nexts5:
	cmp ah,0x4d ;right key
	je s5r0
	jmp nexts55
	s5r0:
	mov di,dx

	mov word ax,[es:di+10]
	cmp ax,0x0720
	je s5r1
	jmp nexts55
	s5r1:
	
    mov di,dx
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
    mov word[es:di+4],ax
	mov word[es:di+6],ax
	mov word[es:di+8],ax

    add dx,2
	add si,2
	
	mov di,dx
	push di
	call printshape5
	jmp p5555
	
	nexts55:
	
	mov ax,word[ds:si]
	cmp ax,0x0720
	je checkagains6
	jmp skip2
	checkagains6:
	mov ax,word[ds:si+2]
	cmp ax,0x0720
	je checkagains7
	jmp skip2
	checkagains7:
	mov ax,word[ds:si+4]
	cmp ax,0x0720
	je checkagains8
	jmp skip2
	checkagains8:
	mov ax,word[ds:si+6]
	cmp ax,0x0720
	je checkagains9
	jmp skip2
	checkagains9:
	mov ax,word[ds:si+8]
	cmp ax,0x0720
	je fp5
	jmp skip2
	fp5:
	
	
	
	
	mov di,dx
	mov ax,0x0720
	mov word[es:di],ax
	mov word[es:di+2],ax
    mov word[es:di+4],ax
	mov word[es:di+6],ax
	mov word[es:di+8],ax
	push si 
	call printshape5
	mov dx,si
	add si,160
    jmp scrollloop6
	
	skip2:
	pop dx
	pop ds
	pop si
	pop di
	pop es
	pop bx
	pop ax
	pop bp
	ret 2 
incrementscore:
    push bp 
    mov  bp, sp
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 
    
	mov word ax,[sco]
	add ax,10
	mov word [sco],ax
    

    mov ax,[sco]    
    mov bx, 10      
    mov cx, 0         

    firstloop:
        mov dx, 0    
        div bx       
        add dl,0x30 
        push dx      
        add cx,1       
        cmp ax, 0    
        jnz firstloop  

    mov ax, 0xb800 
    mov es, ax 
    mov di,766
    secondloop: 
        pop dx          
        mov dh, 0x0f   
        mov [es:di], dx 
        add di, 2 
        sub cx,1
        cmp cx,0
        jne secondloop		

    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax 
    pop es
    pop bp 
    ret 

movedown:
push bp
mov bp,sp
sub sp,2

push es

push cx
push di
push si
push ax
push bx
push ds

mov ax ,0xb800
mov es,ax
mov ds,ax
mov ax,60
mov [bp-2],ax
mov cx,22
mov di,[bp+4]
mov si,di
sub si,160

cld
nrows:
mov bx,[bp-2]
push di
push si
ncols:
movsw
dec bx
jnz ncols
pop si
pop di
sub si,160
sub di,160

cmp di,160
je youhavereachedsecondrow


loop nrows
youhavereachedsecondrow:

pop ds
pop bx
pop ax
pop si
pop di
pop cx
pop es
pop bp
pop bp
ret 2	
	
checkpop:
	push bp
	mov bp,sp
	sub sp,2
	push es
	push cx
	push di
	push ax
	push bx
	
	
	mov ax,0xb800
	mov es,ax
	mov di,3706
	mov cx,34
	mov bx,cx
	mov[bp-2],cx
	mov dx,23
	moverowsup:
    push bx
	push di
	mov cx,0
	checkforcols:
	mov word ax,[es:di]
	cmp ax,0x0720
	je skipthisrow
	add cx,1
	add di,2
	dec bx
	jnz checkforcols
	skipthisrow:
	pop di
    cmp cx,[bp-2]
	jne decrementrow
	sub di,26
	push di
	call movedown
	call incrementscore
	call delay
	add di,26
	cmp cx,[bp-2]
	je dontdecrementrow
	decrementrow:
	sub di,160
	dec dx
	dontdecrementrow:
	pop bx
	cmp dx,0
	jnz moverowsup
	

	
	pop bx
	pop ax
	pop di
	pop cx
	pop es
	pop bp
	pop bp
	ret
	
	
start:







call clearscreen
 call colourscr
 call printstart
 mov ah,0
 int 16h
 mov ax,0
call clearscreen

call drawborder      
xor ax,ax           ;Timerhooked
mov es,ax
mov ax,word[es:8*4]
mov [oldisr],ax
mov ax,word[es:8*4+2]
mov [oldisr+2],ax
cli
mov word[es:8*4],timer
mov [es:8*4+2],cs
sti



mainloop:
cmp word [tickmin],5
je gameend

mov ax,0xb800
mov es,ax
mov di,214
mov word ax,[es:di]
cmp ax,0x0720
jne gameend
call clearupcomingshape
push word [arr+2]
call printupcomingshape
call shapedelay
;call music
push word[arr]
call printshapeontop
call shapescrolldown
call checkpop

mov ax,[arr+2]
mov word [arr],ax
call RANDGEN
mov word[arr+2],dx
jmp mainloop
gameend:
call delay
push es
    xor ax,ax
    mov es,ax
    cli
    mov ax,[oldisr]
    mov word[es:8*4],ax
    mov ax,[oldisr+2]
    mov [es:8*4+2],ax
    sti
    pop es
call clearscreen
 call colourscr1
 call endscreen2
 call printend
 



mov ah,0x1 ; to stop upper most row from scrolling up unless user presses a key
int 0x21
mov ax,0x4c00
int 0x21
