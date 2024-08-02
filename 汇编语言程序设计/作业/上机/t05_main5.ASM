EXTRN  DISPBX:Far
MYDATA SEGMENT
DATA  	DW      1234H,5678H,9D4CH,0D7H,0,-1,7D2AH,8A0EH,10F5H,645DH
N   	EQU     $-DATA
MYDATA ENDS
CODE    SEGMENT
        ASSUME  CS:CODE,DS:MYDATA
START:  MOV     AX,MYDATA
        MOV     DS,AX
        MOV     DX,0
        MOV     AX,N
        MOV     BX,2
        DIV     BX
        MOV     CX,AX
        MOV     BX,OFFSET DATA
        MOV     AX,[BX]
AGAIN:  INC     BX
        INC     BX
        PUSH    AX
        CMP     AX,[BX]
        JG     NEXT
        MOV     AX,[BX]
        PUSH    CX
        MOV     DX,0
        MOV     CX,2
        DIV     CX
        CMP     DX,0
        POP     CX
        JE      L0
        POP     AX
        JMP     NEXT
L0:     MOV     AX,[BX]
NEXT:   LOOP    AGAIN
        MOV     BX,AX
        CALL    DISPBX
        MOV     AH,4CH
        INT     21H
CODE    ENDS
       	END	START