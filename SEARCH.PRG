function sea_clifor(cod,lin,col,opcao,codven)
local nome,getlist:={},tela,oldord
memvar clifor
oldord:=clifor->(dbsetorder())
clifor->(dbsetorder(1))
if opcao=(nil)
   opcao="A"
endif
if clifor->(dbseek(cod))
   clifor->(dbsetorder(oldord))
   do case
      case opcao="f"
         if left(clifor->codigo_v,1)#"F" .and. left(clifor->codigo_v,1)#"E"
            aviso("ê Necess†rio Selecionar Um Fornecedor")
            return(.f.)
         endif
      case opcao="C"
         if left(clifor->codigo_v,1)#"C" .and. left(clifor->codigo_v,1)#"E"
            aviso("ê Necess†rio Selecionar Um Cliente")
            return(.f.)
         else
            if codven<>nil .and. clifor->codven_v<>codven
               aviso("Este cliente nao pertence ao vendedor selecionado.")
               return(.f.)
            endif
         endif
      case opcao="E"
         if left(clifor->codigo_v,1)#"E"
            aviso("ê Necess†rio Selecionar Um Evento")
            return(.f.)
         endif
   endcase
else
   do while .t.
      dbe_clifor(10,5,20,75,codven)
      clifor->(dbclearfil())
      if lastkey()=27
         return(.f.)
      endif
      clifor->(dbsetorder(oldord))
      do case
         case opcao="F"
            if left(clifor->codigo_v,1)#"F" .and. left(clifor->codigo_v,1)#"E"
               aviso("ê Necess†rio Selecionar Um Fornecedor")
               loop
            endif
         case opcao="C"
            if left(clifor->codigo_v,1)#"C" .and. left(clifor->codigo_v,1)#"E"
               aviso("ê Necess†rio Selecionar Um Cliente")
               loop
            else
               if codven<>nil .and. clifor->codven_v<>codven
                  aviso("Este cliente nao pertence ao vendedor selecionado.")
                  return(.f.)
               endif
            endif
         case opcao="E"
            if left(clifor->codigo_v,1)#"E"
               aviso("ê Necess†rio Selecionar Um Evento")
               loop
            endif
      endcase
      exit
   enddo
endif
clifor:=clifor->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say clifor->nome_v
endif
return(.t.)

function sea_codbasc(codbas,lin,col)
memvar codbasc,perbasc
if !bascal->(dbseek(codbas,.f.))
   dbe_bascal(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
perbasc:=bascal->bascal_v
codbasc:=bascal->codigo_v

if lin#(nil).and.col#(nil)
   @ lin,col say perbasc pict "9,999.99 %"
endif
return(.t.)

function sea_codpla(codigo,lin,col,tipo)
local saida
memvar codpla
saida:=0
if plano->(dbseek(codigo))
   do case
      case tipo="+"
         if left(plano->codigo_v,1)#tipo
            aviso("ê Necess†rio Selecionar Uma Conta Para Recebimentos")
            return(.f.)
         endif
      case tipo="-"
         if left(plano->codigo_v,1)#tipo
            aviso("ê Necess†rio Selecionar Uma Conta Para Pagamentos")
            return(.f.)
         endif
      case tipo="="
         if left(plano->codigo_v,1)#tipo
            aviso("ê Necess†rio Selecionar Uma Conta Para Transferància")
            return(.f.)
         endif
   endcase
else
   do while .t.
      dbe_plano(10,5,20,50)
      if lastkey()=27
         return(.f.)
      endif
      do case
         case tipo="+"
            if left(plano->codigo_v,1)#tipo
               aviso("ê Necess†rio Selecionar Uma Conta Para Recebimentos")
               loop
            endif
         case tipo="-"
            if left(plano->codigo_v,1)#tipo
               aviso("ê Necess†rio Selecionar Uma Conta Para Pagamentos")
               loop
            endif
         case tipo="="
            if left(plano->codigo_v,1)#tipo
               aviso("ê Necess†rio Selecionar Uma Conta Para Transferància")
               loop
            endif
      endcase
      exit
   enddo
endif
codpla:=plano->codigo_v
if lin#(nil) .and. col#(nil)
   @ lin,col say plano->nome_v
endif
return(.t.)

function sea_garantia(ficha)
local tela,op,procura,getlist:={}
memvar clifor,garantia,item
tecnica->(dbsetorder(1))
if tecnica->(dbseek(ficha))
   clifor:=tecnica->clifor_v
   item  :=tecnica->item_v
else
   tecnica->(dbsetorder(1))
   dbe_tecnica(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
   garantia:=tecnica->codigo_v
   clifor  :=tecnica->clifor_v
   item    :=tecnica->item_v
endif
return(.t.)

function sea_ficha(cod)
local tela,op,procura,getlist:={}
memvar clifor,ficha
tecnica->(dbsetorder(1))
if !tecnica->(dbseek(cod))
   tecnica->(dbsetorder(1))
   dbe_tecnica(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
   ficha:=tecnica->codigo_v
endif
clifor:=tecnica->clifor_v
return(.t.)

function sea_bank(codigo,lin,col)
memvar codban
if !bank->(dbseek(codigo,.f.))
   dbe_bank(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
codban:=bank->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say bank->nome_v
endif
return(.t.)

function sea_cheque(codigo,banco,opcao)
memvar cheque
if opcao=(nil)
   opcao:="A"
endif
cheque->(dbsetorder(2))
if cheque->(dbseek(codigo))
   if cheque->codban_v#banco
      aviso("N£mero de Cheque Nao Confere Com O Banco")
      return(.f.)
   endif
   if opcao="CAN" .or. opcao="COM"
      if upper(cheque->obs_v)="CANCELADO"
         aviso("Este Cheque Foi Cancelado")
         return(.f.)
      endif
      if !empty(cheque->datbai_v)
            aviso("Este Cheque J† Foi Compensado")
            return(.f.)
      endif
      if empty(cheque->datemi_v) .and. opcao="COM"
         aviso("Este Cheque Nao Foi Emitido")
         return(.f.)
      endif
   endif
   if opcao="EMI"
      if upper(cheque->obs_v)="CANCELADO"
         aviso("Este Cheque Foi Cancelado")
         return(.f.)
      endif
      if !empty(cheque->datbai_v)
            aviso("Este Cheque J† Foi Compensado")
            return(.f.)
      endif
   endif
else
   cheque->(dbsetorder(1))
   cheque->(dbgotop())
   dbselectarea("cheque")
   locate for cheque->codban_v=banco .and. !empty(cheque->datemi_v) .or. cheque->codban_v=banco
   dbe_cheque(10,5,20,75)
   if cheque->codban_v#banco
      aviso("N£mero de Cheque Nao Confere Com O Banco")
      return(.f.)
   endif
   if opcao="CAN" .or. opcao="COM"
      if upper(cheque->obs_v)="CANCELADO"
         aviso("Este Cheque Foi Cancelado")
         return(.f.)
      endif
      if !empty(cheque->datbai_v)
            aviso("Este Cheque J† Foi Compensado")
            return(.f.)
      endif
      if empty(cheque->datemi_v) .and. opcao="COM"
         aviso("Este Cheque Nao Foi Emitido")
         return(.f.)
      endif
   endif
   if opcao="EMI"
      if upper(cheque->obs_v)="CANCELADO"
         aviso("Este Cheque Foi Cancelado")
         return(.f.)
      endif
      if !empty(cheque->datbai_v)
            aviso("Este Cheque J† Foi Compensado")
            return(.f.)
      endif
   endif
   
endif
cheque:=cheque->cheque_v
return(.t.)

function sea_estoque(codigo,lin,col)
local desc,getlist:={},tela,old
memvar item,valuni,cortex,corbar,cordes
old:=setcolor()
if !estoque->(dbseek(codigo))
   tela:=savescreen(0,0,24,80)
   window(10,5,12,71)
   desc:=space(len(estoque->nome_v))
   setcolor(cortex+","+corbar+",,,"+cordes)
   @ 11,7 say "Descriáao :" get desc pict "@!"
   read
   restscreen(0,0,24,80,tela)
   if lastkey()=27
      return(.f.)
   endif
   estoque->(dbsetorder(2))
   estoque->(dbseek(desc,.t.))
   dbe_estoque(10,2,20,77)
   estoque->(dbsetorder(1))
   if lastkey()=27
      return(.f.)
   endif
endif
item  :=estoque->codigo_v
valuni:=estoque->valven_v
if lin#(nil) .and. col#(nil)
   @ lin,col say estoque->nome_v
endif
setcolor(old)
return(.t.)

function sea_mecven(cod,lin,col,opcao)
local nome,getlist:={},tela,oldord
memvar mecven
oldord:=mecven->(dbsetorder())
mecven->(dbsetorder(1))
if opcao=(nil)
   opcao="A"
endif
if mecven->(dbseek(cod))
   mecven->(dbsetorder(oldord))
   do case
      case opcao="M"
         if left(mecven->codigo_v,1)#"M"
            aviso("ê Necess†rio Selecionar Um TÇcnico")
            return(.f.)
         endif
      case opcao="V"
         if left(mecven->codigo_v,1)#"V"
            aviso("ê Necess†rio Selecionar Um Vendedor")
            return(.f.)
         endif
   endcase
else
   nome:=space(len(mecven->nome_v))
   tela:=savescreen(0,0,24,80)
   window(10,5,12,len(nome)+19)
   @ 11,7 say "Nome:" get nome pict "@!"
   read
   restscreen(0,0,24,80,tela)
   if lastkey()=27
      return(.f.)
   endif
   if !empty(nome)
      mecven->(dbsetorder(2))
      mecven->(dbseek(nome,.t.))
   else
      mecven->(dbseek(opcao,.t.))
      mecven->(dbsetorder(2))
   endif
   do while .t.
      dbe_mecven(10,5,20,75)
      if lastkey()=27
         return(.f.)
      endif
      mecven->(dbsetorder(oldord))
      do case
         case opcao="M"
            if left(mecven->codigo_v,1)#"M"
               aviso("ê Necess†rio Selecionar Um TÇcnico")
               return(.f.)
            endif
         case opcao="V"
            if left(mecven->codigo_v,1)#"V"
               aviso("ê Necess†rio Selecionar Um Vendedor")
               return(.f.)
            endif
      endcase
      exit
   enddo
endif
mecven:=mecven->codigo_v
cod   :=mecven->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say mecven->nome_v
endif
return(.t.)


function sea_cfop(codigo,lin,col)
memvar cfop
if !cfop->(dbseek(codigo,.f.))
   dbe_cfop(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
cfop:=cfop->cfop_v
if lin#(nil).and.col#(nil)
   @ lin,col say cfop->mensagem_v
endif
return(.t.)

function sea_midia(codigo,lin,col)
memvar midia
if !midia->(dbseek(codigo,.f.))
   dbe_midia(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
midia:=midia->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say midia->nome_v
endif

return(.t.)

function sea_porta(codigo,lin,col)
memvar codporta
if !porta->(dbseek(codigo,.f.))
   dbe_porta(10,5,20,30)
   if lastkey()=27
      return(.f.)
   endif
endif
codporta:=porta->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say porta->nome_v
endif
return(.t.)


function sea_serv(codigo,lin,col)
memvar serv
if !serv->(dbseek(codigo,.f.))
   dbe_serv(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
serv:=serv->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say serv->nome_v
endif
return(.t.)

function sea_codtran(codigo,lin,col)
memvar codtran
if !transp->(dbseek(codigo,.f.))
   dbe_transp(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
codtran:=transp->codigo_v
if lin#(nil).and.col#(nil)
   @ lin,col say transp->nome_v
endif
return(.t.)

function sea_pedido(codped,tipo,codven)
local op,tela,getlist:={},procura
memvar codigo,clifor,sysven,blqven
pedido->(dbsetorder(1))
if pedido->(dbseek(codigo))
   do case
      case tipo="V"
         if left(pedido->codigo_v,1)#tipo
            aviso("E necessario selecionar um pedido de vendas ...")
            return(.f.)
         endif
         if blqven='S' .and. clifor->codven_v<>sysven
            aviso("Voce nao tem direito de acesso a esse pedido...")
            return(.f.)
         endif
      case tipo="C"
         if left(pedido->codigo_v,1)#tipo
            aviso("E necessario selecionar um pedido de compras ...")
            return(.f.)
         endif
   endcase
else
   do while .t.
      //pedido->(dbsetfilter({|| left(pedido->codigo_v,1)=tipo },"left(pedido->codigo_v,1)=tipo"))
      pedido->(ordscope(0,tipo))
      pedido->(ordscope(1,tipo))
      dbe_pedido(10,5,20,75,codven)
      pedido->(ordscope(0,nil))
      pedido->(ordscope(1,nil))
      //pedido->(dbclearfilter())
      if lastkey()=27
         exit
      endif
      do case
         case tipo="V"
            if left(pedido->codigo_v,1)#tipo
               aviso("E necessario selecionar um pedido de vendas ...")
               loop
            endif
            if blqven='S' .and. clifor->codven_v<>sysven
               aviso("Voce nao tem direito de acesso a esse pedido...")
               return(.f.)
            endif
         case tipo="C"
            if left(pedido->codigo_v,1)#tipo
               aviso("E necessario selecionar um pedido de compras ...")
               loop
            endif
      endcase
      exit
   enddo
   if lastkey()=27
      return(.f.)
   endif
endif
codigo:=pedido->codigo_v
pedido->(dbsetorder(1))
return(.t.)

function sea_nota(cod)
local nCurRec, nQtdNotas
memvar codigo
nota->(dbsetorder(1))
if !nota->(dbseek(str(cod,6)))
   dbe_nota(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
else
   nCurRec := nota->(recno())
   nQtdNotas := 1
   nota->(dbskip())
   do while !nota->(eof()) .and. nota->codigo_v == codigo .and. nQtdNotas == 1
      nQtdNotas++
      nota->(dbskip())
   enddo
   nota->(dbgoto(nCurRec))
   if nQtdNotas>1
      dbe_nota(10,5,20,75)
      if lastkey()=27
         return .f.
      endif
   endif
endif
codigo:=nota->codigo_v
return(.t.)

function sea_prod(cod)
local tela,op,procura,getlist:={}
memvar codigo
prod->(dbsetorder(1))
if !prod->(dbseek(cod))
   dbe_prod(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
codigo:=prod->codigo_v
return(.t.)

function sea_cotacao(codped,tipo)
local op,tela,getlist:={},procura
memvar codigo,clifor
cotacao->(dbsetorder(1))
if !cotacao->(dbseek(codigo))
   do while .t.
      dbe_cotacao(10,5,20,75)
      cotacao->(dbclearfilter())
      if lastkey()=27
         exit
      endif
      exit
   enddo
   if lastkey()=27
      return(.f.)
   endif
endif
codigo:=cotacao->codigo_v
cotacao->(dbsetorder(1))
return(.t.)

function sea_cadimp(codigo,lin,col,tam)
memvar codimp
if !cadimp->(dbseek(codigo,.f.))
   dbe_cadimp(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
codimp:=cadimp->codigo_v
if lin#(nil).and.col#(nil)
   if tam==(nil)
      tam := len(cadimp->nome_v)
   endif
   @ lin,col say left(cadimp->nome_v,tam)
endif
return(.t.)

function sea_cidade(cod)
local tela,op,procura,getlist:={}
memvar cidade
cadcid->(dbsetorder(1))
if !cadcid->(dbseek(cod))
   dbe_cidade(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
cidade:=cadcid->nome_v
return(.t.)

function sea_sittabb(codigo,lin,col,tam)
memvar sittabb
if !sittabb->(dbseek(codigo,.f.))
   dbe_sittabb(10,5,20,75)
   if lastkey()=27
      return(.f.)
   endif
endif
sittabb:=sittabb->codigo_v
if lin#(nil).and.col#(nil)
   if tam==(nil)
      tam := len(sittabb->nome_v)
   endif
   @ lin,col say left(sittabb->nome_v,tam)
endif
return(.t.)

function sea_modbc(codigo,lin,col,tam)
local aTipos := {}
memvar modbc

aadd(aTipos ,{0,"Margem Valor Agregado"})
aadd(aTipos ,{1,"Pauta"})
aadd(aTipos ,{2,"Preco Tabelado Max.(valor)"})
aadd(aTipos ,{3,"Valor da operacao"})

nTipo := ascan(aTipos, {|x| x[1] == codigo})
if nTipo == 0
   codigo := 3
   nTipo := ascan(aTipos, {|x| x[1] == codigo})
endif
if lin#(nil)
   if tam==(nil)
      tam := 26
   endif
   @ lin,col say left(padr(aTipos[nTipo][2],tam),tam)
endif
modbc := codigo
return(.t.)

function sea_modbcst(codigo,lin,col,tam)
local aTipos := {}
memvar modbcst

aadd(aTipos, {0,"Preco tabelado ou maximo sugerido"})
aadd(aTipos, {1,"Lista negativa(valor)"})
aadd(aTipos, {2,"Lista positiva(valor)"})
aadd(aTipos, {3,"Lista neutra(valor)"})
aadd(aTipos, {4,"Margem Valor Agregado(%)"})
aadd(aTipos, {5,"Pauta(valor)"})

nTipo := ascan(aTipos, {|x| x[1] == codigo})
if nTipo == 0
   codigo := 3
   nTipo := ascan(aTipos, {|x| x[1] == codigo})
endif
if lin#(nil)
   if tam ==(nil)
      tam := 33
   endif
   @ lin,col say left(padr(aTipos[nTipo][2],tam),tam)
endif
modbcst := codigo
return(.t.)
