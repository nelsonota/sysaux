#include "dbinfo.ch"
REQUEST DBFCDX
request DBFFPT

FUNCTION MAIN(PARAMETRO)
LOCAL GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,DATAPATH,LEVEL,CODSEN,TRABALHO,NOMSEN,IMPFUN
MEMVAR COMPR,COMPON,NORMAL,COMPOFF,ENFOFF,ENFON,EXPON,EXPOFF,ITALON,ITALOFF,CPI10,CPI12,RESET
MEMVAR SYSVEN,BLQVEN
SETMODE(25,80)
SETCANCEL(.T.)
SETBLINK(.F.)
SET DEFA TO (GETENV("DATACOML"))
SET EPOCH TO 1940
SET CENTURY    ON
SET CONFIRM    ON
SET DATE       BRIT
SET DELETED    ON
SET SCOREBOARD OFF
SET SOFTSEEK   OFF
SET WRAP       ON
IF file("cdx\config.dbf")
   DATAPATH       :="CDX\"
   RDDSETDEFAULT("DBFCDX")
   //SET DBFLOCKSCHEME TO DB_DBFLOCK_CL53
ELSE
   DATAPATH       :="NTX\"
   RDDSETDEFAULT("DBFNTX")
ENDIF
LEVEL          :="NE"
SYSVEN         :=SPACE(6)
BLQVEN         :="S"
CODSEN         :=0
IMPFUN         :=0
NOMSEN         :=SPACE(10)
CORTIT         :="BG+/B*"
CORTEX         :="W/B+"
CORPAR         :="BG+/N+*"
CORBAR         :="GR+/R+"
CORDES         :="W+/N"
COMPR          :=CHR( 15 )
COMPON	       :=CHR( 15 )
NORMAL	       :=CHR( 18 )
COMPOFF        :=CHR( 18 )
ENFON          :=CHR( 27 ) + CHR( 69 )
ENFOFF	       :=CHR( 27 ) + CHR( 70 )
EXPON	         :=CHR( 14 )
EXPOFF         :=CHR( 20 )
ITALON	       :=CHR( 27 ) + "4"
ITALOFF        :=CHR( 27 ) + "5"
CPI10        	 :=CHR( 27 ) + CHR( 80 )
CPI12        	 :=CHR( 27 ) + CHR( 77 )
RESET	         :=""
IF PARAMETRO<>(NIL) .AND. UPPER(PARAMETRO)="/CONVERTE"
   CONVERTE()
   QUIT
ENDIF
VERIFY()
DBF_CONFIG()
TRABALHO       :=CONFIG->TRABALHO_V
IF ! PARAMETRO="/7913"
//   IF DATE()-CONFIG->REGISTRO_V>CONFIG->VALREG_V
//      AVISO("Imposs¡vel continuar... truncada a chave de uso.")
//      RETURN(.F.)
//   ENDIF
//   IF CONFIG->VALREG_V#CONFIG->LOCK_V
//      AVISO("Vocˆ nao conseguiu destravar o sistema....")
//      AVISO("Chame seu Supervisor no praxo m ximo de 24h,")
//      AVISO("para que todos os dados nao sejam apagados")
//      RETURN(.F.)
//   ENDIF
*   IF .NOT. FILE("C:\WINDOWS\SYSTEM\AUXSYS.DLL") .AND. .NOT. FILE("C:\WINNT\SYSTEM32\AUXSYS.DLL")
*      AVISO("Reprodu‡ao nao autorizada")
*      SCROLL(0,0,24,79)
*      @ 0,0 say padc("Adquira sua licensa com a NeO Systems",80)
*      @ 1,0 say padc("Entre em contato pelos E-Mails nelson_ota@hotmail.com",80)
*      @ 2,0 say padc("ou pelo fone 3837-0790",80)
*      RETURN(.F.)
*   ENDIF
ENDIF
CONFIG->(DBCLOSEAREA())
WINDOW(0,0,24,80)
TEL_PRINCIPAL()
DO CASE
   CASE PARAMETRO=(NIL)
      IF "CDX"$DATAPATH
         IF .NOT. FILE(DATAPATH+"*.cdx")
            IF ! INDICE()
               RETURN(.F.)
            ENDIF
         ENDIF
      ELSE
         IF .NOT. FILE(DATAPATH+"*.ntx")
            IF ! INDICE()
               RETURN(.F.)
            ENDIF
         ENDIF
      ENDIF
   CASE UPPER(PARAMETRO)="/VERIFICA"
      verificaCampos()
      IF ! INDICE()
         RETURN(.F.)
      ENDIF
   CASE UPPER(PARAMETRO)="/R"
      IF ! INDICE()
         RETURN(.F.)
      ENDIF
   CASE UPPER(PARAMETRO)="/?"
      WINDOW(10,10,13,37)
      @ 11,12 SAY "/? - Tela de Ajuda      "
      @ 12,12 SAY "/R - Reorganiza Arquivos"
      @ 13,12 SAY "/CONVERTE - Converte NTX-CDX"
      @ 14,12 SAY "/VERIFICA - Confere campos dos arquivos"
      RETURN(.T.)
   CASE UPPER(PARAMETRO)="/XMIG"
      exporta_xmig()
      return nil
   CASE UPPER(PARAMETRO)="/MAILNFE"
      mail_nfe()
      return nil
ENDCASE

IF SENHA(20,15)
   USERVAR()
   DBF_SENHA()
   IF SENHA->(DBSEEK(CODSEN))
      IF SENHA->PAGAR_V  ="S"
         RELFUT("P",TRABALHO,TRABALHO)
      ENDIF
      IF SENHA->RECEBER_V="S"
         RELFUT("R",TRABALHO,TRABALHO)
      ENDIF
   ENDIF
   SENHA->(DBCLOSEAREA())
   DBF_MOEDA()
   MOEDA->(DBGOBOTTOM())
   IF MOEDA->DATA_V<DATE()
      WINDOW(10,10,13,25)
      @ 11,11 SAY "US$ "+DTOC(DATE()) COLOR CORTIT
      MOEDA->(DBAPPEND())
      MOEDA->MOEDA_V:="US$"
      MOEDA->DATA_V:=DATE()
      @ 12,14 GET MOEDA->VALOR_V PICT "@R 9,999.99"
      READ
   ELSE
      WINDOW(10,10,13,25)
      MOEDA->(RECLOCK(5))
      @ 11,11 SAY "US$ "+DTOC(DATE()) COLOR CORTIT
      @ 12,14 GET MOEDA->VALOR_V PICT "@R 9,999.99"
      READ
   ENDIF
   MOEDA->(DBUNLOCK())
   MOEDA->(DBCLOSEAREA())
*   DBF_ACCCOM()
   DBF_PRIVIL()
   COMERCIO()
   SETMODE(25,80)
ELSE
   TONE(100,4)
   TONE(50,6)
ENDIF
SETCOLOR("W/N")
CLS
CLOSEWIN(0,0,24,80)
@ 24,0
RETURN(.T.)


//function corest()
//local i, lAchei
//dbf_movest()
//dbf_2pedido()
//pedido2->(dbsetorder(1), dbseek("V26782"))
//i := 0
//do while !pedido2->(eof())
//   if !empty(pedido2->datbai_v)
//      ++i
//      @ 10,10 say "Verificando :" + str(i,3)
//      @ 11,10 say "pedido " + pedido2->codigo_v + "Item: " + pedido2->item_v + " qtd:"+alltrim(str(pedido2->qtd_v))
//      lAchei := .f.
//      movest->(dbsetorder(1), dbseek(dtos(pedido2->datbai_v)+pedido2->item_v))
//      do while !movest->(eof()) .and. movest->codigo_v == pedido2->item_v .and. !lAchei
//         if left(pedido2->codigo_v,1) == "V"
//            lAchei := movest->tipomov_v == "VM" .and. movest->doc_v == pedido2->codigo_v .and. movest->qtd_v*-1 = pedido2->qtd_v
//         endif
//         movest->(dbskip())
//      enddo
//      if !lAchei
//         if left(pedido2->codigo_v,1) == "V"
//            if confirma(20,20,"Confirma pedido " + pedido2->codigo_v + "Item: " + pedido2->item_v + " qtd:"+alltrim(str(pedido2->qtd_v)))
//               movest("S",pedido2->item_v, "VM", pedido2->qtd_v, pedido2->codigo_v)
//            endif
//         endif
//      endif
//   endif
//   pedido2->(dbskip())
//enddo
//return nil