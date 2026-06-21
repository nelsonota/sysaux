FUNCTION RPAGREC(OPCAO)
LOCAL TELA,QTD,X,MDATVEN,TELA1,OP,CONT,LIN,INTER,GETLIST:={},MDOCEXT,MDOCINT
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

*** VARIAVEIS P/ CADASTRO DE CONTAS A PAGAR/RECEBER
MEMVAR PAGREC,CODIGO,CLIFOR,DOCEXT,DESC,DOCINT,DATVEN,VALOR,CODPLA,DATEXT,DATINT
DO CASE
   CASE OPCAO="P"
      IF LEFT(PAGREC->CODIGO_V,1)#OPCAO
         AVISO("Este nao ‚ um T¡tulo … Pagar ...")
         RETURN(.F.)
      ENDIF
   CASE OPCAO="R"
      IF LEFT(PAGREC->CODIGO_V,1)#OPCAO
         AVISO("Este nao ‚ um T¡tulo … Receber ...")
         RETURN(.F.)
      ENDIF
ENDCASE
TELA:=SAVESCREEN(0,0,24,80)
INTER  :=0
QTD    :=0
MDATVEN:={,,,,,,,,}
MDOCEXT:={,,,,,,,,}
MDOCINT:={,,,,,,,,}
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   WINDOW(5,10,18,42)
   QTD:=0
   @ 6,12 SAY "Repetir Quantas Vezes    :" GET QTD PICT    "9"
   @ 7,12 SAY "Qual o Intervalo de Dias :" GET INTER PICT "99"
   @ 8,11 TO 8,41
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   TELA1:=SAVESCREEN(0,0,24,80)
   WINDOW(12,12,17,17)
   @ 13,13 PROMPT " -B "
   @ 14,13 PROMPT " /B "
   @ 15,13 PROMPT " -2 "
   @ 16,13 PROMPT " /2 "
   MENU TO OP
   IF LASTKEY()=27
      LOOP
   ENDIF
   RESTSCREEN(0,0,24,80,TELA1)
   X:=1
   LIN:=9
   DO WHILE X<=QTD
      DO CASE
         CASE X=1
            DO CASE
               CASE OP=1
                  CONT:="-B"
               CASE OP=2
                  CONT:="/B"
               CASE OP=3
                  CONT:="-2"
               CASE OP=4
                  CONT:="/2"
            ENDCASE
         CASE X=2
            DO CASE
               CASE OP=1
                  CONT:="-C"
               CASE OP=2
                  CONT:="/C"
               CASE OP=3
                  CONT:="-3"
               CASE OP=4
                  CONT:="/3"
            ENDCASE
         CASE X=3
            DO CASE
               CASE OP=1
                  CONT:="-D"
               CASE OP=2
                  CONT:="/D"
               CASE OP=3
                  CONT:="-4"
               CASE OP=4
                  CONT:="/4"
            ENDCASE
         CASE X=4
            DO CASE
               CASE OP=1
                  CONT:="-E"
               CASE OP=2
                  CONT:="/E"
               CASE OP=3
                  CONT:="-5"
               CASE OP=4
                  CONT:="/5"
            ENDCASE
         CASE X=5
            DO CASE
               CASE OP=1
                  CONT:="-F"
               CASE OP=2
                  CONT:="/F"
               CASE OP=3
                  CONT:="-6"
               CASE OP=4
                  CONT:="/6"
            ENDCASE
         CASE X=6
            DO CASE
               CASE OP=1
                  CONT:="-G"
               CASE OP=2
                  CONT:="/G"
               CASE OP=3
                  CONT:="-7"
               CASE OP=4
                  CONT:="/7"
            ENDCASE
         CASE X=7
            DO CASE
               CASE OP=1
                  CONT:="-H"
               CASE OP=2
                  CONT:="/H"
               CASE OP=3
                  CONT:="-8"
               CASE OP=4
                  CONT:="/8"
            ENDCASE
         CASE X=8
            DO CASE
               CASE OP=1
                  CONT:="-I"
               CASE OP=2
                  CONT:="/I"
               CASE OP=3
                  CONT:="-9"
               CASE OP=4
                  CONT:="/9"
            ENDCASE
         CASE X=9
            DO CASE
               CASE OP=1
                  CONT:="-J"
               CASE OP=2
                  CONT:="/J"
               CASE OP=3
                  CONT:="-10"
               CASE OP=4
                  CONT:="/10"
            ENDCASE
         CASE X=10
            DO CASE
               CASE OP=1
                  CONT:="-K"
               CASE OP=2
                  CONT:="/K"
               CASE OP=3
                  CONT:="-11"
               CASE OP=4
                  CONT:="/11"
            ENDCASE
      ENDCASE
      SETCOLOR(CORTIT)
      DO CASE
         CASE OPCAO="P"
            MDOCEXT[X]:=ALLTRIM(DOCEXT)+CONT
            @ LIN,12 SAY LEFT(MDOCEXT[X],10)
         CASE OPCAO="R"
            MDOCINT[X]:=ALLTRIM(DOCINT)+CONT
            @ LIN,12 SAY LEFT(MDOCINT[X],10)
      ENDCASE
      SETCOLOR(CORTEX)
      IF X>=2
         MDATVEN[X]:=MDATVEN[X-1]+INTER
      ELSE
         MDATVEN[X]:=DATVEN+INTER
      ENDIF
      @ LIN,27 SAY MDATVEN[X]
      X++
      LIN++
   ENDDO
   IF CONFIRMA(20,20,"Confirma Repeti‡ao ?")
      X:=1
      DO WHILE X<=QTD
         IF PAGREC->(ADDREC(5))
            IF CONFIG->(RECLOCK(5))
               CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
               CODIGO:=PAGREC+STRZERO(CONFIG->PAGREC_V,5,0)
               CONFIG->(DBUNLOCK())
            ELSE
               EXIT
            ENDIF
            PAGREC->CODIGO_V:=CODIGO
            PAGREC->CLIFOR_V:=CLIFOR
            IF(OPCAO="P",PAGREC->DOCEXT_V:=MDOCEXT[X],PAGREC->DOCEXT_V:=DOCEXT)
            PAGREC->DATEXT_V:=DATEXT
            PAGREC->DESC_V  :=DESC
            IF(OPCAO="R",PAGREC->DOCINT_V:=MDOCINT[X],PAGREC->DOCINT_V:=DOCINT)
            PAGREC->DATINT_V:=DATINT
            PAGREC->DATVEN_V:=MDATVEN[X]
            PAGREC->VALOR_V :=VALOR
            PAGREC->CODPLA_V:=CODPLA
            PAGREC->NOMSEN_V:=NOMSEN
            PAGREC->(DBUNLOCK())
         ENDIF
         X++
      ENDDO
      EXIT
   ENDIF
ENDDO
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)