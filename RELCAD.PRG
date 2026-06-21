FUNCTION RELCAD()
LOCAL  TELA,OP,OPCOES
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN()
WINDOW(5,30,19,67)
DO WHILE .T.
   OPCOES:={"  Ficha cadastral de cliente        ",;
            "  Clientes     por Ordem Alfab‚tica ",;
            "  Clientes     por Inicial          ",;
            "  Clientes     com Letras Contidas  ",;
            "  Ficha cadastral de fornecedor     ",;
            "  Fornecedores por Ordem Alfab‚tica ",;
            "  Fornecedores por Inicial          ",;
            "  Fornecedores com Letras Contidas  ",;
            "  Eventos      por Ordem Alfab‚tica ",;
            "  Eventos      por Inicial          ",;
            "  Eventos      com Letras Contidas  ",;
            "  Vendedores   por Ordem Alfab‚tica ",;
            "  T‚cnicos     por Ordem Alfab‚tica ",;
            "  Transportad. por Ordem Alfab‚tica ",;
            " "+CHR(16)+"Etiquetas para Mala Direta        " }
   OP:=ACHOICE(6,31,18,66,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         REFICAD("C")
      CASE OP=2
         RECFORD("C")
      CASE OP=3
         RELCF("C","I")
      CASE OP=4
         RELCF("C","C")
      CASE OP=5
         REFICAD("F")
      CASE OP=5
         RECFORD("F")
      CASE OP=6
         RELCF("F","I")
      CASE OP=7
         RELCF("F","C")
      CASE OP=8
         RECFORD("E")
      CASE OP=9
         RELCF("E","I")
      CASE OP=10
         RELCF("E","C")
      CASE OP=11
         RELMV("V")
      CASE OP=12
         RELMV("M")
      CASE OP=13
         RELTRAN()
      CASE OP=14
         RELMALA()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(5,30,18,67)
RETURN(.T.)