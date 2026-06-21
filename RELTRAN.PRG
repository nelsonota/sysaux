FUNCTION RELTRAN()
LOCAL  TELA,X,Y,TITULO
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR LINHA
LINHA:={}
TELA:=SAVESCREEN()
DBF_CONFIG()
DBF_TRANSP()
DO WHILE .T.
   TRANSP->(DBSETORDER(2))
   TRANSP->(DBGOTOP())
   X=0
   Y=0
   DO WHILE TRANSP->(.NOT. EOF()) .AND. X<=4090
      Y++
      X=X+8
      AADD(LINHA,"C¢digo   : " + STRZERO(TRANSP->CODIGO_V,5,0))
      AADD(LINHA,"Nome     : " + TRANSP->NOME_V)
      AADD(LINHA,"Endere‡o : " + TRANSP->ENDERECO_V)
      AADD(LINHA,"Cidade   : " + TRANSP->CIDADE_V+"  Estado : "   + TRANSP->ESTADO_V)
      AADD(LINHA,"CGC      : " + TRANSP->CGC_V+"  RG/I.Est.: " + TRANSP->INSEST_V)
      AADD(LINHA,"Telefone1: " + TRANSFORM(TRANSP->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(TRANSP->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(TRANSP->FAX_V,"@R (#999) ##99-9999"))
      AADD(LINHA,"Contato  : " + TRANSP->CONTATO_V)
      AADD(LINHA," ")
      TRANSP->(DBSKIP())
   ENDDO
   WINDOW(5,0,20,79)
   SETCOLOR(CORTIT)
   TITULO="Transportadoras"
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
      TRANSP->(DBGOTOP())
      X=0
      Y=0
      DO WHILE TRANSP->(.NOT. EOF())
         X++
         Y++
         @ PROW()+2,2 SAY "C¢digo   : " + STRZERO(TRANSP->CODIGO_V,5,0)
         @ PROW()+1,2 SAY "Nome     : " + TRANSP->NOME_V
         @ PROW()+1,2 SAY "Endere‡o : " + TRANSP->ENDERECO_V
         @ PROW()+1,2 SAY "Cidade   : " + TRANSP->CIDADE_V+"  Estado : "   + TRANSP->ESTADO_V
         @ PROW()+1,2 SAY "CGC      : " + TRANSP->CGC_V+"  Insc.Est.: " + TRANSP->INSEST_V
         @ PROW()+1,2 SAY "Telefone1: " + TRANSFORM(TRANSP->FONE1_V,"@R (#999) ##99-9999")+" Telefone2: " + TRANSFORM(TRANSP->FONE2_V,"@R (#999) ##99-9999")+" Fax: " + TRANSFORM(TRANSP->FAX_V,"@R (#999) ##99-9999")
         @ PROW()+1,2 SAY "Contato  : " + TRANSP->CONTATO_V
         IF X=6
            X=0
            EJECT
            CABECA("Relat¢rio de "+TITULO)
         ENDIF
         TRANSP->(DBSKIP())
      ENDDO
      @ PROW()+1,1 SAY REPLICATE("-",78)
      @ PROW()+1,1 SAY " Total de "+TITULO+" Cadastrados : " + TRANSFORM(Y,"@R 999,999")
      EJECT
      SET PRINTER TO
      SET DEVICE TO SCREEN
   ENDIF
   EXIT
ENDDO
TRANSP->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)