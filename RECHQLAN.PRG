FUNCTION RECHQLAN()
LOCAL GETLIST:={},TELA,X,MOVI,TVALOR,TITULO
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,CODBAN,CHEQUE
LINHA:={}
TELA:=SAVESCREEN(0,0,24,80)
DBF_CONFIG()
DBF_CHEQUE()
DBF_BANK()
DBF_CLIFOR()
WINDOW(10,10,13,29)
CODBAN:=0
CHEQUE:=SPACE(6)
DO WHILE .T.
   @ 11,12 SAY "Banco  :" GET CODBAN PICT "99999" VALID(SEA_BANK(CODBAN))
   @ 12,12 SAY "Cheque :" GET CHEQUE VALID(LASTKEY()=5.OR.SEA_CHEQUE(CHEQUE,CODBAN,))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF EMPTY(CHEQUE->DATEMI_V)
      AVISO("Este Cheque nao Foi Emitido ...")
      LOOP
   ENDIF
   MOVI:=BAN_2MOVI(CHEQUE->DATEMI_V)
   DBF_MOVI(MOVI)
   LOCATE FOR (MOVI)->CHEQUE_V==CHEQUE
   X:=10
   TVALOR:=0
   DO WHILE X<=4090 .AND. (MOVI)->(!EOF())
      IF (MOVI)->CHEQUE_V#CHEQUE
         (MOVI)->(DBSKIP())
         LOOP
      ENDIF
      AADD(LINHA,IF((MOVI) ->FUTVIS_V="F"," Conta "+IF(LEFT((MOVI)->PAGREC_V,1)="P","… Pagar","… Receber")+" Baixada",;
                 IF(LEFT((MOVI)->PAGREC_V,1)="P"," Pagamento"," Recebimento")+" … Vista"))
      AADD(LINHA," ")
      AADD(LINHA," Nome          : "+IF(CLIFOR->(DBSEEK((MOVI) ->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50)))
      AADD(LINHA," Doc.Externo   : "+(MOVI) ->DOCEXT_V)
      AADD(LINHA," Descricao     : "+(MOVI) ->DESC_V)
      AADD(LINHA," Doc.Interno   : "+(MOVI) ->DOCINT_V)
      AADD(LINHA," Vencimento    : "+DTOC((MOVI)->DATVEN_V))
      AADD(LINHA," Data da Baixa : "+DTOC((MOVI)->DATBAI_V))
      AADD(LINHA," Valor         : "+TRANSFORM((MOVI) ->VALOR_V,"@R 999,999,999.99"))
      AADD(LINHA," ")
      AADD(LINHA," ")
      AADD(LINHA," ")
      TVALOR:=TVALOR+(MOVI)->VALOR_V
      (MOVI)->(DBSKIP())
      X=X+10
   ENDDO
   IF X>4090
      AVISO("Mem¢ria Insuficiente...")
   ENDIF
   WINDOW(3,0,22,79)
   SETCOLOR(CORTIT)
   @ 4,1 SAY PADC("Relat¢rio de Lan‡amentos com o Cheque : "+CHEQUE+" do Banco : "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),78)
   IF UPPER(CHEQUE->OBS_V)="CANCELADO"
      TITULO:="   Cancelado"
   ELSE
      IF !EMPTY(CHEQUE->DATBAI_V)
         TITULO:="   Compensado"
      ELSE
         TITULO:="   … Compensar"
      ENDIF
   ENDIF
   @ 21,1 SAY PADR(" Valor Total do Cheque : " + TRANSFORM(TVALOR,"@R 999,999,999.99")+TITULO,78)
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 5,1 TO 5,78
   @ 20,1 TO 20,78
   ACHOICE(6,1,19,78,LINHA,.T.,"RELACHOFUN")
   (MOVI)->(DBCLOSEAREA())
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      AADD(LINHA,REPLICATE("-",78))
      AADD(LINHA," Valor Total do Cheque : " + TRANSFORM(TVALOR,"@R 999,999,999.99")+TITULO)
      IMPREL("Relat¢rio de Lan‡amentos com o Cheque : "+CHEQUE+" do Banco : "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),,48)
   ENDIF
   EXIT
ENDDO
BANK->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)