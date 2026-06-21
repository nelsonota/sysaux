function aestoque()
local  getlist:={},codigo2,ultcus,oldvalues,tela
local permiteAlterar
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
*** variaveis p/ cadatro de estoque
memvar codigo,nome,clifor,valcus,percent,valven,qtd,unidade
memvar familia,localiza,ipi,reserva,excesso,falta,descrev
memvar sittaba,valrev,aplica,fabrican,codigof,moeda
memvar valmed,valmax,permed,permax,codimp,ncm
codigo2:=codigo
ultcus := estoque->valcus_v
permiteAlterar := acccom("143",.f.)
do while .t.
   if permiteAlterar
      oldvalues := estoque->(fieldvalues())
      estoque->(dbsetorder(1))
      setcolor(cortex+","+corbar+",,,"+cordes)
      @ 01,14 get codigo   pict "@!" valid(!empty(codigo).and. if(codigo<>codigo2,.not. estoque->(dbseek(codigo)),.t.))
      @ 01,47 get codigof  pict "@!"
      @ 02,14 get nome     pict "@!" valid(lastkey()=5.or.!empty(nome))
      @ 03,14 get aplica   pict "@!"
      @ 04,14 get fabrican pict "@!"
      @ 05,14 get familia  pict "@!s14"
   endif
   if permiteAlterar .or. acccom("14_2",.f.)
      @ 05,49 get localiza pict "@!"
   endif
   if permiteAlterar
      @ 06,14 get clifor   pict "@!" valid(lastkey()=5.or.sea_clifor(clifor,6,23,"f"))
      @ 08,09 get unidade  pict "@!"
      @ 09,23 get excesso  pict "999,999,999.99"
      @ 09,57 get falta    pict "999,999,999.99"
      @ 13,21 get valcus   pict "@r 999,999.9999" valid(estvalven() .and. estvalmed() .and. estvalmax() .and. calcrev())
      @ 13,53 get moeda    pict "@!" valid(moeda$"UR")
      @ 15,21 get percent  pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax() .and. calcrev())
      @ 15,51 get valven   pict "@r 999,999,999.99"
      if config->multprcv_v='s'
         @ 16,21 get permed   pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax())
         @ 16,51 get valmed   pict "@r 999,999,999.99"
         @ 17,21 get permax   pict "@r 9,999.99 %" valid(estvalven() .and. estvalmed() .and. estvalmax())
         @ 17,51 get valmax   pict "@r 999,999,999.99"
      endif
      @ 18,21 get descrev  pict "@r 9,999.99 %" valid(calcrev())
      @ 18,51 get valrev   pict "@r 999,999,999.99"
   endif
   read
   if lastkey()=27
      exit
   endif
   if permiteAlterar
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
   endif
   if confirma(20,20,"confirma altera‡ao no estoque ?")
      estoque->(dbsetorder(1))
      if estoque->(dbseek(codigo2))
         if estoque->(reclock())
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
            estoque->reserva_v := reserva
            estoque->datatu_v  := date()
            estoque->nomsen_v  := nomsen
            estoque->codimp_v  := codimp
            estoque->ncm_v     := ncm
            estoque->(dbunlock())
            estoque->(logchangevalues(oldvalues))
            exit
         endif
      endif
   endif
enddo
return(.t.)