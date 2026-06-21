function estoque()
local  tela,op
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
*** variaveis p/ cadatro de estoque
memvar codigo,nome,clifor,valcus,percent,valven,qtd,unidade
memvar familia,localiza,descrev,ipi,reserva,excesso,falta
memvar sittaba,sittabb,valrev,aplica,fabrican,codigof,moeda
memvar valmed,valmax,permed,permax,dtultcus,ultcus,ultped
memvar ultest,dtpencus,pencus,penest,penped,codimp,ncm
tela:=savescreen()
window(22,0,24,54)
window(0,0,22,79)
@ 23,54 say chr(219)
@ 0,0 say "Estoque" color cortit
dbf_config()
dbf_estoque()
dbf_clifor()
dbf_cadimp()
dbf_sittabb()
do while .t.
   setcolor(cortex+","+corbar)
   @ 0,7 say "->Pe‡a atualizada em "+dtoc(estoque->datatu_v) color cortit
   codigo  :=estoque->codigo_v
   codigof :=estoque->codigof_v
   nome    :=estoque->nome_v
   clifor  :=estoque->clifor_v
   aplica  :=estoque->aplica_v
   fabrican:=estoque->fabrican_v
   moeda   :=estoque->moeda_v
   valcus  :=estoque->valcus_v
   percent :=estoque->percent_v
   permed  :=estoque->permed_v
   permax  :=estoque->permax_v
   descrev :=estoque->descrev_v
   valven  :=estoque->valven_v
   valmed  :=estoque->valmed_v
   valmax  :=estoque->valmax_v
   valrev  :=estoque->valrev_v
   qtd     :=estoque->qtd_v
   unidade :=estoque->unidade_v
   sittaba :=estoque->sittaba_v
   sittabb :=strzero(estoque->sittabb_v,2)
   familia :=estoque->familia_v
   localiza:=estoque->localiza_v
   ipi     :=estoque->ipi_v
   reserva :=estoque->reserva_v
   excesso :=estoque->excesso_v
   falta   :=estoque->falta_v
   dtultcus:=estoque->dtultcus_v
   ultcus  :=estoque->ultcus_v
   ultest  :=estoque->ultest_v
   ultped  :=estoque->ultped_v
   dtpencus:=estoque->dtpencus_v
   pencus  :=estoque->pencus_v
   penped  :=estoque->penped_v
   penest  :=estoque->penest_v
   codimp  :=estoque->codimp_v
   ncm     :=estoque->ncm_v
   @ 01,02 say "C¢digo    : " + codigo
   @ 01,27 say "C¢digo Fabricante : "+codigof
   @ 02,02 say "Descri‡ao : " + nome
   @ 03,02 say "Aplica‡ao : " + aplica
   @ 04,02 say "Fabricante: " + fabrican
   @ 05,02 say "Fam¡lia   : "+familia
   @ 05,35 say "Localiza‡ao : "+localiza
   @ 07,1 say padr(" Posi‡ao do Estoque",78) color cortit
   @ 08,02 say "Unid.: " + unidade
   @ 08,12 say "Qtd.Estoque : " + transform(qtd,"@r 999,999.99")
   @ 08,37 say "Reservado : " + transform(reserva,"@r 999,999.99")
   @ 08,60 say "Real : " + transform(qtd-reserva,"@r 999,999.99") color(if((qtd-reserva<falta .and. falta>0).or.qtd-reserva<=0,"gr+/r",if(qtd-reserva>excesso .and. excesso>0,"n/gr*",cortex)))
   @ 09,02 say "Excesso do Item em : " + transform(excesso,"@r 999,999,999.99") color if(qtd-reserva>excesso .and. excesso>0,"n/gr*",cortex)
   @ 09,38 say "Falta do Item em : " + transform(falta,"@r 999,999,999.99") color if(qtd-reserva<falta .and. falta>0,"gr+/r",cortex)
   @ 10,1 say padr(" Valores de Custo",78) color cortit
   if acccom("143",.f.)
      clifor->(dbsetorder(1))
      @ 06,02 say "Fornecedor: " + clifor +" - "+if(clifor->(dbseek(clifor,.f.)),clifor->nome_v,space(50))
      @ 11,02 say "Pen£ltima Compra : " + transform(pencus,"@r 999,999.9999")
      @ 11,34 say "Dt : " + dtoc(dtpencus)
      @ 11,50 say "Estoque : " + transform(penest,"@r 999,999.99")
      @ 11,71 say "P:"+ penped
      @ 12,02 say "Ultima Compra    : " + transform(ultcus,"@r 999,999.9999")
      @ 12,34 say "Dt : " + dtoc(dtultcus)
      @ 12,50 say "Estoque : " + transform(ultest,"@r 999,999.99")
      @ 12,71 say "P:"+ ultped
      @ 13,02 say "Custo M‚dio      : " + transform(valcus,"@r 999,999.9999")
      @ 13,34 say "Moeda (R)$/(U)S$ : " + moeda
      @ 14,1 say padr(" Valores de Venda",78) color cortit
      @ 16,02 say "Percentual Medio : " + transform(permed ,"@r 9,999.99 %")
      @ 15,02 say "Percentual M¡nimo: " + transform(percent,"@r 9,999.99 %")
      @ 17,02 say "Perceltual M ximo: " + transform(permax ,"@r 9,999.99 %")
   ENDIF   
   @ 15,32 say "Valor V.M¡nimo   : " + transform(valven,"@r 999,999,999.99")
   @ 16,32 say "Valor V.M‚dio    : " + transform(valmed,"@r 999,999,999.99")
   @ 17,32 say "Valor V.M ximo   : " + transform(valmax,"@r 999,999,999.99")
   @ 18,02 say "Desconto Revenda : " + transform(descrev,"@r 9,999.99 %")
   @ 18,32 say "Valor p/Revenda  : " + transform(valrev,"@r 999,999,999.99")
   setcolor(cortex+","+corbar)
   @ 23,1  prompt " Incluir "
   @ 23,10 prompt " Buscar "
   @ 23,18 prompt " Alterar "
   @ 23,27 prompt " Apagar "
   @ 23,35 prompt " Aumento "
   @ 23,44 prompt " Impostos "
   menu to op
   do case
      case op=1
         if acccom("141",.t.)
            iestoque()
         endif
      case op=2
         bestoque() 
      case op=3
         if acccom("14_2",.f.) .or. acccom("143",.t.)
            aestoque()
         endif
      case op=4
         if acccom("144",.t.)
            eestoque()
         endif
      case op=5
         if acccom("145",.t.)
            maumento()
         endif
      case op=6
         estoqueimpostos()
      otherwise
         exit
   endcase
enddo
sittabb->(dbclosearea())
cadimp->(dbclosearea())
clifor->(dbclosearea())
estoque->(dbclosearea())
config->(dbclosearea())
restscreen(,,,,tela)
closewin(3,0,20,79)
return(.t.)

function estvalven()
memvar valcus,valven,percent
valven:=valcus+(valcus*(percent/100))
return(.t.)

function estvalmed()
memvar valven,valmed,permed
valmed:=valven+(valven*(permed/100))
return(.t.)

function estvalmax()
memvar valmed,valmax,permax
valmax:=valmed+(valmed*(permax/100))
return(.t.)

function calcrev()
memvar valven,descrev,valrev,valmed
if config->multprcv_v='S'
   valrev:=valmed-(valmed*(descrev/100))
else
   valrev:=valven-(valven*(descrev/100))
endif
return(.t.)

function telaimpostos()
scroll(3,1,21,78,0)
@ 3,1 say padr(" Situacao Tribut ria",78) color cortit
@ 4,02 say "Origem da Mercadoria : "
@ 5,02 say "Grupo de Imposto : "
@ 5,50 say "NCM: "
return

function estoqueimpostos()
local tela := savescreen()
memvar sittaba, sittabb, codimp, ncm
telaimpostos()
@ 4,25 say str(sittaba,1) 
sittaba(sittaba, 4,38)
@ 5,21 say str(codimp,5)+"-"+if(cadimp->(dbseek(codimp)),left(cadimp->nome_v,20),space(20))
@ 5,55 say ncm
inkey(0)
restscreen(,,,,tela)
return .t.