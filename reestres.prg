function reestres()
local tela := savescreen(), linha
dbf_pedido()
dbf_2pedido()
dbf_clifor()
dbf_estoque()
if confirma(20,20,"Iniciar verificacao?")
   estoque->(dbsetorder(1), dbgotop())
   linha := array(0)
   do while !estoque->(eof())
      if pedido2->(dbsetorder(3), dbseek(estoque->codigo_v))
         if pedido->(dbsetorder(1), dbseek(pedido2->codigo_v)) .and. left(pedido->codigo_v,1)=="V" .and. empty(pedido->datbai_v)
            aadd(linha, "  "+estoque->codigo_v+" "+estoque->nome_v+" "+str(pedido2->qtd_v,5)+pedido2->codigo_v)
         endif
      endif
      estoque->(dbskip())
   enddo
   WINDOW(1,0,22,79)
   @2,1 say "Codigo       Nome                                                 Qtd Pedido"
           //123456789012 12345678901234567890123456789012345678901234567890 12345
   @3,1 to 3,78
   if len(linha)>0
      ACHOICE(4,1,21,78,LINHA,.T.,"RELACHOFUN")
   else
      aviso("Nao existem produtos reservados")
   endif
endif
pedido->(dbclosearea())
pedido2->(dbclosearea())
clifor->(dbclosearea())
estoque->(dbclosearea())
restscreen(,,,,tela)
return nil