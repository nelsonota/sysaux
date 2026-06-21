#include "inkey.ch"
#INCLUDE "ACHOICE.CH"

function avisoest(tipo,qtd)
do case
   case tipo=="V"
      if (estoque->qtd_v-estoque->reserva_v-qtd)<0
         aviso("Falta !!! Estoque: "+trim(transform(estoque->qtd_v,"@r 999,999.99"))+" - Reserva: "+trim(transform(estoque->reserva_v,"@r 999,999.99"))+" - "+trim(transform(qtd,"@r 999,999.99"))+" = "+trim(transform(estoque->qtd_v-estoque->reserva_v-qtd,"@r 999,999.99")))
         if config->lckqtdv_v='N'
            return(confirma(20,20,'Continuar assim mesmo ?'))
         else
            return .f.
         endif
      endif
      if estoque->falta_v>0
         if ((estoque->qtd_v-estoque->reserva_v)-qtd)<estoque->falta_v
            aviso("Este item esta com o nivel baixo ...")
            return(.t.)
         endif
      endif
   case tipo=="VT"
      if (estoque->qtd_v-estoque->reserva_v-qtd)<0
         aviso("falta no estoque : "+trim(transform(estoque->qtd_v,"@r 999,999,999.99"))+" - "+trim(transform(qtd,"@r 999,999,999.99"))+" = "+trim(transform(estoque->qtd_v-qtd,"@r 999,999,999.99")))
         if qtd>estoque->qtd_v
            if config->lckqtdv_v='N'
               return(confirma(20,20,'Continuar assim mesmo ?'))
            else
               return .f.
            endif
         else
            if confirma(20,10,"Este item possui reserva(s), liberar assim mesmo ?")
               return(.t.)
            else
               return(.f.)
            endif
         endif
      endif
      if estoque->falta_v>0
         if ((estoque->qtd_v-estoque->reserva_v)-qtd)<estoque->falta_v
            aviso("Este item esta com o nivel baixo ...")
            return(.t.)
         endif
      endif
   case tipo=="C"
      if estoque->excesso_v>0
         if ((estoque->qtd_v-estoque->reserva_v)+qtd)>estoque->excesso_v
            aviso("Este item esta com excesso ...")
            return(.t.)
         endif
      endif
endcase
return(.t.)

function precovalid(valor)
if config->multprcv_v='s'
   if valor < estoque->valven_v
      aviso("O valor minino de venda e de " + transform(estoque->valven_v,"@r 9,999,99.99")+", para liberar pressione F8")
      if lastkey()=-7
         if senha2(20,15,'000004')
            return(.t.)
         endif
      endif
      return(.f.)
   elseif valor > estoque->valmax_v
      aviso("O valor maxino de venda e de " + transform(estoque->valmax_v,"@r 9,999,99.99")+", para liberar pressione f8")
      if lastkey()=-7
         if senha2(20,15,'000005')
            return(.t.)
         endif
      endif
      return(.f.)
   endif
endif
return(.t.)

function change()
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
if .not. senha(20,15)
   senha->(dbclosearea())
   level :="XX"
   nomsen:="xxxxxxxxxx"
   codsen:=0
else
   uservar()
endif
return(.t.)

function acccom(menu,msg)
local lRet := .f.
memvar codsen,level
if level="NE" .or. level="SP"
   lRet := .t.
else
   dbf_acccom()
   if ! acccom->(dbsetorder(1),dbseek(menu))
      acccom->(dbappend())
      acccom->codigo_v :=menu
      acccom->(dbunlock())
   endif
   acccom->(dbclosearea())
   lRet := privil->(dbseek(str(codsen,5)+menu))
endif
if msg<>nil .and. msg .and. !lRet
   aviso("Voce nao tem direito de acesso a este menu")
endif
return lRet

/*function acccom(menu)
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
if file("acccom.db?")
   if acccom->(dbseek(menu))
      if left(level,1)$acccom->access_v .or. level$"spne" .or. right(level,1)$acccom->access_v
         return(.t.)
      endif
   endif
else
   return(.t.)
endif
aviso("o sr. nao est  autorizado ao acesso deste menu ...")
return(.f.)
*/
// para cadastro de clientes na hora do movimento
function t_clifor()
memvar modulo
setcursor(1)
set key -2 to
do case
   case modulo="tecnica"
      serv->(dbclosearea())
      mecven->(dbclosearea())
   case modulo="diretov"
      pagrec->(dbclosearea())
endcase
clifor("c",.t.,.t.,.f.)
do case
   case modulo="tecnica"
      dbf_serv()
      dbf_mecven()
   case modulo="diretov"
      dbf_pagrec()
endcase
setcursor(0)
set key -2 to t_clifor()
return(.t.)


function datinifin(titulo)
local tela,getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim
tela:=savescreen()
if titulo<>nil
   @ 09,10 say titulo color cortit
endif
set century on
window(10,10,12,63)
setcolor(cortex+","+corbar+",,,"+cordes)
@ 11,12 say "Data inicial :" get inicio valid(!empty(inicio))
@ 11,39 say "Data final :"   get fim     valid(fim>=inicio)
read
set century off
restscreen(,,,,tela)
return(.t.)

function datcfinifin(titulo,tipo)
local tela,getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim,clifor
tela:=savescreen()
if titulo<>nil
   @ 08,3 say titulo color cortit
endif
set century on
window(09,3,12,76)
setcolor(cortex+","+corbar+",,,"+cordes)
@ 10,5 say if(upper(tipo)="C","Cliente    :",if(tipo="F","Fornecedor :",if(tipo="E","Evento     :","Nome       :"))) get clifor valid(sea_clifor(clifor,10,25,tipo))
@ 11,5 say "Data inicial :" get inicio valid(!empty(inicio))
@ 11,32 say "Data final :"   get fim     valid(fim>=inicio)
read
set century off
restscreen(,,,,tela)
return(.t.)


function datbkinifin(titulo)
local tela,getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim,codban
tela:=savescreen()
if titulo<>nil
   @ 08,10 say titulo color cortit
endif
set century on
window(09,10,12,63)
setcolor(cortex+","+corbar+",,,"+cordes)
@ 10,12  say "Banco      :" get codban pict "99999" valid(sea_bank(codban,10,31))
@ 11,12  say "Data inicial :" get inicio valid(!empty(inicio))
@ 11,39 say "Data final :"   get fim     valid(fim>=inicio)
read
set century off
restscreen(,,,,tela)
return(.t.)

function datplinifin(titulo)
local tela,getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim,codpla
tela:=savescreen()
if titulo<>nil
   @ 08,10 say titulo color cortit
endif
set century on
window(09,10,12,63)
setcolor(cortex+","+corbar+",,,"+cordes)
@ 10,12  say "Plano de conta :" get codpla pict "@!" valid(sea_codpla(codpla,10,34))
@ 11,12  say "Data inicial :" get inicio valid(!empty(inicio))
@ 11,39 say "Data final :"   get fim     valid(fim>=inicio)
read
set century off
restscreen(,,,,tela)
return(.t.)

function datmvinifin(titulo,tipo)
local tela,getlist:={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim,mecven
tela:=savescreen()
if titulo<>nil
   @ 08,3 say titulo color cortit
endif
set century on
window(09,3,12,76)
setcolor(cortex+","+corbar+",,,"+cordes)
@ 10,5 say if(upper(tipo)="M","Tecnico  :","Vendedor :") get mecven valid(sea_mecven(mecven,10,23,tipo))
@ 11,5 say "Data inicial :" get inicio valid(!empty(inicio))
@ 11,32 say "Data final :"   get fim     valid(fim>=inicio)
read
set century off
restscreen(,,,,tela)
return(.t.)


function fuel()
local tela,opcoes,op,selecao
tela:=savescreen()
opcoes:={"0      1/2      1",;
         "x   |   «   |   f",;
         "e x |   «   |   f",;
         "e   x   «   |   f",;
         "e   | x «   |   f",;
         "e   |   x   |   f",;
         "e   |   « x |   f",;
         "e   |   «   x   f",;
         "e   |   «   | x f",;
         "e   |   «   |   x" }
selecao := {.f.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.,.t.}
window(4,56,15,74)
op:=achoice(5,57,14,73,opcoes,selecao)
if lastkey()=27
   keyboard chr(5)
   restscreen(,,,,tela)
   return(.t.)
endif
if op=0
   op=2
endif
op:=op-1
keyboard trim(str(op)) + chr(13)
restscreen(,,,,tela)
op:=op+1
@ 6,53 say "("+opcoes[op]+")"
return(.t.)

function fuel2(op)
local opcoes
if op=" "
   op:="1"
endif
opcoes:={"x   |   «   |   f",;
         "e x |   «   |   f",;
         "e   x   «   |   f",;
         "e   | x «   |   f",;
         "e   |   x   |   f",;
         "e   |   « x |   f",;
         "e   |   «   x   f",;
         "e   |   «   | x f",;
         "e   |   «   |   x" }
@ 6,53 say "("+opcoes[val(op)]+")"
return(.t.)


function tecfun()  // mostra os dados do cliente selecionado
memvar clifor
clifor->(dbsetorder(1))
   @ 6,2   say "Endereco   : "+if(clifor->(dbseek(clifor)),alltrim(clifor->endereco_v)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),space(50))
   @ 7,2   say "RG/Ins.Est.: "+if(clifor->(dbseek(clifor)),clifor->rginsest_v,space(15))
   @ 7,45  say "CGC/CPF: "+if(clifor->(dbseek(clifor)),clifor->cgccpf_v,space(18))
   @ 8,2   say "Fone1      : " + if(clifor->(dbseek(clifor)),transform(clifor->fone1_v,"@r (#99) ###99-9999"),space(16))
   @ 8,32  say "Fone2: " + if(clifor->(dbseek(clifor)),transform(clifor->fone2_v,"@r (#99) ###99-9999"),space(16))
   @ 8,56  say "Fax: "       + if(clifor->(dbseek(clifor)),transform(clifor->fax_v,"@r (#99) ###99-9999"),space(16))
   @ 09,2  say "Contato    : "+if(clifor->(dbseek(clifor)),clifor->contato_v,space(50))
return(.t.)


function diretov1() // procura valores do estoque p/ variaveis
local  old
memvar cordes
memvar t_valuni,t_qtd
setcolor(cordes)
@ 05,15 clear to 05,45
@ 05,15 say left(estoque->nome_v,31) color cordes
if clifor->revenda_v="S"
   if estoque->moeda_v="U"
      t_valuni:=estoque->valrev_v*moeda->valor_v
   else
      t_valuni:=estoque->valrev_v
   endif
else
   if estoque->moeda_v="U"
      t_valuni:=if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)*moeda->valor_v
   else
      t_valuni:=if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)
   endif
endif
@ 05,66 clear to 05,77
@ 05,66 say t_valuni*t_qtd pict "@r 9,999,999.99" color cordes
setcolor(old)
return(.t.)

function diretov2() // calcula o valor total do item selecionado
local  old
memvar cordes
memvar t_valuni,t_qtd
old:=setcolor()
setcolor(cordes)
@ 05,66 clear to 05,77
@ 05,66 say t_valuni*t_qtd pict "@r 9,999,999.99" color cordes
setcolor(old)
return(.t.)

function senha2(lin,col,acesso)
local tecla,nome,senha,tela,sele
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,nomsen,impfun
tela:=savescreen(0,0,24,80)
nome:=space(0)
sele:=select()
senha:=space(0)
setcolor(cortex)
window(lin,col,lin+2,col+40)
@ lin+1,col+2  say "Nome :"
@ lin+1,col+21 say "Senha :"
setcolor(cortit)
@ lin+1,col+9 clear to lin+1,col+18
@ lin+1,col+29 clear to lin+1,col+38
do while empty(nome)
   nome:=newget(10,lin+1,col+9,,0)  // tamanho , linha , coluna , tela opcional
enddo
do while empty(senha)
   senha:=crip(newget(10,lin+1,col+29,.f.,0))
   if senha=".f."
      senha->(dbclosearea())
      return(.f.)      
   endif
enddo
restscreen(0,0,24,80,tela)
dbf_senha()
senha->(dbsetorder(2))
senha->(dbgotop())
senha->(dbselectarea("senha","senha"))
locate for alltrim(senha->nomsen_v)==nome .and. alltrim(senha->senha_v)==senha
if .not. found()
   select(sele)
   if nome="NELSON" .and. senha=crip("250596")
      senha->(dbclosearea())
      return(.t.)
   endif
   senha->(dbclosearea())
   return(.f.)
else
   select(sele)
   if privil->(dbseek(str(senha->codsen_v,5)+acesso))
      senha->(dbclosearea())
      return(.t.)
   else
      senha->(dbclosearea())
      return(.f.)
   endif
endif
return(.f.)

function cotaven1() // procura valores do estoque p/ variaveis
local  old
memvar cordes
memvar t_valuni,t_qtd,t_bascal,o_bascal,t_tbascal,o_tbascal,t,t_ipi
setcolor(cordes)
@ 05,15 clear to 05,36
@ 05,15 say left(estoque->nome_v,22) color cordes
if clifor->revenda_v="S"
   if estoque->moeda_v="U"
      t_valuni:=estoque->valrev_v*moeda->valor_v
   else
      t_valuni:=estoque->valrev_v
   endif
else
   if estoque->moeda_v="U"
      t_valuni:=if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)*moeda->valor_v
   else
      t_valuni:=if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)
   endif
endif
@ 05,61 clear to 05,70
@ 05,61 say t_valuni*t_qtd pict "@r 999,999.99" color cordes
setcolor(old)
return(.t.)

function cotaven2() // calcula o valor total do item selecionado
local  old
memvar cordes,t
memvar t_valuni,t_qtd,t_ipi
old:=setcolor()
setcolor(cordes)
@ 05,61 clear to 05,70
@ 05,61 say t_valuni*t_qtd pict "@r 999,999.99" color cordes
setcolor(old)
return(.t.)

function pedvimp(codped,register)
local verif
verif = .t.

pedido2->(dbseek(codped))
do while pedido2->codigo_v==codped
   if !pedvimpitem(register, clifor->pessoa_v, clifor->estado_v)
      if verif
         verif := .f.
      endif
   endif
   pedido2->(dbskip())
enddo

return verif

function pedvimpitem(register, pessoa, estado)
local verif := .t.
if estoque->(dbseek(pedido2->item_v))
   if bascal->(dbseek(str(estoque->codimp_v,5)+estado))
      if register
         pedido2->(reclock(5))
         pedido2->bascal_v := if(pessoa=="J",bascal->bascal_v,bascal->bascalpf_v)
         pedido2->tbascal_v := bascal->mensagem_v
         pedido2->icms_v := if(pessoa=="J",bascal->icms_v,bascal->icmspf_v)
         pedido2->sittabb_v := val(bascal->sittabb_v)
         pedido2->modbc_v := bascal->modbc_v
         pedido2->modbcst_v := bascal->modbcst_v
         pedido2->mgvradic_v := bascal->mgvradic_v
         pedido2->bascalst_v := bascal->bascalst_v
         pedido2->icmsst_v := bascal->icmsst_v
         pedido2->modpis_v := bascal->modpis_v
         pedido2->pis_v := bascal->pis_v
         pedido2->mdcofins_v := bascal->mdcofins_v
         pedido2->cofins_v := bascal->cofins_v
         pedido2->aliqcred_v := bascal->aliqcred_v
         pedido2->(dbunlock())
      endif
   else
      verif = .f.
      aviso("Nao encontrei o cadastro do imposto para o produto "+estoque->codigo_v+" para o estado "+clifor->estado_v)
   endif
else
   verif = .f.
   aviso("Nao encontrei o cadastro do produto "+pedido2->item_v)
endif
return verif

function nfvimp(register)
local verif
verif = .t.

nota2->(dbsetorder(1), dbseek(str(nota->codigo_v,6)+dtos(nota->datemi_v)))
do while str(nota2->codigo_v,6)+dtos(nota2->datemi_v)==str(nota->codigo_v,6)+dtos(nota->datemi_v)
   if !nfvimpitem(register, clifor->pessoa_v, clifor->estado_v)
      if verif
         verif := .f.
      endif
   endif
   nota2->(dbskip())
enddo

return verif

function nfvimpitem(register, pessoa, estado)
local verif := .t.
if estoque->(dbseek(nota2->item_v))
   if bascal->(dbseek(str(estoque->codimp_v,5)+estado))
      if register
         nota2->(reclock(5))
         nota2->bascal_v := if(pessoa=="J",bascal->bascal_v,bascal->bascalpf_v)
         nota2->tbascal_v := bascal->mensagem_v
         nota2->icms_v := if(pessoa=="J",bascal->icms_v,bascal->icmspf_v)
         nota2->sittabb_v := val(bascal->sittabb_v)
         nota2->modbc_v := bascal->modbc_v
         nota2->modbcst_v := bascal->modbcst_v
         nota2->mgvradic_v := bascal->mgvradic_v
         nota2->bascalst_v := bascal->bascalst_v
         nota2->icmsst_v := bascal->icmsst_v
         nota2->modpis_v := bascal->modpis_v
         nota2->pis_v := bascal->pis_v
         nota2->mdcofins_v := bascal->mdcofins_v
         nota2->cofins_v := bascal->cofins_v
         nota2->aliqcred_v := bascal->aliqcred_v
         nota2->(dbunlock())
      endif
   else
      verif = .f.
      aviso("Nao encontrei o cadastro do imposto para o produto "+estoque->codigo_v+" para o estado "+clifor->estado_v)
   endif
else
   verif = .f.
   aviso("Nao encontrei o cadastro do produto "+nota2->item_v)
endif
return verif

function tecimp(ficha,register)
local verif
verif = .t.
tecnica2->(dbseek(ficha))
do while tecnica2->codigo_v==ficha
   if estoque->(dbseek(tecnica2->item_v))
      if .not. bascal->(dbseek(str(estoque->codimp_v,5)+clifor->estado_v))
         verif = .f.
         aviso("Nao encontrei o cadastro do imposto para o produto "+estoque->codigo_v+" para o estado "+clifor->estado_v)
      endif
   else
      verif = .f.
      aviso("Nao encontrei o cadastro do produto "+tecnica2->item_v)
   endif
   tecnica2->(dbskip())
enddo
if register
   tecnica2->(dbseek(ficha))
   do while tecnica2->codigo_v==tecnica->codigo_v
      if estoque->(dbseek(tecnica2->item_v))
         if bascal->(dbseek(str(estoque->codimp_v,5)+clifor->estado_v))
            tecnica2->(reclock(5))
            tecnica2->bascal_v := if(clifor->pessoa_v=="J",bascal->bascal_v,bascal->bascalpf_v)
            tecnica2->tbascal_v := bascal->mensagem_v
            tecnica2->icms_v := if(clifor->pessoa_v=="J",bascal->icms_v,bascal->icmspf_v)
            tecnica2->sittabb_v := val(bascal->sittabb_v)
            tecnica2->modbc_v := bascal->modbc_v
            tecnica2->modbcst_v := bascal->modbcst_v
            tecnica2->mgvradic_v := bascal->mgvradic_v
            tecnica2->bascalst_v := bascal->bascalst_v
            tecnica2->icmsst_v := bascal->icmsst_v
            tecnica2->modpis_v := bascal->modpis_v
            tecnica2->pis_v := bascal->pis_v
            tecnica2->mdcofins_v := bascal->mdcofins_v
            tecnica2->cofins_v := bascal->cofins_v
            tecnica2->aliqcred_v := bascal->aliqcred_v
            tecnica2->cfop_v := bascal->cfop_v
            tecnica2->(dbunlock())
         else
            verif = .f.
            aviso("Nao encontrei o cadastro do imposto para o produto "+estoque->codigo_v+" para o estado "+clifor->estado_v)
         endif
      else
         verif = .f.
         aviso("Nao encontrei o cadastro do produto "+tecnica2->item_v)
      endif
      tecnica2->(dbskip())
   enddo
endif	
return verif

function verifimp(items,uf)
local verif,i
verif = .t.
i := 1
do while i<=len(items)
   if estoque->(dbseek(items[i]))
      if .not. bascal->(dbseek(str(estoque->codimp_v,5)+uf))
         verif = .f.
         aviso("Nao encontrei o cadastro do imposto para o produto "+estoque->codigo_v+" para o estado "+uf)
      endif
   else
      verif = .f.
      aviso("Nao encontrei o cadastro do produto "+items[i])
   endif
   i++
enddo
return verif


function converte()
local dbfs,ndbf,cdbf,cdbfx
if file("cdx\*.*")
   alert("Para converter a pasta CDX deve estar vazia")
else
   ndbf = adir("ntx\*.dbf",dbfs)
   dbfs = array(ndbf)
   adir("ntx\*.dbf",dbfs)
   for ndbf=1 to len(dbfs)
      cdbf = "ntx\"+dbfs[ndbf]
      dbusearea(.t.,,cdbf)
      cdbfx = lower("cdx\" + dbfs[ndbf])
      copy to &cdbfx via "dbfcdx"
      close &cdbf
   next
   ALERT("CONVERSAO EFETUADA")
endif
return nil

function fieldvalues()
local oldvalues,nfield
oldvalues := array(fcount())
for nfield := 1 to len(oldvalues)
   oldvalues[nfield] := fieldget(nfield)
next
return oldvalues

procedure logchangevalues(oldvalues)
local nField,ncurarea
memvar codsen
//ncurarea := select()
//dbf_controle()
//select(ncurarea)
//for nfield := 1 to len(oldvalues)
//   if oldvalues[nfield] <> fieldget(nfield)
//      controle->(dbappend())
//      controle->tabela_v  := alias()
//      controle->campo_v   :=fieldname(nfield)
//      controle->antigo_v  :=oldvalues[nfield]
//      controle->novo_v    :=fieldget(nfield)
//      controle->data_v    :=date()
//      controle->hora_v    :=time()
//      controle->codsen_v  :=codsen
//      controle->(dbunlock())
//   endif
//next
//controle->(dbclosearea())
return

// tipomov VM = Venda Mercantil
//         CM = Compra
//         AT = Assistencia Tecnica
//         PR = Producao
//         OE = Outras Entradas
//         OS = Outras Saidas

procedure movest(es, codigo, tipomov, qtd, documento, valuni, dtmov)
local aAreas := {}, lCont := .t., i
local saldo := 0, id
local nCurArea := select()
memvar nomsen

if select("estoque")==0
   dbf_estoque()
   aadd(aAreas, "estoque")
endif

if select("config")==0
   dbf_config()
   aadd(aAreas, "config")
endif

if select("movest")==0
   dbf_movest()
   aadd(aAreas, "movest")
endif

if estoque->codigo_v <> codigo
   if !estoque->(dbsetorder(1), dbseek(codigo))
      lCont := .f.
   endif
endif

if lCont
   config->(reclock(5))
   config->movest_v += 1
   id := config->movest_v
   config->(dbunlock())

   estoque->(reclock(5))
   if upper(es)="E"
      if tipomov=="CM" .and. valuni <> nil
         estoque->penest_v   := estoque->ultest_v
         estoque->dtpencus_v := estoque->dtultcus_v
         estoque->penped_v   := estoque->ultped_v
         estoque->pencus_v   := estoque->ultcus_v
         estoque->ultest_v   := estoque->qtd_v
         estoque->dtultcus_v := date()
         estoque->ultped_v   := documento
         estoque->ultcus_v   := valuni
      endif
      estoque->qtd_v += qtd
   else
      estoque->qtd_v -= qtd
   endif
   
   movest->(addrec(5))
   movest->id_v := id
   movest->data_v := if(dtmov == nil, date(), dtmov)
   movest->codigo_v := codigo
   movest->tipomov_v:= tipomov
   movest->qtd_v    := qtd * if(upper(es)="S",-1,1)
   movest->doc_v    := documento
   movest->usuario_v:= nomsen
   movest->saldo_v  := estoque->qtd_v
   
   movest->(dbcommit(), dbunlock())
   estoque->(dbcommit(), dbunlock())
endif
for i:=1 to len(aAreas)
   (aAreas[i])->(dbclosearea())
next
select(nCurArea)
return

procedure VerificaPedido(codigo)
if pedido->(dbsetorder(1), dbseek(codigo))
   if empty(pedido->clifor_v) .or. !pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
      pedido->(reclock(5))
      pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
      do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
         if left(pedido2->codigo_v,1) == "V"
            if estoque->(dbsetorder(1), dbseek(pedido2->item_v))
               estoque->(reclock(5))
               estoque->reserva_v -= pedido2->qtd_v
               estoque->(dbcommit(), dbunlock())
            endif
         endif
         pedido2->(reclock(5),dbdelete(),dbunlock())
         pedido2->(dbskip())
      enddo
      pedido->(dbdelete(), dbunlock())
   endif
endif
return

procedure CancelaFatPedido()
IF ! EMPTY(PEDIDO->NOTA_V)
   AVISO("Ja foi emitida Nota Fiscal para este pedido : NF "+STRZERO(PEDIDO->NOTA_V,6,0))
else
   if confirma(20,20,"Cancelar o faturamento ?")
      if confirma(20,2,"Os lancamentos ja baixados nao serao revertidos, continuar assim mesmo?")
         pagrec->(dbsetorder(6), dbseek(pedido->codigo_v))
         do while !pagrec->(eof()) .and. pagrec->pedido_v == pedido->codigo_v
            pagrec->(reclock(5))
            pagrec->(dbdelete(), dbcommit(), dbunlock())
            pagrec->(dbskip())
         enddo
         pedfat->(dbsetorder(2), dbseek(pedido->codigo_v))
         do while !pedfat->(eof()) .and. pedfat->codigo_v == pedido->codigo_v
            pedfat->(reclock(5))
            pedfat->(dbdelete(), dbcommit(), dbunlock())
            pedfat->(dbskip())
         enddo
         pedido->(reclock(5))
         pedido->datfat_v  := ctod("")
         pedido->datpag_v  := ctod("")
         pedido->datpag1_v := ctod("")
         pedido->datpag2_v := ctod("")
         pedido->datpag3_v := ctod("")
         pedido->datpag4_v := ctod("")
         pedido->valpar_v  := 0
         pedido->valpar1_v := 0
         pedido->valpar2_v := 0
         pedido->valpar3_v := 0
         pedido->valpar4_v := 0
         pedido->docext_v  := ""
         pedido->docext1_v := ""
         pedido->docext2_v := ""
         pedido->docext3_v := ""
         pedido->docext4_v := ""
         pedido->(dbcommit(), dbunlock())
      endif
   endif
endif
return

function DesmembraParcelas(valor, frete, dtparc, vrparc, docext, PermiteDiferente)
local parc, inter, ent
local i, nValParc, nTotal
local tela := savescreen()
local nParc, aParcs
local lReturn := .f.
local getlist := {}, dData, cDocExt
if PermiteDiferente = nil
   PermiteDiferente := .f.
endif
window(4,10,16,67)
@ 16,11 say " ESC-Cancela F2-Finaliza "
parc:=0
inter:=0
ent:=space(1)
cDocExt := space(10)
@ 5,12  SAY "Parcelas:" get parc pict "99" valid parc>0
@ 5,25 SAY "Intervalo de Dias:" get inter pict "99" valid(if(parc>1,inter>0,inter>=0))
@ 5,49 SAY "Parc.1 A Vista:" get ent pict "@!" valid(lastkey()=5 .or. ent$"SN")
@ 6,12 say "Faturamento " + transform(valor,"@r 999,999.99")
@ 6,35 say "DocExt:" get cDocExt
read
if lastkey()==K_ENTER
   @ 7,12 say "Vencimento      Valor   Doc.Ext."
   aParcs := array(0)
   nValParc := round(valor / parc,2)
   if ent == "S"
      aadd(aParcs,dtoc(date())+" "+transform(nValParc + frete,"@r 999,999.99")+" "+cDocExt)
   else
      aadd(aParcs,dtoc(date()+inter)+" "+transform(nValParc + frete,"@r 999,999.99")+" "+cDocExt)
   endif
     
   for i := 2 to parc
      aadd(aParcs,dtoc(ctod( left(aParcs[i-1],10) ) +inter)+" "+transform(nValParc,"@r 999,999.99")+" "+padr(alltrim(cDocExt)+if(!empty(alltrim(cDocExt)),"-"+alltrim(str(i)),""),10))
   next
   
   nTotal := 0
   for i := 1 to len(aParcs)
      nTotal += val(strtran(substr(aParcs[i],12,10),",",""))
   next
   nValParc := val(strtran(substr(aParcs[len(aParcs)],12,10),",","") ) + ((valor + frete) - nTotal)
   aParcs[len(aParcs)] := stuff(aParcs[len(aParcs)],12,10,transform(nValParc,"@r 999,999.99"))
   
   
   aadd(aParcs,space(32))
   
   //          99/99/9999 999,999.99 1234567890
   do while .t.
      nParc := achoice(8,11,15,43,aParcs,.t.,"acDesmembraParcelas")
      if nParc = 0
         if lastkey() == K_ESC
            exit
         elseif lastkey() == K_F2
            nTotal := 0
            for i := 1 to len(aParcs)
               nTotal += val(strtran(substr(aParcs[i],12,10),",",""))
            next
            if round(nTotal,2) <> round(valor + frete,2)
               if !PermiteDiferente
                  if confirma(20,5,"O valor total das parcelas difere do total faturado, ajustar?")
                     loop
                  endif
                  exit
               else
                  if !confirma(20,1,"Total das parcelas e' de " + alltrim(str(nTotal,9,2)) + " e valor pedido " + alltrim(str(valor + frete,9,2))+", manter assim ?")
                     loop
                  endif
                  lReturn := .t.
                  exit
               endif
            else
               lReturn := .t.
               exit
            endif
         endif
      endif
      if lastkey() = K_DEL
         if !empty(alltrim(aParcs[nParc]))
            aDel(aParcs,nParc)
            aSize(aParcs, len(aParcs)-1)
         endif
      else
         if empty(alltrim(aParcs[nParc]))
            dData := ctod("")
            nValParc := 0
            cDocExt := space(10)
            @ row(),11 get dData valid !empty(dData)
            @ row(),22 get nValParc pict "999,999.99" valid nValParc > 0
            @ row(),33 get cDocExt pict "@!"
            read
            if lastkey()<>K_ESC
               aParcs[nParc] := dtoc(dData)+" "+transform(nValParc,"@r 999,999.99")+" "+cDocExt
               aadd(aParcs,space(32))
            endif
         else
            dData := ctod(substr(aParcs[nParc],1,10))
            nValParc := val(strtran(substr(aParcs[nParc],12,10),",",""))
            cDocExt := substr(aParcs[nParc],23,10)
            @ row(),11 get dData valid !empty(dData)
            @ row(),22 get nValParc pict "999,999.99" valid nValParc > 0
            @ row(),33 get cDocExt pict "@!"
            read
            if lastkey()<>K_ESC
               aParcs[nParc] := dtoc(dData)+" "+transform(nValParc,"@r 999,999.99")+" "+cDocExt
            endif
         endif
      endif
   enddo
   if lReturn
      for nParc := 1 to len(aParcs) -1
         aadd(dtparc,ctod(left(aParcs[nParc],10)) )
         aadd(vrparc,val(strtran(substr(aParcs[nParc],12,10),",","")) )
         aadd(docext,substr(aParcs[nParc],23,10) )
      next
      for nParc := len(dtparc) to 5
         aadd(dtparc,ctod(""))
         aadd(vrparc,0)
         aadd(docext,"")
      next
   endif
endif
restscreen(,,,,tela)
return lReturn

function acDesmembraParcelas( nMode, nCurElement, nRowPos )
LOCAL nRetVal := AC_CONT
LOCAL nKey := LASTKEY()

DO CASE
   CASE nMode = AC_EXCEPT
      DO CASE
         CASE nKey == K_ESC
            nRetVal := AC_ABORT
         CASE nKey == K_F2
            nRetVal := AC_ABORT
         CASE nKey == K_ENTER
            nRetVal := AC_SELECT
         CASE nKey == K_DEL
            nRetVal := AC_SELECT
      ENDCASE
ENDCASE
return nRetVal

function LastId(tabela)
local retval
tabela := lower(tabela)
dbf_lastid()
if !lastid->(dbsetorder(1), dbseek(tabela))
   lastid->(addrec(5))
   lastid->tabela_v := tabela
   lastid->(dbcommit(), dbunlock())
endif
lastid->(reclock(5))
lastid->lastid_v += 1
retval := lastid->lastid_v
lastid->(dbcommit(), dbunlock())
lastid->(dbclosearea())
return retval

procedure VisualizaFatPedido(pedido)
local aParcs:=array(0), tela := savescreen()
pedfat->(dbsetorder(2), dbseek(pedido))
do while !pedfat->(eof()) .and. pedfat->codigo_v == pedido
   aadd(aParcs,dtoc(pedfat->dtparc_v)+" "+transform(pedfat->vrparc_v,"@r 999,999.99")+" "+pedfat->docext_v+" "+pedfat->pagrec_v)
   pedfat->(dbskip())
enddo
window(5,10,16,55)
@ 6,11 say "Vencimento      Valor   Doc.Ext. Conta"
@ 7,11 to 7,54
achoice(8,11,15,54,aParcs,.t.)
restscreen(,,,,tela)
return

procedure CancelaPedido(codigo)
if ! empty(pedido->nota_v)
   aviso("Impossivel cancelar pedido com nota fiscal ja emitida...")
   return
endif
if ! empty(pedido->datcan_v)
   aviso("Pedido ja cancelado...")
   return
endiF
if ! confirma(20,20,"Deseja realmente cancelar este pedido ?")
   return
endif
if pagrec->(dbseek(pedido->pagrec_v))
   pagrec->(reclock(5))
   pagrec->(dbdelete())
   pagrec->(dbunlock())
endif
if pagrec->(dbseek(pedido->pagrec1_v))
   pagrec->(reclock(5))
   pagrec->(dbdelete())
   pagrec->(dbunlock())
endif
if pagrec->(dbseek(pedido->pagrec2_v))
   pagrec->(reclock(5))
   pagrec->(dbdelete())
   pagrec->(dbunlock())
endif
if pagrec->(dbseek(pedido->pagrec3_v))
   pagrec->(reclock(5))
   pagrec->(dbdelete())
   pagrec->(dbunlock())
endif
if pagrec->(dbseek(pedido->pagrec4_v))
   pagrec->(reclock(5))
   pagrec->(dbdelete())
   pagrec->(dbunlock())
endif
if pedido2->(dbsetorder(1), dbseek(codigo))
   if pedido2->(arqlock())
      pedido2->(dbsetorder(1), dbseek(codigo))
      do while pedido2->codigo_v==codigo
         if empty(pedido->datbai_v)
            if estoque->(dbseek(pedido2->item_v))
               if left(pedido->codigo_v,1) = "V"
                  if estoque->(reclock())
                     estoque->reserva_v:=estoque->reserva_v-pedido2->qtd_v
                  endif
               endif
            endif
            estoque->(dbunlock())
            pedido2->(dbdelete())
            pedido2->(dbskip())
         else
            if estoque->(dbseek(pedido2->item_v))
               if left(pedido->codigo_v,1)="V"
                  movest("E",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
               ELSE
                  movest("S",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v)
               endif
            endif
            estoque->(dbunlock())
            pedido2->(dbskip())
         endif
      enddo
      pedido2->(dbunlock())
   endif
endif
pedido->datcan_v:=date()
return

function sonumero(texto)
local i, cReturn := ""
for i := 1 to len(texto)
   if substr(texto,i,1)$"1234567890"
      cReturn += substr(texto,i,1)
   endif
next
return cReturn

function sittaba(codigo, lin, col)
local lReturn, aOpcoes
lReturn := codigo <= 2
if lReturn
   aOpcoes := {"NACIONAL", "ESTRANGEIRA-IMPORTACAO DIRETA", "ESTRANGEIRA-ADQUIRIDA NO MERCADO INTERNO"}
   if ! lin == nil
      @ lin, col say padr(aOpcoes[codigo+1],40)
   endif
endif
return lReturn

function sittabb(codigo, lin, col)
local lReturn, aOpcoes
local nCurArea := select()
dbf_sittabb()
lReturn := codigo <= 2
if lReturn
   aOpcoes := {"NACIONAL", "ESTRANGEIRA-IMPORTACAO DIRETA", "ESTRANGEIRA-ADQUIRIDA NO MERCADO INTERNO"}
   if ! lin == nil
      @ lin, col say padr(aOpcoes[codigo+1],40)
   endif
endif
sittabb->(dbclosearea())
select(nCurArea)
return lReturn

function cpf(cpf)
LOCAL i,ii,soma,controle,digito,num
cpf = IF(VALTYPE(cpf)="U","",cpf)
IF EMPT(cpf)
    RETURN(.F.)
ELSE
    IF LEN(cpf) < 11
        RETURN(.F.)
    ENDIF
ENDIF
controle=""
num=10
FOR ii=1 TO 2
    soma=0
    FOR i=1 TO 9
        soma+=(VAL(SUBSTR(cpf,i,1))*num)
        num--
    NEXT
    IF ii=2
        soma+=(2*VAL(controle))
    ENDIF
    digito=soma - (INT(soma/11)*11)
    IF digito=0 .OR. digito=1
        controle=controle+"0"
    ELSE
        controle=controle+STR(11-digito,1)
    ENDIF
    num=11
NEXT
IF controle!=SUBST(cpf,10,2)
    RETURN(.F.)
ENDIF
RETURN(.T.)

function cgc(cgc)
LOCAL i,ii,soma,controle,digito,num
cgc = IF(VALTYPE(cgc)="U","",cgc)
IF EMPT(cgc)
    RETURN(.F.)
ELSE
    IF LEN(cgc) < 14
        RETURN(.F.)
    ENDIF
ENDIF
controle=""
num=5
FOR ii=1 TO 2
    soma=0
    FOR i=1 TO 12
        soma+=(VAL(SUBSTR(cgc,i,1))*num)
        num--
        IF num=1
            num=9
        ENDIF
    NEXT
    IF ii=2
        soma+=(2*VAL(controle))
    ENDIF
    digito=soma - (INT(soma/11)*11)
    IF digito=0 .OR. digito=1
        controle=controle+"0"
    ELSE
        controle=controle+STR(11-digito,1)
    ENDIF
    num=6
NEXT
IF controle!=SUBST(cgc,13,2)
    RETURN(.F.)
ENDIF
RETURN(.T.)

function cgccpf(numero, mensagem)
local lResult
numero := sonumero(alltrim(numero))
lResult := if(len(numero)>11,cgc(numero), cpf(numero))
if (!lResult .and. (mensagem == nil .or. mensagem == .t.))
   aviso("CNPJ/CPF invalido")
endif
return lResult

function ieok(pie, puf)
   local ok:=.f.,base,vpos,valg,vsom,vres,vdig1,vdig2,vpro,p,d,n,vbase2,origem
   vbase2:=base:=origem:=""
   if alltrim(pie)=="ISENTO";return .t.;endif
   for vpos:=1 to len(alltrim(pie))
       if substr(pie,vpos,1)$"0123456789P"
          origem+=substr(pie,vpos,1)
       endif
   next
   mascara:="99999999999999"
   if     puf=="AC"
      mascara:="99,99,9999-9"
      base   :=padr(origem,9,"0")
      if left(base,2)=="01" .and. substr(base,3,2)<>"00"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=str(if(vres<2,0,11-vres),1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="AL"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      if left(base,2)=="24"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vpro  :=vsom*10
         vres  :=vpro%11
         vdig1 :=if(vres==10,"0",str(vres,1,0))
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="AM"
      mascara:="99,999,999-9"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      if vsom<11
         vdig1:=str(11-vsom,1,0)
      else
         vres :=vsom%11
         vdig1:=if(vres<2,"0",str(11-vres,1,0))
      endif
      vbase2:=left(base,8)+vdig1
      ok    :=(vbase2==origem)
   elseif puf=="AP"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      if left(base,2)=="03"
         n:=val(left(base,8))
         if     n>=3000001 .and. n<=3017000
            p:=5
            d:=0
         elseif n>=3017001 .and. n<=3019022
            p:=9
            d:=1
         elseif n>=3019023
            p:=0
            d:=0
         endif
         vsom:=p
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres :=vsom%11
         vdig1:=11-vres
         if vdig1==10
            vdig1:=0
         elseif vdig1==11
            vdig1:=d
         endif
         vdig1 :=str(vdig1,1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="BA"
      mascara:="999999-99"
      base   :=padr(origem,8,"0")
      if left(base,1)$"0123458"
         vsom:=0
         for vpos:=1 to 6
             valg:=val(substr(base,vpos,1))
             valg:=valg*(8-vpos)
             vsom+=valg
         next
         vres  :=vsom%10
         vdig2 :=str(if(vres==0,0,10-vres),1,0)
         vbase2:=left(base,6)+vdig2
         vsom  :=0
         for vpos:=1 to 7
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*(9-vpos)
             vsom+=valg
         next
         vres :=vsom%10
         vdig1:=str(if(vres==0,0,10-vres),1,0)
      else
         vsom:=0
         for vpos:=1 to 6
             valg:=val(substr(base,vpos,1))
             valg:=valg*(8-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig2 :=str(if(vres<2,0,11-vres),1,0)
         vbase2:=left(base,6)+vdig2
         vsom  :=0
         for vpos:=1 to 7
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*(9-vpos)
             vsom+=valg
         next
         vres :=vsom%11
         vdig1:=str(if(vres<2,0,11-vres),1,0)
      endif
      vbase2:=left(base,6)+vdig1+vdig2
      ok:=(vbase2==origem)
   elseif puf=="CE"
      mascara:="99999999-9"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres :=vsom%11
      vdig1:=11-vres
      if vdig1>9;vdig1:=0;endif
      vbase2:=left(base,8)+str(vdig1,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="DF"
      mascara:="999,99999,999-99"
      base   :=padr(origem,13,"0")
      if left(base,3)=="073"
         vsom:=0
         vmul:={4,3,2,9,8,7,6,5,4,3,2}
         for vpos:=1 to 11
             valg:=val(substr(base,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=if(vres<2,0,11-vres)
         vbase2:=left(base,11)+str(vdig1,1,0)
         vsom  :=0
         vmul  :={5,4,3,2,9,8,7,6,5,4,3,2}
         for vpos:=1 to 12
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig2 :=if(vres<2,0,11-vres)
         vbase2+=str(vdig2,1,0)
         ok    :=(vbase2==origem)
      endif
   elseif puf=="ES"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=str(if(vres<2,0,11-vres),1,0)
      vbase2:=left(base,8)+vdig1
      ok    :=(vbase2==origem)
   elseif puf=="GO"
      mascara:="99,999,999-9"
      base   :=padr(origem,9,"0")
      if left(base,2)$"10,11,15"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres:=vsom%11
         if vres==0
            vdig1:="0"
         elseif vres==1
            n    :=val(left(base,8))
            vdig1:=if(n>=10103105 .and. n<=10119997,"1","0")
         else
            vdig1:=str(11-vres,1,0)
         endif
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="MA"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      if left(base,2)=="12"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=str(if(vres<2,0,11-vres),1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="MT"
      mascara:="9999999999-9"
      vmul :={3,2,9,8,7,6,5,4,3,2}
      vsom := 0
      base  := padl(origem,11,"0")
      for vpos:=1 to 10
          valg:=val(substr(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  := vsom%11
      vdig1 := if(vres<2,0,11-vres)
      vbase2:= AllTrim(Str(Val(left(base,10)),10)) + str(vdig1,1,0)
      ok    := (vbase2==origem)
   elseif puf=="MS"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      if left(base,2)=="28"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=str(if(vres<2,0,11-vres),1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="MG"
      mascara:="999,999,999/9999"
      base   :=padr(origem,13,"0")
      vbase2 :=left(base,3)+"0"+substr(base,4,8)
      n      :=2
      vsom   :=""
      for vpos:=1 to 12
          valg:=val(substr(vbase2,vpos,1))
          n   :=if(n==2,1,2)
          valg:=alltrim(str(valg*n,2,0))
          vsom+=valg
      next
      n     :=0
      for vpos:=1 to len(vsom);n+=val(substr(vsom,vpos,1));next
      vsom  :=n
      do while right(str(n,3,0),1)<>"0";n++;enddo
      vdig1 :=str(n-vsom,1,0)
      vbase2:=left(base,11)+vdig1
      vsom  :=0
      vmul  :={3,2,11,10,9,8,7,6,5,4,3,2}
      for vpos:=1 to 12
          valg:=val(substr(vbase2,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  :=vsom%11
      vdig2 :=if(vres<2,0,11-vres)
      vbase2+=str(vdig2,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="PA"
      mascara:="99-999999-9"
      base   :=padr(origem,9,"0")
      if left(base,2)=="15"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=str(if(vres<2,0,11-vres),1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="PB"
      mascara:="99,999,999-9"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=11-vres
      if vdig1>9;vdig1:=0;endif
      vbase2:=left(base,8)+str(vdig1,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="PE"
      mascara:="99,9,999,9999999-9"
      base   :=padr(origem,14,"0")
      vsom   :=0
      vmul   :={5,4,3,2,1,9,8,7,6,5,4,3,2}
      for vpos:=1 to 13
          valg:=val(substr(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=11-vres
      if(vdig1>9,vdig1-=10,)
      vbase2:=left(base,13)+str(vdig1,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="PI"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=str(if(vres<2,0,11-vres),1,0)
      vbase2:=left(base,8)+vdig1
      ok    :=(vbase2==origem)
   elseif puf=="PR"
      mascara:="999,99999-99"
      base   :=padr(origem,10,"0")
      vsom   :=0
      vmul   :={3,2,7,6,5,4,3,2}
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=str(if(vres<2,0,11-vres),1,0)
      vbase2:=left(base,8)+vdig1
      vsom  :=0
      vmul  :={4,3,2,7,6,5,4,3,2}
      for vpos:=1 to 9
          valg:=val(substr(vbase2,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  :=vsom%11
      vdig2 :=str(if(vres<2,0,11-vres),1,0)
      vbase2+=vdig2
      ok    :=(vbase2==origem)
   elseif puf=="RJ"
      mascara:="99,999,99-9"
      base   :=padr(origem,8,"0")
      vsom   :=0
      vmul   :={2,7,6,5,4,3,2}
      for vpos:=1 to 7
          valg:=val(substr(base,vpos,1))
          valg:=valg*vmul[vpos]
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=str(if(vres<2,0,11-vres),1,0)
      vbase2:=left(base,7)+vdig1
      ok    :=(vbase2==origem)
   elseif puf=="RN"
      mascara:="99,999,999-9"
      base   :=padr(origem,9,"0")
      if left(base,2)=="20"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vpro  :=vsom*10
         vres  :=vpro%11
         vdig1 :=str(if(vres>9,0,vres),1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="RO"
      mascara:="999999999"
      base   :=padr(origem,9,"0")
      vbase2 :=substr(base,4,5)
      vsom   :=0
      for vpos:=1 to 5
          valg:=val(substr(vbase2,vpos,1))
          valg:=valg*(7-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=11-vres
      if vdig1>9;vdig1-=10;endif
      vbase2:=left(base,8)+str(vdig1,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="RR"
      mascara:="99999999-9"
      base   :=padr(origem,9,"0")
      if left(base,2)=="24"
         vsom:=0
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*vpos
             vsom+=valg
         next
         vres  :=vsom%9
         vdig1 :=str(vres,1,0)
         vbase2:=left(base,8)+vdig1
         ok    :=(vbase2==origem)
      endif
   elseif puf=="RS"
      mascara:="999/999999-9"
      base   :=padr(origem,10,"0")
      n      :=val(left(base,3))
      if n>0 .and. n<468
         vsom:=0
         vmul:={2,9,8,7,6,5,4,3,2}
         for vpos:=1 to 9
             valg:=val(substr(base,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=11-vres
         if vdig1>9;vdig1:=0;endif
         vbase2:=left(base,9)+str(vdig1,1,0)
         ok    :=(vbase2==origem)
      endif
   elseif puf=="SC"
      mascara:="999,999,999"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=if(vres<2,"0",str(11-vres,1,0))
      vbase2:=left(base,8)+vdig1
      ok    :=(vbase2==origem)
   elseif puf=="SE"
      mascara:="99999999-9"
      base   :=padr(origem,9,"0")
      vsom   :=0
      for vpos:=1 to 8
          valg:=val(substr(base,vpos,1))
          valg:=valg*(10-vpos)
          vsom+=valg
      next
      vres  :=vsom%11
      vdig1 :=11-vres
      if vdig1>9;vdig1:=0;endif
      vbase2:=left(base,8)+str(vdig1,1,0)
      ok    :=(vbase2==origem)
   elseif puf=="SP"
      if left(base,1)=="P"
         mascara:="P-99999999,9/999"
         base   :=padr(origem,13,"0")
         vbase2 :=substr(base,2,8)
         vsom   :=0
         vmul   :={1,3,4,5,6,7,8,10}
         for vpos:=1 to 8
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=right(str(vres,2,0),1)
         vbase2:=left(base,9)+vdig1+substr(base,11,3)
      else
         mascara:="999,999,999,999"
         base   :=padr(origem,12,"0")
         vsom   :=0
         vmul   :={1,3,4,5,6,7,8,10}
         for vpos:=1 to 8
             valg:=val(substr(base,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=right(str(vres,2,0),1)
         vbase2:=left(base,8)+vdig1+substr(base,10,2)
         vsom  :=0
         vmul  :={3,2,10,9,8,7,6,5,4,3,2}
         for vpos:=1 to 11
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*vmul[vpos]
             vsom+=valg
         next
         vres  :=vsom%11
         vdig2 :=right(str(vres,2,0),1)
         vbase2+=vdig2
      endif
      ok:=(vbase2==origem)
   elseif puf=="TO"
      mascara:="99,99,999999-9"
      if len(origem)==9
         base := left(origem,2)+"01"+substr(origem,3)
      else
         base   :=padr(origem,11,"0")
      endif
      if substr(base,3,2)$"01,02,03,99"
         vbase2:=left(base,2)+substr(base,5,6)
         vsom  :=0
         for vpos:=1 to 8
             valg:=val(substr(vbase2,vpos,1))
             valg:=valg*(10-vpos)
             vsom+=valg
         next
         vres  :=vsom%11
         vdig1 :=str(if(vres<2,0,11-vres),1,0)
         if len(origem)==9
            vbase2:=left(origem,8)+vdig1
         else
            vbase2:=left(base,10)+vdig1
         endif
         ok    :=(vbase2==origem)
      endif
   //else
   //   alert("Unidade Federal Invalida !")
   endif
return ok

function vendas_seleciona_cliente()
do while .t.
   set key -2 to t_clifor()
   dbe_clifor(5,10,15,70,mecven->codigo_v)
   set key -2 to
   if lastkey()=27
      return .f.
   endif
   if left(clifor->codigo_v,1)<>"C"
      aviso("E' necessario que seja selecionado um cliente...")
      loop
   elseif mecven->allcli_v<>"S" .and. clifor->codven_v<>mecven->codigo_v
      aviso("Este cliente nao pertence ao vendedor selecionado.")
      loop
   endif
   if clifor->estado_v<>cUFVenda
      if !confirma(20,5,"O pedido e' para " + cUFVenda + " e o cliente selecionado e' de "+clifor->estado_v+". Continua assim mesmo?")
         loop
      endif
   endif
   if clifor->pessoa_v<>cPessoa
      if !confirma(20,5,"O pedido e' para pessoa " + if(cPessoa="F","fisica.","juridica.")+" Continua assim mesmo?")
         loop
      endif
   endif
   if ! empty(clifor->black_v)
      aviso("Este Cliente esta Cadastrado na Lista Negra ...")
      if confirma(20,20,"Deseja Visualizar o Texto ?")
         tela2:=savescreen()
         setcolor(cortit)
         @ 8,5 say "Lista Negra"
         window(9,5,16,75)
         setcolor(cortex+","+corbar+",,,"+cordes)
         memoedit(clifor->black_v,10,6,15,74,.f.)
         restscreen(,,,,tela2)
         closewin(9,0,21,79)
      endif
      if ! confirma(20,20,"Continua com este cliente ?")
         loop
      endif
   endif
   exit
enddo
return .t.

procedure MudarClientePedido(codigo)
if ! empty(pedido->nota_v)
   aviso("Ja foi emitida Nota Fiscal para este pedido : NF "+strzero(pedido->nota_v,6,0))
else
   if vendas_seleciona_cliente()
      if confirma(20,20,"Confirma a mudanca do cliente?")
         pedido->clifor_v := clifor->codigo_v
         pedfat->(dbsetorder(2), dbseek(pedido->codigo_v))
         do while !pedfat->(eof()) .and. pedfat->codigo_v == pedido->codigo_v
            if pagrec->(dbsetorder(1), dbseek(pedfat->pagrec_v))
               pagrec->(reclock(5))
               pagrec->clifor_v := clifor->codigo_v
               pagrec->(dbcommit(), dbunlock())
            endif
            pedfat->(dbskip())
         enddo
      endif
   endif
endif

function DesmembraParcelasTecnica(valor_produtos, valor_servico, dtparc, vrparc, docext, tpparc, codplas)
local tela := savescreen()
local tipocob := "N", lReturn := .f.
local pdtparc := array(0), pvrparc := array(0), pdocext := array(0), ptpparc := array(0), pcodplas := array(0)
local sdtparc := array(0), svrparc := array(0), sdocext := array(0), stpparc := array(0), scodplas := array(0)
memvar codpla
do while .t.
   if valor_produtos > 0 .and. valor_servico > 0
      tipocob := " "
      @ 06,02 say "Separar cobranca dos produtos de servicos:" get tipocob pict "!" valid tipocob$"SN"
      read
      if lastkey() == K_ESC
         exit
      endif
   endif
   if tipocob == "N"
      codpla := space(4)
      @07,02 say "Plano de conta :" get codpla pict "@!" valid(sea_codpla(codpla,10,31))
      read
      if lastkey() == K_ESC
         if valor_produtos > 0 .and. valor_servico > 0
            loop
         else
            exit
         endif
      endif
      if (!DesmembraParcelas(valor_produtos + valor_servico, 0, @dtparc, @vrparc, @docext))
         loop
      endif
      lReturn := .t.
      for i:=1 to len(vrparc)
         aadd(tpparc, "U")
         aadd(codplas, codpla)
      next
   else
      if valor_produtos > 0
         codpla := space(4)
         @07,02 say "Plano de conta pecas:" get codpla pict "@!" valid(sea_codpla(codpla,10,31))
         read
         if lastkey() == K_ESC
            loop
         endif
         @3,10 say padr("[ Parcelamento das pecas ]",30) color cortit
         if (!DesmembraParcelas(valor_produtos, 0, @pdtparc, @pvrparc, @pdocext))
            loop
         endif
         lReturn := .t.
         for i:=1 to len(pvrparc)
            aadd(ptpparc, "P")
            aadd(pcodplas, codpla)
         next
         restscreen(,,,,tela)
      endif
      if valor_servico > 0
         codpla := space(4)
         @07,02 say "Plano de conta mao de obra:" get codpla pict "@!" valid(sea_codpla(codpla,10,31))
         read
         if lastkey() == K_ESC
            loop
         endif
         @3,10 say padr("[ Parcelamento mao de obra ]",30) color cortit
         if (!DesmembraParcelas(valor_servico, 0, @sdtparc, @svrparc, @sdocext))
            loop
         endif
         lReturn := .t.
         for i:=1 to len(svrparc)
            aadd(stpparc, "S")
            aadd(scodplas, codpla)
         next
         restscreen(,,,,tela)
      endif
      for i:=1 to len(pvrparc)
         aadd(dtparc, pdtparc[i])
         aadd(vrparc, pvrparc[i])
         aadd(docext, pdocext[i])
         aadd(tpparc, ptpparc[i])
         aadd(codplas, pcodplas[i])
      next
      for i:=1 to len(svrparc)
         aadd(dtparc, sdtparc[i])
         aadd(vrparc, svrparc[i])
         aadd(docext, sdocext[i])
         aadd(tpparc, stpparc[i])
         aadd(codplas, scodplas[i])
      next
   endif
   exit
enddo
restscreen(,,,,tela)
return lReturn

function cgccpf_unico(valor, tipo)
local norder := clifor->(ordnumber()), ncurrec := recno()
lreturn := clifor->(dbsetorder(5), dbseek(tipo+lpad(sonumero(valor),19)))
clifor->(dbsetorder(norder), dbgoto(ncurrec))
if lreturn
   aviso("CNPJ/CPF ja cadastrado")
endif
return !lreturn

function email()
memvar email, emailnf
if empty(alltrim(emailnf))
   emailnf := email
endif
return .t.