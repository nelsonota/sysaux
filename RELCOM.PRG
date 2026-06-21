FUNCTION RELCOM()
LOCA   OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(11,30,16,61)
DO WHILE .T.
   OPCOES:={"  Pedido                      ",;
            "  Itens de Compras Diretas    ",;
            "  Itens de Compras por Pedido ",;
            "  Itens Comprados no Per¡odo  " }
   OP:=ACHOICE(12,31,15,60,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RELPED1('C')
      CASE OP=2
         RELVCITE("C","D")
      CASE OP=3
         RELVCITE("C","P")
      CASE OP=4
         RELVCITE("C","G")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(11,30,14,56)
RETURN(.T.)