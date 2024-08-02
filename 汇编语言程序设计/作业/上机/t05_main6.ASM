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
        MOV     DI,[BX]
AGAIN:  INC     BX
        INC     BX
        PUSH    AX
        MOV     AX,[BX]
        PUSH    CX
        MOV     DX,0
        MOV     CX,2
        DIV     CX
        CMP     DX,0
        POP     CX
        POP     AX
        JNE     NEXT
        CMP     AX,[BX]
        JG      NEXT
        MOV     AX,[BX]
NEXT:   CMP     DI,[BX]
        JL      L0
        MOV     DI,[BX]
L0:     LOOP    AGAIN
        MOV     BX,AX
        MOV     AH,02H
        MOV     DL,'M'
        INT     21H
        MOV     DL,'A'
        INT     21H
        MOV     DL,'X'
        INT     21H
        MOV     DL,':'
        INT     21H
        CALL    DISPBX
        MOV     DL,' '
        INT     21H
        MOV     BX,DI
        MOV     AH,02H
        MOV     DL,'M'
        INT     21H
        MOV     DL,'I'
        INT     21H
        MOV     DL,'N'
        INT     21H
        MOV     DL,':'
        INT     21H
        CALL    DISPBX
        MOV     AH,4CH
        INT     21H
CODE    ENDS
       	END	START