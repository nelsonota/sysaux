FUNCTION RELCF(TIPO,OPCAO)
LOCAL  TELA,X,Y,TITULO,PROCURA,GETLIST:={},TITULO2
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA
TELA:=SAVESCREEN()
IF OPCAO=(NIL)
   OPCAO:=" "
ENDIF
IF OPCAO="I" .OR. OPCAO="C"
   WINDOW(10,10,12,55)
   PROCURA:=SPACE(50)
   @ 11,12 SAY "Procurar :" GET PROCURA PICT "@S30!"
   READ
ENDIF
LINHA:={}
DBF_CONFIG()
DBF_CLIFOR()
DO WHILE .T.
   IF LASTKEY()=27
      EXIT
   ENDIF
   CLIFOR->(DBSETORDER(2))
   CLIFOR->(DBGOTOP())
   X=0
   Y=0
   DO WHILE CLIFOR->(.NOT. EOF()) .AND. X<=4090
      IF LEFT(CLIFOR->CODIGO_V,1)#TIPO
         CLIFOR->(DBSKIP())
         LOOP
      ENDIF
      DO CASE
         CASE OPCAO="I"
            IF ALLTRIM(CLIFOR->NOME_V)#ALLTRIM(PROCURA)
               CLIFOR->(DBSKIP())
               LOOP
            ENDIF
         CASE OPCAO="C"
            IF .NOT. ALLTRIM(PROCURA)$CLIFOR->NOME_V
               CLIFOR->(DBSKIP())
               LOOP
            ENDIF
      ENDCASE
      Y++
      X=X+15
      AADD(LINHA,"C¢digo   : " + CLIFOR->CODIGO_V)
      AADD(LINHA,"Nome     : " + CLIFOR->NOME_V)
      AADD(LINHA,"Fantasia : " + CLIFOR->FANTASIA_V)
      AADD(LINHA,"Endere‡o : " + CLIFOR->ENDERECO_V)
      AADD(LINHA,"Bairro   : " + CLIFOR->BAIRRO_V)
      AADD(LINHA,"Cidade   : " + CLIFOR->CIDADE_V+"  Estado : "   + CLIFOR->ESTADO_V+"  C.E.P.: "    + TRANSFORM(CLIFOR->CEP_V,"@R 99999-999"))
      AADD(LINHA,"CGC / CPF: " + CLIFOR->CGCCPF_V+"  RG/I.Est.: " + CLIFOR->RGINSEST_V)
      AADD(LINHA,"Telefone1: " + TRANSFORM(CLIFOR->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(CLIFOR->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(CLIFOR->FAX_V,"@R (#999) ##99-9999"))
      AADD(LINHA,"Contato  : " + CLIFOR->CONTATO_V)
      AADD(LINHA," ")
      CLIFOR->(DBSKIP())
   ENDDO
   WINDOW(5,0,20,79)
   SETCOLOR(CORTIT)
   DO CASE
      CASE TIPO="F"
         TITULO="Fornecedores"
      CASE TIPO="E"
         TITULO="Eventos"
      CASE TIPO="C"
         TITULO="Clientes"
   ENDCASE
   DO CASE
      CASE OPCAO=" "
         TITULO2:=" "
      CASE OPCAO="I"
         TITULO2:="com Procura das iniciais: "+ALLTRIM(PROCURA)
      CASE OPCAO="C"
         TITULO2:="com Procura de: "+ALLTRIM(PROCURA)
   ENDCASE
   @ 6,1 SAY PADC("Relat¢rio de "+TITULO+TITULO2,78)
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
      CLIFOR->(DBGOTOP())
      X=0
      Y=0
      DO WHILE CLIFOR->(.NOT. EOF())
         IF LEFT(CLIFOR->CODIGO_V,1)#TIPO
            CLIFOR->(DBSKIP())
            LOOP
         ENDIF
         DO CASE
            CASE OPCAO="I"
               IF ALLTRIM(CLIFOR->NOME_V)#ALLTRIM(PROCURA)
                  CLIFOR->(DBSKIP())
                  LOOP
               ENDIF
            CASE OPCAO="C"
               IF .NOT. ALLTRIM(PROCURA)$CLIFOR->NOME_V
                  CLIFOR->(DBSKIP())
                  LOOP
               ENDIF
         ENDCASE
         X++
         Y++
         @ PROW()+2,2 SAY "C¢digo   : " + CLIFOR->CODIGO_V
         @ PROW()+1,2 SAY "Nome     : " + CLIFOR->NOME_V
         @ PROW()+1,2 SAY "Fantasia : " + CLIFOR->FANTASIA_V
         @ PROW()+1,2 SAY "Endere‡o : " + CLIFOR->ENDERECO_V
         @ PROW()+1,2 SAY "Bairro   : " + CLIFOR->BAIRRO_V
         @ PROW()+1,2 SAY "Cidade   : " + CLIFOR->CIDADE_V+"  Estado : "   + CLIFOR->ESTADO_V+"  C.E.P.: "    + TRANSFORM(CLIFOR->CEP_V,"@R 99999-999")
         @ PROW()+1,2 SAY "CGC / CPF: " + CLIFOR->CGCCPF_V+"  RG/I.Est.: " + CLIFOR->RGINSEST_V
         @ PROW()+1,2 SAY "Telefone1: " + TRANSFORM(CLIFOR->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(CLIFOR->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(CLIFOR->FAX_V,"@R (#999) ##99-9999")
         @ PROW()+1,2 SAY "Contato  : " + CLIFOR->CONTATO_V
         IF X=4
            X=0
            EJECT
            CABECA("Relat¢rio de "+TITULO)
         ENDIF
         CLIFOR->(DBSKIP())
      ENDDO
      @ PROW()+1,1 SAY REPLICATE("-",78)
      @ PROW()+1,1 SAY " Total de "+TITULO+" Cadastrados : " + TRANSFORM(Y,"@R 999,999")
      EJECT
      SET PRINTER TO
      SET DEVICE TO SCREEN
   ENDIF
   EXIT
ENDDO
CLIFOR->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)