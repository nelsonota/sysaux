FUNCTION RECHEQUE()
LOCAL OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(15,33,23,66)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Cheques Pendentes       Geral ",;
            "  Cheques Compensados     Geral ",;
            "  Cheques Cancelados      Geral ",;
            "  Cheques Pendentes   por Banco ",;
            "  Cheques Compensados por Banco ",;
            "  Cheques Cancelados  por Banco ",;
            "  Lan‡amentos c/ Cheque         " }
   OP:=ACHOICE(16,34,22,65,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RECHQ("PEN")
      CASE OP=2
         RECHQ("COM")
      CASE OP=3
         RECHQ("CAN")
      CASE OP=4
         RECHQBAN("PEN")
      CASE OP=5
         RECHQBAN("COM")
      CASE OP=6
         RECHQBAN("CAN")
      CASE OP=7
         RECHQLAN()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(15,33,23,66)
RETURN(.T.)