FUNCTION RELESTL()
LOCAL OP,OPCOES,TELA,VC
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(9,33,20,67)
IF CONFIRMA(15,20,"Ativar impressao com valor de custo ?")
   VC:="S"
ELSE
   VC:="N"
ENDIF
DO WHILE .T.
   OPCOES:={"  Itens por Inicial              ",;
            "  Itens por Fornecedor           ",;
            "  Itens por Fornecedor e Inicial ",;
            "  Itens por Fam¡lia              ",;
            "  Itens por Fam¡lia e Fornecedor ",;
            "  Itens por Fam¡lia e Fabricante ",;
            "  Geral por Ordem Alfab‚tica     ",;
            "  Geral por Ordem de C¢digos     ",;
            "  Itens em falta no estoque      ",;
            "  Itens em excesso no estoque    " }
   OP:=ACHOICE(10,34,19,66,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         REESTINI(VC,"L")
      CASE OP=2
         REESTFOR(VC,"L")
      CASE OP=3
         RESINIFO(VC,"L")
      CASE OP=4
         REESTFAM(,VC,"L")
      CASE OP=5
         REESTFAM("F",VC,"L")
      CASE OP=6
         REESTFAM("I",VC,"L")
      CASE OP=7
         REESTORD("A",VC,"L")
      CASE OP=8
         REESTORD("C",VC,"L")
      CASE OP=9
         REESTFE("FAL")
      CASE OP=10
         REESTFE("EXC")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(9,33,20,67)
RETURN(.T.)