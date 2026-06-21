function indice()
local inicio,x,tela
memvar datapath
abrir("system"  ,"codigo_v"  ,"system1" )

abrir("senha"   ,"codsen_v"  ,"senha1"  )
abrir("senha"   ,"nomsen_v"  ,"senha2"  )
abrir("senha"   ,"senha_v"   ,"senha3"  )

abrir("privil"  ,"str(codsen_v,5)+codmen_v","privil1")

abrir("clifor"  ,"codigo_v"  ,"clifor1" )
abrir("clifor"  ,"nome_v"    ,"clifor2" )
abrir("clifor"  ,"fantasia_v","clifor3" ) 
abrir("clifor"  ,"datped_v"  ,"clifor4",,.t. )
abrir("clifor"  ,"left(codigo_v,1)+lpad(sonumero(cgccpf_v),19)","clifor5" ) 
abrir("clifor"  ,"cgccpf_v","clifor6" ) 

abrir("mecven"  ,"codigo_v"  ,"mecven1" )
abrir("mecven"  ,"nome_v"    ,"mecven2" )

abrir("bascal"  ,"str(codimp_v,5)+sigla_v"   ,"bascal1" )

abrir("cfop"    ,"cfop_v"    ,"cfop1")

abrir("midia"   ,"codigo_v"  ,"midia1")

abrir("cadimp"   ,"codigo_v"  ,"cadimp1")

abrir("serv"    ,"codigo_v"  ,"serv1")

abrir("estoque" ,"codigo_v"                   ,"estoque1")
abrir("estoque" ,"nome_v+fabrican_v"          ,"estoque2")
abrir("estoque" ,"clifor_v+nome_v+fabrican_v" ,"estoque3") 
abrir("estoque" ,"familia_v+fabrican_v+nome_v","estoque4")
abrir("estoque" ,"ncm_v+codigo_v"             ,"estoque5")
abrir("estoque" ,"codigof_v"                  ,"estoque6")


abrir("bank"    ,"codigo_v"  ,"bank1"   )
abrir("bank"    ,"nome_v"    ,"bank2"   )
abrir("bank"    ,"conta_v"   ,"bank3"   )
abrir("bank"    ,"agencia_v" ,"bank4"   )

abrir("cheque"  ,"codban_v"  ,"cheque1" )
abrir("cheque"  ,"cheque_v"  ,"cheque2" )
abrir("cheque"  ,"valor_v"   ,"cheque3" )
abrir("cheque"  ,"datemi_v"  ,"cheque4" )
abrir("cheque"  ,"datbai_v"  ,"cheque5" )

abrir("plano"   ,"codigo_v"  ,"plano1"  )

abrir("pagrec"  ,"codigo_v"  ,"pagrec1" )
abrir("pagrec"  ,"clifor_v"  ,"pagrec2" )
abrir("pagrec"  ,"docext_v"  ,"pagrec3" )
abrir("pagrec"  ,"docint_v"  ,"pagrec4" )
abrir("pagrec"  ,"datven_v"  ,"pagrec5" )
abrir("pagrec"  ,"pedido_v"  ,"pagrec6" )


abrir("tecnica" ,"codigo_v"  ,"tecni11" )
abrir("tecnica" ,"clifor_v"  ,"tecni12" )
abrir("tecnica" ,"datent_v"  ,"tecni13" )
abrir("tecnica" ,"datorc_v"  ,"tecni14" )
abrir("tecnica" ,"datapr_v"  ,"tecni15" )
abrir("tecnica" ,"datexe_v"  ,"tecni16" )
abrir("tecnica" ,"datexe2_v" ,"tecni17" )
abrir("tecnica" ,"datsai_v"  ,"tecni18" )

abrir("tecnica2","codigo_v" ,"tecni21" )

abrir("transp"  ,"codigo_v" ,"transp1" )
abrir("transp"  ,"nome_v"   ,"transp2" )

abrir("pedido"  ,"codigo_v" ,"pedido11")
abrir("pedido"  ,"clifor_v" ,"pedido12")
abrir("pedido"  ,"datemi_v" ,"pedido13")
abrir("pedido"  ,"datbai_v" ,"pedido14")
abrir("pedido"  ,"datpag_v" ,"pedido15")
abrir("pedido"  ,"clifor_v+dtos(datbai_v)","pedido16",,.t.)

abrir("pedido2" ,"codigo_v+item_v" ,"pedido21")
abrir("pedido2" ,"item_v"   ,"pedido22")
abrir("pedido2" ,"item_v+codigo_v"   ,"pedido23")

abrir("nota"    ,"str(codigo_v,6)+serie_v" ,"nota1"  )
abrir("nota"    ,"clifor_v" ,"nota2"  )
abrir("nota"    ,"pedido_v" ,"nota3"  )
abrir("nota"    ,"ficha_v"  ,"nota4"  )
abrir("nota"    ,"datemi_v" ,"nota5"  )
abrir("nota"    ,"str(cupom_v,6)+cancela_v"  ,"nota6"  )
abrir("nota"    ,"dtos(datemi_v)+str(codigo_v,6)+serie_v","nota7"  )

abrir("nota2"    ,"str(codigo_v,6)+dtos(datemi_v)" ,"nota21"  )
abrir("nota2"    ,"str(codigo_v,6)+serie_v" ,"nota22"  )
abrir("nota2"    ,"str(codigo_v,6)+dtos(datemi_v)+item_v" ,"nota23"  )


abrir("cota"    ,"clifor_v" ,"cota1"  )
abrir("cota"    ,"item_v"   ,"cota2"  )

abrir("defmat"  ,"item_v"   ,"defmat" )

abrir("prod"    ,"codigo_v" ,"prod1"  )
abrir("prod"    ,"data_v"   ,"prod2"  )
abrir("prod"    ,"mecven_v" ,"prod3"  )

abrir("prod2"   ,"codigo_v" ,"prod21" )

abrir("porta"   ,"codigo_v" ,"porta1" )

abrir("cotacao" ,"codigo_v" ,"cotaca11")
abrir("cotacao" ,"clifor_v+str(codigo_v)","cotaca12")
abrir("cotacao" ,"datemi_v" ,"cotaca13")

abrir("cotacao2","codigo_v" ,"cotaca21")

abrir("moeda","data_v","moeda1")

abrir("movest","dtos(data_v)+codigo_v","movest1")
abrir("movest","codigo_v+dtos(data_v)","movest2")
abrir("movest","codigo_v+dtos(data_v)","movest3",,.t.)
abrir("movest","codigo_v+doc_v+dtos(data_v)","movest4")
abrir("movest","doc_v+codigo_v+dtos(data_v)","movest5")

abrir("controle","tabela_v+campo_v+dtos(data_v)+hora_v+str(codsen_v,5)","controle1")

abrir("lastid","tabela_v","lastid1")

abrir("pedfat","id_v","pedfat1")
abrir("pedfat","codigo_v","pedfat2")

abrir("tecfat","id_v","pedfat1")
abrir("tecfat","codigo_v","pedfat2")


abrir("caduf","uf_v","caduf1")

abrir("cadcid","nome_v+uf_v","cadcid1")
abrir("cadcid","uf_v+nome_v","cadcid2")

abrir("sittabb","codigo_v","sittabb1")

abrir("nfe","arquivo_v","nfe1")
abrir("nfe","datcad_v","nfe2")
abrir("nfe","datenv_v","nfe3")

if file(datapath+"acccom.dbf") .and. ( file(datapath+"acccom.dbt") .or. file(datapath+"acccom.fpt") )
   abrir("acccom"   ,"codigo_v" ,"acccom1")
endif

dbf_config()
inicio:=config->registro_v
if empty(inicio)
   aviso("Este sistema nao est  registrado...")
   return(.f.)
endif
config->(dbclosearea())
x:=0
do while .t.
   if x>=3
      exit
   endif
   if file(datapath+ban_2movi(inicio)+".dbf")
      abrir(ban_2movi(inicio),"clifor_v","indi1"+right(ban_2movi(inicio),3))
      abrir(ban_2movi(inicio),"banco_v" ,"indi2"+right(ban_2movi(inicio),3))
      abrir(ban_2movi(inicio),"datbai_v","indi3"+right(ban_2movi(inicio),3))
      abrir(ban_2movi(inicio),"codpla_v","indi4"+right(ban_2movi(inicio),3))
      x:=0
   else
      x++
   endif
   inicio:=inicio+29
enddo

return(.t.)

function abrir(banco, campo, ntx, condicao, inverter)
local tela,l2,l1,c1,c2,d,indice
memvar cortex,datapath
if (!file(alltrim(datapath+banco) + ".dbf"))
   alert("Ocorreu um Erro, o Sistema nao est  conseguindo encontrar o Banco de Dados " ;
         + banco + ", contate o seu supervisor")
   setcolor(cortex)
   l1:= 0
   l2:= 24
   c1:= 0
   c2:= 79
   do while (.t.)
      @ l1 - 1, c1 - 1 clear to l2 + 1, c2 + 1
      @ l1, c1, l2, c2 box "Û"
      l1++
      l2--
      c1++
      c2--
      if (l1 > 12)
         l1:= 12
      endif
      if (l2 < 12)
         l2:= 12
      endif
      if (c1 == 40)
         exit
      endif
      d:= 0
      do while (d < 200)
         d++
      enddo
   enddo
   set color to
   clear screen
   quit
endif
do while .t.
   dbusearea(.t.,,datapath+banco,banco,.f.)
   if ! neterr()
      if (banco)->(arqlock(5))
         tela:=savescreen(24,0,24,80)
         @ 24,0 say padc( "Indexando " + banco + " pela Chave -> " + campo + " no Indice " + ntx,80)
      *   dbcreateind(ntx,campo,{|| &campo. })
         if "CDX"$upper(datapath)
            indice := lower(datapath+banco)
            if condicao=nil
               if inverter = nil
                  index on &campo. tag (ntx) to &indice
                  *index on &campo. to (ntx)
               else
                  index on &campo. tag (ntx) to &indice descending
                  *index on &campo. to (ntx) descending
               endif
            else
               if inverter=nil
                  index on &campo. tag (ntx) to &indice for &condicao.
                  *index on &campo. to (ntx) for &condicao.
               else
                  index on &campo. tag (ntx) to &indice for &condicao. descending
                  *index on &campo. to (ntx) for &condicao. descending
               endif
            endif
         else
            indice = lower(datapath+ntx)
            if condicao=nil
               if inverter = nil
                  index on &campo. to &indice
               else
                  index on &campo. to &indice descending
               endif
            else
               if inverter=nil
                  index on &campo. to &indice for &condicao.
               else
                  index on &campo. to &indice for &condicao. descending
               endif
            endif
         endif
         dbunlock(banco)
      else
         @ 24,0 say padc("o arquivo de dados nao esta disponivel...",80)
         @ 24,  3 say space(60)
         return .f.
      endif
      restscreen(24,0,24,80,tela)
      dbclosearea(banco)
      exit
   else
      aviso("O Sistema nao conseguiu criar o indice")
      if ! confirma(20,20,"Tentar de Novo ?")
         exit
      endif
   endif
enddo
return .t.
