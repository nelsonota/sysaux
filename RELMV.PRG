FUNCTION RELMV(TIPO)
LOCAL  TELA,X,Y,TITULO
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA
LINHA:={}
TELA:=SAVESCREEN()
DBF_CONFIG()
DBF_MECVEN()
DO WHILE .T.
   MECVEN->(DBSETORDER(2))
   MECVEN->(DBGOTOP())
   X=0
   Y=0
   DO WHILE MECVEN->(.NOT. EOF()) .AND. X<=4090
      IF LEFT(MECVEN->CODIGO_V,1)#TIPO
         MECVEN->(DBSKIP())
         LOOP
      ENDIF
      Y++
      X=X+15
      AADD(LINHA,"C¢digo   : " + MECVEN->CODIGO_V)
      AADD(LINHA,"Nome     : " + MECVEN->NOME_V)
      AADD(LINHA,"Endere‡o : " + MECVEN->ENDERECO_V)
      AADD(LINHA,"Bairro   : " + MECVEN->BAIRRO_V)
      AADD(LINHA,"Cidade   : " + MECVEN->CIDADE_V+"  Estado : "   + MECVEN->ESTADO_V+"  C.E.P.: "    + TRANSFORM(MECVEN->CEP_V,"@R 99999-999"))
      AADD(LINHA,"CGC / CPF: " + MECVEN->CGCCPF_V+"  RG/I.Est.: " + MECVEN->RGINSEST_V)
      AADD(LINHA,"Telefone1: " + TRANSFORM(MECVEN->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(MECVEN->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(MECVEN->FAX_V,"@R (#999) ##99-9999"))
      AADD(LINHA,"Contato  : " + MECVEN->CONTATO_V)
      AADD(LINHA," ")
      MECVEN->(DBSKIP())
   ENDDO
   WINDOW(5,0,20,79)
   SETCOLOR(CORTIT)
   DO CASE
      CASE TIPO="M"
         TITULO="Mecanicos"
      CASE TIPO="V"
         TITULO="Vendedores"
   ENDCASE
   @ 6,1 SAY PADC("Relat¢rio de "+TITULO,78)
   @ 19,1 SAY PADR(" Total de "+TITULO+" Cadastrados : " + TRANSFORM(Y,"@R 999,999"),78)
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 7,1 TO 7,78
   @ 18,1 TO 18,78
   ACHOICE(8,1,17,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      DO WHILE ! ISPRINTER() .AND. LASTKEY()#27
         AVISO("Impressora Desligada ou Nao Conectada ...")
      ENDDO
      IF LASTKEY()=27
         EXIT
      ENDIF
      CABECA("Relat¢rio de "+TITULO)
      MECVEN->(DBGOTOP())
      X=0
      Y=0
      DO WHILE MECVEN->(.NOT. EOF())
         IF LEFT(MECVEN->CODIGO_V,1)#TIPO
            MECVEN->(DBSKIP())
            LOOP
         ENDIF
         X++
         Y++
         @ PROW()+2,2 SAY "C¢digo   : " + MECVEN->CODIGO_V
         @ PROW()+1,2 SAY "Nome     : " + MECVEN->NOME_V
         @ PROW()+1,2 SAY "Endere‡o : " + MECVEN->ENDERECO_V
         @ PROW()+1,2 SAY "Bairro   : " + MECVEN->BAIRRO_V
         @ PROW()+1,2 SAY "Cidade   : " + MECVEN->CIDADE_V+"  Estado : "   + MECVEN->ESTADO_V+"  C.E.P.: "    + TRANSFORM(MECVEN->CEP_V,"@R 99999-999")
         @ PROW()+1,2 SAY "CGC / CPF: " + MECVEN->CGCCPF_V+"  RG/I.Est.: " + MECVEN->RGINSEST_V
         @ PROW()+1,2 SAY "Telefone1: " + TRANSFORM(MECVEN->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(MECVEN->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(MECVEN->FAX_V,"@R (#999) ##99-9999")
         @ PROW()+1,2 SAY "Contato  : " + MECVEN->CONTATO_V
         IF X=4
            X=0
            EJECT
            CABECA("Relat¢rio de "+TITULO)
         ENDIF
         MECVEN->(DBSKIP())
      ENDDO
      @ PROW()+1,1 SAY REPLICATE("-",78)
      @ PROW()+1,1 SAY " Total de "+TITULO+" Cadastrados : " + TRANSFORM(Y,"@R 999,999")
      EJECT
      SET PRINTER TO
      SET DEVICE TO SCREEN
   ENDIF
   EXIT
ENDDO
MECVEN->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)