function outmov(tipo)
local nQtd, getlist:={}
local tela := savescreen()
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar item
tipo := upper(tipo)
if .not. (tipo$"ES")
   return
endif
dbf_estoque()
dbf_clifor()
window(10,10,13,60)
if tipo == "E"
   @10,11 say "Outras Entradas" color cortit
else
   @10,11 say "Outras Saídas" color cortit
endif
do while .t.
   item := space(len(estoque->codigo_v))
   nQtd := 0
   @ 11,12 say "Codigo:" get item pict "@!" valid(sea_estoque(item))
   @ 12,12 say "Quantidade:" get nQtd pict "9999"
   read
   if lastkey()=27
      exit
   endif
   if confirma(20,20,"Confirma "+if(tipo="E","entrada","saida")+" no estoque ?")
      movest(tipo,item, if(tipo="E","OE","OS"), nQtd, "", estoque->valcus_v)
   endif
enddo
estoque->(dbclosearea())
clifor->(dbclosearea())
restscreen(,,,,tela)
return