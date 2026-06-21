FUNCTION REESTFOR(VC,TIPO)
LOCAL GETLIST:={},X,TELA,TOTQTD,TOTCUS,TOTVEN
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CLIFOR,LINHA,LINHA2
TELA:=SAVESCREEN(0,0,24,80)
DBF_CONFIG()
DBF_ESTOQUE()
DBF_CLIFOR()
WINDOW(10,3,12,30)
LINHA:={}
LINHA2:={}
DO WHILE .T.
   CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
   CLIFOR->(DBSETORDER(1))
   @ 11,5 SAY "C¢d.Fornecedor :" GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,,,"F"))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   ESTOQUE->(DBSETORDER(3))
   ESTOQUE->(DBSEEK(CLIFOR,.T.))
   IF .NOT. ESTOQUE->CLIFOR_V=CLIFOR
      AVISO("Nenhum registro encontrado...")
      LOOP
   ENDIF
   X:=0
   CLIFOR->(DBSETORDER(1))
   TOTQTD:=0
   TOTCUS:=0
   TOTVEN:=0
   DO WHILE ESTOQUE->CLIFOR_V=CLIFOR .AND. X<=4090
      TOTQTD:=TOTQTD+ESTOQUE->QTD_V
      TOTCUS:=TOTCUS+ESTOQUE->VALCUS_V*ESTOQUE->QTD_V
      TOTVEN:=TOTVEN+ESTOQUE->VALVEN_V*ESTOQUE->QTD_V
      IF TIPO="L"
         AADD(LINHA,ESTOQUE->CODIGO_V+" "+IF(VC="S",LEFT(ESTOQUE->NOME_V,28),ESTOQUE->NOME_V)+" "+ESTOQUE->FABRICAN_V+" "+ESTOQUE->APLICA_V+IF(VC="S"," "+TRANSFORM(ESTOQUE->QTD_V,"@R 999")+" "+TRANSFORM(ESTOQUE->VALCUS_V,"@R 999,999.99")," ")+" "+ESTOQUE->MOEDA_V+"$"+TRANSFORM(ESTOQUE->VALVEN_V,"@R 999,999.99")+IF(VC="S"," "+TRANSFORM(ESTOQUE->VALREV_V,"@R 99,999.99")+" "," ")+LEFT(ESTOQUE->LOCALIZA_V,8))
         AADD(LINHA2,ESTOQUE->CODIGO_V+" "+LEFT(ESTOQUE->NOME_V,35)+" "+ESTOQUE->APLICA_V)
         IF VC="S"
            AADD(LINHA2," Fabricante:"+ESTOQUE->FABRICAN_V+" Custo : "+ESTOQUE->MOEDA_V+"$"+TRANSFORM(ESTOQUE->VALCUS_V,"@R 999,999.99")+" Venda : "+ESTOQUE->MOEDA_V+"$"+TRANSFORM(ESTOQUE->VALVEN_V,"@R 999,999.99"))
         ELSE
            AADD(LINHA2," Fabricante:"+ESTOQUE->FABRICAN_V+" Venda : "+ESTOQUE->MOEDA_V+"$"+TRANSFORM(ESTOQUE->VALVEN_V,"@R 999,999.99"))
         ENDIF
      ELSE
         AADD(LINHA,ESTOQUE->CODIGO_V+" "+LEFT(ESTOQUE->NOME_V,31)+" "+LEFT(ESTOQUE->FABRICAN_V,10)+" "+LEFT(ESTOQUE->APLICA_V,30)+" "+TRANSFORM(ESTOQUE->QTD_V,"@R 99,999.99")+" "+TRANSFORM(ESTOQUE->RESERVA_V,"@R 99,999.99")+" "+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,"@R 99,999.99")+"   "+left(ESTOQUE->LOCALIZA_V,8))
         AADD(LINHA2,ESTOQUE->CODIGO_V+" "+LEFT(ESTOQUE->NOME_V,35)+" "+ESTOQUE->APLICA_V)
         AADD(LINHA2,"        "+"Estoque : "+TRANSFORM(ESTOQUE->QTD_V,"@R 99,999.99")+" "+"Reservado: "+TRANSFORM(ESTOQUE->RESERVA_V,"@R 99,999.99")+" "+"Dispon¡vel:"+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,"@R 99,999.99"))
      ENDIF
      ESTOQUE->(DBSKIP())
      X++
   ENDDO
   IF X>4090
      AVISO("Mem¢ria Insuficiente...")
   ENDIF
   WINDOW(2,0,23,79)
   @ 5,1 TO 5,78
   @ 3,1 SAY PADR(" Relat¢rio de Itens do Fornecedor : "+IF(CLIFOR->(DBSEEK(CLIFOR)),LEFT(CLIFOR->NOME_V,30),SPACE(30)),78) COLOR CORTIT
   @ 4,1 SAY PADR("C¢digo       Descri‡ao                           Aplica‡ao",78) COLOR CORTIT
   @ 21,1 TO 21,78
   IF VC="S"
      @ 22,1 SAY PADR(" "+TRANSFORM(X,"@R 99,999")+" Produtos "+TRANSFORM(TOTQTD,"@R 999,999,999")+" Itens Custo="+TRANSFORM(TOTCUS,"@R 999,999,999.99")+" Venda="+TRANSFORM(TOTVEN,"@R 999,999,999.99"),78) COLOR CORTIT
   ELSE
      @ 22,1 SAY PADR(" "+TRANSFORM(X,"@R 99,999")+" Produtos",78) COLOR CORTIT
   ENDIF
   ACHOICE(6,1,20,78,LINHA2,.T.,"RELACHOFUN")
   AADD(LINHA,REPLICATE("-",80))
   IF VC="S"
      AADD(LINHA," "+TRANSFORM(X,"@R 99,999")+" Produtos "+TRANSFORM(TOTQTD,"@R 999,999,999")+" Itens  Custo="+TRANSFORM(TOTCUS,"@R 999,999,999.99")+" Venda="+TRANSFORM(TOTVEN,"@R 999,999,999.99"))
   ELSE
      AADD(LINHA," "+TRANSFORM(X,"@R 99,999")+" Produtos ")
   ENDIF
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      IF TIPO="L"
         IF VC="S"
            C_IMPREL("Relatorio de Itens no Estoque por Fornecedor","Codigo       Descricao                    Fabricante  Aplicacao                     Qtd      Custo        Venda   Revenda Localiza",52)
         ELSE
            C_IMPREL("Relatorio de Itens no Estoque por Fornecedor","Codigo       Descricao                                          Fabricante  Aplicacao                             Venda Localiza",52)
         ENDIF
      ELSE
         C_IMPREL("Relatorio de Itens no Estoque por Fornecedor","Codigo       Descricao                       Fabricante Aplicacao                         Estoque Reservado Disponivel Local",52)
      ENDIF
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)