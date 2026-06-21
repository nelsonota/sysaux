FUNCTION MIDIA()
LOCAL TELA,OP,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN
MEMVAR MIDIA,NOME
TELA:=SAVESCREEN()
WINDOW(18,8,20,43)
WINDOW(15,8,18,43)
@ 19,43 SAY CHR(219)
@ 14,8 SAY "Tabela de M¡dia" COLOR CORTIT
DBF_MIDIA()
DBF_CONFIG()
DO WHILE .T.
   MIDIA:=MIDIA->CODIGO_V
   NOME  :=MIDIA->NOME_V
   @ 16,10 SAY "C¢digo : " + TRANSFORM(MIDIA,"@ 99")
   @ 17,10 SAY "M¡dia  : " + NOME
   @ 19,9  PROMPT " Incluir "
   @ 19,18 PROMPT " Buscar "
   @ 19,26 PROMPT " Alterar "
   @ 19,35 PROMPT " Apagar "
   MENU TO OP 
   DO CASE
      CASE OP=1
         MIDIA->(DBGOBOTTOM())
         MIDIA:=MIDIA->CODIGO_V+1
         NOME :=SPACE(LEN(MIDIA->NOME_V))
         @ 16,19 SAY TRANSFORM(MIDIA,"@ 99")
         @ 17,19 GET NOME PICT "@K!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma inclusao ?")
            MIDIA->(DBGOBOTTOM())
            MIDIA:=MIDIA->CODIGO_V+1
            IF MIDIA->(ADDREC(5))
               MIDIA->CODIGO_V:=MIDIA
               MIDIA->NOME_V  :=NOME
               MIDIA->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=2
         DBE_MIDIA(10,20,20,50)
      CASE OP=3
         @ 17,19 GET NOME PICT "@!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma altera‡ao ?")
            IF MIDIA->(RECLOCK(5))
               MIDIA->NOME_V:=NOME
               MIDIA->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=4
         IF CONFIRMA(20,20,"Deseja excluir ?")
            IF MIDIA->(RECLOCK(5))
               MIDIA->(DBDELETE())
               MIDIA->(DBUNLOCK())
            ENDIF
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
MIDIA->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RETURN(.T.)