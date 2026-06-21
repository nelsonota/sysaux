FUNCTION TIPOSERV()
LOCAL TELA,OP,GETLIST:={},TELA1
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN
MEMVAR SERV,NOME
TELA:=SAVESCREEN()
WINDOW(19,8,21,50)
WINDOW(16,8,19,50)
@ 20,50 SAY CHR(219)
@ 15,8 SAY "Tipos de Servi‡o" COLOR CORTIT
DBF_SERV()
DBF_CONFIG()
DO WHILE .T.
   SERV:=SERV->CODIGO_V
   NOME  :=SERV->NOME_V
   @ 17,10 SAY "C¢digo  : " + TRANSFORM(SERV,"@ 99")
   @ 18,10 SAY "Servi‡o : " + NOME
   @ 20,9  PROMPT " Incluir "
   @ 20,18 PROMPT " Buscar "
   @ 20,26 PROMPT " Alterar "
   @ 20,35 PROMPT " Apagar "
   @ 20,43 PROMPT " Texto "
   MENU TO OP 
   DO CASE
      CASE OP=1
         SERV :=SPACE(LEN(SERV->CODIGO_V))
         NOME :=SPACE(LEN(SERV->NOME_V))
         @ 17,20 GET SERV PICT "@K!"
         @ 18,20 GET NOME PICT "@K!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma inclusao ?")
            IF SERV->(ADDREC(5))
               SERV->CODIGO_V:=SERV
               SERV->NOME_V  :=NOME
               SERV->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=2
         DBE_SERV(10,20,20,50)
      CASE OP=3
         @ 18,20 GET NOME PICT "@!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma altera‡ao ?")
            IF SERV->(RECLOCK(5))
               SERV->NOME_V:=NOME
               SERV->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=4
         IF CONFIRMA(20,20,"Deseja excluir ?")
            IF SERV->(RECLOCK(5))
               SERV->(DBDELETE())
               SERV->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=5
         TELA1:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         @ 6,2 SAY PADC(ALLTRIM(SERV+" "+NOME),76) COLOR CORTIT
         @ 7,1 TO 7,78
         IF SERV->(RECLOCK(5))
            SETCOLOR("N/W")
            SERV->TEXTO_V:=MEMOEDIT(SERV->TEXTO_V,8,1,19,78,.T.,"MemoFunction")
            SETCOLOR(CORTEX+","+CORBAR)
            SERV->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA1)
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
SERV->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RETURN(.T.)