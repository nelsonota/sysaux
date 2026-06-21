FUNCTION MENUMOV()
LOCAL OPCOES,TELA,OP
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(3,14,8,44)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={" "+CHR(16)+"Vendas/Compras/Estoque     ",;
            " "+CHR(16)+"Administra‡ao              ",;
            " "+CHR(16)+"Assistˆncia T‚cnica        ",;
            " "+CHR(16)+"Produ‡ao/Remanufaturamento " }
   OP:=ACHOICE(4,15,7,43,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("21")
            MENUEST()
         ENDIF
      CASE OP=2
         IF ACCCOM("22")
            MENUADM()
         ENDIF
      CASE OP=3
         IF ACCCOM("23")
            TECNICA()
         ENDIF
      CASE OP=4
         IF ACCCOM("24")
            MENUPROD()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(3,14,8,44)
RETURN(.T.)