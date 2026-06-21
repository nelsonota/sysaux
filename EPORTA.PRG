FUNCTION EPORTA()
LOCAL OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,NETKEY,LEVEL,CODSEN

****** VARIAVEIS P/ CADASTRO DE PORTADORES
MEMVAR CODIGO,NOME
IF CONFIRMA(20,20,"Deseja Excluir o Portador ?")
   AVISO("Excluindo o Portador alguns dados dos relat¢rio podem ficar incompletos")
   IF CONFIRMA(20,20,"Deseja Realmente Excluir ?!")
      PORTA->(RECLOCK())
      PORTA->(DBDELETE())
      PORTA->(DBUNLOCK())
   ENDIF
ENDIF
RETURN(.T.)