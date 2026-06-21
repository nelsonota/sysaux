FUNCTION EPAGREC(OPCAO)
DO CASE
   CASE OPCAO="P"
      IF LEFT(PAGREC->CODIGO_V,1)#OPCAO
         AVISO("Este nao ‚ um T¡tulo … Pagar ...")
         RETURN(.F.)
      ENDIF
   CASE OPCAO="R"
      IF LEFT(PAGREC->CODIGO_V,1)#OPCAO
         AVISO("Este nao ‚ um T¡tulo … Receber ...")
         RETURN(.F.)
      ENDIF
ENDCASE
IF ! EMPTY(PAGREC->PEDIDO_V)
   IF ! CONFIRMA(22,02,"Esse t¡tulo ‚ referente a uma Venda.Deseja Excluir assim mesmo ?")
      RETURN(.T.)
   ENDIF
ENDIF
IF CONFIRMA(22,20,"Confirma Exclusao ?")
   IF PAGREC->(RECLOCK(5))
      PAGREC->(DBDELETE())
      PAGREC->(DBUNLOCK())
      PAGREC->(DBSEEK(OPCAO,.T.))
      RETURN(.T.)
   ENDIF
ENDIF
RETURN(.T.)