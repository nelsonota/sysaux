FUNCTION CONFIG()
LOCAL OPCOES,OP,TELA,TELA1
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(7,43,19,77)
DO WHILE .T.
   OPCOES:={"  Cores do Usu rio               ",;
            "  Chaves do Sistema              ",;
            "  Limpeza dos DBF's              ",;
            "  Mensagem do Boleto             ",;
            "  Informa‡oes Gerais             ",;
            "  Rodap‚ Or‡amento               ",;
            "  Recomenda‡ao na Ficha de Sa¡da ",;
            "  Aviso a Ficha de Sa¡da         ",;
            "  Recontagem Estoque Reservado   ",;
            "  Zerar o estoque                ",;
            "  Configurar servidor email      " }
   OP:=ACHOICE(8,44,18,76,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         CORES()         
      CASE OP=2
         KEYS()
      CASE OP=3
         ALERT("Nesta op‡ao ‚ necess rio nao ter nenhum outro micro ligado no sistema ...")
         IF ! CONFIRMA(15,10,"Inicializar limpeza de banco de dados ?")
            LOOP
         ENDIF
         CLEANDBF()
      CASE OP=4
         MENBOLET()
      CASE OP=5
         DBF_CONFIG()
         TELA1:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         @ 6,2 SAY PADC(ALLTRIM("Informa‡oes Gerais da Empresa"),76) COLOR CORTIT
         @ 7,1 TO 7,78
         IF CONFIG->(RECLOCK(5))
            SETCOLOR("N/W")
            CONFIG->INFGER_V:=MEMOEDIT(CONFIG->INFGER_V,8,1,19,78,.T.,"MemoFunction")
            SETCOLOR(CORTEX+","+CORBAR)
            CONFIG->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA1)
         CONFIG->(DBCLOSEAREA())
      CASE OP=6
         DBF_CONFIG()
         TELA1:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         @ 6,2 SAY PADC(ALLTRIM("Rodap‚ do Or‡amento"),76) COLOR CORTIT
         @ 7,1 TO 7,78
         IF CONFIG->(RECLOCK(5))
            SETCOLOR("N/W")
            CONFIG->TEXTORC_V:=MEMOEDIT(CONFIG->TEXTORC_V,8,1,19,78,.T.,"MemoFunction")
            SETCOLOR(CORTEX+","+CORBAR)
            CONFIG->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA1)
         CONFIG->(DBCLOSEAREA())
      CASE OP=7
         DBF_CONFIG()
         TELA1:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         @ 6,2 SAY PADC(ALLTRIM("Recomenda‡ao ao Cliente na Ficha de Sa¡da"),76) COLOR CORTIT
         @ 7,1 TO 7,78
         IF CONFIG->(RECLOCK(5))
            SETCOLOR("N/W")
            CONFIG->RECOSAI_V:=MEMOEDIT(CONFIG->RECOSAI_V,8,1,19,78,.T.,"MemoFunction")
            SETCOLOR(CORTEX+","+CORBAR)
            CONFIG->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA1)
         CONFIG->(DBCLOSEAREA())
      CASE OP=8
         DBF_CONFIG()
         TELA1:=SAVESCREEN(0,0,24,80)
         WINDOW(5,0,20,79)
         @ 6,2 SAY PADC(ALLTRIM("Aviso ao Cliente na Ficha de Sa¡da"),76) COLOR CORTIT
         @ 7,1 TO 7,78
         IF CONFIG->(RECLOCK(5))
            SETCOLOR("N/W")
            CONFIG->AVISAI_V:=MEMOEDIT(CONFIG->AVISAI_V,8,1,19,78,.T.,"MemoFunction")
            SETCOLOR(CORTEX+","+CORBAR)
            CONFIG->(DBUNLOCK())
         ELSE
            AVISO("Existe Outro Usu rio Utilizando Este Registro , Tente Mais Tarde ...")
         ENDIF
         RESTSCREEN(0,0,24,80,TELA1)
         CONFIG->(DBCLOSEAREA())
      CASE OP=9
         DBF_ESTOQUE()
         DBF_PEDIDO()
         DBF_2PEDIDO()
         ESTOQUE->(DBGOTOP())
         DO WHILE .NOT. ESTOQUE->(EOF())
            ESTOQUE->(RECLOCK(5))
            ESTOQUE->RESERVA_V := 0
            ESTOQUE->(DBCOMMIT())
            PEDIDO2->(DBSETORDER(2),DBSEEK(ESTOQUE->CODIGO_V))
            DO WHILE PEDIDO2->ITEM_V==ESTOQUE->CODIGO_V .AND. .NOT. PEDIDO2->(EOF())
               IF PEDIDO->(DBSETORDER(1),DBSEEK(PEDIDO2->CODIGO_V)) .AND. EMPTY(PEDIDO->DATBAI_V) .AND. EMPTY(PEDIDO->DATPAG_V)
                  ESTOQUE->(RECLOCK(5))
                  ESTOQUE->RESERVA_V += PEDIDO2->QTD_V
                  ESTOQUE->(DBCOMMIT(),DBUNLOCK())
               ENDIF
               PEDIDO2->(DBSKIP())
            ENDDO
            ESTOQUE->(DBSKIP())
         ENDDO
         ESTOQUE->(DBCLOSEAREA())
         PEDIDO->(DBCLOSEAREA())
         PEDIDO2->(DBCLOSEAREA())
      CASE OP=10
         if acccom('000006')
            zera_estoque()
         endif
      CASE OP=11
         configmail()
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(7,43,16,77)
RETURN(.T.)

function zera_estoque()
local opcao := "N", tela := savescreen(), getlist := {}
memvar clifor
dbf_clifor()
dbf_estoque()
dbf_movest()
window(10,15,13,80)
clifor := space(len(clifor->codigo_v))
@ 11,17 say "Zerar todo o estoque: " get opcao pict "!" valid opcao$"SN"
@ 12,17 say "Fornecedor :" get clifor pict "@!" VALID(LASTKEY()=5 .OR. SEA_CLIFOR(CLIFOR,12,38,"F"))
read
IF lastkey()<> 27 .and. CONFIRMA(20,20,"Tem certeza que deseja zerar o estoque ?")
   IF SENHA2(20,15,'000006')
      ESTOQUE->(DBGOTOP())
      DO WHILE .NOT. ESTOQUE->(EOF())
         if opcao == "S" .or. estoque->clifor_v == clifor .and. estoque->qtd_v<>0
            tipo = if(ESTOQUE->QTD_V>0,"S","E")
            movest(tipo, ESTOQUE->codigo_V, if(tipo="E","OE","OS"), abs(ESTOQUE->QTD_V), "ZERAESTOQU", estoque->valcus_v)
         endif
         estoque->(dbskip())
      ENDDO
      aviso("Estoque zerado com sucesso!")
   ENDIF
ENDIF
clifor->(dbclosearea())
movest->(dbclosearea())
ESTOQUE->(DBCLOSEAREA())
restscreen(,,,,tela)
return