FUNCTION CLIFOR(OPCAO)
LOCAL OP,TELA,TELA1,i,aTabelas := {}, tipoacesso := if(opcao=="C","1","2")
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
MEMVAR SYSVEN,BLQVEN

*** VARIAVEIS PARA CADASTRO CLIENTES/FORNECEDORES
MEMVAR CODIGO,NOME,FANTASIA,ENDERECO,BAIRRO,CIDADE,ESTADO,CEP,FONE1,FONE2,FAX
MEMVAR ENDCOB,BAICOB,CIDCOB,ESTCOB,CEPCOB,FONECOB1,FONECOB2,FAXCOB,CLIFOR
MEMVAR CGCCPF,RGINSEST,CONTATO,REFERE1,REFERE2,TELREF1,TELREF2,REVENDA,INSMUN
MEMVAR ENDENT,BAIENT,CIDENT,ESTENT,CEPENT,FONEENT1,FONEENT2,FAXENT,CODTRAN
MEMVAR MIDIA,EMAIL,EMAILNF,DATCAD,MECVEN,OBS,OBS1,PESSOA, NUMERO, COMPLEM, NUMCOB, COMPCOB, NUMENT, COMPENT
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(22,0,24,68)
WINDOW(2,0,22,79)
@ 23,68 SAY CHR(219)
IF SELECT("CONFIG") == 0
   DBF_CONFIG()
   aadd(aTabelas,"CONFIG")
ENDIF
IF SELECT("CLIFOR") == 0
   DBF_CLIFOR()
   aadd(aTabelas,"CLIFOR")
ENDIF
IF SELECT("TRANSP") == 0
   DBF_TRANSP()
   aadd(aTabelas,"TRANSP")
ENDIF
IF SELECT("MIDIA") == 0
   DBF_MIDIA()
   aadd(aTabelas,"MIDIA")
ENDIF
IF SELECT("MECVEN") == 0
   DBF_MECVEN()
   aadd(aTabelas,"MECVEN")
ENDIF
IF SELECT("PEDIDO") == 0
   DBF_PEDIDO()
   aadd(aTabelas,"PEDIDO")
ENDIF
IF SELECT("CADCID") == 0
   DBF_CADCID()
   aadd(aTabelas,"CADCID")
ENDIF

DO CASE
   CASE OPCAO="C"
      @ 2,1 SAY "Clientes" COLOR CORTIT
      CLIFOR:="C"
   CASE OPCAO="F"
      @ 2,1 SAY "Fornecedores" COLOR CORTIT
      CLIFOR:="F"
   CASE OPCAO="E"
      @ 2,1 SAY "Eventos" COLOR CORTIT
      CLIFOR:="E"
ENDCASE
CODIGO:=CLIFOR
CLIFOR->(DBSEEK(CODIGO,.T.))
DO WHILE .T.
   REVENDA :=CLIFOR->REVENDA_V
   CODIGO  :=CLIFOR->CODIGO_V
   NOME    :=CLIFOR->NOME_V
   CGCCPF  :=CLIFOR->CGCCPF_V
   RGINSEST:=CLIFOR->RGINSEST_V
   INSMUN  :=CLIFOR->INSMUN_V
   FANTASIA:=CLIFOR->FANTASIA_V
   EMAIL   :=CLIFOR->EMAIL_V
   EMAILNF :=CLIFOR->EMAILNF_V
   ENDERECO:=CLIFOR->ENDERECO_V
   NUMERO  :=CLIFOR->NUMERO_V
   COMPLEM :=CLIFOR->COMPLEM_V
   BAIRRO  :=CLIFOR->BAIRRO_V
   CIDADE  :=CLIFOR->CIDADE_V
   ESTADO  :=CLIFOR->ESTADO_V
   CEP     :=CLIFOR->CEP_V
   FONE1   :=CLIFOR->FONE1_V
   FONE2   :=CLIFOR->FONE2_V
   FAX     :=CLIFOR->FAX_V
   REFERE1 :=CLIFOR->REFERE1_V
   TELREF1 :=CLIFOR->TELREF1_V
   REFERE2 :=CLIFOR->REFERE2_V
   TELREF2 :=CLIFOR->TELREF2_V
   ENDCOB  :=CLIFOR->ENDCOB_V
   NUMCOB  :=CLIFOR->NUMCOB_V
   COMPCOB :=CLIFOR->COMPCOB_V
   BAICOB  :=CLIFOR->BAICOB_V
   CIDCOB  :=CLIFOR->CIDCOB_V
   ESTCOB  :=CLIFOR->ESTCOB_V
   CEPCOB  :=CLIFOR->CEPCOB_V
   FONECOB1:=CLIFOR->FONECOB1_V
   FONECOB2:=CLIFOR->FONECOB2_V
   FAXCOB  :=CLIFOR->FAXCOB_V
   DATCAD  :=CLIFOR->DATCAD_V
   ENDENT  :=CLIFOR->ENDENT_V
   NUMENT  :=CLIFOR->NUMENT_V
   COMPENT :=CLIFOR->COMPENT_V
   BAIENT  :=CLIFOR->BAIENT_V
   CIDENT  :=CLIFOR->CIDENT_V
   ESTENT  :=CLIFOR->ESTENT_V
   CEPENT  :=CLIFOR->CEPENT_V
   FONEENT1:=CLIFOR->FONEENT1_V
   FONEENT2:=CLIFOR->FONEENT2_V
   FAXENT  :=CLIFOR->FAXENT_V
   CODTRAN :=CLIFOR->CODTRAN_V
   CONTATO :=CLIFOR->CONTATO_V
   MIDIA   :=CLIFOR->MIDIA_V
   MECVEN  :=CLIFOR->CODVEN_V
   OBS     :=CLIFOR->OBS_V
   OBS1    :=CLIFOR->OBS1_V
   PESSOA  :=CLIFOR->PESSOA_V
   SETCOLOR(CORTEX)
   @ 03,1   CLEAR TO 21,78
   @ 03,02 SAY "C¢digo   : " + CODIGO
   @ 03,32 SAY "Pessoa : " + PESSOA
   IF OPCAO="C"
      @ 03,20 SAY "Revenda : "  + REVENDA
      @ 03,43 SAY "Vendedor : " + MECVEN+' '+IF(MECVEN->(DBSEEK(MECVEN)),LEFT(MECVEN->NOME_V,17),SPACE(17))
   ENDIF
   @ 04,02 SAY "CGC / CPF: " + CGCCPF
   @ 04,32 SAY "RG/I.Est.: " + RGINSEST
   @ 04,58 SAY "IM:" + INSMUN
   @ 05,02 SAY "Nome     : " + NOME
   @ 06,02 SAY "Fantasia : " + FANTASIA
   @ 07,02 SAY "Obs.     : " COLOR(IF(EMPTY(OBS) .AND. EMPTY(OBS1),CORTEX,CORTIT))
   @ 07,13 SAY OBS
   @ 08,13 SAY OBS1
   @ 09,02 SAY "Endereco : " + LEFT(ENDERECO,35)
   @ 09,49 SAY "N.: " + NUMERO
   @ 09,60 say "Compl.: " + COMPLEM
   @ 10,02 SAY "Bairro   : " + BAIRRO
   @ 11,02 SAY "Cidade   : " + CIDADE
   @ 11,45 SAY "Estado : "   + ESTADO
   @ 11,57 SAY "C.E.P.: "    + TRANSFORM(CEP,"@R 99999-999")
   @ 12,02 SAY "Fone1    : " + TRANSFORM(FONE1,"@R (#99) ###99-9999")
   @ 12,30 SAY "Fone2: "     + TRANSFORM(FONE2,"@R (#99) ###99-9999")
   @ 12,54 SAY "Fax: "       + TRANSFORM(FAX,"@R (#99) ###99-9999")
   @ 13,02 SAY "Contato  : " + CONTATO
   @ 14,02 SAY "Referen.1: " + REFERE1
   @ 14,55 SAY "Fone : "     + TRANSFORM(TELREF1,"@R (#99) ###99-9999")
   @ 15,02 SAY "Referen.2: " + REFERE2
   @ 15,55 SAY "Fone : "     + TRANSFORM(TELREF2,"@R (#99) ###99-9999")
   @ 16,01 TO 16,78
   @ 17,1 SAY PADC("Dados Para Cobran‡a",78) COLOR CORTIT
   @ 18,02 SAY "Endereco : " + ENDCOB
   @ 18,49 SAY "N.: " + NUMCOB
   @ 18,60 say "Compl.: " + COMPCOB
   @ 19,2   SAY "Bairro   : " + BAICOB
   @ 20,2   SAY "Cidade   : " + CIDCOB
   @ 20,45  SAY "Estado : "   + ESTCOB
   @ 20,57  SAY "C.E.P.: "    + TRANSFORM(CEPCOB,"@R 99999-999")
   @ 21,2   SAY "Fone1    : " + TRANSFORM(FONECOB1,"@R (#99) ###99-9999")
   @ 21,30  SAY "Fone2: "     + TRANSFORM(FONECOB2,"@R (#99) ###99-9999")
   @ 21,54  SAY "Fax: "       + TRANSFORM(FAXCOB,"@R (#99) ###99-9999")
   SETCOLOR(CORTEX+","+CORBAR)
   IF BLQVEN = "S" .AND. CLIFOR->CODVEN_V<>SYSVEN .AND. OPCAO="C"
      SCROLL(06,01,21,78)
      @ 06,1 SAY PADC("Vocˆ nao tem acesso a este cliente...",78)
   ENDIF
   @ 23,1  PROMPT " Incluir "
   @ 23,10 PROMPT " Buscar "
   @ 23,18 PROMPT " Alterar "
   @ 23,27 PROMPT " Apagar "
   @ 23,35 PROMPT " Texto "
   @ 23,42 PROMPT " Lista Negra "
   @ 23,55 PROMPT " Complemento "
   MENU TO OP
   IF BLQVEN = "S" .AND. CLIFOR->CODVEN_V<>SYSVEN .AND. OP>2 .AND. LASTKEY()<>27 .AND. OPCAO="C"
      AVISO("Vocˆ nao tem acesso a este cliente...")
      LOOP
   ENDIF
   DO CASE
      CASE OP=1
         if acccom("1"+tipoacesso+"1",.t.)
            @ 04,02 SAY "CGC / CPF: "
            @ 04,32 SAY "RG/I.Est.: "
            @ 07,02 SAY "Obs.     : "
            @ 09,02 SAY "Endereco : "
            @ 09,49 SAY "N.: "
            @ 09,60 say "Compl.: "
            @ 10,02 SAY "Bairro   : "
            @ 11,02 SAY "Cidade   : "
            @ 11,45 SAY "Estado : "
            @ 11,57 SAY "C.E.P.: "
            @ 12,02 SAY "Fone1    : "
            @ 12,30 SAY "Fone2: "
            @ 12,54 SAY "Fax: "
            @ 13,02 SAY "Contato  : "
            @ 14,02 SAY "Referen.1: "
            @ 14,55 SAY "Fone : "
            @ 15,02 SAY "Referen.2: "
            @ 15,55 SAY "Fone : "
            @ 16,01 TO 16,78
            @ 17,1 SAY PADC("Dados Para Cobranca",78) COLOR CORTIT
            @ 18,02 SAY "Endereco : "
            @ 18,49 SAY "N.: "
            @ 18,60 say "Compl.: "
            @ 19,2   SAY "Bairro   : "
            @ 20,2   SAY "Cidade   : "
            @ 20,45  SAY "Estado : "
            @ 20,57  SAY "C.E.P.: "
            @ 21,2   SAY "Fone1    : "
            @ 21,30  SAY "Fone2: "
            @ 21,54  SAY "Fax: "
            ICLIFOR(OPCAO)
         endif
      CASE OP=2
         BCLIFOR(OPCAO)
      CASE OP=3
         if acccom("1"+tipoacesso+"3",.t.)
            ACLIFOR(OPCAO)
         endif
      CASE OP=4
         if acccom("1"+tipoacesso+"4",.t.)
            ECLIFOR(OPCAO)
         endif
      CASE OP=5
         if acccom("1"+tipoacesso+"5",.t.)
            TELA1:=SAVESCREEN(0,0,24,80)
            WINDOW(5,0,20,79)
            @ 6,2 SAY PADC(ALLTRIM(NOME),76) COLOR CORTIT
            @ 7,1 TO 7,78
            SETCOLOR("N/W")
            IF CLIFOR->(RECLOCK(5))
               CLIFOR->TEXTO_V:=MEMOEDIT(CLIFOR->TEXTO_V,8,2,19,77,.T.,"MemoFunction")
               CLIFOR->(DBUNLOCK())
            ELSE
               AVISO("Existe Outro Usuario Utilizando Este Registro , Tente Mais Tarde ...")
            ENDIF
            RESTSCREEN(0,0,24,80,TELA1)
         endif
      CASE OP=6
         if acccom("1"+tipoacesso+"6",.t.)
            TELA1:=SAVESCREEN(0,0,24,80)
            WINDOW(5,0,20,79)
            @ 6,2 SAY PADC("Lista Negra : "+ALLTRIM(NOME),76) COLOR CORTIT
            @ 7,1 TO 7,78
            SETCOLOR("N/W")
            IF CLIFOR->(RECLOCK(5))
               CLIFOR->BLACK_V:=MEMOEDIT(CLIFOR->BLACK_V,8,2,19,77,.T.,"MemoFunction")
               CLIFOR->(DBUNLOCK())
            ELSE
               AVISO("Existe Outro Usuario Utilizando Este Registro , Tente Mais Tarde ...")
            ENDIF
            RESTSCREEN(0,0,24,80,TELA1)
         endif
      CASE OP=7
         @ 05,1 CLEAR TO 21,78
         @ 05,02 SAY "E-Mail   : "+left(CLIFOR->EMAIL_V,65)
         @ 06,02 SAY "E-Mail NF: "+left(CLIFOR->EMAILNF_V,65)
         @ 07,02 SAY "Registrado por   : "+CLIFOR->NOMSEN_V
         @ 08,02 SAY "Data de Cadastro : "+DTOC(CLIFOR->DATCAD_V)
         @ 08,32 SAY "Midia  : " + TRANSFORM(MIDIA,"@ 99")+" "+ IF(MIDIA->(DBSEEK(MIDIA)),MIDIA->NOME_V,SPACE(LEN(MIDIA->NOME_V)))
         @ 09,02 SAY "Ultima Compra    : "+DTOC(CLIFOR->DATPED_V)+" Pedido : "+CLIFOR->ULTPED_V+" Valor :"+TRANSFORM(IF(PEDIDO->(DBSETORDER(1),DBSEEK(CLIFOR->ULTPED_V)),PEDIDO->VALTOT_V,CLIFOR->VALPED_V),"@R 999,999.99")
         @ 10,02 SAY "Maior Compra     : "+DTOC(CLIFOR->DATMAI_V)+" Pedido : "+CLIFOR->PEDMAI_V+" Valor :"+TRANSFORM(IF(PEDIDO->(DBSETORDER(1),DBSEEK(CLIFOR->PEDMAI_V)),PEDIDO->VALTOT_V,CLIFOR->VALMAI_V),"@R 999,999.99")
         if opcao="C"
            @ 11,02 SAY "Ultimo Servi‡o   : "+DTOC(CLIFOR->DATTEC_V)+" Ficha  : "+CLIFOR->ULTTEC_V
            @ 12,01 TO 12,78
            @ 13,02 SAY "Transportadora   : " + STRZERO(CODTRAN,5,0)+" "+IF(TRANSP->(DBSEEK(CODTRAN)),TRANSP->NOME_V,SPACE(50))
            @ 15,1 SAY PADC("Dados Para Entrega",78) COLOR CORTIT
            @ 16,02 SAY "Endereco : " + ENDENT
            @ 16,49 SAY "N.: " + NUMENT
            @ 16,60 say "Compl.: " + COMPENT
            @ 17,2   SAY "Bairro   : " + BAIENT
            @ 18,2   SAY "Cidade   : " + CIDENT
            @ 18,45  SAY "Estado : "   + ESTENT
            @ 18,57  SAY "C.E.P.: "    + TRANSFORM(CEPENT,"@R 99999-999")
            @ 19,2   SAY "Fone1    : " + TRANSFORM(FONEENT1,"@R (#99) ###99-9999")
            @ 19,30  SAY "Fone2: "     + TRANSFORM(FONEENT2,"@R (#99) ###99-9999")
            @ 19,54  SAY "Fax: "       + TRANSFORM(FAXENT,"@R (#99) ###99-9999")
         endif
         INKEY(0)
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
for i := 1 to len(aTabelas)
   (aTabelas[i])->(dbclosearea())
next
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(1,0,20,79)
RETURN(.T.)

FUNCTION CLIFORCOPY()
MEMVAR COB,ENT
MEMVAR ENDERECO,NUMERO,COMPLEM,BAIRRO,CIDADE,ESTADO,CEP,FONE1,FONE2,FAX
MEMVAR ENDCOB  ,NUMCOB,COMPCOB,BAICOB,CIDCOB,ESTCOB,CEPCOB,FONECOB1,FONECOB2,FAXCOB
MEMVAR ENDENT  ,NUMENT,COMPENT,BAIENT,CIDENT,ESTENT,CEPENT,FONEENT1,FONEENT2,FAXENT,CODTRAN
IF COB=0
   ENDCOB  :=ENDERECO
   NUMCOB  :=NUMERO
   COMPCOB :=COMPLEM
   BAICOB  :=BAIRRO
   CIDCOB  :=CIDADE
   ESTCOB  :=ESTADO
   CEPCOB  :=CEP
   FONECOB1:=FONE1
   FONECOB2:=FONE2
   FAXCOB  :=FAX
ENDIF
IF ENT=0
   ENDENT  :=ENDERECO
   BAIENT  :=BAIRRO
   NUMENT  :=NUMERO
   COMPENT :=COMPLEM
   CIDENT  :=CIDADE
   ESTENT  :=ESTADO
   CEPENT  :=CEP
   FONEENT1:=FONE1
   FONEENT2:=FONE2
   FAXENT  :=FAX
ENDIF
RETURN(.T.)