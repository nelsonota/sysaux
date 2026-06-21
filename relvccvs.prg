function relvccvs()
local separador,produto,arquivo,tela,getlist:={}, nNota, nValorICMS, nValorFrete
memvar cortit,cortex,corpar,corbar,cordes,level,codsen,trabalho
memvar inicio,fim
tela:=savescreen()
dbf_pedido()
dbf_2pedido()
dbf_estoque()
dbf_clifor()
dbf_mecven()
DBF_NOTA()
DBF_NOTA2()
do while .t.
   set century on
   window(10,10,14,63)
   setcolor(cortex+","+corbar+",,,"+cordes)
   inicio := ctod("")
   fim := ctod("")
   produto := space(len(estoque->nome_v))
   separador := ","
   @ 11,12 say "Data inicial :" get inicio valid(!empty(inicio))
   @ 11,39 say "Data final :"   get fim     valid(fim>=inicio)
   @ 12,12 say "Produto :" get produto pict "@!S40"
   @ 13,12 say "Separar casas decimais com (. ou ,):" get separador valid separador$".,"
   read
   set century off
   if lastkey()=27
      exit
   endif
   if confirma(10,10,"O arquivo .cvs sera gerado no seu desktop, continuar ?")
      arquivo := ""
//      arquivo := lower(alltrim(getenv("HOMEDRIVE")))
//      arquivo += lower(alltrim(getenv("HOMEPATH")))
      arquivo += "\relvccvs"+dtos(date())+left(strtran(time(),":",""),4)+".csv"
      set printer to (arquivo)
      set device to printer

      @ prow(),1 say "Pedido;Data Emissao;Codigo Cliente;Nome Cliente;Codigo Produto;Nome Produto;Familia Produto;Valor Unitario;Quantidade;Valor Total;Nota;Valor ICMS;Frete;Vendedor"
      pedido->(dbsetorder(3),dbseek(inicio,.t.))
      do while !pedido->(eof()) .and. pedido->datemi_v >= inicio .and. pedido->datemi_v <= fim
         mecven->(dbsetorder(1), dbseek(pedido->mecven_v))
         if left(pedido->codigo_v,1)="V"
            pedido2->(dbsetorder(1),dbseek(pedido->codigo_v))
            do while ! pedido2->(eof()) .and. pedido2->codigo_v == pedido->codigo_v
               clifor->(dbsetorder(1),dbseek(pedido->clifor_v))
               estoque->(dbsetorder(1),dbseek(pedido2->item_v))
               if estoque->nome_v=alltrim(produto)
               		nNota := 0
               		nValorICMS := 0
               		nValorFrete := 0
               		if nota->(dbsetorder(3), dbseek(pedido->codigo_v))
               			nNota := nota->codigo_v
               			if nota2->(dbsetorder(3), dbseek(str(nota->codigo_v,6)+dtos(nota->datemi_v)+pedido2->item_v))
               				nValorICMS := ((nota2->valuni_v*nota2->qtd_v) + nota2->frete_v) * (nota2->bascal_v/100) * (nota2->icms_v / 100)
               				nValorFrete := nota2->frete_v
               			endif
									endif
                  @ prow()+1,1 say pedido->codigo_v + ";" +;
                                   dtoc(pedido->datemi_v) + ";" +;
                                   pedido->clifor_v + ";" +;
                                   alltrim(clifor->nome_v) + ";" +;
                                   pedido2->item_v + ";" +;
                                   alltrim(estoque->nome_v) + ";" +;
                                   alltrim(estoque->familia_v) + ";" +;
                                   transform(pedido2->valuni_v, if(separador=",","@e","") + "99999999999.9999") + ";" +;
                                   transform(pedido2->qtd_v, if(separador=",","@e","") + "99999999999.99") + ";" +;
                                   transform(pedido2->valuni_v * pedido2->qtd_v, if(separador=",","@e","") + "99999999999.99") + ";" +;
                                   str(nNota,6) + ";" +;
                                   transform(nValorICMS, if(separador=",","@e","") + "99999999999.99")+";"+;
                                   transform(nValorFrete, if(separador=",","@e","") + "99999999999.99")+";"+;
                                   mecven->nome_v
               endif
               pedido2->(dbskip())
            enddo
         endif
         pedido->(dbskip())
      enddo
      
      set printer to
      set device to screen
      aviso("Arquivo gerado com sucesso.")
   endif
enddo
restscreen(,,,,tela)
mecven->(dbclosearea())
estoque->(dbclosearea())
pedido->(dbclosearea())
pedido2->(dbclosearea())
clifor->(dbclosearea())
nota->(dbclosearea())
nota2->(dbclosearea())
return nil