FUNCTION MENUREL()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,IMPFUN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(3,27,11,50)
DO WHILE .T.
   SET CENTURY ON
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={" "+CHR(16)+"Cadastrais          ",;
            " "+CHR(16)+"Controle de Estoque ",;
            " "+CHR(16)+"Assistˆncia T‚cnica ",;
            " "+CHR(16)+"Administrativos     ",;
            " "+CHR(16)+"Faturamento         ",;
            " "+CHR(16)+"Dpto. de Vendas     ",;
            " "+CHR(16)+"Dpto. de Compras    " }
   OP:=ACHOICE(4,28,10,49,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("31")
            RELCAD()
         ENDIF
      CASE OP=2
         IF ACCCOM("32")
            RELEST()
         ENDIF
      CASE OP=3
         IF ACCCOM("33")
            RELTEC()
         ENDIF
      CASE OP=4
         IF ACCCOM("34")
            RELADM()
         ENDIF
      CASE OP=5
         IF ACCCOM("35")
            RELFAT()
         ENDIF
      CASE OP=6
         IF ACCCOM("36")
            RELVEN()
         ENDIF
      CASE OP=7
         IF ACCCOM("37")
            RELCOM()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(3,27,11,50)
RETURN(.T.)