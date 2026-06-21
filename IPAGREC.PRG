FUNCTION IPAGREC(OPCAO)
LOCAL GETLIST:={}, cWs
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,NOMSEN

*** VARIAVEIS P/ CADASTRO DE CONTAS A PAGAR/RECEBER
MEMVAR PAGREC,CODIGO,CLIFOR,DOCEXT,DESC,DOCINT,DATVEN,VALOR,CODPLA,DATEXT,DATINT
MEMVAR CODPORTA
CODIGO  :=PAGREC+STRZERO(CONFIG->PAGREC_V+1,5,0)
CLIFOR  :=SPACE(LEN(PAGREC->CLIFOR_V))
DOCEXT  :=SPACE(LEN(PAGREC->DOCEXT_V))
DESC    :=SPACE(LEN(PAGREC->DESC_V))
DOCINT  :=SPACE(LEN(PAGREC->DOCINT_V))
DATEXT  :=CTOD("  /  /  ")
DATINT  :=CTOD("  /  /  ")
DATVEN  :=CTOD("  /  /  ")
VALOR   :=0
CODPLA  :=SPACE(LEN(PAGREC->CODPLA_V))
CODPORTA:=SPACE(LEN(PAGREC->CODPORTA_V))
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ IF(OPCAO="R",11,18),55 CLEAR TO IF(OPCAO="R",11,18),56
   @ IF(OPCAO="R",11,18),69 CLEAR TO IF(OPCAO="R",11,18),78
   @ IF(OPCAO="R",04,11),16 SAY CODIGO
   @ IF(OPCAO="R",05,12),16 GET CLIFOR PICT "@!" VALID(SEA_CLIFOR(CLIFOR,IF(OPCAO="R",05,12),25,IF(OPCAO="R","C","F")))
   @ IF(OPCAO="R",7,14),16 GET DOCEXT PICT "@!"
   @ IF(OPCAO="R",7,14),50 GET DATEXT
   @ IF(OPCAO="R",8,15),16 GET DESC   PICT "@!"
   @ IF(OPCAO="R",9,16),16 GET DOCINT PICT "@!"
   @ IF(OPCAO="R",9,16),50 GET DATINT
   @ IF(OPCAO="R",10,17),16 GET VALOR  PICT "@R 999,999,999.99" VALID(VALOR>0.OR.LASTKEY()=5)
   @ IF(OPCAO="R",10,17),48 GET CODPLA PICT "@!" VALID(LASTKEY()=5 .OR. SEA_CODPLA(CODPLA,IF(OPCAO="R",10,17),55,IF(OPCAO="R","+","-")))
   @ IF(OPCAO="R",11,18),16 GET DATVEN VALID(!EMPTY(DATVEN).OR.LASTKEY()=5)
   IF OPCAO="R"
      @ 11,48 GET CODPORTA PICT "@!" VALID(LASTKEY()=5 .OR. SEA_PORTA(CODPORTA,11,53))
   ENDIF
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF CONFIRMA(20,20,"Confirma Inclusao do T¡tulo ?")
      IF PAGREC->(ADDREC(5))
         IF CONFIG->(RECLOCK(5))
            CONFIG->PAGREC_V:=CONFIG->PAGREC_V+1
            CODIGO:=PAGREC+STRZERO(CONFIG->PAGREC_V,5,0)
            CONFIG->(DBUNLOCK())
         ELSE
            EXIT
         ENDIF
         PAGREC->CODIGO_V  :=CODIGO
         PAGREC->CLIFOR_V  :=CLIFOR
         PAGREC->DOCEXT_V  :=DOCEXT
         PAGREC->DATEXT_V  :=DATEXT
         PAGREC->DESC_V    :=DESC
         PAGREC->DOCINT_V  :=DOCINT
         PAGREC->DATINT_V  :=DATINT
         PAGREC->DATVEN_V  :=DATVEN
         PAGREC->VALOR_V   :=VALOR
         PAGREC->CODPLA_V  :=CODPLA
         PAGREC->CODPORTA_V:=CODPORTA
         PAGREC->NOMSEN_V:=NOMSEN
         PAGREC->(DBUNLOCK())
         cParc := "1"
         cWS := "dtvenc"+cParc+"="+dtos(pagrec->datven_v)+;
                "&descr"+cParc+"="+alltrim(pagrec->desc_v)+;
                "&val"+cParc+"="+alltrim(str(pagrec->valor_v,14,2))+;
                "&dtint"+cParc+"="+alltrim(dtos(pagrec->datext_v))+;
                "&docint"+cParc+"="+alltrim(pagrec->docext_v)+;
                "&pagrec"+cParc+"="+alltrim(pagrec->codigo_v)
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
           ws(cWs, "/agendamentos/cadastra_agendamento")
         EXIT
      ENDIF
   ENDIF
ENDDO
RETURN(.T.)