FUNCTION MOVPED(TIPO)
LOCAL  GETLIST:={},TELA,TELA2,CONT,VARIAVEIS,MASCARAS,TITULOS,NOTACOM,X
LOCAL  COL,PARC,INTER,ENT,ENT2,TOTPAR,VALPAR,MDATE,DOCEXT,LINSERV1
LOCAL  LINSERV2,LINSERV3, LINSERV4,PAGREC,REGISTRAR
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
MEMVAR O_BASCAL,O_TBASCAL,TOTITE,CODPLA,VALMO,SYSVEN,BLQVEN
MEMVAR CODIGO,T,T2
TELA:=SAVESCREEN()
WINDOW(0,0,24,79)
DBF_CONFIG()
DBF_CLIFOR()
DBF_PEDIDO()
DBF_2PEDIDO()
DBF_ESTOQUE()
DBF_MECVEN()
DBF_PAGREC()
DBF_PLANO()
DBF_BASCAL()
DBF_PEDFAT()
T:=TIPO
T2:="V"
CODPLA  :=SPACE(LEN(PLANO->CODIGO_V))
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 1,1 CLEAR TO 23,78
   CODIGO:=SPACE(LEN(PEDIDO->CODIGO_V))
   @ 1,2 SAY "C¢digo      :" GET CODIGO VALID(SEA_PEDIDO(CODIGO,TIPO,IF(TIPO='V'.AND.BLQVEN='S',SYSVEN,NIL)))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF TIPO="V"
      IF PEDIDO->TIPO_V="P"
         @ 1,23 SAY "Pedido Cliente : "+PEDIDO->PEDCLI_V
      ELSE
         @ 1,23 SAY "Venda por Pedido "
      ENDIF
      @ 1,51 SAY "Vendedor : " + IF(MECVEN->(DBSEEK(PEDIDO->MECVEN_V)),LEFT(MECVEN->NOME_V,16),SPACE(16))
   ELSE
      IF PEDIDO->TIPO_V="P"
         @ 1,23 SAY "Compra por Pedido "
      ELSE
         @ 1,23 SAY "Compra Direta "
      ENDIF
      @ 1,41 say "NF:" + STR(PEDIDO->NOTACOM_V)
   ENDIF
   @ 5,2  SAY "Emissao     : " + DTOC(PEDIDO->DATEMI_V)+"             Baixa no Estoque : "+DTOC(PEDIDO->DATBAI_V)
   @ 2,2  SAY IF(TIPO="V","Cliente     : ","Fornecedor  : ") + IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),LEFT(CLIFOR->NOME_V,29),SPACE(29))
   @ 3,2  SAY "Endereco    : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
   @ 4,2  SAY "Cidade      : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->CIDADE_V,SPACE(30))
   @ 4,47 SAY "Estado   : "+ IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
   @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99")
   @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99")
   IF EMPTY(PEDIDO->DATCAN_V)
      IF ! EMPTY(PEDIDO->DATPAG_V)
         IF TIPO="V"
            @ 6,1  SAY PADC("Faturamento"+IF(!EMPTY(PEDIDO->NOTA_V)," NF."+ALLTRIM(STR(PEDIDO->NOTA_V)),""),78) COLOR CORTIT
         ELSE
            @ 6,1  SAY PADC("Faturamento"+IF(!EMPTY(PEDIDO->NOTACOM_V)," NF."+ALLTRIM(STR(PEDIDO->NOTACOM_V)),""),78) COLOR CORTIT
         ENDIF
         @ 7,2 SAY PEDIDO->DATPAG_V
         @ 8,2 SAY TRANSFORM(PEDIDO->VALPAR_V,"@R 999,999.99")
         IF ! EMPTY(PEDIDO->DATPAG1_V)
            @ 7,14 SAY PEDIDO->DATPAG1_V
            @ 8,14 SAY TRANSFORM(PEDIDO->VALPAR1_V,"@R 999,999.99")
         ENDIF
         IF ! EMPTY(PEDIDO->DATPAG2_V)
            @ 7,26 SAY PEDIDO->DATPAG2_V
            @ 8,26 SAY TRANSFORM(PEDIDO->VALPAR2_V,"@R 999,999.99")
         ENDIF
         IF ! EMPTY(PEDIDO->DATPAG3_V)
            @ 7,38 SAY PEDIDO->DATPAG3_V
            @ 8,38 SAY TRANSFORM(PEDIDO->VALPAR3_V,"@R 999,999.99")
         ENDIF
         IF ! EMPTY(PEDIDO->DATPAG4_V)
            @ 7,50 SAY PEDIDO->DATPAG4_V
            @ 8,50 SAY TRANSFORM(PEDIDO->VALPAR4_V,"@R 999,999.99")
         ENDIF
      ENDIF
   ELSE
      @ 6,1 SAY PADC("Pedido cancelado em "+DTOC(PEDIDO->DATCAN_V),78) COLOR CORTIT
   ENDIF
   IF ! EMPTY(PEDIDO->DATBAI_V)
      VARIAVEIS:={"IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->ITEM_V,SPACE(6))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->VALUNI_V,SPACE(8))","IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->QTD_V,SPACE(8))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->VALUNI_V*PEDIDO2->QTD_V,SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(LEFT(PEDIDO->CODIGO_V,1)=='V',IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),IF(BASCAL->(DBSEEK(STR(ESTOQUE->CODIMP_V,5)+CLIFOR->ESTADO_V)),BASCAL->ICMS_V,0),0),PEDIDO2->ICMS_V),SPACE(2))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->IPI_V,SPACE(2))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),ESTOQUE->VALVEN_V,0),SPACE(9))"}
      MASCARAS :={,,IF(T=T2,"@R 999,999.99","@R 999,999.9999"),"@R 999,999.99","@R 9,999,999.99","@R 99.9999 %","@R 99 %","@R 9,999,999.99"}
      TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","Qtd","Vl.Total","ICMS","IPI","Vl.Venda Estoque"}
   ELSE
      VARIAVEIS:={"IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->ITEM_V,SPACE(6))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->VALUNI_V,SPACE(8))","IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->QTD_V,SPACE(8))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->VALUNI_V*PEDIDO2->QTD_V,SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->ICMS_V,SPACE(2))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,PEDIDO2->IPI_V,SPACE(2))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),ESTOQUE->VALVEN_V,0),SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),ESTOQUE->QTD_V,0),SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),ESTOQUE->RESERVA_V,0),SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,0),SPACE(9))"}
      MASCARAS :={,,IF(T=T2,"@R 999,999.99","@R 999,999.9999"),"@R 999,999.99","@R 9,999,999.99","@R 99.9999 %","@R 99 %","@R 9,999,999.99","@R 9,999,999.99","@R 9,999,999.99","@R 9,999,999.99"}
      TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","Qtd","Vl.Total","ICMS","IPI","Vl.Venda Estoque","Qtd. em Estoque","Qtd. Reservado","Qtd.Real"}
   ENDIF
   DBSELECTAREA("PEDIDO2")
   COUNT TO TOTITE WHILE PEDIDO2->CODIGO_V==CODIGO
   PEDIDO2->(DBSETORDER(1))
   PEDIDO2->(DBSEEK(CODIGO))
   IF EMPTY(PEDIDO->DATBAI_V)
      @ 24,1  SAY PADR("INS:Inclui item DEL:Exclui item F2:Baixa Pe‡as  F5:Cancela Pedido F7:Imprime",78) COLOR CORTIT
   ELSE
      IF EMPTY(PEDIDO->DATPAG_V)
         @ 24,1  SAY PADR("INS:Inclui item DEL:Exclui item F2:Fechamento   F5:Cancela Pedido F7:Imprime",78) COLOR CORTIT
      ELSE
         @ 24,1  SAY PADR("INS:Inclui item DEL:Exclui item F2:Canc.Fecto.  F5:Cancela Pedido F7:Imprime",78) COLOR CORTIT
      ENDIF
   ENDIF
   SETCOLOR(CORDES+","+CORBAR+",,,"+CORDES)
   PEDIDO2->(DBEDIT(IF(EMPTY(PEDIDO->DATPAG_V),7,9),1,23,78,VARIAVEIS,"DBEBAIPED",MASCARAS,TITULOS,CHR(220),CHR(219)))
   DO CASE
      CASE LASTKEY()=27
         LOOP
      CASE LASTKEY()=-1
         IF !EMPTY(PEDIDO->DATCAN_V)
            AVISO("Pedido cancelado...")
            LOOP
         ENDIF
         IF EMPTY(PEDIDO->DATBAI_V)
            IF ! CONFIRMA(20,20,"Deseja dar baixa neste pedido ?")
               LOOP
            ENDIF
            PEDIDO2->(DBGOTOP())
            PEDIDO2->(DBSEEK(CODIGO))
///VERIFICACAO NO ESTOQUE
/*
            IF TIPO="V"
               CONT:=.T.
               DO WHILE PEDIDO2->CODIGO_V=PEDIDO->CODIGO_V .AND. PEDIDO2->(! EOF())
                  IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                     IF PEDIDO2->QTD_V>ESTOQUE->QTD_V
                        CONT:=.F.
                        EXIT
                     ENDIF
                  ELSE
                     CONT:=.F.
                     EXIT
                  ENDIF
                  PEDIDO2->(DBSKIP())
               ENDDO
               IF CONT=.F.
                  AVISO("Imposs¡vel baixar o pedido, encontrado item em falta no estoque...")
                  LOOP
               ENDIF
            ENDIF
*/
            IF PEDIDO->(RECLOCK())
               PEDIDO->DATBAI_V :=DATE()
               PEDIDO->(DBUNLOCK())
               IF CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)) .AND. CLIFOR->(RECLOCK(5))
                  CLIFOR->DATPED_V:=DATE()
                  CLIFOR->ULTPED_V:=PEDIDO->CODIGO_V
                  CLIFOR->(DBUNLOCK())
               ENDIF
            ENDIF
///BAIXA
            PEDIDO2->(DBGOTOP())
            PEDIDO2->(DBSEEK(CODIGO))
            DO WHILE PEDIDO2->CODIGO_V=PEDIDO->CODIGO_V .AND. PEDIDO2->(! EOF())
               IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                  IF ESTOQUE->(RECLOCK())
                     IF TIPO="V"
                        ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V-PEDIDO2->QTD_V
                        movest("S",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
                     ELSE
                        movest("E",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v, pedido2->valuni_v)
                     ENDIF
                     ESTOQUE->(DBUNLOCK())
                  ENDIF
               ENDIF
               PEDIDO2->(DBSKIP())
            ENDDO
         ELSE
            IF EMPTY(PEDIDO->DATPAG_V)
               IF TIPO = "V"
                  PEDVIMP(PEDIDO->CODIGO_V,.F.)
               ENDIF
               SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
               @ 6,1 CLEAR TO 23,78
               LINSERV1:=PEDIDO->LINSERV1_V
               LINSERV2:=PEDIDO->LINSERV2_V
               LINSERV3:=PEDIDO->LINSERV3_V
               LINSERV4:=PEDIDO->LINSERV4_V
               VALMO   :=PEDIDO->VALMO_V
               NOTACOM :=0
               DO WHILE .T.
                  @ 6,1 TO 6,78
                  @ 7,1 SAY PADC("Fechamento do Pedido",78) COLOR CORTIT
                  @ 8,1 TO 8,78
                  @ 09,2 SAY "Valor dos Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99")
                  IF TIPO="C"
                     @ 09,33 SAY "Valor IPI   : "+TRANSFORM(PEDIDO->VALIPI_V,"@R 999,999.99")
                  ENDIF
                  @ 10,33 SAY "Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+VALMO+PEDIDO->VALIPI_V,"@R 999,999.99")
                  @ 10,2 SAY "Mao de Obra     :" GET VALMO PICT "@R 999,999.99" VALID(MOVPED1())
                  @ 11,2 GET LINSERV1 PICT "@!"
                  @ 12,2 GET LINSERV2 PICT "@!"
                  @ 13,2 GET LINSERV3 PICT "@!"
                  @ 14,2 GET LINSERV4 PICT "@!"
                  @ 15,1 SAY PADC("Faturamento",78) COLOR CORTIT
                  IF TIPO="C"
                     @ 16,02 SAY "NF do Fonecedor:" GET NOTACOM PICT "99999999"
                  ENDIF
                  @ 17,02 SAY "Plano de Conta :" GET CODPLA VALID(SEA_CODPLA(CODPLA,17,24,IF(TIPO="V","+","-")))
                  PARC:=0
                  INTER:=0
                  ENT:=SPACE(1)
                  @ 18,2  SAY "Parcelas   :" GET PARC PICT "9" VALID(PARC>0 .AND. PARC<=5)
                  @ 18,18 SAY "Intervalo de Dias :" GET INTER PICT "99" VALID(IF(PARC>1,INTER>0,INTER>=0))
                  @ 18,43 SAY "1¦ Parc. … Vista ? :" GET ENT PICT "@!" VALID(LASTKEY()=5 .OR. ENT$"SN")
                  @ 19,02 SAY "Vencimento         :"
                  @ 20,02 SAY "Valor da Parcela   :"
                  @ 21,02 SAY "Doc.Ext.da Parcela :"
                  READ
                  IF LASTKEY()=27
                     EXIT
                  ENDIF
                  X:=1
                  ENT2:=ENT
                  TOTPAR:=0
                  MDATE   :={,,,,,}
                  VALPAR  :={,,,,,}
                  DOCEXT  :={,,,,,}
                  DO WHILE X<=PARC
                     IF ENT2="S"
                        MDATE[X]=DATE()
                        ENT2:="N"
                     ELSE
                        IF X>1
                           MDATE[X]=MDATE[X-1]+INTER
                        ELSE
                           MDATE[X]=DATE()+INTER
                        ENDIF
                     ENDIF
                     X++
                  ENDDO
                  X:=1
                  COL:=23
                  SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
                  DO WHILE .T.
                     IF MDATE[X]=(NIL)
                        EXIT
                     ENDIF
                     VALPAR[X]:=ROUND((PEDIDO->VALTOT_V+VALMO+PEDIDO->VALIPI_V)/(PARC),2)
                     DOCEXT[X]:=IF(EMPTY(NOTACOM),SPACE(LEN(PAGREC->DOCEXT_V)),SPACE(10-LEN("NF."+ALLTRIM(STR(NOTACOM))))+"NF."+ALLTRIM(STR(NOTACOM)))
                     @ 19,COL GET MDATE[X]
                     @ 20,COL GET VALPAR[X] PICT "@R 999,999.99"
                     @ 21,COL GET DOCEXT[X]
                     READ
                     IF LASTKEY()=27
                        @ 20,1 CLEAR TO 21,78
                        EXIT
                     ENDIF
                     TOTPAR:=TOTPAR+VALPAR[X]
                     X++
                     COL=COL+11
                  ENDDO
                  IF LASTKEY()=27
                     LOOP
                  ENDIF
                  IF ROUND(TOTPAR,2)#ROUND(PEDIDO->VALTOT_V+VALMO+PEDIDO->VALIPI_V,2) .AND. PEDIDO->VALTOT_V+VALMO+PEDIDO->VALIPI_V#TOTPAR
                     AVISO("O Valor Total das Parcelas nao Conferem com o Valor Total do Pedido ...")
                     LOOP
                  ENDIF
                  IF ! CONFIRMA(20,20,"Confirma todos os Dados ?")
                     LOOP
                  ENDIF
                  IF TIPO="V"
                     IF CONFIG->AUTVEN_V="P" .and. config->tipaut_v=='P'
                        IF CONFIRMA(20,20,"Registrar Contas Futuras ?")
                           REGISTRAR:="S"
                        ELSE
                           REGISTRAR:="N"
                        ENDIF
                     ELSE
                        REGISTRAR:=if(config->autven_v=='S' .and. config->tipaut_v=='P', 'S', 'N')
                     ENDIF
	             		PEDVIMP(PEDIDO->CODIGO_V,.T.)
                  ELSE
                     IF CONFIG->AUTCOM_V="P"
                        IF CONFIRMA(20,20,"Registrar Contas Futuras ?")
                           REGISTRAR:="S"
                        ELSE
                           REGISTRAR:="N"
                        ENDIF
                     ELSE
                        REGISTRAR:=CONFIG->AUTCOM_V
                     ENDIF
                  ENDIF
                  PEDIDO->(RECLOCK(5))
                  IF TIPO = "C"
                     PEDIDO->NOTACOM_V := NOTACOM
                  ENDIF
                  PEDIDO->VALMO_V   :=VALMO
                  PEDIDO->LINSERV1_V:=LINSERV1
                  PEDIDO->LINSERV2_V:=LINSERV2
                  PEDIDO->LINSERV3_V:=LINSERV3
                  PEDIDO->LINSERV4_V:=LINSERV4
                  IF MDATE[1]#(NIL)
                     PEDIDO->DATPAG_V:=MDATE[1]
                     PEDIDO->VALPAR_V:=VALPAR[1]
                     PEDIDO->DOCEXT_V:=DOCEXT[1]
                     PAGREC := ""
                     IF REGISTRAR="S"
                        PAGREC->(ADDREC(5))
                        CONFIG->(RECLOCK())
                        IF TIPO="V"
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ELSE
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ENDIF
                        CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
                        CONFIG->(DBUNLOCK())
                        PEDIDO->PAGREC_V:=PAGREC
                        PAGREC->CODIGO_V:=PAGREC
                        PAGREC->CLIFOR_V:=PEDIDO->CLIFOR_V
                        PAGREC->CODPLA_V:=CODPLA
                        PAGREC->PEDIDO_V:=PEDIDO->CODIGO_V
                        PAGREC->VALOR_V :=VALPAR[1]
                        PAGREC->DATVEN_V:=MDATE[1]
                        PAGREC->DOCEXT_V:=DOCEXT[1]
                        PAGREC->DATEXT_V :=DATE()
                        IF TIPO="V"
                           PAGREC->DESC_V  :="Venda por Pedido "+PEDIDO->CODIGO_V
                        ELSE
                           PAGREC->DESC_V  :="Compra por Pedido "+PEDIDO->CODIGO_V
                        ENDIF
                        PAGREC->(DBUNLOCK())
                     ENDIF
                     pedfat->(addrec(5))
                     pedfat->id_v := lastid("pedfat")
                     pedfat->codigo_v := pedido->codigo_v
                     pedfat->datemi_v := pedido->datemi_v
                     pedfat->dtparc_v := MDATE[1]
                     pedfat->vrparc_v := VALPAR[1]
                     pedfat->docext_v := DOCEXT[1]
                     pedfat->pagrec_v := PAGREC
                     pedfat->(dbcommit(), dbunlock())
                  ENDIF
                  IF MDATE[2]#(NIL)
                     PEDIDO->DATPAG1_V:=MDATE[2]
                     PEDIDO->VALPAR1_V:=VALPAR[2]
                     PEDIDO->DOCEXT1_V:=DOCEXT[2]
                     pagrec := ""
                     IF REGISTRAR="S"
                        PAGREC->(ADDREC(5))
                        CONFIG->(RECLOCK())
                        IF TIPO="V"
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ELSE
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ENDIF
                        CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
                        CONFIG->(DBUNLOCK())
                        PEDIDO->PAGREC1_V:=PAGREC
                        PAGREC->CODIGO_V :=PAGREC
                        PAGREC->CLIFOR_V :=PEDIDO->CLIFOR_V
                        PAGREC->CODPLA_V :=CODPLA
                        PAGREC->PEDIDO_V :=PEDIDO->CODIGO_V
                        PAGREC->VALOR_V  :=VALPAR[2]
                        PAGREC->DATVEN_V :=MDATE[2]
                        PAGREC->DOCEXT_V :=DOCEXT[2]
                        PAGREC->DATEXT_V :=DATE()
                        IF TIPO="V"
                           PAGREC->DESC_V  :="Venda por Pedido "+PEDIDO->CODIGO_V
                        ELSE
                           PAGREC->DESC_V  :="Compra por Pedido "+PEDIDO->CODIGO_V
                        ENDIF
                        PAGREC->(DBUNLOCK())
                     ENDIF
                     pedfat->(addrec(5))
                     pedfat->id_v := lastid("pedfat")
                     pedfat->codigo_v := pedido->codigo_v
                     pedfat->datemi_v := pedido->datemi_v
                     pedfat->dtparc_v := MDATE[2]
                     pedfat->vrparc_v := VALPAR[2]
                     pedfat->docext_v := DOCEXT[2]
                     pedfat->pagrec_v := PAGREC
                     pedfat->(dbcommit(), dbunlock())
                  ENDIF
                  IF MDATE[3]#(NIL)
                     PEDIDO->DATPAG2_V:=MDATE[3]
                     PEDIDO->VALPAR2_V:=VALPAR[3]
                     PEDIDO->DOCEXT2_V:=DOCEXT[3]
                     pagrec := ""
                     IF REGISTRAR="S"
                        PAGREC->(ADDREC(5))
                        CONFIG->(RECLOCK())
                        IF TIPO="V"
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ELSE
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ENDIF
                        CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
                        CONFIG->(DBUNLOCK())
                        PEDIDO->PAGREC2_V:=PAGREC
                        PAGREC->CODIGO_V :=PAGREC
                        PAGREC->CLIFOR_V :=PEDIDO->CLIFOR_V
                        PAGREC->CODPLA_V :=CODPLA
                        PAGREC->PEDIDO_V :=PEDIDO->CODIGO_V
                        PAGREC->VALOR_V  :=VALPAR[3]
                        PAGREC->DATVEN_V :=MDATE[3]
                        PAGREC->DOCEXT_V :=DOCEXT[3]
                        PAGREC->DATEXT_V :=DATE()
                        IF TIPO="V"
                           PAGREC->DESC_V  :="Venda por Pedido "+PEDIDO->CODIGO_V
                        ELSE
                           PAGREC->DESC_V  :="Compra por Pedido "+PEDIDO->CODIGO_V
                        ENDIF
                        PAGREC->(DBUNLOCK())
                     ENDIF
                     pedfat->(addrec(5))
                     pedfat->id_v := lastid("pedfat")
                     pedfat->codigo_v := pedido->codigo_v
                     pedfat->datemi_v := pedido->datemi_v
                     pedfat->dtparc_v := MDATE[3]
                     pedfat->vrparc_v := VALPAR[3]
                     pedfat->docext_v := DOCEXT[3]
                     pedfat->pagrec_v := PAGREC
                     pedfat->(dbcommit(), dbunlock())
                  ENDIF
                  IF MDATE[4]#(NIL)
                     PEDIDO->DATPAG3_V:=MDATE[4]
                     PEDIDO->VALPAR3_V:=VALPAR[4]
                     PEDIDO->DOCEXT3_V:=DOCEXT[4]
                     pagrec := ""
                     IF REGISTRAR="S"
                        PAGREC->(ADDREC(5))
                        CONFIG->(RECLOCK())
                        IF TIPO="V"
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ELSE
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ENDIF
                        CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
                        CONFIG->(DBUNLOCK())
                        PEDIDO->PAGREC3_V:=PAGREC
                        PAGREC->CODIGO_V :=PAGREC
                        PAGREC->CLIFOR_V :=PEDIDO->CLIFOR_V
                        PAGREC->CODPLA_V :=CODPLA
                        PAGREC->PEDIDO_V :=PEDIDO->CODIGO_V
                        PAGREC->VALOR_V  :=VALPAR[4]
                        PAGREC->DATVEN_V :=MDATE[4]
                        PAGREC->DOCEXT_V :=DOCEXT[4]
                        PAGREC->DATEXT_V :=DATE()
                        IF TIPO="V"
                           PAGREC->DESC_V  :="Venda por Pedido "+PEDIDO->CODIGO_V
                        ELSE
                           PAGREC->DESC_V  :="Compra por Pedido "+PEDIDO->CODIGO_V
                        ENDIF
                        PAGREC->(DBUNLOCK())
                     ENDIF
                     pedfat->(addrec(5))
                     pedfat->id_v := lastid("pedfat")
                     pedfat->codigo_v := pedido->codigo_v
                     pedfat->datemi_v := pedido->datemi_v
                     pedfat->dtparc_v := MDATE[4]
                     pedfat->vrparc_v := VALPAR[4]
                     pedfat->docext_v := DOCEXT[4]
                     pedfat->pagrec_v := PAGREC
                     pedfat->(dbcommit(), dbunlock())
                  ENDIF
                  IF MDATE[5]#(NIL)
                     PEDIDO->DATPAG4_V:=MDATE[5]
                     PEDIDO->VALPAR4_V:=VALPAR[5]
                     PEDIDO->DOCEXT4_V:=DOCEXT[5]
                     pagrec := ""
                     IF REGISTRAR="S"
                        PAGREC->(ADDREC(5))
                        CONFIG->(RECLOCK())
                        IF TIPO="V"
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ELSE
                           PAGREC:="R"+STRZERO(CONFIG->PAGREC_V+1,5,0)
                        ENDIF
                        CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
                        CONFIG->(DBUNLOCK())
                        PEDIDO->PAGREC4_V:=PAGREC
                        PAGREC->CODIGO_V :=PAGREC
                        PAGREC->CLIFOR_V :=PEDIDO->CLIFOR_V
                        PAGREC->CODPLA_V :=CODPLA
                        PAGREC->PEDIDO_V :=PEDIDO->CODIGO_V
                        PAGREC->VALOR_V  :=VALPAR[5]
                        PAGREC->DATVEN_V :=MDATE[5]
                        PAGREC->DOCEXT_V :=DOCEXT[5]
                        PAGREC->DATEXT_V :=DATE()
                        IF TIPO="V"
                           PAGREC->DESC_V  :="Venda por Pedido "+PEDIDO->CODIGO_V
                        ELSE
                           PAGREC->DESC_V  :="Compra por Pedido "+PEDIDO->CODIGO_V
                        ENDIF
                        PAGREC->(DBUNLOCK())
                     ENDIF
                     pedfat->(addrec(5))
                     pedfat->id_v := lastid("pedfat")
                     pedfat->codigo_v := pedido->codigo_v
                     pedfat->datemi_v := pedido->datemi_v
                     pedfat->dtparc_v := MDATE[5]
                     pedfat->vrparc_v := VALPAR[5]
                     pedfat->docext_v := DOCEXT[5]
                     pedfat->pagrec_v := PAGREC
                     pedfat->(dbcommit(), dbunlock())
                  ENDIF
                  PEDIDO->(DBUNLOCK())
                  EXIT
               ENDDO
            ELSE
               IF .NOT. CONFIRMA(20,20,"Cancelar Fechamento ?")
                  LOOP
               ENDIF
               IF ! EMPTY(PEDIDO->PAGREC_V)
                  IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC_V))
                     IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG_V)+" nao encontrada, continuar ?")
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               IF ! EMPTY(PEDIDO->PAGREC1_V)
                  IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC1_V))
                     IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG1_V)+" nao encontrada, continuar ?")
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               IF ! EMPTY(PEDIDO->PAGREC2_V)
                  IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC2_V))
                     IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG2_V)+" nao encontrada, continuar ?")
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               IF ! EMPTY(PEDIDO->PAGREC3_V)
                  IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC3_V))
                     IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG3_V)+" nao encontrada, continuar ?")
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               IF ! EMPTY(PEDIDO->PAGREC4_V)
                  IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC4_V))
                     IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG4_V)+" nao encontrada, continuar ?")
                        LOOP
                     ENDIF
                  ENDIF
               ENDIF
               IF PAGREC->(DBSEEK(PEDIDO->PAGREC_V))
                  PAGREC->(RECLOCK(5))
                  PAGREC->(DBDELETE())
                  PAGREC->(DBUNLOCK())
               ENDIF
               IF PAGREC->(DBSEEK(PEDIDO->PAGREC1_V))
                  PAGREC->(RECLOCK(5))
                  PAGREC->(DBDELETE())
                  PAGREC->(DBUNLOCK())
               ENDIF
               IF PAGREC->(DBSEEK(PEDIDO->PAGREC2_V))
                  PAGREC->(RECLOCK(5))
                  PAGREC->(DBDELETE())
                  PAGREC->(DBUNLOCK())
               ENDIF
               IF PAGREC->(DBSEEK(PEDIDO->PAGREC3_V))
                  PAGREC->(RECLOCK(5))
                  PAGREC->(DBDELETE())
                  PAGREC->(DBUNLOCK())
               ENDIF
               IF PAGREC->(DBSEEK(PEDIDO->PAGREC4_V))
                  PAGREC->(RECLOCK(5))
                  PAGREC->(DBDELETE())
                  PAGREC->(DBUNLOCK())
               ENDIF
               pedfat->(dbsetorder(2), dbseek(pedido->codigo_v))
			         do while !pedfat->(eof()) .and. pedfat->codigo_v == pedido->codigo_v
			            pedfat->(reclock(5))
			            pedfat->(dbdelete(), dbcommit(), dbunlock())
			            pedfat->(dbskip())
			         enddo
               IF PEDIDO->(RECLOCK(5))
                  PEDIDO->DATPAG_V:=CTOD("  /  /    ")
                  PEDIDO->DATPAG1_V:=CTOD("  /  /    ")
                  PEDIDO->DATPAG2_V:=CTOD("  /  /    ")
                  PEDIDO->DATPAG3_V:=CTOD("  /  /    ")
                  PEDIDO->DATPAG4_V:=CTOD("  /  /    ")
                  PEDIDO->VALPAR_V:=0
                  PEDIDO->VALPAR1_V:=0
                  PEDIDO->VALPAR2_V:=0
                  PEDIDO->VALPAR3_V:=0
                  PEDIDO->VALPAR4_V:=0
                  PEDIDO->DOCEXT_V :=SPACE(LEN(PEDIDO->DOCEXT_V))
                  PEDIDO->DOCEXT1_V :=SPACE(LEN(PEDIDO->DOCEXT1_V))
                  PEDIDO->DOCEXT2_V :=SPACE(LEN(PEDIDO->DOCEXT2_V))
                  PEDIDO->DOCEXT3_V :=SPACE(LEN(PEDIDO->DOCEXT3_V))
                  PEDIDO->DOCEXT4_V :=SPACE(LEN(PEDIDO->DOCEXT4_V))
                  PEDIDO->(DBUNLOCK())
               ENDIF
            ENDIF
         ENDIF
      CASE LASTKEY()=-4
         IF ! EMPTY(PEDIDO->NOTA_V)
            AVISO("Imposs¡vel cancelar pedido com nota fiscal j  emitida...")
            LOOP
         ENDIF
         IF ! EMPTY(PEDIDO->DATCAN_V)
            AVISO("Pedido j  cancelado...")
            LOOP
         ENDIF
         IF ! CONFIRMA(20,20,"Deseja realmente cancelar este pedido ?")
            RESTSCREEN(,,,,TELA2)
            LOOP
         ENDIF
         IF ! EMPTY(PEDIDO->PAGREC_V)
            IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC_V))
               IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG_V)+" nao encontrada, continuar ?")
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF ! EMPTY(PEDIDO->PAGREC1_V)
            IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC1_V))
               IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG1_V)+" nao encontrada, continuar ?")
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF ! EMPTY(PEDIDO->PAGREC2_V)
            IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC2_V))
               IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG2_V)+" nao encontrada, continuar ?")
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF ! EMPTY(PEDIDO->PAGREC3_V)
            IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC3_V))
               IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG3_V)+" nao encontrada, continuar ?")
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF ! EMPTY(PEDIDO->PAGREC4_V)
            IF ! PAGREC->(DBSEEK(PEDIDO->PAGREC4_V))
               IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(PEDIDO->DATPAG4_V)+" nao encontrada, continuar ?")
                  LOOP
               ENDIF
            ENDIF
         ENDIF
         IF PAGREC->(DBSEEK(PEDIDO->PAGREC_V))
            PAGREC->(RECLOCK(5))
            PAGREC->(DBDELETE())
            PAGREC->(DBUNLOCK())
         ENDIF
         IF PAGREC->(DBSEEK(PEDIDO->PAGREC1_V))
            PAGREC->(RECLOCK(5))
            PAGREC->(DBDELETE())
            PAGREC->(DBUNLOCK())
         ENDIF
         IF PAGREC->(DBSEEK(PEDIDO->PAGREC2_V))
            PAGREC->(RECLOCK(5))
            PAGREC->(DBDELETE())
            PAGREC->(DBUNLOCK())
         ENDIF
         IF PAGREC->(DBSEEK(PEDIDO->PAGREC3_V))
            PAGREC->(RECLOCK(5))
            PAGREC->(DBDELETE())
            PAGREC->(DBUNLOCK())
         ENDIF
         IF PAGREC->(DBSEEK(PEDIDO->PAGREC4_V))
            PAGREC->(RECLOCK(5))
            PAGREC->(DBDELETE())
            PAGREC->(DBUNLOCK())
         ENDIF
         IF PEDIDO2->(DBSEEK(CODIGO))
            IF PEDIDO2->(ARQLOCK())
               PEDIDO2->(DBSEEK(CODIGO))
               DO WHILE PEDIDO2->CODIGO_V==CODIGO
                  IF EMPTY(PEDIDO->DATBAI_V)
                     IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                        IF TIPO="V"
                           IF ESTOQUE->(RECLOCK())
                              ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V-PEDIDO2->QTD_V
                           ENDIF
                        ENDIF
                     ENDIF
                     ESTOQUE->(DBUNLOCK())
                     PEDIDO2->(DBDELETE())
                     PEDIDO2->(DBSKIP())
                  ELSE
                     IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                        IF TIPO="V"
                           movest("E",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
                        ELSE
                           movest("S",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v)
                        ENDIF
                     ENDIF
                     ESTOQUE->(DBUNLOCK())
                     PEDIDO2->(DBSKIP())
                  ENDIF
               ENDDO
               PEDIDO2->(DBUNLOCK())
            ENDIF
         ENDIF
         IF PEDIDO->(RECLOCK())
            PEDIDO->DATCAN_V:=DATE()
            PEDIDO->(DBUNLOCK())
         ENDIF
   ENDCASE
   PEDIDO2->(DBCLEARFILTER())
ENDDO
PEDFAT->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PEDIDO->(DBCLOSEAREA())
PEDIDO2->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
MECVEN->(DBCLOSEAREA())
PAGREC->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
BASCAL->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,24,79)
RETURN(.T.)

FUNCTION DBEBAIPED(nMode,Col)
LOCAL TELA
LOCAL GETLIST:={}
LOCAL TECLA:=LASTKEY()
LOCAL VALOR:=1
LOCAL VAL:=0
MEMVAR CORDES,CORTEX,CORTIT
MEMVAR ITEM,T_VALUNI,T_QTD,T_BASCAL,T_TBASCAL,O_BASCAL,O_TBASCAL,T_ICMS
MEMVAR CODIGO,T,TOTITE,T_IPI
ITEM     :=SPACE(LEN(ESTOQUE->CODIGO_V))
T_VALUNI :=0
T_QTD    :=0
T_BASCAL :=0
T_ICMS   :=CONFIG->DEFICMS_V
T_IPI    :=0
T_TBASCAL:=""
DO CASE
   CASE nMode=0
*      @ 9,1 SAY " C¢digo        Descri‡ao            Vl.Unit rio Qtd.         Vl.Total   %ICMS " COLOR CORTIT
   CASE nMode=4
      DO CASE
         CASE TECLA=13
            IF !EMPTY(PEDIDO->DATCAN_V)
               AVISO("Pedido cancelado...")
               RETURN VALOR
            ENDIF
            IF PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V
               IF EMPTY(PEDIDO->NOTA_V) .AND. EMPTY(PEDIDO->DATPAG_V)
                  SETCURSOR(1)
                  DO CASE
                     CASE Col=3
                        IF PEDIDO2->(RECLOCK()) .AND. PEDIDO->(RECLOCK())
                           VAL:=PEDIDO2->VALUNI_V
                           IF T="V"
                              @ ROW(),COL() GET PEDIDO2->VALUNI_V PICT "@R 999,999.99" VALID PRECOVALID(PEDIDO2->VALUNI_V,'A')
                           ELSE
                              @ ROW(),COL() GET PEDIDO2->VALUNI_V PICT "@R 999,999.9999"
                           ENDIF
                           READ
                           IF T="V"
                              PEDIDO->VALTOT_V:=(PEDIDO->VALTOT_V-(VAL*PEDIDO2->QTD_V))+(PEDIDO2->VALUNI_V*PEDIDO2->QTD_V)
                           ELSE
                              PEDIDO->VALTOT_V:=(PEDIDO->VALTOT_V-ROUND((VAL*PEDIDO2->QTD_V)*(1+(PEDIDO2->IPI_V/100)),2)+ROUND((PEDIDO2->VALUNI_V*PEDIDO2->QTD_V)*(1+(PEDIDO2->IPI_V/100)),2))
                           ENDIF
                           PEDIDO->(DBUNLOCK())
                           @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99") COLOR CORTEX
                           @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99") COLOR CORTEX
                        ELSE
                           AVISO("O Sistema nao conseguiu travar o registro...")
                        ENDIF
                     CASE Col=4
                        IF PEDIDO2->(RECLOCK()) .AND. PEDIDO->(RECLOCK()) .AND. ESTOQUE->(RECLOCK())
                           VAL:=PEDIDO2->QTD_V
                           @ ROW(),COL() GET PEDIDO2->QTD_V PICT "@R 999,999.99"
                           READ
                           IF T="V"
                              IF ! EMPTY(PEDIDO->DATBAI_V)
                                 IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                                    movest("E",pedido2->item_v, "VM", val, pedido2->codigo_v)
                                    movest("S",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
                                 ENDIF
                              ELSE
                                 IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                                    ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V-VAL
                                    ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V+PEDIDO2->QTD_V
                                 ENDIF
                              ENDIF
                              PEDIDO->VALCUS_V:=(PEDIDO->VALCUS_V-(PEDIDO2->VALCUS_V*VAL)+(PEDIDO2->VALCUS_V*PEDIDO2->QTD_V))
                              PEDIDO->VALMIN_V:=(PEDIDO->VALMIN_V-(PEDIDO2->VALMIN_V*VAL)+(PEDIDO2->VALMIN_V*PEDIDO2->QTD_V))
                              PEDIDO->VALMED_V:=(PEDIDO->VALMED_V-(PEDIDO2->VALMED_V*VAL)+(PEDIDO2->VALMED_V*PEDIDO2->QTD_V))
                              PEDIDO->VALMAX_V:=(PEDIDO->VALMAX_V-(PEDIDO2->VALMAX_V*VAL)+(PEDIDO2->VALMAX_V*PEDIDO2->QTD_V))
                              PEDIDO->VALTOT_V:=(PEDIDO->VALTOT_V-(PEDIDO2->VALUNI_V*VAL)+(PEDIDO2->VALUNI_V*PEDIDO2->QTD_V))
                           ELSE
                              IF ! EMPTY(PEDIDO->DATBAI_V)
                                 IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                                    movest("S",pedido2->item_v, "CM", val, pedido2->codigo_v)
                                    movest("E",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v)
                                 ENDIF
                              ENDIF
                              PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V-ROUND((PEDIDO2->VALUNI_V*VAL)*(1+(PEDIDO2->IPI_V/100)),2)+ROUND((PEDIDO2->VALUNI_V*PEDIDO2->QTD_V)*(1+(PEDIDO2->IPI_V/100)),2)
                           ENDIF
                           ESTOQUE->(DBUNLOCK())
                           PEDIDO->(DBUNLOCK())
                           @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99") COLOR CORTEX
                           @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99") COLOR CORTEX
                        ELSE
                           AVISO("O Sistema nao conseguiu travar o registro...")
                        ENDIF
                     CASE Col=6
                        IF LEFT(PEDIDO->CODIGO_V,1)=="V"
                           AVISO("O sistema utiliza o grupo de impostos para definir o ICMS.")
                        ELSE
                           IF PEDIDO2->(RECLOCK())
                              @ ROW(),COL() GET PEDIDO2->ICMS_V PICT "@R 99.9999 %"
                              READ
                           ELSE
                              AVISO("O Sistema nao conseguiu travar o registro...")
                           ENDIF
                        ENDIF
                     CASE Col=7
                        IF PEDIDO2->(RECLOCK()) .AND. PEDIDO->(RECLOCK())
                           VAL:=PEDIDO2->IPI_V
                           IF T="C"
                              @ ROW(),COL() GET PEDIDO2->IPI_V PICT "@R 99 %"
                           ELSE
                              AVISO("O Sistema nao utiliza ipi em vendas")
                           ENDIF
                           READ
                           IF T="C"
                              PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V-ROUND((PEDIDO2->VALUNI_V*PEDIDO2->QTD_V)*(1+(VAL/100)),2)+ROUND((PEDIDO2->VALUNI_V*PEDIDO2->QTD_V)*(1+(PEDIDO2->IPI_V/100)),2)
                           ENDIF
                           PEDIDO->(DBUNLOCK())
                           @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99") COLOR CORTEX
                           @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99") COLOR CORTEX
                        ELSE
                           AVISO("O Sistema nao conseguiu travar o registro...")
                        ENDIF
                  ENDCASE
                  SETCURSOR(0)
               ELSE
                  AVISO("Imposs¡vel alterar itens pedido j  fechado...")
               ENDIF
            ELSE
               PEDIDO2->(DBSEEK(PEDIDO->CODIGO_V))
            ENDIF
         CASE TECLA=27 .OR. TECLA=-1 .OR. TECLA=-4
            VALOR:=0
         CASE TECLA=-6
            IF CONFIRMA(20,20,"A impressora est  preparada ?")
               IMPPEDIDO(CODIGO)
            ENDIF
         CASE TECLA=7
            IF !EMPTY(PEDIDO->DATCAN_V)
               AVISO("Pedido cancelado...")
               RETURN VALOR
            ENDIF
            IF PEDIDO2->CODIGO_V==PEDIDO->CODIGO_V
               IF EMPTY(PEDIDO->NOTA_V) .AND. EMPTY(PEDIDO->DATPAG_V)
                  IF !EMPTY(PEDIDO->DATBAI_V)
                     TELA:=SAVESCREEN()
                     WINDOW(10,20,13,68)
                     @ 11,22 SAY "Este Pedido j  foi baixado, se vocˆ continuar" COLOR CORTEX
                     @ 12,22 SAY "ser  dado baixa automaticamente no estoque..." COLOR CORTEX
                     IF ! CONFIRMA(14,25,"Continua opera‡ao ?")
                        RESTSCREEN(,,,,TELA)
                        CLOSEWIN(10,20,13,68)
                        RETURN VALOR
                     ENDIF
                     RESTSCREEN(,,,,TELA)
                     CLOSEWIN(10,20,13,68)
                  ENDIF
                  IF PEDIDO2->(RECLOCK())
                     IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                        IF T="V"
                           IF ESTOQUE->(RECLOCK())
                              IF EMPTY(PEDIDO->DATBAI_V)
                                 ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V-PEDIDO2->QTD_V
                              ELSE
                                 movest("E",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
                              ENDIF
                              ESTOQUE->(DBUNLOCK())
                           ENDIF
                        ELSE
                           IF !EMPTY(PEDIDO->DATBAI_V)
                              IF ESTOQUE->(RECLOCK())
                                 movest("S",pedido2->item_v, "CM", pedido2->qtd_v, pedido2->codigo_v)
                              ENDIF
                              ESTOQUE->(DBUNLOCK())
                           ENDIF
                        ENDIF
                     ENDIF
                     TOTITE:=TOTITE-1
                     IF PEDIDO->(RECLOCK())
                        IF T="V"
                           PEDIDO->VALCUS_V:=PEDIDO->VALCUS_V-(PEDIDO2->QTD_V*PEDIDO2->VALCUS_V)
                           PEDIDO->VALMIN_V:=PEDIDO->VALMIN_V-(PEDIDO2->QTD_V*PEDIDO2->VALMIN_V)
                           PEDIDO->VALMED_V:=PEDIDO->VALMED_V-(PEDIDO2->QTD_V*PEDIDO2->VALMED_V)
                           PEDIDO->VALMAX_V:=PEDIDO->VALMAX_V-(PEDIDO2->QTD_V*PEDIDO2->VALMAX_V)
                           PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V-(PEDIDO2->QTD_V*PEDIDO2->VALUNI_V)
                        ELSE
                           PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V-((PEDIDO2->QTD_V*PEDIDO2->VALUNI_V)*(1+(PEDIDO2->IPI_V/100)))
                        ENDIF
                        PEDIDO->(DBUNLOCK())
                     ENDIF
                     PEDIDO2->(DBDELETE())
                     PEDIDO2->(DBSEEK(CODIGO))
                     @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99") COLOR CORTEX
                     @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99") COLOR CORTEX
                  ENDIF
               ELSE
                  AVISO("Imposs¡vel exluir itens com pedido j  fechado...")
               ENDIF
            ELSE
               PEDIDO2->(DBSEEK(PEDIDO->CODIGO_V))
            ENDIF
         CASE TECLA=22
            IF !EMPTY(PEDIDO->DATCAN_V)
               AVISO("Pedido cancelado...")
               RETURN VALOR
            ENDIF
            IF EMPTY(PEDIDO->NOTA_V) .AND. EMPTY(PEDIDO->DATPAG_V)
               IF !EMPTY(PEDIDO->DATBAI_V)
                  TELA:=SAVESCREEN()
                  WINDOW(10,20,13,68)
                  @ 11,22 SAY "Este Pedido j  foi baixado, se vocˆ continuar" COLOR CORTEX
                  @ 12,22 SAY "ser  dado baixa automaticamente no estoque..." COLOR CORTEX
                  IF ! CONFIRMA(14,25,"Continua opera‡ao ?")
                     RESTSCREEN(,,,,TELA)
                     CLOSEWIN(10,20,13,68)
                     RETURN VALOR
                  ENDIF
                  RESTSCREEN(,,,,TELA)
                  CLOSEWIN(10,20,13,68)
               ENDIF
               IF TOTITE<14
                  TELA:=SAVESCREEN()
                  WINDOW(4,0,6,79)
                  SETCOLOR(CORDES)
                  @ 05,16 CLEAR TO 05,35
                  SETCOLOR(CORTEX)
                  SETCURSOR(1)
                  @ 05,02 GET ITEM PICT "@K!" VALID(SEA_ESTOQUE(ITEM).AND.PEDIDO1(,,,5,IF(T="V",61,64)))
                  IF T="V"
                     @ 05,61 CLEAR TO 05,72
                     @ 05,38 GET T_VALUNI PICT "@R 999,999.99" VALID(LASTKEY()=5 .OR. T_VALUNI>0 .AND. PRECOVALID(T_VALUNI) .AND. PEDIDO2(5,IF(T="V",61,64)))
                     @ 05,50 GET T_QTD    PICT "@R 999,999.99" VALID(LASTKEY()=5 .OR. T_QTD>0 .AND. PEDIDO2(5,IF(T="V",61,64)) .AND. AVISOEST(T+"T",T_QTD))
                  ELSE
                     @ 05,63 CLEAR TO 05,74
                     @ 05,39 GET T_VALUNI PICT "@R 999,999.9999" VALID(LASTKEY()=5 .OR. T_VALUNI>0 .AND. PEDIDO2(5,IF(T="V",61,64)))
                     @ 05,52 GET T_QTD    PICT "@R 999,999.99" VALID(LASTKEY()=5 .OR. T_QTD>0 .AND. PEDIDO2(5,IF(T="V",61,64)) .AND. AVISOEST(T,T_QTD))
                     @ 05,75 GET T_IPI    PICT "@R 99 %"
                  ENDIF
                  READ
                  SETCURSOR(0)
                  IF LASTKEY()#27
                     IF PEDIDO2->(ADDREC())
                        PEDIDO2->CODIGO_V:=CODIGO
                        PEDIDO2->ITEM_V  :=ITEM
                        PEDIDO2->VALUNI_V:=T_VALUNI
                        PEDIDO2->QTD_V   :=T_QTD
                        IF T="C"
                           PEDIDO2->IPI_V    :=T_IPI
                        ENDIF
                     ENDIF
                     IF ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V))
                        IF ESTOQUE->(RECLOCK())
                           IF T="V"
                              PEDIDO2->VALCUS_V := ESTOQUE->VALCUS_V
                              IF CONFIG->MULTPRCV_V='S'
                                 PEDIDO2->VALMIN_V := ESTOQUE->VALVEN_V
                                 PEDIDO2->VALMED_V := ESTOQUE->VALMED_V
                                 PEDIDO2->VALMAX_V := ESTOQUE->VALMAX_V
                              ELSE
                                 PEDIDO2->VALMED_V := ESTOQUE->VALVEN_V
                              ENDIF
                              IF EMPTY(PEDIDO->DATBAI_V)
                                 ESTOQUE->RESERVA_V:=ESTOQUE->RESERVA_V+T_QTD
                              ELSE
                                 movest("S",pedido2->item_v, "VM", T_QTD, pedido2->codigo_v)
                              ENDIF
                              ESTOQUE->(DBUNLOCK())
                           ELSE
                              IF !EMPTY(PEDIDO->DATBAI_V)
                                 movest("E",pedido2->item_v, "CM", T_qtd, pedido2->codigo_v)
                              ENDIF
                              ESTOQUE->(DBUNLOCK())
                           ENDIF
                        ENDIF
                     ENDIF
                     IF PEDIDO->(RECLOCK())
                        IF T="V"
                           PEDIDO->VALCUS_V+=PEDIDO2->VALCUS_V
                           PEDIDO->VALMIN_V+=PEDIDO2->VALMIN_V
                           PEDIDO->VALMED_V+=PEDIDO2->VALMED_V
                           PEDIDO->VALMAX_V+=PEDIDO2->VALMAX_V
                           PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V+(T_QTD*T_VALUNI)
                        ELSE
                           PEDIDO->VALTOT_V:=PEDIDO->VALTOT_V+ROUND((T_QTD*T_VALUNI)*(1+(T_IPI/100)),2)
                        ENDIF
                        PEDIDO->(DBUNLOCK())
                     ENDIF
                     PEDIDO2->(DBCLEARFIL())
                     PEDIDO2->(DBSEEK(CODIGO))
                  ENDIF
                  RESTSCREEN(,,,,TELA)
                  CLOSEWIN(4,0,6,79)
                  TOTITE:=TOTITE+1
                  @ 6,2  SAY "Valor Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999.99") COLOR CORTEX
                  @ 6,27 SAY "Mao de Obra : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999.99")+" Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999.99") COLOR CORTEX
                  IF !EMPTY(PEDIDO->DATBAI_V)
                     PEDVIMP(PEDIDO->CODIGO_V,.T.)
                  ENDIF
               ELSE
                  AVISO("O n£mero m ximo de itens para a sua Nota Fiscal ‚ 14...")
               ENDIF
               PEDIDO2->(DBSEEK(PEDIDO->CODIGO_V))
            ELSE
               AVISO("Imposs¡vel incluir itens com pedido j  fechado...")
            ENDIF
      ENDCASE
ENDCASE
PEDIDO2->(DBUNLOCK())
RETURN VALOR

FUNCTION MOVPED1()
MEMVAR VALMO
@ 10,33 SAY "Valor Total : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALIPI_V+VALMO,"@R 999,999.99")
RETURN(.T.)