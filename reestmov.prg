function reestmov()
local inicio, fim, tela, getlist :={}
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar item
tela := savescreen()
dbf_config()
dbf_movest()
dbf_estoque()
dbf_clifor()
dbf_pedido()
do while .t.
   window(5,8,8,61)
   item := space(len(movest->codigo_v))
   inicio := ctod("")
   fim := ctod("")
   @ 6,10 say "Codigo:" get item pict "@!" valid(sea_estoque(item))
   @ 7,10 say "Data inicial :" get inicio valid(!empty(inicio))
   @ 7,37 say "Data final :"   get fim     valid(fim>=inicio)
   read
   if lastkey()=27
      exit
   endif
   linha := {}
   movest->(dbsetorder(2), dbseek(item+dtos(inicio),.t.))
   do while !movest->(eof()) .and. movest->codigo_v==item .and. movest->data_v>= inicio .and. movest->data_v<=fim
      nota := 0
      if pedido->(dbsetorder(1), dbseek(movest->doc_v))
         if movest->tipomov_v == "VM"
            nota := pedido->nota_v
         elseif movest->tipomov_v == "CM"
            nota := pedido->notacom_v
         endif
      endif
      aadd(linha, dtoc(movest->data_v)+;
                  " "+movest->tipomov_v+;
                  " "+movest->doc_v+;
                  " "+if(nota=0,space(6),strzero(nota,6))+;
                  " "+padl(transform(if(movest->qtd_v>0,movest->qtd_v,""),"@e 999,999"),7)+;
                  " "+padl(transform(if(movest->qtd_v<0,movest->qtd_v,""),"@e 999,999"),7)+;
                  " "+padl(transform(movest->saldo_v,"@e 999,999"),7)+;
                  " "+movest->usuario_v )
      movest->(dbskip())
   enddo
   window(2,0,23,79)
   @ 3,1 say padc("Extrato: "+item+" "+left(estoque->nome_v,29)+" de "+dtoc(inicio)+" a "+dtoc(fim),78) color cortit
   @ 4,1 say padr(" Data       Tp Doc    Nota   Entrada   Saida   Saldo Usuario",78) color cortit
   //               99/99/9999 99 999999 999999 999.999 999.999 999.999
   @ 5,1 to 5,78
   achoice(6,2,21,78,linha)
   if confirma(20,20,"Deseja Imprimir ?")
      c_imprel("Extrato: "+item+" "+left(estoque->nome_v,29)+" de "+dtoc(inicio)+" a "+dtoc(fim),"Data       Tp Doc    Nota   Entrada   Saida   Saldo",52)
   endif
enddo
config->(dbclosearea())
pedido->(dbclosearea())
clifor->(dbclosearea())
estoque->(dbclosearea())
movest->(dbclosearea())
restscreen(,,,,tela)
return nil