FUNCTION MENUVEN()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(8,20,14,42)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Vendas             ",;
            "  Venda por Pedido   ",;
            "  Manutencao Vendas  ",;
   			"  Cotacao            ",;
            "  Outras Saidas      " }
   OP:=ACHOICE(9,21,13,41,OPCOES,.t.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2125")
            vendas()
         ENDIF
   	CASE OP=2
         IF ACCCOM("2122")
            PEDIDO("V")
         ENDIF
      CASE OP=3
         IF ACCCOM("2123")
            MOVPED("V")
         ENDIF
      CASE OP=4
         IF ACCCOM("2124")
            COTAVEN()
         ENDIF
      CASE OP=5
         IF ACCCOM("2126")
            OUTMOV("S")
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(8,20,12,44)
RETURN(.T.)

FUNCTION _MENUVEN()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(8,20,14,42)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Venda Direta       ",;
            "  Venda por Pedido   ",;
            "  Manutencao Vendas  ",;
            "  Cotacao            ",;
            "  Vendas             " }
   OP:=ACHOICE(9,21,13,41,OPCOES,.t.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2121")
            DIRETOV()
         ENDIF
      CASE OP=2
         IF ACCCOM("2122")
            PEDIDO("V")
         ENDIF
      CASE OP=3
         IF ACCCOM("2123")
            MOVPED("V")
         ENDIF
      CASE OP=4
         IF ACCCOM("2124")
            COTAVEN()
         ENDIF
      CASE OP=5
         vendas()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(8,20,12,44)
RETURN(.T.)