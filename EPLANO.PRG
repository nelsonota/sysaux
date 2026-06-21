FUNCTION EPLANO()
LOCAL OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN

****** VARIAVEIS P/ CADASTRO DE PLANO DE CONTA
MEMVAR CODIGO,NOME
IF CONFIRMA(20,20,"Deseja Excluir o Plano de Conta ?")
   AVISO("Excluindo o Plano de Conta alguns dados dos relat¢rio podem ficar incompletos")
   IF CONFIRMA(20,20,"Deseja Realmente Excluir ?!")
      PLANO->(RECLOCK())
      PLANO->(DBDELETE())
      PLANO->(DBUNLOCK())
   ENDIF
ENDIF
RETURN(.T.)