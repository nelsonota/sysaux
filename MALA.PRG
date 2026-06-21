FUNCTION MALA(OPCAO)
LOCAL  TELA,OP,OPCOES,TELA1
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CLIFOR,MECVEN,CODTRAN,CONT,LISTA,GETLIST,OPCAO1
GETLIST:={}
TELA:=SAVESCREEN()
CONT:=.T.
WINDOW(3,0,24,79)
DO CASE
   CASE OPCAO="CLI" .OR. OPCAO="FOR" .OR. OPCAO="EVE"
      DBF_CLIFOR()
      OPCAO1:="CLIFOR"
   CASE OPCAO="TEC" .OR. OPCAO="VEN"
      DBF_MECVEN()
      OPCAO1:="MECVEN"
   CASE OPCAO="TRA"
      DBF_TRANSP()
      OPCAO1:="TRANSP"
ENDCASE
DO WHILE .T.
   LISTA:={}
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 4,02 PROMPT " Parcial "
   @ 4,11 PROMPT " Geral "
   @ 5,1 TO 5,78
   CONT:=.T.
   MENU TO OP
   DO CASE
      CASE OP=1
         @ 6,2 SAY "C¢digo Nome"
         @ 7,1 TO 7,78
         SETCOLOR(CORDES)
         @ 8,2 CLEAR TO 23,7
         @ 8,9 CLEAR TO 23,77
         DO WHILE .T.
            IF CONT=.F.
               EXIT
            ENDIF
            SETCOLOR(CORDES)
            @ 8,2 CLEAR TO 8,7
            @ 8,9 CLEAR TO 8,77
            SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
            DO CASE
               CASE OPCAO="CLI" .OR. OPCAO="FOR" .OR. OPCAO="EVE"
                  CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
                  @ 8,2 GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,,,IF(OPCAO="CLI","C",IF(OPCAO="FOR","F","E"))).AND.MALA1("CLIFOR"))
               CASE OPCAO="TEC" .OR. OPCAO="VEN"
                  MECVEN:=SPACE(LEN(MECVEN->CODIGO_V))
                  @ 8,2 GET MECVEN VALID(SEA_MECVEN(MECVEN,,,IF(OPCAO="TEC","M","V")).AND.MALA1("MECVEN"))
               CASE OPCAO="TRA"
                  CODTRAN:=0
                  @ 8,2 GET CODTRAN VALID(SEA_CODTRAN(CODTRAN).AND.MALA1("TRANSP"))
            ENDCASE
            READ
            IF CONT=.F.
               EXIT
            ENDIF
            IF LASTKEY()=27
               IF CONFIRMA(20,20,"Deseja realmente cancelar a opera‡ao ?")
                  EXIT
               ELSE
                  LOOP
               ENDIF
            ENDIF
            IF CONFIRMA(20,20,"Confirma sele‡ao ?")
               DO CASE
                  CASE OPCAO="CLI" .OR. OPCAO="FOR" .OR. OPCAO="EVE"
                     AADD(LISTA,CLIFOR)
                  CASE OPCAO="TEC" .OR. OPCAO="VEN"
                     AADD(LISTA,MECVEN)
                  CASE OPCAO="TRA"
                     AADD(LISTA,CODTRAN)
               ENDCASE
               TELA1:=SAVESCREEN(8,2,22,78)
               RESTSCREEN(9,2,23,78,TELA1)
               SET KEY -1 TO FINALMALA()
            ENDIF
         ENDDO
      CASE OP=2
         AVISO("Op‡ao Inativa...")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
DO CASE
   CASE OPCAO="CLI" .OR. OPCAO="FOR" .OR. OPCAO="EVE"
      CLIFOR->(DBCLOSEAREA())
   CASE OPCAO="TEC" .OR. OPCAO="VEN"
      MECVEN->(DBCLOSEAREA())
   CASE OPCAO="TRA"
      TRANSP->(DBCLOSEAREA())
ENDCASE
RESTSCREEN(,,,,TELA)
CLOSEWIN(3,0,24,79)
RETURN(.T.)

FUNCTION MALA1(OPCAO)
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
DO CASE
   CASE OPCAO="CLIFOR"
      @ 8,9 SAY CLIFOR->NOME_V COLOR CORDES
   CASE OPCAO="MECVEN"
      @ 8,9 SAY MECVEN->NOME_V COLOR CORDES
   CASE OPCAO="TRANSP"
      @ 8,9 SAY TRANSP->NOME_V COLOR CORDES
ENDCASE
RETURN(.T.)

FUNCTION FINALMALA()
LOCAL  CODIGOS,X,QTD,L
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CONT,LISTA,GETLIST,OPCAO1
CLEAR GETS
DBF_MALA()
DO WHILE .T.
   DBE_MALA(5,5,10,74)
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF ! CONFIRMA(20,20,"Confirma Impressao no Modelo "+MALA->MODELO_V+" ?")
      LOOP
   ENDIF
   LigaImpressora()
   X:=1
   QTD:=1
   AADD(LISTA,)
   DO WHILE .T.
      IF LISTA[X]=(NIL)
         EXIT
      ENDIF
      CODIGOS:={}
      DO WHILE QTD<=MALA->QTD_V
         AADD(CODIGOS,LISTA[X])
         X++
         IF LISTA[X]=(NIL)
            EXIT
         ENDIF
         QTD++
      ENDDO
      L:=MALA->LINHA_V
      AADD(CODIGOS,)
      QTD:=1
      @ PROW(),0 SAY SPACE(0)
      @ PROW(),0 SAY SPACE(0)
      DO WHILE .T.
         IF CODIGOS[QTD]=(NIL)
            QTD:=1
            EXIT
         ENDIF
         DO CASE
            CASE OPCAO1="CLIFOR"
               IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                  @ PROW(),PCOL() SAY LEFT(CLIFOR->NOME_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
               ENDIF
            CASE OPCAO1="MECVEN"
               IF MECVEN->(DBSEEK(CODIGOS[QTD]))
                  @ PROW(),PCOL() SAY LEFT(MECVEN->NOME_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
               ENDIF
            CASE OPCAO1="TRANSP"
               IF TRANSP->(DBSEEK(CODIGOS[QTD]))
                  @ PROW(),PCOL() SAY LEFT(TRANSP->NOME_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
               ENDIF
         ENDCASE
         @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
         QTD++
      ENDDO
      L:=L-1
      IF MALA->LINHA_V>=2
         @ PROW()+1,0 SAY SPACE(0)
         DO WHILE .T.
            IF CODIGOS[QTD]=(NIL)
               QTD:=1
               EXIT
            ENDIF
            DO CASE
               CASE OPCAO1="CLIFOR"
                  IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                     @ PROW(),PCOL() SAY LEFT(padr(alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),50)+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                  ENDIF
               CASE OPCAO1="MECVEN"
                  IF MECVEN->(DBSEEK(CODIGOS[QTD]))
                     @ PROW(),PCOL() SAY LEFT(padr(alltrim(MECVEN->ENDERECO_V)+" "+alltrim(mecven->numero_v)+" "+alltrim(mecven->complem_v),50)+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                  ENDIF
               CASE OPCAO1="TRANSP"
                  IF TRANSP->(DBSEEK(CODIGOS[QTD]))
                     @ PROW(),PCOL() SAY LEFT(padr(alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),50)+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                  ENDIF
            ENDCASE
            @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
            QTD++
         ENDDO
         L:=L-1
         IF MALA->LINHA_V>=3
            @ PROW()+1,0 SAY SPACE(0)
            DO WHILE .T.
               IF CODIGOS[QTD]=(NIL)
                  QTD:=1
                  EXIT
               ENDIF
               DO CASE
                  CASE OPCAO1="CLIFOR"
                     IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                        @ PROW(),PCOL() SAY LEFT(CLIFOR->BAIRRO_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                     ENDIF
                  CASE OPCAO1="MECVEN"
                     IF MECVEN->(DBSEEK(CODIGOS[QTD]))
                        @ PROW(),PCOL() SAY LEFT(MECVEN->BAIRRO_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                     ENDIF
                  CASE OPCAO1="TRANSP"
                     IF TRANSP->(DBSEEK(CODIGOS[QTD]))
                        @ PROW(),PCOL() SAY LEFT(TRANSP->BAIRRO_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                     ENDIF
               ENDCASE
               @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
               QTD++
            ENDDO
            L:=L-1
            IF MALA->LINHA_V>=4
               @ PROW()+1,0 SAY SPACE(0)
               DO WHILE .T.
                  IF CODIGOS[QTD]=(NIL)
                     QTD:=1
                     EXIT
                  ENDIF
                  DO CASE
                     CASE OPCAO1="CLIFOR"
                        IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                           @ PROW(),PCOL() SAY LEFT(CLIFOR->CIDADE_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V-3)+" "+CLIFOR->ESTADO_V
                        ENDIF
                     CASE OPCAO1="MECVEN"
                        IF MECVEN->(DBSEEK(CODIGOS[QTD]))
                           @ PROW(),PCOL() SAY LEFT(MECVEN->CIDADE_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V-3)+" "+MECVEN->ESTADO_V
                        ENDIF
                     CASE OPCAO1="TRANSP"
                        IF TRANSP->(DBSEEK(CODIGOS[QTD]))
                           @ PROW(),PCOL() SAY LEFT(TRANSP->CIDADE_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V-3)+" "+TRANSP->ESTADO_V
                        ENDIF
                  ENDCASE
                  @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
                  QTD++
               ENDDO
               L:=L-1
               IF MALA->LINHA_V>=5
                  @ PROW()+1,0 SAY SPACE(0)
                  DO WHILE .T.
                     IF CODIGOS[QTD]=(NIL)
                        QTD:=1
                        EXIT
                     ENDIF
                     DO CASE
                        CASE OPCAO1="CLIFOR"
                           IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                              @ PROW(),PCOL() SAY LEFT(TRANSFORM(CLIFOR->CEP_V,"@R 99999-999")+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                           ENDIF
                        CASE OPCAO1="MECVEN"
                           IF MECVEN->(DBSEEK(CODIGOS[QTD]))
                              @ PROW(),PCOL() SAY LEFT(TRANSFORM(MECVEN->CEP_V,"@R 99999-999")+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                           ENDIF
                        CASE OPCAO1="TRANSP"
                           IF TRANSP->(DBSEEK(CODIGOS[QTD]))
                              @ PROW(),PCOL() SAY LEFT(TRANSFORM(TRANSP->CEP_V,"@R 99999-999")+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                           ENDIF
                     ENDCASE
                     @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
                     QTD++
                  ENDDO
                  L:=L-1
                  IF MALA->LINHA_V>=6
                     @ PROW()+1,0 SAY SPACE(0)
                     DO WHILE .T.
                        IF CODIGOS[QTD]=(NIL)
                           QTD:=1
                           EXIT
                        ENDIF
                        DO CASE
                           CASE OPCAO1="CLIFOR"
                              IF CLIFOR->(DBSEEK(CODIGOS[QTD]))
                                 @ PROW(),PCOL() SAY LEFT("A/C "+CLIFOR->CONTATO_V+SPACE(MALA->COLUNA_V),MALA->COLUNA_V)
                              ENDIF
                        ENDCASE
                        @ PROW(),PCOL() SAY SPACE(MALA->INTCOL_V)
                        QTD++
                     ENDDO
                     L:=L-1
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      @ PROW()+1+MALA->INTLIN_V+L,0 SAY SPACE(0)
   ENDDO
   CONT:=.F.
   EXIT
ENDDO
SET KEY -1 TO
SET PRINTER TO
SET DEVICE TO SCREEN
MALA->(DBCLOSEAREA())
RETURN(.T.)