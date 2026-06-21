FUNCTION RELPLANO()
LOCAL TELA,GETLIST:={},MOVI,TOTAL,MOVIFIM
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CODPLA,INICIO,FIM,LINHA,DATAPATH

LINHA:={}
TLINHA:={}
TELA:=SAVESCREEN()
DBF_PLANO()
DBF_CONFIG()
DBF_CLIFOR()
DBF_BANK()
INICIO:=TRABALHO
FIM   :=TRABALHO
TOTAL :=0
CODPLA:=SPACE(LEN(PLANO->CODIGO_V))
DO WHILE .T.
   DATPLINIFIN("Lan‡amentos por Plano de Conta")
   if lastkey()=27
      exit
   endif
   MOVI:=BAN_2MOVI(INICIO)
   MOVIFIM := BAN_2MOVI(DATE())
   IF ! FILE(DATAPATH+MOVI+".DBF")
      DO WHILE MOVI<>MOVIFIM
         DO CASE
            CASE SUBSTR(MOVI,5,1)="9"
               MOVI:="MOVIA"+RIGHT(MOVI,2)
            CASE SUBSTR(MOVI,5,1)="A"
               MOVI:="MOVIB"+RIGHT(MOVI,2)
            CASE SUBSTR(MOVI,5,1)="B"
               MOVI:="MOVIC"+RIGHT(MOVI,2)
            CASE SUBSTR(MOVI,5,1)="C"
               IF RIGHT(MOVI,2)="99"
                  MOVI:="MOVI100"
               ELSE
                  MOVI:="MOVI1"+STRZERO(VAL(RIGHT(MOVI,2))+1,2,0)
               ENDIF
            OTHERWISE
               MOVI:="MOVI"+STRZERO(VAL(SUBSTR(MOVI,5,1))+1,1,0)+RIGHT(MOVI,2)
         ENDCASE
         IF FILE(MOVI+".DBF")
            EXIT
         ENDIF
      ENDDO
   ENDIF
   IF ! FILE(DATAPATH+MOVI+".DBF")
      aviso("Nao existem lancamentos neste periodo")
      loop
   ENDIF
   DBF_MOVI(MOVI)
   (MOVI)->(DBSETORDER(3))
   (MOVI)->(DBSEEK(INICIO,.T.))
   DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. ! (MOVI)->(EOF())
         IF (MOVI)->CODPLA_V==CODPLA
            *** PRINTER
            AADD(LINHA,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->BOLETO_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
            *** SCREEN
            AADD(TLINHA,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28))
            AADD(TLINHA,"         "+(MOVI)->DOCINT_V+" "+(MOVI)->BOLETO_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
            TOTAL:=TOTAL+(MOVI)->VALOR_V
         ENDIF
         (MOVI)->(DBSKIP())
      ENDDO
      (MOVI) -> (DBCLOSEAREA())
      IF MOVI=MOVIFIM
         EXIT
      ELSE
         DO WHILE MOVI<>MOVIFIM
            DO CASE
               CASE SUBSTR(MOVI,5,1)="9"
                  MOVI:="MOVIA"+RIGHT(MOVI,2)
               CASE SUBSTR(MOVI,5,1)="A"
                  MOVI:="MOVIB"+RIGHT(MOVI,2)
               CASE SUBSTR(MOVI,5,1)="B"
                  MOVI:="MOVIC"+RIGHT(MOVI,2)
               CASE SUBSTR(MOVI,5,1)="C"
                  IF RIGHT(MOVI,2)="99"
                     MOVI:="MOVI100"
                  ELSE
                     MOVI:="MOVI1"+STRZERO(VAL(RIGHT(MOVI,2))+1,2,0)
                  ENDIF
               OTHERWISE
                  MOVI:="MOVI"+STRZERO(VAL(SUBSTR(MOVI,5,1))+1,1,0)+RIGHT(MOVI,2)
            ENDCASE
            IF FILE(MOVI+".DBF")
               EXIT
            //ELSE
            //   X++
            ENDIF
         ENDDO
         IF FILE(DATAPATH + MOVI+".DBF")
            DBF_MOVI(MOVI)
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO
   WINDOW(0,0,24,79)
   SETCOLOR(CORTEX)
   @ 2,1 TO 2,78
   @ 22,1 TO 22,78
   SETCOLOR(CORTIT)
   @ 1,1 SAY PADC("Relat¢rio por Plano de Conta no Per¡odo de "+DTOC(INICIO)+" … "+DTOC(FIM),78)
   @ 23,1 SAY PADR(" Total : "+TRANSFORM(TOTAL,"@R 999,999.99"),78)
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   ACHOICE(3,1,21,78,TLINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      AADD(LINHA,REPLICATE("-",125))
      AADD(LINHA,"Total : "+TRANSFORM(TOTAL,"@R 999,999.99"))
      AADD(LINHA,REPLICATE("=",125))
      C_IMPREL("Relatorio por Plano de Conta no Periodo de "+DTOC(INICIO)+" … "+DTOC(FIM),,56)
   ENDIF
   EXIT
ENDDO
CLIFOR->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)
