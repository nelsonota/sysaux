FUNCTION ECLIFOR(OPCAO)
MEMVAR CODIGO
DO CASE
   CASE OPCAO="C"
      IF LEFT(CODIGO,1)#OPCAO
         AVISO("Este nao ‚ um Cliente ...")
         RETURN(.F.)
      ENDIF
   CASE OPCAO="F"
      IF LEFT(CODIGO,1)#OPCAO
         AVISO("Este nao ‚ um Fornecedor ...")
         RETURN(.F.)
      ENDIF
   CASE OPCAO="E"
      IF LEFT(CODIGO,1)#OPCAO
         AVISO("Este nao ‚ um Evento ...")
         RETURN(.F.)
      ENDIF
ENDCASE
IF CONFIRMA(22,20,"Confirma Exclusao ?")
   IF CLIFOR->(RECLOCK(5))
      CLIFOR->(DBDELETE())
      CLIFOR->(DBUNLOCK())
      CLIFOR->(DBSEEK(OPCAO,.T.))
      RETURN(.T.)
   ENDIF
ENDIF
RETURN(.T.)