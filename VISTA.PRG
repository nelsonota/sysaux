FUNCTION VISTA()
LOCAL OP,TELA,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR CLIFOR,CODPLA,CHEQUE
LOCAL DOCEXT,DESC,DOCINT,VALOR,BANCO,MOVI,PAGREC,DATVEN,DATEXT,DATINT
TELA:=SAVESCREEN(0,0,24,80)
SETCOLOR(CORTIT)
@ 2,0 SAY "Lan‡amentos … Vista"
WINDOW(3,0,15,79)
DBF_CONFIG()
MOVI:=BAN_MOVI()
DBF_MOVI(MOVI)
DBF_PLANO()
DBF_CHEQUE()
DBF_CLIFOR()
DBF_BANK()
DO WHILE .T.
   CLIFOR:=SPACE(LEN( (MOVI) ->CLIFOR_V))
   CHEQUE:=SPACE(LEN( (MOVI) ->CHEQUE_V))
   DOCEXT:=SPACE(LEN((MOVI) ->DOCEXT_V))
   DATEXT:=CTOD("  /  /  ")
   DESC  :=SPACE(LEN((MOVI) ->DESC_V))
   DOCINT:=SPACE(LEN((MOVI) ->DOCINT_V))
   DATINT:=CTOD("  /  /  ")
   CODPLA:=SPACE(LEN((MOVI) ->CODPLA_V))
   VALOR :=0
   DATVEN:=TRABALHO
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 4,1  PROMPT " Contas … Pagar "
   @ 4,17 PROMPT " Contas … Receber "
   @ 5,1 TO 5,78
   MENU TO OP
   IF LASTKEY()=27
      EXIT
   ENDIF
   DO WHILE .T.
      DBE_BANK(10,5,20,75)
      IF LASTKEY()#27
         IF BANK->CODIGO_V=0
            AVISO("Selecione Um Banco")
            LOOP
         ENDIF
      ENDIF
      EXIT
   ENDDO
   IF LASTKEY()=27
      LOOP
   ENDIF
   BANCO:=BANK->CODIGO_V
   @ 4,45 SAY "Lan‡amento Para o Banco "+ BANK->NOME_V
   IF OP=1
      DO WHILE .T.
         CHEQUE->(DBSETORDER(1))
         CHEQUE->(DBSEEK(BANCO))
         CHEQUE->(DBSETORDER(2))
         DBSELECTAREA("CHEQUE","CHEQUE")
         LOCATE FOR CHEQUE->CODBAN_V=BANCO .AND. EMPTY(CHEQUE->DATEMI_V)
         IF FOUND()
            CHEQUE:=CHEQUE->CHEQUE_V
         ELSE
            CHEQUE=SPACE(LEN(CHEQUE->CHEQUE_V))
         ENDIF
         @ 6,2 SAY "Cheque     :" GET CHEQUE PICT "@K!" VALID(CHEQUE->(DBSEEK(CHEQUE)).OR.EMPTY(CHEQUE))
         READ
         IF LASTKEY()=27
            EXIT
         ENDIF
         DBSELECTAREA("CHEQUE","CHEQUE")
         IF ! EMPTY(CHEQUE)
            LOCATE FOR CHEQUE->CODBAN_V=BANCO .AND. CHEQUE->CHEQUE_V=CHEQUE
            IF .NOT. FOUND() .AND. !EMPTY(CHEQUE)
               AVISO("Este Cheque Nao Existe ...")
               LOOP
            ELSE
               IF !EMPTY(CHEQUE)
                  IF UPPER(CHEQUE->OBS_V)="CANCELADO"
                     AVISO("Este Cheque Foi Cancelado")
                     LOOP
                  ENDIF
                  IF !EMPTY(CHEQUE->DATBAI_V)
                     AVISO("Este Cheque J  Foi Baixado ...")
                     LOOP
                  ENDIF
                  IF !EMPTY(CHEQUE->DATEMI_V)
                     AVISO("Este Cheque J  Foi Emitido "+TRANSFORM(CHEQUE->VALOR_V,"@R 999,999,999.99"))
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         EXIT
      ENDDO
      IF LASTKEY()=27
         LOOP
      ENDIF
   ENDIF
   DO CASE
      CASE OP=1
         @ 7,2 SAY "Fornecedor :" GET CLIFOR PICT "@!" VALID(SEA_CLIFOR(CLIFOR,7,23,"F"))
      CASE OP=2
         @ 7,2 SAY "Cliente    :" GET CLIFOR PICT "@!" VALID(SEA_CLIFOR(CLIFOR,7,23,"C"))
   ENDCASE
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   @ 8,02  SAY "Plano de Conta :" GET CODPLA PICT "@K!" VALID(SEA_CODPLA(CODPLA,8,30,IF(OP=1,"-","+")))
   @ 9,02  SAY "Doc.Externo    :" GET DOCEXT PICT "@K!"
   @ 9,30  SAY "Data do Doc.Externo : " GET DATEXT
   @ 10,2  SAY "Descri‡ao      :" GET DESC   PICT "@K!"
   @ 11,2  SAY "Doc.Interno    :" GET DOCINT PICT "@K!"
   @ 11,30 SAY "Data do Doc.Interno : " GET DATINT
   @ 13,2  SAY "Valor          :" GET VALOR PICT"@R 999,999,999.99" VALID(VALOR>0.OR. LASTKEY()=5)
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   IF CONFIRMA(20,10,"Confirma Lan‡amento … Vista ?")
      IF CONFIG->(RECLOCK(5))
         CONFIG->VISTA_V:=CONFIG->VISTA_V+1
         PAGREC:=IF(OP=1,"P","R")+STRZERO(CONFIG->VISTA_V,5,0)
         CONFIG->(DBUNLOCK())
      ELSE
         EXIT
      ENDIF
      IF (MOVI) ->(ADDREC(5))
         (MOVI) ->DATLAN_V :=DATE()
         (MOVI) ->FUTVIS_V :="V"
         (MOVI) ->PAGREC_V :=PAGREC
         (MOVI) ->BANCO_V  :=BANCO
         (MOVI) ->CHEQUE_V :=CHEQUE
         (MOVI) ->CLIFOR_V :=CLIFOR
         (MOVI) ->DOCEXT_V :=DOCEXT
         (MOVI) ->DATEXT_V :=DATEXT
         (MOVI) ->DESC_V   :=DESC
         (MOVI) ->DOCINT_V :=DOCINT
         (MOVI) ->DATINT_V :=DATINT
         (MOVI) ->DATVEN_V :=TRABALHO
         (MOVI) ->DATBAI_V :=TRABALHO
         (MOVI) ->VALOR_V  :=VALOR
         (MOVI) ->VALDOC_V :=VALOR
         (MOVI) ->CODPLA_V :=CODPLA
         (MOVI) ->NOMSEN_V :=NOMSEN
         (MOVI) ->(DBUNLOCK())
      ENDIF
      IF BANK->(RECLOCK(5))
         DO CASE
            CASE OP=1
               IF !EMPTY(CHEQUE)
                  IF CHEQUE->(RECLOCK(5))
                     CHEQUE->CODBAN_V:=BANCO
                     CHEQUE->VALOR_V :=CHEQUE->VALOR_V+VALOR
                     CHEQUE->DATEMI_V:=TRABALHO
                     CHEQUE->(DBUNLOCK())
                  ENDIF
               ELSE
                  BANK->SALDO_V :=BANK->SALDO_V-VALOR
               ENDIF
            CASE OP=2
               BANK->SALDO_V :=BANK->SALDO_V+VALOR
         ENDCASE
         BANK->(DBUNLOCK())
      ENDIF
      SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
      @ 6,1 CLEAR TO 14,78
   ENDIF
ENDDO
CONFIG->(DBCLOSEAREA())
(MOVI) ->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(3,0,15,79)
RETURN(.T.)