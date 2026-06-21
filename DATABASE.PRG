function dbf_senha()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando senhas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"senha","senha",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"senha")
else
   dbsetindex(datapath+"senha1")
   dbsetindex(datapath+"senha2")
   dbsetindex(datapath+"senha3")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cotacao()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando senhas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cotacao","cotacao",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"cotacao")
else
   dbsetindex(datapath+"cotaca11")
   dbsetindex(datapath+"cotaca12")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_2cotacao()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando senhas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cotacao2","cotacao2",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"cotacao2")
else
   dbsetindex(datapath+"cotaca21")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_config()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando configuracoes ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"config","config",.t.)
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cfgmail()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando configuracoes email...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cfgmail","cfgmail",.t.)
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_clifor()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando cadastro de clientes/fornecedores ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"clifor","clifor",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"clifor")
else
   dbsetindex(datapath+"clifor1")
   dbsetindex(datapath+"clifor2")
   dbsetindex(datapath+"clifor3")
   dbsetindex(datapath+"clifor4")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_porta()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando cadastro de portadores ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"porta","porta",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"porta")
else
   dbsetindex(datapath+"porta1")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_mecven()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando cadastro de mecƒnicos/vendedores ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"mecven","mecven",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"mecven")
   else
      dbsetindex(datapath+"mecven1")
      dbsetindex(datapath+"mecven2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_estoque(lShared)
local  old,tela,y,datapath2
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
datapath2 = getenv("dbfest")
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando estoque ...",80)
for y=0 to 10
   dbusearea(.t.,,if(empty(datapath2),datapath,datapath2)+"estoque","estoque",lShared)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"estoque")
else
*estoque->(dbsetindex(getenv("dbfest")+"estoque1"))
*estoque->(dbsetindex(getenv("dbfest")+"estoque2"))
*estoque->(dbsetindex(getenv("dbfest")+"estoque3"))
*estoque->(dbsetindex(getenv("dbfest")+"estoque4"))
   dbsetindex(datapath+"estoque1")
   dbsetindex(datapath+"estoque2")
   dbsetindex(datapath+"estoque3")
   dbsetindex(datapath+"estoque4")
   dbsetindex(datapath+"estoque5")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)


function dbf_bascal()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando tabelas de aliquota de base de calculo ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"bascal","bascal",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"bascal")
else
   dbsetindex(datapath+"bascal1")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cadimp()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando tabelas de grupo de impostos ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cadimp","cadimp",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"cadimp")
else
   dbsetindex(datapath+"cadimp1")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_bank()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando bancos ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"bank","bank",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"bank")
else
   dbsetindex(datapath+"bank1")
   dbsetindex(datapath+"bank2")
   dbsetindex(datapath+"bank3")
   dbsetindex(datapath+"bank4")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cheque()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando cheques ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cheque","cheque",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"cheque")
else
   dbsetindex(datapath+"cheque1")
   dbsetindex(datapath+"cheque2")
   dbsetindex(datapath+"cheque3")
   dbsetindex(datapath+"cheque4")
   dbsetindex(datapath+"cheque5")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_plano()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando plano de contas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"plano","plano",.t.)
   if !neterr()
      exit
   endif
next y
if "CDX"$upper(datapath)
   dbsetindex(datapath+"plano")
else
   dbsetindex(datapath+"plano1")
endif
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_movi(banco)
local  old,tela,y,nome
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando movimentos di rios ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+banco,banco,.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+banco)
   else
      dbsetindex(datapath+"indi1"+right(banco,3))
      dbsetindex(datapath+"indi2"+right(banco,3))
      dbsetindex(datapath+"indi3"+right(banco,3))
      dbsetindex(datapath+"indi4"+right(banco,3))
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)


function dbf_pagrec()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando contas … pagar/receber ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"pagrec","pagrec",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"pagrec")
   else
      dbsetindex(datapath+"pagrec1")
      dbsetindex(datapath+"pagrec2")
      dbsetindex(datapath+"pagrec3")
      dbsetindex(datapath+"pagrec4")
      dbsetindex(datapath+"pagrec5")
      dbsetindex(datapath+"pagrec6")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_tecnica()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando assistencia tecnica ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"tecnica","tecnica",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"tecnica")
   else
      dbsetindex(datapath+"tecni11")
      dbsetindex(datapath+"tecni12")
      dbsetindex(datapath+"tecni13")
      dbsetindex(datapath+"tecni14")
      dbsetindex(datapath+"tecni15")
      dbsetindex(datapath+"tecni16")
      dbsetindex(datapath+"tecni17")
      dbsetindex(datapath+"tecni18")
   endif
   if !neterr()
      if config->protect_v="s"
         tecnica->(dbsetfilter({|| !empty(tecnica->nota_v).or.empty(tecnica->datsai_v).or.tecnica->datsai_v=date()},"!empty(tecnica->nota_v).or.empty(tecnica->datsai_v).or.tecnica->datsai_v=date()"))
      else
         tecnica->(dbclearfilter())
      endif
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_2tecnica()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando assistencia tecnica ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"tecnica2","tecnica2",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"tecnica2")
   else
      dbsetindex(datapath+"tecni21")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_report()
local nome,campos:={}
memvar codsen
nome:="rpt"+strzero(codsen,5,0)
aadd(campos,{"texto_v","c",78,0 })
if file(nome+".dbf")
   aviso("impossivel emitir relatorio...")
   aviso("existe um usu rio utilizando com esta senha no sistema")
   return(".f.")
endif
dbcreate(nome,campos)
dbusearea(.t.,,nome,nome,.f.)
return(nome)

function dbf_fecha()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando informa‡oes de fechamentos de caixa ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"fecha","fecha",.f.)
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cfop()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando C.F.O.P. ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cfop","cfop",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"cfop")
   else
      dbsetindex(datapath+"cfop1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_midia()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando tabela de m¡dia ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"midia","midia",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"midia")
   else
      dbsetindex(datapath+"midia1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_serv()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando tabela tipos de servi‡o ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"serv","serv",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"serv")
   else
      dbsetindex(datapath+"serv1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_pedido(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando pedidos ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"pedido","pedido",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"pedido")
   else
      dbsetindex(datapath+"pedido11")
      dbsetindex(datapath+"pedido12")
      dbsetindex(datapath+"pedido13")
      dbsetindex(datapath+"pedido14")
      dbsetindex(datapath+"pedido15")
      dbsetindex(datapath+"pedido16")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_2pedido(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando pedidos ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"pedido2","pedido2",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"pedido2")
   else
      dbsetindex(datapath+"pedido21")
      dbsetindex(datapath+"pedido22")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_nota()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando notas fiscais ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"nota","nota",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"nota")
   else
      dbsetindex(datapath+"nota1")
      dbsetindex(datapath+"nota2")
      dbsetindex(datapath+"nota3")
      dbsetindex(datapath+"nota4")
      dbsetindex(datapath+"nota5")
      dbsetindex(datapath+"nota6")
      dbsetindex(datapath+"nota7")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_nota2()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando itens das notas fiscais ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"nota2","nota2",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"nota2")
   else
      dbsetindex(datapath+"nota21")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_transp()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando transportadoras ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"transp","transp",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"transp")
   else
      dbsetindex(datapath+"transp1")
      dbsetindex(datapath+"transp2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cota()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando cota‡oes ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cota","cota",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"cota")
   else
      dbsetindex(datapath+"cota1")
      dbsetindex(datapath+"cota2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_acccom()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando permissoes do sistema ...",80)
for y=0 to 10
   if file(datapath+"acccom.db?")
      dbusearea(.t.,,datapath+"acccom","acccom",.t.)
      if "CDX"$upper(datapath)
         dbsetindex(datapath+"acccom")
      else
         dbsetindex(datapath+"acccom1")
      endif
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_privil()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando permissoes do sistema ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"privil","privil",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"privil")
   else
      dbsetindex(datapath+"privil1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_mala()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando modelo de etiquetas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"mala","mala",.t.)
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_moeda()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando tabela de moedas ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"moeda","moeda",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"moeda")
   else
      dbsetindex(datapath+"moeda1")
   endif
   moeda->(dbgobottom())
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_defmat()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando defini‡oes de material ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"defmat","defmat",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"defmat")
   else
      dbsetindex(datapath+"defmat")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_prod()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando registros de produ‡ao ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"prod","prod",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"prod")
   else
      dbsetindex(datapath+"prod1")
      dbsetindex(datapath+"prod2")
      dbsetindex(datapath+"prod3")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_prod2()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando itens dos registros de produ‡ao ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"prod2","prod2",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"prod2")
   else
      dbsetindex(datapath+"prod21")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_system()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando itens dos registros de produ‡ao ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"system","system",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"system")
   else
      dbsetindex(datapath+"system1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)


function dbf_tmp(tmp,alias)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando temporario ...",80)
for y=0 to 10
   dbusearea(.t.,,tmp,if(alias=nil,"tmp",alias),.f.)
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)

function dbf_controle()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando itens dos registros de produ‡ao ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"controle","controle",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"controle")
   else
      dbsetindex(datapath+"controle1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

return(.t.)

function dbf_movest(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando extrato de movimento ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"movest","movest",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"movest")
   else
      dbsetindex(datapath+"movest1")
      dbsetindex(datapath+"movest2")
      dbsetindex(datapath+"movest3")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_pedfat(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando faturamento de pedido ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"pedfat","pedfat",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"pedfat")
   else
      dbsetindex(datapath+"pedfat1")
      dbsetindex(datapath+"pedfat2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_tecfat(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando faturamento de ficha ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"tecfat","tecfat",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"tecfat")
   else
      dbsetindex(datapath+"tecfat1")
      dbsetindex(datapath+"tecfat2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_lastid(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando Controle de Códigos ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"lastid","lastid",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"lastid")
   else
      dbsetindex(datapath+"lastid1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_cadcid(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando Cidades ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"cadcid","cadcid",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"cadcid")
   else
      dbsetindex(datapath+"cadcid1")
      dbsetindex(datapath+"cadcid2")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_caduf(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando Estados ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"caduf","caduf",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"caduf")
   else
      dbsetindex(datapath+"caduf1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_sittabb(lShared)
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
if lShared == nil
   lShared := .t.
endif
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando Situacoes Tributarias ...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"sittabb","sittabb",lShared)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"sittabb")
   else
      dbsetindex(datapath+"sittabb1")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)

function dbf_nfe()
local  old,tela,y
memvar cortit,cortex,corpar,corbar,cordes,datapath
old:=setcolor()
tela:=savescreen(24,0,24,80)
setcolor(cortit)
@ 24,0 say padc("Acessando nomes de arquivos xml nfe...",80)
for y=0 to 10
   dbusearea(.t.,,datapath+"nfe","nfe",.t.)
   if "CDX"$upper(datapath)
      dbsetindex(datapath+"nfe")
   else
      dbsetindex(datapath+"nfe1")
      dbsetindex(datapath+"nfe2")
      dbsetindex(datapath+"nfe3")
   endif
   if !neterr()
      exit
   endif
next y
restscreen(24,0,24,80,tela)
setcolor(old)
return(.t.)
