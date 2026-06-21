FUNCTION RECOBRAN()
LOCAL OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(16,33,24,63)
DO WHILE .T.
   SET CENTURY ON
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   OPCOES:={" Cheques Pr‚ Datados         ",;
            " Boletos por Per¡odo         ",;
            " Boletos por Banco           ",;
            " Duplicatas por Per¡odo      ",;
            " Duplicatas por Banco        ",;
            " T¡tulos sem Cobran‡a        ",;
            " T¡tulos Protestados         " }
   OP:=ACHOICE(17,34,23,62,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RECHQPRE()
      CASE OP=2
         RELBODU("BP")
      CASE OP=3
         RELBODU("BB")
      CASE OP=4
         RELBODU("DP")
      CASE OP=5
         RELBODU("DB")
      CASE OP=6
         RELBODU("SC")
      CASE OP=7
         RELBODU("PR")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(15,33,23,66)
RETURN(.T.)