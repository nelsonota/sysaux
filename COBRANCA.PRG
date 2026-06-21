FUNCTION COBRANCA()
LOCAL TELA,OP,GETLIST:={},OP1,TELA2
*** VARIAVEIS P/ CADASTRO DE CONTAS A PAGAR/RECEBER
MEMVAR PAGREC,CODIGO,CLIFOR,DOCEXT,DESC,DOCINT,DATVEN,VALOR,CODPLA
MEMVAR DATEXT,DATINT
*** VARIAVEIS DE COBRANCA
MEMVAR BOLETO,CODBANBO,DUPLICA,CODBANDU,COBCHQ,CBCODBAN,COBBANCO,COBAGEN,COBCONTA
TELA:=SAVESCREEN()
WINDOW(15,44,20,56)
DO WHILE .T.
   IF LEFT(PAGREC->CODIGO_V,1)#"R"
      AVISO("Este nao ‚ um t¡tulo … receber...")
      EXIT
   ENDIF
   @ 16,45 PROMPT " Boleto    "
   @ 17,45 PROMPT " Duplicata "
   @ 18,45 PROMPT " Cheque    "
   @ 19,45 PROMPT " Protesto  "
   MENU TO OP
   DO CASE
      CASE OP=1
         TELA2:=SAVESCREEN()
         WINDOW(17,55,19,76)
         @ 18,57 PROMPT "Imprimir"
         @ 18,66 PROMPT "Registrar"
         MENU TO OP1
         RESTSCREEN(,,,,TELA2)
         DO CASE
            CASE OP1=1
               BOLETO()
            CASE OP1=2
               RESTSCREEN(,,,,TELA)
               @ 15,01 CLEAR TO 18,78
               @ 15,02 SAY "Boleto    :"
               @ 15,35 SAY "Banco : "
               @ 15,14 GET BOLETO PICT "@!"
               @ 15,54 GET CODBANBO VALID(COBBANK("B"))
               READ
               IF LASTKEY()=27
                  RESTSCREEN(,,,,TELA2)
                  LOOP
               ENDIF
               IF CONFIRMA(20,20,"Confirma Boleto ?")
                  IF PAGREC->(RECLOCK(5))
                     PAGREC->BOLETO_V  :=BOLETO
                     PAGREC->CODBANBO_V:=CODBANBO
                     PAGREC->(DBUNLOCK())
                     RETURN(.T.)
                  ENDIF
               ENDIF
            OTHERWISE
               LOOP
         ENDCASE
      CASE OP=2
         TELA2:=SAVESCREEN()
         WINDOW(17,55,19,76)
         @ 18,57 PROMPT "Imprimir"
         @ 18,66 PROMPT "Registrar"
         MENU TO OP1
         RESTSCREEN(,,,,TELA2)
         DO CASE
            CASE OP1=1
               DUPLICA()
            CASE OP1=2
               RESTSCREEN(,,,,TELA)
               @ 15,01 CLEAR TO 18,78
               @ 16,02 SAY "Duplicata :"
               @ 16,35 SAY "Banco : "
               @ 16,14 GET DUPLICA PICT "@!"
               @ 16,54 GET CODBANDU VALID(COBBANK("D"))
               READ
               IF LASTKEY()=27
                  RESTSCREEN(,,,,TELA2)
                  LOOP
               ENDIF
               IF CONFIRMA(20,20,"Confirma Boleto ?")
                  IF PAGREC->(RECLOCK(5))
                     PAGREC->DUPLICA_V  :=DUPLICA
                     PAGREC->CODBANDU_V:=CODBANDU
                     PAGREC->(DBUNLOCK())
                     RETURN(.T.)
                  ENDIF
               ENDIF
            OTHERWISE
               LOOP
         ENDCASE
      CASE OP=3
         RESTSCREEN(,,,,TELA)
         @ 15,01 CLEAR TO 18,78
         @ 17,02 SAY "Cheque    :"
         @ 17,21 SAY "Banco   :"
         @ 18,21 SAY "Agˆncia :       Conta Corrente :"
         DO WHILE .T.
            @ 17,14 GET COBCHQ PICT "@!"
            @ 17,31 GET CBCODBAN PICT "@!"
            @ 17,36 GET COBBANCO PICT "@!"
            @ 18,31 GET COBAGEN PICT "@!"
            @ 18,54 GET COBCONTA PICT "@!"
            READ
            IF LASTKEY()=27
               RETURN(.T.)
            ENDIF
            IF CONFIRMA(20,20,"Os dados estao corretos ?")
               PAGREC->(RECLOCK())
               PAGREC->COBCHQ_V  :=COBCHQ
               PAGREC->CBCODBAN_V:=CBCODBAN
               PAGREC->COBBANCO_V:=COBBANCO
               PAGREC->COBAGEN_V :=COBAGEN
               PAGREC->COBCONTA_V:=COBCONTA
               PAGREC->(DBUNLOCK())
               RETURN(.T.)
            ENDIF
         ENDDO
      CASE OP=4
         PAGREC->(RECLOCK())
         IF CONFIRMA(21,34,"Registrar t¡tulo como protestado ?")
            PAGREC->PROTESTO_V:="S"
         ELSE
            PAGREC->PROTESTO_V:=" "
         ENDIF
         PAGREC->(DBUNLOCK())
         EXIT
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(15,44,19,56)
RETURN(.T.)

FUNCTION COBBANK(TIPO)
MEMVAR CODBANBO,CODBANDU
DO CASE
   CASE TIPO="B"
      IF CODBANBO=0
         @ 15,43 SAY SPACE(LEN(BANK->NOME_V))
      ELSE
         BANK->(DBSEEK(CODBANBO))
         DBE_BANK(10,5,20,75)
         @ 15,43 SAY BANK->NOME_V
         CODBANBO:=BANK->CODIGO_V
      ENDIF
   CASE TIPO="D"
      IF CODBANDU=0
         @ 16,43 SAY SPACE(LEN(BANK->NOME_V))
      ELSE
         BANK->(DBSEEK(CODBANDU))
         DBE_BANK(10,5,20,75)
         @ 16,43 SAY BANK->NOME_V
         CODBANDU:=BANK->CODIGO_V
      ENDIF
ENDCASE
RETURN(.T.)