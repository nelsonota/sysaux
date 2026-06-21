FUNCTION MENUADM()
LOCAL OPCOES,TELA,OP
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(6,17,10,40)
DO WHILE .T.
   OPCOES:={" "+CHR(16)+"Lan‡amentos Di rios ",;
            " "+CHR(16)+"Lan‡amentos Futuros ",;
            " "+CHR(16)+"Faturamento         " }
   OP:=ACHOICE(7,18,9,39,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("221")
            DIARIO()
         ENDIF
      CASE OP=2
         IF ACCCOM("222")
            MENUFUT()
         ENDIF
      CASE OP=3
         IF ACCCOM("223")
            MENUFAT()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(6,17,10,40)
RETURN(.T.)