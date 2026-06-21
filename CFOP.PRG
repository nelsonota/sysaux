function cfop()
local op,tela
memvar cortit,cortex,corpar,corbar,cordes,level,codsen

****** variaveis p/ cadastro de cfop
memvar cfop,mensagem,movest,movimp,movfin
tela:=savescreen(0,0,24,80)
window(20,8,22,43)
window(14,8,20,46)
@ 21,43 say chr(219)
setcolor(cortit)
@ 13,8 say "Tabela de C.F.OP."
dbf_cfop()
do while .t.
   setcolor(cortex)
   cfop:=cfop->cfop_v
   mensagem  :=cfop->mensagem_v
   movest := if(cfop->movest_v,"S","N")
   movimp := if(cfop->movimp_v,"S","N")
   movfin := if(cfop->movfin_v,"S","N")
   @ 15,10 say "C¢digo   : " + cfop
   @ 16,10 say "Descri‡ao: " + mensagem
   @ 17,10 say "Movimenta estoque   : " + movest
   @ 18,10 say "Movimenta impostos  : " + movimp
   @ 19,10 say "Movimenta financeiro: " + movfin
   setcolor(cortex+","+corbar+",,,"+cordes)
   @ 21,9  prompt " Incluir "
   @ 21,18 prompt " Buscar "
   @ 21,26 prompt " Alterar "
   @ 21,35 prompt " Apagar "
   menu to op
   do case
      case op=1
         icfop()
      case op=2
         dbe_cfop(10,20,20,50)
      case op=3
         acfop()
      case op=4
         if confirma(20,20,"Confirma Exclusao ?")
            if cfop->(reclock())
               cfop->(dbdelete())
               cfop->(dbunlock())
            endif
         endif
      otherwise
         exit
   endcase
enddo
cfop->(dbclosearea())
restscreen(0,0,24,80,tela)
return(.t.)