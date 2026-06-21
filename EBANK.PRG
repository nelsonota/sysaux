FUNCTION EBANK()
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN

***** VARIAVEIS PARA CADASTRO DE BANCOS
MEMVAR CODIGO,NOME,CONTA,AGENCIA,SALDO
AVISO("Nao ‚ aconselh vel excluir o banco, por motivo de consultas depois desejadas.")
IF SALDO<>0
   AVISO("Para excluir o banco ‚ necess rio zerar o saldo primeiro")
ENDIF
IF CONFIRMA(20,20,"Deseja realmente excluir o banco ?")
   BANK->(RECLOCK(5))
   BANK->(DBDELETE())
   BANK->(DBUNLOCK())
ENDIF
RETURN(.T.)