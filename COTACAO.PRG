FUNCTION COTACAO()
LOCAL  LIN,TELA,TELA1,LINHA1,COLUNA,TITULOS,MASCARAS,VARIAVEIS,OP,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR ITEM,CLIFOR,VALOR
TELA:=SAVESCREEN()
DBF_COTA()
DBF_ESTOQUE()
DBF_CLIFOR()
WINDOW(21,0,23,15)
WINDOW(0,0,21,79)
@ 22,15 SAY CHR(219)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   ITEM  :=ESTOQUE->CODIGO_V
   CLIFOR:=ESTOQUE->CLIFOR_V
   VALOR :=ESTOQUE->VALVEN_V
   ESTOQUE->(DBSETORDER(1))
   CLIFOR->(DBSETORDER(1))
   @ 1,2 SAY "Item       : " + ITEM +"-"+IF(ESTOQUE->(DBSEEK(ITEM)),ESTOQUE->NOME_V,SPACE(50))
   @ 2,2 SAY "Fornecedor : " + IF(CLIFOR->(DBSEEK(IF(ESTOQUE->(DBSEEK(ITEM)),ESTOQUE->CLIFOR_V,SPACE(6)))),CLIFOR->NOME_V,SPACE(50))
   @ 3,2 SAY "Valor      : " + TRANSFORM(VALOR,"@R 999,999,999.99")
   @ 4,1 TO 4,78
   @ 5,1 SAY PADC("Outros Fornecedores deste Item",78)
   SETCOLOR(CORTIT)
   @ 6,1 SAY PADR(" Fornecedor                                              Valor do Fornecedor",78)
   COTA->(DBSETORDER(2))
   COTA->(DBSEEK(ITEM))
   LIN=7
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 7,1 CLEAR TO 20,78
   DO WHILE LIN<20 .AND. COTA->(!EOF()) .AND. COTA->ITEM_V=ITEM
      @ LIN,2 SAY IF(CLIFOR->(DBSEEK(COTA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))+SPACE(2)+TRANSFORM(COTA->VALOR_V,"@R 999,999,999.99")
      COTA->(DBSKIP())
      LIN++
   ENDDO
   @ 22,1 PROMPT " Busca "
   @ 22,8 PROMPT " Edita "
   MENU TO OP
   DO CASE
      CASE OP=1
         @ 1,15 GET ITEM PICT "@K!" VALID(SEA_ESTOQUE(ITEM))
         READ
         LOOP
      CASE OP=2
         @ 24,0 CLEAR TO 24,79
         @ 24,2 SAY "INS - Incluir  DEL - Exluir  ENTER - em cima do valor, altera."
         TELA1:=SAVESCREEN()
         WINDOW(6,0,21,79)
         DO WHILE .T.
            LINHA1:=CHR(220)
            COLUNA:=CHR(219)
            VARIAVEIS:={"IF(CLIFOR->(DBSEEK(IF(COTA->ITEM_V=ITEM,COTA->CLIFOR_V,SPACE(6)))),CLIFOR->NOME_V,SPACE(50))","IF(COTA->ITEM_V=ITEM,COTA->VALOR_V,SPACE(14))"}
            MASCARAS :={,"@R 999,999,999.99"}
            TITULOS  :={"Fornecedor(es)","Valor"}
            COTA->(DBSETORDER(1))
            COTA->(DBEDIT(7,1,20,78,VARIAVEIS,"DBECOTACAO",MASCARAS,TITULOS,LINHA1,COLUNA))
            EXIT
         ENDDO
         RESTSCREEN(,,,,TELA1)
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
COTA->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,21,79)
RETURN(.T.)


FUNCTION DBECOTACAO(nMode,Col)
LOCAL GETLIST:={}
LOCAL TECLA:=LASTKEY()
LOCAL VALOR:=1
LOCAL VAL:=0
MEMVAR CORDES,CORTEX,CORTIT
MEMVAR ITEM,CLIFOR
DO CASE
   CASE nMode=0
*      @ 9,1 SAY " C¢digo        Descri‡ao            Vl.Unit rio Qtd.         Vl.Total   %ICMS " COLOR CORTIT
   CASE nMode=4
      DO CASE
         CASE TECLA=13
            IF COTA->ITEM_V==ITEM
               IF Col=2
                  IF COTA->(RECLOCK())
                     @ ROW(),COL() GET COTA->VALOR_V PICT "@R 999,999,999.99"
                     READ
                     COTA->(DBUNLOCK())
                  ELSE
                     AVISO("O Sistema nao conseguiu travar o registro...")
                  ENDIF
                  SETCURSOR(0)
               ENDIF
            ELSE
               COTA->(DBSEEK(ITEM))
            ENDIF
         CASE TECLA=27 .OR. TECLA=-1 .OR. TECLA=-4
            VALOR:=0
         CASE TECLA=22
            @ 24,0 CLEAR TO 24,79
            @ 24,2 SAY "Novo Fornecedor : " GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,24,28,"F"))
            READ
            IF LASTKEY()#27
               @ 24,0 CLEAR TO 24,79
               @ 24,2 SAY "Valor : " GET VAL PICT "999,999,999.99" VALID(VAL>0)
               READ
            ENDIF
            IF LASTKEY()#27
               IF CONFIRMA(20,20,"Confirma inclusao de outro Fornecedor deste Item ?")
                  IF COTA->(ADDREC(5))
                     COTA->CLIFOR_V:=CLIFOR
                     COTA->ITEM_V  :=ITEM
                     COTA->VALOR_V :=VAL
                     COTA->(DBUNLOCK())
                  ENDIF
               ENDIF
            ENDIF
            COTA->(DBSEEK(ITEM))
         CASE TECLA=7
            IF COTA->ITEM_V#ITEM
               AVISO("Registro Inv lido ...")
            ELSE
               IF CONFIRMA(20,20,"Confirma Exclusao do Fornecedor deste Item ?")
                  IF COTA->(RECLOCK(5))
                     COTA->(DBDELETE())
                     COTA->(DBUNLOCK())
                  ENDIF
               ENDIF
            ENDIF
            COTA->(DBSEEK(ITEM))
      ENDCASE
ENDCASE
COTA->(DBUNLOCK())
RETURN VALOR