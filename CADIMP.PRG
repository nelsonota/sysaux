FUNCTION CADIMP()
LOCAL TELA,OP,GETLIST:={},LN
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN
MEMVAR CODIGO,NOME,ITEMSIMP
TELA:=SAVESCREEN()
WINDOW(5,8,7,53)
WINDOW(2,8,5,53)
WINDOW(7,8,20,77)
@ 6,53 SAY CHR(219)
@ 2,9 SAY "Tabela de Impostos" COLOR CORTIT
@ 7,9 SAY "Bases de Calculo registradas" COLOR CORTIT
@ 8,9 SAY "UF Mensagem                                           BaseC.    ICMS"
@ 9,9 TO 9,76
*          XX 12345678901234567890123456789012345678901234567890 999.99 99.9999
DBF_CADIMP()
DBF_CONFIG()
DBF_BASCAL()
DBF_CFOP()
dbf_sittabb()
sittabb->(dbsetfilter({|| sittabb->regtrib_v == if(config->regtrib_v=="3","3","1") }))
DO WHILE .T.
   CODIGO:=CADIMP->CODIGO_V
   NOME  :=CADIMP->NOME_V
   @ 3,10 SAY "Codigo : " + TRANSFORM(CODIGO,"@ 99")
   @ 4,10 SAY "Grupo  : " + left(NOME,33)
   BASCAL->(DBSEEK(STR(CADIMP->CODIGO_V,5)))
   SCROLL(10,9,19,76)
   LN=9
   ITEMSIMP:={}
   DO WHILE !BASCAL->(EOF()) .AND. BASCAL->CODIMP_V==CADIMP->CODIGO_V
      ++LN
      AADD(ITEMSIMP,BASCAL->SIGLA_V+" "+LEFT(BASCAL->MENSAGEM_V,50)+" "+TRANSFORM(BASCAL->BASCAL_V,"@R 999.99")+" "+TRANSFORM(BASCAL->ICMS_V,"@R 99.9999")+SPACE(10)+STR(BASCAL->(RECNO()),8))
      IF LN<=19
         @ LN,9 SAY LEFT(ITEMSIMP[LEN(ITEMSIMP)],68)
      ENDIF
      BASCAL->(DBSKIP())
   ENDDO
   IF LEN(ITEMSIMP)<1
      AADD(ITEMSIMP,SPACE(80))
   ENDIF
   @ 6,9  PROMPT " Incluir "
   @ 6,18 PROMPT " Buscar "
   @ 6,26 PROMPT " Alterar "
   @ 6,35 PROMPT " Apagar "
   @ 6,43 PROMPT " Impostos "
   MENU TO OP 
   DO CASE
      CASE OP=1
         CADIMP->(DBGOBOTTOM())
         CODIGO:=CADIMP->CODIGO_V+1
         NOME :=SPACE(LEN(CADIMP->NOME_V))
         @ 3,19 SAY TRANSFORM(CODIGO,"@ 99")
         @ 4,19 GET NOME PICT "@S33!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma inclusao ?")
            CADIMP->(DBGOBOTTOM())
            CODIGO:=CADIMP->CODIGO_V+1
            IF CADIMP->(ADDREC(5))
               CADIMP->CODIGO_V:=CODIGO
               CADIMP->NOME_V  :=NOME
               CADIMP->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=2
         DBE_CADIMP(5,15,15,50)
      CASE OP=3
         @ 4,19 GET NOME PICT "@S33!"
         READ
         IF LASTKEY()=27
            LOOP
         ENDIF
         IF CONFIRMA(20,20,"Confirma altera‡ao ?")
            IF CADIMP->(RECLOCK(5))
               CADIMP->NOME_V:=NOME
               CADIMP->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=4
         IF CONFIRMA(20,20,"Deseja excluir ?")
            BASCAL->(DBSEEK(STR(CADIMP->CODIGO_V,5)))
            DO WHILE !BASCAL->(EOF()) .AND. BASCAL->CODIMP_V==CADIMP->CODIGO_V
               BASCAL->(RECLOCK(5))
               BASCAL->(DBDELETE())
               BASCAL->(DBUNLOCK())
               BASCAL->(DBSKIP())
            ENDDO
            IF CADIMP->(RECLOCK(5))
               CADIMP->(DBDELETE())
               CADIMP->(DBUNLOCK())
            ENDIF
         ENDIF
      CASE OP=5
         IF CADIMP->CODIGO_V>0
            @ 24,0 SAY PADR("Ins-Incluir imposto Del-Excluir imposto Enter-Altera Imposto Esc-Voltar",80) COLOR CORTIT
            ACHOICE(10,9,19,76,ITEMSIMP,.T.,"ACCADIMP")
         ENDIF
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
BASCAL->(DBCLOSEAREA())
CADIMP->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
CFOP->(DBCLOSEAREA())
sittabb->(dbclosearea())
RETURN(.T.)

FUNCTION ACCADIMP(nMode,nCurElement,nRowPes)
LOCAL nRetVal := 2
LOCAL nKey := LASTKEY()
LOCAL nReg,TELA
#INCLUDE "ACHOICE.CH" 
MEMVAR ITEMSIMP,CODIGO,BASCAL,MENSAGEM,SIGLA,ESTADO,ICMS,BASCALPF,ICMSPF,CFOP,modbc,modbcst,mgvradic
memvar bascalst,icmsst,bcstpf,icmsstpf,sittabb, modpis, pis, mdcofins, cofins, aliqcred
TELA := SAVESCREEN()
DO CASE
   CASE nMode = AC_EXCEPT
      DO CASE
         CASE nKey == 27
           nRetVal := AC_ABORT
         CASE nKey == 22
            TELBASCAL()
            IF IBASCAL(CADIMP->CODIGO_V)
               AADD(ITEMSIMP,BASCAL->SIGLA_V+" "+LEFT(BASCAL->MENSAGEM_V,50)+" "+TRANSFORM(BASCAL->BASCAL_V,"@R 999.99")+" "+TRANSFORM(BASCAL->ICMS_V,"@R 99.9999")+SPACE(10)+STR(BASCAL->(RECNO()),8))
            ENDIF
         CASE nKey == 13
            nReg := VAL(RIGHT(ITEMSIMP[nCurElement],8)) 
            IF nReg > 0
               BASCAL->(DBGOTO(nReg))
               sittabb :=bascal->sittabb_v
               modbc   :=bascal->modbc_v
               BASCAL  :=BASCAL->BASCAL_V
               ICMS    :=BASCAL->ICMS_V
               modbcst :=bascal->modbcst_v
               mgvradic:=bascal->mgvradic_v
               bascalst:=bascal->bascalst_v
               icmsst  :=bascal->icmsst_v
               bcstpf  :=bascal->bcstpf_v
               icmsstpf:=bascal->icmsstpf_v
               CFOP    :=BASCAL->CFOP_V
               MENSAGEM:=BASCAL->MENSAGEM_V
               SIGLA   :=BASCAL->SIGLA_V
               ESTADO  :=BASCAL->ESTADO_V
               BASCALPF:=BASCAL->BASCALPF_V
               ICMSPF  :=BASCAL->ICMSPF_V
               MODPIS  :=BASCAL->MODPIS_V
               PIS     :=BASCAL->PIS_V
               MDCOFINS:=BASCAL->MDCOFINS_V
               COFINS  :=BASCAL->COFINS_V
               aliqcred:=BASCAL->aliqcred_v
               TELBASCAL()
               SETCURSOR(1)
               ABASCAL()
               SETCURSOR(0)
               ITEMSIMP[nCurElement] := BASCAL->SIGLA_V+" "+LEFT(BASCAL->MENSAGEM_V,50)+" "+TRANSFORM(BASCAL->BASCAL_V,"@R 999.99")+" "+TRANSFORM(BASCAL->ICMS_V,"@R 99.9999")+SPACE(10)+STR(BASCAL->(RECNO()),8)
            ENDIF
         CASE nKey == 7
            nReg := VAL(RIGHT(ITEMSIMP[nCurElement],8)) 
            IF nReg > 0
               IF CONFIRMA(20,10,"Deseja realmente excluir esta definicao de imposto ?")
                  BASCAL->(DBGOTO(nReg))
                  IF BASCAL->(RECLOCK(5))
                     BASCAL->(DBDELETE())
                  ENDIF
                  nRetVal := AC_ABORT                  
               ENDIF
            ENDIF
         OTHERWISE
            nRetVal := AC_GOTO
      ENDCASE
ENDCASE
RESTSCREEN(,,,,TELA)
RETURN nRetVal

FUNCTION TELBASCAL()
WINDOW(0,00,19,79)
@ 1,02 say "Tributacao ICMS: "
if !config->regtrib_v == "3"
   @2,02 say "Aliq.aplicavel de calculo do credito:"
endif
@ 03,2 SAY "Mod.Det.B.Calc.: "
@ 04,2 SAY "                 [Pessoa Juridica] [Pessoa Fisica]"
@ 05,2 SAY "Base de Calculo: "
@ 06,2 SAY "ICMS padrao    : "
@ 07,2 SAY "Mod.Det.B.C.ST.: "
@ 08,2 say "Mg.Vr.Adic.ST. : "
@ 09,2 SAY "B.Calculo ST.  : "
@ 10,2 SAY "ICMS ST        : "
@ 11,2 say "CFOP           : "
@ 12,2 SAY "Estado         : "
@ 13,2 SAY "Sigla          : "
@ 14,2 SAY "Mensagem       : "
@ 15,2 say "Tributacao PIS : "
@ 16,2 say "Aliquota PIS   : "
@ 17,2 say "Tribut. COFINS : "
@ 18,2 say "Aliquota COFINS: "
RETURN NIL