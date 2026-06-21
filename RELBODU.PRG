FUNCTION RELBODU(TIPO)
LOCAL INICIO,FIM,GETLIST:={},X,TOTAL,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
MEMVAR LINHA,CODBAN,LINHA2
TELA:=SAVESCREEN()
DBF_CONFIG()
DBF_PAGREC()
DBF_CLIFOR()
DBF_BANK()
CODBAN:=0
INICIO:=DATE()
FIM   :=DATE()
WINDOW(IF(RIGHT(TIPO,1)="B",09,10),10,12,63)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   IF RIGHT(TIPO,1)="B"
      @ 10,12 SAY "Banco :" GET CODBAN PICT "99999" VALID(SEA_BANK(CODBAN,10,26))
   ENDIF
   @ 11,12 SAY "Data Inicial :" GET INICIO VALID(!EMPTY(INICIO))
   @ 11,39 SAY "Data Final :"  GET FIM     VALID(FIM>=INICIO)
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   LINHA:={}
   LINHA2:={}
   X:=0
   TOTAL:=0
   PAGREC->(DBSETORDER(5))
   PAGREC->(DBSEEK(INICIO,.T.))
   SET CENTURY OFF
   DO WHILE PAGREC->DATVEN_V>=INICIO .AND. PAGREC->DATVEN_V<=FIM .AND. X<4090 .AND. ! PAGREC->(EOF())
      DO CASE
         CASE TIPO="BP"
            IF ! EMPTY(PAGREC->BOLETO_V) .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,PAGREC->BOLETO_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))+" "+;
                          PAGREC->DOCINT_V+" "+IF(BANK->(DBSEEK(PAGREC->CODBANBO_V)),BANK->NOME_V,SPACE(10))+" "+TRANSFORM(PAGREC->VALOR_V,"@R 99,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+PAGREC->PROTESTO_V)
               AADD(LINHA2,PAGREC->BOLETO_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,18),SPACE(18))+" "+;
                          PAGREC->DOCINT_V+" "+IF(BANK->(DBSEEK(PAGREC->CODBANBO_V)),BANK->NOME_V,SPACE(10))+" "+TRANSFORM(PAGREC->VALOR_V,"@R 99,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+PAGREC->PROTESTO_V)
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V
            ENDIF
         CASE TIPO="BB"
            IF ! EMPTY(PAGREC->BOLETO_V) .AND. PAGREC->CODBANBO_V=CODBAN .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,PAGREC->BOLETO_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),CLIFOR->NOME_V,SPACE(50))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+PAGREC->PROTESTO_V)
               AADD(LINHA2,PAGREC->BOLETO_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,19),SPACE(19))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+PAGREC->PROTESTO_V)
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V
            ENDIF
         CASE TIPO="DP"
            IF ! EMPTY(PAGREC->DUPLICA_V) .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,PAGREC->DUPLICA_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,17),SPACE(17))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 99,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+;
                          IF(BANK->(DBSEEK(PAGREC->CODBANDU_V)),LEFT(BANK->NOME_V,8),SPACE(8))+" "+PAGREC->PROTESTO_V)
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V
            ENDIF
         CASE TIPO="DB"
            IF ! EMPTY(PAGREC->DUPLICA_V) .AND. PAGREC->CODBANDU_V=CODBAN .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,PAGREC->DUPLICA_V+" "+IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,25),SPACE(25))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V)+" "+PAGREC->PROTESTO_V)
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V
            ENDIF
         CASE TIPO="SC"
            IF EMPTY(PAGREC->DUPLICA_V) .AND. EMPTY(PAGREC->BOLETO_V) .AND. EMPTY(PAGREC->COBCHQ_V) .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,38),SPACE(38))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V))
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V
            ENDIF
         CASE TIPO="PR"
            IF PAGREC->PROTESTO_V="S" .AND. LEFT(PAGREC->CODIGO_V,1)="R"
               AADD(LINHA,IF(CLIFOR->(DBSEEK(PAGREC->CLIFOR_V)),LEFT(CLIFOR->NOME_V,38),SPACE(38))+" "+;
                          PAGREC->DOCINT_V+" "+DTOC(PAGREC->DATINT_V)+" "+TRANSFORM(PAGREC->VALOR_V,"@R 999,999.99")+" "+DTOC(PAGREC->DATVEN_V))
               X++
               TOTAL:=TOTAL+PAGREC->VALOR_V 
            ENDIF
      ENDCASE
      PAGREC->(DBSKIP())
   ENDDO
   SET CENTURY ON
   WINDOW(3,0,22,79)
   DO CASE
      CASE TIPO="BP"
         @ 4,1 SAY PADC("Relat¢rio de Boletos para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),78) COLOR CORTIT
         @ 5,1 SAY "Boleto           Nome               Doc.Int.   Banco      Valor     Vencto. Pr" COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" Boletos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
      CASE TIPO="BB"
         @ 4,1 SAY PADC("Relat¢rio de Boletos para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM)+" do Banco "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),78) COLOR CORTIT
         @ 5,1 SAY "Boleto           Nome                Doc.Int.   Dt.Int.  Valor      Vencto. Pr" COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" Boletos                                   Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
      CASE TIPO="DP"
         @ 4,1 SAY PADC("Relat¢rio de Duplicatas para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),78) COLOR CORTIT
         @ 5,1 SAY "Duplica    Nome              Doc.Int.   Dt.Int.  Valor     Vencto.  Banco   Pr" COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" Duplicatas                        Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
      CASE TIPO="DB"
         @ 4,1 SAY PADC("Relat¢rio de Duplicatas para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM)+" do Banco "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),78) COLOR CORTIT
         @ 5,1 SAY "Duplica    Nome                      Doc.Int.   Dt.Int.  Valor      Vencto. Pr" COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" Duplicatas                                 Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
      CASE TIPO="SC"
         @ 4,1 SAY PADC("T¡tulos sem Cobran‡a para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),78) COLOR CORTIT
         @ 5,1 SAY "Nome                                   Doc.Int.   Dt.Int.  Valor      Vencto. " COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" T¡tulos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
      CASE TIPO="PR"
         @ 4,1 SAY PADC("T¡tulos Protestados no Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),78) COLOR CORTIT
         @ 5,1 SAY "Nome                                   Doc.Int.   Dt.Int.  Valor      Vencto. " COLOR CORTIT
         @ 21,1 SAY PADR(STRZERO(X,4,0)+" T¡tulos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"),78) COLOR CORTIT
   ENDCASE
   @ 06,1 TO 06,78
   @ 20,1 TO 20,78
   ACHOICE(7,1,19,78,LINHA,.T.,"RELACHOFUN")
   IF CONFIRMA(20,20,"Deseja Imprimir ?")
      DO CASE
         CASE TIPO="BP"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" Boletos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            C_IMPREL("Relatorio de Boletos para o Periodo de "+DTOC(INICIO)+" a "+DTOC(FIM),"Boleto           Nome                                               Doc.Int.   Banco          Valor Vencto. Pr",49)
         CASE TIPO="BB"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" Boletos                                   Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            C_IMPREL("Relatorio de Boletos para o Periodo de "+DTOC(INICIO)+" a "+DTOC(FIM)+" do Banco "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),"Boleto           Nome                                               Doc.Int.   Dt.Int.       Valor Vencto. Pr",49)
         CASE TIPO="DP"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" Duplicatas                        Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            IMPREL("Relatorio de Duplicatas para o Periodo de "+DTOC(INICIO)+" a "+DTOC(FIM),"Duplica    Nome              Doc.Int.   Dt.Int.  Valor     Vencto.  Banco   Pr",49)
         CASE TIPO="DB"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" Duplicatas                                 Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            IMPREL("Relatorio de Duplicatas para o Periodo de "+DTOC(INICIO)+" a "+DTOC(FIM)+" do Banco "+IF(BANK->(DBSEEK(CODBAN)),BANK->NOME_V,SPACE(10)),"Duplica    Nome                      Doc.Int.   Dt.Int.  Valor      Vencto. Pr",49)
         CASE TIPO="SC"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" T¡tulos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            IMPREL("T¡tulos sem Cobran‡a para o Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),"Nome                                   Doc.Int.   Dt.Int.  Valor      Vencto. ",49)
         CASE TIPO="PR"
            AADD(LINHA,REPLICATE("-",80))
            AADD(LINHA,STRZERO(X,4,0)+" T¡tulos                                    Total : "+TRANSFORM(TOTAL,"@R 99,999,999.99"))
            IMPREL("T¡tulos Protestados no Per¡odo de "+DTOC(INICIO)+" a "+DTOC(FIM),"Nome                                   Doc.Int.   Dt.Int.  Valor      Vencto. ",49)
      ENDCASE
   ENDIF
   EXIT
ENDDO
RESTSCREEN(,,,,TELA)
CONFIG->(DBCLOSEAREA())
PAGREC->(DBCLOSEAREA())
CLIFOR->(DBCLOSEAREA())
BANK->(DBCLOSEAREA())
RETURN(.T.)
