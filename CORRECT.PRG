procedure mcorrect()
local op, opcoes,tela
opcoes := {"  Corrigir Lançamento Diario                   ",;
           "  Corrigir Dados de Movimentacoes dos Cadastros",;
           "  Corrigir Reservas no Estoque                 ",;
           "  Verificar Estoque Inicial do Extrato de Movim",;
           "  Verifica Visualizacao de Desmembramento      ",;
           "  Verifica Ultimo Custo do Estoque             ",;
           "  Verifica Movimentação do Extrato             ",;
           "  Preparar pedidos xmig                        "}
tela:=savescreen(0,0,24,80)
window(7,29,16,78)
do while .t.
   op := achoice(8,30,16,77,opcoes,.t.,"ACHOFUN")
   do case
      case op == 1
         IF ACCCOM("441")
            CORRECT()
         ENDIF
      case op == 2
         IF ACCCOM("442")
            CORDATAMOV()
         ENDIF
      case op == 3
         if acccom("443")
            if confirma(20,20,"Todos devem estar fora do sistema, continuar ?")
               VerificaReservas()
            endif
         endif
      case op == 4
         if acccom("444")
            if confirma(20,20,"Todos devem estar fora do sistema, continuar ?")
               VerificaEstoqueInicial()
            endif
         endif
      case op == 5
         if acccom("445")
            VerificaPedFat()
         endif
      case op == 6
         if acccom("446")
            VerificaCusto()
         endif
      case op == 7
         if acccom("447")
            VerificaMovExt()
         endif
      case op == 8
         corxmig()
      otherwise
         exit
   endcase
enddo
restscreen(0,0,24,80,tela)
closewin(3,40,11,63)
return

FUNCTION CORRECT()
LOCAL  OP,TELA,DATLAN,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR BANCO,CLIFOR,CODPLA,DOCEXT,DESC,DOCINT,DATVEN,DATBAI,VALOR,CHEQUE,MOVI
MEMVAR DATEXT,DATINT,BOLETO,CODBANBO,DUPLICA,CODBANDU,COBCHQ,CBCODBAN,COBBANCO
MEMVAR COBAGEN,COBCONTA,PROTESTO,CODPORTA,DATAPATH
TELA:=SAVESCREEN()
WINDOW(8,0,10,42)
DATLAN:=TRABALHO
DBF_BANK()
DBF_CLIFOR()
DBF_CHEQUE()
DBF_PLANO()
DBF_PORTA()
DO WHILE .T.
   @ 9,2 SAY "Digite a data do lan‡amento :" GET DATLAN
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   MOVI:=BAN_2MOVI(DATLAN)
   IF .NOT. FILE(DATAPATH+MOVI+".DBF")
      AVISO("Nao Existe Nenhum Lan‡amento no Mˆs desta Data ...")
      LOOP
   ENDIF
   DBF_MOVI(MOVI)
   (MOVI)->(DBSETORDER(3))
   (MOVI)->(DBSEEK(DATLAN,.T.))
   DBE_MOVI(10,5,20,75,MOVI)
   IF LASTKEY()=27
      (MOVI)->(DBCLOSEAREA())
      LOOP
   ENDIF
   WINDOW(18,0,20,25)
   WINDOW(8,0,18,79)
   @ 19,25 SAY CHR(219)
   SETCOLOR(CORTIT)
   @ 7,0 SAY "Corre‡ao de Lan‡amento Efetuado"
   DO WHILE .T.
      SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
      BANCO   :=(MOVI)->BANCO_V
      CLIFOR  :=(MOVI)->CLIFOR_V
      CODPLA  :=(MOVI)->CODPLA_V
      CODPORTA  :=(MOVI)->CODPORTA_V
      DOCEXT  :=(MOVI)->DOCEXT_V
      DATEXT  :=(MOVI)->DATEXT_V
      DESC    :=(MOVI)->DESC_V
      DOCINT  :=(MOVI)->DOCINT_V
      DATINT  :=(MOVI)->DATINT_V
      VALOR   :=(MOVI)->VALOR_V
      DATVEN  :=(MOVI)->DATVEN_V
      DATBAI  :=(MOVI)->DATBAI_V
      CHEQUE  :=(MOVI)->CHEQUE_V
      BOLETO  :=(MOVI)->BOLETO_V
      CODBANBO:=(MOVI)->CODBANBO_V
      DUPLICA :=(MOVI)->DUPLICA_V
      CODBANDU:=(MOVI)->CODBANDU_V
      COBCHQ  :=(MOVI)->COBCHQ_V
      CBCODBAN:=(MOVI)->CBCODBAN_V
      COBBANCO:=(MOVI)->COBBANCO_V
      COBAGEN :=(MOVI)->COBAGEN_V
      COBCONTA:=(MOVI)->COBCONTA_V
      PROTESTO:=(MOVI)->PROTESTO_V
      BANK->(DBSETORDER(1))
      @ 17,2 SAY "Lan‡amento no Banco "+ IF(BANK->(DBSEEK((MOVI)->BANCO_V)),BANK->NOME_V,SPACE(10))
      DO CASE
         CASE LEFT((MOVI)->PAGREC_V,1)="P"
            @ 9,2  SAY "Cheque     : " + CHEQUE
         CASE LEFT((MOVI)->PAGREC_V,1)="R"
            @ 9,2 SAY "Boleto : "+BOLETO+" Duplicata : "+DUPLICA+" Cheque : "+COBCHQ
      ENDCASE
      DO CASE
         CASE LEFT((MOVI)->PAGREC_V,1)="P"
            @ 10,2 SAY "Fornecedor     : " + CLIFOR+" "+IF(CLIFOR->(DBSEEK(CLIFOR)),CLIFOR->NOME_V,SPACE(50))
         CASE LEFT((MOVI)->PAGREC_V,1)="R"
            @ 10,2 SAY "Cliente        : " + CLIFOR+" "+IF(CLIFOR->(DBSEEK(CLIFOR)),CLIFOR->NOME_V,SPACE(50))
      ENDCASE
      @ 11,02 SAY "Plano de Conta : " + CODPLA +" "+IF(PLANO->(DBSEEK(CODPLA)),PLANO->NOME_V,SPACE(10))
      IF LEFT((MOVI)->PAGREC_V,1)="R"
         @ 11,40 SAY "Portador : " + CODPORTA+" "+IF(PORTA->(DBSEEK(CODPORTA)),PORTA->NOME_V,SPACE(10))
      ENDIF
      @ 12,02 SAY "Doc.Externo    : " + DOCEXT
      @ 12,32  SAY "Data do Doc.Externo : " + DTOC(DATEXT)
      @ 13,2 SAY "Descri‡ao      : " + DESC  
      @ 14,2 SAY "Doc.Interno    : " + DOCINT
      @ 14,32 SAY "Data do Doc.Interno : " + DTOC(DATINT)
      @ 15,2 SAY "Vencimento     : " + DTOC(DATVEN)+" Data da Baixa : "+DTOC(DATBAI)
      @ 16,2 SAY "Valor          : " + TRANSFORM(VALOR,"@R 999,999,999.99")
      @ 19,1  PROMPT " Busca "
      @ 19,8  PROMPT " Altera "
      @ 19,16 PROMPT " Cancela "
      MENU TO OP
      DO CASE
         CASE OP=1
            EXIT
         CASE OP=2
            ACORRECT()
         CASE OP=3
            CCORRECT()
         OTHERWISE
            EXIT
      ENDCASE
   ENDDO
   (MOVI)->(DBCLOSEAREA())
   IF OP=1
      LOOP
   ENDIF
   EXIT
ENDDO
CLIFOR->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
CHEQUE->(DBCLOSEAREA())
PORTA->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)

FUNCTION CORDATAMOV()
if confirma(10,10,"Iniciar verificacao dos movimentos ?")
   dbf_pedido()
   dbf_clifor()
   clifor->(dbsetorder(1),dbgotop())
   do while !clifor->(eof())
      if pedido->(dbsetorder(2),dbseek(clifor->codigo_v))
         do while !pedido->(eof()) .and. pedido->clifor_v == clifor->codigo_v
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
            pedido->(dbskip())
         enddo
      endif
      clifor->(dbskip())
   enddo
   clifor->(dbclosearea())
   pedido->(dbclosearea())
   aviso("Verificacao realizada com sucesso")
endif
RETURN NIL

procedure VerificaReservas()
local cont := .t., lTemItens
set dele on
if !dbf_estoque(.f.)
   aviso("Nao foi possivel abrir a tabela de estoque")
   cont := .f.
endif
if !dbf_pedido(.f.)
   aviso("Nao foi possivel abrir a tabela de pedidos")
   cont := .f.
endif
if !dbf_2pedido(.f.)
   aviso("Nao foi possivel abrir a tabela de itens de pedidos")
   cont := .f.
endif

if cont
   pedido->(dbsetorder(1),dbgotop())
   do while ! pedido->(eof())
      lTemItens := pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
      if lTemItens
         do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
            if empty(pedido->clifor_v)
               pedido2->(dbdelete())
            endif
            pedido2->(dbskip())
         enddo
      endif
      if empty(pedido->clifor_v) .or. ! lTemItens
         pedido->(dbdelete())
      endif
      pedido->(dbskip())
   enddo

   estoque->(dbgotop())
   do while ! estoque->(eof())
      estoque->reserva_v := 0
      pedido2->(dbsetorder(2), dbseek(estoque->codigo_v))
      do while !pedido2->(eof()) .and. pedido2->item_v == estoque->codigo_v
         if left(pedido2->codigo_v,1)=="V"
            if pedido->(dbsetorder(1), dbseek(pedido2->codigo_v))
               if empty(pedido->datbai_v)
                  estoque->reserva_v += pedido2->qtd_v
               endif
            endif
         endif
         pedido2->(dbskip())
      enddo
      estoque->(dbskip())
   enddo

endif
pedido->(dbclosearea())
pedido2->(dbclosearea())
estoque->(dbclosearea())
return

procedure VerificaEstoqueInicial()
local cont := .t.,aExtrato, nExtrato, aTotal, nTotal, saldo, tela, registro, id
tela := savescreen()
if !dbf_config(.f.)
   aviso("Nao foi possivel abrir a tabela de configuracao")
   cont := .f.
endif
if !dbf_estoque(.f.)
   aviso("Nao foi possivel abrir a tabela de estoque")
   cont := .f.
endif
if !dbf_movest(.f.)
   aviso("Nao foi possivel abrir a tabela movimentacao de estoque")
   cont := .f.
endif
if !dbf_pedido(.f.)
   aviso("Nao foi possivel abrir a tabela de pedidos")
   cont := .f.
endif
if !dbf_2pedido(.f.)
   aviso("Nao foi possivel abrir a tabela de itens de pedidos")
   cont := .f.
endif
if cont
   if movest->(lastrec())=0
      aExtrato := {}
      aTotal := {}
      pedido->(dbsetorder(4),dbgotop())
      
      // Gerar extrato
      registro := 0
      do while !pedido->(eof())
         registro ++
         @ 23,0 say " 1 Processando pedidos "+alltrim(str(registro,6))+"/"+alltrim(str(pedido->(lastrec())))
         if !empty(pedido->datbai_v)
            if pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
               do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
                  aadd(aExtrato, {pedido->datbai_v,;
                                  pedido2->item_v,;
                                  if(left(pedido->codigo_v,1)="V","VM","CM") ,;
                                  pedido2->qtd_v * if(left(pedido->codigo_v,1)="V",-1,1) ,;
                                  pedido->codigo_v})
                  
                  nExtrato := len(aExtrato)
                  nTotal := ascan(aTotal, {|x| x[1] == aExtrato[nExtrato,2] })
                  if nTotal == 0
                    aadd(aTotal, { aExtrato[nExtrato,2], aExtrato[nExtrato,4], aExtrato[nExtrato,1] })
                  else
                    aTotal[nTotal,2] += aExtrato[nExtrato,4]
                  endif
                  pedido2->(dbskip())
               enddo
            endif
         endif
         pedido->(dbskip())
      enddo
      
      // Comparar totais do extrato com quantidade em estoque e gerar estoque inicial
      for nTotal := 1 to len(aTotal)
         @ 23,0 say " 2 Processando estoque inicial "+alltrim(str(nTotal,6))+"/"+alltrim(str(len(aTotal)))
         if estoque->(dbsetorder(1), dbseek(aTotal[nTotal,1]))
            if estoque->qtd_v <> aTotal[nTotal,2]
               config->(reclock(5))
               config->movest_v += 1
               id := config->movest_v
               config->(dbunlock())
               movest->(addrec(5))
               movest->id_v := id
               movest->data_v := aTotal[nTotal,3]
               movest->codigo_v := aTotal[nTotal,1]
               movest->tipomov_v := if(estoque->qtd_v - aTotal[nTotal,2] > 0, "OE", "OS")
               movest->qtd_v := estoque->qtd_v - aTotal[nTotal,2]
               movest->saldo_v := movest->qtd_v
               movest->(dbcommit(), dbunlock())
            endif
         endif
      next
      
      // Gerar Extrato
      
      for nExtrato := 1 to len(aExtrato)
      	@ 23,0 say " 3 Processando extrato de movimento de estoque "+alltrim(str(nExtrato,6))+"/"+alltrim(str(len(aExtrato)))
         if estoque->(dbsetorder(1), dbseek(aExtrato[nExtrato,2]))
            saldo := 0
            if movest->(dbsetorder(3), dbseek(aExtrato[nExtrato,2]))
               saldo := movest->saldo_v
            endif
            config->(reclock(5))
            config->movest_v += 1
            id := config->movest_v
            config->(dbunlock())
            movest->(addrec(5))
            movest->id_v := id
            movest->data_v := aExtrato[nExtrato,1]
            movest->codigo_v := aExtrato[nExtrato,2]
            movest->tipomov_v := aExtrato[nExtrato,3]
            movest->qtd_v := aExtrato[nExtrato,4]
            movest->doc_v := aExtrato[nExtrato,5]
            movest->saldo_v := saldo + movest->qtd_v
            movest->(dbcommit(), dbunlock())
         endif
      next
      
   else
      aviso("Ja exite movimentacao, impossivel inicializar")
   endif
endif
pedido2->(dbclosearea())
pedido->(dbclosearea())
estoque->(dbclosearea())
movest->(dbclosearea())
restscreen(,,,,tela)
return

procedure VerificaPedFat()
dbf_pedido()
dbf_pedfat()
pedido->(dbgotop())
do while !pedido->(eof())
   if !pedfat->(dbsetorder(2), dbseek(pedido->codigo_v))
      if !empty(pedido->datfat_v) .and. !empty(pedido->datpag1_v)
         if !empty(pedido->datpag1_v)
            pedfat->(addrec(5))
            pedfat->id_v := lastid("pedfat")
            pedfat->codigo_v := pedido->codigo_v
            pedfat->datemi_v := pedido->datemi_v
            pedfat->dtparc_v := pedido->datpag1_v
            pedfat->vrparc_v := pedido->valpag1_v
            pedfat->docext_v := pedido->docext1_v
            pedfat->pagrec_v := pedido->pagrec1_v
            pedfat->(dbcommit(), dbunlock())
         endif
         if !empty(pedido->datpag2_v)
            pedfat->(addrec(5))
            pedfat->id_v := lastid("pedfat")
            pedfat->codigo_v := pedido->codigo_v
            pedfat->datemi_v := pedido->datemi_v
            pedfat->dtparc_v := pedido->datpag2_v
            pedfat->vrparc_v := pedido->valpag2_v
            pedfat->docext_v := pedido->docext2_v
            pedfat->pagrec_v := pedido->pagrec2_v
            pedfat->(dbcommit(), dbunlock())
         endif
         if !empty(pedido->datpag3_v)
            pedfat->(addrec(5))
            pedfat->id_v := lastid("pedfat")
            pedfat->codigo_v := pedido->codigo_v
            pedfat->datemi_v := pedido->datemi_v
            pedfat->dtparc_v := pedido->datpag3_v
            pedfat->vrparc_v := pedido->valpag3_v
            pedfat->docext_v := pedido->docext3_v
            pedfat->pagrec_v := pedido->pagrec3_v
            pedfat->(dbcommit(), dbunlock())
         endif
         if !empty(pedido->datpag4_v)
            pedfat->(addrec(5))
            pedfat->id_v := lastid("pedfat")
            pedfat->codigo_v := pedido->codigo_v
            pedfat->datemi_v := pedido->datemi_v
            pedfat->dtparc_v := pedido->datpag4_v
            pedfat->vrparc_v := pedido->valpag4_v
            pedfat->docext_v := pedido->docext4_v
            pedfat->pagrec_v := pedido->pagrec4_v
            pedfat->(dbcommit(), dbunlock())
         endif
      endif
   endif
   pedido->(dbskip())
enddo
pedido->(dbclosearea())
pedfat->(dbclosearea())
return

procedure VerificaCusto()
local nHand := fcreate("vrfcusto.log")
dbf_pedido()
dbf_2pedido()
dbf_estoque()
estoque->(dbgotop())
do while !estoque->(eof())
   if left(estoque->ultped_v,1)="V"
      estoque->(reclock(5))
      estoque->dtultcus_v := ctod("")
      estoque->ultcus_v := 0
      estoque->ultped_v := ""
      estoque->(dbcommit(), dbunlock())
   endif
   pedido2->(dbsetorder(2), dbseek(estoque->codigo_v))
   do while !pedido2->(eof()) .and. pedido2->item_v == estoque->codigo_v
      if left(pedido2->codigo_v,1)="C"
         if pedido->(dbsetorder(1), dbseek(pedido2->codigo_v))
            if pedido->datbai_v > estoque->dtultcus_v .or. left(estoque->ultped_v,1)="V"
               fwrite(nHand, estoque->codigo_v+" "+estoque->ultped_v+" "+dtos(estoque->dtultcus_v)+" "+str(estoque->ultcus_v)+" -> "+pedido->codigo_v +" "+ dtos(pedido->datbai_v) + " " + str(pedido2->valuni_v) + chr(13)+chr(10) )
               estoque->(reclock(5))
               estoque->dtultcus_v := pedido->datbai_v
               estoque->ultcus_v := pedido2->valuni_v
               estoque->ultped_v   := pedido->codigo_v
               estoque->(dbcommit(), dbunlock())
            endif
         endif
      endif
      pedido2->(dbskip())
   enddo
   estoque->(dbskip())
enddo
pedido->(dbclosearea())
pedido2->(dbclosearea())
estoque->(dbclosearea())
fclose(nHand)
return

procedure VerificaMovExt2()
local nHand := fcreate("vrfmovext.txt")
local nMovimentos, nPedidos, cPedido, cProduto, Registro, logtxt
dbf_movest()
dbf_2pedido()
dbf_estoque()
movest->(dbsetorder(2))
movest->(dbgotop())
do while !movest->(eof())
   Registro := movest->codigo_v+movest->tipomov_v+movest->doc_v+str(movest->qtd_v,5)
   logtxt := movest->codigo_v+" "+dtoc(movest->data_v)+" "+movest->tipomov_v+" "+movest->doc_v+" "+str(movest->qtd_v,5)+" "
   movest->(dbskip())
   if eof()
      exit
   endif
   if movest->codigo_v+movest->tipomov_v+movest->doc_v+str(movest->qtd_v,5) == Registro
      movest->(dbskip(-1))
      nMovimentos := 0
      cPedido := left(movest->doc_v,6)
      cProduto := movest->codigo_v
      nQuantidade := movest->qtd_v
      do while !movest->(eof()) .and. movest->codigo_v+movest->tipomov_v+movest->doc_v+str(movest->qtd_v,5) == Registro
         nMovimentos ++
         movest->(dbskip())
      enddo
      pedido2->(dbsetorder(1), dbseek(cPedido))
      nPedidos := 0
      do while !pedido2->(eof()) .and. pedido2->codigo_v == cPedido
         if pedido2->item_v == cProduto .and. pedido2->qtd_v == nQuantidade * if(nQuantidade<0,-1,1)
            nPedidos ++
         endif
         pedido2->(dbskip())
      enddo
      if nMovimentos <> nPedidos
         fwrite(nHand, logtxt + chr(10)+chr(13))
      endif
   endif
enddo
fwrite(nHand, replicate("=",80))
estoque->(dbgotop())
do while !estoque->(eof()) 
   movest->(dbsetorder(3), dbseek(estoque->codigo_v))
   if estoque->qtd_v <> movest->saldo_v
      fwrite(nHand, estoque->codigo_v+" "+str(estoque->qtd_v,5)+" "+str(movest->saldo_v,5)+chr(13)+chr(10))
   endif
   estoque->(dbskip())
enddo
movest->(dbclosearea())
pedido2->(dbclosearea())
estoque->(dbclosearea())
fclose(nHand)
return

procedure VerificaMovExt()
local Produto, Pedido, QtdExtrato, QtdPedido, DataExtrato
local nHand := fcreate("vrfmovext.txt"), Extrato, nErro, nExtrato, nMovimento
local tela := savescreen()
memvar Erros, Movimentos
Erros := array(0)
Movimentos := array(0)
if confirma(20,20,"Iniciar verificacao ?")
   dbf_2pedido()
   dbf_movest()
   dbf_estoque()
   dbf_pedido()
   
//   movest->(dbsetorder(4), dbgotop())
//   do while !movest->(eof())
//      Produto := movest->codigo_v
//      Pedido := left(movest->doc_v,6)
//      DataExtrato := movest->data_v
//      QtdExtrato := 0
//      QtdPedido := 0
//      if !empty(alltrim(Pedido))
//         Extrato := array(0)
//         do while !movest->(eof()) .and. movest->codigo_v == Produto .and. left(movest->doc_v,6) == Pedido
//            QtdExtrato += movest->qtd_v //* if(left(Pedido,1)=="V",-1,1)
//            aadd(Extrato, movest->codigo_v+" "+left(movest->doc_v,6)+movest->tipomov_v+" "+str(movest->qtd_v,5)+" "+dtoc(movest->data_v)+" "+str(movest->(recno()),8) )
//            movest->(dbskip())
//         enddo
//         if pedido->(dbsetorder(1), dbseek(Pedido)) .and. (empty(pedido->datcan_v)) //.or. pedido->datcan_v<ctod("13/11/2009"))
//            pedido2->(dbsetorder(1), dbseek(Pedido))
//            do while !pedido2->(eof()) .and. pedido2->codigo_v == Pedido
//               if pedido2->item_v == Produto
//                  QtdPedido += pedido2->qtd_v * if(left(pedido2->codigo_v,1)=="V",-1,1)
//               endif
//               pedido2->(dbskip())
//            enddo
//         endif
//      else
//         movest->(dbskip())
//      endif
//      if QtdExtrato <> QtdPedido
//         aadd(Erros, Produto+" "+Pedido+" "+str(QtdExtrato,5)+" "+str(QtdPedido,5))
//         for nExtrato := 1 to len(Extrato)
//            aadd(Movimentos, Extrato[nExtrato])
//         next
//         fwrite(nHand, Produto+" "+Pedido+" "+dtoc(DataExtrato)+" "+str(QtdExtrato,5)+" "+str(QtdPedido,5)+chr(13)+chr(10))
//      endif
//   enddo
   pedido->(dbgotop())
   do while !pedido->(eof())
      if pedido->datemi_v>=ctod("01/11/2009")
         DataExtrato := pedido->datemi_v
         pedido2->(dbsetorder(1), dbseek(pedido->codigo_v))
         do while !pedido2->(eof()) .and. pedido2->codigo_v==pedido->codigo_v
            
            Produto := pedido2->item_v
            QtdExtrato := 0
            QtdPedido := 0
            do while !pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v .and. pedido2->item_v==Produto
               if empty(pedido->datcan_v)
                  QtdPedido += pedido2->qtd_v * if(left(pedido2->codigo_v,1)=="V",-1,1)
               endif
               pedido2->(dbskip())
            enddo

            movest->(dbsetorder(5), dbseek(pedido->codigo_v+Produto))
            Extrato := array(0)
            do while !movest->(eof()) .and. movest->codigo_v == Produto .and. left(movest->doc_v,6) == pedido->codigo_v
               QtdExtrato += movest->qtd_v //* if(left(Pedido,1)=="V",-1,1)
               aadd(Extrato, movest->codigo_v+" "+left(movest->doc_v,6)+movest->tipomov_v+" "+str(movest->qtd_v,5)+" "+dtoc(movest->data_v)+" "+str(movest->(recno()),8) )
               movest->(dbskip())
            enddo
            if QtdExtrato <> QtdPedido
               aadd(Erros, Produto+" "+pedido->codigo_v+" "+str(QtdExtrato,5)+" "+str(QtdPedido,5))
               for nExtrato := 1 to len(Extrato)
                  aadd(Movimentos, Extrato[nExtrato])
               next
               fwrite(nHand, Produto+" "+pedido->codigo_v+" "+dtoc(DataExtrato)+" "+str(QtdExtrato,5)+" "+str(QtdPedido,5)+chr(13)+chr(10))
            endif
            
         enddo
      endif
      pedido->(dbskip())
   enddo
   fclose(nHand)
   window(0,0,23,79)
   @11,1 to 11,78
   keyboard(chr(5))
   do while .t.
      nErro := achoice(1,1,10,32,Erros,.t.,"acVrfMovExt")
      if nErro == 0
         exit
      endif
      
      tela2 := savescreen()
      QtdExtrato := val(substr(Erros[nErro],21,5))
      QtdPedido := val(substr(Erros[nErro],27,5))
      if QtdExtrato == QtdPedido
         alert("Este produto ja esta corrigido")
      else
         Produto := left(Erros[nErro],12)
         Pedido := substr(Erros[nErro],14,6)
         nMovimento := ascan(Movimentos, {|x| left(x,19) == left(Erros[nErro],19)})
         MovCor := array(0)
         do while nMovimento<=len(Movimentos) .and. nMovimento>0
            if left(Movimentos[nMovimento],19) == left(Erros[nErro],19)
               aadd(MovCor,Movimentos[nMovimento])
            else
               exit
            endif
            nMovimento++
         enddo
         scroll(1,1,22,78,0)
         do while .t.
            @ 1,1 say Produto+" "+Pedido+" "+str(QtdExtrato,5)+" "+str(QtdPedido,5)
            @ 2,1 to 2,78
            nMovimento := achoice(3,1,22,78,MovCor)
            if nMovimento = 0
               if alert("Efetuar Correcoes ?",{"Nao","Sim"}) == 2
                  if QtdExtrato == QtdPedido
                     for nMovimento := 1 to len(MovCor)
                        nExtrato := ascan(Movimentos, {|x| right(x,8) == right(MovCor[nMovimento],8)})
                        Movimentos[nExtrato] := MovCor[nMovimento]
                        if substr(Movimentos[nExtrato],39,1) == "*"
                           movest->(dbgoto(val(right(Movimentos[nExtrato],8))))
                           if estoque->(dbsetorder(1), dbseek(movest->codigo_v))
                              estoque->(reclock(5))
                              estoque->qtd_v += (movest->qtd_v * -1)
                              estoque->(dbcommit(), dbunlock())
                              movest->(dbsetorder(2))
                              saldo := movest->saldo_v + (movest->qtd_v * -1)
                              movest->(reclock(5))
                              movest->(dbdelete())
                              movest->(dbcommit(), dbunlock())
                              movest->(dbskip())
                              do while !movest->(eof()) .and. movest->codigo_v == estoque->codigo_v
                                 movest->(reclock(5))
                                 saldo += movest->qtd_v
                                 movest->saldo_v := saldo
                                 movest->(dbcommit(), dbunlock())
                                 movest->(dbskip())
                              enddo
                           endif
                        endif
                     next
                     Erros[nErro] := stuff(Erros[nErro],21,11,str(QtdExtrato,5)+" "+str(QtdPedido,5))
                  else
                     Alert("Voce nao corrigiu adequadamente")
                  endif
               endif
               exit
            else
               if alert("Confirma acerto ?",{"Nao","Sim"}) == 2
                  MovCor[nMovimento] := stuff(MovCor[nMovimento],39,1,if(substr(MovCor[nMovimento],39,1)=" ","*"," "))
                  QtdExtrato += val(substr(MovCor[nMovimento],23,5)) * if(substr(MovCor[nMovimento],39,1)=="*",-1,1)
               endif
            endif
         enddo
         restscreen(,,,,tela2)
      endif
   enddo
   movest->(dbclosearea())
   pedido2->(dbclosearea())
   pedido->(dbclosearea())
   estoque->(dbclosearea())
endif
restscreen(,,,,tela)
return

function acVrfMovExt( nMode, nCurElement, nRowPos )
local nRetVal := 2
local nKey := lastkey()
local i := ascan(Movimentos, {|x| left(x,19) == left(Erros[nCurElement],19)})
local lin
scroll(12,1,22,78,0)
lin := 12
do while i<=len(Movimentos) .and. i>0
   if left(Movimentos[i],19) == left(Erros[nCurElement],19)
      @ lin,1 say Movimentos[i]
      lin++
   else
      exit
   endif
   i++
enddo
if nKey == 27
   nRetVal := 0
elseif nKey == 13
   nRetVal := 1
endif
return nRetVal

function corxmig()
dbf_pedido()
dbf_2pedido()
dbf_pedfat()
dbf_estoque()
dbf_clifor()
pedido2->(dbgotop())
do while !pedido2->(eof())
   if empty(pedido2->datemi_v)
      if pedido->(dbsetorder(1), dbseek(pedido2->codigo_v))
         pedido2->(reclock())
         pedido2->datemi_v := pedido->datemi_v
         pedido2->(dbcommit(), dbunlock())
      endif
   endif
   if empty(pedido2->datbai_v)
      pedido2->(reclock())
      pedido2->datbai_v := pedido2->datemi_v
      pedido2->(dbcommit(), dbunlock())
   endif
   pedido2->(dbskip())
enddo
pedido->(dbgotop())
do while !pedido->(eof())
   if (!empty(pedido->datpag_v) .and. !pedfat->(dbsetorder(2), dbseek(pedido->codigo_v)))
      if (!empty(pedido->datpag_v))
         pedfat->(addrec(5))
         pedfat->id_v := lastid("pedfat")
         pedfat->codigo_v := pedido->codigo_v
         pedfat->datemi_v := pedido->datemi_v
         pedfat->dtparc_v := pedido->datpag_v
         pedfat->vrparc_v := pedido->valpar_v
         pedfat->docext_v := pedido->docext_v
         pedfat->(dbcommit(), dbunlock())
      endif
      if (!empty(pedido->datpag1_v))
         pedfat->(addrec(5))
         pedfat->id_v := lastid("pedfat")
         pedfat->codigo_v := pedido->codigo_v
         pedfat->datemi_v := pedido->datemi_v
         pedfat->dtparc_v := pedido->datpag1_v
         pedfat->vrparc_v := pedido->valpar1_v
         pedfat->docext_v := pedido->docext1_v
         pedfat->(dbcommit(), dbunlock())
      endif
      if (!empty(pedido->datpag2_v))
         pedfat->(addrec(5))
         pedfat->id_v := lastid("pedfat")
         pedfat->codigo_v := pedido->codigo_v
         pedfat->datemi_v := pedido->datemi_v
         pedfat->dtparc_v := pedido->datpag2_v
         pedfat->vrparc_v := pedido->valpar2_v
         pedfat->docext_v := pedido->docext2_v
         pedfat->(dbcommit(), dbunlock())
      endif
      if (!empty(pedido->datpag3_v))
         pedfat->(addrec(5))
         pedfat->id_v := lastid("pedfat")
         pedfat->codigo_v := pedido->codigo_v
         pedfat->datemi_v := pedido->datemi_v
         pedfat->dtparc_v := pedido->datpag3_v
         pedfat->vrparc_v := pedido->valpar3_v
         pedfat->docext_v := pedido->docext3_v
         pedfat->(dbcommit(), dbunlock())
      endif
      if (!empty(pedido->datpag4_v))
         pedfat->(addrec(5))
         pedfat->id_v := lastid("pedfat")
         pedfat->codigo_v := pedido->codigo_v
         pedfat->datemi_v := pedido->datemi_v
         pedfat->dtparc_v := pedido->datpag4_v
         pedfat->vrparc_v := pedido->valpar4_v
         pedfat->docext_v := pedido->docext4_v
         pedfat->(dbcommit(), dbunlock())
      endif
   endif
   pedido->(dbskip())
enddo
estoque->(dbgotop())
do while !estoque->(eof())
   if pedido2->(dbsetorder(3), dbseek(estoque->codigo_v))
      do while !pedido2->(eof()) .and. pedido2->item_v == estoque->codigo_v
         if estoque->ultmov_v<pedido2->datbai_v
            estoque->(reclock(5))
            estoque->ultmov_v := pedido2->datbai_v
            estoque->(dbcommit(), dbunlock())
         endif
         pedido2->(dbskip())
      enddo
   endif
   verifica_strings_estoque()
   estoque->(dbskip())
enddo
clifor->(dbgotop())
do while !clifor->(eof())
   verifica_strings_clifor()
   clifor->(dbskip())
enddo
clifor->(dbclosearea())
estoque->(dbclosearea())
pedido->(dbclosearea())
pedido2->(dbclosearea())
pedfat->(dbclosearea())
return nil

function verifica_strings_estoque()
nome := verifica_string(alltrim(estoque->nome_v))
if !nome==alltrim(estoque->nome_v)
   estoque->(reclock(5))
   estoque->nome_v := nome
   estoque->(dbcommit(), dbunlock())
endif
fabrican := verifica_string(alltrim(estoque->fabrican_v))
if !fabrican==alltrim(estoque->fabrican_v)
   estoque->(reclock(5))
   estoque->fabrican_v := fabrican
   estoque->(dbcommit(), dbunlock())
endif
return nil


function verifica_strings_clifor()
local endereco
endereco := verifica_string(alltrim(clifor->endereco_v))
if !endereco==alltrim(clifor->endereco_v)
   clifor->(reclock(5))
   clifor->endereco_v := endereco
   clifor->(dbcommit(), dbunlock())
endif
endereco := verifica_string(alltrim(clifor->endcob_v))
if !endereco==alltrim(clifor->endcob_v)
   clifor->(reclock(5))
   clifor->endcob_v := endereco
   clifor->(dbcommit(), dbunlock())
endif
endereco := verifica_string(alltrim(clifor->endent_v))
if !endereco==alltrim(clifor->endent_v)
   clifor->(reclock(5))
   clifor->endent_v := endereco
   clifor->(dbcommit(), dbunlock())
endif
return nil

function verifica_string(texto)
local corrigido
corrigido := ""
for i:=1 to len(texto)
   if asc(substr(texto,i,1))>=32 .and. asc(substr(texto,i,1))<=126
      corrigido += substr(texto,i,1)
   endif
next
return corrigido