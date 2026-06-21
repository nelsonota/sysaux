function reestfam(opcao,vc,tipo)
local  tela,familia,getlist:={},x,linha2,totqtd,totcus,totven,fabrican,grupoimposto,lOk,ncm
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar linha,clifor
tela:=savescreen()
if opcao=nil
   opcao:=" "
endif
dbf_config()
dbf_estoque()
dbf_clifor()
dbf_cadimp()
fabrican:=space(len(estoque->fabrican_v))
clifor:=space(len(clifor->codigo_v))
familia:=space(len(estoque->familia_v))
grupoimposto:=0
ncm:=space(len(estoque->ncm_v))
do while .t.
   linha:={}
   linha2:={}
   window(10,20,if(opcao$"FIG",13,12),55)
   @ 11,22 say "Fam¡lia   :" get familia pict "@K!"
   if opcao="F"
      @ 12,22 say "Fornecedor:" get clifor valid(sea_clifor(clifor,,,"F"))
   elseif opcao="I"
      @ 12,22 say "Fabricante:" get fabrican pict "@!"
   elseif opcao="G"
      @ 12,22 say "Grupo Imposto:" get grupoimposto pict "99999" valid(sea_cadimp(grupoimposto))
   endif
   read
   if lastkey()=27
      exit
   endif
   estoque->(dbsetorder(4))
   if empty(alltrim(familia))
      estoque->(dbgotop())
   else
      estoque->(dbseek(familia,.t.))
      if .not. alltrim(familia)$estoque->familia_v
         aviso("Nenhum registro encontrado...")
         loop
      endif
   endif
   x:=0
   totqtd:=0
   totcus:=0
   totven:=0
   do while (empty(alltrim(familia)) .or. alltrim(familia)$estoque->familia_v) .and. x<=4090
      lOk := .t.
      if opcao="F"
         lOk := estoque->clifor_v==clifor
      elseif opcao="I"
         lOk := alltrim(fabrican)$estoque->fabrican_v
      elseif opcao="G"
         lOk := estoque->codimp_v==grupoimposto
      endif
      if lOk
         totqtd:=totqtd+estoque->qtd_v
         totcus:=totcus+estoque->valcus_v*estoque->qtd_v
         totven:=totven+estoque->valven_v*estoque->qtd_v
         if tipo="L"
            aadd(linha,estoque->codigo_v+" "+if(vc="S",left(estoque->nome_v,28),estoque->nome_v)+" "+estoque->fabrican_v+" "+estoque->aplica_v+if(vc="S"," "+transform(estoque->qtd_v,"@r 999")+" "+transform(estoque->valcus_v,"@r 999,999.99")," ")+" "+estoque->moeda_v+"$"+transform(estoque->valven_v,"@r 999,999.99")+if(vc="S"," "+transform(estoque->valrev_v,"@r 99,999.99")+" "," ")+left(estoque->localiza_v,8))
            aadd(linha2,estoque->codigo_v+" "+left(estoque->nome_v,35)+" "+estoque->aplica_v)
            if vc="S"
               aadd(linha2," Fabricante:"+estoque->fabrican_v+" Custo : "+estoque->moeda_v+"$"+transform(estoque->valcus_v,"@r 999,999.99")+" Venda : "+estoque->moeda_v+"$"+transform(estoque->valven_v,"@r 999,999.99"))
            else
               aadd(linha2," Fabricante:"+estoque->fabrican_v+" Venda : "+estoque->moeda_v+"$"+transform(estoque->valven_v,"@r 999,999.99"))
            endif
         else
            aadd(linha,estoque->codigo_v+" "+left(estoque->nome_v,31)+" "+left(estoque->fabrican_v,10)+" "+left(estoque->aplica_v,30)+" "+transform(estoque->qtd_v,"@r 99,999.99")+" "+transform(estoque->reserva_v,"@r 99,999.99")+" "+transform(estoque->qtd_v-estoque->reserva_v,"@r 99,999.99")+"   "+LEFT(estoque->localiza_v,8))
            aadd(linha2,estoque->codigo_v+" "+left(estoque->nome_v,35)+" "+estoque->aplica_v)
            aadd(linha2,"        "+"Estoque : "+transform(estoque->qtd_v,"@r 99,999.99")+" "+"Reservado: "+TRANSFORM(ESTOQUE->RESERVA_V,"@R 99,999.99")+" "+"Dispon¡vel:"+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,"@R 99,999.99"))
         endif
         x++
      endif
      estoque->(dbskip())
   enddo
   if x>4090
      AVISO("Mem¢ria Insuficiente...")
   endif
   window(2,0,23,79)
   @ 3,1 say padc("Itens do Estoque por Fam¡lia : "+ALLTRIM(FAMILIA),78) color cortit
   @ 4,1 say padr("C¢digo       Descri‡ao                           Aplica‡ao",78) color cortit
   @ 5,1 to 5,78
   @ 21,1 to 21,78
   if vc="S"
      @ 22,1 say padr(" "+transform(x,"@r 99,999")+" Produtos "+transform(totqtd,"@r 999,999,999")+" Itens Custo="+transform(totcus,"@r 999,999,999.99")+" Venda="+transform(totven,"@r 999,999,999.99"),78) color cortit
   else
      @ 22,1 say padr(" "+transform(x,"@r 99,999")+" Produtos",78) color cortit
   endif
   achoice(6,1,20,78,linha2,.t.,"relachofun")
   aadd(linha,replicate("-",80))
   if vc="S"
      aadd(linha," "+transform(x,"@r 99,999")+" Produtos "+transform(totqtd,"@r 999,999,999")+" Itens  Custo="+transform(totcus,"@r 999,999,999.99")+" Venda="+transform(totven,"@r 999,999,999.99"))
   else
      aadd(linha," "+transform(x,"@r 99,999")+" Produtos ")
   ENDIF
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      if tipo="L"
         if vc="S"
            c_imprel("Relatorio de Itens no Estoque por Familia","Codigo       Descricao                    Fabricante  Aplicacao                     Qtd      Custo        Venda   Revenda Localiza",52)
         else
            c_imprel("Relatorio de Itens no Estoque por Familia","Codigo       Descricao                                          Fabricante  Aplicacao                             Venda Localiza",52)
         endif
      else
         c_imprel("Relatorio de Itens no Estoque por Familia","Codigo       Descricao                       Fabricante Aplicacao                         Estoque Reservado Disponivel Local",52)
      endif
   endif
   exit
enddo
config->(dbclosearea())
estoque->(dbclosearea())
clifor->(dbclosearea())
cadimp->(dbclosearea())
restscreen(,,,,tela)
closewin(10,20,12,54)
return(.t.)