FUNCTION MENUPROD()
LOCAL OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(8,17,12,43)
DO WHILE .T.
   OPCOES:={"  Produ‡ao/Remanufaturar ",;
            "  Produ‡oes realizadas   ",;
            "  Defini‡ao de Material  " }
   OP:=ACHOICE(9,18,11,42,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("241")
            PRODUCAO()
         ENDIF
      CASE OP=2
         IF ACCCOM("242")
            MOVPROD()
         ENDIF
      CASE OP=3
         IF ACCCOM("243")
            DEFMAT()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(8,17,12,43)
RETURN(.T.)