FUNCTION MENUUTI()
LOCAL GetList:={},OPCOES,OP,TELA,TELA1,OPCOES2,OP2,hIni,SelPrinter
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(3,40,13,63)
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR)
   OPCOES:={"  Fechamento de Caixa ","  Senhas              ",;
            " "+CHR(16)+"Configura‡oes       "," "+chr(16)+"Corre‡oes           ",;
            "  C¢pia de Seguran‡a  ","  Restaura C¢pia      ",;
            "  Shell do Sistema    ","  Porta p/Impressora  ",;
            "  Exportacao" }
   OP:=ACHOICE(4,41,12,62,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         IF ACCCOM("41")
            FECHA()
         ENDIF
      CASE OP=2
         IF ACCCOM("42")
            SET KEY 28 TO
            MSENHA()
            SET KEY 28 TO AJUDA()
         ENDIF
      CASE OP=3
         IF ACCCOM("43")
            CONFIG()
         ENDIF
      CASE OP=4
         IF ACCCOM("44")
            MCORRECT()
         ENDIF
      CASE OP=5
         IF ACCCOM("45")
            COPIA()
         ENDIF
      CASE OP=6
         IF ACCCOM("46")
            RESTAURA()
         ENDIF
      CASE OP=7
         IF ACCCOM("47")
            TELA1:=SAVESCREEN()
            SETCOLOR("W/N")
            CLS
            ? " SysAux - Sistema de Auxilio em Gerenciamento de Empresas"
            ? " Revendedor Autorizado"
            ? " Genoma Tecnologia em Inform tica"
            ? " genomatec@terra.com.br genomati@uol.com.br"
            ? " Shell do Sistema                              "
            ? " Para retornar digite EXIT + [Enter]           "
            RUN COMMAND.COM
            RESTSCREEN(,,,,TELA1)
         ENDIF
      CASE OP=8
         if !file("c:\sysaux.ini")
            hIni := Hash()
            hIni["MAIN"] :=  Hash()
            hIni["MAIN" ]["Impressora" ]  := "GetDefaultPrinter()"
            HB_WriteIni( "c:\sysaux.ini", hIni, ;
                            "; Start comment", "; End comment" )
         endif
         hIniData := HB_ReadIni( "c:\sysaux.ini" )
         SelPrinter := padr(hIniData["MAIN"]["Impressora"],100)
         TELA1:=SAVESCREEN()
         WINDOW(12,02,14,79)
         @ 13,04 say "Imprimir em :" get SelPrinter pict "@S60"
         read
         if lastkey()<>27
            if confirma(20,20,"Confirma impressora ?")
               hIni := Hash()
               hIni["MAIN"] :=  Hash()
               hIni["MAIN" ]["Impressora" ]  := SelPrinter
               HB_WriteIni( "c:\sysaux.ini", hIni, ;
                               "; Start comment", "; End comment" )
            endif
         endif
         RESTSCREEN(,,,,TELA1)
      CASE OP=9
         IF ACCCOM("49")
            exportacao()
         endif
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(3,40,11,63)
TEL_PRINCIPAL()
SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
@ 24,1 SAY " Usu rio : " + NOMSEN+" N¡vel : "+LEVEL
RETURN(.T.)