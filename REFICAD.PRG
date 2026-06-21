FUNCTION REFICAD(TIPO)
LOCAL TELA,GETLIST:={},TIPO2,VALTOT,ATRASO,ATRASADO,FUTURO,MOVIFIM
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CLIFOR,MOVI,INICIO,FIM,LINHA,LINHA2,DATAPATH
TELA:=SAVESCREEN()
DBF_CLIFOR()
DBF_CONFIG()
DBF_PAGREC()
DBF_PORTA()
DBF_PEDIDO()
WINDOW(09,3,11,76)
SET CENTURY OFF
DO WHILE .T.
   CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
   @ 10,5 SAY IF(TIPO="C","Cliente    :",IF(TIPO="F","Fornecedor :",IF(TIPO="E","Evento     :","Nome       :"))) GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,10,25,TIPO))
   READ
   ATRASO:=0
   ATRASADO:=0
   FUTURO:=0
   IF LASTKEY()=27
      EXIT
   ENDIF
   LINHA:={}
   LINHA2:={}
   IF EMPTY(CLIFOR->DATCAD_V)
      INICIO:=CONFIG->REGISTRO_V
   ELSE
      INICIO:=CLIFOR->DATCAD_V
   ENDIF
   FIM:=DATE()
   MOVI := BAN_2MOVI(INICIO)
   MOVIFIM := BAN_2MOVI(DATE())
   IF ! FILE(DATAPATH + MOVI+".DBF")
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
               ELSEIF RIGHT(MOVI,2)="00"
                  MOVI:="MOVI101"
               ELSE
                  MOVI:="MOVI1"+STRZERO(VAL(RIGHT(MOVI,2))+1,2,0)
               ENDIF
            OTHERWISE
               MOVI:="MOVI"+STRZERO(VAL(SUBSTR(MOVI,5,1))+1,1,0)+RIGHT(MOVI,2)
         ENDCASE
         IF FILE(DATAPATH + MOVI+".DBF")
            EXIT
         ENDIF
      ENDDO
   ENDIF
   IF FILE(DATAPATH + MOVI + ".DBF")
      DBF_MOVI(MOVI)
      (MOVI)->(DBSETORDER(3))
      (MOVI)->(DBSEEK(INICIO,.T.))
      DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM
         (MOVI)->(DBSETORDER(3))
         (MOVI)->(DBSEEK(INICIO,.T.))
         DO WHILE (MOVI)->DATBAI_V>=INICIO .AND. (MOVI)->DATBAI_V<=FIM .AND. (MOVI)->(! EOF())
            IF (MOVI)->CLIFOR_V=CLIFOR
               IF TIPO="C"
                  IF (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="R"
                     AADD(LINHA,LEFT((MOVI)->DESC_V,13)+" "+DTOC((MOVI)->DATEXT_V)+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->DOCINT_V+" "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999.99")+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->DATBAI_V-(MOVI)->DATVEN_V,"@R 999")+IF((MOVI)->PROTESTO_V="S","P","")+" "+TRANSFORM((MOVI)->MULTA_V,"@R 999.99")+" "+TRANSFORM((MOVI)->ACRES_V,"@R 999.99")+" "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999.99")+" "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999.99")+" "+TRANSFORM((MOVI)->VALOR_V,"@R 9,999.99")+" "+IF(PORTA->(DBSETORDER(1),DBSEEK((MOVI)->CODPORTA_V)),PORTA->NOME_V,SPACE(15)))
                     AADD(LINHA2,DTOC((MOVI)->DATEXT_V)+" "+(MOVI)->DOCEXT_V+" "+(MOVI)->DOCINT_V+" "+TRANSFORM((MOVI)->VALDOC_V,"@R 999,999.99")+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->DATBAI_V-(MOVI)->DATVEN_V,"@R 999")+IF((MOVI)->PROTESTO_V="S","Protestado","          "))
                     AADD(LINHA2,"  "+LEFT((MOVI)->DESC_V,25)+" "+TRANSFORM((MOVI)->MULTA_V,"@R 999.99")+" "+TRANSFORM((MOVI)->ACRES_V,"@R 999.99")+" "+TRANSFORM((MOVI)->DESCONTO_V,"@R 999.99")+" "+TRANSFORM((MOVI)->DEDUCAO_V,"@R 999.99")+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999.99")+" "+IF(PORTA->(DBSETORDER(1),DBSEEK((MOVI)->CODPORTA_V)),PORTA->NOME_V,SPACE(15)) )
                     AADD(LINHA2," ")
                  ENDIF
               ELSE
                  IF (MOVI)->(LEFT((MOVI)->PAGREC_V,1))="P"
                     AADD(LINHA,LEFT((MOVI)->DESC_V,13)+" "+DTOC((MOVI)->DATEXT_V)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999.99")+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->DATBAI_V-(MOVI)->DATVEN_V,"@R 999"))
                     AADD(LINHA2,LEFT((MOVI)->DESC_V,13)+" "+DTOC((MOVI)->DATEXT_V)+" "+(MOVI)->DOCINT_V+" "+(MOVI)->DOCEXT_V+" "+TRANSFORM((MOVI)->VALOR_V,"@R 999,999.99")+" "+DTOC((MOVI)->DATVEN_V)+" "+DTOC((MOVI)->DATBAI_V)+" "+TRANSFORM((MOVI)->DATBAI_V-(MOVI)->DATVEN_V,"@R 999"))
                  ENDIF
               ENDIF
               IF ATRASO<((MOVI)->DATBAI_V-(MOVI)->DATVEN_V)
                  ATRASO:=((MOVI)->DATBAI_V-(MOVI)->DATVEN_V)
               ENDIF
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
                     ELSEIF RIGHT(MOVI,2)="00"
                        MOVI:="MOVI101"
                     ELSE
                        MOVI:="MOVI1"+STRZERO(VAL(RIGHT(MOVI,2))+1,2,0)
                     ENDIF
                  OTHERWISE
                     MOVI:="MOVI"+STRZERO(VAL(SUBSTR(MOVI,5,1))+1,1,0)+RIGHT(MOVI,2)
               ENDCASE
               IF FILE(DATAPATH + MOVI+".DBF")
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
   ENDIF
   AADD(LINHA,REPLICATE("=",79))
   AADD(LINHA,"                               Contas Futuras")
   AADD(LINHA,REPLICATE("-",79))
   AADD(LINHA2,REPLICATE("=",79))
   AADD(LINHA2,"                               Contas Futuras")
   AADD(LINHA2,REPLICATE("-",79))
   IF TIPO="C"
      TIPO2:="R"
   ELSE
      TIPO2:="P"
   ENDIF
   PAGREC->(DBGOTOP())
   VALTOT:=0
   DO WHILE PAGREC->(.NOT. EOF())
      IF LEFT(PAGREC->CODIGO_V,1)#TIPO2 .OR. PAGREC->CLIFOR_V#CLIFOR
         PAGREC->(DBSKIP())
         LOOP
      ENDIF
      AADD(LINHA,LEFT(PAGREC->DESC_V,13)+" "+IF(TIPO="C",DTOC(PAGREC->DATEXT_V),DTOC(PAGREC->DATINT_V))+" "+PAGREC->DOCEXT_V+" "+PAGREC->DOCINT_V+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+IF(PAGREC->PROTESTO_V="S","Protestado",""))
      AADD(LINHA2,LEFT(PAGREC->DESC_V,13)+" "+IF(TIPO="C",DTOC(PAGREC->DATEXT_V),DTOC(PAGREC->DATINT_V))+" "+PAGREC->DOCEXT_V+" "+PAGREC->DOCINT_V+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+IF(PAGREC->PROTESTO_V="S","Protestado",""))
      VALTOT:=VALTOT+PAGREC->VALOR_V
      IF PAGREC->DATVEN_V<DATE()
         ATRASADO:=ATRASADO+PAGREC->VALOR_V
      ELSE
         FUTURO:=FUTURO+PAGREC->VALOR_V
      ENDIF
      PAGREC->(DBSKIP())
   ENDDO
   AADD(LINHA,REPLICATE("=",79))
   AADD(LINHA,"Data de Cadastro : "+DTOC(CLIFOR->DATCAD_V))
   AADD(LINHA,"Ultima Compra    : "+DTOC(CLIFOR->DATPED_V)+" Pedido : "+CLIFOR->ULTPED_V+" Valor :"+TRANSFORM(IF(PEDIDO->(DBSETORDER(1),DBSEEK(CLIFOR->ULTPED_V)),PEDIDO->VALTOT_V,CLIFOR->VALPED_V),"@R 999,999.99"))
   AADD(LINHA,"Maior Compra     : "+DTOC(CLIFOR->DATMAI_V)+" Pedido : "+CLIFOR->PEDMAI_V+" Valor :"+TRANSFORM(IF(PEDIDO->(DBSETORDER(1),DBSEEK(CLIFOR->PEDMAI_V)),PEDIDO->VALTOT_V,CLIFOR->VALMAI_V),"@R 999,999.99"))
   AADD(LINHA,"Ultimo Servi‡o   : "+DTOC(CLIFOR->DATTEC_V)+" Ficha  : "+CLIFOR->ULTTEC_V)
   AADD(LINHA,"Maior Atraso     : "+TRANSFORM(ATRASO,"@R 999"))
   AADD(LINHA,"Total Atrasado   : "+TRANSFORM(ATRASADO,"@R 9,999,999.99"))
   AADD(LINHA,"Total a Vencer   : "+TRANSFORM(FUTURO,"@R 9,999,999.99"))
   AADD(LINHA,"Total Geral      : "+TRANSFORM(VALTOT,"@R 9,999,999.99"))

   AADD(LINHA2,REPLICATE("=",79))
   AADD(LINHA2,"Data de Cadastro : "+DTOC(CLIFOR->DATCAD_V))
   AADD(LINHA2,"Ultima Compra    : "+DTOC(CLIFOR->DATPED_V)+" Pedido : "+CLIFOR->ULTPED_V+" Valor :"+TRANSFORM(CLIFOR->VALPED_V,"@R 999,999.99"))
   AADD(LINHA2,"Maior Compra     : "+DTOC(CLIFOR->DATMAI_V)+" Pedido : "+CLIFOR->PEDMAI_V+" Valor :"+TRANSFORM(CLIFOR->VALMAI_V,"@R 999,999.99"))
   AADD(LINHA2,"Ultimo Servi‡o   : "+DTOC(CLIFOR->DATTEC_V)+" Ficha  : "+CLIFOR->ULTTEC_V)
   AADD(LINHA2,"Maior Atraso     : "+TRANSFORM(ATRASO,"@R 999"))
   AADD(LINHA2,"Total Atrasado   : "+TRANSFORM(ATRASADO,"@R 9,999,999.99"))
   AADD(LINHA2,"Total a Vencer   : "+TRANSFORM(FUTURO,"@R 9,999,999.99"))
   AADD(LINHA2,"Total Geral      : "+TRANSFORM(VALTOT,"@R 9,999,999.99"))
   WINDOW(0,0,23,79)
   @ 1,1 SAY PADC("Ficha Cadastral de : "+ALLTRIM(LEFT(CLIFOR->NOME_V,30)),78) COLOR CORTIT
   @ 2,1 SAY PADR("Dt.Ems.  D.Externo  D.Interno  Valor      Vencto.  Baixa  Atraso",78) COLOR CORTIT
   @ 3,1 SAY PADR("  Descri‡ao                  Multa Acres. Descnt Dedcao Vl.Receb Portador",78) COLOR CORTIT
   @ 4,1 TO 4,78
   ACHOICE(5,1,22,78,LINHA2,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      C_IMPREL("Ficha Cadastral de : "+ALLTRIM(LEFT(CLIFOR->NOME_V,30)),"Descri‡ao     Dt.Ems.  D.Interno  D.Externo  Valor      Vencto.  Baixa Atraso  Multa Acresc Descnt Deduca  Vl.Rec. Portador")
   ENDIF
   EXIT
ENDDO
SET CENTURY ON
RESTSCREEN(,,,,TELA)
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PAGREC->(DBCLOSEAREA())
PORTA->(DBCLOSEAREA())
PEDIDO->(DBCLOSEAREA())
RETURN(.T.)