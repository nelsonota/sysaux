FUNCTION MENUTAB()
LOCAL OPCOES,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(10,5,17,29)
DO WHILE .T.
   OPCOES:={"  Grupo para Impostos  ",;
            "  Plano de Contas      ",;
            "  Tabela de C.F.O.P.   ",;
            "  Tabela de M¡dia      ",;
            "  Tipo de Servi‡o      ",;
            "  Tabela de Portadores " }
   OP:=ACHOICE(11,6,16,28,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("171")
            CADIMP()
         ENDIF
      CASE OP=2
         IF ACCCOM("172")
            PLANO()
         ENDIF
      CASE OP=3
         IF ACCCOM("173")
            CFOP()
         ENDIF
      CASE OP=4
         IF ACCCOM("174")
            MIDIA()
         ENDIF
      CASE OP=5
         IF ACCCOM("175")
            TIPOSERV()
         ENDIF
      CASE OP=6
         IF ACCCOM("176")
            PORTA()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(10,5,17,29)
RETURN(.T.)