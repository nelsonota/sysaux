FUNCTION CLEANDBF()
MEMVAR DATAPATH
CLEAN("SENHA"   ,"Usu rios")
CLEAN("CLIFOR"  ,"Clientes / Fornecedores / Eventos")
CLEAN("PAGREC"  ,"Contas a Pagar e Contas a Receber")
CLEAN("ESTOQUE" ,"Itens do Estoque")
CLEAN("MECVEN"  ,"Mecƒnicos / Vendedores")
CLEAN("BANK"    ,"Bancos e Contas Correntes")
CLEAN("CHEQUE"  ,"Taloes de Cheque")
CLEAN("BASCAL"  ,"Tabelas de Base de Redu‡ao de ICMS")
CLEAN("PLANO"   ,"Tabelas de Plano de Contas")
CLEAN("TECNICA" ,"Fichas de Servi‡o da Assistˆncia T‚cnica")
CLEAN("TECNICA2","Itens de Fichas de Servi‡o")
CLEAN("PEDIDO"  ,"Pedidos de Compras e de Vendas")
CLEAN("PEDIDO2" ,"Itens dos Pedidos")
CLEAN("NOTA"    ,"Banco de Notas Fiscais")
CLEAN("CFOP"    ,"Tabelas de C¢digo Fiscal de Opera‡ao")
CLEAN("TRANSP"  ,"Transportadoras")
CLEAN("COTACAO" ,"Cota‡oes de Venda")
CLEAN("COTACAO2","Itens das Cota‡oes de Venda")
/*IF FILE("ACCCOM.DB?")
   ACCCOM->(DBCLOSEAREA())
ENDIF*/
INDICE()
//DBF_ACCCOM()
RETURN(.T.)

FUNCTION CLEAN(BANCO,MENSAGEM)
LOCAL  OLD,TELA,X
MEMVAR CORTEX,DATAPATH
TELA:=SAVESCREEN()
OLD:=SETCOLOR()
@ 24,0 SAY PADC("O Sistema esta limpando o arquivo de "+MENSAGEM,79)
X:=0
DO WHILE X<500
   DBUSEAREA(.F.,,DATAPATH+BANCO,BANCO,.F.)
   IF ! NETERR()
      IF (BANCO) ->(ARQLOCK(5))
         DBSELECTAREA(BANCO)
         PACK         
      ENDIF
      EXIT
   ENDIF
   X++
ENDDO
SETCOLOR(OLD)
RESTSCREEN(,,,,TELA)
RETURN(.T.)