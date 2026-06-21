FUNCTION RELFAT()
LOCAL TELA,OPCOES,OP
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN()
WINDOW(9,30,14,70)
DO WHILE .T.
   OPCOES:={"  Notas Fiscais emitidas por per¡odo   ",;
            "  Notas Fiscais canceladas por per¡odo ",;
            "  Notas Fiscais emitidas por cliente   ",;
            "  Notas Fiscais canceladas por cliente " }
   OP:=ACHOICE(10,31,13,69,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RELNF("EMI")
      CASE OP=2
         RELNF("CAN")
      CASE OP=3
         RELNF("CEMI")
      CASE OP=4
         RELNF("CCAN")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(9,30,14,70)
RETURN(.T.)