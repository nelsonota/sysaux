FUNCTION RECHQ(OPCAO)
LOCAL  GETLIST:={},TELA,X,TVALOR,MARCA,MARCA2,TDIA,TITULO,TITULO2
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,INICIO,FIM
LINHA:={}
TELA:=SAVESCREEN(0,0,24,80)
DBF_CONFIG()
DBF_CHEQUE()
DBF_BANK()
WINDOW(10,10,12,60)
MARCA :=CTOD("  /  /  ")
INICIO:=CTOD("  /  /  ")
FIM   :=CTOD("  /  /  ")
DO WHILE .T.
   DATINIFIN("Relat¢rio de Cheques "+IF(OPCAO="PEN","nao Compensados",IF(OPCAO="COM","Compensados","Cancelados")))
   IF LASTKEY()=27
      EXIT
   ENDIF
   TVALOR:=0
   TDIA  :=0
   DO CASE
      CASE OPCAO="PEN"
         TITULO:="Pendentes"
         CHEQUE->(DBSETORDER(4))
      CASE OPCAO="COM"
         TITULO:="Compensados"
         CHEQUE->(DBSETORDER(5))
      CASE OPCAO="CAN"
         TITULO:="Cancelados"
         CHEQUE->(DBSETORDER(5))
   ENDCASE
   CHEQUE->(DBSEEK(INICIO,.T.))
   X:=1
   DO WHILE CHEQUE->(!EOF()) .AND. IF(OPCAO="PEN",CHEQUE->DATEMI_V,CHEQUE->DATBAI_V)>=INICIO .AND. IF(OPCAO="PEN",CHEQUE->DATEMI_V,CHEQUE->DATBAI_V)<=FIM .AND. X<=4090
      DO CASE
         CASE OPCAO="PEN"
            IF !EMPTY(CHEQUE->DATBAI_V) .OR. EMPTY(CHEQUE->DATEMI_V)
               CHEQUE->(DBSKIP())
               MARCA2="S"
               LOOP
            ELSE
               MARCA2="N"
            ENDIF
            MARCA:=CHEQUE->DATEMI_V
         CASE OPCAO="COM"
            IF EMPTY(CHEQUE->DATBAI_V) .OR. UPPER(CHEQUE->OBS_V)="CANCELADO"
               CHEQUE->(DBSKIP())
               MARCA2="S"
               LOOP
            ELSE
               MARCA2="N"
            ENDIF
            MARCA:=CHEQUE->DATBAI_V
         CASE OPCAO="CAN"
            IF EMPTY(CHEQUE->DATBAI_V) .OR. UPPER(CHEQUE->OBS_V)#"CANCELADO"
               CHEQUE->(DBSKIP())
               MARCA2="S"
               LOOP
            ELSE
               MARCA2="N"
            ENDIF
            MARCA:=CHEQUE->DATBAI_V
      ENDCASE
      CHEQUE->(DBSKIP())
      DO CASE
         CASE OPCAO="PEN" 
            IF CHEQUE->DATEMI_V#MARCA
               MARCA2="S"
            ENDIF
         CASE OPCAO="COM".OR.OPCAO="CAN"
            IF CHEQUE->DATBAI_V#MARCA
               MARCA2="S"
            ENDIF
      ENDCASE
      CHEQUE->(DBSKIP(-1))
      AADD(LINHA," "+IF(BANK->(DBSEEK(CHEQUE->CODBAN_V)),BANK->NOME_V,SPACE(10))+"   "+CHEQUE->CHEQUE_V+"   "+TRANSFORM(CHEQUE->VALOR_V,"@R 999,999,999.99")+"   "+DTOC(CHEQUE->DATEMI_V)+IF(OPCAO#"PEN","      "+DTOC(CHEQUE->DATBAI_V),SPACE(8)))
      TDIA:=TDIA+CHEQUE->VALOR_V
      IF MARCA2="S"
         AADD(LINHA,SPACE(32)+"Total   "+DTOC(MARCA)+" : "+TRANSFORM(TDIA,"@R 999,999,999.99"))
         AADD(LINHA,SPACE(78))
         MARCA2="N"
         TDIA:=0
      ENDIF
      TVALOR:=TVALOR+CHEQUE->VALOR_V
      CHEQUE->(DBSKIP())
      X++
   ENDDO
   IF X>4090
      AVISO("Mem¢ria Insufuciente...")
   ENDIF
   IF MARCA2="S"
      AADD(LINHA,SPACE(32)+"Total   "+DTOC(MARCA)+" : "+TRANSFORM(TDIA,"@R 999,999,999.99"))
   ENDIF
   WINDOW(5,0,20,79)
   SETCOLOR(CORTIT)
   @ 6,1 SAY PADC("Relat¢rio de Cheques "+TITULO+" no Per¡odo de : "+DTOC(INICIO)+" … "+DTOC(FIM),78)
   DO CASE
      CASE OPCAO="COM"
         TITULO2="Compensa‡ao"
      CASE OPCAO="CAN"
         TITULO2="Cancelamento"
   ENDCASE
   @ 7,1 SAY PADR(" Banco        Cheque            Valor   Dt.Emissao"+IF(OPCAO#"PEN","   Dt."+TITULO2," "),78)
   @ 19,1 SAY PADR(" Total de Cheque "+TITULO+" : "+TRANSFORM(TVALOR,"@R 999,999,999.99"),78)
   SETCOLOR(CORTEX)
   @ 8,1 TO 8,78
   @ 18,1 TO 18,78
   ACHOICE(9,1,17,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      AADD(LINHA,REPLICATE("-",78))
      AADD(LINHA," Total de Cheque "+TITULO+" : "+TRANSFORM(TVALOR,"@R 999,999,999.99"))
      IMPREL("Relat¢rio de Cheques "+TITULO+" no Per¡odo de : "+DTOC(INICIO)+" … "+DTOC(FIM)," Banco        Cheque            Valor   Dt.Emissao"+IF(OPCAO#"PEN","   Dt."+TITULO2," "),50)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)