FUNCTION MNTECCAD()
LOCAL  TELA,OP,TELA2,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR FICHA,RECEBE,CLIFOR,DATENT,ITEM,COMPLETA,ORCAMENT,DATORC,DATPAG
MEMVAR DATAPR,DATEXE,DATEXE2,DATSAI,MECVEN,GARANTIA,VALMO,VALITOT,NOTA

TELA:=SAVESCREEN()
DO WHILE .T.
   IF ! EMPTY(DATSAI)
      IF ! EMPTY(DATPAG)
         @ 1,57 SAY "Fechado em " + DTOC(DATPAG)
      ELSE
         @ 1,70 SAY "Pendente" COLOR CORTIT
      ENDIF
   ENDIF
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   WINDOW(15,8,21,18)
   @ 16,9 PROMPT "  Novo   "
   @ 17,9 PROMPT "  Edita  "
   @ 18,9 PROMPT "  Apaga  "
   @ 19,9 PROMPT "  Texto  "
   @ 20,9 PROMPT " Operado "
   MENU TO OP
   DO CASE
      CASE OP=1
         RESTSCREEN(,,,,TELA)
         CLOSEWIN(14,8,21,18)
         ITECNICA()
         EXIT
      CASE OP=2
         RESTSCREEN(,,,,TELA)
         CLOSEWIN(14,8,21,18)
         ATECNICA()
         EXIT
      CASE OP=3
         RESTSCREEN(,,,,TELA)
         CLOSEWIN(14,8,21,18)
         IF CONFIRMA(20,20,"Deseja realmente excluir esta ficha ?")
            IF TECNICA->(RECLOCK())
               TECNICA2->(DBSETORDER(1))
               IF TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
                  DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V
                     IF TECNICA2->(RECLOCK())
                        TECNICA2->(DBDELETE())
                        TECNICA2->(DBUNLOCK())
                     ELSE
                        LOOP
                     ENDIF
                     TECNICA2->(DBSKIP())
                  ENDDO
               ENDIF
               TECNICA->(DBDELETE())
               TECNICA->(DBUNLOCK())
               TECNICA->(DBSEEK(FICHA,.T.))
               EXIT
            ELSE
               AVISO("Imposs¡vel apagar, existe outro usu rio utilizando esta ficha...")
            ENDIF
         ENDIF
      CASE OP=4
         TELA2:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         SETCOLOR(CORTIT)
         @ 6,2 SAY "Ficha : " + FICHA
         SETCOLOR(CORTEX)
         @ 7,1 TO 7,78
         SETCOLOR("N/W")
         IF TECNICA->(RECLOCK(5))
            TECNICA->TEXTO_V:=MEMOEDIT(TECNICA->TEXTO_V,8,2,19,77,.T.,"MemoFunction")
            TECNICA->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA2)
         CLOSEWIN(5,0,20,79)
      CASE OP=5
         TELA2:=SAVESCREEN()
         WINDOW(8,15,12,66)
         @ 09,17 SAY "Entrada de ficha cadastrado por    : "+TECNICA->NOMSEN_V
         @ 10,17 SAY "Or‡amento realizado por            : "+TECNICA->NOMORC_V
         @ 11,17 SAY "Finaliza‡ao da ficha realizada por : "+TECNICA->NOMSAI_V
         INKEY(0)
         RESTSCREEN(,,,,TELA2)
         CLOSEWIN(8,15,12,66)
      OTHERWISE
         RESTSCREEN(,,,,TELA)
         CLOSEWIN(14,8,21,18)
         EXIT
   ENDCASE
ENDDO
RETURN(.T.)

FUNCTION MNTECMOV()
LOCAL OP,TELA,GETLIST:={},TELA2,MES,COL,MDATE,VALPAR,DOCEXT,X,TOTPAR
LOCAL ENT,ENT2,INTER,PARC,REGISTRAR,PAGREC,CONT
local dtparc, vrparc, tpparc, codplas
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
MEMVAR FICHA,RECEBE,CLIFOR,DATENT,ITEM,COMPLETA,ORCAMENT,DATORC,DATPAG
MEMVAR DATAPR,DATEXE,DATEXE2,DATSAI,MECVEN,GARANTIA,VALMO,VALITOT,NOTA
MEMVAR VALTERC,VALOUTRO

TELA:=SAVESCREEN()
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   WINDOW(15,18,21,36)
   @ 16,19 PROMPT                   " Or‡amento       "
   @ 17,19 PROMPT IF(EMPTY(DATAPR) ," Aprova          "," Desaprova       ")
   @ 18,19 PROMPT IF(EMPTY(DATEXE) ," Sa¡da de Pe‡as  "," Devolu‡ao Pe‡as ")
   @ 19,19 PROMPT IF(EMPTY(DATEXE2)," Executa         "," ¥ Executa       ")
   @ 20,19 PROMPT IF(EMPTY(DATSAI) ," Entrega         "," ¥ Entrega       ")
   MENU TO OP
   RESTSCREEN(,,,,TELA)
   DO CASE
      CASE OP=1
         ORCAMENT()
      CASE OP=2 //APROVACAO
         IF EMPTY(DATAPR)
            @ 15,16 GET VALMO PICT "@R 999,999,999.99" VALID(VALITOT>=0 .OR. VALMO>=0 .AND. TECCALC())
            @ 16,16 GET VALTERC PICT "@R 999,999,999.99" VALID(VALTERC>=0 .AND. TECCALC())
            @ 16,50 GET VALOUTRO PICT "@R 999,999,999.99" VALID(TECCALC())
            @ 20,68 GET DATAPR VALID(!EMPTY(DATAPR))
            READ
            IF CONFIRMA(20,20,"Aprovar a ficha ?")
               IF TECNICA->(RECLOCK())
                  TECNICA->VALMO_V :=VALMO
                  TECNICA->DATAPR_V:=DATAPR
                  TECNICA->VALTERC_V:=VALTERC
                  TECNICA->VALOUTRO_V:=VALOUTRO
                  TECNICA->(DBUNLOCK())
               ENDIF
            ENDIF
         ELSE
            IF ! EMPTY(TECNICA->NOTA_V)
               AVISO("Imposs¡vel utilizar esta op‡ao com Nota Fiscal j  emitida...")
               LOOP
            ENDIF
            IF CONFIRMA(20,20,"Deseja desaprovar esta ficha ?")
               IF TECNICA->(RECLOCK())
                  TECNICA->DATAPR_V:=CTOD("  /  /  ")
                  TECNICA->(DBUNLOCK())
               ENDIF
            ENDIF
         ENDIF
         RETURN(.T.)
      CASE OP=3  // SAIDA DE PECAS
         IF EMPTY(TECNICA->DATEXE_V)
            IF ! EMPTY(TECNICA->DATORC_V)
               TECNICA2->(DBSETORDER(1),DBSEEK(TECNICA->CODIGO_V))
               CONT := .T.
               DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
                  IF TECNICA2->TIPO_V#"O"
                     IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)) .AND. ESTOQUE->QTD_V-ESTOQUE->RESERVA_V<TECNICA2->QTD_V
                        CONT := .F.
                     ENDIF
                  ENDIF
                  TECNICA2->(DBSKIP())
               ENDDO
               IF CONFIG->LCKQTDV_V='S' .AND. .NOT. CONT
                  AVISO("Nao existe todos os itens dispon¡veis no estoque...")
                  RETURN(.T.)
               ENDIF
               @ 21,17 GET DATEXE VALID(!EMPTY(DATEXE))
               READ
               IF LASTKEY()=27
                  LOOP
               ENDIF
               IF TECNICA2->(DBSEEK(TECNICA->CODIGO_V)) .AND. TECNICA->(RECLOCK())
                  TECNICA->DATEXE_V:=DATEXE
                  TECNICA->(DBUNLOCK())
                  DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
                     IF TECNICA2->TIPO_V#"O"
                        IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                           movest("S",tecnica2->item_v, "AT", tecnica2->qtd_v, tecnica2->codigo_v)
                        ENDIF
                     ENDIF
                     TECNICA2->(DBSKIP())
                  ENDDO
               ENDIF
            ELSE
               AVISO("Imposs¡vel utilizar esta op‡ao sem ter sido feito o or‡amento")
            ENDIF
         ELSE
            IF ! CONFIRMA(20,20,"Confirma devolu‡ao de pe‡as ?")
               LOOP
            ENDIF
            IF EMPTY(TECNICA->NOTA_V)
               IF TECNICA2->(DBSEEK(TECNICA->CODIGO_V)) .AND. TECNICA->(RECLOCK())
                  TECNICA->DATEXE_V:=CTOD("  /  /  ")
                  TECNICA->(DBUNLOCK())
                  DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V .AND. TECNICA2->(!EOF())
                     IF TECNICA2->TIPO_V#"O"
                        IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                           movest("E",tecnica2->item_v, "AT", tecnica2->qtd_v, tecnica2->codigo_v)
                        ENDIF
                     ENDIF
                     TECNICA2->(DBSKIP())
                  ENDDO
               ENDIF
            ELSE
               AVISO("Imposs¡vel devolver pe‡as com a Nota Fiscal emitida...")
               AVISO("Vo‡ˆ pode cancelar a Nota Fiscal...")
            ENDIF
         ENDIF
         RETURN(.T.)
      CASE OP=4  // CONSERTO
         IF EMPTY(DATEXE2)
            IF EMPTY(TECNICA->MECVEN_V)
               @ 14,50 GET MECVEN VALID(SEA_MECVEN(MECVEN,14,57,"M"))
            ENDIF
            @ 15,16 GET VALMO PICT "@R 999,999,999.99"  VALID(VALITOT>=0 .OR. VALMO>=0 .AND. TECCALC())
            @ 16,16 GET VALTERC PICT "@R 999,999,999.99" VALID(VALTERC>=0 .AND. TECCALC())
            @ 16,50 GET VALOUTRO PICT "@R 999,999,999.99" VALID(TECCALC())
            @ 21,42 GET DATEXE2 VALID(!EMPTY(DATEXE2))
            READ
            IF CONFIRMA(20,20,"Executar o servi‡o desta ficha ?")
               IF TECNICA->(RECLOCK())
                  TECNICA->MECVEN_V:=MECVEN
                  TECNICA->VALMO_V :=VALMO
                  TECNICA->DATEXE2_V:=DATEXE2
                  TECNICA->VALTERC_V:=VALTERC
                  TECNICA->VALOUTRO_V:=VALOUTRO
                  TECNICA->(DBUNLOCK())
               ENDIF
            ENDIF
         ELSE
            IF ! EMPTY(TECNICA->NOTA_V)
               AVISO("Imposs¡vel utilizar esta op‡ao com Nota Fiscal j  emitida...")
               LOOP
            ENDIF
            IF CONFIRMA(20,20,"Deseja cancelar a execu‡ao desta ficha ?")
               IF TECNICA->(RECLOCK())
                  TECNICA->DATEXE2_V:=CTOD("  /  /  ")
                  TECNICA->(DBUNLOCK())
               ENDIF
            ENDIF
         ENDIF
         RETURN(.T.)
      CASE OP=5  // FINALIZAR
         DBF_PLANO()
         DBF_PAGREC()
         IF EMPTY(DATSAI)
            @ 15,16 GET VALMO PICT "@R 999,999,999.99"  VALID(VALITOT>=0 .OR. VALMO>=0 .AND. TECCALC())
            @ 16,16 GET VALTERC PICT "@R 999,999,999.99" VALID(VALTERC>=0 .AND. TECCALC())
            @ 16,50 GET VALOUTRO PICT "@R 999,999,999.99" VALID(TECCALC())
            @ 21,68 GET DATSAI VALID(!EMPTY(DATSAI))
            READ
            IF CONFIRMA(20,20,"Finalizar a ficha ?")
               MES:=0
               dtparc := array(0)
               vrparc := array(0)
               docext := array(0)
               tpparc := array(0)
               codplas:= array(0)
               if ((valmo + valterc + valoutro + valitot) > 0)
                  @ 2,1 CLEAR TO 21,78
                  @ 4,2 SAY "Garantia valida por :" GET MES PICT "999"
                  @ 4,28 SAY "Mes(es)"
                  READ
                  IF LASTKEY() = 27
                     LOOP
                  ENDIF
                  @ 5,1 SAY PADC("Faturamento",78) COLOR CORTIT
                  if !DesmembraParcelasTecnica(valitot, valmo+valterc+valoutro, @dtparc, @vrparc, @docext, @tpparc, @codplas)
                     loop
                  endif
                  IF CONFIG->AUTVEN_V="P" .and. config->tipaut_v=='P'
                     IF CONFIRMA(20,20,"Registrar Contas Futuras ?")
                        REGISTRAR:="S"
                     ELSE
                        REGISTRAR:="N"
                     ENDIF
                  ELSE
                     registrar:=if(config->autven_v=='S' .and. config->tipaut_v=='P', 'S', 'N')
                  ENDIF
               endif
               IF TECNICA->(RECLOCK())
                  TECNICA->VALMO_V   :=VALMO
                  TECNICA->DATSAI_V  :=DATSAI
                  IF MES=0
                     TECNICA->DATGAR_V:=DATSAI
                  ELSE
                     TECNICA->DATGAR_V:=TECNICA->DATSAI_V+(MES*30)
                  ENDIF
                  TECNICA->NOMSAI_V  :=NOMSEN
                  TECNICA->VALTERC_V:=VALTERC
                  TECNICA->VALOUTRO_V:=VALOUTRO
                  if config->autven_v="P" .and. config->tipaut_v=='P'
                     if confirma(20,20,"Registrar Contas Futuras ?")
                        registrar:="S"
                     else
                        registrar:="N"
                     endif
                  else
                     registrar:=if(config->autven_v=='S' .and. config->tipaut_v=='P', 'S', 'N')
                  endif
                  cWs := ""
                  for i := 1 to len(dtparc)
                     if !empty(dtparc[i]) .and. vrparc[i]>0
                        pagrec := ""
                        if registrar == "S"
                           pagrec->(addrec(5))
                           config->(reclock())
                           pagrec:="R"+strzero(config->pagrec_v+1,5,0)
                           config->pagrec_v:=config->pagrec_v+1
                           config->(dbunlock())
                           tecnica->pagrec1_v:=pagrec
                           pagrec->codigo_v :=pagrec
                           pagrec->clifor_v :=tecnica->clifor_v
                           pagrec->codpla_v :=codplas[i]
                           pagrec->tecnica_v :=tecnica->codigo_v
                           pagrec->valor_v  :=vrparc[i]
                           pagrec->datven_v :=dtparc[i]
                           pagrec->docext_v :=docext[i]
                           pagrec->datext_v :=date()
                           pagrec->desc_v   :="Servico ficha "+tecnica->codigo_v+" "+if(tpparc[i]=="P", "pecas", if(tpparc[i]=="S","mao de obra","pecas + mao de obra"))
                           pagrec->(dbunlock())
                           nWs ++
                           cParc := alltrim(str(nWs))
                           cWS += "dtvenc"+cParc+"="+dtos(pagrec->datven_v)+;
                                  "&descr"+cParc+"="+alltrim(pagrec->desc_v)+;
                                  "&val"+cParc+"="+alltrim(str(valor_v,14,2))+;
                                  "&dtint"+cParc+"="+alltrim(dtos(pedfat->datext_v))+;
                                  "&docint"+cParc+"="+alltrim(pagrec->docext)
                        endif
                        tecfat->(addrec(5))
                        tecfat->id_v := lastid("tecfat")
                        tecfat->codigo_v := tecnica->codigo_v
                        tecfat->datemi_v := tecnica->datsai_v
                        tecfat->dtparc_v := dtparc[i]
                        tecfat->vrparc_v := vrparc[i]
                        tecfat->docext_v := docext[i]
                        tecfat->tpparc_v := tpparc[i]
                        tecfat->pagrec_v := pagrec
                        tecfat->(dbcommit(), dbunlock())
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
                  TECNICA->(DBUNLOCK())
               ENDIF
               IF CONFIRMA(20,20,"Deseja imprimir a ficha de sa¡da ?")
                  IMPSAIDA()
               ENDIF
            ENDIF
         ELSE
            do while .t.
               IF ! EMPTY(TECNICA->NOTA_V)
                  AVISO("Imposs¡vel utilizar esta op‡ao com Nota Fiscal j  emitida...")
                  exit
               ENDIF
               IF CONFIRMA(20,20,"Deseja voltar a entrega desta ficha ?")
                  IF ! EMPTY(TECNICA->PAGREC_V)
                     IF ! PAGREC->(DBSEEK(TECNICA->PAGREC_V))
                        IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(TECNICA->DATPAG_V)+" nao encontrada, continuar ?")
                           exit
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ! EMPTY(TECNICA->PAGREC1_V)
                     IF ! PAGREC->(DBSEEK(TECNICA->PAGREC1_V))
                        IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(TECNICA->DATPAG1_V)+" nao encontrada, continuar ?")
                           exit
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ! EMPTY(TECNICA->PAGREC2_V)
                     IF ! PAGREC->(DBSEEK(TECNICA->PAGREC2_V))
                        IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(TECNICA->DATPAG2_V)+" nao encontrada, continuar ?")
                           exit
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ! EMPTY(TECNICA->PAGREC3_V)
                     IF ! PAGREC->(DBSEEK(TECNICA->PAGREC3_V))
                        IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(TECNICA->DATPAG3_V)+" nao encontrada, continuar ?")
                           exit
                        ENDIF
                     ENDIF
                  ENDIF
                  IF ! EMPTY(TECNICA->PAGREC4_V)
                     IF ! PAGREC->(DBSEEK(TECNICA->PAGREC4_V))
                        IF ! CONFIRMA(20,05,"Parcela a vencer dia "+DTOC(TECNICA->DATPAG4_V)+" nao encontrada, continuar ?")
                           exit
                        ENDIF
                     ENDIF
                  ENDIF
                  IF PAGREC->(DBSEEK(TECNICA->PAGREC_V))
                     PAGREC->(RECLOCK(5))
                     PAGREC->(DBDELETE())
                     PAGREC->(DBUNLOCK())
                  ENDIF
                  IF PAGREC->(DBSEEK(TECNICA->PAGREC1_V))
                     PAGREC->(RECLOCK(5))
                     PAGREC->(DBDELETE())
                     PAGREC->(DBUNLOCK())
                  ENDIF
                  IF PAGREC->(DBSEEK(TECNICA->PAGREC2_V))
                     PAGREC->(RECLOCK(5))
                     PAGREC->(DBDELETE())
                     PAGREC->(DBUNLOCK())
                  ENDIF
                  IF PAGREC->(DBSEEK(TECNICA->PAGREC3_V))
                     PAGREC->(RECLOCK(5))
                     PAGREC->(DBDELETE())
                     PAGREC->(DBUNLOCK())
                  ENDIF
                  IF PAGREC->(DBSEEK(TECNICA->PAGREC4_V))
                     PAGREC->(RECLOCK(5))
                     PAGREC->(DBDELETE())
                     PAGREC->(DBUNLOCK())
                  ENDIF
                  if tecfat->(dbsetorder(2), dbseek(tecnica->codigo_v))
                     do while !tecfat->(eof()) .and. tecfat->codigo_v == tecnica->codigo_v
                        tecfat->(reclock())
                        tecfat->(dbdelete())
                        tecfat->(dbunlock())
                        tecfat->(dbskip())
                     enddo
                  endif
                  IF TECNICA->(RECLOCK())
                     TECNICA->PAGREC_V:=SPACE(LEN(TECNICA->PAGREC_V))
                     TECNICA->PAGREC1_V:=SPACE(LEN(TECNICA->PAGREC1_V))
                     TECNICA->PAGREC2_V:=SPACE(LEN(TECNICA->PAGREC2_V))
                     TECNICA->PAGREC3_V:=SPACE(LEN(TECNICA->PAGREC3_V))
                     TECNICA->PAGREC4_V:=SPACE(LEN(TECNICA->PAGREC4_V))
                     TECNICA->DATPAG_V:=CTOD("  /  /    ")
                     TECNICA->DATPAG1_V:=CTOD("  /  /    ")
                     TECNICA->DATPAG2_V:=CTOD("  /  /    ")
                     TECNICA->DATPAG3_V:=CTOD("  /  /    ")
                     TECNICA->DATPAG4_V:=CTOD("  /  /    ")
                     TECNICA->VALPAR_V:=0
                     TECNICA->VALPAR1_V:=0
                     TECNICA->VALPAR2_V:=0
                     TECNICA->VALPAR3_V:=0
                     TECNICA->VALPAR4_V:=0
                     TECNICA->DATSAI_V  :=CTOD("  /  /  ")
                     TECNICA->DATGAR_V  :=CTOD("  /  /  ")
                     TECNICA->NOMSAI_V  :=NOMSEN
                     TECNICA->(DBUNLOCK())
                  ENDIF
               ENDIF
               exit
            enddo
         ENDIF
         PLANO->(DBCLOSEAREA())
         PAGREC->(DBCLOSEAREA())
         RETURN(.T.)
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(,,,,TELA)
RETURN(.T.)