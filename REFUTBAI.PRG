FUNCTION REFUTBAI()
LOCAL  TELA,TPAGFUT,TRECFUT,INICIO,FIM,MOVI,GETLIST:={},OPCAO,X,OPCAO2,Y
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA
TELA:=SAVESCREEN()
WINDOW(8,10,12,63)
INICIO:=TRABALHO
FIM:=TRABALHO
Y:=0
LINHA:={}
TRECFUT:=0
TPAGFUT:=0
DBF_CONFIG()
DBF_CLIFOR()
DBF_BANK()
DBF_PORTA()
OPCAO:=SPACE(1)
OPCAO2:=SPACE(1)
DO WHILE .T.
   SET CENTURY ON
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 09,12 SAY "(P)agar / (R)eceber / (A)mbas :" GET OPCAO PICT "@!" VALID(OPCAO$"PRA")
   @ 10,12 SAY "(R)esumido   /   (D)etalhado  :" GET OPCAO2 PICT "@!" VALID OPCAO2$"RD"
   @ 11,12 SAY "Data Inicial :" GET INICIO VALID(!EMPTY(INICIO))
   @ 11,39 SAY "Data Final :"   GET FIM     VALID(FIM>=INICIO)
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   SET CENTURY OFF
   IF OPCAO="R" .OR. OPCAO="A"
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Pesquisando Contas … Receber Baixadas",80)
      AADD(LINHA,"Contas … Receber Baixadas")
      AADD(LINHA,REPLICATE("-",40))
      X:=0
      Y:=2
      MOVI:=BAN_2MOVI(INICIO)
      IF ! FILE(MOVI+".DBF")
         DO WHILE X<=12
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
            ELSE
               X++
            ENDIF
         ENDDO
         IF X>12
            AVISO("Nenhum registro encontrado...")
            LOOP
         ENDIF
      ENDIF
      DBF_MOVI(MOVI)
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. X<=12 .AND. Y<=4070
         (MOVI)->(DBSETORDER(3))
         (MOVI)->(DBSEEK(INICIO,.T.))
         DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. (MOVI)->(! EOF()) .AND. Y<4066
            IF (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R"
               IF OPCAO2="D"
                  AADD(LINHA,"Nome       : "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50)))
                  AADD(LINHA,"Descri‡ao  : "+(MOVI)->DESC_V)
                  AADD(LINHA,"Doc.Externo: "+(MOVI)->DOCEXT_V+" Data do Documento : "+DTOC((MOVI)->DATEXT_V))
                  AADD(LINHA,"Doc.Interno: "+(MOVI)->DOCINT_V+" Data do Documento : "+DTOC((MOVI)->DATINT_V))
                  AADD(LINHA,"Boleto     : "+(MOVI)->BOLETO_V+" Banco : "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
                  AADD(LINHA,"Valor Bruto: "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Desconto   : "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Dedu‡oes   : "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Multa      : "+TRANSFORM((MOVI)->MULTA_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Acr‚scimos : "+TRANSFORM((MOVI)->ACRES_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Vl.L¡quido : "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Vencimento : "+DTOC((MOVI)->DATVEN_V)+" Dt.Baixa : "+DTOC((MOVI)->DATBAI_V))
                  AADD(LINHA,"Portador   : "+IF(PORTA->(DBSEEK((MOVI)->CODPORTA_V)),PORTA->NOME_V,SPACE(LEN(PORTA->NOME_V))))
                  AADD(LINHA," ")
                  Y:=Y+13
               ELSE
                  AADD(LINHA," "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,21),SPACE(21))+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->DOCINT_V+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99"))
                  Y++
               ENDIF
               TRECFUT:=TRECFUT+(MOVI)->VALOR_V
            ENDIF
            (MOVI)->(DBSKIP())
         ENDDO

         (MOVI) -> (DBCLOSEAREA())
         X:=0
         DO WHILE X<=12
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
            ELSE
               X++
            ENDIF
         ENDDO
         IF X>12
            EXIT
         ENDIF
         DBF_MOVI(MOVI)
      ENDDO
      IF Y>4070
         AVISO("Mem¢ria Insuficiente...")
      ENDIF
      (MOVI)->(DBCLOSEAREA())
      AADD(LINHA,REPLICATE("-",40))
      AADD(LINHA,"Total : "+TRANSFORM(TRECFUT,"@R 999,999,999.99"))
      AADD(LINHA," ")
      AADD(LINHA," ")
   ENDIF

   IF OPCAO="P" .OR. OPCAO="A"
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Pesquisando Contas … Pagar Baixadas",80)
      AADD(LINHA,"Contas … Pagar Baixadas")
      AADD(LINHA,REPLICATE("-",40))
      Y:=Y+2      
      X:=0
      MOVI:=BAN_2MOVI(INICIO)
      IF ! FILE(MOVI+".DBF")
         DO WHILE X<=12
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
            ELSE
               X++
            ENDIF
         ENDDO
         IF X>12
            AVISO("Nenhum registro encontrado...")
            LOOP
         ENDIF
      ENDIF
      DBF_MOVI(MOVI)
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. X<=12 .AND. Y<=4070
         (MOVI)->(DBSETORDER(3))
         (MOVI)->(DBSEEK(INICIO,.T.))
         DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. (MOVI)->(! EOF()) .AND. Y<=4066
            IF (MOVI)->FUTVIS_V="F" .AND. (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P"
               IF OPCAO2="D"
                  AADD(LINHA,"Nome       : "+IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50)))
                  AADD(LINHA,"Descri‡ao  : "+(MOVI)->DESC_V)
                  AADD(LINHA,"Doc.Externo: "+(MOVI)->DOCEXT_V+" Data do Documento : "+DTOC((MOVI)->DATEXT_V))
                  AADD(LINHA,"Doc.Interno: "+(MOVI)->DOCINT_V+" Data do Documento : "+DTOC((MOVI)->DATINT_V))
                  AADD(LINHA,"Cheque     : "+(MOVI)->CHEQUE_V+" Banco : "+IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10)))
                  AADD(LINHA,"Valor Bruto: "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Desconto   : "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Dedu‡oes   : "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Multa      : "+TRANSFORM((MOVI)->MULTA_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Acr‚scimos : "+TRANSFORM((MOVI)->ACRES_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Vl.L¡quido : "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99"))
                  AADD(LINHA,"Vencimento : "+DTOC((MOVI)->DATVEN_V)+" Dt.Baixa : "+DTOC((MOVI)->DATBAI_V))
                  AADD(LINHA," ")
                  Y:=Y+13
               ELSE
                  AADD(LINHA,IF(CLIFOR->(DBSEEK((MOVI)->CLIFOR_V)),LEFT(CLIFOR->NOME_V,21),SPACE(21))+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->DOCINT_V+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999,999.99"))
                  Y++
               ENDIF
               TPAGFUT:=TPAGFUT+(MOVI)->VALOR_V
            ENDIF
            (MOVI)->(DBSKIP())
         ENDDO

         (MOVI) -> (DBCLOSEAREA())
         X:=0
         DO WHILE X<=12
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
            ELSE
               X++
            ENDIF
         ENDDO
         IF Y>4070
            AVISO("Mem¢ria Insuficiente...")
         ENDIF
         IF X>12
            EXIT
         ENDIF
         DBF_MOVI(MOVI)
      ENDDO
      (MOVI)->(DBCLOSEAREA())
      AADD(LINHA,REPLICATE("-",40))
      AADD(LINHA,"Total : "+TRANSFORM(TRECFUT,"@R 999,999,999.99"))
   ENDIF

   WINDOW(0,0,24,79)
   SETCOLOR(CORTEX)
   @ IF(OPCAO2="D",2,3),1 TO IF(OPCAO2="D",2,3),78
   @ 22,1 TO 22,78
   SETCOLOR(CORTIT)
   @ 1,1 SAY PADC("Relat¢rio de Contas Baixadas no Per¡odo de "+DTOC(INICIO)+" … "+DTOC(FIM),78)
   IF OPCAO2="R"
      @ 2,1 SAY " Nome                   Doc.Ext.  Doc.Int.   Vencto.  Baixa             Valor " COLOR CORTIT
   ENDIF
   @ 23,1 CLEAR TO 23,78
   @ 23,1 SAY "Total Geral       Pagamentos : "+TRANSFORM(TPAGFUT,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECFUT,"@R 999,999,999.99")
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   ACHOICE(IF(OPCAO2="D",3,4),1,21,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      AADD(LINHA,REPLICATE("-",80))
      AADD(LINHA,"Total Geral       Pagamentos : "+TRANSFORM(TPAGFUT,"@R 999,999,999.99") +"  Recebimentos : "+TRANSFORM(TRECFUT,"@R 999,999,999.99"))
      IMPREL("Relatorio de Contas Baixadas no Periodo de "+DTOC(INICIO)+" … "+DTOC(FIM),IF(OPCAO2="D",IF(OPCAO="R","Recebidas",IF(OPCAO="P","Pagas","Recebidas / Pagas"))," Nome                   Doc.Ext.  Doc.Int.   Vencto.  Baixa             Valor "),52)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
BANK  ->(DBCLOSEAREA())
PORTA ->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)