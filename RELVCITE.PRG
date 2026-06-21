FUNCTION RELVCITE(TIPO,TIPO2,TIPO3)
LOCAL  GETLIST:={},TELA,ITEM,QTD,VALOR,VALEST,ITEM2,TOTVAL,TOTEST,TOTQTD
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,CLIFOR,INICIO,FIM
LINHA:={}
IF TIPO3=NIL
   TIPO3:=""
ENDIF
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(IF(TIPO3="C",09,10),10,12,60)
INICIO:=CTOD("  /  /  ")
FIM   :=CTOD("  /  /  ")
DBF_CONFIG()
DBF_PEDIDO()
DBF_2PEDIDO()
DBF_ESTOQUE()
DBF_CLIFOR()
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   IF TIPO3="C"
      CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
      DATCFINIFIN(,IF(TIPO="C","F","C"))
   ELSE
      DATINIFIN()
   ENDIF
   IF LASTKEY()=27
      EXIT
   ENDIF
   PEDIDO2->(DBSETORDER(2))
   PEDIDO2->(DBGOTOP())
   TOTVAL:=0
   TOTEST:=0
   TOTQTD:=0
   DO WHILE PEDIDO2->(!EOF())
      ITEM2:=PEDIDO2->ITEM_V
      ITEM:=" "
      QTD:=0
      VALOR:=0
      VALEST:=0
      DO WHILE PEDIDO2->ITEM_V=ITEM2 .AND. PEDIDO2->(! EOF())
         IF PEDIDO->(DBSEEK(PEDIDO2->CODIGO_V)) .AND. LEFT(PEDIDO2->CODIGO_V,1)=TIPO .AND. EMPTY(PEDIDO->DATCAN_V) .AND. (.NOT. EMPTY(PEDIDO->DATPAG_V))
            IF PEDIDO->TIPO_V=TIPO2 .OR. TIPO2="G"
               IF PEDIDO->DATEMI_V>=INICIO .AND. PEDIDO->DATEMI_V<=FIM .AND. (IF(TIPO3="C",PEDIDO->CLIFOR_V==CLIFOR,.T.))
                  ITEM :=PEDIDO2->ITEM_V
                  QTD  :=QTD+PEDIDO2->QTD_V
                  VALOR:=VALOR+PEDIDO2->QTD_V*PEDIDO2->VALUNI_V
                  TOTQTD:=TOTQTD+PEDIDO2->QTD_V
                  TOTVAL:=TOTVAL+PEDIDO2->QTD_V*PEDIDO2->VALUNI_V
                  IF ESTOQUE->(DBSEEK(ITEM))
                     IF TIPO="V"
                        VALEST:=VALEST+PEDIDO2->QTD_V*ESTOQUE->VALVEN_V
                        TOTEST:=TOTEST+PEDIDO2->QTD_V*ESTOQUE->VALVEN_V
                     ELSE
                        VALEST:=VALEST+PEDIDO2->QTD_V*ESTOQUE->VALCUS_V
                        TOTEST:=TOTEST+PEDIDO2->QTD_V*ESTOQUE->VALCUS_V
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         PEDIDO2->(DBSKIP())
      ENDDO
      IF ITEM#" "
         AADD(LINHA,ITEM+" "+IF(ESTOQUE->(DBSEEK(ITEM)),LEFT(ESTOQUE->NOME_V,32),SPACE(32))+" "+TRANSFORM(QTD,"@R 99,999.99")+" "+TRANSFORM(VALOR,"@R 999,999.99")+" "+TRANSFORM(VALEST,"@R 999,999.99"))
      ENDIF
   ENDDO
   WINDOW(4,0,23,79)
   @ 5,1 SAY PADC("Total de "+IF(TIPO="V","Vendas","Compras")+IF(TIPO2="D"," Direta",IF(TIPO2="P"," por Pedido"," Geral"))+" no Per¡odo de "+DTOC(INICIO)+" … "+DTOC(FIM),78) COLOR CORTIT
   @ 6,1 SAY PADR("C¢digo        Descri‡ao                      Quantidade  Vl."+IF(TIPO="V","Vendido  a Cobrar","Compra     Custo "),78) COLOR CORTIT
   @ 7,1 TO 7,78
   @ 21,1 TO 21,78
   @ 22,1 SAY " Total                                        "+TRANSFORM(TOTQTD,"@R 99,999.99")+" "+TRANSFORM(TOTVAL,"@R 999,999.99")+" "+TRANSFORM(TOTEST,"@R 999,999.99") COLOR CORTIT
   ACHOICE(8,1,20,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja imprimir o relat¢rio ?")
      AADD(LINHA," Total                                        "+TRANSFORM(TOTQTD,"@R 99,999.99")+" "+TRANSFORM(TOTVAL,"@R 999,999.99")+" "+TRANSFORM(TOTEST,"@R 999,999.99"))
      IMPREL("Total de "+IF(TIPO="V","Vendas","Compras")+IF(TIPO2="D"," Direta",IF(TIPO2="P"," por Pedido"," Geral"))+" no Per¡odo de "+DTOC(INICIO)+" … "+DTOC(FIM),"Codigo        Descricao                      Quantidade  Vl."+IF(TIPO="V","Vendido  a Cobrar","Compra     Custo "),50)
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PEDIDO->(DBCLOSEAREA())
PEDIDO2->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)