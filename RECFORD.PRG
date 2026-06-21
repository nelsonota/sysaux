FUNCTION RECFORD(OPCAO)
LOCAL  TELA,X,LIN,PORT
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
DBF_CLIFOR()
DBF_CONFIG()
CLIFOR->(DBSETORDER(2))
CLIFOR->(DBSETFILTER({||LEFT(CLIFOR->CODIGO_V,1)=OPCAO},LEFT(CLIFOR->CODIGO_V,1)=OPCAO))
CLIFOR->(DBGOTOP())
TELA:=SAVESCREEN()
WINDOW(1,0,24,79)
@ 2,1 SAY PADC("Relat¢rio de "+IF(OPCAO="C","Clientes",IF(OPCAO="F","Fornecedores","Eventos"))+" por Ordem Alfab‚tica",78) COLOR CORTIT
@ 3,1 TO 3,78
@ 22,1 TO 22,78
@ 23,1 SAY PADC("Home=Primeiro Registro  PgDown=Pr¢xima Tela  PgUp=Tela Anterior  End=éltimo Registro",78) COLOR CORTIT
LIN:=4
X:=0
DO WHILE .T.
   IF X=0
      @ LIN,1   SAY "Nome     : "+CLIFOR->NOME_V
      @ LIN+1,1 SAY "Endere‡o : "+CLIFOR->ENDERECO_V
      @ LIN+2,1 SAY "Bairro   : "+CLIFOR->BAIRRO_V+" CEP : "+CLIFOR->CEP_V
      @ LIN+3,1 SAY "Cidade   : "+CLIFOR->CIDADE_V+" Estado : "+CLIFOR->ESTADO_V
      @ LIN+4,1 SAY "Fone 1   : "+CLIFOR->FONE1_V+" Fone2 : "+CLIFOR->FONE2_V+" Fax : "+CLIFOR->FAX_V
      @ LIN+5,1 SAY "Contato  : "+CLIFOR->CONTATO_V
      LIN:=LIN+6
      X=1
   ELSE
      @ LIN,1   SAY PADR("Nome     : "+CLIFOR->NOME_V,78) COLOR CORTIT
      @ LIN+1,1 SAY PADR("Endere‡o : "+CLIFOR->ENDERECO_V,78) COLOR CORTIT
      @ LIN+2,1 SAY PADR("Bairro   : "+CLIFOR->BAIRRO_V+" CEP : "+CLIFOR->CEP_V,78) COLOR CORTIT
      @ LIN+3,1 SAY PADR("Cidade   : "+CLIFOR->CIDADE_V+" Estado : "+CLIFOR->ESTADO_V,78) COLOR CORTIT
      @ LIN+4,1 SAY PADR("Fone 1   : "+CLIFOR->FONE1_V+" Fone2 : "+CLIFOR->FONE2_V+" Fax : "+CLIFOR->FAX_V,78) COLOR CORTIT
      @ LIN+5,1 SAY PADR("Contato  : "+CLIFOR->CONTATO_V,78) COLOR CORTIT
      LIN:=LIN+6
      X=0
   ENDIF
   CLIFOR->(DBSKIP())
   IF LIN>=19 .OR. CLIFOR->(EOF())
      INKEY(0)
      DO CASE
         CASE LASTKEY()=18
            CLIFOR->(DBSKIP(-6))
         CASE LASTKEY()=1
            CLIFOR->(DBGOTOP())
         CASE LASTKEY()=6
            CLIFOR->(DBGOBOTTOM())
         CASE LASTKEY()=27
            EXIT
      ENDCASE
      SETCOLOR(CORTEX)
      @ 4,1 CLEAR TO 21,78
      LIN:=4
   ENDIF
ENDDO
IF CONFIRMA(20,20,"Deseja Imprimir ?")
   CLIFOR->(DBGOTOP())
   CABECA("Relatorio de "+IF(OPCAO="C","Clientes",IF(OPCAO="F","Fornecedores","Eventos"))+" por Ordem Alfabetica")
   LIN:=1
   PORT:=""
   DO WHILE ! CLIFOR->(EOF())
      @ PROW()+2,1   SAY "Nome     : "+CLIFOR->NOME_V
      @ PROW()+1,1 SAY "Endere‡o : "+CLIFOR->ENDERECO_V
      @ PROW()+1,1 SAY "Bairro   : "+CLIFOR->BAIRRO_V+" CEP : "+CLIFOR->CEP_V
      @ PROW()+1,1 SAY "Cidade   : "+CLIFOR->CIDADE_V+" Estado : "+CLIFOR->ESTADO_V
      @ PROW()+1,1 SAY "Fone 1   : "+CLIFOR->FONE1_V+" Fone2 : "+CLIFOR->FONE2_V+" Fax : "+CLIFOR->FAX_V
      @ PROW()+1,1 SAY "Contato  : "+CLIFOR->CONTATO_V
      CLIFOR->(DBSKIP())
      LIN++
      IF LIN>=8
         EJECT
         CABECA("Relatorio de "+IF(OPCAO="C","Clientes",IF(OPCAO="F","Fornecedores","Eventos"))+" por Ordem Alfabetica",@PORT)
         LIN:=1
      ENDIF
   ENDDO
   EJECT
   SET PRINTER TO
   SET DEVICE TO SCREEN
ENDIF
RESTSCREEN(,,,,TELA)
CLOSEWIN(1,0,24,79)
CLIFOR->(DBCLEARFIL())
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
RETURN(.T.)