FUNCTION TECNF(SERV)
LOCAL TELA,ENT,ENT2,X,COL,GETLIST:={},INTER
LOCAL CONT,TOTAL,TELA2
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR FICHA,LINSERV1,LINSERV2,LINSERV3,LINSERV4,VALTOT

MEMVAR FRETE,PLACA,UF,QUANT,ESPECIE,MARCA,NUMERO,PESOBRU,PESOLIQ
MEMVAR NOTA,DATSAI,HORASAI,DATEMI,HORAEMI,CFOP,CODTRAN,CUPOM,VALFRETE,ICMFRETE,OBSERVA1,NFS

MEMVAR MDATE,VALPAR,PARCELAS,MSGFISC,NATOPER

TELA:=SAVESCREEN()

WINDOW(0,0,24,79)

FICHA  :=SERV
CONT   :=.F.
NOTA   :=0
CUPOM  :=0
NFS    :=0
VALFRETE:=0
CODTRAN:=IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CODTRAN_V,0)
CFOP   :=SPACE(len(cfop->cfop_v))
TECNICA->(DBSETORDER(1))
IF TECNICA->(DBSETORDER(1),DBSEEK(FICHA))
   CONT:=.T.
ENDIF
MDATE:={,,,,,}
VALPAR:={,,,,,}

LINSERV1:=SPACE(LEN(NOTA->LINSERV1_V))
LINSERV2:=SPACE(LEN(NOTA->LINSERV2_V))
LINSERV3:=SPACE(LEN(NOTA->LINSERV3_V))
LINSERV4:=SPACE(LEN(NOTA->LINSERV4_V))

PARCELAS:=0
INTER   :=0
ENT     :=SPACE(1)

OBSERVA1:= SPACE(LEN(NOTA->OBSERVA1_V))
FRETE  :="2"
PLACA  :=SPACE(9)
UF     :=SPACE(2)
QUANT  :=0
ESPECIE:=SPACE(15)
MARCA  :=SPACE(15)
NUMERO :=SPACE(15)
PESOBRU:=SPACE(15)
PESOLIQ:=SPACE(15)
DATEMI :=DATE()
HORAEMI:=TIME()
DATSAI :=DATE()
HORASAI:=TIME()
ICMFRETE:=CONFIG->DEFICMS_V
MSGFISC:=CONFIG->MSGFISC_V
NATOPER := padr("VENDAS", LEN(NOTA->NATOPER_V))
NOTA->(DBSETORDER(1))
DO WHILE CONT=.T.
   TOTAL   :=0
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   if config->nfs_v = 'S'
      if tecnica->valitot_v > 0
         @ 1,2   SAY "Nota Fiscal   :" GET NOTA PICT "999999" VALID(NOTA>0.AND. VerificaNota(Nota, "0"))
      else
         @ 1,2   SAY "Nota Fiscal   :"
      endif
   else
      @ 1,2   SAY "Nota Fiscal   :" GET NOTA PICT "999999" VALID(NOTA>0.AND. VerificaNota(Nota, "0"))
   endif
   @ 1,25  SAY "Cupom Fiscal  :" GET CUPOM PICT "999999" // VALID(CUPOM==0.OR.!NOTA->(DBSETORDER(6),DBSEEK(STR(CUPOM,6)+" ")))
   if config->nfs_v = 'S'
      if TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V > 0
         @ 1,48  SAY "NF Paulista:" GET NFS PICT "999999" VALID(nfs>0.AND. VerificaNota(Nota, "A"))
      else
         @ 1,48  SAY "NF Paulista:" 
      endif
   endif
   @ 2,2   SAY "Cliente       : "+IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
   @ 3,2   SAY "C.F.OP.Transp.:" GET CFOP VALID(LASTKEY()=5 .OR. SEA_CFOP(CFOP,3,28))
   if config->nfe_v=="S"
      @ 3,47 SAY "Nt.Operacao:" GET NATOPER PICT "@!S18"
   endif
   @ 4,2   SAY "Transportadora:" GET CODTRAN PICT "99999" VALID(LASTKEY()=5 .OR. SEA_CODTRAN(CODTRAN,4,25))
   @ 05,01 SAY PADC("Descri‡ao dos Servi‡os Prestados",78) COLOR CORTIT
   @ 06,02 GET LINSERV1
   @ 07,02 GET LINSERV2
   @ 08,02 GET LINSERV3
   @ 09,02 GET LINSERV4
   @ 10,1  SAY PADC("Observacoes",78) COLOR CORTIT
   @ 11,02 GET OBSERVA1 PICT "@S76"
   @ 12,1  SAY PADC("Volumes Transportados",78) COLOR CORTIT
   @ 13,2  SAY "Frete p/Conta :" + FRETE
   //@ 13,2  SAY "Frete p/Conta :" GET FRETE VALID(FRETE$"12 ")
   //@ 13,20 SAY "Valor :" GET VALFRETE PICT "99,999.99" VALID TCORPARCS(VALFRETE)
   //@ 13,38 SAY "ICMS :" GET ICMFRETE PICT "@R 99.9999%"
   @ 13,54 SAY "Placa :" GET PLACA PICT "NNN-9999"
   @ 13,71 SAY "UF :" GET UF
   @ 14,2  SAY "Quantidade :" GET QUANT PICT "999,999,999.99"
   @ 14,31 SAY "Esp‚cie      :" GET ESPECIE
   @ 15,2  SAY "Marca      :" GET MARCA
   @ 15,31 SAY "N£mero       :" GET NUMERO
   @ 16,2  SAY "Peso Bruto :" GET PESOBRU
   @ 16,31 SAY "Peso L¡quido :" GET PESOLIQ
   @ 17,2  SAY "Dt. Emissao:" GET DATEMI
   @ 17,31 SAY "Data Sa¡da   :" GET DATSAI
   @ 17,57 SAY "Hora Sa¡da :" GET HORASAI
   @ 18,2  SAY "Msg.Fisco" GET MSGFISC pict "@s66"
   @ 19,1  SAY PADC("Faturamento",78) COLOR CORTIT
   if config->nfs_v=="S"
      tecfat->(dbsetorder(2), dbseek(tecnica->codigo_v))
      coluna := 2
      x := 0
      do while !tecfat->(eof()) .and. tecfat->codigo_v == tecnica->codigo_v .and. coluna <= 50
         x++
         MDATE[x]:=TECfat->DTPARC_V
         VALPAR[x]:=TECfat->VrPARc_V
         @ 20,coluna SAY DTOC(tecfat->dtparc_v)
         @ 21,coluna SAY TRANSFORM(tecfat->vrparc_v,"@R 999,999.99")
         tecfat->(dbskip())
         coluna += 12
      enddo
   else
      IF ! EMPTY(TECNICA->DATPAG_V)
         MDATE[1]:=TECNICA->DATPAG_V
         VALPAR[1]:=TECNICA->VALPAR_V
         @ 20,2 SAY DTOC(MDATE[1])
         @ 21,2 SAY TRANSFORM(VALPAR[1],"@R 999,999.99")
      ENDIF
      IF ! EMPTY(TECNICA->DATPAG1_V)
         MDATE[2]:=TECNICA->DATPAG1_V
         VALPAR[2]:=TECNICA->VALPAR1_V
         @ 20,14 SAY DTOC(MDATE[2])
         @ 21,14 SAY TRANSFORM(VALPAR[2],"@R 999,999.99")
      ENDIF
      IF ! EMPTY(TECNICA->DATPAG2_V)
         MDATE[3]:=TECNICA->DATPAG2_V
         VALPAR[3]:=TECNICA->VALPAR2_V
         @ 20,26 SAY DTOC(MDATE[3])
         @ 21,26 SAY TRANSFORM(VALPAR[3],"@R 999,999.99")
      ENDIF
      IF ! EMPTY(TECNICA->DATPAG3_V)
         MDATE[4]:=TECNICA->DATPAG3_V
         VALPAR[4]:=TECNICA->VALPAR3_V
         @ 20,38 SAY DTOC(MDATE[4])
         @ 21,38 SAY TRANSFORM(VALPAR[4],"@R 999,999.99")
      ENDIF
      IF ! EMPTY(TECNICA->DATPAG4_V)
         MDATE[5]:=TECNICA->DATPAG4_V
         VALPAR[5]:=TECNICA->VALPAR4_V
         @ 20,50 SAY DTOC(MDATE[5])
         @ 21,50 SAY TRANSFORM(VALPAR[5],"@R 999,999.99")
      ENDIF
   endif
   @ 22,1 TO 22,78
   @ 23,01 SAY PADL("Itens : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999,999.99")+"  Servi‡os : "+TRANSFORM(TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V,"@R 999,999,999.99")+"  Total : "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V,"@R 999,999,999.99")+" ",78) COLOR CORTIT
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   @ 23,01 SAY PADL("Itens : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999,999.99")+"  Servi‡os : "+TRANSFORM(TECNICA->VALMO_V,"@R 999,999,999.99")+"  Total : "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V,"@R 999,999,999.99")+" ",78) COLOR CORTIT
   IF ! CONFIRMA(20,20,"Confirma todos os dados ?")
      LOOP
   ENDIF
   IF ! TECIMP(TECNICA->CODIGO_V,.T.)
      LOOP
   ENDIF
   IF CONFIRMA(20,20,"Gerar faturamento ?")
      if config->nfs_v=="S"
         if TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V > 0
            gernftec("A")
         endif
         if tecnica->valitot_v > 0
            gernftec("0")
            gernfe()
         endif
         exit
      else
         DO WHILE ! ISPRINTER()
            AVISO("Impressora fora de linha ou nao conectada")
         ENDDO
         TECIMPNF()
         EXIT
      ENDIF
   endif
ENDDO
CLOSEWIN(0,0,24,79)
RESTSCREEN(,,,,TELA)
RETURN(.T.)

function gernftec(serie)
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR FICHA,LINSERV1,LINSERV2,LINSERV3,LINSERV4,VALTOT

MEMVAR FRETE,PLACA,UF,QUANT,ESPECIE,MARCA,NUMERO,PESOBRU,PESOLIQ
MEMVAR NOTA,DATSAI,HORASAI,DATEMI,HORAEMI,CFOP,CODTRAN,CUPOM,VALFRETE,ICMFRETE,OBSERVA1,NFS

MEMVAR MDATE,VALPAR,PARCELAS,MSGFISC,NATOPER
IF NOTA->(ADDREC(5))
   if serie == "0"
      NOTA->CODIGO_V  :=NOTA
      NOTA->NFS_V     :=NFS
   else
      NOTA->CODIGO_V  :=NFS
      NOTA->NFS_V     :=NOTA
   endif
   NOTA->SERIE_V   :=serie
   NOTA->CUPOM_V   :=CUPOM
   NOTA->FICHA_V   :=TECNICA->CODIGO_V
   NOTA->CLIFOR_V  :=TECNICA->CLIFOR_V
   NOTA->CODTRAN_V :=CODTRAN
   NOTA->CFOP_V    :=CFOP
   NOTA->DATEMI_V  :=DATEMI
   NOTA->HORAEMI_V :=HORAEMI
   NOTA->DATSAI_V  :=DATSAI
   NOTA->HORASAI_V :=HORASAI
   NOTA->PLACA_V   :=PLACA
   NOTA->UF_V      :=UF
   NOTA->QTD_V     :=QUANT
   NOTA->ESPECIE_V :=ESPECIE
   NOTA->MARCA_V   :=MARCA
   NOTA->NUMERO_V  :=NUMERO
   NOTA->PESOBRU_V :=PESOBRU
   NOTA->PESOLIQ_V :=PESOLIQ
   NOTA->OBSERVA1_V:=OBSERVA1
   NOTA->NOMSEN_V  :=NOMSEN
   NOTA->LINSERV1_V:=LINSERV1
   NOTA->LINSERV2_V:=LINSERV2
   NOTA->LINSERV3_V:=LINSERV3
   NOTA->LINSERV4_V:=LINSERV4
   if serie == "A"
      NOTA->VALMO_V   :=TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V
   else
      NOTA->FRETE_V   :=FRETE
      NOTA->VALFRETE_V:=VALFRETE
      NOTA->ICMFRETE_V:=ICMFRETE
      NOTA->MSGFISC_V :=MSGFISC
   endif
   NOTA->NATOPER_V :=NATOPER
   nTotalFrete := 0
   if serie=="0"
      tecnica2->(dbsetorder(1), dbseek(tecnica->codigo_v))
      DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
         nota2->(addrec())
         nota2->codigo_v := nota->codigo_v
         nota2->serie_v := nota->serie_v
         nota2->datemi_v := nota->datemi_v
         nota2->item_v := tecnica2->item_v
         nota2->valuni_v := tecnica2->valuni_v
         nota2->qtd_v := tecnica2->qtd_v
         nota2->icms_v := tecnica2->icms_v
         nota2->bascal_v := tecnica2->bascal_v
         nota2->tbascal_v := tecnica2->tbascal_v
         nota2->frete_v := round( (nota->valfrete_v / nota->valitot_v) * (nota2->valuni_v * nota2->qtd_v) ,2)
         nota2->cfop_v    := tecnica2->cfop_v
         nota2->sittabb_v := tecnica2->sittabb_v
         nota2->modbc_v   := tecnica2->modbc_v
         nota2->modbcst_v := tecnica2->modbcst_v
         nota2->mgvradic_v:= tecnica2->mgvradic_v
         nota2->bascalst_v:= tecnica2->bascalst_v
         nota2->icmsst_v  := tecnica2->icmsst_v
         nota2->modpis_v := tecnica2->modpis_v
         nota2->pis_v := tecnica2->pis_v
         nota2->mdcofins_v := tecnica2->mdcofins_v
         nota2->cofins_v := tecnica2->cofins_v
         nota2->(dbcommit(), dbunlock())
         nTotalFrete += nota2->frete_v
          IF NOTA->(RECLOCK(5))
            NOTA->VALITOT_V:=NOTA->VALITOT_V+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
            NOTA->(DBUNLOCK())
         ENDIF
         tecnica2->(dbskip())
      ENDDO
      nota2->(reclock())
      nota2->frete_v += (nota->valfrete_v - nTotalFrete)
      nota2->(dbcommit(), dbunlock())
   endif
   IF TECNICA->(RECLOCK())
      if alltrim(nota->serie_v) == "0"
         TECNICA->NOTA_V:=NOTA->CODIGO_V
      else
         TECNICA->nfs_V:=NOTA->codigo_V
      endif
      TECNICA->(DBUNLOCK())
   ENDIF
   
   if config->autven_v="P" .and. config->tipaut_v=='N'
      if confirma(20,20,"Registrar Contas Futuras ?")
         registrar:="S"
      else
         registrar:="N"
      endif
   else
      registrar:=if(config->autven_v=='S' .and. config->tipaut_v=='N', 'S', 'N')
   endif
   mpagrec := array(0)
   tecfat->(dbsetorder(2), dbseek(tecnica->codigo_v))
   do while !tecfat->(eof()) .and. tecfat->codigo_v == tecnica->codigo_v
      tecfat->(reclock(5))
      if registrar == "S" .and. ( (serie=="0" .and. tecfat->tpparc_v=="P" .or. tecfat->tpparc_v=="U") .or. (serie=="A" .and. tecfat->tpparc_v=="S"))
         pagrec->(addrec(5))
         config->(reclock())
         pagrec:="R"+strzero(config->pagrec_v+1,5,0)
         config->pagrec_v:=config->pagrec_v+1
         config->(dbunlock())
         pagrec->codigo_v :=pagrec
         pagrec->clifor_v :=nota->clifor_v
         pagrec->codpla_v :=tecnica->codpla_v
         pagrec->tecnica_v:=tecnica->codigo_v
         pagrec->valor_v  :=tecfat->vrparc_v
         pagrec->datven_v :=tecfat->dtparc_v
         pagrec->docext_v :=tecfat->docext_v
         pagrec->docint_v :="nf."+alltrim(str(nota->codigo_v))
         pagrec->datint_v :=nota->datemi_v
         pagrec->desc_v   :="nf."+alltrim(str(nota->codigo_v))+" ficha "+tecnica->codigo_v
         pagrec->(dbunlock())
         xmig_add_pagrec(@mpagrec)
         tecfat->pagrec_v :=pagrec
      endif
      tecfat->nota_v := nota->codigo_v
      tecfat->datnf_v := nota->datemi_v
      tecfat->(dbcommit(), dbunlock())
      tecfat->(dbskip())
   enddo
   if (!empty(mpagrec))
   	xmig_pagrec(mpagrec)
   endif

endif
return nil

FUNCTION TECIMPNF()
LOCAL  VALBASE,VALICMS,Y,X,COL,LIN,MESSAGE,GETLIST:={},CONTINUA, SERIE := "0"
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR FICHA,LINSERV1,LINSERV2,LINSERV3,LINSERV4,VALTOT,VALPAR,MDATE

MEMVAR FRETE,PLACA,UF,QUANT,ESPECIE,MARCA,NUMERO,PESOBRU,PESOLIQ
MEMVAR NOTA,DATSAI,HORASAI,DATEMI,HORAEMI,CFOP,CODTRAN,PARCELAS,CUPOM,VALBAS,VALFRETE,ICMFRETE,OBSERVA1
TECNICA2->(DBSETORDER(1),DBSEEK(TECNICA->CODIGO_V))
IF EMPTY(CONFIG->MODNF_V) .OR. CONFIG->MODNF_V=="1" // AKOSA
   DO WHILE .T.
      MESSAGE:={,,,,,,,}
      CONTINUA:="N"
      if config->nfs_v=="S"
      else
         SET PRINTER TO LPT1
         SET DEVICE TO PRINTER
      endif
      @ PROW(),PCOL() SAY CHR(18)
      @ 1,56   SAY "X"
      @ 1,74   SAY STRZERO(NOTA,6)
      SET DEVICE TO SCREEN
      if config->nfs_v=="S"
      else
         SET DEVICE TO PRINTER
      endif
      @ PROW(),PCOL() SAY CHR(15)
      @ 6,14   SAY IF(CFOP->(DBSETORDER(1),DBSEEK(CFOP)),CFOP->MENSAGEM_V,SPACE(18))
      @ 6,58   SAY CFOP
      @ 9,14   SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
      @ 9,95   SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(19))
      @ 9,132  SAY DTOC(DATEMI)
      @ 11,14  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
      @ 11,85  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->BAIRRO_V,27),SPACE(27))
      @ 11,115 SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-999"),SPACE(8))
      @ 11,132 SAY DTOC(DATSAI)
      @ 13,14  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->CIDADE_V,25),SPACE(25))
      @ 13,87  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
      @ 13,63  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) ###99-9999"),SPACE(12))
      @ 13,95  SAY IF(CLIFOR->(DBSETORDER(1),DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
      @ 13,132 SAY HORASAI
      Y:=1
      COL:=14
      DO WHILE .T.
         IF MDATE[Y]=(NIL)
            EXIT
         ENDIF
         @ 15,COL+4 SAY MDATE[Y]
         Y++
         COL:=COL+20
      ENDDO
      IF NOTA->(ADDREC(5))
         NOTA->CODIGO_V  :=NOTA
         NOTA->SERIE_V   := SERIE
         NOTA->CUPOM_V   :=CUPOM
         NOTA->FICHA_V   :=TECNICA->CODIGO_V
         NOTA->CLIFOR_V  :=TECNICA->CLIFOR_V
         NOTA->CODTRAN_V :=CODTRAN
         NOTA->CFOP_V    :=CFOP
         NOTA->DATEMI_V  :=DATEMI
         NOTA->HORAEMI_V :=HORAEMI
         NOTA->DATSAI_V  :=DATSAI
         NOTA->HORASAI_V :=HORASAI
         NOTA->PLACA_V   :=PLACA
         NOTA->UF_V      :=UF
         NOTA->QTD_V     :=QUANT
         NOTA->ESPECIE_V :=ESPECIE
         NOTA->MARCA_V   :=MARCA
         NOTA->NUMERO_V  :=NUMERO
         NOTA->PESOBRU_V :=PESOBRU
         NOTA->PESOLIQ_V :=PESOLIQ
         NOTA->OBSERVA1_V:=OBSERVA1
         NOTA->NOMSEN_V  :=NOMSEN
         IF MDATE[1]#(NIL)
            NOTA->DATPAR1_V:=MDATE[1]
            NOTA->VALPAR1_V:=VALPAR[1]
         ENDIF
         IF MDATE[2]#(NIL)
            NOTA->DATPAR2_V:=MDATE[2]
            NOTA->VALPAR2_V:=VALPAR[2]
         ENDIF
         IF MDATE[3]#(NIL)
            NOTA->DATPAR3_V:=MDATE[3]
            NOTA->VALPAR3_V:=VALPAR[3]
         ENDIF
         IF MDATE[4]#(NIL)
            NOTA->DATPAR4_V:=MDATE[4]
            NOTA->VALPAR4_V:=VALPAR[4]
         ENDIF
         IF MDATE[5]#(NIL)
            NOTA->DATPAR5_V:=MDATE[5]
            NOTA->VALPAR5_V:=VALPAR[5]
         ENDIF
         NOTA->(DBUNLOCK())
      ENDIF
      Y:=0
      VALBASE:=0
      VALICMS:=0
      LIN:=20
      DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
         IF ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)) .AND. ESTOQUE->SITTABB_V=2 .AND. BASCAL->(DBSETORDER(1),DBSEEK(CLIFOR->ESTADO_V))
            IF CLIFOR->PESSOA_V="J"
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCAL_V/100)
            ELSE
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCALPF_V/100)
            ENDIF
            X:=1
            DO WHILE .T.
               IF MESSAGE[X]=(NIL)
                  MESSAGE[X]:=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               IF MESSAGE[X]=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               X++
            ENDDO
         ELSE
            VALBAS=(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
         ENDIF
         VALBASE:=VALBASE+VALBAS
         IF CLIFOR->PESSOA_V="J"
            VALICMS:=VALICMS+((BASCAL->ICMS_V/100)*VALBAS)
         ELSE
            VALICMS:=VALICMS+((BASCAL->ICMSPF_V/100)*VALBAS)
         ENDIF
         @ LIN,14  SAY LEFT(TECNICA2->ITEM_V+" - "+IF(ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->NOME_V,SPACE(12)),45)
         @ LIN,70  SAY IF(ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)),ALLTRIM(STR(ESTOQUE->SITTABA_V))+ALLTRIM(STR(ESTOQUE->SITTABB_V)),SPACE(2))
         @ LIN,76  SAY IF(ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->UNIDADE_V,SPACE(2))
         @ LIN,82  SAY IF(TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->QTD_V,"99,999"),SPACE(6))
         @ LIN,88  SAY IF(TECNICA2->VALUNI_V>0,TRANSFORM(TECNICA2->VALUNI_V,"999,999,999.99"),SPACE(9))
         @ LIN,104 SAY IF(TECNICA2->VALUNI_V*TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->VALUNI_V*TECNICA2->QTD_V,"999,999,999.99"),SPACE(9))
   //      @ LIN,124 SAY IF(TECNICA2->ICMS_V>0,TRANSFORM(TECNICA2->ICMS_V,"@R 999%"),SPACE(4))
         X:=1
         DO WHILE .T.
            IF MESSAGE[X]=(NIL)
               MESSAGE[X]:=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            IF MESSAGE[X]=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            X++
         ENDDO
         IF NOTA->(RECLOCK(5))
            NOTA->VALITOT_V:=NOTA->VALITOT_V+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
            NOTA->(DBUNLOCK())
         ENDIF
         TECNICA2->(DBSKIP())
         IF Y>=CONFIG->QTDITENS_V .AND. TECNICA2->CODIGO_V==TECNICA->CODIGO_V
            CONTINUA:="S"
            EXIT
         ENDIF
         Y++
         LIN++
      ENDDO
      IF CONTINUA="N"
         IF NOTA->(RECLOCK())
            NOTA->LINSERV1_V:=LINSERV1
            NOTA->LINSERV2_V:=LINSERV2
            NOTA->LINSERV3_V:=LINSERV3
            NOTA->LINSERV4_V:=LINSERV4
            NOTA->VALMO_V   :=TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V
            NOTA->(DBUNLOCK())
         ENDIF
         @ 37.5,14 SAY LINSERV1
         @ 38.5,14 SAY LINSERV2
         @ 39.5,14 SAY LINSERV3
         IF (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100)>0
            @ 39.5,120 SAY (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100) PICT "@R 999,999,999.99"
         ENDIF
         @ 40.5,14 SAY LINSERV4
         IF NOTA->VALMO_V>0
            @ 41.5,120 SAY NOTA->VALMO_V PICT "@R 999,999,999.99"
         ENDIF
         NOTA->(RECLOCK(5))
         NOTA->FRETE_V   :=FRETE
         NOTA->VALFRETE_V:=VALFRETE
         NOTA->ICMFRETE_V:=ICMFRETE
         NOTA->(DBUNLOCK())
         IF NOTA->ICMFRETE_V>0
            VALBASE = VALBASE + NOTA->VALFRETE_V
            *VALICMS = VALICMS + (NOTA->VALFRETE_V*(NOTA->ICMFRETE_V/100))
         ENDIF
      ENDIF
      @ 42.8,40  SAY CONFIG->NFCOMPL_V
   //   @ 44.8,14  SAY IF(VALBASE>0,TRANSFORM(VALBASE,"@R 999,999,999.99")," ")
   //   @ 44.8,40  SAY IF(VALICMS>0,TRANSFORM(VALICMS,"@R 999,999,999.99")," ")
      @ 44.8,120 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      IF CONTINUA="N"
         @ 46,06  SAY IF(NOTA->VALFRETE_V>0,TRANSFORM(NOTA->VALFRETE_V,"@R 999,999.99")," ")
         @ 46.5,120 SAY IF((NOTA->VALITOT_V+NOTA->VALMO_V+NOTA->VALFRETE_V)>0,TRANSFORM(NOTA->VALITOT_V+NOTA->VALMO_V+NOTA->VALFRETE_V,"@R 999,999,999.99")," ")
      ELSE
         @ 46.5,120 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      ENDIF
      @ 49.5,14  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->NOME_V,SPACE(50))
      @ 49.5,93  SAY NOTA->FRETE_V
      @ 49.5,99  SAY NOTA->PLACA_V
      @ 49.5,113 SAY NOTA->UF_V
      @ 49.5,120 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->CGC_V,SPACE(18))
      @ 51.5,14  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),30),SPACE(30))
      @ 51.5,75  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->CIDADE_V,30),SPACE(30))
      @ 51.5,113 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->ESTADO_V,30),SPACE(30))
      @ 51.5,120 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->INSEST_V,SPACE(15))
      @ 53.5,14  SAY IF(NOTA->QTD_V#0,TRANSFORM(NOTA->QTD_V,"@R 999,999.99"),SPACE(2))
      IF !EMPTY(NOTA->CUPOM_V) .AND. VALICMS>0
//         @ 56,14 SAY "-ICMS recolhido no"
//         @ 57,14 SAY "Cupom Fiscal "+STRZERO(NOTA->CUPOM_V,6)
//         @ 58,14 SAY "-ICMS incluso no "
//         @ 59,14 SAY "preco R$"+ALLTRIM(TRANSFORM(VALICMS,"99,999.99"))
         @ 56,44 SAY "-ICMS recolhido no"
         @ 57,44 SAY "Cupom Fiscal "+STRZERO(NOTA->CUPOM_V,6)
//         @ 58,44 SAY "-ICMS incluso no "
//         @ 59,44 SAY "preco R$"+ALLTRIM(TRANSFORM(VALICMS,"99,999.99"))
      ENDIF
      @ 66,16   SAY STRZERO(NOTA->CODIGO_V,6)
      @ PROW(),PCOL() SAY CHR(18)
      IF CONTINUA="S"
         @ 00,PCOL() SAY CHR(18)+" "
         SET DEVICE TO SCREEN
         WINDOW(10,10,12,56)
         SETCOLOR(CORTIT)
         @ 9,10 SAY "Estouro de Itens o Sistema Requer Mais Uma Nota"
         SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
         DO WHILE NOTA->(DBSETORDER(1),DBSEEK(str(NOTA,6)+"0"))
            @ 11,12 SAY "N£mero da Nota Fiscal :" GET NOTA VALID(! NOTA->(DBSEEK(str(NOTA,6))))
            READ
            IF LASTKEY()=27
               AVISO(" necess rio digitar o n£mero da nota ...")
               LOOP
            ENDIF
         ENDDO
         LOOP
      ENDIF
      IF TECNICA->(RECLOCK())
         TECNICA->NOTA_V:=NOTA->CODIGO_V
         TECNICA->(DBUNLOCK())
      ENDIF
      EXIT
   ENDDO
   @ 0,PCOL() SAY CHR(18)+" "
   SET PRINTER TO
   SET DEVICE TO SCREEN
ELSEIF CONFIG->MODNF_V=="2" // AGROJ
   DO WHILE .T.
      MESSAGE:={,,,,,,,}
      CONTINUA:="N"
      if config->nfs_v=="S"
      else
         SET PRINTER TO LPT1
         SET DEVICE TO PRINTER
      endif
      @ PROW(),PCOL() SAY CHR(18)
      @ 1,56   SAY "X"
      @ PROW(),PCOL() SAY CHR(15)
      @ 6,14   SAY IF(CFOP->(DBSEEK(CFOP)),CFOP->MENSAGEM_V,SPACE(18))
      @ 6,58   SAY CFOP
      @ 9,14   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
      @ 9,95   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(19))
      @ 9,132  SAY DTOC(DATEMI)
      @ 11,14  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
      @ 11,85  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->BAIRRO_V,27),SPACE(27))
      @ 11,115 SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-999"),SPACE(8))
      @ 11,132 SAY DTOC(DATSAI)
      @ 13,14  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->CIDADE_V,25),SPACE(25))
      @ 13,87  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
      @ 13,63  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) ###99-9999"),SPACE(12))
      @ 13,95  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
      @ 13,132 SAY HORASAI
      Y:=1
      COL:=14
      DO WHILE .T.
         IF MDATE[Y]=(NIL)
            EXIT
         ENDIF
         @ 15,COL+4 SAY MDATE[Y]
         Y++
         COL:=COL+20
      ENDDO
      IF NOTA->(ADDREC(5))
         NOTA->CODIGO_V  :=NOTA
         NOTA->SERIE_V   := SERIE
         NOTA->CUPOM_V   :=CUPOM
         NOTA->FICHA_V   :=TECNICA->CODIGO_V
         NOTA->CLIFOR_V  :=TECNICA->CLIFOR_V
         NOTA->CODTRAN_V :=CODTRAN
         NOTA->CFOP_V    :=CFOP
         NOTA->DATEMI_V  :=DATEMI
         NOTA->HORAEMI_V :=HORAEMI
         NOTA->DATSAI_V  :=DATSAI
         NOTA->HORASAI_V :=HORASAI
         NOTA->FRETE_V   :=FRETE
         NOTA->PLACA_V   :=PLACA
         NOTA->UF_V      :=UF
         NOTA->QTD_V     :=QUANT
         NOTA->ESPECIE_V :=ESPECIE
         NOTA->MARCA_V   :=MARCA
         NOTA->NUMERO_V  :=NUMERO
         NOTA->PESOBRU_V :=PESOBRU
         NOTA->PESOLIQ_V :=PESOLIQ
         NOTA->NOMSEN_V  :=NOMSEN
         IF MDATE[1]#(NIL)
            NOTA->DATPAR1_V:=MDATE[1]
            NOTA->VALPAR1_V:=VALPAR[1]
         ENDIF
         IF MDATE[2]#(NIL)
            NOTA->DATPAR2_V:=MDATE[2]
            NOTA->VALPAR2_V:=VALPAR[2]
         ENDIF
         IF MDATE[3]#(NIL)
            NOTA->DATPAR3_V:=MDATE[3]
            NOTA->VALPAR3_V:=VALPAR[3]
         ENDIF
         IF MDATE[4]#(NIL)
            NOTA->DATPAR4_V:=MDATE[4]
            NOTA->VALPAR4_V:=VALPAR[4]
         ENDIF
         IF MDATE[5]#(NIL)
            NOTA->DATPAR5_V:=MDATE[5]
            NOTA->VALPAR5_V:=VALPAR[5]
         ENDIF
         NOTA->(DBUNLOCK())
      ENDIF
      Y:=0
      VALBASE:=0
      VALICMS:=0
      LIN:=20
      DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
         IF ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)) .AND. ESTOQUE->SITTABB_V=2 .AND. BASCAL->(DBSETORDER(1),DBSEEK(CLIFOR->ESTADO_V))
            IF CLIFOR->PESSOA_V="J"
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCAL_V/100)
            ELSE
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCALPF_V/100)
            ENDIF
            X:=1
            DO WHILE .T.
               IF MESSAGE[X]=(NIL)
                  MESSAGE[X]:=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               IF MESSAGE[X]=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               X++
            ENDDO
         ELSE
            VALBAS=(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
         ENDIF
         VALBASE:=VALBASE+VALBAS
         IF CLIFOR->PESSOA_V="J"
            VALICMS:=VALICMS+((BASCAL->ICMS_V/100)*VALBAS)
         ELSE
            VALICMS:=VALICMS+((BASCAL->ICMSPF_V/100)*VALBAS)
         ENDIF
         @ LIN,14  SAY LEFT(TECNICA2->ITEM_V+" - "+IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->NOME_V,SPACE(12)),45)
         @ LIN,70  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ALLTRIM(STR(ESTOQUE->SITTABA_V))+ALLTRIM(STR(ESTOQUE->SITTABB_V)),SPACE(2))
         @ LIN,76  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->UNIDADE_V,SPACE(2))
         @ LIN,82  SAY IF(TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->QTD_V,"99,999"),SPACE(6))
         @ LIN,88  SAY IF(TECNICA2->VALUNI_V>0,TRANSFORM(TECNICA2->VALUNI_V,"999,999,999.99"),SPACE(9))
         @ LIN,104 SAY IF(TECNICA2->VALUNI_V*TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->VALUNI_V*TECNICA2->QTD_V,"999,999,999.99"),SPACE(9))
   //      @ LIN,124 SAY IF(TECNICA2->ICMS_V>0,TRANSFORM(TECNICA2->ICMS_V,"@R 999%"),SPACE(4))
         X:=1
         DO WHILE .T.
            IF MESSAGE[X]=(NIL)
               MESSAGE[X]:=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            IF MESSAGE[X]=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            X++
         ENDDO
         IF NOTA->(RECLOCK(5))
            NOTA->VALITOT_V:=NOTA->VALITOT_V+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
            NOTA->(DBUNLOCK())
         ENDIF
         TECNICA2->(DBSKIP())
         IF Y>=CONFIG->QTDITENS_V .AND. TECNICA2->CODIGO_V==TECNICA->CODIGO_V
            CONTINUA:="S"
            EXIT
         ENDIF
         Y++
         LIN++
      ENDDO
      IF !EMPTY(NOTA->OBSERVA1_V)
         @ 34,14 SAY NOTA->OBSERVA1_V
      ENDIF
      IF CONTINUA="N"
         IF NOTA->(RECLOCK())
            NOTA->LINSERV1_V:=LINSERV1
            NOTA->LINSERV2_V:=LINSERV2
            NOTA->LINSERV3_V:=LINSERV3
            NOTA->LINSERV4_V:=LINSERV4
            NOTA->VALMO_V   :=TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V
            NOTA->(DBUNLOCK())
         ENDIF
         @ 37.5,14 SAY LINSERV1
         @ 38.5,14 SAY LINSERV2
         @ 39.5,14 SAY LINSERV3
         IF (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100)>0
            @ 39.5,120 SAY (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100) PICT "@R 999,999,999.99"
         ENDIF
         @ 40.5,14 SAY LINSERV4
         IF NOTA->VALMO_V>0
            @ 41.5,120 SAY NOTA->VALMO_V PICT "@R 999,999,999.99"
         ENDIF
      ENDIF
      @ 42.8,40  SAY CONFIG->NFCOMPL_V
   //   @ 44.8,14  SAY IF(VALBASE>0,TRANSFORM(VALBASE,"@R 999,999,999.99")," ")
   //   @ 44.8,40  SAY IF(VALICMS>0,TRANSFORM(VALICMS,"@R 999,999,999.99")," ")
      @ 44.8,120 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      IF CONTINUA="N"
         @ 46.5,120 SAY IF((NOTA->VALITOT_V+NOTA->VALMO_V)>0,TRANSFORM(NOTA->VALITOT_V+NOTA->VALMO_V,"@R 999,999,999.99")," ")
      ELSE
         @ 46.5,120 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      ENDIF
      @ 49.5,14  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->NOME_V,SPACE(50))
      @ 49.5,93  SAY NOTA->FRETE_V
      @ 49.5,99  SAY NOTA->PLACA_V
      @ 49.5,113 SAY NOTA->UF_V
      @ 49.5,120 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->CGC_V,SPACE(18))
      @ 51.5,14  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),30),SPACE(30))
      @ 51.5,75  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->CIDADE_V,30),SPACE(30))
      @ 51.5,113 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->ESTADO_V,30),SPACE(30))
      @ 51.5,120 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->INSEST_V,SPACE(15))
      @ 53.5,14  SAY IF(NOTA->QTD_V#0,TRANSFORM(NOTA->QTD_V,"@R 999,999.99"),SPACE(2))
      @ PROW(),PCOL() SAY CHR(18)
      IF CONTINUA="S"
         @ 00,PCOL() SAY CHR(18)+" "
         SET DEVICE TO SCREEN
         WINDOW(10,10,12,56)
         SETCOLOR(CORTIT)
         @ 9,10 SAY "Estouro de Itens o Sistema Requer Mais Uma Nota"
         SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
         DO WHILE NOTA->(DBSETORDER(1),DBSEEK(str(NOTA,6)+"0"))
            @ 11,12 SAY "N£mero da Nota Fiscal :" GET NOTA VALID(! NOTA->(DBSEEK(str(NOTA,6)+"0")))
            READ
            IF LASTKEY()=27
               AVISO(" necess rio digitar o n£mero da nota ...")
               LOOP
            ENDIF
         ENDDO
         LOOP
      ENDIF
      IF TECNICA->(RECLOCK())
         TECNICA->NOTA_V:=NOTA->CODIGO_V
         TECNICA->(DBUNLOCK())
      ENDIF
      EXIT
   ENDDO
   @ 0,PCOL() SAY CHR(18)+" "
   SET PRINTER TO
   SET DEVICE TO SCREEN
ELSEIF CONFIG->MODNF_V=="3" // NIPO
   DO WHILE .T.
      MESSAGE:={,,,,,,,}
      CONTINUA:="N"
      if config->nfs_v=="S"
      else
         SET PRINTER TO LPT1
         SET DEVICE TO PRINTER
      endif
      @ PROW(),PCOL() SAY CHR(18)
      @ 1,53   SAY "X"
      @ 1,74   SAY STRZERO(NOTA->CODIGO_V,6)
      @ 6,5    SAY IF(CFOP->(DBSEEK(CFOP)),CFOP->MENSAGEM_V,SPACE(18))
      @ 6,30   SAY CFOP
      @ PROW(),PCOL() SAY CHR(15)
      @ 9,06   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
      @ 9,91   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(19))
      @ 9,124  SAY DTOC(DATEMI)
      @ 11,06  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
      @ 11,77  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->BAIRRO_V,27),SPACE(27))
      @ 11,107 SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-999"),SPACE(8))
      @ 11,124 SAY DTOC(DATSAI)
      @ 13,06  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->CIDADE_V,25),SPACE(25))
      @ 13,81  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
      @ 13,55  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) ###99-9999"),SPACE(12))
      @ 13,91  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
      @ 13,124 SAY HORASAI
      Y:=1
      COL:=06
      DO WHILE .T.
         IF MDATE[Y]=(NIL)
            EXIT
         ENDIF
         @ 16,COL+4 SAY MDATE[Y]
         Y++
         COL:=COL+20
      ENDDO
      IF NOTA->(ADDREC(5))
         NOTA->CODIGO_V  :=NOTA
         NOTA->SERIE_V   := SERIE
         NOTA->CUPOM_V   :=CUPOM
         NOTA->FICHA_V   :=TECNICA->CODIGO_V
         NOTA->CLIFOR_V  :=TECNICA->CLIFOR_V
         NOTA->CODTRAN_V :=CODTRAN
         NOTA->CFOP_V    :=CFOP
         NOTA->DATEMI_V  :=DATEMI
         NOTA->HORAEMI_V :=HORAEMI
         NOTA->DATSAI_V  :=DATSAI
         NOTA->HORASAI_V :=HORASAI
         NOTA->FRETE_V   :=FRETE
         NOTA->PLACA_V   :=PLACA
         NOTA->UF_V      :=UF
         NOTA->QTD_V     :=QUANT
         NOTA->ESPECIE_V :=ESPECIE
         NOTA->MARCA_V   :=MARCA
         NOTA->NUMERO_V  :=NUMERO
         NOTA->PESOBRU_V :=PESOBRU
         NOTA->PESOLIQ_V :=PESOLIQ
         NOTA->NOMSEN_V  :=NOMSEN
         IF MDATE[1]#(NIL)
            NOTA->DATPAR1_V:=MDATE[1]
            NOTA->VALPAR1_V:=VALPAR[1]
         ENDIF
         IF MDATE[2]#(NIL)
            NOTA->DATPAR2_V:=MDATE[2]
            NOTA->VALPAR2_V:=VALPAR[2]
         ENDIF
         IF MDATE[3]#(NIL)
            NOTA->DATPAR3_V:=MDATE[3]
            NOTA->VALPAR3_V:=VALPAR[3]
         ENDIF
         IF MDATE[4]#(NIL)
            NOTA->DATPAR4_V:=MDATE[4]
            NOTA->VALPAR4_V:=VALPAR[4]
         ENDIF
         IF MDATE[5]#(NIL)
            NOTA->DATPAR5_V:=MDATE[5]
            NOTA->VALPAR5_V:=VALPAR[5]
         ENDIF
         NOTA->(DBUNLOCK())
      ENDIF
      Y:=0
      VALBASE:=0
      VALICMS:=0
      LIN:=20
      DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
         IF ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)) .AND. ESTOQUE->SITTABB_V=2 .AND. BASCAL->(DBSETORDER(1),DBSEEK(CLIFOR->ESTADO_V))
            IF CLIFOR->PESSOA_V="J"
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCAL_V/100)
            ELSE
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCALPF_V/100)
            ENDIF
            X:=1
            DO WHILE .T.
               IF MESSAGE[X]=(NIL)
                  MESSAGE[X]:=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               IF MESSAGE[X]=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               X++
            ENDDO
         ELSE
            VALBAS=(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
         ENDIF
         VALBASE:=VALBASE+VALBAS
         IF CLIFOR->PESSOA_V="J"
            VALICMS:=VALICMS+((BASCAL->ICMS_V/100)*VALBAS)
         ELSE
            VALICMS:=VALICMS+((BASCAL->ICMSPF_V/100)*VALBAS)
         ENDIF
         @ LIN,06  SAY LEFT(TECNICA2->ITEM_V+" - "+IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->NOME_V,SPACE(12)),45)
         *@ LIN,81  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ALLTRIM(STR(ESTOQUE->SITTABA_V))+ALLTRIM(STR(ESTOQUE->SITTABB_V)),SPACE(2))
         @ LIN,86  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->UNIDADE_V,SPACE(2))
         @ LIN,90  SAY IF(TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->QTD_V,"99,999"),SPACE(6))
         @ LIN,97  SAY IF(TECNICA2->VALUNI_V>0,TRANSFORM(TECNICA2->VALUNI_V,"999,999,999.99"),SPACE(9))
         @ LIN,113 SAY IF(TECNICA2->VALUNI_V*TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->VALUNI_V*TECNICA2->QTD_V,"999,999,999.99"),SPACE(9))
         IF CLIFOR->PESSOA_V="J"
            @ LIN,129 SAY IF(BASCAL->ICMS_V>0,TRANSFORM(BASCAL->ICMS_V,"@R 99.9999%"),SPACE(4))
         ELSE
            @ LIN,129 SAY IF(BASCAL->ICMSPF_V>0,TRANSFORM(BASCAL->ICMSPF_V,"@R 99.9999%"),SPACE(4))
         ENDIF
         X:=1
         DO WHILE .T.
            IF MESSAGE[X]=(NIL)
               MESSAGE[X]:=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            IF MESSAGE[X]=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            X++
         ENDDO
         IF NOTA->(RECLOCK(5))
            NOTA->VALITOT_V:=NOTA->VALITOT_V+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
            NOTA->(DBUNLOCK())
         ENDIF
         TECNICA2->(DBSKIP())
         IF Y>=CONFIG->QTDITENS_V .AND. TECNICA2->CODIGO_V==TECNICA->CODIGO_V
            CONTINUA:="S"
            EXIT
         ENDIF
         Y++
         LIN++
      ENDDO
      IF !EMPTY(NOTA->OBSERVA1_V)
         @ 34,14 SAY NOTA->OBSERVA1_V
      ENDIF
      IF CONTINUA="N"
         IF NOTA->(RECLOCK())
            NOTA->LINSERV1_V:=LINSERV1
            NOTA->LINSERV2_V:=LINSERV2
            NOTA->LINSERV3_V:=LINSERV3
            NOTA->LINSERV4_V:=LINSERV4
            NOTA->VALMO_V   :=TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V
            NOTA->(DBUNLOCK())
         ENDIF
         @ 36.5,06 SAY LINSERV1
         @ 37.5,06 SAY LINSERV2
         @ 38.5,06 SAY LINSERV3
         IF (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100)>0
            @ 38.5,114 SAY (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100) PICT "@R 999,999,999.99"
         ENDIF
         @ 39.5,06 SAY LINSERV4
         IF NOTA->VALMO_V>0
            @ 40.5,114 SAY NOTA->VALMO_V PICT "@R 999,999,999.99"
         ENDIF
      ENDIF
      @ 41,34  SAY CONFIG->NFCOMPL_V
      @ 44,06  SAY IF(VALBASE>0,TRANSFORM(VALBASE,"@R 999,999,999.99")," ")
      @ 44,32  SAY IF(VALICMS>0,TRANSFORM(VALICMS,"@R 999,999,999.99")," ")
      @ 44,112 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      IF CONTINUA="N"
         @ 46,112 SAY IF((NOTA->VALITOT_V+NOTA->VALMO_V)>0,TRANSFORM(NOTA->VALITOT_V+NOTA->VALMO_V,"@R 999,999,999.99")," ")
      ELSE
         @ 46,112 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      ENDIF
      @ 49,06  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->NOME_V,SPACE(50))
      @ 49,85  SAY NOTA->FRETE_V
      @ 49,91  SAY NOTA->PLACA_V
      @ 49,105 SAY NOTA->UF_V
      @ 49,112 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->CGC_V,SPACE(18))
      @ 51,06  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),30),SPACE(30))
      @ 51,67  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->CIDADE_V,30),SPACE(30))
      @ 51,105 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->ESTADO_V,30),SPACE(30))
      @ 51,112 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->INSEST_V,SPACE(15))
      @ 53,08  SAY IF(NOTA->QTD_V#0,TRANSFORM(NOTA->QTD_V,"@R 999,999.99"),SPACE(2))
      @ PROW(),PCOL() SAY CHR(18)
      IF CONTINUA="S"
         @ 00,PCOL() SAY CHR(18)+" "
         SET DEVICE TO SCREEN
         WINDOW(10,10,12,56)
         SETCOLOR(CORTIT)
         @ 9,10 SAY "Estouro de Itens o Sistema Requer Mais Uma Nota"
         SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
         DO WHILE NOTA->(DBSETORDER(1),DBSEEK(str(NOTA,6)+"0"))
            @ 11,12 SAY "N£mero da Nota Fiscal :" GET NOTA VALID(! NOTA->(DBSEEK(str(NOTA,6)+"0")))
            READ
            IF LASTKEY()=27
               AVISO(" necess rio digitar o n£mero da nota ...")
               LOOP
            ENDIF
         ENDDO
         LOOP
      ENDIF
      IF TECNICA->(RECLOCK())
         TECNICA->NOTA_V:=NOTA->CODIGO_V
         TECNICA->(DBUNLOCK())
      ENDIF
      EXIT
   ENDDO
   @ 0,PCOL() SAY CHR(18)+" "
   SET PRINTER TO
   SET DEVICE TO SCREEN
ELSEIF CONFIG->MODNF_V=="4" // GEO
   DO WHILE .T.
      MESSAGE:={,,,,,,,}
      CONTINUA:="N"
      if config->nfs_v=="S"
      else
         SET PRINTER TO LPT1
         SET DEVICE TO PRINTER
      endif
      @ PROW(),PCOL() SAY CHR(18)
      @ 1,53   SAY "X"
      @ 1,74   SAY STRZERO(NOTA->CODIGO_V,6)
      @ 6,5    SAY IF(CFOP->(DBSEEK(CFOP)),CFOP->MENSAGEM_V,SPACE(18))
      @ 6,30   SAY CFOP
      @ PROW(),PCOL() SAY CHR(15)
      @ 9,06   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
      @ 9,91   SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(19))
      @ 9,124  SAY DTOC(DATEMI)
      @ 11,06  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
      @ 11,77  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->BAIRRO_V,27),SPACE(27))
      @ 11,107 SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-999"),SPACE(8))
      @ 11,124 SAY DTOC(DATSAI)
      @ 13,06  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),LEFT(CLIFOR->CIDADE_V,25),SPACE(25))
      @ 13,81  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
      @ 13,55  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) ###99-9999"),SPACE(12))
      @ 13,91  SAY IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
      @ 13,124 SAY HORASAI
      Y:=1
      COL:=06
      DO WHILE .T.
         IF MDATE[Y]=(NIL)
            EXIT
         ENDIF
         @ 16,COL+4 SAY MDATE[Y]
         Y++
         COL:=COL+20
      ENDDO
      IF NOTA->(ADDREC(5))
         NOTA->CODIGO_V  :=NOTA
         NOTA->SERIE_V   := SERIE
         NOTA->CUPOM_V   :=CUPOM
         NOTA->FICHA_V   :=TECNICA->CODIGO_V
         NOTA->CLIFOR_V  :=TECNICA->CLIFOR_V
         NOTA->CODTRAN_V :=CODTRAN
         NOTA->CFOP_V    :=CFOP
         NOTA->DATEMI_V  :=DATEMI
         NOTA->HORAEMI_V :=HORAEMI
         NOTA->DATSAI_V  :=DATSAI
         NOTA->HORASAI_V :=HORASAI
         NOTA->FRETE_V   :=FRETE
         NOTA->PLACA_V   :=PLACA
         NOTA->UF_V      :=UF
         NOTA->QTD_V     :=QUANT
         NOTA->ESPECIE_V :=ESPECIE
         NOTA->MARCA_V   :=MARCA
         NOTA->NUMERO_V  :=NUMERO
         NOTA->PESOBRU_V :=PESOBRU
         NOTA->PESOLIQ_V :=PESOLIQ
         NOTA->NOMSEN_V  :=NOMSEN
         IF MDATE[1]#(NIL)
            NOTA->DATPAR1_V:=MDATE[1]
            NOTA->VALPAR1_V:=VALPAR[1]
         ENDIF
         IF MDATE[2]#(NIL)
            NOTA->DATPAR2_V:=MDATE[2]
            NOTA->VALPAR2_V:=VALPAR[2]
         ENDIF
         IF MDATE[3]#(NIL)
            NOTA->DATPAR3_V:=MDATE[3]
            NOTA->VALPAR3_V:=VALPAR[3]
         ENDIF
         IF MDATE[4]#(NIL)
            NOTA->DATPAR4_V:=MDATE[4]
            NOTA->VALPAR4_V:=VALPAR[4]
         ENDIF
         IF MDATE[5]#(NIL)
            NOTA->DATPAR5_V:=MDATE[5]
            NOTA->VALPAR5_V:=VALPAR[5]
         ENDIF
         NOTA->(DBUNLOCK())
      ENDIF
      Y:=0
      VALBASE:=0
      VALICMS:=0
      LIN:=20
      DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
         IF ESTOQUE->(DBSETORDER(1),DBSEEK(TECNICA2->ITEM_V)) .AND. ESTOQUE->SITTABB_V=2 .AND. BASCAL->(DBSETORDER(1),DBSEEK(CLIFOR->ESTADO_V))
            IF CLIFOR->PESSOA_V="J"
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCAL_V/100)
            ELSE
               VALBAS := (TECNICA2->VALUNI_V*TECNICA2->QTD_V)*(BASCAL->BASCALPF_V/100)
            ENDIF
            X:=1
            DO WHILE .T.
               IF MESSAGE[X]=(NIL)
                  MESSAGE[X]:=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               IF MESSAGE[X]=BASCAL->MENSAGEM_V
                  EXIT
               ENDIF
               X++
            ENDDO
         ELSE
            VALBAS=(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
         ENDIF
         VALBASE:=VALBASE+VALBAS
         IF CLIFOR->PESSOA_V="J"
            VALICMS:=VALICMS+((BASCAL->ICMS_V/100)*VALBAS)
         ELSE
            VALICMS:=VALICMS+((BASCAL->ICMSPF_V/100)*VALBAS)
         ENDIF
         @ LIN,06  SAY LEFT(TECNICA2->ITEM_V+" - "+IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->NOME_V,SPACE(12)),45)
         *@ LIN,81  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ALLTRIM(STR(ESTOQUE->SITTABA_V))+ALLTRIM(STR(ESTOQUE->SITTABB_V)),SPACE(2))
         @ LIN,86  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),ESTOQUE->UNIDADE_V,SPACE(2))
         @ LIN,90  SAY IF(TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->QTD_V,"99,999"),SPACE(6))
         @ LIN,97  SAY IF(TECNICA2->VALUNI_V>0,TRANSFORM(TECNICA2->VALUNI_V,"999,999,999.99"),SPACE(9))
         @ LIN,113 SAY IF(TECNICA2->VALUNI_V*TECNICA2->QTD_V>0,TRANSFORM(TECNICA2->VALUNI_V*TECNICA2->QTD_V,"999,999,999.99"),SPACE(9))
//         IF CLIFOR->PESSOA_V="J"
//            @ LIN,129 SAY IF(BASCAL->ICMS_V>0,TRANSFORM(BASCAL->ICMS_V,"@R 99.9999%"),SPACE(4))
//         ELSE
//            @ LIN,129 SAY IF(BASCAL->ICMSPF_V>0,TRANSFORM(BASCAL->ICMSPF_V,"@R 99.9999%"),SPACE(4))
//         ENDIF
         X:=1
         DO WHILE .T.
            IF MESSAGE[X]=(NIL)
               MESSAGE[X]:=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            IF MESSAGE[X]=TECNICA2->TBASCAL_V
               EXIT
            ENDIF
            X++
         ENDDO
         IF NOTA->(RECLOCK(5))
            NOTA->VALITOT_V:=NOTA->VALITOT_V+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
            NOTA->(DBUNLOCK())
         ENDIF
         TECNICA2->(DBSKIP())
         IF Y>=CONFIG->QTDITENS_V .AND. TECNICA2->CODIGO_V==TECNICA->CODIGO_V
            CONTINUA:="S"
            EXIT
         ENDIF
         Y++
         LIN++
      ENDDO
      IF !EMPTY(NOTA->OBSERVA1_V)
         @ 34,14 SAY NOTA->OBSERVA1_V
      ENDIF
      IF CONTINUA="N"
         IF NOTA->(RECLOCK())
            NOTA->LINSERV1_V:=LINSERV1
            NOTA->LINSERV2_V:=LINSERV2
            NOTA->LINSERV3_V:=LINSERV3
            NOTA->LINSERV4_V:=LINSERV4
            NOTA->VALMO_V   :=TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V
            NOTA->(DBUNLOCK())
         ENDIF
         @ 36.5,06 SAY LINSERV1
         @ 37.5,06 SAY LINSERV2
         @ 38.5,06 SAY LINSERV3
         IF (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100)>0
            @ 38.5,114 SAY (TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V)*(5/100) PICT "@R 999,999,999.99"
         ENDIF
         @ 39.5,06 SAY LINSERV4
         IF NOTA->VALMO_V>0
            @ 40.5,114 SAY NOTA->VALMO_V PICT "@R 999,999,999.99"
         ENDIF
      ENDIF
      @ 41,34  SAY CONFIG->NFCOMPL_V
//      @ 44,06  SAY IF(VALBASE>0,TRANSFORM(VALBASE,"@R 999,999,999.99")," ")
//      @ 44,32  SAY IF(VALICMS>0,TRANSFORM(VALICMS,"@R 999,999,999.99")," ")
      @ 44,112 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      IF CONTINUA="N"
         @ 46,112 SAY IF((NOTA->VALITOT_V+NOTA->VALMO_V)>0,TRANSFORM(NOTA->VALITOT_V+NOTA->VALMO_V,"@R 999,999,999.99")," ")
      ELSE
         @ 46,112 SAY IF(NOTA->VALITOT_V>0,TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")," ")
      ENDIF
      @ 49,06  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->NOME_V,SPACE(50))
      @ 49,85  SAY NOTA->FRETE_V
      @ 49,91  SAY NOTA->PLACA_V
      @ 49,105 SAY NOTA->UF_V
      @ 49,112 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->CGC_V,SPACE(18))
      @ 51,06  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),30),SPACE(30))
      @ 51,67  SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->CIDADE_V,30),SPACE(30))
      @ 51,105 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),LEFT(TRANSP->ESTADO_V,30),SPACE(30))
      @ 51,112 SAY IF(TRANSP->(DBSETORDER(1),DBSEEK(NOTA->CODTRAN_V)),TRANSP->INSEST_V,SPACE(15))
      @ 53,08  SAY IF(NOTA->QTD_V#0,TRANSFORM(NOTA->QTD_V,"@R 999,999.99"),SPACE(2))
      @ PROW(),PCOL() SAY CHR(18)
      IF CONTINUA="S"
         @ 00,PCOL() SAY CHR(18)+" "
         SET DEVICE TO SCREEN
         WINDOW(10,10,12,56)
         SETCOLOR(CORTIT)
         @ 9,10 SAY "Estouro de Itens o Sistema Requer Mais Uma Nota"
         SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
         DO WHILE NOTA->(DBSETORDER(1),DBSEEK(str(NOTA,6)+"0"))
            @ 11,12 SAY "N£mero da Nota Fiscal :" GET NOTA VALID(! NOTA->(DBSEEK(str(NOTA,6)+"0")))
            READ
            IF LASTKEY()=27
               AVISO(" necess rio digitar o n£mero da nota ...")
               LOOP
            ENDIF
         ENDDO
         LOOP
      ENDIF
      IF TECNICA->(RECLOCK())
         TECNICA->NOTA_V:=NOTA->CODIGO_V
         TECNICA->(DBUNLOCK())
      ENDIF
      EXIT
   ENDDO
   @ 0,PCOL() SAY CHR(18)+" "
   SET PRINTER TO
   SET DEVICE TO SCREEN
ENDIF
RETURN(.T.)

FUNCTION TCORPARCS(VALFRETE)
LOCAL I, FRETEPARC, RESTO,DIVIDIR
MEMVAR MDATE,VALPAR
MEMVAR CORTIT
DIVIDIR=.F.
IF DIVIDIR
   I := 0
   IF ! EMPTY(TECNICA->DATPAG_V)
      I++
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG1_V)
      I++
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG2_V)
      I++
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG3_V)
      I++
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG4_V)
      I++
   ENDIF
   FRETEPARC = VALFRETE / I
   FRETEPARC = ROUND(FRETEPARC,2)
   RESTO = VALFRETE - (FRETEPARC * I)
   IF ! EMPTY(TECNICA->DATPAG_V)
      @ 20,2 SAY DTOC(MDATE[1])
      @ 21,2 SAY TRANSFORM(VALPAR[1]+FRETEPARC+RESTO,"@R 999,999.99")
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG1_V)
      @ 20,14 SAY DTOC(MDATE[2])
      @ 21,14 SAY TRANSFORM(VALPAR[2]+FRETEPARC,"@R 999,999.99")
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG2_V)
      @ 20,26 SAY DTOC(MDATE[3])
      @ 21,26 SAY TRANSFORM(VALPAR[3]+FRETEPARC,"@R 999,999.99")
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG3_V)
      @ 20,38 SAY DTOC(MDATE[4])
      @ 21,38 SAY TRANSFORM(VALPAR[4]+FRETEPARC,"@R 999,999.99")
   ENDIF
   IF ! EMPTY(TECNICA->DATPAG4_V)
      @ 20,50 SAY DTOC(MDATE[5])
      @ 21,50 SAY TRANSFORM(VALPAR[5]+FRETEPARC,"@R 999,999.99")
   ENDIF
ELSE
   @ 21,2 SAY TRANSFORM(VALPAR[1]+VALFRETE,"@R 999,999.99")
ENDIF
@ 23,01 SAY PADL("Itens : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999,999.99")+"  Servi‡os : "+TRANSFORM(TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V,"@R 999,999,999.99")+"  Total : "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V+VALFRETE,"@R 999,999,999.99")+" ",78) COLOR CORTIT
RETURN .T.