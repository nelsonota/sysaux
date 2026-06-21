FUNCTION ARQLOCK(TEMPO)
LOCAL TELA,OLD,TEMPO2,OK
MEMVAR CORTIT
OLD:=SETCOLOR()
TELA:=SAVESCREEN(24,0,24,80)
TEMPO2:=0
OK:=0
IF TEMPO=NIL
   TEMPO:=10
ENDIF
DO WHILE TEMPO2<=TEMPO
   IF FLOCK()
      OK:=1
      EXIT
   ELSE
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Aguarde Tentando Acesso Ao Arquivo "+alltrim(alias()),80)
      INKEY(1)
   ENDIF
   TEMPO2++
ENDDO
RESTSCREEN(24,0,24,80,TELA)
SETCOLOR(OLD)
IF OK=1
   RETURN(.T.)
ELSE
   RETURN(.F.)
ENDIF
RETURN(.F.)

FUNCTION RECLOCK(TEMPO)
LOCAL TELA,OLD,TEMPO2,OK
MEMVAR CORTIT
OLD:=SETCOLOR()
TELA:=SAVESCREEN(24,0,24,80)
TEMPO2:=0
OK:=0
IF TEMPO=NIL
   TEMPO:=10
ENDIF
DO WHILE .T. //TEMPO2<=TEMPO
   IF RLOCK()
      OK:=1
      EXIT
   ELSE
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Aguarde Tentando Acesso Ao Registro "+alltrim(alias()),80)
      INKEY(1)
      IF LASTKEY() == 27
         IF CONFIRMA(20,20,"Deseja cancelar a operacao ?")
            EXIT
         ENDIF
      ENDIF
   ENDIF
   TEMPO2++
ENDDO
RESTSCREEN(24,0,24,80,TELA)
SETCOLOR(OLD)
IF OK=1
   RETURN(.T.)
ELSE
   RETURN(.F.)
ENDIF
RETURN(.F.)

FUNCTION ADDREC(TEMPO)
LOCAL TELA,OLD,TEMPO2,OK
MEMVAR CORTIT
OLD:=SETCOLOR()
TELA:=SAVESCREEN(24,0,24,80)
TEMPO2:=0
OK:=0
IF TEMPO=NIL
   TEMPO:=10
ENDIF
DO WHILE .T. // TEMPO2<=TEMPO
   DBAPPEND()
   IF ! NETERR()
      OK:=1
      EXIT
   ELSE
      SETCOLOR(CORTIT)
      @ 24,0 SAY PADC("Aguarde Tentando Acesso Ao Arquivo "+alltrim(alias()),80)
      INKEY(1)
      IF LASTKEY() == 27
         IF CONFIRMA(20,20,"Deseja cancelar a operacao ?")
            EXIT
         ENDIF
      ENDIF
   ENDIF
   TEMPO2++
ENDDO
RESTSCREEN(24,0,24,80,TELA)
SETCOLOR(OLD)
IF OK=1
   RETURN(.T.)
ELSE
   RETURN(.F.)
ENDIF
RETURN(.F.)

function ws(cXml, cAction)
local oUrl, cData, cRet, output_error, output_debug
local lf := chr(13)+chr(10)
if !empty(alltrim(config->hash_v))
   cXml += '&hash='+config->hash_v
   if (config->dbgxmig_v == 'S')
      output_debug := fcreate('ws/ws.txt')
      fwrite(output_debug, alltrim(config->urlxmig_v)+cAction+lf)
      fwrite(output_debug, cXml+lf)
   endif
   try
   	oUrl := TURL():New( alltrim(config->urlxmig_v) )
   	oUrl:cPath := cAction // "/agendamentos/cadastra_agendamento"
   	oInternet := TIPClientHTTP():New(oUrl)
   	oInternet:cUserAgent := "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"
   	cData := ""
   	//oUrl:cFile := "prova.php"
   	WITH OBJECT oInternet
   	   IF :Open()
   	      IF :Post(cXml)
   	         DO WHILE !Empty((cRet:=:Read()))
   	            cData += cRet
   	         ENDDO
   	         if (config->dbgxmig_v == 'S')
   	            fwrite(output_debug, cData+lf)
   	         endif
   	         processado = at("processado", cData)
               if processado > 0
                  if lower(substr(cData, at(":", cData)+1, 1)) == 'f'
                     Throw( ErrorNew( "Conexao", 0, 0, "Solicitacao nao processada " + cData + lf))
                  endif
               endif
   		   else
   		      Throw( ErrorNew( "Conexao", 0, 0, "Nao foi possivel postar os dados" + lf))
   	      ENDIF
   	   else
   	      Throw( ErrorNew( "Conexao", 0, 0, "Nao foi possivel abrir a conexao" + lf))
   	   ENDIF
   	   :Close()
   	END WITH
   catch oErr
      output_error := fcreate('ws/ws'+dtos(date())+strtran(time(),':','')+'.txt')
      fwrite(output_error, oErr:operation+cAction+lf)
      fwrite(output_error, alltrim(config->urlxmig_v)+cAction+lf)
      fwrite(output_error, cXml+lf)
      fclose(output_error)
   end
   if (config->dbgxmig_v == 'S')
      fclose(output_debug)
   endif
ENDIF
return

function xmig_pagrec(mpagrec)
local cWs, cParc
if !empty(alltrim(config->hash_v))
   if mpagrec == nil
      cParc := '1'
      cWS := 'dtvenc'+cParc+'='+dtos(pagrec->datven_v)+;
             '&descr'+cParc+'='+alltrim(pagrec->desc_v)+;
             '&val'+cParc+'='+alltrim(str(pagrec->valor_v,14,2))+;
             '&dtext'+cParc+'='+alltrim(dtos(pagrec->datext_v))+;
             '&docuext'+cParc+'='+alltrim(pagrec->docext_v)+;
             '&dtint'+cParc+'='+alltrim(dtos(pagrec->datint_v))+;
             '&docuint'+cParc+'='+alltrim(pagrec->docint_v)+;
             '&codpagrec'+cParc+'='+alltrim(pagrec->codigo_v)
   else
      cWs = xmig_convert_pagrec(mpagrec)
   endif
   cWs += '&codclifor='+alltrim(clifor->codigo_v)
   cWs += '&nome='+alltrim(clifor->nome_v)
   cWs += '&fantasia='+alltrim(clifor->fantasia_v)
   cWs += '&pessoa='+alltrim(clifor->pessoa_v)
   cWs += '&cgccpf='+alltrim(sonumero(clifor->cgccpf_v))
   cWs += '&rgie='+alltrim(clifor->rginsest_v)
   cWs += '&end='+alltrim(clifor->endereco_v)
   cWs += '&numend='+alltrim(clifor->numero_v)
   cWs += '&compend='+alltrim(clifor->complem_v)
   cWs += '&bairro='+alltrim(clifor->bairro_v)
   cWs += '&cidade='+alltrim(clifor->cidade_v)
   cWs += '&estado='+alltrim(clifor->estado_v)
   cWs += '&cep='+alltrim(clifor->cep_v)
   cWs += '&fone1='+alltrim(substr(clifor->fone1_v,-10,10))
   cWs += '&fone2='+alltrim(substr(clifor->fone2_v,-10,10))
   cWs += '&fax='+alltrim(substr(clifor->fax_v,-10,10))
   cWs += '&email='+alltrim(clifor->email_v)
   cWs += '&ref1='+alltrim(clifor->refere1_v)
   cWs += '&telref1='+alltrim(substr(clifor->telref1_v,-10,10))
   cWs += '&ref2='+alltrim(clifor->refere2_v)
   cWs += '&telref2='+alltrim(substr(clifor->telref2_v,-10,10))
   cWs += '&ref1='+alltrim(clifor->refere1_v)
   cWs += '&revenda='+alltrim(clifor->revenda_v)
   cWs += '&contato='+alltrim(clifor->contato_v)
   cWs += '&cend='+alltrim(clifor->endcob_v)
   cWs += '&cnumend='+alltrim(clifor->numcob_v)
   cWs += '&ccompend='+alltrim(clifor->compcob_v)
   cWs += '&cbairro='+alltrim(clifor->baicob_v)
   cWs += '&ccidade='+alltrim(clifor->cidcob_v)
   cWs += '&cuf='+alltrim(clifor->estcob_v)
   cWs += '&ccep='+alltrim(clifor->cepcob_v)
   cWs += '&eend='+alltrim(clifor->endent_v)
   cWs += '&enumend='+alltrim(clifor->nument_v)
   cWs += '&ecompend='+alltrim(clifor->compent_v)
   cWs += '&ebairro='+alltrim(clifor->baient_v)
   cWs += '&ecidade='+alltrim(clifor->cident_v)
   cWs += '&euf='+alltrim(clifor->estent_v)
   cWs += '&ecep='+alltrim(clifor->cepent_v)
   if select('plano')>0
   	cWs += '&codplano='+alltrim(plano->codigo_v)+;
   	       '&nomepla='+alltrim(plano->nome_v)
   else
   	cWs += '&codplano='+alltrim(pagrec->codpla_v)+;
   			 '&nomepla='
   endif
   ws(cWs, '/agendamentos/cadastra_agendamento')
endif
return

function xmig_add_pagrec(mpagrec)
local cWs, cParc
cParc = alltrim(str(len(mpagrec)+1))
cWS := "dtvenc"+cParc+"="+dtos(pagrec->datven_v)+;
       "&descr"+cParc+"="+alltrim(pagrec->desc_v)+;
       "&val"+cParc+"="+alltrim(str(pagrec->valor_v,14,2))+;
       "&dtext"+cParc+"="+alltrim(dtos(pagrec->datext_v))+;
       "&docuext"+cParc+"="+alltrim(pagrec->docext_v)+;
       "&dtint"+cParc+"="+alltrim(dtos(pagrec->datint_v))+;
       "&docuint"+cParc+"="+alltrim(pagrec->docint_v)+;
       "&codpagrec"+cParc+"="+alltrim(pagrec->codigo_v)
aadd(mpagrec, cWs)
return

function xmig_convert_pagrec(mpagrec)
local cWs, i
cWs := ""
for i := 1 to len(mpagrec)
   cWs += if(i>1, '&', '')+mpagrec[i]
next
return cWs

function xmig_canc_pagrec(mpagrec)
local cWs, i
cWs := ""
for i := 1 to len(mpagrec)
   cWs += if(i>1, '&', '')+'codpagrec'+alltrim(str(i))+'='+mpagrec[i]
next
ws(cWs, "/agendamentos/cancela_agendamento")
return