function reestncm()
local  tela,familia,getlist:={},x,linha2,ncm
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar linha,clifor
tela:=savescreen()
dbf_config()
dbf_estoque()
dbf_clifor()
ncm:=space(len(estoque->ncm_v))
do while .t.
   linha:={}
   linha2:={}
   window(10,20,12,55)
   @ 11,22 say "NCM :" get ncm pict "@K!" valid !empty(ncm)
   read
   if lastkey()=27
      exit
   endif
   estoque->(dbsetorder(5))
   estoque->(dbseek(ncm,.t.))
   if .not. alltrim(ncm)$estoque->ncm_v
      aviso("Nenhum registro encontrado...")
      loop
   endif
   x:=0
   do while alltrim(ncm)$estoque->ncm_v
      aadd(linha,estoque->codigo_v+" "+left(estoque->nome_v,31)+" "+left(estoque->fabrican_v,10)+" "+left(estoque->aplica_v,30)+" "+transform(estoque->qtd_v,"@r 99,999.99")+" "+transform(estoque->reserva_v,"@r 99,999.99")+" "+transform(estoque->qtd_v-estoque->reserva_v,"@r 99,999.99")+"   "+LEFT(estoque->localiza_v,8))
      aadd(linha2,estoque->codigo_v+" "+left(estoque->nome_v,35)+" "+estoque->aplica_v)
      aadd(linha2,"        "+"Estoque : "+transform(estoque->qtd_v,"@r 99,999.99")+" "+"Reservado: "+TRANSFORM(ESTOQUE->RESERVA_V,"@R 99,999.99")+" "+"Dispon¡vel:"+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,"@R 99,999.99"))
      x++
      estoque->(dbskip())
   enddo
   window(2,0,23,79)
   @ 3,1 say padc("Itens do Estoque por NCM : "+ALLTRIM(ncm),78) color cortit
   @ 4,1 say padr("C¢digo       Descri‡ao                           Aplica‡ao",78) color cortit
   @ 5,1 to 5,78
   @ 21,1 to 21,78
   @ 22,1 say padr(" "+transform(x,"@r 99,999")+" Produtos",78) color cortit
   achoice(6,1,20,78,linha2,.t.,"relachofun")
   aadd(linha,replicate("-",80))
   aadd(linha," "+transform(x,"@r 99,999")+" Produtos ")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      c_imprel("Relatorio de Itens no Estoque por NCM: " + ncm ,"Codigo       Descricao                       Fabricante Aplicacao                         Estoque Reservado Disponivel Local",52)
   endif
   exit
enddo
config->(dbclosearea())
estoque->(dbclosearea())
clifor->(dbclosearea())
restscreen(,,,,tela)
closewin(10,20,12,54)
return(.t.)