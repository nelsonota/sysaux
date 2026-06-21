FUNCTION MENUNF()
LOCAL  TELA,OP,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR CODIGO,FICHA

TELA:=SAVESCREEN()
DBF_CONFIG()
DBF_CLIFOR()
DBF_NOTA()
DBF_NOTA2()
dbf_caduf()
dbf_cadcid()
dbf_cfop()
DBF_ESTOQUE()
DBF_BASCAL()
dbf_pedfat()
dbf_transp()
WINDOW(0,0,24,79)
@ 0,1 SAY "Nota Fiscal para :" COLOR CORTIT
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 1,01 PROMPT " Vendas "
   @ 1,09 PROMPT " Assistencia Tecnica "
   @ 1,30 PROMPT " Servico "
   @ 1,45 PROMPT " Nota de Entrada "
   @ 2,1 TO 2,78
   MENU TO OP
   DO CASE
	   CASE OP=1
         DBF_PAGREC()
         DBF_PEDIDO()
         DBF_2PEDIDO()
         DO WHILE .T.
            CODIGO:=SPACE(LEN(PEDIDO->CODIGO_V))
            @ 3,2 SAY "Codigo          :" GET CODIGO pict "@!" VALID(SEA_PEDIDO(CODIGO,"V"))
            @ 4,1  TO 4,78
            READ
            IF LASTKEY()=27
               PEDIDO->(DBCLOSEAREA())
               PEDIDO2->(DBCLOSEAREA())
               PAGREC->(DBCLOSEAREA())
               @ 1,1 CLEAR TO 23,78
               EXIT
            ENDIF
            IF EMPTY(PEDIDO->DATBAI_V)
               AVISO("Este pedido precisa ser baixado e fechado primeiro...")
               LOOP
            ENDIF
            IF EMPTY(PEDIDO->DATPAG_V)
               AVISO("Este pedido precisa ser fechado primeiro...")
               LOOP
            ENDIF
            IF ! EMPTY(PEDIDO->NOTA_V)
               AVISO("Ja foi emitida Nota Fiscal para este pedido : NF "+STRZERO(PEDIDO->NOTA_V,6,0))
               LOOP
            ENDIF
            @ 3,2 SAY IF(PEDIDO->TIPO_V="D","Venda Direta    ","Venda por Pedido") COLOR CORTIT
            @ 5,2  SAY "Cliente   : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
            @ 6,2  SAY "Endereco  : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
            @ 7,2  SAY "Bairro    : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->BAIRRO_V,SPACE(30))
            @ 7,45 SAY "C.E.P. :"+ IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-9"),SPACE(9))
            @ 8,2  SAY "Cidade    : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->CIDADE_V,SPACE(30))
            @ 8,45 SAY "Estado :"+ IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
            @ 9,2  SAY "Telefone  : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) #9999-9999"),SPACE(15))
            @ 9,45 SAY "CGC/CPF:"+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(18))
            @ 10,2 SAY "RG/Ins.Est.: "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
            @ 11,1 TO 11,78
            @ 12,2 SAY "Data de Emissao : "+DTOC(PEDIDO->DATEMI_V)
            @ 13,2 SAY "Mao de Obra     : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999,999.99")
            @ 14,2 SAY "Valor dos Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999,999.99")
            @ 15,2 SAY "Valor Total     : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999,999.99")
            IF CONFIRMA(20,10,"Confirma a Emissao de Nota Fiscal para este Pedido ?")
               NF(CODIGO)
            ENDIF
            @ 5,1 CLEAR TO 23,78
         ENDDO
      CASE OP=2
         DBF_TECNICA()
         DBF_2TECNICA()
         DBF_TECFAT()
         DO WHILE .T.
            FICHA:=SPACE(LEN(TECNICA->CODIGO_V))
            @ 3,2 SAY "C¢digo          :" GET FICHA VALID(SEA_FICHA(FICHA))
            @ 4,1  TO 4,78
            READ
            IF LASTKEY()=27
               TECNICA->(DBCLOSEAREA())
               TECNICA2->(DBCLOSEAREA())
               tecfat->(dbclosearea())
               @ 1,1 CLEAR TO 23,78
               EXIT
            ENDIF
            @ 5,2   SAY "Cliente    : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
            @ 6,2   SAY "Endereco   : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
            @ 7,2   SAY "RG/Ins.Est.: "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
            @ 7,45  SAY "CGC/CPF: "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(18))
            @ 8,2   SAY "Fone1: " + IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) ###99-9999"),SPACE(16))
            @ 8,29  SAY "Fone2: " + IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE2_V,"@R (#99) ###99-9999"),SPACE(16))
            @ 8,56  SAY "Fax: "       + IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FAX_V,"@R (#99) ###99-9999"),SPACE(16))
            @ 09,2  SAY "Contato    : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CONTATO_V,SPACE(50))
            @ 10,1  TO  10,78
            @ 11,2  SAY "Servi‡o para: "+TRIM(TECNICA->ITEM_V)+" "+TRIM(TECNICA->MARCA_V)+" "+TRIM(TECNICA->MODELO_V)+" "+TRIM(TECNICA->PLACA_V)+" "+TRIM(TECNICA->NSERIE_V)
            @ 12,33 SAY IF(TECNICA->ORCAMENT_V="S","Passar Or‡amento","Executar Direto")
            @ 13,2  SAY "Mao de Obra : "+TRANSFORM(TECNICA->VALMO_V,"@R 999,999,999.99")
            @ 13,36 SAY "Vl.dos Itens: "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999,999.99")
            @ 14,02 SAY "Terceiros   : "+TRANSFORM(TECNICA->VALTERC_V,"@R 999,999,999.99")
            @ 14,36 SAY "Outros      : " +TRANSFORM(TECNICA->VALOUTRO_V,"@R 999,999,999.99")
            @ 15,2  SAY "Valor Total : "+TRANSFORM(TECNICA->VALMO_V+TECNICA->VALOUTRO_V+TECNICA->VALTERC_V+TECNICA->VALITOT_V,"@R 999,999,999.99")
            IF !EMPTY(TECNICA->NOTA_V)
               AVISO("J  foi emitida a Nota Fiscal desta ficha : NF "+STRZERO(TECNICA->NOTA_V,6,0))
               LOOP
            ENDIF
            IF EMPTY(TECNICA->DATSAI_V)
               AVISO("Imposs¡vel emitir a Nota Fiscal sem que a ficha tenha sido finalizada...")
               LOOP
            ENDIF
            @ 16,1  TO 16,78
            IF CONFIRMA(18,20,"Confirma a ficha ?")
               TECNF(FICHA)
            ENDIF
         ENDDO
      CASE OP=3
         alert("Opcao indisponivel")
         //NFSERV()
      CASE OP=4
         DBF_PAGREC()
         DBF_PEDIDO()
         DBF_2PEDIDO()
         DO WHILE .T.
            CODIGO:=SPACE(LEN(PEDIDO->CODIGO_V))
            @ 3,2 SAY "C¢digo          :" GET CODIGO VALID(SEA_PEDIDO(CODIGO,"C"))
            @ 4,1  TO 4,78
            READ
            IF LASTKEY()=27
               PEDIDO->(DBCLOSEAREA())
               PEDIDO2->(DBCLOSEAREA())
               pedfat->(dbclosearea())
               PAGREC->(DBCLOSEAREA())
               @ 1,1 CLEAR TO 23,78
               EXIT
            ENDIF
            IF EMPTY(PEDIDO->DATBAI_V)
               AVISO("Este pedido precisa ser baixado e fechado primeiro...")
               LOOP
            ENDIF
            IF EMPTY(PEDIDO->DATPAG_V)
               AVISO("Este pedido precisa ser fechado primeiro...")
               LOOP
            ENDIF
            IF ! EMPTY(PEDIDO->NOTA_V)
               AVISO("J  foi emitida Nota Fiscal para este pedido : NF "+STRZERO(PEDIDO->NOTA_V,6,0))
               LOOP
            ENDIF
            @ 3,2 SAY IF(PEDIDO->TIPO_V="D","Venda Direta    ","Venda por Pedido") COLOR CORTIT
            @ 5,2  SAY "Cliente   : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
            @ 6,2  SAY "Endereco  : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),alltrim(CLIFOR->ENDERECO_V)+" "+alltrim(clifor->numero_v)+" "+alltrim(clifor->complem_v),SPACE(50))
            @ 7,2  SAY "Bairro    : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->BAIRRO_V,SPACE(30))
            @ 7,45 SAY "C.E.P. :"+ IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),TRANSFORM(CLIFOR->CEP_V,"@R 99999-9"),SPACE(9))
            @ 8,2  SAY "Cidade    : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->CIDADE_V,SPACE(30))
            @ 8,45 SAY "Estado :"+ IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->ESTADO_V,SPACE(2))
            @ 9,2  SAY "Telefone  : "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#99) #9999-9999"),SPACE(15))
            @ 9,45 SAY "CGC/CPF:"+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->CGCCPF_V,SPACE(18))
            @ 10,2 SAY "RG/Ins.Est.: "+IF(CLIFOR->(DBSEEK(PEDIDO->CLIFOR_V)),CLIFOR->RGINSEST_V,SPACE(15))
            @ 11,1 TO 11,78
            @ 12,2 SAY "Data de Emissao : "+DTOC(PEDIDO->DATEMI_V)
            @ 13,2 SAY "Mao de Obra     : "+TRANSFORM(PEDIDO->VALMO_V,"@R 999,999,999.99")
            @ 14,2 SAY "Valor dos Itens : "+TRANSFORM(PEDIDO->VALTOT_V,"@R 999,999,999.99")
            @ 15,2 SAY "Valor Total     : "+TRANSFORM(PEDIDO->VALTOT_V+PEDIDO->VALMO_V,"@R 999,999,999.99")
            IF CONFIRMA(20,10,"Confirma a Emissao de Nota Fiscal para este Pedido ?")
               *NFENT(CODIGO)
            ENDIF
            @ 5,1 CLEAR TO 23,78
         ENDDO
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
cfop->(dbclosearea())
caduf->(dbclosearea())
cadcid->(dbclosearea())
CONFIG->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
NOTA->(DBCLOSEAREA())
nota2->(dbclosearea())
ESTOQUE->(DBCLOSEAREA())
BASCAL->(DBCLOSEAREA())
transp->(dbclosearea())
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,24,79)
RETURN(.T.)

FUNCTION NF1()
@ 4,2  SAY "Endereco  : " + alltrim(TRANSP->ENDERECO_V)+" "+alltrim(transp->numero_v)+" "+alltrim(transp->complem_v)
@ 5,2  SAY "Cidade    : " + TRANSP->CIDADE_V
@ 5,46 SAY "Estado  : "   + TRANSP->ESTADO_V
@ 6,2  SAY "C.G.C.    : " + TRANSP->CGC_V
@ 6,46 SAY "Ins.Est.: "   + TRANSP->INSEST_V
RETURN(.T.)