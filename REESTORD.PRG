FUNCTION REESTORD(OPCAO,VC,TIPO)
LOCAL  TELA,TITULO,VARIAVEIS,MASCARAS,TITULOS,LINHA1,COLUNA,Y,TOTQTD,TOTCUS,TOTVEN,PORT
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
TELA:=SAVESCREEN()
DBF_ESTOQUE()
DBF_CLIFOR()
DBF_CONFIG()
DO WHILE .T.
   DO CASE
      CASE OPCAO="A"
         ESTOQUE->(DBSETORDER(2))
         TITULO:="Alfabetica"
      CASE OPCAO="C"
         ESTOQUE->(DBSETORDER(1))
         TITULO:="de Codigos"
   ENDCASE
   LINHA1:=CHR(220)
   COLUNA:=CHR(219)
   CLIFOR->(DBSETORDER(1))
   VARIAVEIS:={"CODIGO_V","NOME_V",;
   "IF(CLIFOR->(DBSEEK(ESTOQUE->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))",;
   "VALCUS_V","QTD_V","VALVEN_V","VALVEN_V-(VALVEN_V*(DESCREV_V/100))"}

   MASCARAS :={,,,,"@R 999,999,999.99","@R 999,999,999.99","@R 999,999,999.99","@R 999,999,999.99"}
   TITULOS  :={"C¢digo","Descri‡ao","Fornecedor","Valor de Compra",;
   "Qtd.em Estoque","Valor de Venda","Valor para Revenda"}
   WINDOW(5,0,20,79)
   ESTOQUE->(DBEDIT(6,1,19,78,VARIAVEIS,,MASCARAS,TITULOS,LINHA1,COLUNA))
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      PORT:=""
      LigaImpressora()
      ESTOQUE->(DBGOTOP())
      IF TIPO="L"
         IF VC="S"
            C_CABECA("Relatorio de Itens no Estoque Geral","Codigo       Descricao                    Fabricante  Aplicacao                     Qtd      Custo        Venda   Revenda Localiza",@PORT)
         ELSE
            C_CABECA("Relatorio de Itens no Estoque Geral","Codigo       Descricao                                          Aplicacao                      Fabricante         Venda Localiza",@PORT)
         ENDIF
      ELSE
         C_CABECA("Relatorio de Itens no Estoque por Iniciais","Codigo       Descricao                                          Aplicacao                      Estoque   Reservado Disponivel Local",@PORT)
      ENDIF
      @ PROW(),1 SAY COMPON
      TOTQTD:=0
      TOTCUS:=0
      TOTVEN:=0
      Y:=0
      DO WHILE ESTOQUE->(.NOT. EOF()) .AND. LASTKEY()#27
         IF TIPO="L"
            @ PROW()+1,1 SAY ESTOQUE->CODIGO_V+" "+IF(VC="S",LEFT(ESTOQUE->NOME_V,28),ESTOQUE->NOME_V)+" "+ESTOQUE->FABRICAN_V+" "+ESTOQUE->APLICA_V+IF(VC="S"," "+TRANSFORM(ESTOQUE->QTD_V,"@R 999")+" "+TRANSFORM(ESTOQUE->VALCUS_V,"@R 999,999.99")," ")+" "+ESTOQUE->MOEDA_V+"$"+TRANSFORM(ESTOQUE->VALVEN_V,"@R 999,999.99")+IF(VC="S"," "+TRANSFORM(ESTOQUE->VALREV_V,"@R 99,999.99")+" "," ")+LEFT(ESTOQUE->LOCALIZA_V,8)
         ELSE
            @ PROW()+1,1 SAY ESTOQUE->CODIGO_V+" "+LEFT(ESTOQUE->NOME_V,31)+" "+LEFT(ESTOQUE->FABRICAN_V,10)+" "+left(ESTOQUE->APLICA_V,30)+" "+TRANSFORM(ESTOQUE->QTD_V,"@R 99,999.99")+" "+TRANSFORM(ESTOQUE->RESERVA_V,"@R 99,999.99")+" "+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,"@R 99,999.99")+"   "+left(ESTOQUE->LOCALIZA_V,8)
         ENDIF
         Y++
         TOTQTD:=TOTQTD+ESTOQUE->QTD_V
         TOTCUS:=TOTCUS+ESTOQUE->VALCUS_V*ESTOQUE->QTD_V
         TOTVEN:=TOTVEN+ESTOQUE->VALVEN_V*ESTOQUE->QTD_V
         ESTOQUE->(DBSKIP())
         IF PROW()=60
            INKEY(.5)
            EJECT
            IF TIPO="L"
               IF VC="S"
                  C_CABECA("Relatorio de Itens do Estoque por Ordem "+TITULO,"Codigo       Descricao                    Fabricante  Aplicacao                     Qtd      Custo        Venda   Revenda Localiza",@PORT)
               ELSE
                  C_CABECA("Relatorio de Itens do Estoque por Ordem "+TITULO,"Codigo       Descricao                                          Fabricante  Aplicacao                             Venda Localiza",@PORT)
               ENDIF
            ELSE
               C_CABECA("Relatorio de Itens do Estoque por Ordem "+TITULO,"Codigo       Descricao                       Fabricante Aplicacao                         Estoque Reservado Disponivel Local",@PORT)
            ENDIF
            @ PROW(),1 SAY COMPON
         ENDIF
      ENDDO
      @ PROW(),1 SAY NORMAL
      @ PROW()+1,1 SAY REPLICATE("-",79)
      IF VC="S"
         @ PROW()+1,1 SAY PADR(" "+TRANSFORM(Y,"@R 99,999")+" Produtos "+TRANSFORM(TOTQTD,"@R 999,999,999")+" Itens Custo="+TRANSFORM(TOTCUS,"@R 999,999,999.99")+" Venda="+TRANSFORM(TOTVEN,"@R 999,999,999.99"),78) COLOR CORTIT
      ELSE
         @ PROW()+1,1 SAY PADR(" "+TRANSFORM(Y,"@R 99,999")+" Produtos",78) COLOR CORTIT
      ENDIF
      @ PROW()+1,1 SAY REPLICATE("-",79)
      EJECT
      SET PRINTER TO
      SET DEVICE TO SCREEN
      EXIT
   ELSE
      EXIT
   ENDIF
ENDDO
ESTOQUE->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)