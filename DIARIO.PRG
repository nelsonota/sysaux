FUNCTION DIARIO()
LOCAL OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(8,20,15,48)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={"  Baixas de Contas Futuras ",;
            "  Lan‡amentos    … Vista   ",;
            "  Transferˆncias Banc rias ",;
            "  Compensa‡ao de Cheques   ",;
            "  Aplica‡oes               ",;
            "  Bloqueio de Valores      " }
   OP:=ACHOICE(9,21,14,47,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2211")
            BAIXA()
         ENDIF
      CASE OP=2
         IF ACCCOM("2212")
            VISTA()
         ENDIF
      CASE OP=3
         IF ACCCOM("2213")
            TRANSBAN()
         ENDIF
      CASE OP=4
         IF ACCCOM("2214")
            COMPENSA()
         ENDIF
      CASE OP=5
         IF ACCCOM("2215")
            APLICACAO()
         ENDIF
      CASE OP=6
         IF ACCCOM("2216")
            BLOQUEIO()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(8,20,13,48)
RETURN(.T.)