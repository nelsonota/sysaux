FUNCTION EMECVEN(OPCAO)
MEMVAR CODIGO
DO CASE
   CASE OPCAO="M"
      IF LEFT(CODIGO,1)#OPCAO
         AVISO("Este nao ‚ um Mecƒnico ...")
         RETURN(.F.)
      ENDIF
   CASE OPCAO="V"
      IF LEFT(CODIGO,1)#OPCAO
         AVISO("Este nao ‚ um Vendedor ...")
         RETURN(.F.)
      ENDIF
ENDCASE
IF CONFIRMA(22,20,"Confirma Exclusao ?")
   IF MECVEN->(RECLOCK(5))
      MECVEN->(DBDELETE())
      MECVEN->(DBUNLOCK())
      MECVEN->(DBSEEK(OPCAO,.T.))
      RETURN(.T.)
   ENDIF
ENDIF
RETURN(.T.)