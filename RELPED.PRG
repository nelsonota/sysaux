FUNCTION RELPED1(TIPO)
LOCAL TELA,INICIO,FIM,TPERIODO,TVENDA,TSITUACAO,TORDEM,GETLIST:={},LINHA,LINHA2,LINHA3
LOCAL ARQ,CAMPOS,SUBTITULO,TITULO,TOTGER,TTIPO,TCLASSIFICAR
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,CLIFOR,MECVEN
TELA := SAVESCREEN()
INICIO   := DATE()
FIM   := DATE()
TPERIODO     := 'P'
TVENDA       := 'G'
TSITUACAO    := 'F'
TORDEM       := 'E'
TTIPO        := 'R'
TCLASSIFICAR := 'G'
DBF_PEDIDO()
DBF_CONFIG()
DBF_CLIFOR()
DBF_MECVEN()
CLIFOR := SPACE(LEN(CLIFOR->CODIGO_V))
MECVEN := SPACE(LEN(MECVEN->CODIGO_V))
WINDOW(06,10,22,62)
DO WHILE .T.
   @ 07,11 SAY PADR(" Per¡odo",51) COLOR CORTIT
   @ 08,12 SAY "(G)eral / Definir (P)er¡odo                   :" GET TPERIODO PICT "@!"VALID TPERIODO$'PG'
   @ 09,12 SAY "Inicio :" GET INICIO WHEN TPERIODO='P'
   @ 09,32 SAY "Fim :" GET FIM VALID FIM>=INICIO WHEN TPERIODO='P'
   @ 10,11 SAY PADR(" Relat¢rio baseado na data de",51) COLOR CORTIT
   @ 11,12 SAY "(E)missao / (B)aixa / (F)echamento            :" GET TORDEM PICT "@!" VALID TORDEM$'EBF'
   @ 12,11 SAY PADR(" Situa‡ao dos pedidos",51) COLOR CORTIT
   @ 13,12 SAY "(E)mitidos / (B)aixados / (F)echados          :" GET TSITUACAO PICT "@!" VALID TSITUACAO$'EBF'
   @ 14,11 SAY PADR(" Pedido gerado em",51) COLOR CORTIT
   @ 15,12 SAY "Vendas (D)iretas / por (P)edido / (G)eral     :" GET TVENDA PICT "@!" VALID TVENDA$'DPG'
   @ 16,11 SAY PADR(" Classificar",51) COLOR CORTIT
   @ 17,12 SAY "(G)eral / por (V)endedor / por (C)liente      :" GET TCLASSIFICAR PICT "@!" VALID TCLASSIFICAR$"GVC"
   @ 18,12 SAY IF(TIPO="V","C¢digo do Cliente                        :","C¢digo do Fornecedor                     :") GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,,,IF(TIPO='V','C','F'))) WHEN TCLASSIFICAR='C'
   @ 19,12 SAY "C¢digo do Vendedor                       :" GET MECVEN VALID(SEA_MECVEN(MECVEN,,,'V')) WHEN TCLASSIFICAR='V'
   @ 20,11 SAY PADR(" Informa‡oes",51) COLOR CORTIT
   @ 21,12 SAY "(R)esumido / (D)etalhado                      :" GET TTIPO PICT "@!" VALID TTIPO$'RD'
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   CAMPOS:={}
   AADD(CAMPOS,{"TIPO_V","C",1 ,0 })
   AADD(CAMPOS,{"P1_V"  ,"C",78,0 })
   AADD(CAMPOS,{"P2_V"  ,"C",55,0 })
   ARQ := NOMETEMP()
   DBCREATE(ARQ,CAMPOS)
   IF ! FILE(ARQ+".DBF")
      AVISO("O Sistema nao conseguiu criar o arquivo temporario")
      LOOP
   ENDIF
   DBF_TMP(ARQ,'IMP')
   PEDIDO->(DBGOTOP())
   IF TPERIODO='P'
      PEDIDO->(DBSETORDER( IF(TORDEM='E',3,IF(TORDEM='B',4,5))  ),DBSEEK(INICIO))
   ENDIF
   SET CENTURY OFF
   TOTGER := 0
   DO WHILE IF(TPERIODO='G',.NOT. PEDIDO->(EOF()), IF(TORDEM='E',PEDIDO->DATEMI_V,IF(TORDEM='B',PEDIDO->DATBAI_V,PEDIDO->DATPAG_V))>=INICIO .AND. IF(TORDEM='E',PEDIDO->DATEMI_V,IF(TORDEM='B',PEDIDO->DATBAI_V,PEDIDO->DATPAG_V))<=FIM)
      IF TVENDA<>'G' .AND. TVENDA<>PEDIDO->TIPO_V .OR. TIPO<>LEFT(PEDIDO->CODIGO_V,1) .OR. .NOT. EMPTY(PEDIDO->DATCAN_V)
         PEDIDO->(DBSKIP())
         LOOP
      ENDIF
      IF (.NOT. (TSITUACAO='E' .AND. EMPTY(PEDIDO->DATBAI_V) .AND. EMPTY(PEDIDO->DATPAG_V))) .AND.;
         (.NOT. (TSITUACAO='B' .AND. (.NOT.EMPTY(PEDIDO->DATBAI_V)) .AND. EMPTY(PEDIDO->DATPAG_V))) .AND.;
         (.NOT. (TSITUACAO='F' .AND. .NOT. EMPTY(PEDIDO->DATPAG_V)))
         PEDIDO->(DBSKIP())
         LOOP
      ENDIF
      IF TCLASSIFICAR<>'G' .AND. ((TCLASSIFICAR='C' .AND. PEDIDO->CLIFOR_V<>CLIFOR) .OR. (TCLASSIFICAR='V' .AND. PEDIDO->MECVEN_V<>MECVEN))
         PEDIDO->(DBSKIP())
         LOOP
      ENDIF
      IF TTIPO='R'
         LINHA := PEDIDO->CODIGO_V+' '+PEDIDO->CLIFOR_V+'-'+IF(CLIFOR->(DBSETORDER(1),DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->NOME_V,SPACE(LEN(CLIFOR->NOME_V)))+' '+DTOC(PEDIDO->DATEMI_V)+' '+DTOC(PEDIDO->DATBAI_V)+' '+DTOC(PEDIDO->DATPAG_V)+' '+PEDIDO->DOCEXT_V+' '+TRANSFORM(PEDIDO->VALTOT_V,'@R 999,999.99')+' '+STRZERO(PEDIDO->NOTA_V,6,0)
      ELSE
         LINHA := PEDIDO->CODIGO_V+' '+PEDIDO->CLIFOR_V+'-'+IF(CLIFOR->(DBSETORDER(1),DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->NOME_V,SPACE(LEN(CLIFOR->NOME_V)))+' '+TRANSFORM(PEDIDO->VALTOT_V,'@R 999,999.99')+' '+IF(TSITUACAO='F',STRZERO(PEDIDO->NOTA_V,6),DTOC(PEDIDO->DATEMI_V)+' '+DTOC(PEDIDO->DATBAI_V))
         LINHA2:= ' '+DTOC(PEDIDO->DATEMI_V)+' '+DTOC(PEDIDO->DATBAI_V)+' '+DTOC(PEDIDO->DATPAG_V)+' '+PEDIDO->DOCEXT_V+' '+DTOC(PEDIDO->DATPAG1_V)+' '+PEDIDO->DOCEXT1_V+' '+DTOC(PEDIDO->DATPAG2_V)+' '+PEDIDO->DOCEXT2_V+' '+DTOC(PEDIDO->DATPAG3_V)+' '+PEDIDO->DOCEXT3_V+' '+DTOC(PEDIDO->DATPAG4_V)+' '+PEDIDO->DOCEXT4_V
         LINHA3:= '                             '+TRANSFORM(PEDIDO->VALPAR_V,'@R 99,999.99')+SPACE(11)+TRANSFORM(PEDIDO->VALPAR1_V,'@R 99,999.99')+SPACE(11)+TRANSFORM(PEDIDO->VALPAR2_V,'@R 99,999.99')+SPACE(11)+TRANSFORM(PEDIDO->VALPAR3_V,'@R 99,999.99')+SPACE(11)+TRANSFORM(PEDIDO->VALPAR4_V,'@R 99,999.99')
      ENDIF
      TOTGER += PEDIDO->VALTOT_V
      DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
      IMP->TIPO_V := 'C'
      IMP->P1_V := LEFT(LINHA,78)
      IMP->P2_V := SUBSTR(LINHA,79,55)
      IMP->(DBCOMMIT(),DBUNLOCK())
      IF TSITUACAO='F' .AND. TTIPO='D'
         DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
         IMP->TIPO_V := 'C'
         IMP->P1_V := LEFT(LINHA2,78)
         IMP->P2_V := SUBSTR(LINHA2,79,55)
         IMP->(DBCOMMIT(),DBUNLOCK())
         DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
         IMP->TIPO_V := 'C'
         IMP->P1_V := LEFT(LINHA3,78)
         IMP->P2_V := SUBSTR(LINHA3,79,55)
         IMP->(DBCOMMIT(),DBUNLOCK())
      ENDIF
      PEDIDO->(DBSKIP())
   ENDDO
   DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
   IMP->TIPO_V := 'N'
   IMP->P1_V := REPLICATE("-",78)   
   IMP->P2_V := "--"
   IMP->(DBCOMMIT(),DBUNLOCK())
   DO WHILE .NOT. IMP->(ADDREC(5));ENDDO
   IMP->TIPO_V := 'N'
   IMP->P1_V := "Total Geral : "+TRANSFORM(TOTGER,"@R 999,999,999.99")
   IMP->(DBCOMMIT(),DBUNLOCK())
   SET CENTURY ON
   WINDOW(03,0,21,79)
   CAMPOS := {'IMP->P1_V','IMP->P2_V'}
   TITULO := 'Relatorio de '+IF(TIPO='V','Vendas','Compras')+' : '+IF(TPERIODO='G','Geral','De '+DTOC(INICIO)+' a '+DTOC(FIM))+' DtOrd:'+IF(TORDEM='E','Emissao',IF(TORDEM='B','Baixa','Fechamento'))+' Sit:'+IF(TSITUACAO='F','Fechados',IF(TSITUACAO='B','Baixados','Emitidos'))
   IMP->(DBGOTOP())
   IMP->(DBEDIT(04,01,20,78,CAMPOS,,,{TITULO,TITULO}))
   IF CONFIRMA(20,20,"Deseja Imprimir o Relat¢rio ?")
      IF TTIPO='R'
         SUBTITULO := {{'C','Codigo Nome                                                      Emissao  Baixa    Faturamt Documento   Vlr Total Nota F'}}
      ELSE
         IF TSITUACAO='F'
            SUBTITULO={{'C','Codigo Nome                        Valor Total                  Valor Total NF'},;
                       {'C',' Emissao  Baixa    Vcto1       DocExt1 Vcto2       DocExt2 Vcto3       DocExt3 Vcto4       DocExt4 Vcto5       DocExt5'},;
                       {'C','                                 Valor               Valor               Valor               Valor               Valor'}}
         ELSE
            SUBTITULO={{'C','Codigo Nome                        Valor Total                  Valor Total Emissao  Baixa'}}
         ENDIF
      ENDIF
      IMPRELDB(TITULO,SUBTITULO,49)
   ENDIF
   IMP->(DBCLOSEAREA())
   FERASE(ARQ+'.DBF')
   EXIT
ENDDO
PEDIDO->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
CONFIG->(DBCLOSEAREA())
MECVEN->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
RETURN(.T.)