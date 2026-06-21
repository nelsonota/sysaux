FUNCTION COMERCIO()
LOCAL OP,OP1,OPCOES,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,INSMUN,NOMSEN
MEMVAR IMPFUN,SYSVEN,BLQVEN,RECO
DBF_CONFIG()
INSMUN:=DECRIP(CONFIG->INSMUN_V)
RECO:=''
CONFIG->(DBCLOSEAREA())
TEL_PRINCIPAL()
SETCOLOR(CORTEX)
DBF_SENHA()
IF SENHA->(DBSEEK(CODSEN))
   @ 24,1 SAY " Usu rio : " + SENHA->NOMSEN_V+" N¡vel : "+SENHA->LEVEL_V
ENDIF
SENHA->(DBCLOSEAREA())
DO WHILE(.T.)
   SET KEY 28 TO AJUDA()
   SET KEY -3 TO CALCULA()
   SET KEY -2 TO CHANGE()
   SET KEY 14 TO PROTECT()
   SETCOLOR(CORTEX+","+CORBAR)
   DO CASE
      CASE LASTKEY()=19
         KEYBOARD CHR(19)+CHR(13)
      CASE LASTKEY()=4
         KEYBOARD CHR(4)+CHR(13)
   ENDCASE
   @ 1,2  PROMPT "Cadastros"
   @ 1,14 PROMPT "Movimentos"
   @ 1,27 PROMPT "Relat¢rios"
   @ 1,40 PROMPT "Utilit rios"
   @ 1,54 PROMPT "Sair"
   IF LEVEL="NE"
      @ 1,61 PROMPT "Sistema"
   ENDIF
   MENU TO OP
   SET KEY -2 TO
   SET KEY 14 TO
   DO CASE
      CASE OP=1
         IF ACCCOM("1")
            MENUCAD()
         ENDIF
      CASE OP=2
         IF ACCCOM("2")
            MENUMOV()
         ENDIF
      CASE OP=3
         IF ACCCOM("3")
            MENUREL()
         ENDIF
      CASE OP=4
         IF ACCCOM("4")
            MENUUTI()
         ENDIF
      CASE OP=5
         TELA:=SAVESCREEN(0,0,24,80)
         OPCOES:={" Nao "," Sim "}
         WINDOW(3,54,6,60)
         OP1:=ACHOICE(4,55,5,59,OPCOES,.T.,"ACHOFUN")
         DO CASE
            CASE OP1=2
               RETURN(.T.)
            OTHERWISE
               RESTSCREEN(0,0,24,80,TELA)
               CLOSEWIN(3,54,6,60)
               LOOP
         ENDCASE
      CASE OP=6
         TELA:=SAVESCREEN(0,0,24,80)
         DO WHILE .T.
            WINDOW(3,61,6,72)
            OPCOES:={"  Empresa ",;
                     "  DBF's   " }
            OP1:=ACHOICE(4,62,5,71,OPCOES,.T.,"ACHOFUN")
            DO CASE
               CASE OP1=1
                  EMPRESA()
               CASE OP1=2
                  DADOS()
               OTHERWISE
                  EXIT
            ENDCASE
         ENDDO
         RESTSCREEN(0,0,24,80,TELA)
         CLOSEWIN(3,61,6,72)
   ENDCASE
ENDDO
RETURN(.T.)

FUNCTION PROTECT()
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
DBF_CONFIG()
IF CONFIG->PROTECT_V="N"
   IF CONFIG->(RECLOCK())
      CONFIG->PROTECT_V:="S"
      CONFIG->(DBUNLOCK())
   ENDIF
ELSE
   IF CONFIG->(RECLOCK())
      CONFIG->PROTECT_V:="N"
      CONFIG->(DBUNLOCK())
   ENDIF
ENDIF
CONFIG->(DBCLOSEAREA())
RETURN(.T.)