FUNCTION ORCAMENT()
LOCAL  TELA,OP,TELA2,VARIAVEIS,MASCARAS,TITULOS
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN

MEMVAR FICHA,RECEBE,CLIFOR,DATENT,ORCAMENT,DATORC,GETLIST
MEMVAR DATAPR,DATEXE,DATEXE2,DATSAI,MECVEN,GARANTIA,VALMO,VALITOT,NOTA

MEMVAR VALOR,QTD,ICMS,XITEM,BASCAL,TBASCAL
MEMVAR ITEM,T_VALUNI,T_QTD,T_ICMS,CONT,T_BASCAL,O_BASCAL
MEMVAR T_TBASCAL,O_TBASCAL,VALOUTRO,VALTERC,M1,S,U
M1:="@R 999,999.99"
S:=SPACE(1)
U:="U"
TELA:=SAVESCREEN()
WINDOW(0,0,24,79)
DBF_MOEDA()
DBF_BASCAL()
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 1,2 SAY "Ficha : "+FICHA
   @ 1,17 SAY "Cliente : "+IF(CLIFOR->(DBSEEK(CLIFOR)),CLIFOR->NOME_V,SPACE(50))
   @ 2,1 TO 2,78
   O_BASCAL:=100
   O_TBASCAL:=""
   IF EMPTY(TECNICA->DATORC_V)
      IF ! EMPTY(TECNICA->NOTA_V)
         AVISO("Imposs¡vel utilizar esta op‡ao com Nota Fiscal j  emitida...")
         EXIT
      ENDIF
      XITEM    :={}
      VALOR    :={}
      ICMS     :={}
      QTD      :={}
      BASCAL   :={}
      TBASCAL  :={}
      ITEM     :=SPACE(LEN(ESTOQUE->CODIGO_V))
      T_VALUNI :=0
      T_ICMS   :=0
      T_QTD    :=0
      T_BASCAL :=0
      VALITOT  :=0
      T_TBASCAL:=""
      SETCOLOR(CORDES)
      @ 04,02 CLEAR TO 21,13
      @ 04,15 CLEAR TO 21,45
      @ 04,47 CLEAR TO 21,55
      @ 04,57 CLEAR TO 21,64
      @ 04,66 CLEAR TO 21,77   
      CONT:=.T.
      DO WHILE CONT=.T.
         SETCOLOR(CORDES)
      @ 04,02 CLEAR TO 04,13
      @ 04,15 CLEAR TO 04,45
      @ 04,47 CLEAR TO 04,55
      @ 04,57 CLEAR TO 04,64
      @ 04,66 CLEAR TO 04,77
         SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
         @ 22,1 TO 22,78
         @ 03,01 SAY " C¢digo        Descri‡ao            Vl.Unit rio Qtd.         Vl.Total   %ICMS " COLOR CORTIT
         @ 23,01 SAY PADL("Valor Total dos Itens : "+TRANSFORM(VALITOT,"@R 999,999,999.99")+" ",78) COLOR CORTIT
         @ 24,02 SAY "ESC - Cancela Opera‡ao   F2 - Finaliza"
         @ 04,02 GET ITEM PICT "@K!" VALID(SEA_ESTOQUE(ITEM).AND.ORCA1())
         @ 04,47 GET T_VALUNI PICT "@R 99,999.99" VALID(LASTKEY()=5 .OR. T_VALUNI>0 .AND. ORCA2())
         @ 04,57 GET T_QTD    PICT "@R 9,999.99" VALID(LASTKEY()=5 .OR. T_QTD>0 .AND. ORCA2())
         READ
         IF LASTKEY()=27
            IF CONFIRMA(20,20,"Deseja realmente cancelar a opera‡ao ?")
               CONT:=.F.
               SET KEY -1 TO
               EXIT
            ENDIF
            LOOP
         ENDIF
         IF LASTKEY()=18 .OR. LASTKEY()=3
            LOOP
         ENDIF
         IF CONT=.F.
            EXIT
         ENDIF
         IF CONFIRMA(20,20,"Confirma este Item ?")
            AADD(XITEM,ITEM)
            AADD(QTD,T_QTD)
            AADD(VALOR,T_VALUNI)
            AADD(ICMS,T_ICMS)
            AADD(BASCAL,T_BASCAL)
            AADD(TBASCAL,T_TBASCAL)
            VALITOT:=VALITOT+(T_QTD*T_VALUNI)
            SET KEY -1 TO FINALTEC()
            TELA2:=SAVESCREEN(4,1,20,79)
            RESTSCREEN(5,1,21,79,TELA2)
         ENDIF
         ITEM    :=SPACE(LEN(ESTOQUE->CODIGO_V))
         T_QTD   :=0
         T_VALUNI:=0
      ENDDO
   ELSE
      SETCOLOR(CORTIT)
      @ 21,1  CLEAR TO 23,78
      @ 21,2  SAY "T‚cnico     : "+IF(MECVEN->(DBSEEK(MECVEN)),LEFT(MECVEN->NOME_V,10),SPACE(10))
      @ 21,29 SAY "Dt.Or‡amento  : "+DTOC(DATORC)
      @ 22,2  SAY "Mao de Obra : "+TRANSFORM(TECNICA->VALMO_V,"@R 999,999.99")
      @ 22,29 SAY "Terceiros     : "+TRANSFORM(TECNICA->VALTERC_V,"@R 999,999.99")
      @ 23,2  SAY "Outros      : "+TRANSFORM(TECNICA->VALOUTRO_V,"@R 999,999.99")
      @ 23,29 SAY "Valor Itens   : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999.99")
      @ 23,57 SAY "Total: "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V,"@R 999,999,999.99")
      SETCOLOR(CORDES)
      CONT:=.T.
      IF ! EMPTY(TECNICA->DATEXE_V)
         VARIAVEIS:={"IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->ITEM_V,SPACE(14))","IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->VALUNI_V,SPACE(8))","IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->TIPO_V,SPACE(1))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->QTD_V,SPACE(8))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->VALUNI_V*TECNICA2->QTD_V,SPACE(9))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->NF_V,SPACE(1))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),IF(ESTOQUE->MOEDA_V#U,ESTOQUE->VALVEN_V,0),0),SPACE(9))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),IF(ESTOQUE->MOEDA_V=U,ESTOQUE->VALVEN_V,0),0),SPACE(9))"}
         MASCARAS :={,,"@R 99,999.99",,"@R 99,999.99","@R 9,999,999.99",,"@R 9,999,999.99","@R 9,999,999.99"}
         TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","","Qtd","Vl.Total","NF","R$ Vl.Venda","US$ Vl.Venda"}
      ELSE
         VARIAVEIS:={"IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->ITEM_V,SPACE(14))","IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),LEFT(ESTOQUE->NOME_V,20),SPACE(20)),SPACE(20))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->VALUNI_V,SPACE(8))","IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->TIPO_V,SPACE(1))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->QTD_V,SPACE(8))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,TECNICA2->VALUNI_V*TECNICA2->QTD_V,SPACE(9))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),IF(ESTOQUE->MOEDA_V#U,ESTOQUE->VALVEN_V,0),0),SPACE(9))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),IF(ESTOQUE->MOEDA_V=U,ESTOQUE->VALVEN_V,0),0),SPACE(9))",;
                     "IF(TECNICA2->CODIGO_V==TECNICA->CODIGO_V,IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),TRANSFORM(ESTOQUE->QTD_V,M1)+S+TRANSFORM(ESTOQUE->RESERVA_V,M1)+S+TRANSFORM(ESTOQUE->QTD_V-ESTOQUE->RESERVA_V,M1),SPACE(30)),SPACE(30))"}
         MASCARAS :={,,"@R 99,999.99",,"@R 99,999.99","@R 9,999,999.99","@R 9,999,999.99","@R 9,999,999.99",}
         TITULOS  :={"C¢digo","Descri‡ao","Vl.Unit.","","Qtd","Vl.Total","R$ Vl.Venda","US$ Vl.Venda","Qtd. em Estoque Qtd. Reservado Qtd.Real"}
      ENDIF
      TECNICA2->(DBSETORDER(1))
      TECNICA2->(DBSEEK(FICHA))
*      TECNICA2->(DBSETFILTER({||TECNICA2->CODIGO_V==FICHA},"TECNICA2->CODIGO_V==FICHA"))
      @ 24,1 SAY PADR(" INS: Inclui Item  DEL: Exlui Item  ESC: Volta  F2: Imprime o Or‡amento",78)
      TECNICA2->(DBEDIT(3,1,20,78,VARIAVEIS,"DBEORCTEC",MASCARAS,TITULOS,CHR(220),CHR(219)))
   ENDIF
   IF CONT=.F.
      EXIT
   ENDIF
   IF LASTKEY()=-1
      IF CONFIRMA(20,20,"A impressora est  preparada ?")
         DO WHILE .NOT. ISPRINTER() .AND. LASTKEY()#27
            AVISO("A impressora est  desconectada ou fora de linha...")
            INKEY(0.1)
         ENDDO
         IF LASTKEY()=27
            LOOP
         ENDIF
         IMPORC()
      ENDIF
   ENDIF
ENDDO
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,24,79)
MOEDA->(DBCLOSEAREA())
BASCAL->(DBCLOSEAREA())
RETURN(.T.)

FUNCTION ORCA1() // PROCURA VALORES DO ESTOQUE P/ VARIAVEIS
LOCAL  OLD
MEMVAR CORDES
MEMVAR T_VALUNI,T_QTD,T_BASCAL,O_BASCAL,T_TBASCAL,O_TBASCAL
SETCOLOR(CORDES)
@ 04,15 CLEAR TO 04,36
@ 04,15 SAY LEFT(ESTOQUE->NOME_V,30) COLOR CORDES
IF ESTOQUE->MOEDA_V="U"
   T_VALUNI:=ESTOQUE->VALVEN_V*MOEDA->VALOR_V
ELSE
   T_VALUNI:=ESTOQUE->VALVEN_V
ENDIF
@ 04,66 CLEAR TO 04,77
@ 04,66 SAY T_VALUNI*T_QTD PICT "@R 9,999,999.99" COLOR CORDES
SETCOLOR(OLD)
RETURN(.T.)

FUNCTION ORCA2() // CALCULA O VALOR TOTAL DO ITEM SELECIONADO
LOCAL  OLD
MEMVAR CORDES
MEMVAR T_VALUNI,T_QTD
OLD:=SETCOLOR()
SETCOLOR(CORDES)
@ 04,66 CLEAR TO 04,77
@ 04,66 SAY T_VALUNI*T_QTD PICT "@R 9,999,999.99" COLOR CORDES
SETCOLOR(OLD)
RETURN(.T.)

FUNCTION FINALTEC()
LOCAL  X,TELA,GETLIST:={},TELA2,ORIENT1,ORIENT2,ORIENT3
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
MEMVAR FICHA
MEMVAR VALOR,QTD,ICMS,XITEM,BASCAL,TBASCAL,CONT,MECVEN,VALMO,VALITOT,DATORC
MEMVAR VALOUTRO,VALTERC
CLEAR GETS
IF ! CONFIRMA(20,20,"Confirma or‡amento ?")
   RETURN(.F.)
ENDIF
TELA:=SAVESCREEN()
AADD(XITEM,)
WINDOW(5,40,14,77)
ORIENT1 :=SPACE(LEN(TECNICA->ORIENT1_V))
ORIENT2 :=SPACE(LEN(TECNICA->ORIENT2_V))
ORIENT3 :=SPACE(LEN(TECNICA->ORIENT3_V))
DO WHILE .T.
   @ 06,42 SAY "Data do Or‡amento :    " GET DATORC VALID(! EMPTY(DATORC))
   @ 07,42 SAY "T‚cnico           :        " GET MECVEN VALID(LASTKEY()=5 .OR.(SEA_MECVEN(MECVEN,,,"M").AND.FINALTEC2()))
   @ 08,42 SAY "Valor dos Itens   : "+TRANSFORM(VALITOT,"@R 999,999,999.99")
   @ 09,42 SAY "Valor Mao de Obra :" GET VALMO PICT "@R 999,999,999.99" VALID(FINALTEC2())
   @ 10,42 SAY "Terceiros         :" GET VALTERC PICT "@R 999,999,999.99" VALID(FINALTEC2())
   @ 11,42 SAY "Outros            :" GET VALOUTRO PICT "@R 999,999,999.99" VALID(FINALTEC2())
   @ 12,41 TO 12,76
   @ 13,42 SAY "Valor Total       : "+TRANSFORM(VALITOT+VALMO+VALOUTRO+VALTERC,"@R 999,999,999.99")
   READ
   IF LASTKEY()=27
      RESTSCREEN(,,,,TELA)
      RETURN(.F.)
   ENDIF
   TELA2:=SAVESCREEN()
   WINDOW(14,0,19,79)
   @ 15,01 SAY PADC("Orienta‡ao ao Mecƒnico/Servi‡o … Executar",78) COLOR CORTIT
   @ 16,02 GET ORIENT1
   @ 17,02 GET ORIENT2
   @ 18,02 GET ORIENT3
   READ
   IF LASTKEY()=27
      RESTSCREEN(,,,,TELA2)
      LOOP
   ENDIF
   IF CONFIRMA(20,20,"Confirma todos os dados ?")
      IF TECNICA->(RECLOCK())
         TECNICA->DATORC_V  :=DATORC
         TECNICA->MECVEN_V  :=MECVEN
         TECNICA->VALMO_V   :=VALMO
         TECNICA->VALOUTRO_V:=VALOUTRO
         TECNICA->VALTERC_V :=VALTERC
         TECNICA->VALITOT_V :=VALITOT
         TECNICA->NOMORC_V  :=NOMSEN
         TECNICA->ORIENT1_V :=ORIENT1
         TECNICA->ORIENT2_V :=ORIENT2
         TECNICA->ORIENT3_V :=ORIENT3
         X:=1
         DO WHILE .T.
            IF XITEM[X]=NIL
               EXIT
            ENDIF
            IF TECNICA2->(ADDREC())
               TECNICA2->CODIGO_V :=FICHA
               TECNICA2->ITEM_V   :=XITEM[X]
               TECNICA2->TIPO_V   :="B"
               TECNICA2->VALUNI_V :=VALOR[X]
               TECNICA2->QTD_V    :=QTD[X]
               TECNICA2->ICMS_V   :=ICMS[X]
               TECNICA2->BASCAL_V :=BASCAL[X]
               TECNICA2->TBASCAL_V:=TBASCAL[X]
               TECNICA2->NF_V     :="S"
               TECNICA2->(DBUNLOCK())
            ENDIF
            X++
         ENDDO
         TECNICA->(DBUNLOCK())
      ENDIF
      IF CONFIRMA(20,20,"Deseja imprimir o or‡amento ?")
         IMPORC()
      ENDIF
      CONT:=.F.
      SET KEY -1 TO
      EXIT
   ENDIF
ENDDO
RESTSCREEN(,,,,TELA)
RETURN(.T.)

FUNCTION FINALTEC2()
MEMVAR VALITOT,VALMO,MECVEN,VALOUTRO,VALTERC
@ 07,62 SAY IF(MECVEN->(DBSEEK(MECVEN)),LEFT(MECVEN->NOME_V,8),SPACE(8))
@ 13,62 SAY VALMO+VALITOT+VALOUTRO+VALTERC PICT "@R 999,999,999.99"
RETURN(.T.)

FUNCTION DBEORCTEC(nMode,Col)
LOCAL TELA,TELA2
LOCAL GETLIST:={}
LOCAL TECLA:=LASTKEY()
LOCAL VALOR:=1,TIP
LOCAL VAL:=0
MEMVAR CORDES,CORTEX,CORTIT,NOMSEN
MEMVAR ITEM,T_VALUNI,T_QTD,T_BASCAL,T_TBASCAL,O_BASCAL,O_TBASCAL,T_ICMS
MEMVAR FICHA,T,TOTITE,CONT
ITEM     :=SPACE(LEN(ESTOQUE->CODIGO_V))
T_VALUNI :=0
T_QTD    :=0
T_BASCAL :=0
T_ICMS   :=0
T_TBASCAL:=""
DO CASE
   CASE nMode=0
*      IF ! EMPTY(TECNICA->DATEXE_V)
*         @ 3,1 SAY " C¢digo        Descri‡ao            Vl.Unit rio Qtd.         Vl.Total   %ICMS " COLOR CORTIT
*      ENDIF
   CASE nMode=4
      DO CASE
         CASE TECLA=13
            IF EMPTY(TECNICA->NOTA_V)
               SETCURSOR(1)
               DO CASE
                  CASE Col=3
                     IF EMPTY(TECNICA->DATSAI_V)
                        IF TECNICA2->CODIGO_V==TECNICA->CODIGO_V
                           IF TECNICA2->(RECLOCK())
                              VAL:=TECNICA2->VALUNI_V
                              @ ROW(),COL() GET TECNICA2->VALUNI_V PICT "@R 99,999.99"
                              READ
                              IF LASTKEY()#27
                                 IF TECNICA->(RECLOCK())
                                    TECNICA->VALITOT_V:=(TECNICA->VALITOT_V-(VAL*TECNICA2->QTD_V))+(TECNICA2->VALUNI_V*TECNICA2->QTD_V)
                                    TECNICA->NOMORC_V:=NOMSEN
                                    TECNICA->(DBUNLOCK())
                                 ENDIF
                              ENDIF
                              @ 23,29 SAY "Valor Itens   : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999.99") COLOR CORTIT
                              @ 23,57 SAY "Total: "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V,"@R 999,999,999.99") COLOR CORTIT
                           ELSE
                              AVISO("O Sistema nao conseguiu travar o registro...")
                           ENDIF
                        ELSE
                           TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
                        ENDIF
                     ENDIF
                  CASE COL=4
                     IF TECNICA2->CODIGO_V==TECNICA->CODIGO_V
                        IF EMPTY(TECNICA->DATEXE_V)
                           IF TECNICA2->(RECLOCK()) .AND. TECNICA->(RECLOCK())
                              @ ROW(),COL() GET TECNICA2->TIPO_V VALID(TECNICA2->TIPO_V$"OB")
                              READ
                              IF LASTKEY()#27
                                 TECNICA->NOMORC_V:=NOMSEN
                                 TECNICA->(DBUNLOCK())
                              ENDIF
                           ELSE
                              AVISO("O Sistema nao conseguiu travar o registro...")
                           ENDIF
                        ELSE
                           IF TECNICA2->(RECLOCK()) .AND. TECNICA->(RECLOCK())
                              TIP:=TECNICA2->TIPO_V
                              @ ROW(),COL() GET TIP VALID(TIP$"OB")
                              READ
                              IF TIP#TECNICA2->TIPO_V
                                 IF TIP="O"
                                    IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                                       IF ESTOQUE->(RECLOCK())
                                          movest("E",tecnica2->item_v, "AT", tecnica2->qtd_v, tecnica2->codigo_v)
                                          TECNICA2->TIPO_V:=TIP
                                       ENDIF
                                    ENDIF
                                 ELSE
                                    IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                                       IF ESTOQUE->(RECLOCK())
                                          movest("S",tecnica2->item_v, "AT", tecnica2->qtd_v, tecnica2->codigo_v)
                                          TECNICA2->TIPO_V:=TIP
                                       ENDIF
                                    ENDIF
                                 ENDIF
                              ENDIF
                              TECNICA->NOMORC_V:=NOMSEN
                              TECNICA->(DBUNLOCK())
                           ELSE
                              AVISO("O Sistema nao conseguiu travar o registro...")
                           ENDIF
                        ENDIF
                     ELSE
                        TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
                     ENDIF
                  CASE Col=7
                     IF TECNICA2->CODIGO_V==TECNICA->CODIGO_V
                        IF TECNICA2->(RECLOCK()) .AND. TECNICA->(RECLOCK())
                           @ ROW(),COL() GET TECNICA2->NF_V PICT "@!" VALID(TECNICA2->NF_V$"SN")
                           READ
                           IF LASTKEY()#27
                              TECNICA->NOMORC_V:=NOMSEN
                              TECNICA->(DBUNLOCK())
                           ENDIF
                        ELSE
                           AVISO("O Sistema nao conseguiu travar o registro...")
                        ENDIF
                     ELSE
                        TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
                     ENDIF
               ENDCASE
               SETCURSOR(0)
            ELSE
               AVISO("Imposs¡vel alterar itens com Nota Fiscal j  emitida...")
            ENDIF
         CASE TECLA=27
            CONT:=.F.
            VALOR:=0
         CASE TECLA=-1
            VALOR:=0
         CASE TECLA=7
            IF TECNICA2->CODIGO_V==TECNICA->CODIGO_V
               IF EMPTY(TECNICA->NOTA_V) .AND. EMPTY(TECNICA->DATSAI_V)
                  IF !EMPTY(TECNICA->DATEXE_V)
                     TELA2:=SAVESCREEN()
                     WINDOW(10,20,13,68)
                     @ 11,22 SAY "J  foi dada sa¡da de itens, se vocˆ continuar" COLOR CORTEX
                     @ 12,22 SAY "ser  dado baixa automaticamente no estoque..." COLOR CORTEX
                     IF ! CONFIRMA(14,25,"Continua opera‡ao ?")
                        RESTSCREEN(,,,,TELA)
                        CLOSEWIN(10,20,13,68)
                        RETURN VALOR
                     ENDIF
                     RESTSCREEN(,,,,TELA2)
                     CLOSEWIN(10,20,13,68)
                  ENDIF
                  IF TECNICA2->(RECLOCK())
                     IF !EMPTY(TECNICA->DATEXE_V)
                        IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                           IF ESTOQUE->(RECLOCK())
                              movest("E",tecnica2->item_v, "AT", tecnica2->qtd_v, tecnica2->codigo_v)
                              ESTOQUE->(DBUNLOCK())
                           ENDIF
                        ENDIF
                     ENDIF
                     IF TECNICA->(RECLOCK())
                        TECNICA->VALITOT_V:=TECNICA->VALITOT_V-(TECNICA2->QTD_V*TECNICA2->VALUNI_V)
                        TECNICA->NOMORC_V:=NOMSEN
                        TECNICA->(DBUNLOCK())
                     ENDIF
                     @ 23,29 SAY "Valor Itens   : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999.99") COLOR CORTIT
                     @ 23,57 SAY "Total: "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V,"@R 999,999,999.99") COLOR CORTIT
                     TECNICA2->(DBDELETE())
                     TECNICA2->(DBSEEK(FICHA))
*                     TECNICA2->(DBSETFILTER({||TECNICA2->CODIGO_V==FICHA},"TECNICA2->CODIGO_V==FICHA"))
                  ENDIF
               ELSE
                  AVISO("Imposs¡vel exluir itens com o servi‡o j  entregue...")
               ENDIF
            ELSE
               TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
            ENDIF
         CASE TECLA=22
            IF EMPTY(TECNICA->NOTA_V) .AND. EMPTY(TECNICA->DATSAI_V)
               IF ! EMPTY(TECNICA->DATEXE_V)
                  TELA2:=SAVESCREEN()
                  WINDOW(10,20,13,68)
                  @ 11,22 SAY "J  foi dado sa¡da de pe‡as, se vocˆ continuar" COLOR CORTEX
                  @ 12,22 SAY "ser  dado baixa automaticamente no estoque..." COLOR CORTEX
                  IF ! CONFIRMA(14,25,"Continua opera‡ao ?")
                     RESTSCREEN(,,,,TELA)
                     CLOSEWIN(10,20,13,68)
                     RETURN VALOR
                  ENDIF
                  RESTSCREEN(,,,,TELA2)
                  CLOSEWIN(10,20,13,68)
               ENDIF
               TELA2:=SAVESCREEN()
               WINDOW(3,0,5,79)
               SETCOLOR(CORDES)
               @ 04,15 CLEAR TO 04,36
               @ 04,57 CLEAR TO 04,68
               SETCOLOR(CORTEX)
               SETCURSOR(1)
               @ 04,02 GET ITEM PICT "@K!" VALID(SEA_ESTOQUE(ITEM).AND.ORCA1())
               @ 04,38 GET T_VALUNI PICT "@R 99,999.99" VALID(LASTKEY()=5 .OR. T_VALUNI>0 .AND. ORCA2())
               @ 04,48 GET T_QTD    PICT "@R 9,999.99" VALID(LASTKEY()=5 .OR. T_QTD>0 .AND. ORCA2())
               @ 04,70 GET T_ICMS   PICT "@R 99.9999 %"
               READ
               SETCURSOR(0)
               IF LASTKEY()#27
                  IF TECNICA2->(ADDREC())
                     TECNICA2->CODIGO_V :=FICHA
                     TECNICA2->ITEM_V   :=ITEM
                     TECNICA2->TIPO_V   :="B"
                     TECNICA2->VALUNI_V :=T_VALUNI
                     TECNICA2->QTD_V    :=T_QTD
                     TECNICA2->ICMS_V   :=T_ICMS
                     TECNICA2->BASCAL_V :=T_BASCAL
                     TECNICA2->TBASCAL_V:=T_TBASCAL
                  ENDIF
                  IF !EMPTY(TECNICA->DATEXE_V)
                     IF ESTOQUE->(DBSEEK(TECNICA2->ITEM_V))
                        IF ESTOQUE->(RECLOCK())
                           movest("S",tecnica2->item_v, "AT", t_qtd, tecnica2->codigo_v)
                           ESTOQUE->(DBUNLOCK())
                        ENDIF
                     ENDIF
                  ENDIF
                  IF TECNICA->(RECLOCK())
                     TECNICA->VALITOT_V:=TECNICA->VALITOT_V+(T_QTD*T_VALUNI)
                     TECNICA->NOMORC_V:=NOMSEN
                     TECNICA->(DBUNLOCK())
                  ENDIF
                  TECNICA2->(DBCLEARFIL())
                  TECNICA2->(DBSEEK(FICHA))
*                  TECNICA2->(DBSETFILTER({||TECNICA2->CODIGO_V==FICHA},"TECNICA2->CODIGO_V==FICHA"))
                  RESTSCREEN(,,,,TELA2)
                  @ 23,29 SAY "Valor Itens   : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999.99") COLOR CORTIT
                  @ 23,57 SAY "Total: "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V,"@R 999,999,999.99") COLOR CORTIT
                  CLOSEWIN(4,0,6,79)
               ELSE
                  RESTSCREEN(,,,,TELA2)
               ENDIF
               TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
            ELSE
               AVISO("Imposs¡vel incluir itens com o servi‡o j  entregue...")
            ENDIF
      ENDCASE
ENDCASE
TECNICA2->(DBUNLOCK())
RETURN VALOR

FUNCTION IMPORC()
LOCAL nLineLength := 78, nTabSize := 3, lWrap := .T.
LOCAL nLines, nCurrentLine
DO WHILE !ISPRINTER().AND.LASTKEY()#27
   AVISO("Impressora fora de linha ou nao conectada ...")
ENDDO
IF LASTKEY()=27
   RETURN(.F.)
ENDIF
//@ PROW(),PCOL() SAY CHR(14)
//@ PROW(),2 SAY DECRIP(ALLTRIM(CONFIG->NOME_V))
CABECA("ORCAMENTO")
@ PROW(),PCOL() SAY CHR(18)
@ PROW()+2,2 SAY "Orcamento Ficha : "+TECNICA->CODIGO_V
@ PROW(),50  SAY "Data Orcamento  : "+DTOC(TECNICA->DATORC_V)
@ PROW()+1,2 SAY "Cliente         : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))
@ PROW()+1,2 SAY "Endereco        : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->ENDERECO_V,SPACE(50))
@ PROW()+1,2 SAY "Telefone        : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),TRANSFORM(CLIFOR->FONE1_V,"@R (#999) ##99-9999"),SPACE(12))
@ PROW()+1,2 SAY "Contato         : "+IF(CLIFOR->(DBSEEK(TECNICA->CLIFOR_V)),CLIFOR->CONTATO_V,SPACE(50))

@ PROW()+1,1 SAY REPLICATE("_",78)
@ PROW()+1,1 SAY PADC("DADOS DO SERVICO",78)
@ PROW()+1,1 SAY REPLICATE("_",78)
@ PROW()+1,1 SAY "Servico para : "+TRIM(TECNICA->ITEM_V)+" "+TRIM(TECNICA->MARCA_V)+" "+TRIM(TECNICA->MODELO_V)
@ PROW()+1,1 SAY "Placa/Patrim.: "+TECNICA->PLACA_V+" Km-Ml : "+TECNICA->TIPOKM_V+TRANSFORM(TECNICA->QTDKM_V,"@R 999999.9")
//@ PROW()+1,1 SAY "Placa/Patrim.: "+TECNICA->PLACA_V+" Km-Ml/N§.Serie : "+TECNICA->NSERIE_V
@ PROW()+1,1 SAY "Ano          : "+TECNICA->ANO_V+"     COR : "+TECNICA->COR_V

@ PROW()+1,2 SAY REPLICATE("_",78)
@ PROW()+1,2 SAY PADC("ORIENTACAO AO MECANICO / SERVICOS A EXECUTAR",78)
@ PROW()+1,2 SAY REPLICATE("_",78)
IF ! EMPTY(TECNICA->ORIENT1_V)
   @ PROW()+1,2 SAY TECNICA->ORIENT1_V
ENDIF
IF ! EMPTY(TECNICA->ORIENT2_V)
   @ PROW()+1,2 SAY TECNICA->ORIENT2_V
ENDIF
IF ! EMPTY(TECNICA->ORIENT3_V)
   @ PROW()+1,2 SAY TECNICA->ORIENT3_V
ENDIF

@ PROW()+1,2 SAY REPLICATE("_",78)
// @ PROW()+1,1 SAY " Codigo         Descricao           Vl.Unitario     Quantidade       Vl.Total "
@ PROW()+1,1 SAY " Descricao                       Vl.Unitario     Quantidade       Vl.Total "
@ PROW()+1,2 SAY REPLICATE("_",78)
TECNICA2->(DBSEEK(TECNICA->CODIGO_V))
DO WHILE TECNICA2->CODIGO_V==TECNICA->CODIGO_V
//   @ PROW()+1,2 SAY TECNICA2->ITEM_V
   @ PROW()+1,02  SAY IF(ESTOQUE->(DBSEEK(TECNICA2->ITEM_V)),LEFT(ESTOQUE->NOME_V,30),SPACE(30))
   @ PROW(),33  SAY TECNICA2->VALUNI_V PICT "999,999,999.99"
   @ PROW(),48  SAY TECNICA2->QTD_V    PICT "999,999,999.99"
   @ PROW(),63  SAY TECNICA2->VALUNI_V*TECNICA2->QTD_V PICT "999,999,999.99"
   TECNICA2->(DBSKIP())
ENDDO
@ PROW()+1,2 SAY REPLICATE("_",78)
@ PROW()+1,2 SAY "Valor Itens    : "+TRANSFORM(TECNICA->VALITOT_V,"@R 999,999,999.99")
@ PROW()+1,2 SAY "Mao de Obra    : "+TRANSFORM(TECNICA->VALMO_V,"@R 999,999,999.99")
@ PROW()+1,2 SAY "Terceiros      : "+TRANSFORM(TECNICA->VALTERC_V,"@R 999,999,999.99")
@ PROW()+1,2 SAY "Outros         : "+TRANSFORM(TECNICA->VALOUTRO_V,"@R 999,999,999.99")
@ PROW()+1,2 SAY "Valor Total    : "+TRANSFORM(TECNICA->VALITOT_V+TECNICA->VALMO_V+TECNICA->VALTERC_V+TECNICA->VALOUTRO_V,"@R 999,999,999.99")
@ PROW()+1,2 SAY REPLICATE("_",78)
nLines := MLCOUNT(CONFIG->TEXTORC_V, nLineLength,nTabSize, lWrap)
FOR nCurrentLine := 1 TO nLines
   @ PROW()+1,2 SAY MEMOLINE(CONFIG->TEXTORC_V, nLineLength, nCurrentLine,nTabSize, lWrap)
NEXT
//@ PROW()+1,2 SAY CONFIG->TEXTORC_V
EJECT
SET PRINTER TO
SET DEVICE TO SCREEN
RETURN(.T.)