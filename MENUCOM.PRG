FUNCTION MENUCOM()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(7,20,13,50)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Compras                    ",;
            "  Compra por Pedido         ",;
            "  Manuten‡ao de Compras     ",;
   			" "+CHR(16)+"Cotacoes de Compra        ",;
            "  Outras Entradas            " }
   OP:=ACHOICE(8,21,12,49,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2115")
            Compras()
         ENDIF
      CASE OP=2
         IF ACCCOM("2112")
            PEDIDO("C")
         ENDIF
      CASE OP=3
         IF ACCCOM("2113")
            MOVPED("C")
         ENDIF
      CASE OP=4
         IF ACCCOM("2114")
            MENUCOTA()
         ENDIF
      CASE OP=5
         IF ACCCOM("2116")
            OUTMOV("E")
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(7,20,11,42)
RETURN(.T.)

FUNCTION _MENUCOM()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(7,20,14,50)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Compra Direta             ",;
            "  Compra por Pedido         ",;
            "  Manuten‡ao de Compras     ",;
            " "+CHR(16)+"Cotacoes de Compra        ",;
            "  Outras Entradas de Estoque ",;
            "  Compras                    " }
   OP:=ACHOICE(8,21,13,49,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2111")
            DIRETOC()
         ENDIF
      CASE OP=2
         IF ACCCOM("2112")
            PEDIDO("C")
         ENDIF
      CASE OP=3
         IF ACCCOM("2113")
            MOVPED("C")
         ENDIF
      CASE OP=4
         IF ACCCOM("2114")
            MENUCOTA()
         ENDIF
      CASE OP=5
         IF ACCCOM("2115")
            OUTRENT()
         ENDIF
      CASE OP=6
         Compras()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(7,20,11,42)
RETURN(.T.)