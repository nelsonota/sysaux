#define HB_EXT_INKEY
#INCLUDE "ACHOICE.CH"
#include "inkey.ch"

function vendas()
local  tela, getlist:={}
local dDataEmissao
local cRevenda, nItem, lIgnoraTravaQuantidade := .f.
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
memvar blqven,sysven, codigo, cUFVenda, cPessoa, aItens

tela := savescreen()
dbf_config()
dbf_pedido()
dbf_2pedido()
dbf_clifor()
dbf_estoque()
dbf_mecven()
dbf_bascal()
dbf_moeda()
dbf_system()
dbf_plano()
dbf_pagrec()
dbf_pedfat()
dbf_cfop()
WINDOW(0,0,24,79)
@ 00,01 say "Pedido de Venda" color cortit	
do while .t.
   scroll(1,1,23,78,0)
   @ 1,2 say "Pedido:        Data:            UF:    Revenda:   Tipo Pessoa:   NF:"
   @ 2,2 say "Cliente:"
   //         234567890123456789012345678901234567890123456789012345678901234567890
   //                 v12345       11;11;1111
   @ 3,1 to 3,78
 //@ 4,1 say " Qtd Codigo       Descricao                                 Vr.Unit   Vr.Total"
   //         1234 123456789012 12345678901234567890123456789012345678 999,999.99 999,999.99
   //         234567890123456789012345678901234567890123456789012345678901234567890123456789
   @ 4,1 say " Qtd Codigo       Descricao                  Vr.Unit   Vr.Total BCalc%   ICMS%"
   //         1234 123456789012 12345678901234567890123 999,999.99 999,999.99 999.99 99.9999
   @ 5,1 to 5,78
   @ 17,1 to 17,78
   @ 18,2 say "CFOP:"
   @ 19,1 to 19,78
   @ 20,2 say "Mao de Obra:" + transform(0,"@r 999,999.99") + " Frete: " + transform(0,"@r 999,999.99") + " Itens: " + transform(0,"@r 999,999.99")
   @ 21,1 to 21,78
   @ 23,2 say "F2-Proxima Tela F7-Imprime Pedido"
   if !empty(pedido->clifor_v)
      @ 23,36 say "F5-Cancelar Pedido"
   endif
   codigo := space(len(pedido->codigo_v))
   aItens := {}
   @ 1,10 get codigo pict "@!" valid alltrim(codigo)=="V" .or. sea_pedido(codigo,"V",if(blqven='S',sysven,nil))
   read
   if lastkey()=27
      exit
   endif
   if alltrim(codigo)=="V"
      cUFVenda := decrip(config->estado_v)
      dDataEmissao := date()
      cRevenda := "N"
      cPessoa := "F"
      if pedido->(addrec())
         do while .not. config->(reclock())
         enddo
         config->pedven_v := config->pedven_v+1
         pedido->codigo_v := "V"+strzero(config->pedven_v,5,0)
         PEDIDO->TIPO_V    :="D"
         pedido->datemi_v := dDataEmissao
         pedido->horaemi_v:= time()
         pedido->nomsen_v := nomsen
         config->(dbcommit(),dbunlock())
         
         if system->(addrec()) .and. config->(reclock())
            config->system_v+=1
            system->codigo_v := config->system_v
            system->data_v   := date()
            system->hora_v   := time()
            system->descr_v  := "Inclusao pedido de venda "+pedido->codigo_v
            system->usuario_v:= nomsen
            pedido->system_v := system->codigo_v
            system->(dbcommit(), dbunlock())
            config->(dbcommit(), dbunlock())
         endif
         
         codigo := pedido->codigo_v
         @1,10 say codigo
      else
         loop
      endif
   else
      if left(codigo,1)<>"V"
         aviso("Este nao e' um numero de pedido de venda")
         loop
      endif
      if !clifor->(dbsetorder(1), dbseek(pedido->clifor_v))
         aviso("O cliente do pedido nao foi encontrado." + pedido->clifor_v)
         loop
      endif
      if empty(pedido->datfat_v)
         pedvimp(pedido->codigo_v,.t.)
      endif
      pedido->(reclock(5))
      codigo := pedido->codigo_v
      @ 2,11 say clifor->nome_v
      cUFVenda := clifor->estado_v
      cPessoa := clifor->pessoa_v
      cRevenda := clifor->revenda_v
      dDataEmissao := pedido->datemi_v
      pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
      do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
         aadd(aItens, str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(if(estoque->(dbsetorder(1), dbseek(pedido2->item_v)),estoque->nome_v,space(len(estoque->nome_v))),23)+" "+transform(pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8))
         pedido2->(dbskip())
      enddo
   endif
   aadd(aItens," ")
   @ 1,23 say dtoc(dDataEmissao)
   if !empty(pedido->datcan_v)
      @ 2,58 say "Cancelado: " + dtoc(pedido->datcan_v) color cortit
   endif
   
   @ 1,38 get cUFVenda pict "!!" when empty(pedido->clifor_v) valid !empty(cUFVenda)
   @ 1,50 get cRevenda pict "!" when empty(pedido->clifor_v) valid cRevenda$"SN"
   @ 1,65 get cPessoa pict "!" when empty(pedido->clifor_v) valid cPessoa$"FJ"
   @ 1,71 say strzero(pedido->nota_v,6)
   read
   if lastkey()=27
      VerificaPedido(codigo)
      loop
   endif
   do while .t.
      keyboard chr(3)
      if lIgnoraTravaQuantidade
         @23,59 say "Sem trava quantidade"
      else
         @23,59 say "                    "
      endif
      @ 20,2 say "Mao de Obra:" + transform(pedido->valmo_v,"@r 999,999.99") + " Frete: " + transform(pedido->frete_v,"@r 999,999.99") + " Itens: " + transform(pedido->valtot_v,"@r 999,999.99") + " Total: " + transform(pedido->valtot_v + pedido->valmo_v + pedido->frete_v,"@r 999,999.99")
      vendas_atualizatotais(aItens)
      nItem := len(aItens)
      nItem := achoice(6,1,16,78,aItens,.t.,"acvendas")
      if nItem == 0
         pedido->(dbunlock())
         exit
      endif
      if lastkey() == -1
         if len(aItens)>1
            vendas_fechapedido(cUFVenda,cRevenda,cPessoa)
            if empty(pedido->clifor_v)
               loop
            endif
            exit
         endif
      elseif lastkey() = K_F5 .and. !empty(pedido->clifor_v)
         CancelaPedido(pedido->codigo_v)
         exit
      elseif lastkey() == K_CTRL_T
         lIgnoraTravaQuantidade := !lIgnoraTravaQuantidade
      else
         if empty(right(aItens[nItem],8))
            if lIgnoraTravaQuantidade .or. len(aItens)-1 < config->qtditens_v
               vendas_additem(@aItens, nItem, cRevenda)
            else
               aviso("O pedido pode ter no maximo " + str(config->qtditens_v,2)+" itens.")
            endif
         else
            pedido2->(dbgoto(val( right(aItens[nItem],8) )))
            vendas_edititem(@aItens, nItem, cRevenda)
         endif
      endif
   enddo
   VerificaPedido(codigo)
   
enddo
cfop->(dbclosearea())
pagrec->(dbclosearea())
plano->(dbclosearea())
config->(dbclosearea())
pedido->(dbclosearea())
pedido2->(dbclosearea())
estoque->(dbclosearea())
clifor->(dbclosearea())
mecven->(dbclosearea())
moeda->(dbclosearea())
bascal->(dbclosearea())
system->(dbclosearea())
pedfat->(dbclosearea())
restscreen(,,,,tela)
return nil

function acvendas( nMode, nCurElement, nRowPos )
LOCAL nRetVal := AC_CONT
LOCAL nKey := LASTKEY()

DO CASE
   CASE nMode = AC_EXCEPT
      DO CASE
         CASE nKey == 27
            nRetVal := AC_ABORT
         CASE nKey == 13
            nRetVal := AC_SELECT
         CASE nKey == -1
            nRetVal := AC_SELECT
         CASE nKey == K_F5
            nRetVal := AC_SELECT
         CASE nKey == K_CTRL_T
            nRetVal := AC_SELECT
         CASE nKey == -6
            if confirma(20,20,"Deseja imprimir o pedido ?")
               imppedido(pedido->codigo_v)
            endif
      ENDCASE
ENDCASE
if !empty(alltrim( right(aItens[nCurElement],8) ))
   pedido2->(dbgoto(val( right(aItens[nCurElement],8) )))
   @ 18,8 say pedido2->cfop_v + " " + if(cfop->(dbsetorder(1), dbseek(pedido2->cfop_v)), cfop->mensagem_v, "")
else
   @ 18,8 say space(len(pedido2->cfop_v+cfop->mensagem_v)+1) 
endif

return nRetVal

procedure vendas_additem(aItens, nItem, cRevenda)
local getlist := {}, nQtd, ValUni, linha, lLibera := .t.
local tela := savescreen()
memvar item, cPessoa, cUFVenda, cfop
if !empty(pedido->datfat_v)
   lLibera := .f.
   aviso("Pedido ja faturado.")
elseif !empty(pedido->datcan_v)
   lLibera := .f.
   aviso("Pedido cancelado.")
endif
if lLibera
   nQtd := 0
   item := space(len(estoque->codigo_v))
   valuni := 0
   linha := row()
   cfop := space(len(pedido2->cfop_v))
   window(linha-1,0,linha+2,79)
   @ linha,1 get nQtd pict "9999" valid nQtd > 0
   @ linha,6 get item pict "@!" valid(sea_estoque(item) .and. avisoest("V", nQtd) .and. vendas_f1(item, @ValUni, cRevenda, linha) )
   @ linha,43 get ValUni pict "@r 999,999.99" valid ValUni > 0 .and. vendas_calcvrtot(nqtd,valuni,linha)
   @ linha+1,1 say "CFOP:" get cfop valid SEA_CFOP(CFOP,linha+1,18) when VendasDefaultCFOP(item, cUFVenda, @cfop)
   read
   if lastkey()<>27
      if confirma(20,20,"Confirma item ?")
         if estoque->(dbsetorder(1), dbseek(item))
            pedido2->(addrec(5))
            
            pedido2->codigo_v := pedido->codigo_v
            pedido2->datemi_v := pedido->datemi_v
            pedido2->item_v   := item
            pedido2->qtd_v    := nqtd
            pedido2->valuni_v := valuni
            pedido2->valcus_v := estoque->valcus_v
            pedido2->valmin_v := estoque->valven_v
            pedido2->valmed_v := if(config->multprcv_v='s',estoque->valmed_v,estoque->valven_v)
            pedido2->valmax_v := estoque->valmax_v
            pedido2->cfop_v   := cfop
            pedido2->sittaba_v:= estoque->sittaba_v
            pedido2->sittabb_v:= estoque->sittabb_v
            
            pedido->valcus_v += pedido2->valcus_v
            pedido->valmed_v += pedido2->valmed_v
            pedido->valmin_v += pedido2->valmin_v
            pedido->valmax_v += pedido2->valmax_v
            
            pedido->valtot_v += (pedido2->valuni_v * pedido2->qtd_v)
            
            if empty(pedido->datbai_v)
               estoque->(reclock(5))
               estoque->reserva_v += nQtd
               estoque->(dbunlock())
            else
               movest("S",pedido2->item_v, "VM", nQtd, pedido2->codigo_v, pedido2->valuni_v)
               pedido2->datbai_v := date()
            endif
            
            pedido2->(dbcommit(),dbunlock())
            
            pedvimpitem(.t., cPessoa, cUFVenda)
            aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(estoque->nome_v,23)+" "+transform(pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
            aadd(aItens," ")
         endif
      endif
   endif
endif
restscreen(,,,,tela)
return

procedure vendas_edititem(aItens, nItem)
local getlist := {}, nQtd, ValUni, linha, nOldQtd, OldValUni, lLibera := .t.
local tela := savescreen()
memvar cPessoa, cUFVenda, cfop
if !empty(pedido->datfat_v)
   lLibera := .f.
   aviso("Pedido ja faturado.")
elseif !empty(pedido->datcan_v)
   lLibera := .f.
   aviso("Pedido cancelado.")
endif
if lLibera
   nQtd := pedido2->qtd_v
   valuni := pedido2->valuni_v
   cfop := pedido2->cfop_v
   nOldQtd := pedido2->qtd_v
   Oldvaluni := pedido2->valuni_v
   OldCFOP := pedido2->cfop_v
   linha := row()
   window(linha-1,0,linha+2,79)
   @ linha,1 get nQtd pict "9999" valid nQtd >=0 .and. avisoest("V", (nOldQtd * -1) + nQtd)
   @ linha,43 get ValUni pict "@r 999,999.99" when nQtd>0 valid ValUni > 0 .and. vendas_calcvrtot(nqtd,valuni,linha)
   @ linha+1,1 say "CFOP:" get cfop valid SEA_CFOP(CFOP,linha+1,18) when VendasDefaultCFOP(pedido2->item_v, cUFVenda, @cfop)
   read
   if lastkey()<>27
      if nOldQtd <> nQtd .or. OldValUni <> ValUni .or. OldCFOP <> cfop
         if confirma(20,20,"Confirma item ?")
            if estoque->(dbsetorder(1), dbseek(pedido2->item_v))
               if OldCFOP <> cfop .and. nQtd > 0
                  pedido2->(reclock())
                  pedido2->cfop_v := cfop
                  pedido2->(dbcommit(), dbunlock())
               endif
               
               
               if nOldQtd <> nQtd .or. OldValUni <> ValUni
                  pedido->valtot_v -= (OldValUni * nOldQtd)
                  
                  pedido2->(reclock(5))
                  if nQtd>0
                     pedido2->qtd_v    := nqtd
                     pedido2->valuni_v := valuni
                     pedido->valtot_v += (pedido2->valuni_v * pedido2->qtd_v)

                     pedido2->(dbcommit(), dbunlock())
                     pedvimpitem(.t., cPessoa, cUFVenda)
                     aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(estoque->nome_v,25)+" "+transform(pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
                  else
                     pedido2->(dbdelete())
                     pedido2->(dbcommit(), dbunlock())
                     adel(aItens, nItem)
                     asize(aItens, len(aItens) -1 )
                  endif
                  if empty(pedido->datbai_v)
                     estoque->(reclock(5))
                     estoque->reserva_v -= nOldQtd
                     if nQtd>0
                        estoque->reserva_v += nQtd
                     endif
                     estoque->(dbunlock())
                  else
                     movest("E",pedido2->item_v, "VM", nOldQtd, pedido2->codigo_v, OldValUni)
                     if nQtd>0
                        movest("S",pedido2->item_v, "VM", nQtd, pedido2->codigo_v, ValUni)
                     endif
                  endif
               endif
            endif
         endif
      endif
   endif
endif
restscreen(,,,,tela)
return

function vendas_f1(cCodigo, nVrUnit, cRevenda, linha)

if estoque->(dbsetorder(1), dbseek(cCodigo))
   @ linha,19 say left(estoque->nome_v,25)
   
   if crevenda = "S"
      if estoque->moeda_v="U"
         nVrUnit := estoque->valrev_v*moeda->valor_v
      else
         nVrUnit := estoque->valrev_v
      endif
   else
      if estoque->moeda_v="U"
         nVrUnit := if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)*moeda->valor_v
      else
         nVrUnit := if(config->multprcv_v='S',estoque->valmed_v,estoque->valven_v)
      endif
   endif
endif
return .t.

function vendas_calcvrtot(nqtd, valuni, linha)
@ linha,69 say transform(nqtd * valuni, "@r 999,999.99")
return .t.

procedure vendas_fechapedido(cUFVenda,cRevenda,cPessoa)
local tela := savescreen()
local linserv1, linserv2, linserv3, linserv4, pedcliente
local getlist:={}, tela2, dtbaixa, registrar, i
local dtparc:=array(0),vrparc:=array(0),docext:=array(0), dtfaturamento, observa1
local aFatura := array(0)
local cWS := "", nWs:=0, cParc
memvar frete,valmo
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
memvar codpla
//window(2,0,22,79)
scroll(2,1,22,78,0)
if empty(alltrim(pedido->mecven_v))
   mecven->(dbsetorder(1),dbseek("V"))
else
   mecven->(dbsetorder(1), dbseek(pedido->mecven_v))
endif
clifor->(dbsetorder(2),dbseek("CONSUMIDOR",.t.),dbsetorder(1))
observa1 := pedido->observa1_v
valmo := pedido->valmo_v
linserv1:=pedido->linserv1_v
linserv2:=pedido->linserv2_v
linserv3:=pedido->linserv3_v
linserv4:=pedido->linserv4_v
frete := pedido->frete_v
pedcliente := pedido->pedcli_v
dtbaixa := if(!empty(pedido->datbai_v),pedido->datbai_v,date())
dtfaturamento := if(!empty(pedido->datfat_v),pedido->datfat_v, date())
plano->(dbgotop())
codpla := space(len(plano->codigo_v))
do while .t.
   scroll(4,1,21,78,0)
   if empty(pedido->clifor_v)
      vendas_telafecha(.t.)
      do while .t.
         dbe_mecven(5,10,15,70)
         if left(mecven->codigo_v,1)="V" .or. lastkey()=27
            exit
         endif
         aviso("E' necessario que seja selecionado um vendedor...")
      enddo
      if lastkey()=27
         exit
      endif
      @ 02,12 SAY left(mecven->nome_v,28)
      if !vendas_seleciona_cliente()
         loop
      endif
   else
      clifor->(dbsetorder(1), dbseek(pedido->clifor_v))
   endif
   vendas_telafecha(.f.)
   if empty(pedido->datbai_V) .or. empty(pedido->datfat_v)
      @ 09,15 get observa1 pict "@s60" when empty(pedido->datfat_v)
      @ 10,9 get frete pict "@r 999,999.99" when empty(pedido->datfat_v)
      @ 10,40 get pedcliente when empty(pedido->datfat_v)
      @ 10,64 get valmo pict "@r 999,999.99" when empty(pedido->datfat_v)
      @ 12,2 get linserv1 pict "@!" when empty(pedido->datfat_v)
      @ 13,2 get linserv2 pict "@!" when empty(pedido->datfat_v)
      @ 14,2 get linserv3 pict "@!" when empty(pedido->datfat_v)
      @ 15,2 get linserv4 pict "@!" when empty(pedido->datfat_v)
      @ 17,16 get dtbaixa valid empty(dtbaixa) .or. dtbaixa=date() when empty(pedido->datbai_v)
      @ 17,40 get dtfaturamento when empty(pedido->datfat_v)
      @ 18,27 say "Plano de Conta:      Parcelas:   Intervalo:"
      @ 18,43 get codpla pict "@!" valid(sea_codpla(codpla,,,"+")) when !empty(dtfaturamento)
      read
      if lastkey()=K_ESC
         if !empty(pedido->clifor_v)
            exit
         else
            loop
         endif
      endif
      if lastkey()==K_PGDN .or. lastkey()==K_PGUP
         loop
      endif
      if !empty(dtfaturamento)
         if !DesmembraParcelas(pedido->valtot_v + valmo, frete, @dtparc, @vrparc, @docext)
            loop
         endif
      endif
      if confirma(20,20,"Confirma todos os dados do pedido?")
         if empty(pedido->clifor_v)
            pedido->clifor_v := clifor->codigo_v
            pedido->mecven_v := mecven->codigo_v
         endif
         pedido->observa1_v := observa1
         pedido->frete_v := frete
         pedido->valmo_v := valmo
         pedido->linserv1_v := linserv1
         pedido->linserv2_v := linserv2
         pedido->linserv3_v := linserv3
         pedido->linserv4_v := linserv4
         pedido->pedcli_v := pedcliente
         if empty(pedido->datbai_V) .and. !empty(dtbaixa)
            pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
            do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
               pedido2->(reclock(5))
               if estoque->(dbsetorder(1), dbseek(pedido2->item_v))
                  estoque->(reclock(5))
                  estoque->reserva_v -= pedido2->qtd_v
                  estoque->(dbcommit(), dbunlock())
                  movest("S",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v, pedido2->valuni_v)
               endif
               pedido2->datbai_v := date()
               pedido2->(dbcommit(),dbunlock())
               pedido2->(dbskip())
            enddo
            pedido->datbai_v  := date()
         endif
         if !empty(dtfaturamento)
            pedido->codpla_v  := codpla
            pedido->datfat_v  := dtfaturamento
            pedido->datpag_v  := dtparc[1]
            pedido->datpag1_v := dtparc[2]
            pedido->datpag2_v := dtparc[3]
            pedido->datpag3_v := dtparc[4]
            pedido->datpag4_v := dtparc[5]
            pedido->valpar_v  := vrparc[1]
            pedido->valpar1_v := vrparc[2]
            pedido->valpar2_v := vrparc[3]
            pedido->valpar3_v := vrparc[4]
            pedido->valpar4_v := vrparc[5]
            pedido->docext_v  := docext[1]
            pedido->docext1_v := docext[2]
            pedido->docext2_v := docext[3]
            pedido->docext3_v := docext[4]
            pedido->docext4_v := docext[5]
            if config->autven_v="P" .and. config->tipaut_v=='P'
               if confirma(20,20,"Registrar Contas Futuras ?")
                  registrar:="S"
               else
                  registrar:="N"
               endif
            else
               registrar:=if(config->autven_v=='S' .and. config->tipaut_v=='P', 'S', 'N')
            endif
            
            for i := 1 to len(dtparc)
               if !empty(dtparc[i]) .and. vrparc[i]>0
                  pagrec := ""
                  if registrar == "S"
                     pagrec->(addrec(5))
                     config->(reclock())
                     pagrec:="R"+strzero(config->pagrec_v+1,5,0)
                     config->pagrec_v:=config->pagrec_v+1
                     config->(dbunlock())
                     pedido->pagrec1_v:=pagrec
                     pagrec->codigo_v :=pagrec
                     pagrec->clifor_v :=pedido->clifor_v
                     pagrec->codpla_v :=codpla
                     pagrec->pedido_v :=pedido->codigo_v
                     pagrec->valor_v  :=vrparc[i]
                     pagrec->datven_v :=dtparc[i]
                     pagrec->docext_v :=docext[i]
                     pagrec->datext_v :=date()
                     pagrec->desc_v   :="Venda pedido "+pedido->codigo_v
                     pagrec->(dbunlock())
                     nWs ++
                     cParc := alltrim(str(nWs))
                     cWS += "dtvenc"+cParc+"="+dtos(pagrec->datven_v)+;
                            "&descr"+cParc+"="+alltrim(pagrec->desc_v)+;
                            "&val"+cParc+"="+alltrim(str(valor_v,14,2))+;
                            "&dtint"+cParc+"="+alltrim(dtos(pedfat->datext_v))+;
                            "&docint"+cParc+"="+alltrim(pagrec->docext)
                  endif
                  pedfat->(addrec(5))
                  pedfat->id_v := lastid("pedfat")
                  pedfat->codigo_v := pedido->codigo_v
                  pedfat->datemi_v := pedido->datemi_v
                  pedfat->dtparc_v := dtparc[i]
                  pedfat->vrparc_v := vrparc[i]
                  pedfat->docext_v := docext[i]
                  pedfat->pagrec_v := pagrec
                  pedfat->(dbcommit(), dbunlock())
               endif
            next
            if (!empty(cWs))
               cWs += "&codcli="+alltrim(clifor->codigo_v)+;
                      "&nome="+alltrim(clifor->nome_v)+;
                      "&apelido="+alltrim(clifor->fantasia_v)+;
                      "&pessoa="+alltrim(clifor->pessoa_v)+;
                      "&doc="+alltrim(clifor->cgccpf_v)+;
                      "&rgie="+alltrim(clifor->rginsest_v)+;
                      "&end="+alltrim(clifor->endereco_v)+;
                      "&numend="+alltrim(clifor->numero_v)+;
                      "&compend="+alltrim(clifor->complem_v)+;
                      "&bairro="+alltrim(clifor->bairro_v)+;
                      "&cidade="+alltrim(clifor->cidade_v)+;
                      "&uf="+alltrim(clifor->estado_v)+;
                      "&cep="+alltrim(clifor->cep_v)+;
                      "&fone1="+alltrim(clifor->fone1_v)+;
                      "&fone2="+alltrim(clifor->fone2_v)+;
                      "&fax="+alltrim(clifor->fax_v)+;
                      "&email="+alltrim(clifor->email_v)+;
                      "&ref1="+alltrim(clifor->refere1_v)+;
                      "&telref1="+alltrim(clifor->telref1_v)+;
                      "&ref2="+alltrim(clifor->refere2_v)+;
                      "&telref2="+alltrim(clifor->telref2_v)+;
                      "&ref1="+alltrim(clifor->refere1_v)+;
                      "&revenda="+alltrim(clifor->revenda_v)+;
                      "&contato="+alltrim(clifor->contato_v)+;
                      "&cend="+alltrim(clifor->endcob_v)+;
                      "&cnumend="+alltrim(clifor->numcob_v)+;
                      "&ccompend="+alltrim(clifor->compcob_v)+;
                      "&cbairro="+alltrim(clifor->baicob_v)+;
                      "&ccidade="+alltrim(clifor->cidcob_v)+;
                      "&cuf="+alltrim(clifor->estcob_v)+;
                      "&ccep="+alltrim(clifor->cepcob_v)+;
                      "&eend="+alltrim(clifor->endent_v)+;
                      "&enumend="+alltrim(clifor->nument_v)+;
                      "&ecompend="+alltrim(clifor->compent_v)+;
                      "&ebairro="+alltrim(clifor->baient_v)+;
                      "&ecidade="+alltrim(clifor->cident_v)+;
                      "&euf="+alltrim(clifor->estent_v)+;
                      "&ecep="+alltrim(clifor->cepent_v)
               
            endif
            if pedido->datemi_v > clifor->datped_v
               clifor->(reclock(5))
               clifor->datped_v := pedido->datemi_v
               clifor->ultped_v := pedido->codigo_v
               clifor->valped_v := pedido->valtot_v
               clifor->(dbcommit(),dbunlock())
            endif
            if pedido->valtot_v > clifor->valmai_v
               clifor->(reclock(5))
               clifor->datmai_v := pedido->datemi_v
               clifor->pedmai_v := pedido->codigo_v
               clifor->valmai_v := pedido->valtot_v
               clifor->(dbcommit(),dbunlock())
            endif
         endif
         pedido->(dbcommit(), dbunlock())
         if confirma(20,20,"Deseja imprimir o pedido ?")
            imppedido(pedido->codigo_v)
         endif
      else
         loop
      endif
   else
      if !empty(pedido->datfat_v)
         scroll(23,1,23,78,0)
         @23,41 say "F6-Cancelar faturamento F8-Faturamento"
         if left(pedido->codigo_v,1)=="V" .and. empty(pedido->nota_v)
            @ 23,24 say "F5-Mudar Cliente"
         endif
      endif
      inkey(0)
      if !empty(pedido->datfat_v)
         if lastkey() == K_F5
            MudarClientePedido(pedido->codigo_v)
         endif
         if lastkey() == K_F6
            CancelaFatPedido(pedido->codigo_v)
         endif
         if lastkey() == K_F8
            VisualizaFatPedido(pedido->codigo_v)
         endif
      endif
   endif
   exit
enddo
restscreen(,,,,tela)
return

function montaparc(parc,inter,dtparc,vrparc,nota,docext)
local i,totalizador,coluna
memvar frete, valmo
if parc>1
   totalizador := 0
   for i := 1 to parc
      if i>1
         dtparc[i] := dtparc[i-1]+inter
      endif
      vrparc[i] := round((pedido->valtot_v + frete + valmo) / parc,2)
      if nota <> nil .and. docext <> nil
         docext[i] := "NF"+strzero(nota,6)+"-"+str(i,1)
      endif
      totalizador += vrparc[i]
   next
   vrparc[parc] += (pedido->valtot_v + frete + valmo) - totalizador // acerto de arredondamento na ultima parcela. Ex.: (100,00 / 3)
   for i := 1 to parc
      coluna := ((i+1)*11)
      @ 19,coluna say dtoc(dtparc[i])
      @ 20,coluna say transform(vrparc[i], "@r 999,999.99")
   next
else
   vrparc[1] := pedido->valtot_v + frete + valmo
endif
return .t.

procedure vendas_telafecha(lSomenteTela)
local nClifor := clifor->(recno())
@ 02,2 say "Vendedor: "
@ 03,02 say "Cliente    : "
@ 4,2  say "Endereco   : "
@ 5,2  say "Bairro     : "
@ 5,45 say "C.E.P. : "
@ 6,2  say "Cidade     : "
@ 6,45 say "Estado : "
@ 7,2  say "Telefone   : "
@ 7,45 say "CGC/CPF: "
@ 8,2 say "RG/Ins.Est.: "
@ 9,2 say "Observacoes: "
@ 10,2 say "Frete:             Pedido do Cliente:            Mao de Obra:"
@ 11,2 say "Descricao da mao de obra:"
//@ 18,2 say "Baixa Pedido:            Plano de Conta:      Parcelas:   Intervalo:"
@ 16,1 to 16,78
@ 17,2 say "Baixa Pedido:"
//                        00.00.0000                 9999           9            99
@ 17,27 say "Faturamento:"
@ 19,02 say "Vencimento        :"
@ 20,02 say "Valor da Parcela  :"
@ 21,02 say "Doc.Ext.da Parcela:"
if !lSomenteTela  
   @ 02,12 SAY left(mecven->nome_v,28)
   @ 03,15 say clifor->nome_v
   @ 04,15 say clifor->endereco_v
   @ 05,15 say clifor->bairro_v
   @ 05,54 say transform(clifor->cep_v,"99999-9")
   @ 06,15 say clifor->cidade_v
   @ 06,54 say clifor->estado_v
   @ 07,15 say transform(clifor->fone1_v,"@r (#99) #9999-9999")
   @ 07,54 say clifor->cgccpf_v
   @ 08,15 say clifor->rginsest_v
endif
@ 09,15 say left(pedido->observa1_v,60)
@ 10,9 say pedido->frete_v pict "@r 999,999.99" 
@ 10,40 say pedido->pedcli_v
@ 10,64 say pedido->valmo_v pict "@r 999,999.99"
@ 12,2 say pedido->linserv1_v
@ 13,2 say pedido->linserv2_v
@ 14,2 say pedido->linserv3_v
@ 15,2 say pedido->linserv4_v
@ 17,16 say pedido->datbai_v
@ 17,40 say pedido->datfat_v

@ 19,22 say pedido->datpag_v
@ 20,22 say transform(pedido->valpar_v,"@r 999,999.99")
@ 21,22 say pedido->docext_v
@ 19,33 say pedido->datpag1_v                           
@ 20,33 say transform(pedido->valpar1_v,"@r 999,999.99")
@ 21,33 say pedido->docext1_v                           
@ 19,44 say pedido->datpag2_v                           
@ 20,44 say transform(pedido->valpar2_v,"@r 999,999.99")
@ 21,44 say pedido->docext2_v                           
@ 19,55 say pedido->datpag3_v                           
@ 20,55 say transform(pedido->valpar3_v,"@r 999,999.99")
@ 21,55 say pedido->docext3_v                           
@ 19,66 say pedido->datpag4_v                           
@ 20,66 say transform(pedido->valpar4_v,"@r 999,999.99")
@ 21,66 say pedido->docext4_v                           
@ 22,2 say "Total Itens: " + transform(pedido->valtot_v,"@r 999,999.99")
@ 22,26 say "Total Pedido: " + transform(pedido->valtot_v + pedido->valmo_v + pedido->frete_v,"@r 999,999.99")
return

procedure vendas_atualizatotais(aItens)
local i, TIPI := 0, TBCalc := 0, TICMS := 0, bcalc
for i := 1 to len(aItens)
   pedido2->(dbgoto( val(right(aItens[i],8)) ))
   TIPI += ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
   bcalc := ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->bascal_v / 100 )
   TBCalc += bcalc
   TICMS += ( bcalc * ( pedido2->icms_v / 100 ) )
next
@ 22,2 say "IPI: " + transform(TIPI, "@r 999,999.99") + " Base de Calculo: " + transform(TBCalc,"@r 999,999.99") + " ICMS: "+ transform(TICMS, "@r 999,999.99")
return

function VendasDefaultCFOP(item, estado, cfop)
if empty(alltrim(cfop))
   if estoque->(dbsetorder(1),dbseek(item))
      if bascal->(dbsetorder(1),dbseek(str(estoque->codimp_v,5)+estado))
         cfop := bascal->cfop_v
      endif
   endif
endif
return .t.