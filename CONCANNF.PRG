FUNCTION CONCANNF(OPCAO)
LOCAL  TELA,GETLIST:={}
local nCurRec, nQtdNotas, mpagrec
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CODIGO, SERIE
TELA:=SAVESCREEN()
WINDOW(0,0,22,79)

DBF_CONFIG()
DBF_NOTA()
DBF_NOTA2()
DBF_ESTOQUE()
DBF_CLIFOR()
DBF_TRANSP()
DBF_CFOP()
dbf_pedfat()
dbf_pagrec()
dbf_tecfat()
DO WHILE .T.
   @ 1,1 CLEAR TO 21,78
   CODIGO:=0
   @ 1,2  SAY "Nota      :" GET CODIGO PICT "999999" VALID(SEA_NOTA(CODIGO))
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   codigo := nota->codigo_v
   serie := nota->serie_v
   IF !EMPTY(NOTA->PEDIDO_V)
      @ 1,21 SAY "Pedido : " + NOTA->PEDIDO_V
   ENDIF
   IF !EMPTY(NOTA->FICHA_V)
      @ 1,37 SAY "Ficha de Servico : " + NOTA->FICHA_V
   ENDIF
   IF NOTA->CANCELA_V="S"
      @ 1,62 SAY "Cancelada" COLOR CORTIT
   ENDIF
   CLIFOR->(DBSETORDER(1))
   @ 2,2  SAY "Cliente   : " + IF(CLIFOR->(DBSEEK(NOTA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
   @ 3,1 TO 3,78
   @ 4,2  SAY "C.F.OP.   : " + NOTA->CFOP_V
   @ 5,2  SAY "Transport.: " + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),TRANSP->NOME_V,SPACE(50))
   @ 6,2  SAY "Endere‡o  : " + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v),SPACE(50))
   @ 7,2  SAY "Cidade    : " + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),TRANSP->CIDADE_V,SPACE(50))
   @ 7,46 SAY "Estado  : "   + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),TRANSP->ESTADO_V,SPACE(2))
   @ 8,2  SAY "C.G.C.    : " + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),TRANSP->CGC_V,SPACE(19))
   @ 8,46 SAY "Ins.Est.: "   + IF(TRANSP->(DBSEEK(NOTA->CODTRAN_V)),TRANSP->INSEST_V,SPACE(15))
   @ 9,1 TO 9,78
   @ 10,2  SAY "Frete por Conta : " + NOTA->FRETE_V
   @ 10,22 SAY "Placa do Ve¡culo: " + NOTA->PLACA_V
   @ 10,49 SAY "Estado : " + NOTA->UF_V
   @ 11,2  SAY "Quantidade : " + TRANSFORM(NOTA->QTD_V,"@R 999,999,999.99")
   @ 11,31 SAY "Esp‚cie      : " + NOTA->ESPECIE_V
   @ 12,2  SAY "Marca      : " + NOTA->MARCA_V
   @ 12,31 SAY "N£mero       : " + NOTA->NUMERO_V
   @ 13,2  SAY "Peso Bruto : " + NOTA->PESOBRU_V
   @ 13,31 SAY "Peso L¡quido : " + NOTA->PESOLIQ_V
   @ 14,2  SAY "Dt. Emissao: " + DTOC(NOTA->DATEMI_V)
   @ 14,31 SAY "Data Sa¡da   :" + DTOC(NOTA->DATSAI_V)
   @ 14,56 SAY "Hora Sa¡da :" + NOTA->HORASAI_V
   @ 15,1 TO 15,78
   @ 16,2 SAY "Valor dos Servi‡os  : " + TRANSFORM(NOTA->VALMO_V,"@R 999,999,999.99")
   @ 17,2 SAY "Valor dos Produtos  : " + TRANSFORM(NOTA->VALITOT_V,"@R 999,999,999.99")
   @ 18,2 SAY "Valor Total da Nota : " + TRANSFORM(NOTA->VALITOT_V+NOTA->VALMO_V,"@R 999,999,999.99")
   SETCOLOR(CORTIT)
   @ 19,1 SAY PADC("Faturamento",78)
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   IF !EMPTY(NOTA->DATPAR1_V) .AND. !EMPTY(NOTA->VALPAR1_V)
      @ 20,8 SAY DTOC(NOTA->DATPAR1_V)
      @ 21,2 SAY NOTA->VALPAR1_V PICT "999,999,999.99"
   ENDIF
   IF !EMPTY(NOTA->DATPAR2_V) .AND. !EMPTY(NOTA->VALPAR2_V)
      @ 20,23 SAY DTOC(NOTA->DATPAR2_V)
      @ 21,17 SAY NOTA->VALPAR2_V PICT "999,999,999.99"
   ENDIF
   IF !EMPTY(NOTA->DATPAR3_V) .AND. !EMPTY(NOTA->VALPAR3_V)
      @ 20,38 SAY DTOC(NOTA->DATPAR3_V)
      @ 21,32 SAY NOTA->VALPAR3_V PICT "999,999,999.99"
   ENDIF
   IF !EMPTY(NOTA->DATPAR4_V) .AND. !EMPTY(NOTA->VALPAR4_V)
      @ 20,53 SAY DTOC(NOTA->DATPAR4_V)
      @ 21,47 SAY NOTA->VALPAR4_V PICT "999,999,999.99"
   ENDIF
   IF !EMPTY(NOTA->DATPAR5_V) .AND. !EMPTY(NOTA->VALPAR5_V)
      @ 20,58 SAY DTOC(NOTA->DATPAR5_V)
      @ 21,52 SAY NOTA->VALPAR5_V PICT "999,999,999.99"
   ENDIF
   IF OPCAO="C" .AND. NOTA->CANCELA_V#"S"
      IF CONFIRMA(22,20,"Confirma o Cancelamento Desta Nota Fiscal ?")
         if nota->serie_v != "0"
            aviso("O cancelamento permitido somente para notas serie 0")
            loop
         endif
         IF ! EMPTY(NOTA->PEDIDO_V)
            DBF_PEDIDO()
            PEDIDO->(DBSETORDER(1))
            IF PEDIDO->(DBSEEK(NOTA->PEDIDO_V))
               IF PEDIDO->(RECLOCK(5))
                  PEDIDO->NOTA_V:=0
                  PEDIDO->(DBUNLOCK())
               ENDIF
            ENDIF
            PEDIDO->(DBCLOSEAREA())
         ENDIF
         IF ! EMPTY(NOTA->FICHA_V)
            ELIMINA_NFS(NOTA->NFS_V)
            DBF_TECNICA()
            TECNICA->(DBSETORDER(1))
            IF TECNICA->(DBSEEK(NOTA->FICHA_V))
               IF TECNICA->(RECLOCK(5))
                  TECNICA->NOTA_V:=0
                  TECNICA->NFS_V:=0
                  TECNICA->(DBUNLOCK())
               ENDIF
            ENDIF
            TECNICA->(DBCLOSEAREA())
         ENDIF
         IF NOTA->CODIGO_V=CODIGO .and. NOTA->serie_v=SERIE
            pedfat->(dbsetorder(2), dbseek(nota->pedido_v))
            mpagrec := array(0)
            do while !pedfat->(eof()) .and. pedfat->codigo_v == nota->pedido_v
               if pedfat->datnf_v == nota->datemi_v .and. pedfat->nota_v == nota->codigo_v
                  aadd(mpagrec, pedfat->pagrec_v)
                  if pagrec->(dbsetorder(1), dbseek(pedfat->pagrec_v))
                     pagrec->(reclock(5))
                     pagrec->(dbdelete())
                     pagrec->(dbunlock())
                  endif
               endif
               pedfat->(dbskip())
            enddo
            tecfat->(dbsetorder(2), dbseek(nota->ficha_v))
            mpagrec := array(0)
            do while !tecfat->(eof()) .and. tecfat->codigo_v == nota->ficha_v
               if tecfat->datnf_v == nota->datemi_v .and. tecfat->nota_v == nota->codigo_v
               		aadd(mpagrec, pedfat->pagrec_v)
                  if pagrec->(dbsetorder(1), dbseek(tecfat->pagrec_v))
                     pagrec->(reclock(5))
                     pagrec->(dbdelete())
                     pagrec->(dbunlock())
                  endif
               endif
               tecfat->(dbskip())
            enddo
            IF NOTA->(RECLOCK(5))
               NOTA->CANCELA_V:="S"
               NOTA->(DBUNLOCK())
            ENDIF
            xmig_canc_pagrec(mpagrec)
         ENDIF
      ENDIF
   ELSE
      IF .NOT. EMPTY(NOTA->FICHA_V) .OR. .NOT. EMPTY(NOTA->PEDIDO_V)
         @ 24,0 SAY PADR(" F2 - Mostra Itens",80) COLOR CORTIT
      ENDIF
      DO WHILE .T.
         INKEY(0)
         IF LASTKEY()=27
            EXIT
         ENDIF
         IF .NOT. EMPTY(NOTA->FICHA_V) .OR. .NOT. EMPTY(NOTA->PEDIDO_V)
            IF LASTKEY()=-1
               CONITENF()
            ENDIF
         ENDIF
         IF LASTKEY()=27
            LOOP
         ENDIF
      ENDDO
   ENDIF
ENDDO
tecfat->(dbclosearea())
pedfat->(dbclosearea())
pagrec->(dbclosearea())
CONFIG->(DBCLOSEAREA())
TRANSP->(DBCLOSEAREA())
NOTA2->(DBCLOSEAREA())
NOTA->(DBCLOSEAREA())
ESTOQUE->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
CFOP->(DBCLOSEAREA())
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,22,79)
RETURN(.T.)

FUNCTION CONITENF()
LOCAL  TELA,VARIAVEIS,MASCARAS,TITULOS
MEMVAR CODIGO
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
DO CASE
   CASE !EMPTY(NOTA->PEDIDO_V)
      VARIAVEIS:={"IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->ITEM_V,SPACE(LEN(PEDIDO2->ITEM_V)))",;
                  "IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,IF(ESTOQUE->(DBSEEK(PEDIDO2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                  "IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->VALUNI_V,SPACE(8))","IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->QTD_V,SPACE(8))",;
                  "IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->VALUNI_V*PEDIDO2->QTD_V,SPACE(9))",;
                  "IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->ICMS_V,SPACE(2))",;
                  "IF(PEDIDO2->CODIGO_V=NOTA->PEDIDO_V,PEDIDO2->IPI_V,SPACE(2))" }
      MASCARAS :={,,"@R 999,999.99","@R 999,999.99","@R 9,999,999.99","@R 99 %","99%"}
      TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","Qtd","Vl.Total","ICMS","IPI"}
      DBF_2PEDIDO()
      IF PEDIDO2->(DBSEEK(NOTA->PEDIDO_V))
         TELA:=SAVESCREEN()
         IF NOTA->VALMO_V>0 .OR. !EMPTY(NOTA->LINSERV1_V) .OR. !EMPTY(NOTA->LINSERV2_V) .OR. !EMPTY(NOTA->LINSERV3_V) .OR. !EMPTY(NOTA->LINSERV4_V)
            WINDOW(2,0,7,79)
            @ 2,1 SAY "Descri‡ao dos Servi‡os Prestados" COLOR CORTIT
            @ 3,2 SAY NOTA->LINSERV1_V
            @ 4,2 SAY NOTA->LINSERV2_V
            @ 5,2 SAY NOTA->LINSERV3_V
            @ 6,2 SAY NOTA->LINSERV4_V
         ENDIF
         WINDOW(8,0,24,79)
         PEDIDO2->(DBEDIT(9,1,23,78,VARIAVEIS,,MASCARAS,TITULOS,CHR(220),CHR(219)))
      ELSE
         AVISO("O sistema nao conseguiu encontrar os registros...")
      ENDIF
      PEDIDO2->(DBCLOSEAREA())
   CASE !EMPTY(NOTA->FICHA_V)
      VARIAVEIS:={"IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,TECNICA2->ITEM_V,SPACE(LEN(TECNICA2->ITEM_V)))",;
                  "IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                  "IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,TECNICA2->VALUNI_V,SPACE(8))","IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,TECNICA2->QTD_V,SPACE(8))",;
                  "IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,TECNICA2->VALUNI_V*TECNICA2->QTD_V,SPACE(9))",;
                  "IF(TECNICA2->CODIGO_V=NOTA->FICHA_V,TECNICA2->ICMS_V,SPACE(2))"}
      MASCARAS :={,,"@R 999,999.99","@R 999,999.99","@R 9,999,999.99","@R 99 %"}
      TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","Qtd","Vl.Total","ICMS"}
      DBF_2TECNICA()
      IF TECNICA2->(DBSEEK(NOTA->FICHA_V))
         TELA:=SAVESCREEN()
         IF NOTA->VALMO_V>0
            WINDOW(2,0,7,79)
            @ 2,1 SAY "Descri‡ao dos Servi‡os Prestados" COLOR CORTIT
            @ 3,2 SAY NOTA->LINSERV1_V
            @ 4,2 SAY NOTA->LINSERV2_V
            @ 5,2 SAY NOTA->LINSERV3_V
            @ 6,2 SAY NOTA->LINSERV4_V
         ENDIF
         WINDOW(8,0,24,79)
         TECNICA2->(DBEDIT(9,1,23,78,VARIAVEIS,,MASCARAS,TITULOS,CHR(220),CHR(219)))
      ELSE
         AVISO("O sistema nao conseguiu encontrar os registros...")
      ENDIF
      TECNICA2->(DBCLOSEAREA())
ENDCASE
RESTSCREEN(,,,,TELA)
CLOSEWIN(8,0,24,79)
RETURN(.T.)

FUNCTION ELIMINA_NFS(NFS)
local nCurRec := nota->(recno())
if (nota->(dbsetorder(1), dbseek(str(nfs,6)+"A")))
   nota2->(dbsetorder(2), dbseek(str(nfs,6)+"A"))
   do while !nota2->(eof()) .and. str(nota2->codigo_v,6)+nota2->serie_v == str(nota->codigo_v,6)+nota->serie_v
      nota2->(reclock(5))
      nota2->(dbdelete(), dbunlock())
      nota2->(dbskip())
   enddo
   nota->(reclock(5))
   nota->(dbdelete())
   nota->(dbunlock())
endif
nota->(dbgoto(nCurRec))
RETURN