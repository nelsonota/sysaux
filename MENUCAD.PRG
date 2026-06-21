FUNCTION MENUCAD()
LOCAL  OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(3,2,14,18)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Clientes     ",;
            "  Fornecedores ",;
            "  Eventos      ",;
            "  Estoque      ",;
            "  Bancos       ",;
            " "+CHR(16)+ "Cheques       ",;
            " "+CHR(16)+ "Tabelas       ",;
            "  Vendedores   ",;
            "  T‚cnicos     ",;
            "  Transport.   " }
   SETCOLOR(CORTEX+","+CORBAR)
   OP:=ACHOICE(4,3,13,17,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("11")
            CLIFOR("C")
         ENDIF
      CASE OP=2
         IF ACCCOM("12")
            CLIFOR("F")
         ENDIF
      CASE OP=3
         IF ACCCOM("13")
            CLIFOR("E")
         ENDIF
      CASE OP=4
         IF ACCCOM("14")
            ESTOQUE()
         ENDIF
      CASE OP=5
         IF ACCCOM("15")
            BANK()
         ENDIF
      CASE OP=6
         IF ACCCOM("16")
            CHEQUE()
         ENDIF
      CASE OP=7
         IF ACCCOM("17")
            MENUTAB()
         ENDIF
      CASE OP=8
         IF ACCCOM("18")
            MECVEN("V")
         ENDIF
      CASE OP=9
         IF ACCCOM("19")
            MECVEN("M")
         ENDIF
      CASE OP=10
         IF ACCCOM("1A")
            TRANSP()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(3,2,14,18)
RETURN(.T.)