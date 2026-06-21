FUNCTION NOTA()
LOCAL  OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN()
WINDOW(18,26,22,55)
DO WHILE .T.
   OPCOES:={"  Emissao  de Notas Fiscais ",;
            "  Consulta de Notas Fiscais ",;
            "  Cancela Notas Fiscais     " }
   OP:=ACHOICE(19,27,21,54,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("212261")
*            EMINF()
         ENDIF
      CASE OP=2
         IF ACCCOM("212262")
*            CONCANNF("V")
         ENDIF
      CASE OP=3
         IF ACCCOM("212263")
*            CONCANNF("C")
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(18,26,22,55)
RETURN(.T.)