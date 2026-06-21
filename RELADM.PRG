FUNCTION RELADM()
LOCAL OPCOES,OP,TELA,OP2,TELA2,OPCOES2
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(7,30,24,70)
DO WHILE .T.
   SET CENTURY ON
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Lan‡amentos Di rios                  ",;
            "  Lan‡amentos Di rios por Banco        ",;
            "  Lan‡amentos por Cliente / Fornecedor ",;
            "  Lan‡amentos por Plano de Contas      ",;
            "  Fluxo de Caixa                       ",;
            "  Contas … Pagar                       ",;
            "  Contas … Receber                     ",;
            "  Contas … Pagar por Nome              ",;
            "  Contas … Receber por Nome            ",;
            "  Contas Baixadas                      ",;
            "  Contas Baixadas por Nome             ",;
            "  Contas Baixadas por Banco            ",;
            "  Total Pagar e Receber Dia a Dia      ",;
            "  Saldo Bancario                       ",;
            " "+CHR(16)+"Cheques da Empresa         ",;
            " "+CHR(16)+"Cobranca                   " }
   OP:=ACHOICE(8,31,23,69,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RELADIA()
      CASE OP=2
         RELADIBK()
      CASE OP=3
         RELADICF()
      CASE OP=4
         RELPLANO()
      CASE OP=5
         REFLUXO()
      CASE OP=6
         RELFUT("P")
      CASE OP=7
         RELFUT("R")
/*         TELA2:=SAVESCREEN(0,0,24,80)
         WINDOW(14,60,17,75)
         OPCOES2:={"  Por Per¡odo ",;
                   "  Geral       " }
         OP2:=ACHOICE(15,61,16,74,OPCOES2,.T.,"ACHOFUN")
         IF OP2=1
            RELFUT("R")
         ELSEIF OP2=2
            REFUTGER()
         ENDIF
         RESTSCREEN(,,,,TELA2)*/
      CASE OP=8
         RELFUTCF("P")
      CASE OP=9
         RELFUTCF("R")
      CASE OP=10
         REFUTBAI()
      CASE OP=11
         REFUTBCF()
      CASE OP=12
         REFUTBBK()
      CASE OP=13
         REPAGREC()
      CASE OP=14
         RESALBAN()
      CASE OP=15
         RECHEQUE()
      CASE OP=16
         RECOBRAN()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(7,30,24,70)
RETURN(.T.)