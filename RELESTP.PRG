function relestp()
local op,opcoes,tela
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
tela:=savescreen(0,0,24,80)
window(8,33,23,73)
do while .t.
   opcoes:={"  Itens por Inicial                    ",;
            "  Itens por Fornecedor                 ",;
            "  Itens por Fornecedor e Inicial       ",;
            "  Itens por Fam¡lia                    ",;
            "  Itens por Fam¡lia e Fornecedor       ",;
            "  Itens por Fam¡lia e Fabricante       ",;
            "  Itens por Fam¡lia e Grupo de Imposto ",;
            "  Itens por NCM                        ",;
            "  Geral por Ordem Alfab‚tica           ",;
            "  Geral por Ordem de C¢digos           ",;
            "  Itens em falta no estoque            ",;
            "  Itens em excesso no estoque          ",;
            "  Extrato de Movimentacao              ",;
            "  Itens com reserva                    " }
   op:=achoice(09,34,22,72,opcoes,.t.,"achofun")
   do case
      case op=1
         reestini(,"P")
      case op=2
         reestfor(,"P")
      case op=3
         resinifo(,"P")
      case op=4
         reestfam(,)
      case op=5
         reestfam("F",,"P")
      case op=6
         reestfam("I",,"P")
      case op=7
         reestfam("G",,"P")
      case op=8
         reestncm()
      case op=9
         reestord("A",,"P")
      case op=10
         reestord("C",,"P")
      case op=11
         reestfe("FAL")
      case op=12
         reestfe("EXC")
      case op=13
         reestmov()
      case op=14
         reestres()
      otherwise
         exit
   endcase
enddo
restscreen(0,0,24,80,tela)
closewin(9,33,20,67)
return(.t.)