FUNCTION BLOQUEIO()
LOCAL  TELA,OP,BLOQUEIO,RESGATE,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CODBAN
TELA:=SAVESCREEN()
SETCOLOR(CORTIT)
@ 1,0 SAY "Bloqueio de Valores"
WINDOW(1,0,12,50)
DBF_BANK()
DO WHILE .T.
   CODBAN    :=0
   BLOQUEIO  :=0
   RESGATE   :=0
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 2,1 CLEAR TO 11,49
   @ 2,2  PROMPT "Bloquear"
   @ 2,11 PROMPT "Desbloquear"
   @ 3,1 TO 3,49
   MENU TO OP
   DO CASE
      CASE OP=1
         @ 4,2 SAY "Banco           :" GET CODBAN PICT "99999" VALID(SEA_BANK(CODBAN,4,26))
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 5,2 SAY "Saldo em Conta  : " + TRANSFORM(BANK->SALDO_V,"@R 999,999,999.99")
         @ 6,2 SAY "Valor Bloqueado : " + TRANSFORM(BANK->BLOQUEIO_V,"@R 999,999,999.99")
         @ 7,2 SAY "Valor … Bloquear:" GET BLOQUEIO PICT "999,999,999.99" VALID(BLOQUEIO>0)
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 8,2 SAY "Bloqueado       : "+TRANSFORM(BANK->BLOQUEIO_V+BLOQUEIO,"@R 999,999,999.99")
         @ 9,2 SAY "Saldo em Conta  : "+TRANSFORM(BANK->SALDO_V-BLOQUEIO,"@R 999,999,999.99")
         IF CONFIRMA(20,20,"Confirma Bloqueio ?")
            IF BANK->(RECLOCK(5))
               BANK->SALDO_V :=BANK->SALDO_V-BLOQUEIO
               BANK->BLOQUEIO_V:=BANK->BLOQUEIO_V+BLOQUEIO
               BANK->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=2
         @ 4,2 SAY "Banco           :" GET CODBAN PICT "99999" VALID(SEA_BANK(CODBAN,4,26))
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 5 ,2 SAY "Saldo em Conta  : " + TRANSFORM(BANK->SALDO_V,"@R 999,999,999.99")
         @ 6 ,2 SAY "Valor Bloqueado : " + TRANSFORM(BANK->BLOQUEIO_V,"@R 999,999,999.99")
         @ 7 ,2 SAY "Valor … Resgatar:" GET RESGATE    PICT "999,999,999.99" VALID(RESGATE<=BANK->BLOQUEIO_V.AND.RESGATE>0)
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 8,2 SAY "Bloqueado        : " + TRANSFORM(BANK->BLOQUEIO_V-RESGATE,"@R 999,999,999.99")
         @ 9,2 SAY "Saldo em Conta  : " + TRANSFORM(BANK->SALDO_V+RESGATE,"@R 999,999,999.99")
         IF CONFIRMA(20,20,"Confirma Resgate ?")
            IF BANK->(RECLOCK(5))
               BANK->SALDO_V:=BANK->SALDO_V+RESGATE
               BANK->BLOQUEIO_V:=BANK->BLOQUEIO_V-RESGATE
               BANK->(DBUNLOCK())
            ENDIF
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(1,0,11,50)
BANK->(DBCLOSEAREA())
RETURN(.T.)