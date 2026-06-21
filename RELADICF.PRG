FUNCTION RELADICF()
LOCAL  TELA,GETLIST:={},MOVI,LINHA1,LINHA2,LINHA3,LINHA4
LOCAL  TLINHA,TLINHA1,TLINHA2,TLINHA3,TLINHA4,MOVIFIM
LOCAL  TPAGVIS,TPAGFUT,TPAGTOTAL,TRECVIS,TRECFUT,TRECTOTAL
LOCAL  DATANT1,DATANT2,DATANT3,DATANT4
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,CLIFOR,INICIO,FIM,DATAPATH
TELA:=SAVESCREEN()
INICIO:=TRABALHO
FIM:=TRABALHO
LINHA:={}
LINHA1:={}
LINHA2:={}
LINHA3:={}
LINHA4:={}
TLINHA:={}
TLINHA1:={}
TLINHA2:={}
TLINHA3:={}
TLINHA4:={}
DBF_CONFIG()
DBF_CLIFOR()
DBF_CHEQUE()
DBF_BANK()
DBF_PORTA()
CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
DO WHILE .T.
   DATCFINIFIN("Lan‡amentos Di rios por Cliente ou Fornecedor","A")
   IF LASTKEY()=27
      EXIT
   ENDIF
   TPAGVIS  :=0
   TPAGFUT  :=0
   TPAGTOTAL:=0
   TRECVIS  :=0
   TRECFUT  :=0
   TRECTOTAL:=0
   DATANT1 := DATANT2 := DATANT3 := DATANT4 := INICIO-1

   @ 24,0 SAY PADC("Pesquisando Lan‡amentos",80) COLOR CORTIT

***** PRINTER
   AADD(LINHA1,"Contas … Receber Baixadas")
   AADD(LINHA1,REPLICATE("-",40))
   AADD(LINHA1,"Nome                               Doc.Int.   Doc.Ext.   Valor Doc.  Multa   Acres   Desc.   Deduc.  Valor Cob. Banco     ")
   AADD(LINHA2," ")
   AADD(LINHA2,"Recebimentos … Vista")
   AADD(LINHA2,REPLICATE("-",40))
   AADD(LINHA2,"Nome                         Descricao                    Doc.Int.   Doc.Ext.          Valor          Banco")
   AADD(LINHA3," ")
   AADD(LINHA3,"Contas … Pagar Baixadas")
   AADD(LINHA3,REPLICATE("-",40))
   AADD(LINHA3,"Nome                               Doc.Int.   Doc.Ext.   Valor Doc.  Multa   Acres   Desc.   Deduc.  Valor Cob. Banco     ")
   AADD(LINHA4," ")
   AADD(LINHA4,"Pagamentos … Vista")
   AADD(LINHA4,REPLICATE("-",40))
   AADD(LINHA4,"Nome                         Descricao                    Doc.Int.   Doc.Ext.  Cheque     Valor       Banco")
***** SCREEN
   AADD(TLINHA1,"Contas … Receber Baixadas")
   AADD(TLINHA1,REPLICATE("-",40))
   AADD(TLINHA2," ")
   AADD(TLINHA2,"Recebimentos … Vista")
   AADD(TLINHA2,REPLICATE("-",40))
   AADD(TLINHA3," ")
   AADD(TLINHA3,"Contas … Pagar Baixadas")
   AADD(TLINHA3,REPLICATE("-",40))
   AADD(TLINHA4," ")
   AADD(TLINHA4,"Pagamentos … Vista")
   AADD(TLINHA4,REPLICATE("-",40))

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
   DO WHILE .T.
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. (MOVI)->(! EOF())
         DO CASE
            CASE (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R" .AND. (MOVI)->CLIFOR_V=CLIFOR
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT1
                  DATANT1:=(MOVI)->DATBAI_V
                  AADD(LINHA1,DTOC(DATANT1))
                  AADD(LINHA1,REPLICATE("-",8))
               ENDIF
               AADD(LINHA1,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,34),SPACE(34))+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999.99")+"  "+TRANSFORM((MOVI)->MULTA_V,"@R 999.99")+"  "+;
                              TRANSFORM((MOVI)->ACRES_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               AADD(LINHA1,"  "+(MOVI)->DESC_V+" "+(MOVI)->BOLETO_V+" "+IF(PORTA->(DBSEEK((MOVI)->CODPORTA_V)),PORTA->NOME_V,SPACE(LEN(PORTA->NOME_V))))
               AADD(LINHA1," ")
               *** SCREEN
               AADD(TLINHA1,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28))
               AADD(TLINHA1,"         "+(MOVI)->DOCINT_V+" "+(MOVI)->BOLETO_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TRECFUT:=TRECFUT+(MOVI)->VALOR_V
               TRECTOTAL:=TRECTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="V" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R" .AND. (MOVI)->CLIFOR_V=CLIFOR
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT2
                  DATANT2:=(MOVI)->DATBAI_V
                  AADD(LINHA2,DTOC(DATANT2))
                  AADD(LINHA2,REPLICATE("-",8))
               ENDIF
               AADD(LINHA2,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+"        "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               *** SCREEN
               AADD(TLINHA2,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28))
               AADD(TLINHA2,"         "+(MOVI)->DOCINT_V+" "+(MOVI)->BOLETO_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TRECVIS:=TRECVIS+(MOVI)->VALOR_V
               TRECTOTAL:=TRECTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P" .AND. (MOVI)->CLIFOR_V=CLIFOR
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT3
                  DATANT3:=(MOVI)->DATBAI_V
                  AADD(LINHA3,DTOC(DATANT3))
                  AADD(LINHA3,REPLICATE("-",8))
               ENDIF
               AADD(LINHA3,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,34),SPACE(34))+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999.99")+"  "+TRANSFORM((MOVI)->MULTA_V,"@R 999.99")+"  "+;
                              TRANSFORM((MOVI)->ACRES_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999.99")+"  "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               AADD(LINHA3,"  "+(MOVI)->DESC_V+" "+(MOVI)->CHEQUE_V)
               AADD(LINHA3," ")
               *** SCREEN
               AADD(TLINHA3,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28))
               AADD(TLINHA3,"         "+(MOVI)->DOCINT_V+" "+(MOVI)->CHEQUE_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TPAGFUT:=TPAGFUT+(MOVI)->VALOR_V
               TPAGTOTAL:=TPAGTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="V" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P" .AND. (MOVI)->CLIFOR_V=CLIFOR
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT4
                  DATANT4:=(MOVI)->DATBAI_V
                  AADD(LINHA4,DTOC(DATANT1))
                  AADD(LINHA4,REPLICATE("-",8))
               ENDIF
               AADD(LINHA4,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->CHEQUE_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               *** SCREEN
               AADD(TLINHA4,DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28))
               AADD(TLINHA4,"         "+(MOVI)->DOCINT_V+" "+(MOVI)->CHEQUE_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TPAGVIS:=TPAGVIS+(MOVI)->VALOR_V
               TPAGTOTAL:=TPAGTOTAL+(MOVI)->VALOR_V
         ENDCASE
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
            IF FILE(DATAPATH+MOVI+".DBF")
               EXIT
            ENDIF
         ENDDO
         IF FILE(DATAPATH + MOVI+".DBF")
            DBF_MOVI(MOVI)
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO
   (MOVI)->(DBCLOSEAREA())
***** PRINTER
   AADD(LINHA1,REPLICATE("-",40))
   AADD(LINHA1,"Total : "+TRANSFORM(TRECFUT,"@R 999,999,999.99"))
   AADD(LINHA2,REPLICATE("-",40))
   AADD(LINHA2,"Total : "+TRANSFORM(TRECVIS,"@R 999,999,999.99"))
   AADD(LINHA3,REPLICATE("-",40))
   AADD(LINHA3,"Total : "+TRANSFORM(TPAGFUT,"@R 999,999,999.99"))
   AADD(LINHA4,REPLICATE("-",40))
   AADD(LINHA4,"Total : "+TRANSFORM(TPAGVIS,"@R 999,999,999.99"))
   AADD(LINHA1,)
   AADD(LINHA2,)
   AADD(LINHA3,)
   AADD(LINHA4,)
***** SCREEN
   AADD(TLINHA1,REPLICATE("-",40))
   AADD(TLINHA1,"Total : "+TRANSFORM(TRECFUT,"@R 999,999,999.99"))
   AADD(TLINHA2,REPLICATE("-",40))
   AADD(TLINHA2,"Total : "+TRANSFORM(TRECVIS,"@R 999,999,999.99"))
   AADD(TLINHA3,REPLICATE("-",40))
   AADD(TLINHA3,"Total : "+TRANSFORM(TPAGFUT,"@R 999,999,999.99"))
   AADD(TLINHA4,REPLICATE("-",40))
   AADD(TLINHA4,"Total : "+TRANSFORM(TPAGVIS,"@R 999,999,999.99"))
   AADD(TLINHA1,)
   AADD(TLINHA2,)
   AADD(TLINHA3,)
   AADD(TLINHA4,)


   X:=1
   DO WHILE .T.
      IF LINHA1[X]=NIL
         EXIT
      ENDIF
      AADD(LINHA,LINHA1[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF LINHA2[X]=NIL
         EXIT
      ENDIF
      AADD(LINHA,LINHA2[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF LINHA3[X]=NIL
         EXIT
      ENDIF
      AADD(LINHA,LINHA3[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF LINHA4[X]=NIL
         EXIT
      ENDIF
      AADD(LINHA,LINHA4[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF TLINHA1[X]=NIL
         EXIT
      ENDIF
      AADD(TLINHA,TLINHA1[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF TLINHA2[X]=NIL
         EXIT
      ENDIF
      AADD(TLINHA,TLINHA2[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF TLINHA3[X]=NIL
         EXIT
      ENDIF
      AADD(TLINHA,TLINHA3[X])
      X++
   ENDDO

   X:=1
   DO WHILE .T.
      IF TLINHA4[X]=NIL
         EXIT
      ENDIF
      AADD(TLINHA,TLINHA4[X])
      X++
   ENDDO

   WINDOW(0,0,24,79)
   SETCOLOR(CORTEX)
   @ 3,1 TO 3,78
   @ 22,1 TO 22,78
   SETCOLOR(CORTIT)
   @ 1,1 SAY PADC("Relat¢rio de Lan‡amentos Di rios no Per¡odo de "+DTOC(INICIO)+" … "+DTOC(FIM),78)
   @ 2,1 SAY PADC(IF(CLIFOR->(DBSEEK(CLIFOR)),ALLTRIM(CLIFOR->NOME_V),SPACE(50)),78)
   @ 23,1 CLEAR TO 23,78
   @ 23,1 SAY "Total Geral       Pagamentos : "+TRANSFORM(TPAGTOTAL,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECTOTAL,"@R 999,999,999.99")
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   ACHOICE(4,1,21,78,TLINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      AADD(LINHA,REPLICATE("-",80))
      AADD(LINHA,"Total Geral       Pagamentos : "+TRANSFORM(TPAGTOTAL,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECTOTAL,"@R 999,999,999.99"))
      C_IMPREL("Relatorio de Lancamentos Diarios no Periodo de "+DTOC(INICIO)+" … "+DTOC(FIM),IF(CLIFOR->(DBSEEK(CLIFOR)),CLIFOR->NOME_V,SPACE(50)),56)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
BANK  ->(DBCLOSEAREA())
PORTA->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)