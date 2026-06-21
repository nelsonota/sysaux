FUNCTION REFLUXO()
LOCAL  TELA,INICIO2,GETLIST:={},MOVI,X
LOCAL  PLANO,CODPLA,TOTAL,RTOTAL,PTOTAL,TTOTAL
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,INICIO,FIM
TELA:=SAVESCREEN()
WINDOW(10,10,12,60)
X:=0
INICIO:=TRABALHO
FIM:=TRABALHO
LINHA:={}
DBF_CONFIG()
DBF_CLIFOR()
DBF_PLANO()
DO WHILE .T.
   DATINIFIN("Relat¢rio de Lan‡amento Di rios por Plano de Contas")
   IF LASTKEY()=27
      EXIT
   ENDIF
   INICIO2:=INICIO
   TOTAL:=0
   RTOTAL:=0
   PTOTAL:=0
   TTOTAL:=0
   PLANO->(DBGOTOP())
   DO WHILE PLANO->(!EOF()) .AND. X<4090
      CODPLA:=PLANO->CODIGO_V
      PLANO :=PLANO->NOME_V
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Aguarde verificando "+"("+LEFT(PLANO->CODIGO_V,1)+")"+" "+PLANO,80)
      AADD(LINHA,"("+LEFT(PLANO->CODIGO_V,1)+")"+" "+PLANO)
      AADD(LINHA,REPLICATE("-",40))
      X:=X+2
      DO WHILE INICIO<=FIM
         MOVI:=BAN_2MOVI(INICIO)
         IF .NOT. FILE(DATAPATH+MOVI+".DBF")
            INICIO++
            LOOP
         ENDIF
         DBUSEAREA(.T.,,MOVI,MOVI,.T.)
         LOCATE FOR (MOVI) ->DATBAI_V=INICIO
         DO WHILE (MOVI)->DATBAI_V=INICIO .AND. (MOVI)->(! EOF()) .AND. X<4086
            IF (MOVI)->CODPLA_V=CODPLA
               AADD(LINHA,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,20),LEFT((MOVI)->DESC_V,20))+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->CHEQUE_V+"    "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99"))
               X++
               TOTAL:=TOTAL+(MOVI)->VALOR_V
               DO CASE
                  CASE LEFT(CODPLA,1)="-"
                     PTOTAL:=PTOTAL+(MOVI)->VALOR_V
                  CASE LEFT(CODPLA,1)="+"
                     RTOTAL:=RTOTAL+(MOVI)->VALOR_V
                  CASE LEFT(CODPLA,1)="="
                     TTOTAL:=TTOTAL+(MOVI)->VALOR_V
               ENDCASE
            ENDIF
            (MOVI)->(DBSKIP())
         ENDDO
         (MOVI)->(DBCLOSEAREA())
         INICIO++
      ENDDO
      AADD(LINHA,REPLICATE("-",40))
      AADD(LINHA,"Total "+PLANO+" : "+TRANSFORM(TOTAL,"@R 999,999,999.99"))
      TOTAL:=0
      AADD(LINHA," ")
      X:=X+3
      INICIO:=INICIO2
      PLANO->(DBSKIP())
   ENDDO
   IF X>4090
      AVISO("Mem¢ria Insuficiente...")
   ENDIF
   WINDOW(0,0,24,79)
   SETCOLOR(CORTEX)
   @ 2,1 TO 2,78
   @ 20,1 TO 20,78
   SETCOLOR(CORTIT)
   @ 1,1 SAY PADC("Relat¢rio de Plano de Contas no Per¡odo de "+DTOC(INICIO2)+" … "+DTOC(FIM),78)
   @ 21,1 CLEAR TO 23,78
   @ 21,2 SAY "Total de (+) Recebimentos   : "+TRANSFORM(RTOTAL,"@R 999,999,999.99")
   @ 22,2 SAY "Total de (-) Pagamentos     : "+TRANSFORM(PTOTAL,"@R 999,999,999.99")
   @ 23,2 SAY "Total de (=) Transferˆncias : "+TRANSFORM(TTOTAL,"@R 999,999,999.99")
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   ACHOICE(3,1,19,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      AADD(LINHA,REPLICATE("-",80))
      AADD(LINHA,"Total de (+) Recebimentos   : "+TRANSFORM(RTOTAL,"@R 999,999,999.99"))
      AADD(LINHA,"Total de (-) Pagamentos     : "+TRANSFORM(PTOTAL,"@R 999,999,999.99"))
      AADD(LINHA,"Total de (=) Transferˆncias : "+TRANSFORM(TTOTAL,"@R 999,999,999.99"))
      IMPREL("Relatorio de Plano de Contas no Periodo de "+DTOC(INICIO2)+" a "+DTOC(FIM),,56)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)