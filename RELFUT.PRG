FUNCTION RELFUT(TIPO,INIT,END)
LOCAL TELA,GETLIST:={},RTIPO,ORDEM,ARQ,ARQ2,LINHA,TOTORD,CURDIA,CURCLI,CAMPOS,TIT
LOCAL INICIO,FIM,SUBTITULO,LINHA2,TELA2,TOTGER
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA := SAVESCREEN()
INICIO:=TRABALHO
FIM   :=TRABALHO
RTIPO :='P'
ORDEM :='V'
DBF_CONFIG()
DBF_PAGREC()
DBF_CLIFOR()
DBF_PLANO()
DBF_PORTA()
DBF_BANK()
DO WHILE .T.
   IF INIT=(NIL) .OR. END=(NIL)
      WINDOW(10,10,14,62)
      @ 11,12 SAY "Relat¢rio (G)eral/(P)er¡odo     :" GET RTIPO PICT '@!' VALID RTIPO$'GP'
      @ 12,12 SAY "Data Inicial :" GET INICIO WHEN RTIPO='P'
      @ 12,38 SAY "Data Final :" GET FIM VALID FIM >= INICIO WHEN RTIPO='P'
      @ 13,12 SAY "Ordem (V)encimento/(A)lfab‚tica :" GET ORDEM PICT '@!' VALID ORDEM$'VA'
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
   ENDIF
   TELA2 := SAVESCREEN()
   @ 24,0 SAY PADC("Aguarde, gerando o relat¢rio...",80) COLOR CORTIT
   CAMPOS:={}
   AADD(CAMPOS,{"CLIFOR_V"  ,"C",06,0 })
   AADD(CAMPOS,{"NOME_V"    ,"C",50,0 })
   AADD(CAMPOS,{"DESC_V"    ,"C",50,0 })
   AADD(CAMPOS,{"DOCEXT_V"  ,"C",10,0 })
   AADD(CAMPOS,{"DOCINT_V"  ,"C",10,0 })
   AADD(CAMPOS,{"DATVEN_V"  ,"D",8 ,0 })
   AADD(CAMPOS,{"VALOR_V"   ,"N",14,2 })
   AADD(CAMPOS,{"CODPORTA_V","C",2 ,0 })
   AADD(CAMPOS,{"PORTA_V"   ,"C",15,0 })
   AADD(CAMPOS,{"CODPLA_V"  ,"C",4 ,0 })
   AADD(CAMPOS,{"PLANO_V"   ,"C",15,0 })
   AADD(CAMPOS,{"PEDTEC_V"  ,"C",6 ,0 })
   AADD(CAMPOS,{"BOLETO_V"  ,"C",16,0 })
   AADD(CAMPOS,{"BANBO_V"   ,"C",10,0 })
   AADD(CAMPOS,{"DUPLICA_V" ,"C",10,0 })
   AADD(CAMPOS,{"BANDU_V"   ,"C",10,0 })
   AADD(CAMPOS,{"COBCHQ_V"  ,"C",6 ,0 })
   AADD(CAMPOS,{"COBBANCO_V","C",10,0 })
   AADD(CAMPOS,{"COBAGEN_V" ,"C",4 ,0 })
   AADD(CAMPOS,{"COBCONTA_V","C",8 ,0 })
   AADD(CAMPOS,{"PROTESTO_V","C",1 ,0 })
   ARQ:=NOMETEMP()
   DBCREATE(ARQ,CAMPOS)
   IF ! FILE(ARQ+".DBF")
      AVISO("O Sistema nao conseguiu criar o arquivo temporario")
      LOOP
   ENDIF
   DBF_TMP(ARQ)
   IF ORDEM='A'
      INDEX ON TMP->NOME_V+DTOS(TMP->DATVEN_V) TO &ARQ
   ELSE
      INDEX ON DTOS(TMP->DATVEN_V)+TMP->NOME_V TO &ARQ
   ENDIF
   CAMPOS:={}
   AADD(CAMPOS,{"TIPO_V","C",1 ,0 })
   AADD(CAMPOS,{"P1_V"  ,"C",78,0 })
   AADD(CAMPOS,{"P2_V"  ,"C",55,0 })
   ARQ2 := STRTRAN(ARQ,'E','R')
   DBCREATE(ARQ2,CAMPOS)
   IF ! FILE(ARQ2+".DBF")
      AVISO("O Sistema nao conseguiu criar o arquivo temporario")
      LOOP
   ENDIF
   DBF_TMP(ARQ2,'IMP')
   IF RTIPO="P"
      PAGREC->(DBSETORDER(5),DBSEEK(INICIO,.T.))
   ENDIF
   DO WHILE IF(RTIPO="P",PAGREC->DATVEN_V>=INICIO .AND. PAGREC->DATVEN_V<=FIM,.NOT. PAGREC->(EOF()))
      IF LEFT(PAGREC->CODIGO_V,1)<>TIPO
         PAGREC->(DBSKIP())
         LOOP
      ENDIF
      DO WHILE .NOT. TMP->(ADDREC(5)); ENDDO
      TMP->CLIFOR_V  := PAGREC->CLIFOR_V
      TMP->NOME_V    := IF(CLIFOR->(DBSETORDER(1),DBSEEK(PAGREC->CLIFOR_V)),CLIFOR->NOME_V,'')
      TMP->DESC_V    := PAGREC->DESC_V
      TMP->DOCEXT_V  := PAGREC->DOCEXT_V
      TMP->DOCINT_V  := PAGREC->DOCINT_V
      TMP->DATVEN_V  := PAGREC->DATVEN_V
      TMP->VALOR_V   := PAGREC->VALOR_V
      TMP->CODPORTA_V:= PAGREC->CODPORTA_V
      TMP->PORTA_V   := IF(PORTA->(DBSETORDER(1),DBSEEK(PAGREC->CODPORTA_V)),PORTA->NOME_V,'')
      TMP->CODPLA_V  := PAGREC->CODPLA_V
      TMP->PLANO_V   := IF(PLANO->(DBSETORDER(1),DBSEEK(PAGREC->CODPLA_V)),PLANO->NOME_V,'')
      TMP->PEDTEC_V  := IF(EMPTY(PAGREC->PEDIDO_V),PAGREC->TECNICA_V,PAGREC->PEDIDO_V)
      TMP->BOLETO_V  := PAGREC->BOLETO_V
      TMP->BANBO_V   := IF(BANK->(DBSETORDER(1),DBSEEK(PAGREC->CODBANBO_V)),BANK->NOME_V,'')
      TMP->DUPLICA_V := PAGREC->DUPLICA_V
      TMP->BANDU_V   := IF(BANK->(DBSETORDER(1),DBSEEK(PAGREC->CODBANDU_V)),BANK->NOME_V,'')
      TMP->COBCHQ_V  := PAGREC->COBCHQ_V
      TMP->COBBANCO_V:= PAGREC->COBBANCO_V
      TMP->COBAGEN_V := PAGREC->COBAGEN_V
      TMP->COBCONTA_V:= PAGREC->COBCONTA_V
      TMP->PROTESTO_V:= PAGREC->PROTESTO_V
      TMP->(DBCOMMIT(),DBUNLOCK())
      PAGREC->(DBSKIP())
   ENDDO
   TMP->(DBGOTOP())
   TOTGER := 0
   DO WHILE .NOT. TMP->(EOF())
      TOTORD:=0
      CURCLI:=TMP->CLIFOR_V
      CURDIA:=TMP->DATVEN_V
      DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
      IMP->TIPO_V := 'N'
      IF ORDEM='A'
         IMP->P1_V := TMP->CLIFOR_V+' '+TMP->NOME_V
      ELSE
         IMP->P1_V := DTOC(TMP->DATVEN_V)
      ENDIF
      DO WHILE IF(ORDEM='A',TMP->CLIFOR_V=CURCLI,TMP->DATVEN_V=CURDIA) .AND. .NOT. TMP->(EOF())
         TOTORD += TMP->VALOR_V
         IF ORDEM='A'
            LINHA := ' '+TMP->DESC_V+' '+TMP->DOCEXT_V+' '+TMP->DOCINT_V+' '+TRANSFORM(TMP->VALOR_V,'@R 999,999.99')+' '+DTOC(TMP->DATVEN_V)
         ELSE
            LINHA := ' '+TMP->CLIFOR_V+' '+LEFT(TMP->NOME_V,35)+' '+LEFT(TMP->DESC_V,35)+' '+TMP->DOCEXT_V+' '+TMP->DOCINT_V+' '+TRANSFORM(TMP->VALOR_V,'@R 999,999.99')
         ENDIF
         DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
         IMP->TIPO_V:='C'
         IMP->P1_V := LEFT(LINHA,78)
         IMP->P2_V := SUBSTR(LINHA,79,55)
         IMP->(DBCOMMIT(),DBUNLOCK())
         IF TIPO='R'
            IF EMPTY(TMP->BOLETO_V) .AND. EMPTY(TMP->DUPLICA_V) .AND. EMPTY(TMP->COBCHQ_V)
               LINHA2 := '    Sem cobranca'
            ELSE
               LINHA2 := '   '+TMP->BOLETO_V+' '+TMP->BANBO_V+' '+TMP->DUPLICA_V+' '+TMP->BANDU_V+' '+TMP->COBCHQ_V+' '+TMP->COBBANCO_V+' '+TMP->COBAGEN_V+' '+TMP->COBCONTA_V+' '+TMP->PROTESTO_V
            ENDIF
            DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
            IMP->TIPO_V:='C'
            IMP->P1_V := LEFT(LINHA2,78)
            IMP->P2_V := SUBSTR(LINHA2,79,55)
            IMP->(DBCOMMIT(),DBUNLOCK())
         ENDIF
         TMP->(DBSKIP())
      ENDDO
      TOTGER += TOTORD
      DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
      IMP->TIPO_V := 'N'
      IMP->P1_V := '------- Total : '+TRANSFORM(TOTORD,"@R 999,999.99")
      IMP->(DBCOMMIT(),DBUNLOCK())
      DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
      IMP->TIPO_V := 'N'
      IMP->(DBCOMMIT(),DBUNLOCK())
   ENDDO
   DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
   IMP->TIPO_V := 'E'
   IMP->P1_V := '------- Total Geral : '+TRANSFORM(TOTGER,"@R 999,999.99")
   IMP->(DBCOMMIT(),DBUNLOCK())
   RESTSCREEN(,,,,TELA2)
   WINDOW(03,0,23,79)
   TIT := 'Relat¢rio de Contas a '+IF(TIPO='R','Receber','Pagar')
   CAMPOS := {'IMP->P1_V','IMP->P2_V'}
   IMP->(DBGOTOP())
   IMP->(DBEDIT(4,1,22,78,CAMPOS,,,{TIT,TIT}))
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      IF TIPO='R'
         IF ORDEM='V'
            SUBTITULO := {{"C","Vencimento"},{"C"," Nome                                       Descri‡ao                           Doc.Ext.   Doc.Int.        Valor"},{"C","  Boleto           Banco      Duplicata  Banco      ChqPre Banco      Agen Conta    Protesto"}}
         ELSE
            SUBTITULO := {{"C","Nome"},{"C"," Descri‡ao                                          Doc.Ext.   Doc.Int.        Valor Vencimento"},{"C","  Boleto           Banco      Duplicata  Banco      ChqPre Banco      Agen Conta    Protesto"}}
         ENDIF
      ELSE
         IF ORDEM='V'
            SUBTITULO := {{"C","Vencimento"},{"C"," Nome                                       Descri‡ao                           Doc.Ext.   Doc.Int.        Valor"}}
         ELSE
            SUBTITULO := {{"C","Nome"},{"C"," Descri‡ao                                          Doc.Ext.   Doc.Int.        Valor Vencimento"}}
         ENDIF
      ENDIF
      IMPRELDB("Relatorio de Contas a "+IF(TIPO="P","Pagar","Receber")+" no Perido de "+DTOC(INICIO)+" … "+DTOC(FIM),SUBTITULO,49)
   ENDIF
   TMP->(DBCLOSEAREA())
   IMP->(DBCLOSEAREA())
   FERASE(ARQ+".DBF")
   FERASE(ARQ2+".DBF")
   EXIT
ENDDO
CONFIG->(DBCLOSEAREA())
PAGREC->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
PLANO->(DBCLOSEAREA())
PORTA->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)