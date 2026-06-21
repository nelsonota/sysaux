FUNCTION RELADIA()
LOCAL  TELA,INICIO2,GETLIST:={},MOVI,LINHA1,LINHA2,LINHA3,LINHA4
LOCAL  TLINHA,TLINHA1,TLINHA2,TLINHA3,TLINHA4,MOVIFIM
LOCAL  TPAGVIS,TPAGFUT,TPAGTOTAL,TRECVIS,TRECFUT,TRECTOTAL,TCHQTOTAL
LOCAL  DATANT1,DATANT2,DATANT3,DATANT4
LOCAL  ARQ,CAMPOS
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,INICIO,FIM,DATAPATH
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
DBF_PLANO()
DO WHILE .T.
   DATINIFIN("Lan‡amento Di rios no Per¡odo de :")
   IF LASTKEY()=27
      EXIT
   ENDIF
   INICIO2:=INICIO
   CAMPOS:={}
   AADD(CAMPOS,{"COL1"      ,"C",02,0 })
   AADD(CAMPOS,{"COL2"      ,"C",78,0 })
   AADD(CAMPOS,{"CHEQUE_V"  ,"C",6 ,0 })
   AADD(CAMPOS,{"VALOR_V"   ,"N",14,2 })
   AADD(CAMPOS,{"CODPLA_V"  ,"C",4 ,0 })
   AADD(CAMPOS,{"DESCONTO_V","N",14,2 })
   AADD(CAMPOS,{"DEDUCAO_V" ,"N",14,2 })
   AADD(CAMPOS,{"MULTA_V"   ,"N",14,2 })
   AADD(CAMPOS,{"ACRES_V"   ,"N",14,2 })
   AADD(CAMPOS,{"PROTESTO_V","C",1 ,0 })
   ARQ:=NOMETEMP()
   DBCREATE(ARQ,CAMPOS)
   IF ! FILE(ARQ+".DBF")
      AVISO("O Sistema nao conseguiu criar o arquivo temporario")
      LOOP
   ENDIF
   DBF_TMP(ARQ)
   INDEX ON TMP->COL1 TO ARQ
/*
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL2:=
*/
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="10"
   TMP->COL2:="Contas … Receber Baixadas"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="20"
   TMP->COL2:="Recebimentos … Vista"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="30"
   TMP->COL2:="Contas … Pagar Baixadas"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="40"
   TMP->COL2:="Pagamentos … Vista"
   TPAGVIS := TPAGFUT := TPAGTOTAL := TRECVIS := TRECFUT := TRECTOTAL := TCHQTOTAL := 0
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
         IF FILE(DATAPATH+MOVI+".DBF")
            EXIT
         ENDIF
      ENDDO
   ENDIF
   IF ! FILE(DATAPATH+MOVI+".DBF")
      tmp->(dbclosearea())
      aviso("Nao existem lancamentos neste periodo")
      loop
   ENDIF
   DBF_MOVI(MOVI)
   DO WHILE .t.
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. (MOVI)->(! EOF())
         DO WHILE ! TMP->(ADDREC(5));ENDDO
         DO CASE
            CASE (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R"
               TMP->COL1:="12"
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
               TRECFUT:=TRECFUT+(MOVI)->VALOR_V
               TRECTOTAL:=TRECTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="V" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R"
               TMP->COL1:="22"
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT2
                  DATANT2:=(MOVI)->DATBAI_V
                  AADD(LINHA2,DTOC(DATANT2))
                  AADD(LINHA2,REPLICATE("-",8))
               ENDIF
               AADD(LINHA2,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+"        "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TRECVIS:=TRECVIS+(MOVI)->VALOR_V
               TRECTOTAL:=TRECTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P"
               TMP->COL1:="32"
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
               TPAGFUT:=TPAGFUT+(MOVI)->VALOR_V
               TPAGTOTAL:=TPAGTOTAL+(MOVI)->VALOR_V
            CASE (MOVI)->FUTVIS_V="V" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P"
               TMP->COL1:="42"
               *** PRINTER
               IF (MOVI)->DATBAI_V#DATANT4
                  DATANT4:=(MOVI)->DATBAI_V
                  AADD(LINHA4,DTOC(DATANT1))
                  AADD(LINHA4,REPLICATE("-",8))
               ENDIF
               AADD(LINHA4,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,28),SPACE(28))+" "+LEFT((MOVI)->DESC_V,28)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->CHEQUE_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99")+" "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
               TPAGVIS:=TPAGVIS+(MOVI)->VALOR_V
               TPAGTOTAL:=TPAGTOTAL+(MOVI)->VALOR_V
         ENDCASE
         SET CENTURY ON
         TMP->COL2:=DTOC((MOVI)->DATBAI_V)+" "+IF(CLIFOR->(DBSEEK( (MOVI)->CLIFOR_V )),LEFT(CLIFOR->NOME_V,20),SPACE(20))+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->DOCINT_V+" "+TRANSFORM((MOVI)->VALDOC_V,"@R 99,999.99")+" "+DTOC((MOVI)->DATVEN_V)+" "+TRANSFORM((MOVI)->DATVEN_V-(MOVI)->DATBAI_V,"@R 999")
         SET CENTURY OFF
         TMP->CHEQUE_V  :=(MOVI)->CHEQUE_V
         TMP->VALOR_V   :=(MOVI)->VALOR_V
         TMP->CODPLA_V  :=(MOVI)->CODPLA_V
         TMP->DESCONTO_V:=(MOVI)->DESCONTO_V
         TMP->DEDUCAO_V :=(MOVI)->DEDUCAO_V
         TMP->MULTA_V   :=(MOVI)->MULTA_V
         TMP->ACRES_V   :=(MOVI)->ACRES_V
         TMP->PROTESTO_V:=(MOVI)->PROTESTO_V
         TMP->(DBCOMMIT(),DBUNLOCK())
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
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="13"
   TMP->COL2:=REPLICATE("-",40)
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="23"
   TMP->COL2:=REPLICATE("-",40)
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="33"
   TMP->COL2:=REPLICATE("-",40)
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="43"
   TMP->COL2:=REPLICATE("-",40)
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="14"
   TMP->COL2:="Total : "+TRANSFORM(TRECFUT,"@R 999,999,999.99")
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="24"
   TMP->COL2:="Total : "+TRANSFORM(TRECVIS,"@R 999,999,999.99")
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="34"
   TMP->COL2:="Total : "+TRANSFORM(TPAGFUT,"@R 999,999,999.99")
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="44"
   TMP->COL2:="Total : "+TRANSFORM(TPAGVIS,"@R 999,999,999.99")
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="15"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="25"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="35"
   DO WHILE ! TMP->(ADDREC(5));ENDDO
   TMP->COL1:="45"
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

   SETCOLOR(CORTIT)
   @ 24,0 SAY PADC("Cheques Compensados",80)
   AADD(LINHA," ")
   AADD(LINHA,"Cheques Compensados no Per¡odo")
   AADD(LINHA,REPLICATE("-",40))
   CHEQUE->(DBSETORDER(5))
   CHEQUE->(DBSEEK(INICIO2,.T.))
   DO WHILE CHEQUE->DATBAI_V>=INICIO2 .AND. CHEQUE->DATBAI_V<=FIM .AND. CHEQUE->(! EOF())
      IF UPPER(CHEQUE->OBS_V)<>"CANCELADO" .AND. ! EMPTY(CHEQUE->DATBAI_V)
         AADD(LINHA,DTOC(CHEQUE->DATBAI_V)+" "+CHEQUE->CHEQUE_V+" "+IF(BANK->(DBSEEK(CHEQUE->CODBAN_V)),BANK->NOME_V,SPACE(10))+"  "+TRANSFORM(CHEQUE->VALOR_V,"@R 999,999,999.99"))
         TCHQTOTAL:=TCHQTOTAL+CHEQUE->VALOR_V
      ENDIF
      CHEQUE->(DBSKIP())
   ENDDO
   AADD(LINHA,REPLICATE("-",40))
   AADD(LINHA,"Total : "+TRANSFORM(TCHQTOTAL,"@R 999,999,999.99"))

   WINDOW(0,0,20,79)
   WINDOW(20,0,24,79)
   SETCOLOR(CORTEX)
   @ 2,1 TO 2,78
   SETCOLOR(CORTIT)
   @ 1,1 SAY PADC("Relat¢rio de Lan‡amentos Di rios no Per¡odo de "+DTOC(INICIO2)+" … "+DTOC(FIM),78)
   @ 23,1 CLEAR TO 23,78
   @ 23,1 SAY "Total Geral       Pagamentos : "+TRANSFORM(TPAGTOTAL,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECTOTAL,"@R 999,999,999.99")
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   TMP->(DBGOTOP())
   TMP->(DBEDIT(3,1,19,78,{"COL2"},"FRELADIA",,{"Data Lanc. Nome                 Doc.Ext.   Doc.Int.       Valor Vencimento Atr"}))
   TMP->(DBCLOSEAREA())
   FERASE(ARQ+".DBF")
   FERASE(ARQ+".NTX")
   (MOVI)->(DBCLOSEAREA())
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      AADD(LINHA,REPLICATE("-",80))
      AADD(LINHA,"Total Geral       Pagamentos : "+TRANSFORM(TPAGTOTAL,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECTOTAL,"@R 999,999,999.99"))
      C_IMPREL("Relatorio de Lancamentos Diarios no Periodo de "+DTOC(INICIO2)+" … "+DTOC(FIM),,56)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
BANK  ->(DBCLOSEAREA())
PORTA ->(DBCLOSEAREA())
PLANO ->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)

FUNCTION FRELADIA(nMode,nCol)
LOCAL NRET:=1
IF ! EMPTY(TMP->COL2)
   @ 21,1 SAY "CHEQUE : "+TMP->CHEQUE_V
   @ 22,1 SAY "PLANO  : "+IF(PLANO->(DBSEEK(TMP->CODPLA_V)),PLANO->NOME_V,SPACE(15))
   @ 21,24 SAY "Desconto : "+TRANSFORM(TMP->DESCONTO_V,"@R 999.99")
   @ 21,42 SAY "Deducoes : "+TRANSFORM(TMP->DEDUCAO_V,"@R 999.99")
   @ 21,60 SAY "Protesto: "+TMP->PROTESTO_V
   @ 22,24 SAY "Multa    : "+TRANSFORM(TMP->MULTA_V,"@R 999.99")
   @ 22,42 SAY "Acrescimo: "+TRANSFORM(TMP->ACRES_V,"@R 999.99")
   @ 22,60 SAY "Recebido: "+TRANSFORM(TMP->VALOR_V,"@R 99,999.99")
ELSE
   SCROLL(21,1,22,78)
ENDIF
IF LASTKEY()=27
   NRET:=0
ENDIF
RETURN NRET