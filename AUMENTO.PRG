FUNCTION AUMENTO(OPCAO)
LOCAL  TELA,PORC,CODINI,CODFIN,GETLIST:={},FAMILI
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
MEMVAR CLIFOR
TELA:=SAVESCREEN()
DO WHILE .T.
   PORC:=0
   CODINI:=SPACE(LEN(ESTOQUE->CODIGO_V))
   CODFIN:=SPACE(LEN(ESTOQUE->CODIGO_V))
   CLIFOR:=SPACE(LEN(ESTOQUE->CLIFOR_V))
   FAMILI:=SPACE(LEN(ESTOQUE->FAMILIA_V))
   DO CASE
      CASE OPCAO="G"
         WINDOW(15,46,17,78)
         @ 16,48 SAY "Porcentagem a aumentar :" GET PORC VALID(PORC>0) PICT "999"
         READ
         IF LASTKEY()=27
            EXIT
         ENDIF
         IF CONFIRMA(20,20,"Deseja relamente aumentar os pre‡os de venda ?",.t.)
            ESTOQUE->(DBGOTOP())
            DO WHILE ! ESTOQUE->(EOF())
               ESTOQUE->(RECLOCK(5))
               ESTOQUE->VALCUS_V:=ESTOQUE->VALCUS_V+(ESTOQUE->VALCUS_V*(PORC/100))
               ESTOQUE->VALVEN_V:=ESTOQUE->VALVEN_V+(ESTOQUE->VALVEN_V*(PORC/100))
               ESTOQUE->DATATU_V:=DATE()
               ESTOQUE->(DBUNLOCK())
               ESTOQUE->(DBSKIP())
            ENDDO
         ENDIF
      CASE OPCAO="O"
         WINDOW(15,46,19,78)
         @ 16,48 SAY "C¢digo Inicial :" GET CODINI PICT "@!"
         @ 17,48 SAY "C¢digo Final   :" GET CODFIN PICT "@!" VALID(CODFIN>=CODINI)
         @ 18,48 SAY "Porcentagem a aumentar :" GET PORC VALID(PORC>0) PICT "999"
         READ
         IF LASTKEY()=27
            EXIT
         ENDIF
         IF CONFIRMA(20,20,"Deseja relamente aumentar os pre‡os de venda ?",.t.)
            ESTOQUE->(DBSETORDER(1))
            ESTOQUE->(DBSEEK(CODINI))
            DO WHILE !ESTOQUE->(EOF()) .AND. ESTOQUE->CODIGO_V>=CODINI .AND. ESTOQUE->CODIGO_V<=CODFIN
               ESTOQUE->(RECLOCK(5))
               ESTOQUE->VALCUS_V:=ESTOQUE->VALCUS_V+(ESTOQUE->VALCUS_V*(PORC/100))
               ESTOQUE->VALVEN_V:=ESTOQUE->VALVEN_V+(ESTOQUE->VALVEN_V*(PORC/100))
               ESTOQUE->DATATU_V:=DATE()
               ESTOQUE->(DBUNLOCK())
               ESTOQUE->(DBSKIP())
            ENDDO
         ENDIF
      CASE OPCAO="F"
         WINDOW(15,46,18,78)
         @ 16,48 SAY "Fornecedor :" GET CLIFOR VALID(SEA_CLIFOR(CLIFOR,16,72))
         @ 17,48 SAY "Porcentagem a aumentar :" GET PORC VALID(PORC>0) PICT "999"
         READ
         IF LASTKEY()=27
            EXIT
         ENDIF
         IF CONFIRMA(20,20,"Deseja relamente aumentar os pre‡os de venda ?",.t.)
            ESTOQUE->(DBSETORDER(3))
            ESTOQUE->(DBSEEK(CLIFOR))
            DO WHILE ! ESTOQUE->(EOF()) .AND. ESTOQUE->CLIFOR_V==CLIFOR
               ESTOQUE->(RECLOCK(5))
               ESTOQUE->VALCUS_V:=ESTOQUE->VALCUS_V+(ESTOQUE->VALCUS_V*(PORC/100))
               ESTOQUE->VALVEN_V:=ESTOQUE->VALVEN_V+(ESTOQUE->VALVEN_V*(PORC/100))
               ESTOQUE->DATATU_V:=DATE()
               ESTOQUE->(DBUNLOCK())
               ESTOQUE->(DBSKIP())
            ENDDO
         ENDIF
      CASE OPCAO="A"
         WINDOW(15,46,18,78)
         @ 16,48 SAY "Fam¡lia :" GET FAMILI PICT "@!"
         @ 17,48 SAY "Porcentagem a aumentar :" GET PORC VALID(PORC>0) PICT "999"
         READ
         IF LASTKEY()=27
            EXIT
         ENDIF
         IF CONFIRMA(20,20,"Deseja relamente aumentar os pre‡os de venda ?",.t.)
            ESTOQUE->(DBGOTOP())
            DO WHILE ! ESTOQUE->(EOF())
               IF ALLTRIM(FAMILI)$ESTOQUE->FAMILIA_V
                  ESTOQUE->(RECLOCK(5))
                  ESTOQUE->VALCUS_V:=ESTOQUE->VALCUS_V+(ESTOQUE->VALCUS_V*(PORC/100))
                  ESTOQUE->VALVEN_V:=ESTOQUE->VALVEN_V+(ESTOQUE->VALVEN_V*(PORC/100))
                  ESTOQUE->DATATU_V:=DATE()
                  ESTOQUE->(DBUNLOCK())
               ENDIF
               ESTOQUE->(DBSKIP())
            ENDDO
         ENDIF
   ENDCASE
   EXIT
ENDDO
RESTSCREEN(,,,,TELA)
RETURN(.T.)
