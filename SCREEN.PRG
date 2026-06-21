FUNCTION TEL_PRINCIPAL()
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,CODSEN,LEVEL,RECO
SETBLINK(.F.)
SETCOLOR(CORTIT)
@ 0,0 SAY PADC("SysAux - Controle de Estoque,Presta‡ao de Servi‡os e Administra‡ao",80)
SETCOLOR(CORTEX)
@ 1,0 CLEAR TO 1,80
@ 24,0 CLEAR TO 24,80
DATA(24,45)
SETCOLOR(CORPAR)
@ 2,0 CLEAR TO 23,80
DBF_CONFIG()
IF CONFIG->PROTECT_V="S"
   @ 0,79 SAY CHR(251) COLOR CORTIT
ENDIF
@ 6,9 TO 6,69
@ 8,9 TO 8,69
*@ 7,8 SAY "/"
*@ 9,8 SAY "/"
@ 7,10 SAY PADC(ALLTRIM(DECRIP(CONFIG->NOME_V)),59)
@ 23,0 SAY "NeO Systems 3837-0790 F1-Ajuda"
RECO:=CONFIG->REGISTRO_V
CONFIG->(DBCLOSEAREA())
RETURN(.T.)

FUNCTION APRESENTA(TEMP)
LOCAL TELA,OLD
MEMVAR CORPAR
OLD:=SETCOLOR()
SETCOLOR(CORPAR)
TELA:=SAVESCREEN(3,0,19,80)
@ 2,0 CLEAR TO 19,80
RESTSCREEN(2,0,18,80,TELA)
DO CASE
   CASE TEMP=0
      @ 19,0 SAY PADC("SysAux",80)
   CASE TEMP=1
      @ 19,0 SAY PADC("ÄÄÄÄÄÄÄÄÄÄ",80)
   CASE TEMP=3
      @ 19,0 SAY PADC("Sistema de Aux¡lio em",80)
   CASE TEMP=5
      @ 19,0 SAY PADC("Controle de Estoque",80)
   CASE TEMP=7
      @ 19,0 SAY PADC("Presta‡ao de Servi‡os",80)
   CASE TEMP=9
      @ 19,0 SAY PADC("Compras",80)
   CASE TEMP=11
      @ 19,0 SAY PADC("Vendas",80)
   CASE TEMP=13
      @ 19,0 SAY PADC("Faturamento",80)
   CASE TEMP=15
      @ 19,0 SAY PADC("Contas … Pagar",80)
   CASE TEMP=17
      @ 19,0 SAY PADC("Contas … Receber",80)
   CASE TEMP=19
      @ 19,0 SAY PADC("Tesouraria",80)
   CASE TEMP=22
      @ 19,0 SAY PADC("Pirataria ‚ Crime",80)
   CASE TEMP=23
      @ 19,0 SAY PADC("e d  cadeia",80)
   CASE TEMP=25
      @ 19,0 SAY PADC("Programa Legal",80)
   CASE TEMP=26
      @ 19,0 SAY PADC("UpDate & Suporte",80)
   CASE TEMP=27
      @ 19,0 SAY PADC("NeO Systems",80)
   CASE TEMP=28
      @ 19,0 SAY PADC("nelson_ota@hotmail.com",80)
   CASE TEMP=29
      @ 19,0 SAY PADC("Fone :11 3837-0790",80)
ENDCASE
SETCOLOR(OLD)
RETURN(.T.)

FUNCTION CALCULA()
LOCAL  NUMERO,TOTAL,X,Y,Z,TELA,L1,L2,C1,C2,MOSTRA,K,TELA1
MEMVAR CORTIT,CORTEX,CORBAR,CORDES,CORPAR
SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
L1:=7
C1:=10
L2:=22
C2:=42
NUMERO:=""
TOTAL=0
X:=0
Y:=0
Z:=0
K:=1
TELA:=SAVESCREEN()
WINDOW(L1-2,C1,L1,C2)
WINDOW(L1,C1,L2,C2)
DO WHILE .T.
   @ L1+1,C1+1 CLEAR TO L2-1,C2-1
   SETCOLOR(CORDES)
   IF Y=13 .OR. CHR(Y)="/" .OR. CHR(Y)="*" .OR. CHR(Y)="+" .OR. CHR(Y)="-"
      @ L1+1,C1+6 SAY TOTAL PICT "999,999,999,999,999.9999"
   ELSE
      @ L1+1,C1+6 SAY VAL(NUMERO) PICT "999,999,999,999,999.9999"
   ENDIF
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ L1+3,C1+2  SAY "[  C  ] [  CE  ]"
    
   @ L1+5,C1+2  SAY "        [  ö  ] [  x  ] [ - ]" 

   @ L1+7,C1+2  SAY "[  7  ] [  8  ] [  9  ] Ú   ¿"
   @ L1+8,C1+2  SAY "                          +  "
   @ L1+9,C1+2  SAY "[  4  ] [  5  ] [  6  ] À   Ù"

   @ L1+11,C1+2 SAY "[  1  ] [  2  ] [  3  ] Ú   ¿"
   @ L1+12,C1+2 SAY "                          =  "
   @ L1+13,C1+2 SAY "[      0      ] [  .  ] À   Ù"
   X:=INKEY(.5)

   IF X#0
      BOTAO(X,L1,C1,L2,C2)

      IF X=67 .OR. X=99
         NUMERO:=""
         TOTAL:=0
         LOOP
      ENDIF

      IF X=69 .OR. X=101
         NUMERO:=""
         LOOP
      ENDIF

      IF X=13
         DO CASE
            CASE CHR(Z)="+"
               TOTAL:=TOTAL+VAL(NUMERO)
               NUMERO:=""
               Y:=13
            CASE CHR(Z)="-"
               TOTAL:=TOTAL-VAL(NUMERO)
               NUMERO:=""
               Y:=13
            CASE CHR(Z)="*"
               TOTAL:=TOTAL*VAL(NUMERO)
               NUMERO:=""
               Y:=13
            CASE CHR(Z)="/"
               TOTAL:=TOTAL/VAL(NUMERO)
               NUMERO:=""
               Y:=13
         ENDCASE
         LOOP
      ENDIF

      IF X=27
         EXIT
      ENDIF

      DO CASE
         CASE CHR(X)="+"
            TOTAL:=TOTAL+VAL(NUMERO)
            NUMERO:=""
            Y:=X
            Z:=X
         CASE CHR(X)="-"
            IF TOTAL=0
               TOTAL:=TOTAL+VAL(NUMERO)
            ENDIF
            NUMERO:=""
            Y:=X
            Z:=X
         CASE CHR(X)="*"
            IF TOTAL=0
               TOTAL:=VAL(NUMERO)
            ENDIF
            NUMERO:=""
            Y:=X
            Z:=X
         CASE CHR(X)="/"
            IF TOTAL=0
               TOTAL:=VAL(NUMERO)
            ENDIF
            NUMERO:=""
            Y:=X
            Z:=X
      ENDCASE

      IF CHR(X)$"1234567890."
         IF CHR(X)="." .AND. "."$NUMERO
            LOOP
         ENDIF
         NUMERO:=NUMERO+CHR(X)
         Y:=X
         LOOP
      ENDIF
      DO CASE
         CASE X=5
            L1--
            L2--
            K:=1
            RESTSCREEN(,,,,TELA)
            WINDOW(L1-2,C1,L1,C2)
            WINDOW(L1,C1,L2,C2)
         CASE X=24
            L1++
            L2++
            K:=1
            RESTSCREEN(,,,,TELA)
            WINDOW(L1-2,C1,L1,C2)
            WINDOW(L1,C1,L2,C2)
         CASE X=19
            C1--
            C2--
            K:=1
            RESTSCREEN(,,,,TELA)
            WINDOW(L1-2,C1,L1,C2)
            WINDOW(L1,C1,L2,C2)
         CASE X=4
            C1++
            C2++
            K:=1
            RESTSCREEN(,,,,TELA)
            WINDOW(L1-2,C1,L1,C2)
            WINDOW(L1,C1,L2,C2)
      ENDCASE
   ELSE
      MOSTRA:="Com‚rcio - Sistema de Controle de Estoque,Assistˆncia T‚cnica e Administra‡ao.  11 9631-8423"
      TELA1:=SAVESCREEN(L1-1,C1+3,L1-1,C2-2)
      RESTSCREEN(L1-1,C1+2,L1-1,C2-3,TELA1)
      @ L1-1,C2-2 SAY SUBSTR(MOSTRA,K,1)
      K++
      IF K>LEN(MOSTRA)
         K:=1
      ENDIF
   ENDIF
ENDDO
RESTSCREEN(,,,,TELA)
RETURN(.T.)

FUNCTION BOTAO(X,L1,C1,L2,C2)
MEMVAR CORTIT,CORTEX,CORBAR,CORDES,CORPAR
IF CHR(X)="1"
   @ L1+11,C1+2 SAY "[  1  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="2"
   @ L1+11,C1+10 SAY "[  2  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="3"
   @ L1+11,C1+18 SAY "[  3  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF CHR(X)="4"
   @ L1+9,C1+2 SAY "[  4  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="5"
   @ L1+9,C1+10 SAY "[  5  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="6"
   @ L1+9,C1+18 SAY "[  6  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF


IF CHR(X)="7"
   @ L1+7,C1+2 SAY "[  7  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="8"
   @ L1+7,C1+10 SAY "[  8  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="9"
   @ L1+7,C1+18 SAY "[  9  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF CHR(X)="0"
   @ L1+13,C1+2 SAY "[      0      ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="."
   @ L1+13,C1+18 SAY "[  .  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF CHR(X)="/"
   @ L1+5,C1+10 SAY "[  ö  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="*"
   @ L1+5,C1+18 SAY "[  x  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
IF CHR(X)="-"
   @ L1+5,C1+26 SAY "[ - ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF CHR(X)="+"
   @ L1+7,C1+26 SAY "Ú   ¿" COLOR(CORBAR)
   @ L1+8,C1+26 SAY "  +  " COLOR(CORBAR)
   @ L1+9,C1+26 SAY "À   Ù" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF X=13
   @ L1+11,C1+26 SAY "Ú   ¿" COLOR(CORBAR)
   @ L1+12,C1+26 SAY "  =  " COLOR(CORBAR)
   @ L1+13,C1+26 SAY "À   Ù" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF X=67 .OR. X=99
   @ L1+3,C1+2 SAY "[  C  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF

IF X=69 .OR. X=101
   @ L1+3,C1+10 SAY "[  CE  ]" COLOR(CORBAR)
   INKEY(.1)
ENDIF
RETURN(.T.)

FUNCTION AJUDA()
LOCAL CAMPO,TITULO,OLD,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,CODSEN,LEVEL
DBF_ACCCOM()
OLD:=SETCOLOR()
TELA:=SAVESCREEN()
SET KEY 28 TO
CAMPO:={"ACCCOM->MENU_V"}
TITULO:={"Ajuda Sobre :"}
SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
DO WHILE .T.
   WINDOW(0,40,24,79)
   ACCCOM->(DBEDIT(1,41,23,78,CAMPO,,,TITULO))
   IF LASTKEY()=27
      EXIT
   ENDIF
   WINDOW(2,1,15,50)
   SETCURSOR(1)
   MEMOEDIT(ACCCOM->HELP_V,3,2,14,49,.T.)
   RESTSCREEN(,,,,TELA)
   CLOSEWIN(2,1,15,50)
ENDDO
RESTSCREEN(,,,,TELA)
SETCOLOR(OLD)
ACCCOM->(DBCLOSEAREA())
SET KEY 28 TO AJUDA()
RETURN(.T.)