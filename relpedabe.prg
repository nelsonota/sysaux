function relpedabe()
local tela := savescreen(), linha
dbf_pedido()
dbf_2pedido()
dbf_clifor()
dbf_estoque()
if confirma(20,20,"Iniciar verificacao?")
   pedido->(dbsetorder(4), dbgotop())
   linha := array(0)
   do while !pedido->(eof()) .and. empty(pedido->datbai_v)
      if left(pedido->codigo_v,1)=="V"
         aadd(linha, pedido->codigo_v+" "+dtoc(pedido->datemi_v)+" "+if(clifor->(dbsetorder(1), dbseek(pedido->clifor_v)), clifor->nome_v, space(len(clifor->nome_v))))
         pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
         do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
            aadd(linha, "  "+pedido2->item_v+" "+if(estoque->(dbsetorder(1), dbseek(pedido2->item_v)), estoque->nome_v, space(len(estoque->nome_v)))+str(pedido2->qtd_v,5))
            pedido2->(dbskip())
         enddo
         aadd(linha, replicate("=", 80))
      endif
      pedido->(dbskip())
   enddo
   WINDOW(1,0,22,79)
   @2,1 say "Pedido Data     Cliente"
   @3,1 to 3,78
   if len(linha)>0
      ACHOICE(4,1,21,78,LINHA,.T.,"RELACHOFUN")
   else
      aviso("Nao existem pedidos em aberto")
   endif
endif
pedido->(dbclosearea())
pedido2->(dbclosearea())
clifor->(dbclosearea())
estoque->(dbclosearea())
restscreen(,,,,tela)
return nil