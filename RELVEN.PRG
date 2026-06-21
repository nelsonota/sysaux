FUNCTION RELVEN()
LOCA   OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(10,30,19,65)
DO WHILE .T.
   OPCOES:={"  Pedidos                         ",;
            "  Itens de Vendas Diretas         ",;
            "  Itens Vendidos por Pedido       ",;
            "  Itens Vendidos no Per¡odo       ",;
            "  Itens Vendidos por Cliente      ",;
            "  Clientes sem Venda              ",;
            "  Itens Vendidos por Produto(CVS) ",;
            "  Pedidos em aberto               " }
   OP:=ACHOICE(11,31,18,64,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RELPED1("V")
      CASE OP=2
         RELVCITE("V","D")
      CASE OP=3
         RELVCITE("V","P")
      CASE OP=4
         RELVCITE("V","G")
      CASE OP=5
         RELVCITE("V","G","C")
      CASE OP=6
         RECLIVND()
      CASE OP=7
         RELVCCVS()
      CASE OP=8
         RELPEDABE()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(10,30,17,59)
RETURN(.T.)