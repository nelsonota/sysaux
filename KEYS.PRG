FUNCTION KEYS()
LOCAL TELA,PAGAR,RECEBER,GETLIST:={},DECPADR,AUTVEN,AUTCOM,IMPCVEN
LOCAL QTDITENS,MODPED,ICMS,DESCAPL,FILPR,FILCF,MULTPRCV,LCKQTDV,LCKMAX, nfe, modnf, ambiente, nfs
LOCAL HASH, URLXMIG, msgfisc
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,IMPFUN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(01,0,24,79)
DBF_SENHA()
DBF_CONFIG()
DO WHILE .T.
   IF ! SENHA->(DBSEEK(CODSEN))
      EXIT
   ENDIF
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   PAGAR   :=SENHA->PAGAR_V
   RECEBER :=SENHA->RECEBER_V
   IMPFUN  :=SENHA->IMPFUN_V
   FILPR   :=SENHA->FILPR_V
   FILCF   :=SENHA->FILCF_V
   IMPCVEN :=CONFIG->IMPCVEN_V
   AUTVEN  :=CONFIG->AUTVEN_V
   AUTCOM  :=CONFIG->AUTCOM_V
   QTDITENS:=CONFIG->QTDITENS_V
   MODPED  :=CONFIG->MODPED_V
   ICMS    :=CONFIG->DEFICMS_V
   DESCAPL :=CONFIG->DESCAPL_V
   MULTPRCV:=CONFIG->MULTPRCV_V
   LCKQTDV :=CONFIG->LCKQTDV_V
   LCKMAX  :=CONFIG->LCKMAX_V
   HASH    :=CONFIG->HASH_V
   URLXMIG :=CONFIG->URLXMIG_V
   NFE     := config->nfe_v
   NFS     := config->nfs_v
   tipaut := config->tipaut_v
   modnf := config->modnf_v
   ambiente:=config->ambiente_v
   msgfisc:=config->msgfisc_v
   @ 02,2 SAY "Entrada do Programa :"
   @ 03,3 SAY "Inicializar com Relat¢rio de Contas a Pagar do Dia   (Individual): " GET PAGAR   PICT "@!" VALID(PAGAR$"SN")
   @ 04,3 SAY "Inicializar com Relat¢rio de Contas a Receber do Dia (Individual): " GET RECEBER PICT "@!" VALID(RECEBER$"SN")
   @ 05,2 SAY "Banco de Dados"
   @ 06,3 SAY "Utilizar Precos Minimo e Maximo :" GET MULTPRCV VALID MULTPRCV$'SN' PICT "@!"
   @ 06,39 SAY "Nao vender acima do Preco Maximo:" GET LCKMAX PICT "@!" VALID(LCKMAX$'SN') WHEN MULTPRCV='S'
   @ 07,3 SAY "Filtrar Clientes/Fornecedores   :" GET FILCF VALID FILCF$'SN' PICT "@!"
   @ 07,39 SAY "Filtrar Contas a Pagar/Receber  :" GET FILPR VALID FILCF$'SN' PICT "@!"
   @ 08,2 SAY "Cadastro Autom tico de Contas Futuras por (N)F ou (P)edido " GET TIPAUT PICT "@!" VALID TIPAUT$"NP"
   @ 09,3 SAY "Em Vendas  (S)im (N)ao (P)erguntar : " GET AUTVEN PICT "@K" VALID(AUTVEN$"SNP")
   @ 10,3 SAY "Em Compras (S)im (N)ao (P)erguntar : " GET AUTCOM PICT "@K" VALID(AUTCOM$"SNP")
   @ 11,2 SAY "Impressora Utilizada"
   @ 12,3 SAY "Hewlett Packard (1)  Outras (0)   (Individual) :" GET IMPFUN PICT "9" VALID(IMPFUN>=0.AND.IMPFUN<=1)
   @ 13,2 SAY "Pedidos"
   @ 14,3 SAY "Travar vendas sem qtd em estoque :" GET LCKQTDV PICT "@!" VALID LCKQTDV$"SN"
   @ 15,3 SAY "Quantidade m xima de itens       :" GET QTDITENS PICT "@R 99" VALID QTDITENS>0
   @ 16,3 SAY "Imprimir C¢digo dos Produtos     :" GET IMPCVEN PICT "@!" VALID IMPCVEN$"SN"
   @ 17,3 SAY "Modelo de pedido                 :" GET MODPED PICT "@R 99"
   @ 18,3 SAY "ICMS Padrao                      :" GET ICMS PICT "@R 99.9999"
   @ 19,3 SAY "Imprimir Descri‡ao+Apli‡ao       :" GET DESCAPL PICT "@!" VALID IMPCVEN$"SN"
   @ 20,2 SAY "Hash Xmig" GET HASH
   @ 20,45 SAY "Url" GET URLXMIG pict "@S29"
   @ 21,3 SAY "NFe:" GET NFE PICT "@!" valid nfe$"SN"
   @ 21,10 SAY "NFs:" GET NFS PICT "@!" valid nfs$"SN"
   @ 21,29 say "Layout NF impressa:" get modnf pict "@!"
   @ 21,51 say "1-Producao 2-Homologacao:" get ambiente valid ambiente$"12"
   @ 22,3 say "Msg Fisco:" get msgfisc pict "@s64"
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF CONFIRMA(20,20,"Confirma Altera‡oes ?")
      IF SENHA->(RECLOCK(5))
         SENHA->PAGAR_V  :=PAGAR
         SENHA->RECEBER_V:=RECEBER
         SENHA->IMPFUN_V :=IMPFUN
         SENHA->FILCF_V   :=FILCF
         SENHA->FILPR_V   :=FILPR
         SENHA->(DBUNLOCK())
      ENDIF
      IF CONFIG->(RECLOCK(5))
         CONFIG->AUTVEN_V:=AUTVEN
         CONFIG->AUTCOM_V:=AUTCOM
         CONFIG->IMPCVEN_V:=IMPCVEN
         CONFIG->QTDITENS_V:=QTDITENS
         CONFIG->MODPED_V  :=MODPED
         CONFIG->DEFICMS_V :=ICMS
         CONFIG->DESCAPL_V :=DESCAPL
         CONFIG->MULTPRCV_V:=MULTPRCV
         CONFIG->LCKQTDV_V :=LCKQTDV
         CONFIG->LCKMAX_V  :=LCKMAX
         config->nfe_v     := nfe
         config->nfs_v     := nfs
         config->tipaut_v  := tipaut
         config->ambiente_v:=ambiente
         CONFIG->HASH_V    :=HASH
         CONFIG->URLXMIG_V :=URLXMIG
         CONFIG->msgfisc_v := msgfisc
         IF MULTPRCV='N'
            CONFIG->LCKMAX_V := 'N'
         ENDIF
         CONFIG->(DBCOMMIT(),DBUNLOCK())
      ENDIF
      EXIT
   ENDIF
ENDDO
SENHA->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)