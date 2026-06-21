function exportacao()
local op, opcoes,tela
opcoes := {"  Exportar cadastro de produtos ",;
					 "  Exportar cadastro de clientes/fornecedores ",;
           "  Exportar cadastros para NF-e  "}
tela:=savescreen()
window(7,29,10,75)
do while .t.
   op := achoice(8,30,9,74,opcoes,.t.,"ACHOFUN")
   do case
      case op == 1
         expcadestoque()
      case op == 2
         expcadpessoas()
      case op == 3
         expcadnfe()
      otherwise
         exit
   endcase
enddo
restscreen(,,,,tela)
return nil

function expcadestoque()
local nHandle, comando, i
if confirma(20,10,"Iniciar exportacao do cadastro de produtos?")
   //nHandle := fcreate('./exporta/cadestoque.csv')
   nHandle := fcreate('./exporta/produtos.sql')
   dbf_estoque()
   dbf_2pedido()
   estoque->(dbgotop())
   comando := "insert into produtos (empresa_id, usuario_id, created, modified, codigo, codigo_fabricante, ean, ncm, nome, localizacao, fabricante, aplicacao, unidade, ultimo_custo, custo_medio, valor_de_venda, origem_mercadoria_id, data_atualizacao_cadastro, quantidade_inicial) values "
   fwrite(nHandle, comando)
   i := 0
   do while !estoque->(eof())
      ++i
      pedido2->(dbsetorder(3), dbseek(estoque->codigo_v))
      lOk := .f.
      do while !pedido2->(eof()) .and. pedido2->item_v == estoque->codigo_v .and. !lOk
         lOk := dtos(pedido2->datemi_v)>='20100101'
         pedido2->(dbskip())
      enddo
   	//fwrite(nHandle, quoted(estoque->codigo_v)+';'+quoted(estoque->nome_v)+';'+quoted(estoque->localiza_v)+';'+quoted(estoque->familia_v)+chr(13)+chr(10))
   	if lOk
       comando = if(i>1,',','')+"(4,3,now(),now(),"+;
   							quoted(estoque->codigo_v)+","+;
   							quoted(estoque->codigof_v)+","+;
   							quoted(estoque->ean_v)+","+;
   							quoted(estoque->ncm_v)+","+;
   							quoted(estoque->nome_v)+","+;
   							quoted(estoque->localiza_v)+","+;
   							quoted(estoque->fabrican_v)+","+;
   							quoted(estoque->aplica_v)+","+;
   							quoted(estoque->unidade_v)+","+;
   							alltrim(str(estoque->ultcus_v,14,2))+","+;
   							alltrim(str(estoque->ultcus_v,14,2))+","+;
   							alltrim(str(estoque->valven_v,14,2))+","+;
   							str(estoque->sittaba_v+1,1)+","+;
   							if(empty(estoque->datatu_v),'null',quoted(transform(dtos(estoque->datatu_v),'@r9999-99-99')))+","+;
   							alltrim(str(estoque->qtd_v))+;
   							")"+chr(13)+chr(10)
   		fwrite(nHandle, comando)
   	endif
   	estoque->(dbskip())
   enddo
   fclose(nHandle)
   estoque->(dbclosearea())
   pedido2->(dbclosearea())
   aviso("Arquivo ./exporta/cadestoque.csv gerado com sucesso.")
endif
return nil

function quoted(texto)
return '"'+alltrim(strtran(texto,'"','\"'))+'"'

function expcadnfe()
   //expnfeemitente()
   //expnfeclientes()
   expnfeprodutos()
   aviso("Arquivos ./exporta/nfe*.txt gerados com sucesso.")
return nil

function expnfeemitente()
local nHandle, cTexto, cgccpf
local Terminator := chr(13)+chr(10)
dbf_config()
dbf_cadcid()
config->(dbgotop())
nHandle := fcreate("./exporta/nfe_emitente.txt")
fwrite(nHandle, "EMITENTE|1|"+Terminator)
fwrite(nHandle, "A|1.01"+Terminator)
cgccpf := alltrim(sonumero(decrip(config->cgc_v)))
cTexto := "C"+;
       "|"+if(len(cgccpf)>11,"CNPJ","CPF")+;
       "|"+cgccpf+;
       "|"+alltrim(decrip(config->nome_v))+;
       "|"+;
       "|"+if(len(cgccpf)>11,sonumero(decrip(config->insest_v)),"")+;
       "|"+;
       "|"+;
       "|"+;
       "|"+alltrim(decrip(config->endereco_v))+;
       "|"+alltrim(decrip(config->numero_v))+;
       "|"+alltrim(decrip(config->complem_v))+;
       "|"+alltrim(decrip(config->bairro_v))+;
       "|"+if(cadcid->(dbsetorder(1), dbseek(decrip(config->cidade_v)+decrip(config->estado_v)) ), alltrim(cadcid->ibge_v),"")+;
       "|"+alltrim(decrip(config->cidade_v))+;
       "|"+alltrim(decrip(config->estado_v))+;
       "|"+alltrim(decrip(config->cep_v))+;
       "|1058"+;
       "|BRASIL"+;
       "|"+alltrim(trataFone(decrip(config->fone1_v)))+Terminator
fwrite(nHandle, cTexto)
fclose(nHandle)
config->(dbclosearea())
cadcid->(dbclosearea())
return nil

function expnfeclientes()
local nHandle, cTexto, cgccpf, aClientes, nCliente
local Terminator := chr(13)+chr(10), i, fone
nHandle := fcreate("./exporta/nfe_clientes.txt")
dbf_clifor()
dbf_cadcid()

clifor->(dbgotop())
aClientes := array(0)
do while !clifor->(eof())
   if left(clifor->codigo_v,1)=="C" .and. cgccpf( alltrim(sonumero(clifor->cgccpf_v)), .f. ) .and. if(len(sonumero(clifor->cgccpf_v))>11,ieok(clifor->rginsest_v, clifor->estado_v),.t.)
      cgccpf := alltrim(sonumero(clifor->cgccpf_v))
      cTexto := "E"+;
                "|"+if(len(cgccpf)>11,"CNPJ","CPF")+;
                "|"+strzero(val(cgccpf), if(len(cgccpf)>11, 14, 11))+;
                "|"+alltrim(clifor->nome_v)+;
                "|"+if(len(cgccpf)>11, sonumero(clifor->rginsest_v), "")+;
                "|"+; // suframa
                "|"+alltrim(clifor->endereco_v)+;
                "|"+alltrim(clifor->numero_v)+;
                "|"+alltrim(clifor->complem_v)+;
                "|"+alltrim(clifor->bairro_v)+;
                "|"+if(cadcid->(dbsetorder(1), dbseek(clifor->cidade_v+clifor->estado_v)), alltrim(cadcid->ibge_v),"")+;
                "|"+alltrim(clifor->cidade_v)+;
                "|"+alltrim(clifor->estado_v)+;
                "|"+alltrim(clifor->cep_v)+;
                "|1058"+;
                "|BRASIL"+;
                "|"+trataFone(clifor->fone1_v)+"|"+Terminator
      ncliente := ascan(aClientes, {|x| x[1] == cgccpf})
      if ncliente == 0
         aadd(aClientes, {cgccpf, cTexto})
      else
         aClientes[nCliente] := {cgccpf, cTexto}
      endif
   endif
   clifor->(dbskip())
enddo
fwrite(nHandle, "CLIENTE|"+alltrim(str(len(aClientes)))+"|"+Terminator)
for i:= 1 to len(aClientes)
   fwrite(nHandle, "A|1.01"+Terminator)
   fwrite(nHandle, verificaCaracter(aClientes[i][2]))
next
fclose(nHandle)
clifor->(dbclosearea())
cadcid->(dbclosearea())
return nil

function verificaCaracter(cTexto)
local nAsc, i
local cRetorno := ""
for i:=1 to len(cTexto)
   nAsc := asc(substr(cTexto,i,1))
   if (nAsc >=32 .and. nAsc <= 126) .or. nAsc==13 .or. nAsc==10
      cRetorno += substr(ctexto,i,1)
   endif
next
return cRetorno

function expnfeprodutos()
local nHandle, cProduto, aProdutos, aIcms, cIcms, cTributos
local Terminator := chr(13)+chr(10), i, i2
nHandle := fcreate("./exporta/nfe_produtos.txt")
dbf_estoque()
aProdutos := array(0)

estoque->(dbgotop())
do while !estoque->(eof())
   cProduto := "I" +;
             "|"+alltrim(estoque->codigo_v)+;
             "|"+alltrim(estoque->nome_v)+;
             "|"+alltrim(estoque->ean_v)+;
             "|"+alltrim(estoque->ncm_v)+;
             "|"+;
             "|"+;
             "|"+estoque->unidade_v+;
             "|"+if(estoque->valven_v>0,alltrim(str(estoque->valven_v,14,2)),"")+;
             "|"+;
             "|"+;
             "|"+;
             "|"+Terminator
   aIcms := array(0)
   cIcms := "N"+;
            "|"+strzero(estoque->sittabb_v,2)+;
            "|"+strzero(estoque->sittaba_v,1)+;
            "|"+;
            "|"+;
            "|"+;
            "|"+;
            "|"+;
            "|"+Terminator
            
   aadd(aIcms, cIcms)
   
   cTributos := "M"+;
                "|0"+;
                "|"+alltrim(str(len(aIcms)))+"|"+Terminator
   aadd(aProdutos, {cProduto, cTributos, aIcms})
   estoque->(dbskip())
enddo

fwrite(nHandle, "PRODUTO|"+alltrim(str(len(aProdutos)))+"|"+Terminator)
for i:= 1 to len(aProdutos)
   fwrite(nHandle, "A|1.01"+Terminator)
   fwrite(nHandle, verificaCaracter(aProdutos[i][1]))
   fwrite(nHandle, verificaCaracter(aProdutos[i][2]))
   for i2:=1 to len(aProdutos[i][3])
      fwrite(nHandle, verificaCaracter(aProdutos[i][3][i2]))
   next
next
fclose(nHandle)
estoque->(dbclosearea())
return nil

function expcadpessoas()
local nHandle, cTexto, cgccpf, aClifor, nClifor
local Terminator := chr(13)+chr(10), i, fone
nHandle := fcreate("./exporta/cadpessoas.txt")
dbf_clifor()
dbf_cadcid()

clifor->(dbgotop())
aClifor := array(0)
do while !clifor->(eof())
   if cgccpf( alltrim(sonumero(clifor->cgccpf_v)), .f. ) .and. if(len(sonumero(clifor->cgccpf_v))>11,ieok(clifor->rginsest_v, clifor->estado_v),.t.)
      cgccpf := alltrim(sonumero(clifor->cgccpf_v))
      cTexto := strzero(val(cgccpf), if(len(cgccpf)>11, 14, 11))+;
                ";"+quoted(clifor->nome_v)+;
                ";"+quoted(clifor->fantasia_v)+;
                ";"+if(len(cgccpf)>11, sonumero(clifor->rginsest_v), quoted(clifor->rginsest_v))+;
                ";"+quoted(clifor->endereco_v)+;
                ";"+quoted(clifor->numero_v)+;
                ";"+quoted(clifor->complem_v)+;
                ";"+quoted(clifor->bairro_v)+;
                ";"+if(cadcid->(dbsetorder(1), dbseek(clifor->cidade_v+clifor->estado_v)), alltrim(cadcid->ibge_v),"")+;
                ";"+quoted(clifor->cidade_v)+;
                ";"+quoted(clifor->estado_v)+;
                ";"+quoted(clifor->cep_v)+;
                ";"+trataFone(clifor->fone1_v)+;
                ";"+trataFone(clifor->fone2_v)+;
                ";"+trataFone(clifor->fax_v)+;
                ";"+quoted(clifor->email_v)+;
                ";"+quoted(clifor->refere1_v)+;
                ";"+trataFone(clifor->telref1_v)+;
                ";"+quoted(clifor->refere2_v)+;
                ";"+trataFone(clifor->telref2_v)+;
                ";"+quoted(clifor->contato_v)+;
                ";"+quoted(clifor->revenda_v)+;
                ";"+quoted(clifor->pessoa_v)+;
                ";"+quoted(clifor->endcob_v)+;
                ";"+quoted(clifor->numcob_v)+;
                ";"+quoted(clifor->compcob_v)+;
                ";"+quoted(clifor->baicob_v)+;
                ";"+if(cadcid->(dbsetorder(1), dbseek(clifor->cidcob_v+clifor->estcob_v)), alltrim(cadcid->ibge_v),"")+;
                ";"+quoted(clifor->cidcob_v)+;
                ";"+quoted(clifor->estcob_v)+;
                ";"+quoted(clifor->cepcob_v)+;
                ";"+quoted(clifor->endent_v)+;
                ";"+quoted(clifor->nument_v)+;
                ";"+quoted(clifor->compent_v)+;
                ";"+quoted(clifor->baient_v)+;
                ";"+if(cadcid->(dbsetorder(1), dbseek(clifor->cident_v+clifor->estent_v)), alltrim(cadcid->ibge_v),"")+;
                ";"+quoted(clifor->cident_v)+;
                ";"+quoted(clifor->estent_v)+;
                ";"+quoted(clifor->cepent_v)
      nClifor := ascan(aClifor, {|x| x[1] == cgccpf})
      if nclifor == 0
         aadd(aClifor, {cgccpf, cTexto+tipoPessoa()})
      else
         cTipo := tipoPessoa()
         if right(aClifor[nClifor],2)<>cTipo
            cTipo := ';A'
         endif
         aClifor[nClifor] := {cgccpf, cTexto+cTipo}
      endif
   endif
   clifor->(dbskip())
enddo
for i:= 1 to len(aClifor)
   fwrite(nHandle, verificaCaracter(aClifor[i][2])+Terminator)
next
fclose(nHandle)
clifor->(dbclosearea())
cadcid->(dbclosearea())
return nil

function tipoPessoa()
local cTipo
if left(clifor->codigo_v,1)$'CF'
   cTipo := ";"+left(clifor->codigo_v,1)
else
   cTipo := ";F"
endif
return cTipo