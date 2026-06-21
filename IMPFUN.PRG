//HP
*** CHR(27)+(s1P) EXPANDIDO
*** CHR(27)+(s0P) Volta
*** CHR(27)+(s16.67H) COMPRIMI
*** CHR(27)+(s10H) VOLTA
*** CHR(27)+(3D)NEGRITO
*** CHR(27)+(-3D) VOLTA NEGRITO
*** CHR(27)+(s1S) ITALICO
*** (CHR(27)+(s0S) VOLTA ITALICO


//NORMAL
*** CHR(15) - COMPRIMIDO
*** CHR(18) - NORMAL
*** CHR(14) - EXPANDIDO
Procedure LigaImpressora()
local SelPrinter
SelPrinter := SelectPrinter()
if lower(SelPrinter) = "getdefaultprinter()"
   Set Printer to (GetDefaultPrinter())
else
   SelPrinter := &SelPrinter
   Set Printer to &SelPrinter
endif
SET DEVICE TO PRINTER
return

FUNCTION CABECA(TITULO,SUBTITULO1,PORT) // CABECALHO
MEMVAR IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
LigaImpressora()
@ PROW(),1 SAY EXPON+LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),39)+EXPOFF
@ PROW()+2,1 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
@ PROW()+1,2 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
* @ PROW()+1,2 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
@ PROW()+1,2 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
@ PROW(),71  SAY DTOC(DATE()) + " " + TIME()
@ PROW()+1,0 SAY REPLICATE("-",80)
IF TITULO#(NIL)
   @ PROW()+1,1 SAY PADC(TITULO,79)
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
IF SUBTITULO1#(NIL)
   @ PROW()+1,1 SAY SUBTITULO1
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
RETURN PORT

FUNCTION C_CABECA(TITULO,SUBTITULO1,PORT) // CABECALHO COMPRIMIDO
MEMVAR IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
LigaImpressora()
@ PROW(),1 SAY EXPON+LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),39)+EXPOFF
@ PROW()+2,1 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
@ PROW()+1,2 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
* @ PROW()+1,2 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
@ PROW()+1,2 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
@ PROW(),71  SAY DATE()
@ PROW()+1,0 SAY REPLICATE("-",80)
IF TITULO#(NIL)
   @ PROW()+1,1 SAY PADC(TITULO,79)
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
IF SUBTITULO1#(NIL)
   @ PROW()+1,1 SAY COMPON+SUBTITULO1+COMPOFF
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
RETURN(.T.)


FUNCTION RELACHOFUN( nMode, nCurElement, nRowPos )
LOCAL nRetVal := 2     // Default, Continue
LOCAL nKey := LASTKEY()
#INCLUDE "INKEY.CH"
#INCLUDE "ACHOICE.CH"
DO CASE
// After all pending keys are processed, display message
	CASE nMode == AC_NOITEM

	CASE nMode == AC_IDLE            // Continue ACHOICE()
		nRetVal := 2
	CASE nMode == AC_HITTOP          // Attempt to go past Top
		AVISO("Inicio de relat¢rio ...")
	CASE nMode == AC_HITBOTTOM       // Attempt to go past Bottom
	  AVISO("Fim de relat¢rio ...")
	CASE nMode == AC_EXCEPT          // Key Exception
		DO CASE
			CASE nKey == K_RETURN         // If RETURN key, select
				nRetVal := AC_SELECT
			CASE nKey = K_ESC 					  // If ESCAPE key, abort
				nRetVal := AC_ABORT
			CASE nKey = K_LEFT 					  // If LEFT key, abort
				nRetVal := AC_CONT
			CASE nKey = K_RIGHT 					  // If RIGHT key, abort
				nRetVal := AC_CONT
			OTHERWISE
				nRetVal := AC_GOTO      // Otherwise, go to item
		ENDCASE
ENDCASE
RETURN(nRetVal)

FUNCTION IMPREL(TITULO,SUBTITULO1,QTDLIN) // IMPRESSAO DE RELATORIO
LOCAL X,Y,P
MEMVAR LINHA,IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
P:=1
LigaImpressora()
@ PROW(),1 SAY EXPON+LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),39)+EXPOFF
@ PROW()+2,1 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
@ PROW()+1,2 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
* @ PROW()+1,2 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
@ PROW()+1,2 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
@ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
@ PROW()+1,0 SAY REPLICATE("-",80)
IF TITULO#(NIL)
   @ PROW()+1,1 SAY PADC(TITULO,79)
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
IF SUBTITULO1#(NIL)
   @ PROW()+1,1 SAY SUBTITULO1
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
X:=1
AADD(LINHA,)
Y:=1
DO WHILE LASTKEY()#27
   IF LINHA[X]=(NIL)
      EXIT
   ENDIF
   @ PROW()+1,1 SAY LINHA[X]
   IF QTDLIN#(NIL)
      IF Y>=QTDLIN
         P++
         Y:=1
         @ 0,0 SAY " "
         @ PROW(),1 SAY EXPON+PADC(ALLTRIM(LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),50)),50)+EXPOFF
         @ PROW()+2,1 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
         @ PROW()+1,2 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
*         @ PROW()+1,2 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
         @ PROW()+1,2 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
         @ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
         @ PROW()+1,0 SAY REPLICATE("-",80)
         IF TITULO#(NIL)
            @ PROW()+1,1 SAY PADC(TITULO,79)
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
         IF SUBTITULO1#(NIL)
            @ PROW()+1,1 SAY SUBTITULO1
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
      ENDIF
   ENDIF
   INKEY(.1)
   Y++
   X++
ENDDO
@ PROW()+1,0 SAY REPLICATE("=",80)
@ 0,0 SAY " "
SET PRINTER TO
SET DEVICE TO SCREEN
RETURN(.T.)

FUNCTION C_IMPREL(TITULO,SUBTITULO1,QTDLIN) // IMPRESSAO DE RELATORIO C/ DADOS COMPRIMIDOS
LOCAL X,Y,P
MEMVAR LINHA,IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
P:=1
LigaImpressora()
@ PROW(),0 SAY EXPON+LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),39)+EXPOFF
@ PROW()+2,0 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
@ PROW()+1,0 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
* @ PROW()+1,0 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
@ PROW()+1,0 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
@ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
@ PROW()+1,0 SAY REPLICATE("-",80)
IF TITULO#(NIL)
   @ PROW()+1,0 SAY PADC(TITULO,80)
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
IF SUBTITULO1#(NIL)
   @ PROW()+1,0 SAY COMPON+SUBTITULO1+COMPOFF
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
X:=1
AADD(LINHA,)
Y:=1
@ PROW(),PCOL() SAY COMPON
DO WHILE LASTKEY()#27
   IF LINHA[X]=(NIL)
      EXIT
   ENDIF
   @ PROW()+1,0 SAY LINHA[X]
   IF QTDLIN#(NIL)
      IF Y>=QTDLIN
         Y:=1
         P++
         @ 0,0 SAY COMPOFF
         @ PROW(),0 SAY EXPON+PADC(ALLTRIM(LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),50)),50)+EXPOFF
         @ PROW()+2,0 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
         @ PROW()+1,0 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
*         @ PROW()+1,0 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
         @ PROW()+1,0 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
         @ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
         @ PROW()+1,0 SAY REPLICATE("-",80)
         IF TITULO#(NIL)
            @ PROW()+1,0 SAY PADC(TITULO,80)
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
         IF SUBTITULO1#(NIL)
            @ PROW()+1,0 SAY COMPON+SUBTITULO1+COMPOFF
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
         @ PROW(),PCOL() SAY COMPON
      ENDIF
   ENDIF
   Y++
   X++
ENDDO
@ PROW(),PCOL() SAY NORMAL
@ PROW()+1,0 SAY REPLICATE("=",80)
@ 0,0 SAY " "
SET PRINTER TO
SET DEVICE TO SCREEN
RETURN(.T.)

FUNCTION IMPRELDB(TITULO,SUBTITULO1,QTDLIN) // IMPRESSAO DE RELATORIO
LOCAL Y,P,LASTCMD,X
MEMVAR LINHA,IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
P:=1
LigaImpressora()
@ PROW(),0 SAY EXPON+LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),39)+EXPOFF
@ PROW()+2,0 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
@ PROW()+1,1 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
* @ PROW()+1,1 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
@ PROW()+1,1 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
@ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
@ PROW()+1,0 SAY REPLICATE("-",80)
IF TITULO#(NIL)
   @ PROW()+1,0 SAY PADC(TITULO,80)
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
IF SUBTITULO1#(NIL)
   AADD(SUBTITULO1,)
   X := 1
   DO WHILE SUBTITULO1[X]<>NIL
      @ PROW()+1,0 SAY IF(SUBTITULO1[X][1]='N' , NORMAL ,;
                                            IF(SUBTITULO1[X][1]='E' , NORMAL+EXPON ,;
                                                                 IF(SUBTITULO1[X][1]='C' , NORMAL+COMPON ,;
                                                                                      NORMAL)))
      @ PROW(),0 SAY SUBTITULO1[X][2]
      @ PROW(),0 SAY IF(SUBTITULO1[X][1]='N' , NORMAL ,;
                                      IF(SUBTITULO1[X][1]='E' , EXPOFF ,;
                                                       IF(SUBTITULO1[X][1]='C' , COMPOFF ,;
                                                                        NORMAL)))
      X++
   ENDDO
   @ PROW()+1,0 SAY REPLICATE("-",80)
ENDIF
Y:=1
IMP->(DBGOTOP())
LASTCMD:=IMP->TIPO_V
@ PROW()+1,0 SAY IF(IMP->TIPO_V='N' , NORMAL ,;
                                      IF(IMP->TIPO_V='E' , EXPON ,;
                                                           IF(IMP->TIPO_V='C' , COMPON ,;
                                                                                NORMAL)))
DO WHILE LASTKEY()#27 .AND. .NOT. IMP->(EOF())
   IF IMP->TIPO_V<>LASTCMD
      @ PROW(),0 SAY IF(LASTCMD='N' , NORMAL ,;
                                      IF(LASTCMD='E' , EXPOFF ,;
                                                       IF(LASTCMD='C' , COMPOFF ,;
                                                                        NORMAL)))
      LASTCMD := IMP->TIPO_V
      @ PROW()+1,0 SAY IF(IMP->TIPO_V='N' , NORMAL ,;
                                            IF(IMP->TIPO_V='E' , NORMAL+EXPON ,;
                                                                 IF(IMP->TIPO_V='C' , NORMAL+COMPON ,;
                                                                                      NORMAL)))
      @ PROW(),0 SAY IF(IMP->TIPO_V='N' , IMP->P1_V+LEFT(IMP->P2_V,2) ,;
                                          IF(IMP->TIPO_V='E' , LEFT(IMP->P1_V,30) ,;
                                                               IF(IMP->TIPO_V='C' , IMP->P1_V+IMP->P2_V ,;
                                                                                    IMP->P1_V+LEFT(IMP->P2_V,2) )))

   ELSE
      @ PROW()+1,0 SAY IF(IMP->TIPO_V='N' , IMP->P1_V+LEFT(IMP->P2_V,2) ,;
                                            IF(IMP->TIPO_V='E' , LEFT(IMP->P1_V,30) ,;
                                                                 IF(IMP->TIPO_V='C' , IMP->P1_V+IMP->P2_V ,;
                                                                                      IMP->P1_V+LEFT(IMP->P2_V,2) )))
   ENDIF
   IF QTDLIN#(NIL)
      IF Y>=QTDLIN
         @ PROW(),0 SAY IF(LASTCMD='N' , NORMAL ,;
                                         IF(LASTCMD='E' , EXPOFF ,;
                                                          IF(LASTCMD='C' , COMPOFF ,;
                                                                           NORMAL)))
         P++
         Y:=1
         @ 0,0 SAY " "
         @ PROW(),0 SAY EXPON+PADC(ALLTRIM(LEFT(DECRIP(ALLTRIM(CONFIG->NOME_V)),50)),50)+EXPOFF
         @ PROW()+2,0 SAY COMPON+alltrim(DECRIP(CONFIG->ENDERECO_V))+" "+alltrim(decrip(config->numero_v))+" "+alltrim(decrip(config->complem_v))
         @ PROW()+1,1 SAY ALLTRIM(DECRIP(CONFIG->CIDADE_V))+" - "+DECRIP(CONFIG->ESTADO_V)
*         @ PROW()+1,1 SAY DECRIP(CONFIG->CGC_V)+" - "+DECRIP(CONFIG->INSEST_V)
         @ PROW()+1,1 SAY IF(!EMPTY(CONFIG->FONE1_V),DECRIP(CONFIG->FONE1_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FONE2_V),DECRIP(CONFIG->FONE2_V),SPACE(0))+" - "+IF(!EMPTY(CONFIG->FAX_V),DECRIP(CONFIG->FAX_V),SPACE(0))+COMPOFF
         @ PROW(),78 SAY DTOC(DATE())+" Pag.: "+STRZERO(P,3,0)
         @ PROW()+1,0 SAY REPLICATE("-",80)
         IF TITULO#(NIL)
            @ PROW()+1,0 SAY PADC(TITULO,80)
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
         IF SUBTITULO1#(NIL)
            X := 1
            DO WHILE SUBTITULO1[X]<>NIL
               @ PROW()+1,0 SAY IF(SUBTITULO1[X][1]='N' , NORMAL ,;
                                                        IF(SUBTITULO1[X][1]='E' , NORMAL+EXPON ,;
                                                                                  IF(SUBTITULO1[X][1]='C' , NORMAL+COMPON ,;
                                                                                                            NORMAL)))
               @ PROW(),0 SAY SUBTITULO1[X][2]
               @ PROW(),0 SAY IF(SUBTITULO1[X][1]='N' , NORMAL ,;
                                                        IF(SUBTITULO1[X][1]='E' , EXPOFF ,;
                                                                                  IF(SUBTITULO1[X][1]='C' , COMPOFF ,;
                                                                                                            NORMAL)))
               X++
            ENDDO
            @ PROW()+1,0 SAY REPLICATE("-",80)
         ENDIF
         @ PROW()+1,0 SAY IF(LASTCMD='N' , NORMAL ,;
                                               IF(LASTCMD='E' , NORMAL+EXPON ,;
                                                                    IF(LASTCMD='C' , NORMAL+COMPON ,;
                                                                                         NORMAL)))
      ENDIF
   ENDIF
   INKEY(.1)
   Y++
   IMP->(DBSKIP())
ENDDO
@ PROW()+1,0 SAY REPLICATE("=",80)
@ 0,0 SAY " "
SET PRINTER TO
SET DEVICE TO SCREEN
RETURN(.T.)

Function SelectPrinter()
LOCAL hIniData , hIni
if file("c:\sysaux.ini")
   hIniData := HB_ReadIni( "c:\sysaux.ini" )
   SelPrinter := hIniData["MAIN"]["Impressora"]
else
   SelPrinter := "GetDefaultPrinter()"
   hIni := Hash()
   hIni["MAIN" ] := Hash()
   hIni["MAIN" ]["Impressora" ]  := "GetDefaultPrinter()"
   HB_WriteIni( "c:\sysaux.ini", hIni, ;
                   "; Start comment", "; End comment" )
endif
return SelPrinter