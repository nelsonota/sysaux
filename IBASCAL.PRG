FUNCTION IBASCAL(CODIMP)
LOCAL  GETLIST:={}
LOCAL CODIGO,GRAVOU
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO

*** MEMVAR P/ CADASTRO DE ALIQUOTA DE BASE DE CALCULO DO ICMS
MEMVAR BASCAL,MENSAGEM,SIGLA,ESTADO,ICMS,BASCALPF,ICMSPF,CFOP,modbc,modbcst,mgvradic
memvar bascalst,icmsst,bcstpf,icmsstpf,sittabb, modpis, pis, mdcofins, cofins, aliqcred
CODIGO  :=CONFIG->BASCAL_V+1
sittabb :="  "
modbc   :=0
BASCAL  :=0
ICMS    :=CONFIG->DEFICMS_V
BASCALPF:=0
ICMSPF  :=CONFIG->DEFICMS_V
modbcst :=0
mgvradic:=0
BASCALST:=0
ICMSST  :=0
BCSTPF  :=0
ICMSSTPF:=0
CFOP    :=SPACE(LEN(BASCAL->CFOP_V))
MENSAGEM:=SPACE(LEN(BASCAL->MENSAGEM_V))
SIGLA   :=SPACE(LEN(BASCAL->SIGLA_V))
ESTADO  :=SPACE(LEN(BASCAL->ESTADO_V))
modpis := space(2)
pis := 0
mdcofins := space(2)
cofins := 0
aliqcred := 0
GRAVOU = .F.
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 01,19 get sittabb  pict "999" valid sea_sittabb(sittabb,1,23)
   if !config->regtrib_v == "3"
      @ 02,40 get aliqcred pict "99.9999"
   endif
   @ 03,19 get modbc    pict "9" valid sea_modbc(modbc,3,22)
   @ 05,29 GET BASCAL   PICT "999.99"
   @ 06,28 GET ICMS     PICT "99.9999"
   @ 05,45 GET BASCALPF PICT "999.99"
   @ 06,44 GET ICMSPF   PICT "99.9999"
   @ 07,19 get modbcst  pict "9" valid sea_modbcst(modbcst,7,22)
   @ 08,19 get mgvradic pict "99.9999"
   @ 09,29 GET BASCALST PICT "999.99"
   @ 10,28 GET ICMSST   PICT "99.9999"
   @ 09,45 GET BCSTPF   PICT "999.99"
   @ 10,44 GET ICMSSTPF PICT "99.9999"
   @ 11,19 GET CFOP     PICT "@!" VALID(SEA_CFOP(CFOP,11,30))
   @ 12,19 GET ESTADO   PICT "@!"
   @ 13,19 GET SIGLA    PICT "@!"
   @ 14,19 GET MENSAGEM PICT "@S50"
   @ 15,19 get modpis pict "99" valid (val(modpis)>0 .and. val(modpis)<10) .or. modpis=="99"
   @ 16,19 get pis pict "99.99"
   @ 17,19 get mdcofins pict "99" valid (val(mdcofins)>0 .and. val(mdcofins)<10) .or. mdcofins=="99"
   @ 18,19 get cofins pict "99.99"
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF CONFIRMA(20,4,"Confirma Inclusao de Aliquota de Base de Calculo do ICMS ?")
      IF BASCAL->(ADDREC(5))
         IF CONFIG->(RECLOCK(5))
            CONFIG->BASCAL_V:=CONFIG->BASCAL_V+1
            CODIGO:=CONFIG->BASCAL_V
            CONFIG->(DBUNLOCK())
         ENDIF
         bascal->sittabb_v :=sittabb
         BASCAL->CODIMP_V  :=CODIMP
         BASCAL->CODIGO_V  :=CODIGO
         bascal->modbc_v   :=modbc
         BASCAL->BASCAL_V  :=BASCAL
         BASCAL->CFOP_V    :=CFOP
         BASCAL->ICMS_V    :=ICMS
         BASCAL->BASCALPF_V:=BASCALPF
         BASCAL->ICMSPF_V  :=ICMSPF
         bascal->modbcst_v :=modbcst
         bascal->mgvradic_v:=mgvradic
         BASCAL->BASCALST_V:=BASCALST
         BASCAL->ICMSST_V  :=ICMSST
         BASCAL->BCSTPF_V  :=BCSTPF
         BASCAL->ICMSSTPF_V:=ICMSSTPF
         BASCAL->ESTADO_V  :=ESTADO
         BASCAL->SIGLA_V   :=SIGLA
         BASCAL->MENSAGEM_V:=MENSAGEM
         bascal->modpis_v  := modpis
         bascal->pis_v     := pis
         bascal->mdcofins_v:= mdcofins
         bascal->cofins_v  := cofins
         bascal->aliqcred_v:= aliqcred
         BASCAL->(DBUNLOCK())
         GRAVOU = .T.
         EXIT
      ENDIF
   ENDIF
ENDDO
RETURN(GRAVOU)