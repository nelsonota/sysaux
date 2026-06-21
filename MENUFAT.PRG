FUNCTION MENUFAT()
LOCAL  OP,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN()
WINDOW(10,20,16,49)
DO WHILE .T.
   OPCOES:={"  Emissao  de Notas Fiscais ",;
            "  Consulta de Notas Fiscais ",;
            "  Cancela Notas Fiscais     ",;
            "  Gera Arquivo para NFe     ",;
            "  Consulta Envio Email      "}
   OP:=ACHOICE(11,21,15,48,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("2231")
            MENUNF()
         ENDIF
      CASE OP=2
         IF ACCCOM("2232")
            CONCANNF("V")
         ENDIF
      CASE OP=3
         IF ACCCOM("2233")
            CONCANNF("C")
         ENDIF
      CASE OP=4
         IF ACCCOM("2234")
            NFE() // GLOTENFP()
         ENDIF
      CASE OP=5
         IF ACCCOM("2235")
            CONSMAIL() // GLOTENFP()
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(10,20,14,49)
RETURN(.T.)