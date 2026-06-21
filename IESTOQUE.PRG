function iestoque()
local  getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
*** variaveis p/ cadatro de estoque
memvar codigo,nome,clifor,valcus,percent,valven,qtd,unidade
memvar familia,localiza,descrev,ipi,reserva,excesso,falta
memvar sittaba,valrev,fabrican,aplica,codigof,moeda
memvar valmed,valmax,permed,permax,codimp
codigo  :=space(len(estoque->codigo_v))
codigof :=space(len(estoque->codigof_v))
nome    :=space(len(estoque->nome_v))
aplica  :=space(len(estoque->aplica_v))
fabrican:=space(len(estoque->fabrican_v))
clifor  :=space(len(estoque->clifor_v))
moeda   :="R"
valcus  :=0
percent :=0
permed  :=0
permax  :=0
valven  :=0
valmed  :=0
valmax  :=0
valrev  :=0
qtd     :=0
unidade :=space(len(estoque->unidade_v))
descrev :=0
ipi     :=0
reserva :=0
excesso :=0
falta   :=0
sittaba :=0
familia :=space(len(estoque->familia_v))
localiza:=space(len(estoque->localiza_v))
codimp  :=0
ncm     :=space(len(estoque->ncm_v))
setcolor(cortex+","+corbar+",,,"+cordes)
do while .t.
   estoque->(dbsetorder(1))
   @ 01,14 get codigo   pict "@!" valid(!empty(codigo).and. ! estoque->(dbseek(codigo)))
   @ 01,47 get codigof  pict "@!"
   @ 02,14 get nome     pict "@!" valid(lastkey()=5.or.!empty(nome))
   @ 03,14 get aplica   pict "@!"
   @ 04,14 get fabrican pict "@!"
   @ 05,14 get familia  pict "@!s14"
   @ 05,49 get localiza pict "@!"
   @ 06,14 get clifor   pict "@!" valid(lastkey()=5.or.sea_clifor(clifor,6,23,"F"))
   @ 08,09 get unidade  pict "@!"

   @ 09,23 get excesso  pict "999,999,999.99"
   @ 09,57 get falta    pict "999,999,999.99"
   @ 13,21 get valcus   pict "@r 999,999.9999" valid(estvalven() .and. estvalmed() .and. estvalmax() .and. calcrev())
   @ 13,53 get moeda    pict "@!" valid(moeda$"UR")
   @ 15,21 get percent  pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax() .and. calcrev())
   @ 15,51 get valven   pict "@r 999,999,999.99"
   if config->multprcv_v="S"
      @ 16,21 get permed   pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax())
      @ 16,51 get valmed   pict "@r 999,999,999.99"
      @ 17,21 get permax   pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax())
      @ 17,51 get valmax   pict "@r 999,999,999.99"
   endif
   @ 18,21 get descrev  pict "@r 9,999.99 %" valid(calcrev())
   @ 18,51 get valrev   pict "@r 999,999,999.99"
   read
   if lastkey()=27
      exit
   elseif lastkey()=18 .or. lastkey()=3
      loop
   endif
   tela := savescreen()
   telaimpostos()
   @ 4,25 get sittaba  pict "9" valid sittaba(sittaba, 4,27)
   @ 5,21 get codimp   pict "99999" valid(lastkey()=5.or.sea_cadimp(codimp,5,27,20))
   @ 5,55 get ncm      pict "@!"
   read
   restscreen(,,,,tela)
   if lastkey()=27
      loop
   endif
   if confirma(20,20,"Confirma Inclusao no Estoque ?")
      if estoque->(addrec())
         estoque->codigo_v  := codigo
         estoque->codigof_v := codigof
         estoque->nome_v    := nome
         estoque->aplica_v  := aplica
         estoque->fabrican_v:= fabrican
         estoque->clifor_v  := clifor
         estoque->qtd_v     := qtd
         estoque->unidade_v := unidade
         estoque->familia_v := familia
         estoque->localiza_v:= localiza
         estoque->moeda_v   := moeda
         estoque->valcus_v  := valcus
         estoque->percent_v := percent
         estoque->valven_v  := valven
         estoque->permed_v  := permed
         estoque->valmed_v  := valmed
         estoque->permax_v  := permax
         estoque->valmax_v  := valmax
         estoque->valrev_v  := valrev
         estoque->descrev_v := descrev
         estoque->sittaba_v := sittaba
         estoque->ipi_v     := ipi
         estoque->excesso_v := excesso
         estoque->falta_v   := falta
         estoque->datatu_v  := date()
         estoque->nomsen_v  := nomsen
         estoque->codimp_v  := codimp
         estoque->ncm_v     := ncm
         estoque->(dbunlock())
         exit
      endif
   endif
enddo
return(.t.)