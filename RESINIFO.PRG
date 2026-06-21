FUNCTION RESINIFO(VC,TIPO)
LOCAL TELA,GETLIST:={},NOME,X,Y,TOTQTD,TOTCUS,TOTVEN
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA,CLIFOR,LINHA2
TELA:=SAVESCREEN(0,0,24,80)
DBF_CONFIG()
DBF_ESTOQUE()
DBF_CLIFOR()
NOME:=SPACE(LEN(ESTOQUE->NOME_V))
CLIFOR:=SPACE(LEN(CLIFOR->CODIGO_V))
WINDOW(9,10,12,75)
Y:=0
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 10,12 SAY "C¢d.Fornecedor :" GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,,,"F"))
   @ 11,12 SAY "Iniciais :" GET NOME PICT "@!" VALID(.NOT. EMPTY(NOME))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF LEN(ALLTRIM(NOME))=1
      AVISO(" necess rio ter pelo menos 2 letras ...")
      LOOP
   ENDIF
   ESTOQUE->(DBSETORDER(2))
   ESTOQUE->(DBSEEK(NOME,.T.))
   X:=LEN(ALLTRIM(NOME))
   LINHA:={}
   LINHA2:={}
   CLIFOR->(DBSETORDER(1))
   TOTQTD:=0
   TOTCUS:=0
   TOTVEN:=0
   DO WHILE LEFT(ESTOQUE->NOME_V,X)=ALLTRIM(NOME) .AND. Y<=4090
      IF ESTOQUE->CLIFOR_V#CLIFOR
         ESTOQUE->(DBSKIP())
         LOOP
      ENDIF
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
      Y++
   ENDDO
   WINDOW(2,0,23,79)
   IF Y>4090
      AVISO("Mem¢ria Insuficiente...")
   ENDIF
   @ 5,1 TO 5,78
   @ 3,1 SAY PADC("Relat¢rio de Itens por Iniciais do Fornecedor : "+IF(CLIFOR->(DBSEEK(CLIFOR)),LEFT(CLIFOR->NOME_V,30),SPACE(30)),78) COLOR CORTIT
   @ 4,1 SAY PADR("C¢digo       Descri‡ao                           Aplica‡ao",78) COLOR CORTIT
   @ 21,1 TO 21,78
   IF VC="S"
      @ 22,1 SAY PADR(" "+TRANSFORM(Y,"@R 99,999")+" Produtos "+TRANSFORM(TOTQTD,"@R 999,999,999")+" Itens Custo="+TRANSFORM(TOTCUS,"@R 999,999,999.99")+" Venda="+TRANSFORM(TOTVEN,"@R 999,999,999.99"),78) COLOR CORTIT
   ELSE
      @ 22,1 SAY PADR(" "+TRANSFORM(Y,"@R 99,999")+" Produtos",78) COLOR CORTIT
   ENDIF
   ACHOICE(6,1,20,78,LINHA2,.T.,"RELACHOFUN")
   AADD(LINHA,REPLICATE("-",80))
   IF VC="S"
      AADD(LINHA," "+TRANSFORM(Y,"@R 99,999")+" Produtos "+TRANSFORM(TOTQTD,"@R 999,999,999")+" Itens  Custo="+TRANSFORM(TOTCUS,"@R 999,999,999.99")+" Venda="+TRANSFORM(TOTVEN,"@R 999,999,999.99"))
   ELSE
      AADD(LINHA," "+TRANSFORM(Y,"@R 99,999")+" Produtos ")
   ENDIF
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      IF TIPO="L"
         IF VC="S"
            C_IMPREL("Relatorio de Itens no Estoque por Iniciais","Codigo       Descricao                    Fabricante  Aplicacao                     Qtd      Custo        Venda   Revenda Localiza",52)
         ELSE
            C_IMPREL("Relatorio de Itens no Estoque por Iniciais","Codigo       Descricao                                          Fabricante  Aplicacao                             Venda Localiza",52)
         ENDIF
      ELSE
         C_IMPREL("Relatorio de Itens no Estoque por Iniciais","Codigo       Descricao                       Fabricante Aplicacao                         Estoque Reservado Disponivel Local",52)
      ENDIF
   ENDIF
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)