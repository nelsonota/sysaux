#define HB_EXT_INKEY
FUNCTION SENHA(LIN,COL)
LOCAL TECLA,NOME,SENHA,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,NOMSEN,IMPFUN
TELA:=SAVESCREEN(0,0,24,80)
NOME:=SPACE(0)
SENHA:=SPACE(0)
SETCOLOR(CORTEX)
WINDOW(LIN,COL,LIN+2,COL+40)
@ LIN+1,COL+2  SAY "Nome :"
@ LIN+1,COL+21 SAY "Senha :"
SETCOLOR(CORTIT)
@ LIN+1,COL+9 CLEAR TO LIN+1,COL+18
@ LIN+1,COL+29 CLEAR TO LIN+1,COL+38
DO WHILE EMPTY(NOME)
   NOME:=NEWGET(10,LIN+1,COL+9,,1)  // TAMANHO , LINHA , COLUNA , TELA OPCIONAL
ENDDO
DO WHILE EMPTY(SENHA)
   SENHA:=CRIP(NEWGET(10,LIN+1,COL+29,.F.,1))
   IF SENHA=".F."
      SENHA->(DBCLOSEAREA())
      RETURN(.F.)      
   ENDIF
ENDDO
RESTSCREEN(0,0,24,80,TELA)
DBF_SENHA()
DBSETORDER(2)
SENHA->(DBGOTOP())
DBSELECTAREA("SENHA","SENHA")
LOCATE FOR ALLTRIM(SENHA->NOMSEN_V)==NOME .AND. ALLTRIM(SENHA->SENHA_V)==SENHA
IF .NOT. FOUND()
//   IF NOME="NELSON" .AND. SENHA=CRIP("250596")
//      LEVEL          :="NE"
//      CODSEN         :=0
//      NOMSEN         :=SPACE(10)
//      IMPFUN         :=0
//      CORTIT         :="GR+/BR+"
//      CORTEX         :="W/B+"
//      CORPAR         :="BG+/N+*"
//      CORBAR         :="GR+/R+"
//      CORDES         :="W+/N"
//      SENHA->(DBCLOSEAREA())
//      RETURN(.T.)
//   ENDIF
   RETURN(.F.)
ELSE
   CODSEN:=SENHA->CODSEN_V
   NOMSEN:=SENHA->NOMSEN_V
   LEVEL:=SENHA->LEVEL_V
   IMPFUN:=SENHA->IMPFUN_V
   SENHA->(DBCLOSEAREA())
   RETURN(.T.)
ENDIF
RETURN(.F.)

FUNCTION NEWGET(TAMANHO,LIN,COL,MOSTRA,USAR)
LOCAL TECLA,VARIA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,TEMPO
IF MOSTRA=(NIL)
   MOSTRA:=.T.
ENDIF
TECLA:=INKEY(1)
TEMPO:=0
VARIA:=SPACE(0)
DO WHILE TECLA#13 .AND. LEN(VARIA)<TAMANHO
   IF TECLA=0
      SETCOLOR(CORTIT)
      IF USAR#(NIL)
         DO CASE
            CASE USAR=1
               APRESENTA(TEMPO)
         ENDCASE
      ELSE
         @ 0,72 SAY TIME()
      ENDIF
   ELSE
      SETCOLOR(CORTIT)
      IF USAR#(NIL)
         DO CASE
            CASE USAR=1
               APRESENTA(TEMPO)
         ENDCASE
      ELSE
         @ 0,72 SAY TIME()
      ENDIF
      DO CASE
         CASE LASTKEY()=8
            VARIA:=LEFT(VARIA,LEN(VARIA)-1)
         CASE LASTKEY()=13
            EXIT
         CASE LASTKEY()=27
            RETURN(".F.")
         OTHERWISE
               VARIA:=ALLTRIM(VARIA)+UPPER(CHR(TECLA))
      ENDCASE
      SETCOLOR(CORBAR)
      @ LIN,COL CLEAR TO LIN,COL+TAMANHO-1
      IF MOSTRA=.T.
         @ LIN,COL SAY TRANSFORM(VARIA,"NNNNNNNNNN")
      ELSE
         @ LIN,COL SAY REPLICATE("*",LEN(VARIA))
      ENDIF
   ENDIF
   TECLA:=INKEY(1)
   DO CASE
      CASE USAR=1
         IF TEMPO>=30
            TEMPO:=-1
         ENDIF
   ENDCASE
   TEMPO++
ENDDO
RETURN(VARIA)


FUNCTION WINDOW(SLINHA, SCOLUNA, ILINHA, ICOLUNA)
LOCAL SHAD,SHAD2,L1,L2,C1,C2,D,I,Z,OLD
MEMVAR CORTEX  
SHAD2:= SAVESCREEN(SLINHA + 1, ICOLUNA + 1, ILINHA, ICOLUNA + 2)
SHAD:= SAVESCREEN(ILINHA + 1, SCOLUNA + 2, ILINHA + 1, ICOLUNA + 2)
OLD:=SETCOLOR()
SETCOLOR(CORTEX)
L1:= SLINHA
L2:= ILINHA
C1:= SCOLUNA
C2:= ICOLUNA
DO WHILE (L1 <= L2)
   L2:= L2 - 1
   L1:= L1 + 1
ENDDO
DO WHILE (C1 <= C2)
   C1:= C1 + 1
   C2:= C2 - 1
ENDDO
DO WHILE .T.
   @ L1, C1 CLEAR TO L2, C2
   @ L1, C1, L2, C2 BOX "Û"
   L1:= L1 - 1
   L2:= L2 + 1
   C1:= C1 - 1
   C2:= C2 + 1
   IF (L1 < SLINHA)
      L1:= SLINHA
   ENDIF
   IF (L2 > ILINHA)
      L2:= ILINHA
   ENDIF
   IF (C1 = SCOLUNA)
      EXIT
   ENDIF
   D:= 0
   DO WHILE D<80
      D:= D + 1
   ENDDO
ENDDO
FOR I:= 2 TO LEN(SHAD) STEP 2
   SHAD:= STUFF(SHAD, I, 1,CHR(8))
NEXT
FOR Z:= 2 TO lEN(SHAD2) STEP 2
   SHAD2:= STUFF(SHAD2, Z, 1,CHR(8))
NEXT
RESTSCREEN(ILINHA + 1, SCOLUNA + 2, ILINHA + 1, ICOLUNA + 2, SHAD)
RESTSCREEN(SLINHA + 1, ICOLUNA + 1, ILINHA, ICOLUNA + 2, SHAD2)
@ SLINHA, SCOLUNA, ILINHA, ICOLUNA BOX CHR(219)
@ SLINHA, SCOLUNA + 1, SLINHA, ICOLUNA - 1 BOX CHR(223)
@ ILINHA, SCOLUNA + 1, ILINHA, ICOLUNA - 1 BOX CHR(220)
@ SLINHA + 1, SCOLUNA + 1 CLEAR tO ILINHA - 1, ICOLUNA - 1
SETCOLOR(OLD)
RETURN(.T.)

FUNCTION CLOSEWIN(SLINHA, SCOLUNA, ILINHA, ICOLUNA)
LOCAL L1,L2,C1,C2,D,OLD,TELA
MEMVAR CORTEX  
TELA:=SAVESCREEN()
OLD:=SETCOLOR()
SETCOLOR(CORTEX)
L1:= SLINHA
L2:= ILINHA
C1:= SCOLUNA
C2:= ICOLUNA
DO WHILE (L1 <= L2)
   L2:= L2 - 1
   L1:= L1 + 1
ENDDO
DO WHILE (C1 <= C2)
   C1:= C1 + 1
   C2:= C2 - 1
ENDDO
DO WHILE .T.
   RESTSCREEN(,,,,TELA)
   @ SLINHA, SCOLUNA, ILINHA, ICOLUNA BOX "Û"
   @ SLINHA+1,SCOLUNA+1 CLEAR TO ILINHA-1,ICOLUNA-1
   SLINHA++
   ILINHA--
   SCOLUNA++
   ICOLUNA--
   IF (SLINHA >= L1)
      SLINHA:=L1
   ENDIF
   IF (ILINHA <= L2)
      ILINHA:=L2
   ENDIF
   IF (SCOLUNA >= C1)
      SCOLUNA:=C1
   ENDIF
   IF (ICOLUNA <= C2)
      ICOLUNA:=C2
   ENDIF
   IF SLINHA=L1 .AND. ILINHA=L2 .AND. SCOLUNA=C1 .AND. ICOLUNA=C2
      EXIT
   ENDIF
   D:= 0
   DO WHILE D<100
      D:= D + 1
   ENDDO
ENDDO
SETCOLOR(OLD)
RESTSCREEN(,,,,TELA)
RETURN(.T.)


FUNCTION ACHOFUN( nMode, nCurElement, nRowPos )
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
		KEYBOARD CHR(3)
	CASE nMode == AC_HITBOTTOM       // Attempt to go past Bottom
		KEYBOARD CHR(18)
	CASE nMode == AC_EXCEPT          // Key Exception
		DO CASE
			CASE nKey == K_RETURN         // If RETURN key, select
				nRetVal := AC_SELECT
			CASE nKey = K_ESC 					  // If ESCAPE key, abort
				nRetVal := AC_ABORT
			CASE nKey = K_LEFT 					  // If LEFT key, abort
				nRetVal := AC_ABORT
			CASE nKey = K_RIGHT 					  // If RIGHT key, abort
				nRetVal := AC_ABORT
			OTHERWISE
				nRetVal := AC_GOTO      // Otherwise, go to item
		ENDCASE
ENDCASE
*RETURN nRetVal
RETURN(nRetVal)

FUNCTION DATA(LIN,COL)
LOCAL DIA,MES
MEMVAR TRABALHO
DBF_CONFIG()
IF DOW(CONFIG->TRABALHO_V)=1
   DIA="Domingo ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=2
   DIA="Segunda ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=3
   DIA="Ter‡a ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=4
   DIA="Quarta ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=5
   DIA="Quinta ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=6
   DIA="Sexta ,"
ENDIF
IF DOW(CONFIG->TRABALHO_V)=7
   DIA="S bado ,"
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=1
   MES=" de Janeiro de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=2
   MES=" de Fevereiro de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=3
   MES=" de Mar‡o de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=4
   MES=" de Abril de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=5
   MES=" de Maio de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=6
   MES=" de Junho de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=7
   MES=" de Julho de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=8
   MES=" de Agosto de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=9
   MES=" de Setembro de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=10
   MES=" de Outubro de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=11
   MES=" de Novembro de" 
ENDIF
IF MONTH(CONFIG->TRABALHO_V)=12
   MES=" de Dezembro de" 
ENDIF
@ LIN,COL SAY DIA+STR(DAY(CONFIG->TRABALHO_V))+MES+STR(YEAR(CONFIG->TRABALHO_V))
TRABALHO:=CONFIG->TRABALHO_V
CONFIG->(DBCLOSEAREA())
RETURN(.T.)

FUNCTION DATA2(LIN,COL,DATA)
LOCAL DIA,MES
IF DOW(DATA)=1
   DIA="Domingo ,"
ENDIF
IF DOW(DATA)=2
   DIA="Segunda ,"
ENDIF
IF DOW(DATA)=3
   DIA="Ter‡a ,"
ENDIF
IF DOW(DATA)=4
   DIA="Quarta ,"
ENDIF
IF DOW(DATA)=5
   DIA="Quinta ,"
ENDIF
IF DOW(DATA)=6
   DIA="Sexta ,"
ENDIF
IF DOW(DATA)=7
   DIA="S bado ,"
ENDIF
IF MONTH(DATA)=1
   MES=" de Janeiro de" 
ENDIF
IF MONTH(DATA)=2
   MES=" de Fevereiro de" 
ENDIF
IF MONTH(DATA)=3
   MES=" de Mar‡o de" 
ENDIF
IF MONTH(DATA)=4
   MES=" de Abril de" 
ENDIF
IF MONTH(DATA)=5
   MES=" de Maio de" 
ENDIF
IF MONTH(DATA)=6
   MES=" de Junho de" 
ENDIF
IF MONTH(DATA)=7
   MES=" de Julho de" 
ENDIF
IF MONTH(DATA)=8
   MES=" de Agosto de" 
ENDIF
IF MONTH(DATA)=9
   MES=" de Setembro de" 
ENDIF
IF MONTH(DATA)=10
   MES=" de Outubro de" 
ENDIF
IF MONTH(DATA)=11
   MES=" de Novembro de" 
ENDIF
IF MONTH(DATA)=12
   MES=" de Dezembro de" 
ENDIF
@ LIN,COL SAY DIA+STR(DAY(DATA))+MES+STR(YEAR(DATA))
RETURN(.T.)

FUNCTION CONFIRMA(LIN,COL,MENSAGEM,WARN)
LOCAL COL2,TELA,SN,OLD
MEMVAR CORTEX,CORTIT,CORBAR
OLD:=SETCOLOR()
TELA:=SAVESCREEN(0,0,24,80)
COL2:=COL+LEN(MENSAGEM)+3
IF WARN = NIL
   SN=1
ELSE
   IF WARN
      SN=2
   ELSE
      SN=1
   ENDIF
ENDIF
WINDOW(LIN,COL,LIN+2,COL2+8)
SETCOLOR(CORTEX+","+CORBAR)
@ LIN+1,COL+2  SAY MENSAGEM
@ LIN+1,COL2   PROMPT "Sim"
@ LIN+1,COL2+4 PROMPT "Nao"
TONE(700,2)
TONE(700,2)
MENU TO SN
RESTSCREEN(0,0,24,80,TELA)
SETCOLOR(OLD)
RETURN(SN==1)

FUNCTION AVISO(MENSAGEM)
LOCAL TELA,OLD
MEMVAR CORTIT
TELA:=SAVESCREEN(24,0,24,80)
OLD:=SETCOLOR()
SETCOLOR(CORTIT)
@ 24,0 SAY PADC(MENSAGEM,80)
TONE(800,1)
INKEY(3)
RESTSCREEN(24,0,24,80,TELA)
SETCOLOR(OLD)
RETURN(.T.)

FUNCTION BAN_MOVI()
LOCAL NOME,MES,ANO
NOME:="MOVI"
MES :=MONTH(CONFIG->TRABALHO_V)
ANO :=YEAR(CONFIG->TRABALHO_V)
DO CASE
   CASE MES=10
      MES:="A"
   CASE MES=11
      MES:="B"
   CASE MES=12
      MES:="C"
   OTHERWISE
      MES:=ALLTRIM(STR(MES))
ENDCASE
NOME:=lower(NOME+MES+ALLTRIM(RIGHT(STR(ANO),2)))
RETURN(NOME)

FUNCTION BAN_2MOVI(DATA)
LOCAL NOME,MES,ANO
NOME:="MOVI"
MES :=MONTH(DATA)
ANO :=YEAR(DATA)
DO CASE
   CASE MES=10
      MES:="A"
   CASE MES=11
      MES:="B"
   CASE MES=12
      MES:="C"
   OTHERWISE
      MES:=ALLTRIM(STR(MES))
ENDCASE
NOME:=NOME+MES+ALLTRIM(RIGHT(STR(ANO),2))
RETURN(NOME)

FUNCTION CRIP(VARIAVEL)
LOCAL VARIA,Y,X
X=LEN(VARIAVEL)
VARIA:=SPACE(0)
FOR Y=1 TO X
   VARIA:=VARIA+CHR(ASC(SUBSTR(VARIAVEL,Y,1))+(50+Y))
NEXT Y
RETURN(VARIA)

FUNCTION DECRIP(VARIAVEL)
LOCAL VARIA,Y,X
X=LEN(VARIAVEL)
VARIA:=SPACE(0)
FOR Y=1 TO X
   VARIA:=VARIA+CHR(ASC(SUBSTR(VARIAVEL,Y,1))-(50+Y))
NEXT Y
RETURN(VARIA)

FUNCTION MemoFunction(nMode,nLine,nCol)
LOCAL X
LOCAL nKey   :=LASTKEY()
LOCAL nRetVal:=0
MEMVAR CORTEX
*Ex.:REPLACE BLNOTA_V WITH MEMOEDIT(BLNOTA_V,6,12,19,68,.T.,"MemoFunction")
X:=SETCOLOR()
SETCOLOR(CORTEX)
@ 24,0  CLEAR TO 24,80
@ 24,2  SAY "LINHA: "+ALLTRIM(STR(nLine))
@ 24,20 SAY "COLUNA: "+ALLTRIM(STR(nCol))
SETCOLOR(X)
IF LASTKEY() = 27
   RETURN K_CTRL_W
ENDIF
RETURN nRetVal

FUNCTION NEWMONTH(DATA)
DO CASE
   CASE MONTH(DATA)=10
      DATA="A"
   CASE MONTH(DATA)=11
      DATA="B"
   CASE MONTH(DATA)=12
      DATA="C"
   OTHERWISE
      DATA:=ALLTRIM(STR(MONTH(DATA)))
ENDCASE
RETURN(DATA)

FUNCTION DBLOCATE(EXPRESSAO1,TIPO,EXPRESSAO2,INICIO)
LOCAL OK
DO CASE
   CASE INICIO=(NIL)
      SKIP
ENDCASE
OK:=.F.
DO WHILE .NOT. EOF() .AND. LASTKEY()#27
   DO CASE
      CASE TIPO="="
         IF &EXPRESSAO1.=EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO="#"
         IF &EXPRESSAO1.#EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO=">"
         IF &EXPRESSAO1.>EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO=">="
         IF &EXPRESSAO1.>=EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO="<"
         IF &EXPRESSAO1.<EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO="<="
         IF &EXPRESSAO1.<=EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
      CASE TIPO="=="
         IF &EXPRESSAO1.==EXPRESSAO2
            OK:=.T.
            EXIT
         ENDIF
   ENDCASE
   DBSKIP()
ENDDO
RETURN(OK)


FUNCTION EXTENSO(valor)
LOCAL WMOEDA,WMOEDAP,UNID1,DEZE1,DEZE2,CENTE,WVALOR,DEZ0,DEZ1,CENT1,DEZ2,CENT2
LOCAL DEZ3,CENT3,DEZ4,CENT4,TRILHAO,FLAG,HIST1,HIST2,HIST3,HIST4,HIST5,HIST6
LOCAL WEXTENSOC,WEXTENSO
*******************************************
* Inicializacao das variaveis de trabalho
  wextenso = ''
  wmoeda   = 'Real'
  wmoedap  = 'Reais'

* Acerta centavos truncando se existirem
  valor = int(valor * 100) / 100

* Cancela se valor for igual ou menor que zero
  if valor <= 0.00
     return(" ")
  endif

* Inicializacao de variaveis de memoria contendo as descricoes de valores
  unid1 = 'Um    Dois  Tres  QuatroCinco Seis  Sete  Oito  Nove  '
  deze1 = 'Onze     Doze     Treze    Quatorze Quinze   DezesseisDezesseteDezoito  Dezenove '
  deze2 = 'Dez      Vinte    Trinta   Quarenta CinquentaSessenta Setenta  Oitenta  Noventa  '
  cente = 'Cento       Duzentos    Trezentos   QuatrocentosQuinhentos  Seiscentos  Setecentos  Oitocentos  Novecentos  '

* Subdivisao dos numeros em centenas e dezenas para
* bilhao, milhao, centena e unidade
  wvalor  = str(valor,16,2)
  dez0    = substr(wvalor,15,2)
  dez1    = substr(wvalor,12,2)
  cent1   = substr(wvalor,11,1)
  dez2    = substr(wvalor,9,2)
  cent2   = substr(wvalor,8,1)
  dez3    = substr(wvalor,6,2)
  cent3   = substr(wvalor,5,1)
  dez4    = substr(wvalor,3,2)
  cent4   = substr(wvalor,2,1)
  trilhao = substr(wvalor,1,1)

* Descricao do valor em trilhao
  if trilhao <> ' '
     hist1 = trim(substr(unid1,val(trilhao)*6-5,6))
     if val(trilhao) > 1
	hist1 = hist1 + ' Trilhoes'
     else
	hist1 = hist1 + ' Trilhao'
     endif
  else
     hist1 = ''
  endif

* Descricao do valor em bilhoes
  flag = .f.
  Do case
     case val(dez4) < 10 .and. val(dez4) <> 0
	  hist2 = trim(substr(unid1,val(dez4)*6-5,6))
     case val(dez4) > 10 .and. val(dez4) < 20
	  hist2 = trim(substr(deze1,val(substr(dez4,2,1))*9-8,9))
     case val(dez4) = 10
	  hist2 = ' Dez'
     case val(dez4) > 19
	  hist2 = trim(substr(deze2,val(substr(dez4,1,1))*9-8,9))
	  if val(substr(dez4,2,1)) <> 0
	     hist2 = hist2 + ' e '+ trim(substr(unid1,val(substr(dez4,2,1))*6-5,6))
	  endif
     case val(dez4) = 0 .and. val(cent4) = 0
	  hist2 = ''
	  flag = .t.
     case val(dez4) = 0 .and. val(cent4) = 1
	  hist2 = ' Cem Bilhoes'
	  flag = .t.
     case val(dez4) = 0 .and. val(cent4) > 1
	  hist2 = trim(substr(cente,val(cent4)*12-11,12)) + ' Bilhoes'
	  flag = .t.
     otherwise
	  hist2 = ''
	  flag = .t.
  endcase

* Monta bilhoes
  if .not. flag
     if cent4 <> ' ' .and. cent4 <> '0'
	hist2 = trim(substr(cente,val(cent4)*12-11,12)) + ' e ' + hist2 + ' Bilhoes'
     else
	if hist2 = 'Um'
	   hist2 = hist2 + ' Bilhao'
	else
	   hist2 = hist2 + ' Bilhoes'
	endif
     endif
  endif

* Descricao do valor em milhoes
  flag = .f.
  Do case
     case val(dez3) < 10 .and. val(dez3) <> 0
	  hist3 = trim(substr(unid1,val(dez3)*6-5,6))
     case val(dez3) > 10 .and. val(dez3) < 20
	  hist3 = trim(substr(deze1,val(substr(dez3,2,1))*9-8,9))
     case val(dez3) = 10
	  hist3 = ' Dez'
     case val(dez3) > 19
	  hist3 = trim(substr(deze2,val(substr(dez3,1,1))*9-8,9))
	  if val(substr(dez3,2,1)) <> 0
	     hist3 = hist3 + ' e '+ trim(substr(unid1,val(substr(dez3,2,1))*6-5,6))
	  endif
     case val(dez3) = 0 .and. val(cent3) = 0
	  hist3 = ''
	  flag = .t.
     case val(dez3) = 0 .and. val(cent3) = 1
	  hist3 = ' Cem Milhoes'
	  flag = .t.
     case val(dez3) = 0 .and. val(cent3) > 1
	  hist3 = trim(substr(cente,val(cent3)*12-11,12)) + ' Milhoes'
	  flag = .t.
     otherwise
	  hist3 = ''
	  flag = .t.
  endcase

* Monta milhoes
  if .not. flag
     if cent3 <> ' ' .and. cent3 <> '0'
	hist3 = trim(substr(cente,val(cent3)*12-11,12)) + ' e ' + hist3 + ' Milhoes'
     else
	if hist3 = 'um'
	   hist3 = hist3 + ' milhao'
	else
	   hist3 = hist3 + ' Milhoes'
	endif
     endif
  endif

* Descricao do valor em mil
  flag = .f.
  Do case
     case val(dez2) < 10 .and. val(dez2) <> 0
	  hist4 = trim(substr(unid1,val(dez2)*6-5,6))
     case val(dez2) > 10 .and. val(dez2) < 20
	  hist4 = trim(substr(deze1,val(substr(dez2,2,1))*9-8,9))
     case val(dez2) = 10
	  hist4 = ' Dez'
     case val(dez2) > 19
	  hist4 = trim(substr(deze2,val(substr(dez2,1,1))*9-8,9))
	  if val(substr(dez2,2,1)) <> 0
	     hist4 = hist4 + ' e '+ trim(substr(unid1,val(substr(dez2,2,1))*6-5,6))
	  endif
     case val(dez2) = 0 .and. val(cent2) = 0
	  hist4 = ''
	  flag = .t.
     case val(dez2) = 0 .and. val(cent2) = 1
	  hist4 = ' Cem Mil'
	  flag = .t.
     case val(dez2) = 0 .and. val(cent2) > 1
	  hist4 = trim(substr(cente,val(cent2)*12-11,12)) + ' Mil'
	  flag = .t.
     otherwise
	  hist4 = ''
	  flag = .t.
  endcase

* Monta mil

  if .not. flag
     if cent2 <> ' ' .and. cent2 <> '0'
	hist4 = trim(substr(cente,val(cent2)*12-11,12)) + ' e ' + hist4 + ' Mil'
     else
	hist4 = hist4 + ' Mil'
     endif
  endif

* Descricao do valor em cruzeiros
  flag = .f.
  Do case
     case val(dez1) < 10 .and. val(dez1) <> 0
	  hist5 = trim(substr(unid1,val(dez1)*6-5,6))
     case val(dez1) > 10 .and. val(dez1) < 20
	  hist5 = trim(substr(deze1,val(substr(dez1,2,1))*9-8,9))
     case val(dez1) = 10
	  hist5 = ' Dez'
     case val(dez1) > 19
	  hist5 = trim(substr(deze2,val(substr(dez1,1,1))*9-8,9))
	  if val(substr(dez1,2,1)) <> 0
	     hist5 = hist5 + ' e '+ trim(substr(unid1,val(substr(dez1,2,1))*6-5,6))
	  endif
     case val(dez1) = 0 .and. val(cent1) = 0
	  hist5 = ' ' + wmoedap
	  flag = .t.
      case val(dez1) = 0 .and. val(cent1) = 1
	  hist5 = ' Cem ' + wmoedap
	  flag = .t.
     case val(dez1) = 0 .and. val(cent1) > 1
	  hist5 = trim(substr(cente,val(cent1)*12-11,12)) + ' ' + wmoedap
	  flag = .t.
     otherwise
	  hist5 = ''
	  flag = .t.
  endcase

* Monta unidade
  if .not. flag
     if cent1 <> ' ' .and. cent1 <> '0'
	hist5 = trim(substr(cente,val(cent1)*12-11,12)) + ' e ' + hist5 + ' ' + wmoedap
     else
	if hist5 = 'Um'
	   hist5 = hist5 + ' ' + wmoeda
	else
	   hist5 = hist5 + ' ' + wmoedap
	endif
     endif
  endif

* Descricao do valor em centavos
  flag = .f.
  Do case
     case val(dez0) < 10 .and. val(dez0) <> 0
	  hist6 = trim(substr(unid1,val(dez0)*6-5,6))
     case val(dez0) > 10 .and. val(dez0) < 20
	  hist6 = trim(substr(deze1,val(substr(dez0,2,1))*9-8,9))
     case val(dez0) = 10
	  hist6 = ' Dez'
     case val(dez0) > 19
	  hist6 = trim(substr(deze2,val(substr(dez0,1,1))*9-8,9))
	  if val(substr(dez0,2,1)) <> 0
	     hist6 = hist6 + ' e '+ trim(substr(unid1,val(substr(dez0,2,1))*6-5,6))
	  endif
     otherwise
	  hist6 = ''
	  flag = .t.
  endcase

* monta centavos

  if .not. flag
     if hist6 = 'Um'
	hist6 = hist6 + ' Centavo'
     else
	hist6 = hist6 + ' Centavos'
     endif
  endif


* Montagem da descricao completa do valor
  wextenso = ''
* Monta trilhao
  if len(trim(hist1)) > 1
     wextenso = trim(hist1)
  endif

* Monta bilhao
  if len(trim(hist2)) > 1
     if len(wextenso) > 1
	wextenso = wextenso + ', ' + trim(hist2)
     else
	wextensoc = hist2
     endif
  endif

* Monta milhao
  if len(trim(hist3)) > 1
     if len(wextenso) > 1
	wextenso = wextenso + ', ' + trim(hist3)
     else
	wextenso = hist3
     endif
  endif

* Monta mil
  if len(trim(hist4)) > 1
     if len(wextenso) > 1
	wextenso = wextenso + ', ' + trim(hist4)
     else
	wextenso = hist4
     endif
  endif

* Monta Unidade
  if len(trim(hist5)) > 1
     if len(wextenso) > 1
	if hist5 = ' ' + wmoedap
	   wextenso = wextenso + hist5
	else
	   wextenso = wextenso + ', ' + trim(hist5)
	endif
     else
	if hist5 <> ' ' + wmoedap
	   wextenso = hist5
	endif
     endif
  endif

* Monta Centavos
  if len(trim(hist6)) > 1
     if len(wextenso) > 1
	wextenso = wextenso + ' e ' + trim(hist6)
     else
	wextenso = wextenso + trim(hist6)
     endif
  endif
Return(WEXTENSO)


FUNCTION NOMETEMP()
LOCAL NOME
NOME:="NE"
NOME+=LEFT(TIME(),2)+SUBSTR(TIME(),4,2)+RIGHT(TIME(),2)
RETURN NOME

FUNCTION FGets( nHandle, nLines, nLineLength, cDelim )
   local cText := ""
   
   DEFAULT cDelim to CHR(10)
   
   if nLineLength<>nil
      cText := FReadLn( nHandle, nLines, nLineLength, cDelim )
   else
      HB_FReadLine( nHandle, @cText, {chr(13)+chr(10),chr(10)} )
   endif
   
RETURN cText