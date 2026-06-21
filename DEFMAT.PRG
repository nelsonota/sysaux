FUNCTION DEFMAT()
LOCAL TELA,GETLIST:={},MASCARAS,VARIAVEIS,TITULOS
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR ITEM,ITEM2
TELA:=SAVESCREEN()
WINDOW(0,0,24,79)
@ 0,1 SAY "Definicao de Materias para Produ‡ao/Remanufaturamento" COLOR CORTIT
DBF_CLIFOR()
DBF_ESTOQUE()
DBF_DEFMAT()
DO WHILE .T.
   @ 2,1 CLEAR TO 22,78
   ITEM:=SPACE(LEN(ESTOQUE->CODIGO_V))
   @ 1,2 SAY "Item :" GET ITEM VALID(SEA_ESTOQUE(ITEM,1,22))
   @ 2,1 TO 2,78
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   @ 3,1 SAY PADC("Materiais utilizados para formar o Item",78) COLOR CORTIT
   @ 23,1 TO 23,78
   @ 24,1 SAY PADR(" INS: Inclui itens    DEL: Exclui itens",78) COLOR CORTIT
   ITEM2:=ITEM
   VARIAVEIS:={"IF(DEFMAT->ITEM_V==ITEM2,DEFMAT->CODIGO_V,SPACE(LEN(DEFMAT->CODIGO_V)))",;
               "IF(DEFMAT->ITEM_V==ITEM2,IF(ESTOQUE->(DBSEEK(DEFMAT->CODIGO_V)),ESTOQUE->NOME_V,SPACE(50)),SPACE(50))",;
               "IF(DEFMAT->ITEM_V==ITEM2,DEFMAT->QTD_V,0)"}
   MASCARAS :={,,"@R 999,999.99"}
   TITULOS  :={"C¢digo","Descri‡ao","Quantidade"}
   DEFMAT->(DBSEEK(ITEM))
   DEFMAT->(DBEDIT(4,1,22,78,VARIAVEIS,"DBEDEFMAT",MASCARAS,TITULOS,CHR(220),CHR(219)))
   LOOP
ENDDO
ESTOQUE->(DBCLOSEAREA())
DEFMAT->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)

FUNCTION DBEDEFMAT(nMode,Col)
LOCAL TELA
LOCAL GETLIST:={},QTD
LOCAL TECLA:=LASTKEY()
LOCAL VALOR:=1
MEMVAR CORDES,CORTEX,CORTIT
MEMVAR ITEM,ITEM2
DO CASE
   CASE nMode=0
*      @ 9,1 SAY " C¢digo        Descri‡ao            Vl.Unit rio Qtd.         Vl.Total   %ICMS " COLOR CORTIT
   CASE nMode=4
      DO CASE
         CASE TECLA=13
            IF DEFMAT->ITEM_V==ITEM2
               SETCURSOR(1)
               IF COL=3
                  DEFMAT->(RECLOCK())
                  @ ROW(),COL() GET DEFMAT->QTD_V PICT "@R 999,999.99" VALID(DEFMAT->QTD_V>0)
                  READ
                  DEFMAT->(DBUNLOCK())
               ENDIF
               SETCURSOR(0)
            ELSE
               DEFMAT->(DBSEEK(ITEM))
            ENDIF
         CASE TECLA=27
            VALOR:=0
         CASE TECLA=-6
            IF CONFIRMA(20,20,"A impressora est  preparada ?")

            ENDIF
         CASE TECLA=7 // EXCLUI
            IF DEFMAT->ITEM_V==ITEM2
               DEFMAT->(RECLOCK())
               DEFMAT->(DBDELETE())
               DEFMAT->(DBUNLOCK())
               DEFMAT->(DBSEEK(ITEM2))
            ENDIF
         CASE TECLA=22 // INCLUI
            TELA:=SAVESCREEN()
            WINDOW(5,1,7,78)
            ITEM:=SPACE(LEN(ESTOQUE->CODIGO_V))
            QTD:=0
            @ 6,3 GET ITEM VALID(SEA_ESTOQUE(ITEM,6,16))
            @ 6,67 GET QTD PICT "@R 999,999.99" VALID(QTD>0)
            READ
            RESTSCREEN(,,,,TELA)
            IF LASTKEY()=27
               RETURN VALOR
            ENDIF
            DEFMAT->(DBAPPEND())
            DEFMAT->ITEM_V:=ITEM2
            DEFMAT->CODIGO_V:=ITEM
            DEFMAT->QTD_V:=QTD
            DEFMAT->(DBUNLOCK())
            DEFMAT->(DBSEEK(ITEM2))
      ENDCASE
ENDCASE
RETURN VALOR

