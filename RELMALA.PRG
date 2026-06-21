FUNCTION RELMALA()
LOCAL  TELA,OP,OPCOES
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN()
WINDOW(17,33,24,67)
DO WHILE .T.
   OPCOES:={"  Etiquetas para Clientes        ",;
            "  Etiquetas para Fornecedores    ",;
            "  Etiquetas para Eventos         ",;
            "  Etiquetas para T‚cnicos        ",;
            "  Etiquetas para Vendedores      ",;
            "  Etiquetas para Transportadoras " }
   OP:=ACHOICE(18,34,23,66,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         MALA("CLI")
      CASE OP=2
         MALA("FOR")
      CASE OP=3
         MALA("EVE")
      CASE OP=4
         MALA("TEC")
      CASE OP=5
         MALA("MEC")
      CASE OP=6
         MALA("TRA")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(17,33,24,67)
RETURN(.T.)