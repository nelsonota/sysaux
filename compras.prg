#INCLUDE "ACHOICE.CH"
#include "inkey.ch"

function compras()
local  tela, getlist:={}, aItens
local dDataEmissao, nItem
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
memvar blqven,sysven, codigo
#include "inkey.ch"

tela := savescreen()
dbf_config()
dbf_pedido()
dbf_2pedido()
dbf_clifor()
dbf_estoque()
dbf_bascal()
dbf_moeda()
dbf_system()
dbf_plano()
dbf_pagrec()
dbf_pedfat()
WINDOW(0,0,24,79)
@ 00,01 say "Pedido de Compra" color cortit	
do while .t.
   scroll(1,1,23,78,0)
   @ 1,2 say "Pedido:        Data:                                             NF:"
   @ 2,2 say "Fornecedor:"
   //         234567890123456789012345678901234567890123456789012345678901234567890
   //                 v12345       11;11;1111
   @ 3,1 to 3,78
   @ 4,1 say " Qtd Codigo       Descricao            Vr.Unit   Vr.Total  IPI% BCalc%   ICMS%"
   //         1234 123456789012 12345678901234567 999,999.99 999,999.99 99.99 999.99 99.9999
   //         2345678901234567890123456789012345678901234567890123456789012345678901234567890
   @ 5,1 to 5,78
   @ 19,1 to 19,78
   @ 20,2 say "Mao de Obra:" + transform(0,"@r 999,999.99") + " Frete: " + transform(0,"@r 999,999.99") + " Itens: " + transform(0,"@r 999,999.99")
   @ 21,1 to 21,78
   @ 23,2 say "F2-Proxima Tela/Sair F7-Imprime Pedido"
   @ 23,36 say "F5-Cancelar Pedido"
   codigo := space(len(pedido->codigo_v))
   aItens := {}
   @ 1,10 get codigo pict "@!" valid alltrim(codigo)=="C" .or. sea_pedido(codigo,"C")
   read
   if lastkey()=27
      exit
   endif
   if alltrim(codigo)=="C"
      dDataEmissao := date()
      if pedido->(addrec())
         do while .not. config->(reclock())
         enddo
         config->pedcom_v := config->pedcom_v+1
         pedido->codigo_v := "C"+strzero(config->pedcom_v,5,0)
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
            system->descr_v  := "Inclusao pedido de compra "+pedido->codigo_v
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
      if left(codigo,1)<>"C"
         aviso("Este nao e' um numero de pedido de compra")
         loop
      endif
      if !clifor->(dbsetorder(1), dbseek(pedido->clifor_v))
         aviso("O fornecedor do pedido nao foi encontrado." + pedido->clifor_v)
         loop
      endif
      pedido->(reclock(5))
      @ 2,14 say clifor->nome_v
      dDataEmissao := pedido->datemi_v
      pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
      do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
         aadd(aItens, str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(if(estoque->(dbsetorder(1), dbseek(pedido2->item_v)),estoque->nome_v,space(len(estoque->nome_v))),15)+" "+transform(pedido2->valuni_v,"@r 999,999.9999")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->ipi_v,"@r 99.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8))
         pedido2->(dbskip())
      enddo
   endif
   aadd(aItens," ")
   @ 1,23 say dtoc(dDataEmissao)
   @ 1,71 say strzero(pedido->notacom_v,6)
   if !empty(pedido->datcan_v)
      @ 2,58 say "Cancelado: " + dtoc(pedido->datcan_v)
   endif
   do while .t.
      keyboard chr(3)
      @ 20,2 say "Mao de Obra:" + transform(pedido->valmo_v,"@r 999,999.99") + " Frete: " + transform(pedido->frete_v,"@r 999,999.99") + " Itens: " + transform(pedido->valtot_v,"@r 999,999.99") + " Total: " + transform(pedido->valtot_v + pedido->valmo_v + pedido->frete_v + pedido->valipi_v,"@r 999,999.99")
      compras_atualizatotais(aItens)
      nItem := len(aItens)
      nItem := achoice(6,1,18,78,aItens,.t.,"accompras")
      if nItem == 0
         pedido->(dbunlock())
         exit
      endif
      if lastkey() = -1
         if len(aItens)>1
            compras_fechapedido()
            if empty(pedido->clifor_v)
               loop
            endif
         endif
         exit
      elseif lastkey() = K_F5 .and. !empty(pedido->clifor_v)
         CancelaPedido(pedido->codigo_v)
         exit
      else
         if empty(right(aItens[nItem],8))
            //if len(aItens)-1 < config->qtditens_v
               compras_additem(@aItens, nItem)
            //else
            //   aviso("O pedido pode ter no maximo " + str(config->qtditens_v,2)+" itens.")
            //endif
         else
            pedido2->(dbgoto(val( right(aItens[nItem],8) )))
            compras_edititem(@aItens, nItem)
         endif
      endif
   enddo
   VerificaPedido(codigo)
enddo
pagrec->(dbclosearea())
plano->(dbclosearea())
config->(dbclosearea())
pedido->(dbclosearea())
pedido2->(dbclosearea())
estoque->(dbclosearea())
clifor->(dbclosearea())
moeda->(dbclosearea())
bascal->(dbclosearea())
system->(dbclosearea())
pedfat->(dbclosearea())
restscreen(,,,,tela)
return nil

procedure compras_additem(aItens, nItem)
local getlist := {}, nQtd, ValUni, linha, nIpi, nBCalc, nICMS, lLibera := .t.
memvar item
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
   nIPI := 0
   nBCalc := 100
   nICMS := 0
   linha := row()
   @ linha,1 get nQtd pict "9999" valid nQtd > 0
   @ linha,6 get item valid(sea_estoque(item) .and. avisoest("C", nQtd) .and. compras_f1(item, @ValUni, linha) )
   @ linha,35 get ValUni pict "@r 999,999.9999" valid ValUni > 0 .and. compras_calcvrtot(nqtd,valuni,linha)
   @ linha,59 get nIPI pict "@r 99.99" valid nIPI>=0
   @ linha,65 get nBCalc pict "999.99" valid nBCalc>=0
   @ linha,72 get nICMS pict "99.9999" valid nICMS>=0
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
            pedido2->ipi_v    := nIPI
            pedido2->bascal_v := nBCalc
            pedido2->icms_v   := nICMS
            
            pedido2->valcus_v := estoque->valcus_v
            pedido2->valmin_v := estoque->valven_v
            pedido2->valmed_v := if(config->multprcv_v='s',estoque->valmed_v,estoque->valven_v)
            pedido2->valmax_v := estoque->valmax_v
            
            pedido->valcus_v += pedido2->valcus_v
            pedido->valmed_v += pedido2->valmed_v
            pedido->valmin_v += pedido2->valmin_v
            pedido->valmax_v += pedido2->valmax_v
            
            pedido->valtot_v += (pedido2->valuni_v * pedido2->qtd_v)
            pedido->valipi_v += ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
            
            if !empty(pedido->datbai_v)
               movest("E",pedido2->item_v, "CM", nQtd, pedido2->codigo_v, pedido2->valuni_v)
               pedido2->datbai_v := date()
            endif
            
            pedido2->(dbcommit(),dbunlock())
             
            aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(if(estoque->(dbsetorder(1), dbseek(pedido2->item_v)),estoque->nome_v,space(len(estoque->nome_v))),15)+" "+transform(pedido2->valuni_v,"@r 999,999.9999")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->ipi_v,"@r 99.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
            aadd(aItens," ")
         endif
      endif
   endif
endif
return

procedure compras_edititem(aItens, nItem)
local getlist := {}, nQtd, ValUni, linha, nOldQtd, OldValUni, nIpi, nBCalc, nICMS, oldIPI, lLibera := .t.
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
   nOldQtd := pedido2->qtd_v
   Oldvaluni := pedido2->valuni_v
   oldIPI := pedido2->ipi_v
   nIPI := pedido2->ipi_v
   nBCalc := pedido2->bascal_v
   nICMS := pedido2->icms_v
   linha := row()
   @ linha,1 get nQtd pict "9999" valid nQtd >=0
   @ linha,35 get ValUni pict "@r 999,999.9999" when nQtd>0 valid ValUni > 0 .and. compras_calcvrtot(nqtd,valuni,linha)
   @ linha,59 get nIPI pict "@r 99.99" when nQtd>0 valid nIPI>=0
   @ linha,65 get nBCalc pict "999.99" when nQtd>0 valid nBCalc>=0
   @ linha,72 get nICMS pict "99.9999" when nQtd>0 valid nICMS>=0
   read
   if lastkey()<>27
      if nOldQtd <> nQtd .or. OldValUni <> ValUni .or. oldIPI <> nIPI .or. pedido2->bascal_v<>nBCalc .or. pedido2->icms_v<>nICMS
         if confirma(20,20,"Confirma item ?")
            pedido2->(reclock(5))
            pedido2->bascal_v := nBCalc
            pedido2->icms_v := nICMS
            pedido2->(dbcommit(), dbunlock())
            aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(estoque->nome_v,15)+" "+transform(pedido2->valuni_v,"@r 999,999.9999")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->ipi_v,"@r 99.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
            if estoque->(dbsetorder(1), dbseek(pedido2->item_v))
               if oldIPI <> nIPI .and. nQtd > 0
                  pedido2->(reclock())
                  pedido->valipi_v -= ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
                  pedido2->ipi_v := nIpi
                  pedido->valipi_v += ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
                  pedido2->(dbcommit(), dbunlock())
                  aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(estoque->nome_v,15)+" "+transform(pedido2->valuni_v,"@r 999,999.9999")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->ipi_v,"@r 99.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
               endif

               if nOldQtd <> nQtd .or.  OldValUni <> ValUni
                  pedido->valtot_v -= (OldValUni * nOldQtd)
                  pedido->valipi_v -= ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
                  pedido2->(reclock(5))
                  if nQtd>0
                     pedido2->qtd_v    := nqtd
                     pedido2->valuni_v := valuni
                     pedido->valtot_v += (pedido2->valuni_v * pedido2->qtd_v)
                     pedido->valipi_v += ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
                     pedido2->(dbcommit(), dbunlock())
   
                     aItens[nItem] := str(pedido2->qtd_v,4)+" "+pedido2->item_v+" "+left(estoque->nome_v,15)+" "+transform(pedido2->valuni_v,"@r 999,999.9999")+" "+transform(pedido2->qtd_v*pedido2->valuni_v,"@r 999,999.99")+" "+transform(pedido2->ipi_v,"@r 99.99")+" "+transform(pedido2->bascal_v,"@r 999.99")+" "+transform(pedido2->icms_v,"@r 99.9999")+" "+str(pedido2->(recno()),8)
                  else
                     pedido2->(dbdelete())
                     pedido2->(dbcommit(), dbunlock())
                     adel(aItens, nItem)
                     asize(aItens, len(aItens) -1 )
                  endif
                  if empty(pedido->datbai_v)
                  
                  
                  
                  
                  
                  
                  else
                     movest("S",pedido2->item_v, "CM", nOldQtd, pedido2->codigo_v, ValUni)
                     if nQtd>0
                        movest("E",pedido2->item_v, "CM", nQtd, pedido2->codigo_v, ValUni)
                     endif
                  endif
               endif
            endif
         endif
      endif
   endif
endif
return

function compras_f1(cCodigo, nVrUnit, linha)

if estoque->(dbsetorder(1), dbseek(cCodigo))
   @ linha,20 say left(estoque->nome_v,15)

   nVrUnit := estoque->valcus_v

endif
return .t.

function compras_calcvrtot(nqtd, valuni, linha)
@ linha,48 say transform(nqtd * valuni, "@r 999,999.99")
return .t.

procedure compras_fechapedido()
local tela := savescreen()
local linserv1, linserv2, linserv3, linserv4
local getlist:={}, dtbaixa, inter,parc, registrar, i
local dtparc:=array(0),vrparc:=array(0),docext:=array(0), nota, dtfaturamento, pagrec, observa1
memvar frete,valmo
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho,nomsen
memvar codpla
//window(2,0,22,79)
scroll(2,1,22,78,0)
observa1 := pedido->observa1_v
valmo := pedido->valmo_v
linserv1:=pedido->linserv1_v
linserv2:=pedido->linserv2_v
linserv3:=pedido->linserv3_v
linserv4:=pedido->linserv4_v
frete := pedido->frete_v
dtbaixa := if(!empty(pedido->datbai_v),pedido->datbai_v,date())
dtfaturamento := if(!empty(pedido->datbai_v) .and. empty(pedido->datfat_v),date(),pedido->datfat_v)
parc := 0
inter := 0
nota := pedido->notacom_v
plano->(dbgotop())
codpla := space(len(plano->codigo_v))
do while .t.
   scroll(4,1,21,78,0)
   if empty(pedido->clifor_v)
      compras_telafecha(.t.)
      do while .t.
         set key -2 to t_clifor()
         dbe_clifor(5,10,15,70)
         set key -2 to
         if lastkey()=27
            exit
         endif
         if left(clifor->codigo_v,1)<>"F"
            aviso("E' necessario que seja selecionado um fornecedor...")
            loop
         endif
         exit
      enddo
      if lastkey()=27
         exit
      endif
   else
      clifor->(dbsetorder(1), dbseek(pedido->clifor_v))
   endif
   compras_telafecha(.f.)
   if empty(pedido->datbai_v) .or. empty(pedido->datfat_v)
      @ 09,15 get observa1 pict "@s60" when empty(pedido->datfat_v)
      @ 10,9 get frete pict "@r 999,999.99" when empty(pedido->datfat_v)
      @ 10,64 get valmo pict "@r 999,999.99" when empty(pedido->datfat_v)
      @ 12,2 get linserv1 pict "@!" when empty(pedido->datfat_v)
      @ 13,2 get linserv2 pict "@!" when empty(pedido->datfat_v)
      @ 14,2 get linserv3 pict "@!" when empty(pedido->datfat_v)
      @ 15,2 get linserv4 pict "@!" when empty(pedido->datfat_v)
      @ 17,16 get dtbaixa valid empty(dtbaixa) .or. dtbaixa=date() when empty(pedido->datbai_v)
      @ 17,40 get dtfaturamento when empty(pedido->datfat_v)
      @ 18,16 get nota pict "999999" valid nota>0 when !empty(dtfaturamento)
      @ 18,27 say "Plano de Conta:      Parcelas:   Intervalo:"
      @ 18,43 get codpla pict "@!" valid(sea_codpla(codpla,,,"-")) when !empty(dtfaturamento)
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
         if !DesmembraParcelas(pedido->valtot_v + frete + valmo + pedido->valipi_v, 0, @dtparc, @vrparc, @docext, .t.)
            loop
         endif
      endif
      if confirma(20,20,"Confirma todos os dados do pedido?")
         if empty(pedido->clifor_v)
            pedido->clifor_v := clifor->codigo_v
         endif
         pedido->notacom_v := nota
         pedido->observa1_v := observa1
         if empty(pedido->datbai_V) .and. !empty(dtbaixa)
            pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
            do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
               pedido2->(reclock(5))
               movest("E",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v, pedido2->valuni_v)
               pedido2->datbai_v := date()
               pedido2->(dbcommit(), dbunlock())
               pedido2->(dbskip())
            enddo
            pedido->datbai_v  := date()
         endif
         if !empty(dtfaturamento)
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
            if config->autcom_v="P"
               if confirma(20,20,"Registrar Contas Futuras ?")
                  registrar:="S"
               else
                  registrar:="N"
               endif
            else
               registrar:=config->autcom_v
            endif
            
            for i := 1 to len(dtparc)
               if !empty(dtparc[i]) .and. vrparc[i]>0
                  pagrec := ""
                  if registrar == "S"
                     pagrec->(addrec(5))
                     config->(reclock())
                     pagrec:="P"+strzero(config->pagrec_v+1,5,0)
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
                     pagrec->desc_v   :="Compra pedido "+pedido->codigo_v
                     pagrec->(dbunlock())
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
      endif
   else
      if !empty(pedido->datfat_v)
         @23,41 say "F6-Cancelar faturamento F8-Faturamento"
      endif
      inkey(0)
      if !empty(pedido->datfat_v)
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

procedure compras_telafecha(lSomenteTela)
local nClifor := clifor->(recno())

@ 03,02 say "Fornecedor : "
@ 4,2  say "Endereco   : "
@ 5,2  say "Bairro     : "
@ 5,45 say "C.E.P. : "
@ 6,2  say "Cidade     : "
@ 6,45 say "Estado : "
@ 7,2  say "Telefone   : "
@ 7,45 say "CGC/CPF: "
@ 8,2 say "RG/Ins.Est.: "
@ 9,2 say "Observacoes: "
@ 10,2 say "Frete:                                           Mao de Obra:"
@ 11,2 say "Descricao da mao de obra:"
//@ 18,2 say "Baixa Pedido:            Plano de Conta:      Parcelas:   Intervalo:"
@ 16,1 to 16,78
@ 17,2 say "Baixa Pedido:"
//                        00.00.0000                 9999           9            99
@ 17,27 say "Faturamento :"
@ 18,02 say "Nota Fiscal :"
@ 19,02 say "Vencimento        :"
@ 20,02 say "Valor da Parcela  :"
@ 21,02 say "Doc.Ext.da Parcela:"
if !lSomenteTela  
   @ 03,15 say clifor->nome_v
   @ 04,15 say alltrim(clifor->endereco_v)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v)
   @ 05,15 say clifor->bairro_v
   @ 05,54 say transform(clifor->cep_v,"99999-9")
   @ 06,15 say clifor->cidade_v
   @ 06,54 say clifor->estado_v
   @ 07,15 say transform(clifor->fone1_v,"@r (#99) #9999-9999")
   @ 07,54 say clifor->cgccpf_v
   @ 08,15 say clifor->rginsest_v
endif
@ 10,9 say pedido->frete_v pict "@r 999,999.99" 
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
@ 22,26 say "Total Pedido: " + transform(pedido->valtot_v + pedido->valmo_v + pedido->frete_v + pedido->valipi_v,"@r 999,999.99")
return

procedure compras_atualizatotais(aItens)
local i, TIPI := 0, TBCalc := 0, TICMS := 0, bcalc
for i := 1 to len(aItens)
   pedido2->(dbgoto( val(right(aItens[i],8)) ))
   TIPI += ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->ipi_v / 100 )
   bcalc := ( pedido2->qtd_v * pedido2->valuni_v ) * ( pedido2->bascal_v / 100 )
   TBCalc += bcalc
   TICMS += ( bcalc * ( pedido2->icms_v / 100 ) )
next
if tipi <> pedido->valipi_v
   pedido->valipi_v := tipi
endif
@ 22,2 say "IPI: " + transform(pedido->valipi_v, "@r 999,999.99") + " Base de Calculo: " + transform(TBCalc,"@r 999,999.99") + " ICMS: "+ transform(TICMS, "@r 999,999.99")
return

function accompras( nMode, nCurElement, nRowPos )
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
         CASE nKey == -6
            if confirma(20,20,"Deseja imprimir o pedido ?")
               imppedido(pedido->codigo_v)
            endif
      ENDCASE
ENDCASE
return nRetVal