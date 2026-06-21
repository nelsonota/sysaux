function nfe()
local tela := savescreen()
local nCurRec, nQtdNotas
memvar codigo, level
window(0,0,23,79)
DBF_CONFIG()
DBF_CLIFOR()
DBF_NOTA()
DBF_NOTA2()
DBF_PAGREC()
DBF_PEDIDO()
DBF_2PEDIDO()
dbf_cadcid()
dbf_caduf()
dbf_cfop()
dbf_estoque()
dbf_pedfat()
dbf_tecnica()
dbf_2tecnica()
dbf_tecfat()
dbf_transp()
dbf_bascal()
DO WHILE .T.
   @ 1,1 CLEAR TO 21,78
   CODIGO:=0
   @ 1,2  SAY "Nota      :" GET CODIGO PICT "999999" VALID(SEA_NOTA(CODIGO))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
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
         loop
      endif
   endif
   if nota->cancela_v=="S"
      aviso("Esta nota esta cancelada")
      loop
   endif
   codigo := nota->codigo_v
   if nota->datemi_v == date() .or. level== "NE"
      if confirma(20,20,"Gerar arquivo?")
         if (!empty(alltrim(nota->pedido_v)))
            pedido->(dbsetorder(1), dbseek(nota->pedido_v))
            if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
               loop
            endif
            if ! pedvimp(pedido->codigo_v,.t.)
               loop
            endif
            if ! nfvimp(.t.)
               loop
            endif
         elseif (!empty(alltrim(nota->ficha_v)))
            tecnica->(dbsetorder(1), dbseek(nota->ficha_v))
            if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
               loop
            endif
            if ! tecimp(tecnica->codigo_v,.t.)
               loop
            endif
            if ! nfvimp(.t.)
               loop
            endif
         else
            alert("Dados nao encontrados")
            loop
         endif
         gernfe()
      endif
   else
      aviso("Nao e' permitido gerar arquivo de NF de outro dia")
   endif
enddo
bascal->(dbclosearea())
estoque->(dbclosearea())
cfop->(dbclosearea())
caduf->(dbclosearea())
cadcid->(dbclosearea())
pedido2->(dbclosearea())
pedido->(dbclosearea())
pagrec->(dbclosearea())
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
NOTA->(DBCLOSEAREA())
nota2->(dbclosearea())
pedfat->(dbclosearea())
tecnica->(dbclosearea())
tecnica2->(dbclosearea())
tecfat->(dbclosearea())
transp->(dbclosearea())
closewin(0,0,23,79)
restscreen(,,,,tela)
return

function gernfe(nota, datemi)
return gernfe4(nota, datemi)

function gernfe1(nota, datemi)
local nHandle
local terminador := chr(13)+chr(10)
local nBaseDeCalculoICMS, nValorICMS, cImposto, parc
local nTotBC, nTotICMS, nTotBCST, nValorICMSST, nTotICMSST, nTotal,nTotalFrete, frete
local nBaseDeCalculoPIS, nValorPIS, nTotPIS, nBaseDeCalculoCOFINS, nValorCOFINS, nTotCOFINS
local message, cMessage, nTBascal, cgccpf, cgccpf_cliente, cFaturamento
message := array(0)
if ! nota->codigo_v == nota .and. nota->datemi_v == datemi
   if !nota->(dbsetorder(1), dbseek(str(nota,6)+"0"))
      return .f.
   endif
endif
if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
   return .f.
endif
cgccpf_cliente := sonumero(clifor->cgccpf_v)
nHandle := fcreate("nfe/nf"+strzero(nota->codigo_v,6,0)+".txt")
fwrite(nHandle, "NOTA FISCAL"+;
                "|1"+terminador);

fwrite(nHandle, "A"+;
                "|1.10"+;
                "|NFe"+;
                terminador);

fwrite(nHandle, "B"+;
                "|"+if(caduf->(dbsetorder(1), dbseek( decrip(config->estado_v) )), caduf->ibge_v,"")+;
                "|"+;
                "|"+alltrim(nota->natoper_v)+;
                "|"+if(nota->datemi_v<>nota->datpar1_v .or. !empty(nota->datpar2_v), "1", "0")+;
                "|55"+;
                "|0"+;
                "|"+alltrim(str(nota->codigo_v))+;
                "|"+transform(dtos(nota->datemi_v),"@r9999-99-99")+;
                "|"+transform(dtos(nota->datsai_v),"@r9999-99-99")+;
                "|1"+;
                "|"+if(cadcid->(dbsetorder(1), dbseek(decrip(config->cidade_v)+decrip(config->estado_v)) ), cadcid->ibge_v,"")+;
                "|1"+;
                "|1"+;
                "|"+;
                "|"+config->ambiente_v+;       // 1-Produção  2-Homologação
                "|1"+;
                "|3"+;
                "|1.4.1"+;
                terminador)

fwrite(nHandle, "C"+;
                "|"+alltrim(decrip( config->nome_v ))+;
                "|"+;
                "|"+sonumero( decrip(config->insest_v) )+;
                "|"+;
                "|"+;
                "|"+;
                terminador)

fwrite(nHandle, "C02"+;
                "|"+sonumero( decrip(config->cgc_v) )+;
                terminador)

fwrite(nHandle, "C05"+;
                "|"+alltrim(decrip(config->endereco_v))+;
                "|"+alltrim(decrip(config->numero_v))+;
                "|"+alltrim(decrip(config->complem_v))+;
                "|"+alltrim(decrip(config->bairro_v))+;
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(decrip(config->cidade_v))),cadcid->ibge_v,""))+;
                "|"+alltrim(decrip(config->cidade_v))+;
                "|"+decrip(config->estado_v)+;
                "|"+alltrim(decrip(config->cep_v))+;
                "|1058"+;
                "|Brasil"+;
                "|"+trataFone(decrip(config->fone1_v))+;
                terminador)

fwrite(nHandle, "E"+;
                "|"+alltrim(clifor->nome_v)+;
                "|"+sonumero(if(len(cgccpf_cliente)>11,clifor->rginsest_v,""))+;
                "|"+alltrim(sonumero(clifor->inssuf_v))+;
                terminador)
if len(cgccpf_cliente)>11
   fwrite(nHandle, "E02"+;
                   "|"+cgccpf_cliente+;
                   terminador)
else
   fwrite(nHandle, "E03"+;
                   "|"+cgccpf_cliente+;
                   terminador)
endif

fwrite(nHandle, "E05"+;
                "|"+alltrim(clifor->endereco_v)+;
                "|"+alltrim(clifor->numero_v)+;
                "|"+alltrim(clifor->complem_v)+;
                "|"+alltrim(clifor->bairro_v)+;
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;
                "|"+alltrim(clifor->cidade_v)+;
                "|"+clifor->estado_v+;
                "|"+clifor->cep_v+;
                "|1058"+;
                "|Brasil"+;
                "|"+trataFone(clifor->fone1_v)+;
                terminador)

nota2->(dbsetorder(1), dbseek( str(nota->codigo_v)+dtos(nota->datemi_v) ))
nH := 0
nTotBC := 0
nTotICMS := 0
nTotBCST := 0
nTotICMSST := 0
nTotal := 0
nTotalFrete := 0
nTotPIS := 0
nTotCOFINS := 0
do while !nota2->(eof()) .and. nota2->codigo_v == nota->codigo_v .and. nota2->datemi_v == nota->datemi_v
   if !empty(alltrim(nota2->tbascal_v)) .and. ascan(message, nota2->tbascal_v) < 1
      aadd(message, nota2->tbascal_v)
   endif
   nH++
   fwrite(nHandle, "H"+;
                   "|"+alltrim(str(nH,3))+;
                   "|"+alltrim(nota2->tbascal_v)+terminador)
   fwrite(nHandle, "I"+;
                   "|"+alltrim(nota2->item_v)+;
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),left(estoque->nome_v,43),""))+;
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ncm_v,""))+;
                   "|"+;
                   "|"+;
                   "|"+alltrim(sonumero(nota2->cfop_v))+;
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;
                   "|"+numerostring(nota2->qtd_v,12,4)+;
                   "|"+numerostring(nota2->valuni_v,16,4)+;
                   "|"+numerostring(nota2->valuni_v*nota2->qtd_v,15,2)+;
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;
                   "|"+numerostring(nota2->qtd_v,12,4)+;
                   "|"+numerostring(nota2->valuni_v,16,4)+;
                   "|"+numerostring(nota2->frete_v,15,2,.t.)+;
                   "|"+numerostring(0,15,2,.t.)+;
                   "|"+numerostring(0,15,2,.t.)+;
                   terminador)
   nBaseDeCalculoICMS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v) * (nota2->bascal_v/100)
   nValorICMS := nBaseDeCalculoICMS * (nota2->icms_v / 100)
   nBasedeCalculoICMSST := 0
   if (nota2->bascalst_v/100 > 0)
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (1 + (nota2->mgvradic_v/100))
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (nota2->bascalst_v/100)
   endif
   nValorICMSST := nBaseDeCalculoICMSST * (nota2->icmsst_v / 100)
   
   nBaseDeCalculoPIS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorPIS := nBaseDeCalculoPIS * (nota2->pis_v/100)
   nBaseDeCalculoCOFINS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorCOFINS := nBaseDeCalculoCOFINS * (nota2->cofins_v/100)
   
   nTotBC += nBaseDeCalculoICMS
   nTotICMS += nValorICMS
   nTotBCST += nBaseDeCalculoICMSST
   nTotICMSST += nValorICMSST
   nTotal += (nota2->valuni_v*nota2->qtd_v)
   nTotalFrete += nota2->frete_v
   nTotPIS += nValorPIS
   nTotCOFINS += nValorCOFINS
   
   if nota2->sittabb_v == 00
      cImposto := "N02"
   elseif nota2->sittabb_v == 10
      cImposto := "N03"
   elseif nota2->sittabb_v == 20
      cImposto := "N04"
   elseif nota2->sittabb_v == 30
      cImposto := "N05"
   elseif nota2->sittabb_v == 40
      cImposto := "N06"
   elseif nota2->sittabb_v == 41
      cImposto := "N06"
   elseif nota2->sittabb_v == 51
      cImposto := "N07"
   elseif nota2->sittabb_v == 60
      cImposto := "N08"
   elseif nota2->sittabb_v == 70
      cImposto := "N09"
   elseif nota2->sittabb_v == 90
      cImposto := "N10"
   endif
   
   cImposto += "|"+strzero(nota2->sittaba_v,1)+;       // Origem da Mercadoria
               "|"+strzero(nota2->sittabb_v,2)         // Tributacao do ICMS
               
   if strzero(nota2->sittabb_v,2)$"00,10,20,30,51,70,90"
      cImposto += "|3"                                 // Modalidade de determinacao da BC do ICMS
   endif
   
   if strzero(nota2->sittabb_v,2)$"20,51,70,90"
      cImposto += "|"+numerostring(nota2->bascal_v,6,2)       // Percentual da reducao de BC
   endif
   
   if strzero(nota2->sittabb_v,2)$"00,10,20,51,70,90"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,2)$"10,30,70,90"
      cImposto += "|0"+;                                  // Modalidade de determinacao da BC do ICMS ST
                  "|"+numerostring(nota2->mgvradic_v,6,2,.t.) // Percentual da margem de valor adicionado do ICMS ST
   endif
   
   if strzero(nota2->sittabb_v,2)$"10,30,70,90"
      cImposto += "|"+numerostring(nota2->bascalst_v,6,2,.t.) // Percentual da reducao da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,2)$"10,30,60,70,90" 
      cImposto += "|"+numerostring(nBaseDeCalculoICMSST,15,2) // Valor da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,2)$"10,30,70,90"
      cImposto += "|"+numerostring(nota2->icmsst_v,6,2)    // Aliquota do ICMS ST
   endif
   if strzero(nota2->sittabb_v,2)$"10,30,60,70,90"
      cImposto += "|"+numerostring(nValorICMSST,15,2)      // Valor do ICMS ST
   endif
   
   cImposto += terminador
   fwrite(nHandle, "M|"+terminador)
   fwrite(nHandle, "N|"+terminador)
   fwrite(nHandle, cImposto)
   
   fwrite(nHandle, "Q|"+terminador)
   
   cImposto := ""
   if nota2->modpis_v $ "01,02"
      cImposto := "Q02"
   endif
   if nota2->modpis_v $ "03"
      cImposto := "Q03"
   endif
   if nota2->modpis_v $ "04,06,07,08,09"
      cImposto := "Q04"
   endif
   if nota2->modpis_v $ "99"
      cImposto := "Q05"
   endif
   cImposto += "|"+nota2->modpis_v
   if nota2->modpis_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoPIS,14,2)
      cImposto += "|"+numerostring(nota2->pis_v,6,2)
   endif
   if nota2->modpis_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorPIS,14,2)
   endif

   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->modpis_v $ "99"
      cImposto := "Q07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   
   fwrite(nHandle, "S|"+terminador)
   cImposto := ""
   if nota2->mdcofins_v $ "01,02"
      cImposto := "S02"
   endif
   if nota2->mdcofins_v $ "03"
      cImposto := "S03"
   endif
   if nota2->mdcofins_v $ "04,06,07,08,09"
      cImposto := "S04"
   endif
   if nota2->mdcofins_v $ "99"
      cImposto := "S05"
   endif
   cImposto += "|"+nota2->mdcofins_v
   if nota2->mdcofins_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoCOFINS,14,2)
      cImposto += "|"+numerostring(nota2->cofins_v,6,2)
   endif
   if nota2->mdcofins_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorCOFINS,14,2)
   endif
   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->mdcofins_v $ "99"
      cImposto := "S07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   nota2->(dbskip())
enddo
//nTotBC += nota->valfrete_v
//nTotICMS += nota->valfrete_v * nota->icmfrete_v / 100
fwrite(nHandle, "W|"+terminador)
fwrite(nHandle, "W02"+;
                "|"+numerostring(nTotBC,14,2)+;
                "|"+numerostring(nTotICMS,14,2)+;
                "|"+numerostring(nTotBCST,14,2)+;
                "|"+numerostring(nTotICMSST,14,2)+;
                "|"+numerostring(nTotal,14,2)+;
                "|"+numerostring(nTotalFrete,14,2,.t.)+;
                "|"+; // seguro
                "|"+; // desconto
                "|"+; // total do II
                "|"+; // ipi
                "|"+numerostring(nTotPIS,14,2)+; 
                "|"+numerostring(nTotCOFINS,14,2)+;
                "|"+; // despesas acessorias
                "|"+numerostring(nTotal+nTotalFrete,14,2)+terminador)
frete := "0"
if !empty(nota->frete_v)
   frete := str(val(nota->frete_v)-1,1)
endif
fwrite(nHandle, "X|"+frete+terminador)
if nota->codtran_v>0
   transp->(dbsetorder(1), dbseek(nota->codtran_v))
   cgccpf := sonumero(transp->cgc_v)
   fwrite(nHandle, "X03"+;
                   "|"+alltrim(transp->nome_v)+;
                   "|"+sonumero(transp->insest_v)+;
                   "|"+alltrim(transp->endereco_v)+;
                   "|"+alltrim(transp->estado_v)+;
                   "|"+alltrim(transp->cidade_v)+terminador)
   if len(cgccpf)>11
      fwrite(nHandle, "X04|"+cgccpf+terminador)
   else
      fwrite(nHandle, "X05|"+cgccpf+terminador)
   endif
endif
if nota->valfrete_v>0
   fwrite(nHandle, "X11"+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->icmfrete_v,6,2)+;
                   "|"+; //numerostring((nota->valfrete_v*(nota->icmfrete_v/100)),14,2)+;
                   "|"+; //alltrim(sonumero(nota->cfop_v))+;
                   "|"+; //alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;
                   terminador)
endif
fwrite(nHandle, "X18"+;
                "|"+alltrim(upper(nota->placa_v))+;
                "|"+alltrim(nota->uf_v)+;
                "|"+terminador)
fwrite(nHandle, "X26"+;
                "|"+numerostring(nota->qtd_v,15,0)+;
                "|"+alltrim(nota->especie_v)+;
                "|"+alltrim(nota->marca_v)+;
                "|"+alltrim(nota->numero_v)+;
                "|"+numerostring(val(nota->pesoliq_v),15,3)+;
                "|"+numerostring(val(nota->pesobru_v),15,3)+terminador)
if !empty(alltrim(nota->ficha_v))
   if tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
      cFaturamento := ""
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v
         if tecfat->tpparc_v$"PU"
            parc++
            fwrite(nHandle, "Y07"+;
                            "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                            "|"+transform(dtos(tecfat->dtparc_v),"@r9999-99-99")+;
                            "|"+numerostring(tecfat->vrparc_v,15,2)+terminador)
            cFaturamento += strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+" "+dtoc(tecfat->dtparc_v)+" R$"+alltrim(transform(tecfat->vrparc_v,"@r 999,999.99"))+" * "
         endif
         tecfat->(dbskip())
      enddo
      cFaturamento := left(cFaturamento, len(cFaturamento)-3)
   endif
   if !empty(cFaturamento)
      fwrite(nHandle, "Z"+;
                      "|"+;
                      "|"+cFaturamento+terminador)
   endif
else
   if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
      cFaturamento := ""
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v
         parc++
         fwrite(nHandle, "Y07"+;
                         "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                         "|"+transform(dtos(pedfat->dtparc_v),"@r9999-99-99")+;
                         "|"+numerostring(pedfat->vrparc_v,15,2)+terminador)
         cFaturamento += strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+" "+dtoc(pedfat->dtparc_v)+" R$"+alltrim(transform(pedfat->vrparc_v,"@r 999,999.99"))+" * "
         pedfat->(dbskip())
      enddo
      cFaturamento := left(cFaturamento, len(cFaturamento)-3)
   endif
   if !empty(cFaturamento)
      fwrite(nHandle, "Z"+;
                      "|"+;
                      "|"+cFaturamento+terminador)
   endif
endif
//if len(message)>0
//   cMessage := ""
//   for nTBascal := 1 to len(message)
//      cMessage += alltrim(message[nTBascal]) + " "
//   next
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+cMessage+terminador)
//endif
fclose(nHandle)
return .t.

function numerostring(numero,tam,dec, vazioquandozero)
//return if(numero>0, alltrim(str(numero,tam,dec)), "")
if vazioquandozero == nil
   vazioquandozero := .f.
endif
return if(numero == 0 .and. vazioquandozero, "", alltrim(str(numero,tam,dec)))

function NFeChaveAcesso(nota)
local cTexto
nota->(dbsetorder(1), dbseek(str(nota,6)+"0"))
caduf->(dbsetorder(1), dbseek( decrip(config->estado_v) ))

cTexto := caduf->ibge_v

cTexto += substr(dtos(nota->datemi_v),3,4)

cTexto += sonumero( decrip( config->cgc_v ) )

cTexto += "55"

cTexto += "000"

cTexto += strzero(nota->codigo_v,9)

cTexto += "01"

cTexto += strzero(0,8)

return cTexto

function NFeDVChaveAcesso(chaveAcesso)
local cTexto
return cTexto

function trataFone(fone)
local cRetorno := sonumero(fone)
do while left(cRetorno,1)=="0"
   cRetorno := substr(cRetorno,2)
enddo
return cRetorno

function gernfe2(nota, datemi)
local nHandle
local terminador := chr(13)+chr(10)
local nBaseDeCalculoICMS, nValorICMS, cImposto, parc
local nTotBC, nTotICMS, nTotBCST, nValorICMSST, nTotICMSST, nTotal,nTotalFrete, frete
local nBaseDeCalculoPIS, nValorPIS, nTotPIS, nBaseDeCalculoCOFINS, nValorCOFINS, nTotCOFINS
local message, cMessage, nTBascal, cgccpf, cgccpf_cliente
message := array(0)
if ! nota->codigo_v == nota .and. nota->datemi_v == datemi
   if !nota->(dbsetorder(1), dbseek(str(nota,6)+"0"))
      return .f.
   endif
endif
if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
   return .f.
endif
cgccpf_cliente := sonumero(clifor->cgccpf_v)
nHandle := fcreate("nfe/nf"+strzero(nota->codigo_v,6,0)+".txt")
fwrite(nHandle, "NOTA FISCAL"+;
                "|1"+terminador);

fwrite(nHandle, "A"+;
                "|2.00"+;
                "|NFe"+;
                terminador);

if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
   venda_prazo = .f.
   do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v .and. !venda_prazo
      venda_prazo := pedfat->dtparc_v > nota->datemi_v
      pedfat->(dbskip())
   enddo
elseif tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
   venda_prazo = .f.
   do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v .and. !venda_prazo
      venda_prazo := tecfat->dtparc_v > nota->datemi_v
      tecfat->(dbskip())
   enddo
endif

fwrite(nHandle, "B"+; //ide
                "|"+if(caduf->(dbsetorder(1), dbseek( decrip(config->estado_v) )), caduf->ibge_v,"")+; // cUF
                "|"+; // cNF
                "|"+alltrim(nota->natoper_v)+; // natOp
                "|"+if(venda_prazo, "1", "0")+; // indPag
                "|55"+; //mod
                "|"+nota->serie_v+; // serie
                "|"+alltrim(str(nota->codigo_v))+; // nNf
                "|"+transform(dtos(nota->datemi_v),"@r9999-99-99")+; // dEmi
                "|"+transform(dtos(nota->datsai_v),"@r9999-99-99")+; // dSaiEnt
                "|"+nota->horasai_v+; // hSaiEnt
                "|1"+; // tpNF
                "|"+if(cadcid->(dbsetorder(1), dbseek(decrip(config->cidade_v)+decrip(config->estado_v)) ), cadcid->ibge_v,"")+; // cMunFG
                "|1"+; // TpImp
                "|1"+; // TpEmis
                "|"+; // cDV
                "|"+config->ambiente_v+; // tpAmb     // 1-Produção  2-Homologação
                "|1"+; // finNFe
                "|3"+; // procEmi
                "|2.0.6"+; // VerProc
                terminador)

fwrite(nHandle, "C"+; // emit
                "|"+alltrim(decrip( config->nome_v ))+; // XNome
                "|"+; // XFant
                "|"+sonumero( decrip(config->insest_v) )+; //IE
                "|"+; //IEST
                "|"+sonumero( decrip(config->insmun_v) )+; //IM
                "|"+decrip(config->cnae_v)+; // CNAE
                "|"+config->regtrib_v+; // CRT
                terminador)

if len(sonumero( decrip(config->cgc_v) ))>11
   fwrite(nHandle, "C02"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CNPJ
                   terminador)
else
   fwrite(nHandle, "C02a"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CPF
                   terminador)
endif

fwrite(nHandle, "C05"+;
                "|"+alltrim(decrip(config->endereco_v))+; //XLgr
                "|"+alltrim(decrip(config->numero_v))+; // Nro
                "|"+alltrim(decrip(config->complem_v))+; // Cpl
                "|"+alltrim(decrip(config->bairro_v))+; // Bairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(decrip(config->cidade_v))),cadcid->ibge_v,""))+; // CMun
                "|"+alltrim(decrip(config->cidade_v))+; // XMun
                "|"+decrip(config->estado_v)+; // UF
                "|"+alltrim(decrip(config->cep_v))+; // CEP
                "|1058"+; // cPais
                "|Brasil"+; // xPais
                "|"+trataFone(decrip(config->fone1_v))+; // fone
                terminador)

fwrite(nHandle, "E"+; 
                "|"+alltrim(clifor->nome_v)+; //xNome
                "|"+sonumero(if(len(cgccpf_cliente)>11,clifor->rginsest_v,""))+; // IE
                "|"+alltrim(sonumero(clifor->inssuf_v))+; // ISUF
                "|"+lower(alltrim(clifor->email_v))+; // email
                terminador)
if len(cgccpf_cliente)>11
   fwrite(nHandle, "E02"+;
                   "|"+cgccpf_cliente+; //CNPJ
                   terminador)
else
   fwrite(nHandle, "E03"+;
                   "|"+cgccpf_cliente+; //CPF
                   terminador)
endif

fwrite(nHandle, "E05"+;
                "|"+alltrim(clifor->endereco_v)+;//xLgr
                "|"+alltrim(clifor->numero_v)+;//nro
                "|"+alltrim(clifor->complem_v)+;//xCpl
                "|"+alltrim(clifor->bairro_v)+;//xBairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;//cMun
                "|"+alltrim(clifor->cidade_v)+;//xMun
                "|"+clifor->estado_v+;//UF
                "|"+clifor->cep_v+;//CEP
                "|1058"+;//cPais
                "|Brasil"+;//xPais
                "|"+trataFone(clifor->fone1_v)+;//fone
                terminador)

nota2->(dbsetorder(1), dbseek( str(nota->codigo_v)+dtos(nota->datemi_v) ))
nH := 0
nTotBC := 0
nTotICMS := 0
nTotBCST := 0
nTotICMSST := 0
nTotal := 0
nTotalFrete := 0
nTotPIS := 0
nTotCOFINS := 0
do while !nota2->(eof()) .and. nota2->codigo_v == nota->codigo_v .and. nota2->datemi_v == nota->datemi_v
   if !empty(alltrim(nota2->tbascal_v)) .and. ascan(message, nota2->tbascal_v) < 1
      aadd(message, nota2->tbascal_v)
   endif
   nH++
   fwrite(nHandle, "H"+;
                   "|"+alltrim(str(nH,3))+;//nItem
                   "|"+alltrim(nota2->tbascal_v)+;//infAdProd
                   terminador)
   fwrite(nHandle, "I"+;
                   "|"+alltrim(nota2->item_v)+;//CProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEAN
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),left(estoque->nome_v,43),""))+;//XProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ncm_v,""))+;//NCM
                   "|"+;//EXTIPI
                   "|"+alltrim(sonumero(nota2->cfop_v))+;//CFOP
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UCom
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QCom
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnCom
                   "|"+numerostring(nota2->valuni_v*nota2->qtd_v,15,2)+;//VProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEANTrib
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UTrib
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QTrib
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnTrib
                   "|"+numerostring(nota2->frete_v,15,2,.t.)+;//VFrete
                   "|"+numerostring(0,15,2,.t.)+;//VSeg
                   "|"+numerostring(0,15,2,.t.)+;//vDesc
                   "|"+; // VOutro
                   "|1"+;//indTot
                   "|"+;//xPed
                   "|"+;//nItemPed
                   terminador)
   nBaseDeCalculoICMS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v) * (nota2->bascal_v/100)
   nValorICMS := nBaseDeCalculoICMS * (nota2->icms_v / 100)
   nBasedeCalculoICMSST := 0
   if (nota2->bascalst_v/100 > 0)
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (1 + (nota2->mgvradic_v/100))
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (nota2->bascalst_v/100)
   endif
   nValorICMSST := nBaseDeCalculoICMSST * (nota2->icmsst_v / 100)
   
   nBaseDeCalculoPIS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorPIS := nBaseDeCalculoPIS * (nota2->pis_v/100)
   nBaseDeCalculoCOFINS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorCOFINS := nBaseDeCalculoCOFINS * (nota2->cofins_v/100)
   
   nTotBC += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900", nBaseDeCalculoICMS, 0)
   nTotICMS += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900",nValorICMS,0)
   nTotBCST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nBaseDeCalculoICMSST, 0)
   nTotICMSST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nValorICMSST, 0)
   nTotal += (nota2->valuni_v*nota2->qtd_v)
   nTotalFrete += nota2->frete_v
   nTotPIS += nValorPIS
   nTotCOFINS += nValorCOFINS
   
   if nota2->sittabb_v == 00
      cImposto := "N02"
   elseif nota2->sittabb_v == 10
      cImposto := "N03"
   elseif nota2->sittabb_v == 20
      cImposto := "N04"
   elseif nota2->sittabb_v == 30
      cImposto := "N05"
   elseif nota2->sittabb_v == 40
      cImposto := "N06"
   elseif nota2->sittabb_v == 41
      cImposto := "N06"
   elseif nota2->sittabb_v == 51
      cImposto := "N07"
   elseif nota2->sittabb_v == 60
      cImposto := "N08"
   elseif nota2->sittabb_v == 70
      cImposto := "N09"
   elseif nota2->sittabb_v == 90
      cImposto := "N10"
   elseif nota2->sittabb_v == 101
      cImposto := "N10c"
   elseif nota2->sittabb_v == 102
      cImposto := "N10d"
   elseif nota2->sittabb_v == 103
      cImposto := "N10d"
   elseif nota2->sittabb_v == 300
      cImposto := "N10d"
   elseif nota2->sittabb_v == 400
      cImposto := "N10d"
   elseif nota2->sittabb_v == 201
      cImposto := "N10e"
   elseif nota2->sittabb_v == 202
      cImposto := "N10f"
   elseif nota2->sittabb_v == 203
      cImposto := "N10f"
   elseif nota2->sittabb_v == 500
      cImposto := "N10g"
   elseif nota2->sittabb_v == 900
      cImposto := "N10g"
   endif
   
   cImposto += "|"+strzero(nota2->sittaba_v,1)+;       // Origem da Mercadoria
               "|"+strzero(nota2->sittabb_v,if(nota2->sittabb_v<100,2,3))    // Tributacao do ICMS
               
   if strzero(nota2->sittabb_v,3)$"000,010,020,030,051,070,090,900"
      cImposto += "|3"                                 // Modalidade de determinacao da BC do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"020,051,070"
      cImposto += "|"+numerostring(nota2->bascal_v,6,2)       // Percentual da reducao de BC
   endif
   
   if strzero(nota2->sittabb_v,3)$"000,010,020,051,070"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"090,900"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->bascal_v,6,2)+;     // Percentual da reducao de BC
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|0"+;                                  // Modalidade de determinacao da BC do ICMS ST
                  "|"+numerostring(nota2->mgvradic_v,6,2,.t.) // Percentual da margem de valor adicionado do ICMS ST
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->bascalst_v,6,2,.t.) // Percentual da reducao da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900" 
      cImposto += "|"+numerostring(nBaseDeCalculoICMSST,15,2) // Valor da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->icmsst_v,6,2)    // Aliquota do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900"
      cImposto += "|"+numerostring(nValorICMSST,15,2)      // Valor do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"101,201,900"
      cImposto += "|"+numerostring(nota2->aliqcred_v,6,2)    // Alíquota aplicável de cálculo do crédito (SIMPLES NACIONAL)
      cImposto += "|"+numerostring(0,6,2)    // Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)
   endif
   
   cImposto += terminador
   fwrite(nHandle, "M|"+terminador)
   fwrite(nHandle, "N|"+terminador)
   fwrite(nHandle, cImposto)
   
   fwrite(nHandle, "Q|"+terminador)
   
   cImposto := ""
   if nota2->modpis_v $ "01,02"
      cImposto := "Q02"
   endif
   if nota2->modpis_v $ "03"
      cImposto := "Q03"
   endif
   if nota2->modpis_v $ "04,06,07,08,09"
      cImposto := "Q04"
   endif
   if nota2->modpis_v $ "99"
      cImposto := "Q05"
   endif
   cImposto += "|"+nota2->modpis_v
   if nota2->modpis_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoPIS,14,2)
      cImposto += "|"+numerostring(nota2->pis_v,6,2)
   endif
   if nota2->modpis_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorPIS,14,2)
   endif

   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->modpis_v $ "99"
      cImposto := "Q07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   
   fwrite(nHandle, "S|"+terminador)
   cImposto := ""
   if nota2->mdcofins_v $ "01,02"
      cImposto := "S02"
   endif
   if nota2->mdcofins_v $ "03"
      cImposto := "S03"
   endif
   if nota2->mdcofins_v $ "04,06,07,08,09"
      cImposto := "S04"
   endif
   if nota2->mdcofins_v $ "99"
      cImposto := "S05"
   endif
   cImposto += "|"+nota2->mdcofins_v
   if nota2->mdcofins_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoCOFINS,14,2)
      cImposto += "|"+numerostring(nota2->cofins_v,6,2)
   endif
   if nota2->mdcofins_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorCOFINS,14,2)
   endif
   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->mdcofins_v $ "99"
      cImposto := "S07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   nota2->(dbskip())
enddo
//nTotBC += nota->valfrete_v
//nTotICMS += nota->valfrete_v * nota->icmfrete_v / 100
fwrite(nHandle, "W|"+terminador)
fwrite(nHandle, "W02"+;
                "|"+numerostring(nTotBC,14,2)+;
                "|"+numerostring(nTotICMS,14,2)+;
                "|"+numerostring(nTotBCST,14,2)+;
                "|"+numerostring(nTotICMSST,14,2)+;
                "|"+numerostring(nTotal,14,2)+;
                "|"+numerostring(nTotalFrete,14,2,.t.)+;
                "|"+; // seguro
                "|"+; // desconto
                "|"+; // total do II
                "|"+; // ipi
                "|"+numerostring(nTotPIS,14,2)+; 
                "|"+numerostring(nTotCOFINS,14,2)+;
                "|"+; // despesas acessorias
                "|"+numerostring(nTotal+nTotalFrete,14,2)+terminador)
frete := "0"
if !empty(nota->frete_v)
   frete := str(val(nota->frete_v)-1,1)
endif
fwrite(nHandle, "X|"+frete+terminador)
if nota->codtran_v>0
   transp->(dbsetorder(1), dbseek(nota->codtran_v))
   cgccpf := sonumero(transp->cgc_v)
   fwrite(nHandle, "X03"+;
                   "|"+alltrim(transp->nome_v)+;
                   "|"+sonumero(transp->insest_v)+;
                   "|"+alltrim(transp->endereco_v)+;
                   "|"+alltrim(transp->estado_v)+;
                   "|"+alltrim(transp->cidade_v)+terminador)
   if len(cgccpf)>11
      fwrite(nHandle, "X04|"+cgccpf+terminador)
   else
      fwrite(nHandle, "X05|"+cgccpf+terminador)
   endif
endif
if nota->valfrete_v>0
   fwrite(nHandle, "X11"+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->icmfrete_v,6,2)+;
                   "|"+; //numerostring((nota->valfrete_v*(nota->icmfrete_v/100)),14,2)+;
                   "|"+; //alltrim(sonumero(nota->cfop_v))+;
                   "|"+; //alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;
                   terminador)
endif
fwrite(nHandle, "X18"+;
                "|"+alltrim(upper(nota->placa_v))+;
                "|"+alltrim(nota->uf_v)+;
                "|"+terminador)
fwrite(nHandle, "X26"+;
                "|"+numerostring(nota->qtd_v,15,0)+;
                "|"+alltrim(nota->especie_v)+;
                "|"+alltrim(nota->marca_v)+;
                "|"+alltrim(nota->numero_v)+;
                "|"+numerostring(val(nota->pesoliq_v),15,3)+;
                "|"+numerostring(val(nota->pesobru_v),15,3)+terminador)
if !empty(alltrim(nota->ficha_v))
   if tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v
         if tecfat->tpparc_v$"PU"
            parc++
            fwrite(nHandle, "Y07"+;
                            "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                            "|"+transform(dtos(tecfat->dtparc_v),"@r9999-99-99")+;
                            "|"+numerostring(tecfat->vrparc_v,15,2)+terminador)
         endif
         tecfat->(dbskip())
      enddo
   endif
else
   if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v
         parc++
         fwrite(nHandle, "Y07"+;
                         "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                         "|"+transform(dtos(pedfat->dtparc_v),"@r9999-99-99")+;
                         "|"+numerostring(pedfat->vrparc_v,15,2)+terminador)
         pedfat->(dbskip())
      enddo
   endif
endif
if !empty(alltrim(nota->msgfisc_v))
   fwrite(nHandle, "Z"+;
                   "|"+trim(nota->msgfisc_v)+;
                   "|"+terminador)
endif
//if !empty(alltrim(nota->observa1_v))
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+nota->observa1_v+terminador)
//endif
//if len(message)>0
//   cMessage := ""
//   for nTBascal := 1 to len(message)
//      cMessage += alltrim(message[nTBascal]) + " "
//   next
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+cMessage+terminador)
//endif
fclose(nHandle)
return .t.

function gernfe3(nota, datemi)
local nHandle
local terminador := chr(13)+chr(10)
local nBaseDeCalculoICMS, nValorICMS, cImposto, parc
local nTotBC, nTotICMS, nTotBCST, nValorICMSST, nTotICMSST, nTotal,nTotalFrete, frete
local nBaseDeCalculoPIS, nValorPIS, nTotPIS, nBaseDeCalculoCOFINS, nValorCOFINS, nTotCOFINS
local message, cMessage, nTBascal, cgccpf, cgccpf_cliente
message := array(0)
if ! nota->codigo_v == nota .and. nota->datemi_v == datemi
   if !nota->(dbsetorder(1), dbseek(str(nota,6)+"0"))
      return .f.
   endif
endif
if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
   return .f.
endif
cgccpf_cliente := sonumero(clifor->cgccpf_v)
nHandle := fcreate("nfe/nf"+strzero(nota->codigo_v,6,0)+".txt")
fwrite(nHandle, "NOTA FISCAL"+;
                "|1"+terminador);

fwrite(nHandle, "A"+;
                "|3.10"+;
                "|NFe"+;
                "|1"+;
                terminador);

if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
   venda_prazo = .f.
   do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v .and. !venda_prazo
      venda_prazo := pedfat->dtparc_v > nota->datemi_v
      pedfat->(dbskip())
   enddo
elseif tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
   venda_prazo = .f.
   do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v .and. !venda_prazo
      venda_prazo := tecfat->dtparc_v > nota->datemi_v
      tecfat->(dbskip())
   enddo
endif

fwrite(nHandle, "B"+; //ide
                "|"+if(caduf->(dbsetorder(1), dbseek( decrip(config->estado_v) )), caduf->ibge_v,"")+; // cUF
                "|"+; // cNF
                "|"+alltrim(nota->natoper_v)+; // natOp
                "|"+if(venda_prazo, "1", "0")+; // indPag
                "|55"+; //mod
                "|"+nota->serie_v+; // serie
                "|"+alltrim(str(nota->codigo_v))+; // nNf
                "|"+transform(dtos(nota->datemi_v),"@r9999-99-99")+"T"+if(empty(nota->horaemi_v),'00:00:00',nota->horaemi_v)+"-03:00"+; // dhEmi
                "|"+transform(dtos(nota->datsai_v),"@r9999-99-99")+"T"+nota->horasai_v+"-03:00"+; // dhSaiEnt
                "|1"+; // tpNF
                "|"+if(decrip(config->estado_v)==clifor->estado_v,"1","2")+; // idDest
                "|"+if(cadcid->(dbsetorder(1), dbseek(decrip(config->cidade_v)+decrip(config->estado_v)) ), cadcid->ibge_v,"")+; // cMunFG
                "|1"+; // TpImp
                "|1"+; // TpEmis
                "|"+; // cDV
                "|"+config->ambiente_v+; // tpAmb     // 1-Produção  2-Homologação
                "|1"+; // indFinal
                "|1"+; // indPres
                "|1"+; // finNFe
                "|3"+; // procEmi
                "|2.0.6"+; // VerProc
                terminador)

fwrite(nHandle, "C"+; // emit
                "|"+alltrim(decrip( config->nome_v ))+; // XNome
                "|"+; // XFant
                "|"+sonumero( decrip(config->insest_v) )+; //IE
                "|"+; //IEST
                "|"+sonumero( decrip(config->insmun_v) )+; //IM
                "|"+decrip(config->cnae_v)+; // CNAE
                "|"+config->regtrib_v+; // CRT
                terminador)

if len(sonumero( decrip(config->cgc_v) ))>11
   fwrite(nHandle, "C02"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CNPJ
                   terminador)
else
   fwrite(nHandle, "C02a"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CPF
                   terminador)
endif

fwrite(nHandle, "C05"+;
                "|"+alltrim(decrip(config->endereco_v))+; //XLgr
                "|"+alltrim(decrip(config->numero_v))+; // Nro
                "|"+alltrim(decrip(config->complem_v))+; // Cpl
                "|"+alltrim(decrip(config->bairro_v))+; // Bairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(decrip(config->cidade_v))),cadcid->ibge_v,""))+; // CMun
                "|"+alltrim(decrip(config->cidade_v))+; // XMun
                "|"+decrip(config->estado_v)+; // UF
                "|"+alltrim(decrip(config->cep_v))+; // CEP
                "|1058"+; // cPais
                "|Brasil"+; // xPais
                "|"+trataFone(decrip(config->fone1_v))+; // fone
                terminador)

fwrite(nHandle, "E"+; 
                "|"+alltrim(clifor->nome_v)+; //xNome
                "|"+if(alltrim(clifor->rginsest_v)=="ISENTO","2","1")+; //indIEDest
                "|"+sonumero(if(len(cgccpf_cliente)>11,clifor->rginsest_v,""))+; // IE
                "|"+alltrim(sonumero(clifor->inssuf_v))+; // ISUF
                "|"+alltrim(sonumero(clifor->insmun_v))+; // IM
                "|"+lower(alltrim(clifor->email_v))+; // email
                terminador)
if len(cgccpf_cliente)>11
   fwrite(nHandle, "E02"+;
                   "|"+cgccpf_cliente+; //CNPJ
                   terminador)
else
   fwrite(nHandle, "E03"+;
                   "|"+cgccpf_cliente+; //CPF
                   terminador)
endif

fwrite(nHandle, "E05"+;
                "|"+alltrim(clifor->endereco_v)+;//xLgr
                "|"+alltrim(clifor->numero_v)+;//nro
                "|"+alltrim(clifor->complem_v)+;//xCpl
                "|"+alltrim(clifor->bairro_v)+;//xBairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;//cMun
                "|"+alltrim(clifor->cidade_v)+;//xMun
                "|"+clifor->estado_v+;//UF
                "|"+clifor->cep_v+;//CEP
                "|1058"+;//cPais
                "|Brasil"+;//xPais
                "|"+trataFone(clifor->fone1_v)+;//fone
                terminador)

nota2->(dbsetorder(1), dbseek( str(nota->codigo_v)+dtos(nota->datemi_v) ))
nH := 0
nTotBC := 0
nTotICMS := 0
nTotBCST := 0
nTotICMSST := 0
nTotal := 0
nTotalFrete := 0
nTotPIS := 0
nTotCOFINS := 0
do while !nota2->(eof()) .and. nota2->codigo_v == nota->codigo_v .and. nota2->datemi_v == nota->datemi_v
   if !empty(alltrim(nota2->tbascal_v)) .and. ascan(message, nota2->tbascal_v) < 1
      aadd(message, nota2->tbascal_v)
   endif
   nH++
   fwrite(nHandle, "H"+;
                   "|"+alltrim(str(nH,3))+;//nItem
                   "|"+alltrim(nota2->tbascal_v)+;//infAdProd
                   terminador)
   fwrite(nHandle, "I"+;
                   "|"+alltrim(nota2->item_v)+;//CProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEAN
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),left(estoque->nome_v,43),""))+;//XProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ncm_v,""))+;//NCM
                   "|"+;//EXTIPI
                   "|"+alltrim(sonumero(nota2->cfop_v))+;//CFOP
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UCom
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QCom
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnCom
                   "|"+numerostring(nota2->valuni_v*nota2->qtd_v,15,2)+;//VProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEANTrib
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UTrib
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QTrib
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnTrib
                   "|"+numerostring(nota2->frete_v,15,2,.t.)+;//VFrete
                   "|"+numerostring(0,15,2,.t.)+;//VSeg
                   "|"+numerostring(0,15,2,.t.)+;//vDesc
                   "|"+; // VOutro
                   "|1"+;//indTot
                   "|"+;//xPed
                   "|"+;//nItemPed
                   terminador)
   nBaseDeCalculoICMS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v) * (nota2->bascal_v/100)
   nValorICMS := nBaseDeCalculoICMS * (nota2->icms_v / 100)
   nBasedeCalculoICMSST := 0
   if (nota2->bascalst_v/100 > 0)
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (1 + (nota2->mgvradic_v/100))
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (nota2->bascalst_v/100)
   endif
   nValorICMSST := nBaseDeCalculoICMSST * (nota2->icmsst_v / 100)
   
   nBaseDeCalculoPIS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorPIS := nBaseDeCalculoPIS * (nota2->pis_v/100)
   nBaseDeCalculoCOFINS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorCOFINS := nBaseDeCalculoCOFINS * (nota2->cofins_v/100)
   
   nTotBC += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900", nBaseDeCalculoICMS, 0)
   nTotICMS += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900",nValorICMS,0)
   nTotBCST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nBaseDeCalculoICMSST, 0)
   nTotICMSST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nValorICMSST, 0)
   nTotal += (nota2->valuni_v*nota2->qtd_v)
   nTotalFrete += nota2->frete_v
   nTotPIS += nValorPIS
   nTotCOFINS += nValorCOFINS
   
   if nota2->sittabb_v == 00
      cImposto := "N02"
   elseif nota2->sittabb_v == 10
      cImposto := "N03"
   elseif nota2->sittabb_v == 20
      cImposto := "N04"
   elseif nota2->sittabb_v == 30
      cImposto := "N05"
   elseif nota2->sittabb_v == 40
      cImposto := "N06"
   elseif nota2->sittabb_v == 41
      cImposto := "N06"
   elseif nota2->sittabb_v == 51
      cImposto := "N07"
   elseif nota2->sittabb_v == 60
      cImposto := "N08"
   elseif nota2->sittabb_v == 70
      cImposto := "N09"
   elseif nota2->sittabb_v == 90
      cImposto := "N10"
   elseif nota2->sittabb_v == 101
      cImposto := "N10c"
   elseif nota2->sittabb_v == 102
      cImposto := "N10d"
   elseif nota2->sittabb_v == 103
      cImposto := "N10d"
   elseif nota2->sittabb_v == 300
      cImposto := "N10d"
   elseif nota2->sittabb_v == 400
      cImposto := "N10d"
   elseif nota2->sittabb_v == 201
      cImposto := "N10e"
   elseif nota2->sittabb_v == 202
      cImposto := "N10f"
   elseif nota2->sittabb_v == 203
      cImposto := "N10f"
   elseif nota2->sittabb_v == 500
      cImposto := "N10g"
   elseif nota2->sittabb_v == 900
      cImposto := "N10g"
   endif
   
   cImposto += "|"+strzero(nota2->sittaba_v,1)+;       // Origem da Mercadoria
               "|"+strzero(nota2->sittabb_v,if(nota2->sittabb_v<100,2,3))    // Tributacao do ICMS
               
   if strzero(nota2->sittabb_v,3)$"000,010,020,030,051,070,090,900"
      cImposto += "|3"                                 // Modalidade de determinacao da BC do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"020,051,070"
      cImposto += "|"+numerostring(nota2->bascal_v,6,2)       // Percentual da reducao de BC
   endif
   
   if strzero(nota2->sittabb_v,3)$"000,010,020,051,070"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"090,900"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->bascal_v,6,2)+;     // Percentual da reducao de BC
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|0"+;                                  // Modalidade de determinacao da BC do ICMS ST
                  "|"+numerostring(nota2->mgvradic_v,6,2,.t.) // Percentual da margem de valor adicionado do ICMS ST
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->bascalst_v,6,2,.t.) // Percentual da reducao da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900" 
      cImposto += "|"+numerostring(nBaseDeCalculoICMSST,15,2) // Valor da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->icmsst_v,6,2)    // Aliquota do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900"
      cImposto += "|"+numerostring(nValorICMSST,15,2)      // Valor do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"101,201,900"
      cImposto += "|"+numerostring(nota2->aliqcred_v,6,2)    // Alíquota aplicável de cálculo do crédito (SIMPLES NACIONAL)
      cImposto += "|"+numerostring(0,6,2)    // Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)
   endif
   
   cImposto += terminador
   fwrite(nHandle, "M|"+terminador)
   fwrite(nHandle, "N|"+terminador)
   fwrite(nHandle, cImposto)
   
   fwrite(nHandle, "Q|"+terminador)
   
   cImposto := ""
   if nota2->modpis_v $ "01,02"
      cImposto := "Q02"
   endif
   if nota2->modpis_v $ "03"
      cImposto := "Q03"
   endif
   if nota2->modpis_v $ "04,06,07,08,09"
      cImposto := "Q04"
   endif
   if nota2->modpis_v $ "99"
      cImposto := "Q05"
   endif
   cImposto += "|"+nota2->modpis_v
   if nota2->modpis_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoPIS,14,2)
      cImposto += "|"+numerostring(nota2->pis_v,6,2)
   endif
   if nota2->modpis_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorPIS,14,2)
   endif

   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->modpis_v $ "99"
      cImposto := "Q07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   
   fwrite(nHandle, "S|"+terminador)
   cImposto := ""
   if nota2->mdcofins_v $ "01,02"
      cImposto := "S02"
   endif
   if nota2->mdcofins_v $ "03"
      cImposto := "S03"
   endif
   if nota2->mdcofins_v $ "04,06,07,08,09"
      cImposto := "S04"
   endif
   if nota2->mdcofins_v $ "99"
      cImposto := "S05"
   endif
   cImposto += "|"+nota2->mdcofins_v
   if nota2->mdcofins_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoCOFINS,14,2)
      cImposto += "|"+numerostring(nota2->cofins_v,6,2)
   endif
   if nota2->mdcofins_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorCOFINS,14,2)
   endif
   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->mdcofins_v $ "99"
      cImposto := "S07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   nota2->(dbskip())
enddo
//nTotBC += nota->valfrete_v
//nTotICMS += nota->valfrete_v * nota->icmfrete_v / 100
fwrite(nHandle, "W|"+terminador)
fwrite(nHandle, "W02"+;
                "|"+numerostring(nTotBC,14,2)+;
                "|"+numerostring(nTotICMS,14,2)+;
                "|"+numerostring(nTotBCST,14,2)+;
                "|"+numerostring(nTotICMSST,14,2)+;
                "|"+numerostring(nTotal,14,2)+;
                "|"+numerostring(nTotalFrete,14,2,.t.)+;
                "|"+; // seguro
                "|"+; // desconto
                "|"+; // total do II
                "|"+; // ipi
                "|"+numerostring(nTotPIS,14,2)+; 
                "|"+numerostring(nTotCOFINS,14,2)+;
                "|"+; // despesas acessorias
                "|"+numerostring(nTotal+nTotalFrete,14,2)+terminador)
frete := "0"
if !empty(nota->frete_v)
   frete := str(val(nota->frete_v)-1,1)
endif
fwrite(nHandle, "X|"+frete+terminador)
if nota->codtran_v>0
   transp->(dbsetorder(1), dbseek(nota->codtran_v))
   cgccpf := sonumero(transp->cgc_v)
   fwrite(nHandle, "X03"+;
                   "|"+alltrim(transp->nome_v)+;
                   "|"+sonumero(transp->insest_v)+;
                   "|"+alltrim(transp->endereco_v)+;
                   "|"+alltrim(transp->estado_v)+;
                   "|"+alltrim(transp->cidade_v)+terminador)
   if len(cgccpf)>11
      fwrite(nHandle, "X04|"+cgccpf+terminador)
   else
      fwrite(nHandle, "X05|"+cgccpf+terminador)
   endif
endif
if nota->valfrete_v>0
   fwrite(nHandle, "X11"+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->icmfrete_v,6,2)+;
                   "|"+; //numerostring((nota->valfrete_v*(nota->icmfrete_v/100)),14,2)+;
                   "|"+; //alltrim(sonumero(nota->cfop_v))+;
                   "|"+; //alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;
                   terminador)
endif
fwrite(nHandle, "X18"+;
                "|"+alltrim(upper(nota->placa_v))+;
                "|"+alltrim(nota->uf_v)+;
                "|"+terminador)
fwrite(nHandle, "X26"+;
                "|"+numerostring(nota->qtd_v,15,0)+;
                "|"+alltrim(nota->especie_v)+;
                "|"+alltrim(nota->marca_v)+;
                "|"+alltrim(nota->numero_v)+;
                "|"+numerostring(val(nota->pesoliq_v),15,3)+;
                "|"+numerostring(val(nota->pesobru_v),15,3)+terminador)
if !empty(alltrim(nota->ficha_v))
   if tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v
         if tecfat->tpparc_v$"PU"
            parc++
            fwrite(nHandle, "Y07"+;
                            "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                            "|"+transform(dtos(tecfat->dtparc_v),"@r9999-99-99")+;
                            "|"+numerostring(tecfat->vrparc_v,15,2)+terminador)
         endif
         tecfat->(dbskip())
      enddo
   endif
else
   if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v
         parc++
         fwrite(nHandle, "Y07"+;
                         "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                         "|"+transform(dtos(pedfat->dtparc_v),"@r9999-99-99")+;
                         "|"+numerostring(pedfat->vrparc_v,15,2)+terminador)
         pedfat->(dbskip())
      enddo
   endif
endif
if !empty(alltrim(nota->msgfisc_v))
   fwrite(nHandle, "Z"+;
                   "|"+trim(nota->msgfisc_v)+;
                   "|"+terminador)
endif
//if !empty(alltrim(nota->observa1_v))
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+nota->observa1_v+terminador)
//endif
//if len(message)>0
//   cMessage := ""
//   for nTBascal := 1 to len(message)
//      cMessage += alltrim(message[nTBascal]) + " "
//   next
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+cMessage+terminador)
//endif
fclose(nHandle)
return .t.

function gernfe4(nota, datemi)
local nHandle
local terminador := chr(13)+chr(10)
local nBaseDeCalculoICMS, nValorICMS, cImposto, parc
local nTotBC, nTotICMS, nTotBCST, nValorICMSST, nTotICMSST, nTotal,nTotalFrete, frete
local nBaseDeCalculoPIS, nValorPIS, nTotPIS, nBaseDeCalculoCOFINS, nValorCOFINS, nTotCOFINS
local message, cMessage, nTBascal, cgccpf, cgccpf_cliente
message := array(0)
if ! nota->codigo_v == nota .and. nota->datemi_v == datemi
   if !nota->(dbsetorder(1), dbseek(str(nota,6)+"0"))
      return .f.
   endif
endif
if !clifor->(dbsetorder(1), dbseek(nota->clifor_v))
   return .f.
endif
cgccpf_cliente := sonumero(clifor->cgccpf_v)
nHandle := fcreate("nfe/nf"+strzero(nota->codigo_v,6,0)+".txt")
fwrite(nHandle, "NOTA FISCAL"+;
                "|1"+terminador);

fwrite(nHandle, "A"+;
                "|4.00"+;
                "|NFe"+;
                "|1"+;
                terminador);

if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
   venda_prazo = .f.
   do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v .and. !venda_prazo
      venda_prazo := pedfat->dtparc_v > nota->datemi_v
      pedfat->(dbskip())
   enddo
elseif tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
   venda_prazo = .f.
   do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v .and. !venda_prazo
      venda_prazo := tecfat->dtparc_v > nota->datemi_v
      tecfat->(dbskip())
   enddo
endif

fwrite(nHandle, "B"+; //ide
                "|"+if(caduf->(dbsetorder(1), dbseek( decrip(config->estado_v) )), caduf->ibge_v,"")+; // cUF
                "|"+; // cNF
                "|"+alltrim(nota->natoper_v)+; // natOp
                "|55"+; //mod
                "|"+nota->serie_v+; // serie
                "|"+alltrim(str(nota->codigo_v))+; // nNf
                "|"+transform(dtos(nota->datemi_v),"@r9999-99-99")+"T"+if(empty(nota->horaemi_v),'00:00:00',nota->horaemi_v)+"-03:00"+; // dhEmi
                "|"+transform(dtos(nota->datsai_v),"@r9999-99-99")+"T"+nota->horasai_v+"-03:00"+; // dhSaiEnt
                "|1"+; // tpNF
                "|"+if(decrip(config->estado_v)==clifor->estado_v,"1","2")+; // idDest
                "|"+if(cadcid->(dbsetorder(1), dbseek(decrip(config->cidade_v)+decrip(config->estado_v)) ), cadcid->ibge_v,"")+; // cMunFG
                "|1"+; // TpImp
                "|1"+; // TpEmis
                "|"+; // cDV
                "|"+config->ambiente_v+; // tpAmb     // 1-Produção  2-Homologação
                "|1"+; // indFinal
                "|1"+; // indPres
                "|1"+; // finNFe
                "|3"+; // procEmi
                "|2.0.6"+; // VerProc
                terminador)

fwrite(nHandle, "C"+; // emit
                "|"+alltrim(decrip( config->nome_v ))+; // XNome
                "|"+; // XFant
                "|"+sonumero( decrip(config->insest_v) )+; //IE
                "|"+; //IEST
                "|"+sonumero( decrip(config->insmun_v) )+; //IM
                "|"+decrip(config->cnae_v)+; // CNAE
                "|"+config->regtrib_v+; // CRT
                terminador)

if len(sonumero( decrip(config->cgc_v) ))>11
   fwrite(nHandle, "C02"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CNPJ
                   terminador)
else
   fwrite(nHandle, "C02a"+;
                   "|"+sonumero( decrip(config->cgc_v) )+; // CPF
                   terminador)
endif

fwrite(nHandle, "C05"+;
                "|"+alltrim(decrip(config->endereco_v))+; //XLgr
                "|"+alltrim(decrip(config->numero_v))+; // Nro
                "|"+alltrim(decrip(config->complem_v))+; // Cpl
                "|"+alltrim(decrip(config->bairro_v))+; // Bairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(decrip(config->cidade_v))),cadcid->ibge_v,""))+; // CMun
                "|"+alltrim(decrip(config->cidade_v))+; // XMun
                "|"+decrip(config->estado_v)+; // UF
                "|"+alltrim(decrip(config->cep_v))+; // CEP
                "|1058"+; // cPais
                "|Brasil"+; // xPais
                "|"+trataFone(decrip(config->fone1_v))+; // fone
                terminador)

fwrite(nHandle, "E"+; 
                "|"+alltrim(clifor->nome_v)+; //xNome
                "|"+if(alltrim(clifor->rginsest_v)=="ISENTO","2","1")+; //indIEDest
                "|"+sonumero(if(len(cgccpf_cliente)>11,clifor->rginsest_v,""))+; // IE
                "|"+alltrim(sonumero(clifor->inssuf_v))+; // ISUF
                "|"+alltrim(sonumero(clifor->insmun_v))+; // IM
                "|"+lower(alltrim(clifor->email_v))+; // email
                terminador)
if len(cgccpf_cliente)>11
   fwrite(nHandle, "E02"+;
                   "|"+cgccpf_cliente+; //CNPJ
                   terminador)
else
   fwrite(nHandle, "E03"+;
                   "|"+cgccpf_cliente+; //CPF
                   terminador)
endif

fwrite(nHandle, "E05"+;
                "|"+alltrim(clifor->endereco_v)+;//xLgr
                "|"+alltrim(clifor->numero_v)+;//nro
                "|"+alltrim(clifor->complem_v)+;//xCpl
                "|"+alltrim(clifor->bairro_v)+;//xBairro
                "|"+alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;//cMun
                "|"+alltrim(clifor->cidade_v)+;//xMun
                "|"+clifor->estado_v+;//UF
                "|"+clifor->cep_v+;//CEP
                "|1058"+;//cPais
                "|Brasil"+;//xPais
                "|"+trataFone(clifor->fone1_v)+;//fone
                terminador)

nota2->(dbsetorder(1), dbseek( str(nota->codigo_v)+dtos(nota->datemi_v) ))
nH := 0
nTotBC := 0
nTotICMS := 0
nTotBCST := 0
nTotICMSST := 0
nTotal := 0
nTotalFrete := 0
nTotPIS := 0
nTotCOFINS := 0
do while !nota2->(eof()) .and. nota2->codigo_v == nota->codigo_v .and. nota2->datemi_v == nota->datemi_v
   if !empty(alltrim(nota2->tbascal_v)) .and. ascan(message, nota2->tbascal_v) < 1
      aadd(message, nota2->tbascal_v)
   endif
   nH++
   fwrite(nHandle, "H"+;
                   "|"+alltrim(str(nH,3))+;//nItem
                   "|"+alltrim(nota2->tbascal_v)+;//infAdProd
                   terminador)
   fwrite(nHandle, "I"+;
                   "|"+alltrim(nota2->item_v)+;//CProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEAN
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),left(estoque->nome_v,43),""))+;//XProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ncm_v,""))+;//NCM
                   "|"+;//cBenef
                   "|"+;//EXTIPI
                   "|"+alltrim(sonumero(nota2->cfop_v))+;//CFOP
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UCom
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QCom
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnCom
                   "|"+numerostring(nota2->valuni_v*nota2->qtd_v,15,2)+;//VProd
                   "|"+alltrim(if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->ean_v,""))+;//CEANTrib
                   "|"+if(estoque->(dbsetorder(1),dbseek( nota2->item_v )),estoque->unidade_v,"")+;//UTrib
                   "|"+numerostring(nota2->qtd_v,12,4)+;//QTrib
                   "|"+numerostring(nota2->valuni_v,16,4)+;//VUnTrib
                   "|"+numerostring(nota2->frete_v,15,2,.t.)+;//VFrete
                   "|"+numerostring(0,15,2,.t.)+;//VSeg
                   "|"+numerostring(0,15,2,.t.)+;//vDesc
                   "|"+; // VOutro
                   "|1"+;//indTot
                   "|"+;//xPed
                   "|"+;//nItemPed
                   "|"+;//nFCI
                   terminador)
   nBaseDeCalculoICMS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v) * (nota2->bascal_v/100)
   nValorICMS := nBaseDeCalculoICMS * (nota2->icms_v / 100)
   nBasedeCalculoICMSST := 0
   if (nota2->bascalst_v/100 > 0)
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (1 + (nota2->mgvradic_v/100))
      nBaseDeCalculoICMSST := ((nota2->valuni_v*nota2->qtd_v)) * (nota2->bascalst_v/100)
   endif
   nValorICMSST := nBaseDeCalculoICMSST * (nota2->icmsst_v / 100)
   
   nBaseDeCalculoPIS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorPIS := nBaseDeCalculoPIS * (nota2->pis_v/100)
   nBaseDeCalculoCOFINS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v)
   nValorCOFINS := nBaseDeCalculoCOFINS * (nota2->cofins_v/100)
   
   nTotBC += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900", nBaseDeCalculoICMS, 0)
   nTotICMS += if(strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090,900",nValorICMS,0)
   nTotBCST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nBaseDeCalculoICMSST, 0)
   nTotICMSST += if(strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900", nValorICMSST, 0)
   nTotal += (nota2->valuni_v*nota2->qtd_v)
   nTotalFrete += nota2->frete_v
   nTotPIS += nValorPIS
   nTotCOFINS += nValorCOFINS
   
   if nota2->sittabb_v == 00
      cImposto := "N02"
   elseif nota2->sittabb_v == 10
      cImposto := "N03"
   elseif nota2->sittabb_v == 20
      cImposto := "N04"
   elseif nota2->sittabb_v == 30
      cImposto := "N05"
   elseif nota2->sittabb_v == 40
      cImposto := "N06"
   elseif nota2->sittabb_v == 41
      cImposto := "N06"
   elseif nota2->sittabb_v == 51
      cImposto := "N07"
   elseif nota2->sittabb_v == 60
      cImposto := "N08"
   elseif nota2->sittabb_v == 70
      cImposto := "N09"
   elseif nota2->sittabb_v == 90
      cImposto := "N10"
   elseif nota2->sittabb_v == 101
      cImposto := "N10c"
   elseif nota2->sittabb_v == 102
      cImposto := "N10d"
   elseif nota2->sittabb_v == 103
      cImposto := "N10d"
   elseif nota2->sittabb_v == 300
      cImposto := "N10d"
   elseif nota2->sittabb_v == 400
      cImposto := "N10d"
   elseif nota2->sittabb_v == 201
      cImposto := "N10e"
   elseif nota2->sittabb_v == 202
      cImposto := "N10f"
   elseif nota2->sittabb_v == 203
      cImposto := "N10f"
   elseif nota2->sittabb_v == 500
      cImposto := "N10g"
   elseif nota2->sittabb_v == 900
      cImposto := "N10g"
   endif
   
   cImposto += "|"+strzero(nota2->sittaba_v,1)+;       // Origem da Mercadoria
               "|"+strzero(nota2->sittabb_v,if(nota2->sittabb_v<100,2,3))    // Tributacao do ICMS
               
   if strzero(nota2->sittabb_v,3)$"000,010,020,030,051,070,090,900"
      cImposto += "|3"                                 // Modalidade de determinacao da BC do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"020,051,070"
      cImposto += "|"+numerostring(nota2->bascal_v,6,2)       // Percentual da reducao de BC
   endif
   
   if strzero(nota2->sittabb_v,3)$"000,010,020,051,070"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif

   if strzero(nota2->sittabb_v,3)$"010,020,051,070,090"
      cImposto += "|" // vBCFCP
   endif

   if strzero(nota2->sittabb_v,3)$"000,010,020,051,070,090"
      cImposto += "|"+; // pFCP
                  "|"   // vFCP
   endif
   
   if strzero(nota2->sittabb_v,3)$"090,900"
      cImposto += "|"+numerostring(nBaseDeCalculoICMS,15,2)+; // Valor da BC do ICMS
                  "|"+numerostring(nota2->bascal_v,6,2)+;     // Percentual da reducao de BC
                  "|"+numerostring(nota2->icms_v,6,2)+;       // Aliquota do ICMS
                  "|"+numerostring(nValorICMS,15,2)           // Valor do ICMS
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|0"+;                                  // Modalidade de determinacao da BC do ICMS ST
                  "|"+numerostring(nota2->mgvradic_v,6,2,.t.) // Percentual da margem de valor adicionado do ICMS ST
   endif
   
   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->bascalst_v,6,2,.t.) // Percentual da reducao da BC do ICMS ST
   endif
   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900" 
      cImposto += "|"+numerostring(nBaseDeCalculoICMSST,15,2) // Valor da BC do ICMS ST
   endif

   if strzero(nota2->sittabb_v,3)$"060,500"
      cImposto += "|"    // pST
   endif

   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+numerostring(nota2->icmsst_v,6,2)    // Aliquota do ICMS ST
   endif

   if strzero(nota2->sittabb_v,3)$"010,030,060,070,090,201,202,203,500,900"
      cImposto += "|"+numerostring(nValorICMSST,15,2)      // Valor do ICMS ST
   endif

   if strzero(nota2->sittabb_v,3)$"060,500"
      cImposto += "|"+;     // vBCFCPSTRet
                  "|"+;     // pFCPSTRet
                  "|"+;     // vFCPSTRet
                  "|"+;     // pRedBCEfet
                  "|"+;     // vBCEfet
                  "|"+;     // pICMSEfet
                  "|"       // vICMSEfet
   endif

   if strzero(nota2->sittabb_v,3)$"010,030,070,090,201,202,203,900"
      cImposto += "|"+; // vBCFCPST
                  "|"+; // pPFCPST
                  "|"   // vPFCPST
   endif

   if strzero(nota2->sittabb_v,3)$"101,201,900"
      cImposto += "|"+numerostring(nota2->aliqcred_v,6,2)    // Alíquota aplicável de cálculo do crédito (SIMPLES NACIONAL)
      cImposto += "|"+numerostring(0,6,2)    // Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (SIMPLES NACIONAL)
   endif
   
   cImposto += terminador
   fwrite(nHandle, "M|"+terminador)
   fwrite(nHandle, "N|"+terminador)
   fwrite(nHandle, cImposto)
   
   fwrite(nHandle, "Q|"+terminador)
   
   cImposto := ""
   if nota2->modpis_v $ "01,02"
      cImposto := "Q02"
   endif
   if nota2->modpis_v $ "03"
      cImposto := "Q03"
   endif
   if nota2->modpis_v $ "04,06,07,08,09"
      cImposto := "Q04"
   endif
   if nota2->modpis_v $ "99"
      cImposto := "Q05"
   endif
   cImposto += "|"+nota2->modpis_v
   if nota2->modpis_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoPIS,14,2)
      cImposto += "|"+numerostring(nota2->pis_v,6,2)
   endif
   if nota2->modpis_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorPIS,14,2)
   endif

   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->modpis_v $ "99"
      cImposto := "Q07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   
   fwrite(nHandle, "S|"+terminador)
   cImposto := ""
   if nota2->mdcofins_v $ "01,02"
      cImposto := "S02"
   endif
   if nota2->mdcofins_v $ "03"
      cImposto := "S03"
   endif
   if nota2->mdcofins_v $ "04,06,07,08,09"
      cImposto := "S04"
   endif
   if nota2->mdcofins_v $ "99"
      cImposto := "S05"
   endif
   cImposto += "|"+nota2->mdcofins_v
   if nota2->mdcofins_v $ "01,02"
      cImposto += "|"+numerostring(nBaseDeCalculoCOFINS,14,2)
      cImposto += "|"+numerostring(nota2->cofins_v,6,2)
   endif
   if nota2->mdcofins_v $ "01,02,99"
      cImposto += "|"+numerostring(nValorCOFINS,14,2)
   endif
   cImposto += terminador
   fwrite(nHandle, cImposto)
   
   if nota2->mdcofins_v $ "99"
      cImposto := "S07|0|0"
      cImposto += terminador
      fwrite(nHandle, cImposto)
   endif
   nota2->(dbskip())
enddo
//nTotBC += nota->valfrete_v
//nTotICMS += nota->valfrete_v * nota->icmfrete_v / 100
fwrite(nHandle, "W|"+terminador)
fwrite(nHandle, "W02"+;
                "|"+numerostring(nTotBC,14,2)+;
                "|"+numerostring(nTotICMS,14,2)+;
                "|"+; // vICMSDeson
                "|"+; // vFCPUFDest
                "|"+; // vICMSUFDest
                "|"+; // vICMSUFRemet
                "|"+; // vFCP
                "|"+numerostring(nTotBCST,14,2)+;
                "|"+numerostring(nTotICMSST,14,2)+;
                "|"+; // vFCPST
                "|"+; // vFCPSTRet
                "|"+numerostring(nTotal,14,2)+;
                "|"+numerostring(nTotalFrete,14,2,.t.)+;
                "|"+; // seguro
                "|"+; // desconto
                "|"+; // total do II
                "|"+; // ipi
                "|"+; // vIPIDevol
                "|"+numerostring(nTotPIS,14,2)+; 
                "|"+numerostring(nTotCOFINS,14,2)+;
                "|"+; // despesas acessorias
                "|"+numerostring(nTotal+nTotalFrete,14,2)+;
                "|"+; // vTotTrib
                terminador)
frete := "0"
if !empty(nota->frete_v)
   frete := str(val(nota->frete_v)-1,1)
endif
fwrite(nHandle, "X|"+frete+terminador)
if nota->codtran_v>0
   transp->(dbsetorder(1), dbseek(nota->codtran_v))
   cgccpf := sonumero(transp->cgc_v)
   fwrite(nHandle, "X03"+;
                   "|"+alltrim(transp->nome_v)+;
                   "|"+sonumero(transp->insest_v)+;
                   "|"+alltrim(transp->endereco_v)+;
                   "|"+alltrim(transp->estado_v)+;
                   "|"+alltrim(transp->cidade_v)+terminador)
   if len(cgccpf)>11
      fwrite(nHandle, "X04|"+cgccpf+terminador)
   else
      fwrite(nHandle, "X05|"+cgccpf+terminador)
   endif
endif
if nota->valfrete_v>0
   fwrite(nHandle, "X11"+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->valfrete_v,14,2)+;
                   "|"+; //numerostring(nota->icmfrete_v,6,2)+;
                   "|"+; //numerostring((nota->valfrete_v*(nota->icmfrete_v/100)),14,2)+;
                   "|"+; //alltrim(sonumero(nota->cfop_v))+;
                   "|"+; //alltrim(if(cadcid->(dbsetorder(1),dbseek(clifor->cidade_v+clifor->estado_v)),cadcid->ibge_v,""))+;
                   terminador)
endif
fwrite(nHandle, "X18"+;
                "|"+alltrim(upper(nota->placa_v))+;
                "|"+alltrim(nota->uf_v)+;
                "|"+terminador)
fwrite(nHandle, "X26"+;
                "|"+numerostring(nota->qtd_v,15,0)+;
                "|"+alltrim(nota->especie_v)+;
                "|"+alltrim(nota->marca_v)+;
                "|"+alltrim(nota->numero_v)+;
                "|"+numerostring(val(nota->pesoliq_v),15,3)+;
                "|"+numerostring(val(nota->pesobru_v),15,3)+terminador)
if !empty(alltrim(nota->ficha_v))
   if tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v
         if tecfat->tpparc_v$"PU"
            parc++
            fwrite(nHandle, "Y07"+;
                            "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                            "|"+transform(dtos(tecfat->dtparc_v),"@r9999-99-99")+;
                            "|"+numerostring(tecfat->vrparc_v,15,2)+terminador)
         endif
         tecfat->(dbskip())
      enddo
   endif
else
   if pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
      fwrite(nHandle, "Y"+terminador)
      parc := 0
      do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v
         parc++
         fwrite(nHandle, "Y07"+;
                         "|"+strzero(nota->codigo_v,6)+"-"+alltrim(str(parc,2))+;
                         "|"+transform(dtos(pedfat->dtparc_v),"@r9999-99-99")+;
                         "|"+numerostring(pedfat->vrparc_v,15,2)+terminador)
         pedfat->(dbskip())
      enddo
   endif
endif
if !empty(alltrim(nota->msgfisc_v))
   fwrite(nHandle, "Z"+;
                   "|"+trim(nota->msgfisc_v)+;
                   "|"+terminador)
endif
//if !empty(alltrim(nota->observa1_v))
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+nota->observa1_v+terminador)
//endif
//if len(message)>0
//   cMessage := ""
//   for nTBascal := 1 to len(message)
//      cMessage += alltrim(message[nTBascal]) + " "
//   next
//   fwrite(nHandle, "Z"+;
//                   "|"+;
//                   "|"+cMessage+terminador)
//endif
fclose(nHandle)
return .t.


function get_files_nfe()
local aFiles, cgccpf, numnfe, nHandle, oXml, oNode, infNfe
dbf_cfgmail()
dbf_nfe()
if cfgmail->trace_v == 'S'
   altd()
endif
aFiles := array(adir(cfgmail->pathnfe_v))
adir(cfgmail->pathnfe_v, aFiles)
for i:=1 to len(aFiles)
	if .not. nfe->(dbsetorder(1), dbseek(aFiles[i]))
		nHandle := fopen(strtran(alltrim(cfgmail->pathnfe_v),"*.xml","")+aFiles[i])
		if nHandle > -1
      try
  			oXML := TXmlDocument():New(nHandle)
  			infNfe := oXml:FindFirst('infNFe')
  			numnfe := substr(infNfe:aAttributes['Id'],29,9)
  			oNode := oXML:FindFirst("dest")
  			if oNode <> nil
  				cgccpf := oNode:oChild:cData
  			endif
  			if nfe->(addrec(5))
  				nfe->arquivo_v := aFiles[i]
  				nfe->datcad_v := date()
  				nfe->cgccpf_v := cgccpf
  				nfe->numnfe_v := val(numnfe)
  				nfe->(dbcommit(), dbunlock())
  			endif
      catch oErr
      
      end
		endif		
		fclose(nHandle)
	endif
next
nfe->(dbclosearea())
cfgmail->(dbclosearea())
return .t.

function send_mail_nfe(recno_nfe)
local cServer       //:=      ""  					               // Required. IP or domain name of the mail server
local nPort         //:=      0                               // Optional. Port used my email server
local cFrom         //:=      ""                              // Required. Email address of the sender
local xTo           //:=      ""                              // Required. Character string or array of email addresses to send the email to
local xCC           :=      ""                              // Optional. Character string or array of email adresses for CC (Carbon Copy)
local xBCC          :=      ""                              // Optional. Character string or array of email adresses for BCC (Blind Carbon Copy)
local cBody         :=      "XML de Nota Fiscal Eletronica" // Optional. The body message of the email as text, or the filename of the HTML message to send.
local cSubject      :=      "XML de Nota Fiscal Eletronica" // Optional. Subject of the sending email
local aFiles        //:=      {}                              // Optional. Array of files attachments to the email to send {{"a"},{"b"}}
local cUser         //:=      ""                              // Required. User name for the POP3 server
local cPass         //:=      ""                              // Required. User password for the POP3 server
local cPopServer    //:=      ""                              // Required. POP3 server name or address
local nPriority     :=      3                               // Optional. Email priority: 1=High,3=Normal (Standard), 5=Low
local lRead         :=      .f.                             // Optional. If set to .T., a confirmation request is send. Standard setting is .F.
local bTrace        :=      .f.                             // Optional. If set to .T., a log file is created (smtp-<nNr>.log). Standard setting is NIL.
                                                            // If a block is passed, it will be called for each log event with the message a string, no param on session close.
local lPopAuth      :=      .f.                             // Optional. Do POP3 authentication before sending mail.
local lNoAuth       :=      .f.                             // Optional. Disable Autentication methods
local nTimeOut      :=      1000                            // Optional. Number os ms to wait default 20000 (20s)
local cReplyTo      :=      ""                              // Optional. mail address to reply to
local lTLS          :=      .F.                             // Optional. Set to .t. if you want/need to use Transport Layer Security default to .F.
local cSMTPPass     //:=      ""                    				// Optional. Character string password for SMTP server if needed
local cCharset      :=      ""                              // Character set to be used, default to "ISO-8859-1"
local cEncoding     :=      ""                              // Optional. Encode option to be used, default to "quoted-printable"
local cFile
dbf_cfgmail()
if recno_nfe == nil
   dbf_nfe()
   dbf_clifor()
endif
cServer := alltrim(cfgmail->smtpsrv_v)
nPort := cfgmail->port_v
cFrom := alltrim(cfgmail->user_v)
cUser := cFrom
cPass := alltrim(cfgmail->password_v)
cSMTPPass := cPass
cPopServer := alltrim(cfgmail->popsrv_v)
if cfgmail->trace_v == 'S'
  bTrace := .t.
endif
if !empty(alltrim(cfgmail->smtpsrv_v))
   if recno_nfe == nil
	   nfe->(dbsetorder(2), dbseek(date()-7, .t.))
	else
	   nfe->(dbgoto(recno_nfe))
	endif
	do while !nfe->(eof())
		if empty(nfe->datenv_v)
		   if empty(nfe->email_v)
   			if clifor->(dbsetorder(5), dbseek("C"+lpad(alltrim(nfe->cgccpf_v),19)))
   				nfe->(reclock(5))
   				nfe->email_v := clifor->emailnf_v
   				nfe->(dbcommit(), dbunlock())
   			endif
   	   endif
			if (!empty(nfe->email_v))
				cFile := strtran(alltrim(cfgmail->pathnfe_v),"*.xml","")+alltrim(nfe->arquivo_v)
				aFiles := {cFile}
				xTo := alltrim(nfe->email_v)
				if hb_SendMail( cServer, nPort, cFrom, xTo, xCC , xBCC , cBody, cSubject, aFiles, cUser, cPass, cPopServer, nPriority, lRead, bTrace,lPopAuth,lNoAuth, nTimeOut, cReplyTo, lTLS , cSMTPPass, cCharset, cEncoding )
					nfe->(reclock(5))
					nfe->datenv_v := date()
					nfe->(dbcommit(), dbunlock())
				endif
			endif
		endif
		if recno_nfe <> nil
		   exit
		endif
		nfe->(dbskip())
	enddo
endif
if recno_nfe == nil
   nfe->(dbclosearea())
   clifor->(dbclosearea())
endif
cfgmail->(dbclosearea())
return .t.

function mail_nfe()
	get_files_nfe()
	send_mail_nfe()
return .t.

function teste_nfe()
	local cFiles := "\\192.168.0.100\akosa\Desktop\ARQUIVO XML\09-2012\*.xml"
	LOCAL aFiles[ADIR(cFiles)]

 	 local cServer       :=      "smtp.xmig.com.br"              // Required. IP or domain name of the mail server
   local nPort         :=      587                              // Optional. Port used my email server
   local cFrom         :=      "no-reply@xmig.com.br"          // Required. Email address of the sender
   local xTo           :=      "nelsonota@gmail.com"           // Required. Character string or array of email addresses to send the email to
   local xCC           :=      ""                              // Optional. Character string or array of email adresses for CC (Carbon Copy)
   local xBCC          :=      ""                              // Optional. Character string or array of email adresses for BCC (Blind Carbon Copy)
   local cBody         :=      "Please ignore only a test..."  // Optional. The body message of the email as text, or the filename of the HTML message to send.
   local cSubject      :=      "Test from Harbour"             // Optional. Subject of the sending email
   //local aFiles        :=      {cFiles }                              // Optional. Array of files attachments to the email to send {{"a"},{"b"}}
   local cUser         :=      "no-reply@xmig.com.br"          // Required. User name for the POP3 server
   local cPass         :=      "xurumela"                      // Required. User password for the POP3 server
   local cPopServer    :=      "pop3.xmig.com.br"              // Required. POP3 server name or address
   local nPriority     :=      3                               // Optional. Email priority: 1=High,3=Normal (Standard), 5=Low
   local lRead         :=      .f.                             // Optional. If set to .T., a confirmation request is send. Standard setting is .F.
   local bTrace        :=      .t.                             // Optional. If set to .T., a log file is created (smtp-<nNr>.log). Standard setting is NIL.
                                                               // If a block is passed, it will be called for each log event with the message a string, no param on session close.
   local lPopAuth      :=      .f.                             // Optional. Do POP3 authentication before sending mail.
   local lNoAuth       :=      .f.                             // Optional. Disable Autentication methods
   local nTimeOut      :=      1000                            // Optional. Number os ms to wait default 20000 (20s)
   local cReplyTo      :=      ""                              // Optional. mail address to reply to
   local lTLS          :=      .F.                             // Optional. Set to .t. if you want/need to use Transport Layer Security default to .F.
   local cSMTPPass     :=      "xurumela"                      // Optional. Character string password for SMTP server if needed
   local cCharset      :=      ""                              // Character set to be used, default to "ISO-8859-1"
   local cEncoding     :=      ""                              // Optional. Encode option to be used, default to "quoted-printable"

  ADIR(cFiles, aFiles)
  //AEVAL(aFiles, { |element| QOUT(element) })
  cFiles := "\\192.168.0.100\akosa\Desktop\ARQUIVO XML\09-2012\" + aFiles[len(aFiles)]
  aFiles := {cFiles}

 ? "Sending mail..."
  if  hb_SendMail( cServer, nPort, cFrom, xTo, xCC , xBCC , cBody, cSubject, aFiles, cUser, cPass, cPopServer, nPriority, lRead, bTrace,lPopAuth,lNoAuth, nTimeOut, cReplyTo, lTLS , cSMTPPass, cCharset, cEncoding )
       ? "An email was sent..."
   else
      alert("Cannot contact the mail server ","Please verify parameter or the connection...")
  endif

   /*Util := CreateObject( "NFe_util_PL005a.util" ) // A DLL tem que estar na pasta do aplicativo, se estiver em outro local não roda.

                                                                   // para versão 2G, utilizar "Util := CreateObject("NFe_Util_2G.util")

   ConsultaStatus()*/
return nil

*********************************************************************************
FUNCTION ConsultaStatus()
*********************************************************************************
Local nRetorno
Local msgRetWS       := ''    // Estas
Local msgResultado := ''    // variaveis
Local msgCabec       := ''    // não podem
Local MsgDados       := ''   // ficar sem declaração, declare pelo menos ''. Se ficarNil não funciona   ** fazer isto em todas as chamadas (funções)
Local ProxyName:='',Proxyuser:='',ProxyPassword:=''

Local UnidadeFederativa := 'SP'
Local AmbienteCodigo    := '2'

Local CertificadoDigital := "XXXXXX"  //=====<<< DEFINIR AQUI CADEIA DO CERTIFICADO

If (nRetorno:=Util:ConsultaStatus(UnidadeFederativa,;
                                     AmbienteCodigo,;
                                    CertificadoDigital,;
                                    msgCabec, MsgDados, @msgRetWS , @msgResultado,;
                                    ProxyName,;
                                    ProxyUser,;
                                    ProxyPassword ))==0

    ? msgRetWS   // XML DE RETORNO DO STATUS

Else
    ? retorno,msgResultado
Endif

Return Nil
/////////////////////////////////////////////////////////////////////////////////