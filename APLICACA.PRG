FUNCTION APLICACAO()
LOCAL  TELA,OP,APLICA,RESGATE,RENDIMENTO,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CODBAN
TELA:=SAVESCREEN()
WINDOW(1,0,12,50)
DBF_BANK()
DO WHILE .T.
   CODBAN    :=0
   APLICA    :=0
   RESGATE   :=0
   RENDIMENTO:=0
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 2,1 CLEAR TO 11,49
   @ 2,2  PROMPT "Aplicar"
   @ 2,10 PROMPT "Resgatar"
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
         @ 6,2 SAY "Valor … Aplicar :" GET APLICA PICT "999,999,999.99" VALID(APLICA>0)
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 7,2 SAY "Aplicado        : "+TRANSFORM(BANK->APLICA_V+APLICA,"@R 999,999,999.99")
         @ 8,2 SAY "Saldo em Conta  : "+TRANSFORM(BANK->SALDO_V-APLICA,"@R 999,999,999.99")
         IF CONFIRMA(20,20,"Confirma Aplica‡ao ?")
            IF BANK->(RECLOCK(5))
               BANK->SALDO_V :=BANK->SALDO_V-APLICA
               BANK->APLICA_V:=BANK->APLICA_V+APLICA
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
         @ 6 ,2 SAY "Valor Aplicado  : " + TRANSFORM(BANK->APLICA_V,"@R 999,999,999.99")
         @ 7 ,2 SAY "Valor … Resgatar:" GET RESGATE    PICT "999,999,999.99" VALID(RESGATE<=BANK->APLICA_V.AND.RESGATE>0)
         @ 8 ,2 SAY "Rendimento      :" GET RENDIMENTO PICT "999,999,999.99"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         @ 9 ,2 SAY "Valor Resgatado : " + TRANSFORM(RESGATE+RENDIMENTO,"@R 999,999,999.99")
         @ 10,2 SAY "Aplicado        : " + TRANSFORM(BANK->APLICA_V-RESGATE,"@R 999,999,999.99")
         @ 11,2 SAY "Saldo em Conta  : " + TRANSFORM(BANK->SALDO_V+RESGATE+RENDIMENTO,"@R 999,999,999.99")
         IF CONFIRMA(20,20,"Confirma Resgate ?")
            IF BANK->(RECLOCK(5))
               BANK->SALDO_V:=BANK->SALDO_V+RESGATE+RENDIMENTO
               BANK->APLICA_V:=BANK->APLICA_V-RESGATE
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