function verify()
local campos,nome,codsen, registros, i
memvar datapath
if .not. file(datapath+"config.dbf") //
   campos:={}
   aadd(campos,{"registro_v","D",8 ,0 })
   aadd(campos,{"system_v"  ,"N",10,0 })
   aadd(campos,{"impcven_v" ,"C",1 ,0 })
   aadd(campos,{"protect_v" ,"C",1 ,0 })
   aadd(campos,{"clifor_v"  ,"N",5 ,0 })
   aadd(campos,{"cotacao_v" ,"N",6 ,0 })
   aadd(campos,{"mecven_v"  ,"N",5 ,0 })
   aadd(campos,{"bascal_v"  ,"N",5 ,0 })
   aadd(campos,{"bank_v"    ,"N",5 ,0 })
   aadd(campos,{"vista_v"   ,"N",5 ,0 })
   aadd(campos,{"pagrec_v"  ,"N",5 ,0 })
   aadd(campos,{"tecnica_v" ,"N",5 ,0 })
   aadd(campos,{"senha_v"   ,"N",5 ,0 })
   aadd(campos,{"transp_v"  ,"N",5 ,0 })
   aadd(campos,{"pedcom_v"  ,"N",5 ,0 })
   aadd(campos,{"pedven_v"  ,"N",5 ,0 })
   aadd(campos,{"nf_v"      ,"N",6 ,0 })
   aadd(campos,{"producao_v","N",7 ,0 })
   aadd(campos,{"trabalho_v","D",8 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"endereco_v","C",50,0 })
   aadd(campos,{"numero_v"  ,"C",6 ,0 })
   aadd(campos,{"complem_v" ,"C",10,0 })
   aadd(campos,{"bairro_v"  ,"C",30,0 })
   aadd(campos,{"cidade_v"  ,"C",30,0 })
   aadd(campos,{"estado_v"  ,"C",2 ,0 })
   aadd(campos,{"cep_v"     ,"C",8 ,0 })
   aadd(campos,{"cgc_v"     ,"C",18,0 })
   aadd(campos,{"insest_v"  ,"C",15,0 })
   aadd(campos,{"insmun_v"  ,"C",15,0 })
   aadd(campos,{"fone1_v"   ,"C",12,0 })
   aadd(campos,{"fone2_v"   ,"C",12,0 })
   aadd(campos,{"fax_v"     ,"C",12,0 })
   aadd(campos,{"valreg_v"  ,"N",5 ,0 })
   aadd(campos,{"linbol1_v" ,"C",47,0 })
   aadd(campos,{"linbol2_v" ,"C",47,0 })
   aadd(campos,{"linbol3_v" ,"C",47,0 })
   aadd(campos,{"linbol4_v" ,"C",47,0 })
   aadd(campos,{"infger_v"  ,"M",10,0 })
   aadd(campos,{"textorc_v" ,"M",10,0 })
   aadd(campos,{"avisai_v"  ,"M",10,0 })
   aadd(campos,{"recosai_v" ,"M",10,0 })
   aadd(campos,{"nfcompl_v" ,"C",50,0 })
   aadd(campos,{"lock_v"    ,"N",5 ,0 })
   aadd(campos,{"autven_v"  ,"C",1 ,0 })
   aadd(campos,{"autcom_v"  ,"C",1 ,0 })
   aadd(campos,{"km_v"      ,"N",6 ,0 })
   aadd(campos,{"ml_v"      ,"N",6 ,0 })
   aadd(campos,{"kmserie_v" ,"C",1 ,0 })
   aadd(campos,{"qtditens_v","N",2 ,0 })
   aadd(campos,{"modped_v"  ,"N",2 ,0 })
   aadd(campos,{"deficms_v" ,"N",7 ,4 })
   aadd(campos,{"descapl_v" ,"C",1 ,0 })
   aadd(campos,{"multprcv_v","C",1 ,0 })
   aadd(campos,{"lckqtdv_v" ,"C",1 ,0 })
   aadd(campos,{"lckmax_v"  ,"C",1 ,0 })
   aadd(campos,{"modnf_v"   ,"C",1 ,0 })
   aadd(campos,{"movest_v"  ,"N",8 ,0 })
   aadd(campos,{"nfe_v"     ,"C",1 ,0 })
   aadd(campos,{"tipaut_v"  ,"C",1 ,0 })
   aadd(campos,{"ambiente_v","C",1 ,0 })
   aadd(campos,{"regtrib_v" ,"C",1 ,0 })
   aadd(campos,{"cnae_v"    ,"C",7 ,0 })
   aadd(campos,{"hash_v"    ,"C",32,0 })
   aadd(campos,{"urlxmig_v" ,"C",50,0 })
   aadd(campos,{"nfs_v"     ,"C",1 ,0 })
   aadd(campos,{"dbgxmig_v" ,"C",1 ,0 })
   aadd(campos,{"msgfisc_v" ,"C",99,0 })
   dbcreate(datapath+"config",campos)
   dbf_config()
   if config->(addrec(5))
      config->trabalho_v:=date()
      config->registro_v:=date()
      config->kmserie_v :="s"
      config->lock_v    :=30
      config->valreg_v  :=30
      config->lckqtdv_v :="S"
      config->descapl_v :="N"
      config->modped_v  :=1
      config->tipaut_v  :='N'
      config->autven_v  :='S'
      config->autcom_v  :='S'
      config->multprcv_v:='S'
      config->lckmax_v  :='S'
      config->ambiente_v:='1'
      config->regtrib_v :='2'
      config->nfe_v     :='N'
      config->nfs_v     :='N'
      config->(dbunlock())
   endif
   config->(dbclosearea())
endif

dbf_config()
nome:=ban_movi()
config->(dbclosearea())
if .not. file(datapath+nome+".dbf")
   campos:={}
   aadd(campos,{"datlan_v"  ,"D",8 ,0 })
   aadd(campos,{"futvis_v"  ,"C",1 ,0 })
   aadd(campos,{"pagrec_v"  ,"C",6 ,0 })
   aadd(campos,{"banco_v "  ,"N",5 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"docext_v"  ,"C",10,0 })
   aadd(campos,{"desc_v"    ,"C",50,0 })
   aadd(campos,{"docint_v"  ,"C",10,0 })
   aadd(campos,{"datext_v"  ,"D",8 ,0 })
   aadd(campos,{"datint_v"  ,"D",8 ,0 })
   aadd(campos,{"cheque_v"  ,"C",6 ,0 })
   aadd(campos,{"datven_v"  ,"D",8 ,0 })
   aadd(campos,{"datbai_v"  ,"D",8 ,0 })
   aadd(campos,{"valor_v"   ,"N",14,2 })
   aadd(campos,{"codpla_v"  ,"C",4 ,0 })
   aadd(campos,{"desconto_v","N",14,2 })
   aadd(campos,{"deducao_v" ,"N",14,2 })
   aadd(campos,{"multa_v"   ,"N",14,2 })
   aadd(campos,{"acres_v"   ,"N",14,2 })
   aadd(campos,{"valdoc_v"  ,"N",14,2 })
   aadd(campos,{"boleto_v"  ,"C",16,0 })
   aadd(campos,{"codbanbo_v","N",5 ,0 })
   aadd(campos,{"duplica_v" ,"C",10,0 })
   aadd(campos,{"codbandu_v","N",5 ,0 })
   aadd(campos,{"cobchq_v"  ,"C",6 ,0 })
   aadd(campos,{"cbcodban_v","C",4 ,0 })
   aadd(campos,{"cobbanco_v","C",10,0 })
   aadd(campos,{"cobconta_v","C",8 ,0 })
   aadd(campos,{"cobagen_v" ,"C",4 ,0 })
   aadd(campos,{"protesto_v","C",1 ,0 })
   aadd(campos,{"codporta_v","C",2 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   dbcreate(datapath+nome,campos)
endif

if .not. file(datapath+"pagrec.dbf") 
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",6 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"pedido_v"  ,"C",6 ,0 })
   aadd(campos,{"tecnica_v" ,"C",5 ,0 })
   aadd(campos,{"docext_v"  ,"C",10,0 })
   aadd(campos,{"docint_v"  ,"C",10,0 })
   aadd(campos,{"datext_v"  ,"D",8 ,0 })
   aadd(campos,{"datint_v"  ,"D",8 ,0 })
   aadd(campos,{"desc_v"    ,"C",50,0 })
   aadd(campos,{"datven_v"  ,"D",8 ,0 })
   aadd(campos,{"valor_v"   ,"N",14,2 })
   aadd(campos,{"boleto_v"  ,"C",16,0 })
   aadd(campos,{"codbanbo_v","N",5 ,0 })
   aadd(campos,{"duplica_v" ,"C",10,0 })
   aadd(campos,{"codbandu_v","N",5 ,0 })
   aadd(campos,{"cobchq_v"  ,"C",6 ,0 })
   aadd(campos,{"cbcodban_v","C",4 ,0 })
   aadd(campos,{"cobbanco_v","C",10,0 })
   aadd(campos,{"cobconta_v","C",8 ,0 })
   aadd(campos,{"cobagen_v" ,"C",4 ,0 })
   aadd(campos,{"codpla_v"  ,"C",4 ,0 })
   aadd(campos,{"protesto_v","C",1 ,0 })
   aadd(campos,{"codporta_v","C",2 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   dbcreate(datapath+"pagrec",campos)
endif

if .not. file(datapath+"estoque.dbf") //
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",12,0 })
   aadd(campos,{"codigof_v" ,"C",12,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"aplica_v"  ,"C",50,0 })
   aadd(campos,{"fabrican_v","C",50,0 })
   aadd(campos,{"qtd_v"     ,"N",14,2 })
   aadd(campos,{"reserva_v" ,"N",14,2 })
   aadd(campos,{"excesso_v" ,"N",14,2 })
   aadd(campos,{"falta_v"   ,"N",14,2 })
   aadd(campos,{"moeda_v"   ,"C",1 ,0 })
   aadd(campos,{"valcus_v"  ,"N",16,4 })
   aadd(campos,{"ultcus_v"  ,"N",16,4 })
   aadd(campos,{"dtultcus_v","D",8 ,0 })
   aadd(campos,{"ultest_v"  ,"N",14,2 })
   aadd(campos,{"ultped_v"  ,"C",6 ,0 })
   aadd(campos,{"pencus_v"  ,"N",16,4 })
   aadd(campos,{"dtpencus_v","D",8 ,0 })
   aadd(campos,{"penest_v"  ,"N",14,2 })
   aadd(campos,{"penped_v"  ,"C",6 ,0 })
   aadd(campos,{"percent_v" ,"N",7 ,2 })
   aadd(campos,{"descrev_v" ,"N",7 ,2 })
   aadd(campos,{"valven_v"  ,"N",14,2 })
   aadd(campos,{"permed_v"  ,"N",7 ,2 })
   aadd(campos,{"valmed_v"  ,"N",14,2 })
   aadd(campos,{"permax_v"  ,"N",14,2 })
   aadd(campos,{"valmax_v"  ,"N",14,2 })
   aadd(campos,{"valrev_v"  ,"N",14,2 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"unidade_v" ,"C",2 ,0 })
   aadd(campos,{"ipi_v"     ,"N",2 ,0 })
   aadd(campos,{"sittaba_v" ,"N",1 ,0 })
   aadd(campos,{"sittabb_v" ,"N",3 ,0 })
   aadd(campos,{"familia_v" ,"C",20,0 })
   aadd(campos,{"localiza_v","C",20,0 })
   aadd(campos,{"pesoliq_v" ,"N",7 ,3 })
   aadd(campos,{"pesobrt_v" ,"N",7 ,3 })
   aadd(campos,{"datatu_v"  ,"D",8 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"codimp_v"  ,"N",5 ,0 })
   aadd(campos,{"ncm_v"     ,"C",10,0 })
   aadd(campos,{"ean_v"     ,"C",14,0 })
   aadd(campos,{"ultmov_v"  ,"D",8 ,0 })
   dbcreate(datapath+"estoque",campos)
endif

if .not. file(datapath+"clifor.dbf") //
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",6 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"revenda_v" ,"C",1 ,0 })
   aadd(campos,{"fantasia_v","C",50,0 })
   aadd(campos,{"obs_v"     ,"C",50,0 })
   aadd(campos,{"obs1_v"    ,"C",50,0 })
   aadd(campos,{"email_v"   ,"C",90,0 })
   aadd(campos,{"endereco_v","C",50,0 })
   aadd(campos,{"numero_v"  ,"C",6 ,0 })
   aadd(campos,{"complem_v" ,"C",10,0 })
   aadd(campos,{"bairro_v"  ,"C",30,0 })
   aadd(campos,{"cidade_v"  ,"C",30,0 })
   aadd(campos,{"estado_v"  ,"C",2 ,0 })
   aadd(campos,{"cep_v"     ,"C",8 ,0 })
   aadd(campos,{"fone1_v"   ,"C",12,0 })
   aadd(campos,{"fone2_v"   ,"C",12,0 })
   aadd(campos,{"fax_v"     ,"C",12,0 })
   aadd(campos,{"contato_v" ,"C",50,0 })
   aadd(campos,{"cgccpf_v"  ,"C",19,0 })
   aadd(campos,{"rginsest_v","C",15,0 })
   aadd(campos,{"inssuf_v"  ,"C",9 ,0 })
   aadd(campos,{"refere1_v" ,"C",40,0 })
   aadd(campos,{"telref1_v" ,"C",12,0 })
   aadd(campos,{"refere2_v" ,"C",40,0 })
   aadd(campos,{"telref2_v" ,"C",12,0 })
   aadd(campos,{"endcob_v"  ,"C",50,0 })
   aadd(campos,{"numcob_v"  ,"C",6 ,0 })
   aadd(campos,{"compcob_v" ,"C",10,0 })
   aadd(campos,{"baicob_v"  ,"C",30,0 })
   aadd(campos,{"cidcob_v"  ,"C",30,0 })
   aadd(campos,{"estcob_v"  ,"C",2 ,0 })
   aadd(campos,{"cepcob_v"  ,"C",8 ,0 })
   aadd(campos,{"fonecob1_v","C",12,0 })
   aadd(campos,{"fonecob2_v","C",12,0 })
   aadd(campos,{"faxcob_v"  ,"C",12,0 })
   aadd(campos,{"endent_v"  ,"C",50,0 })
   aadd(campos,{"nument_v"  ,"C",6 ,0 })
   aadd(campos,{"compent_v" ,"C",10,0 })
   aadd(campos,{"baient_v"  ,"C",30,0 })
   aadd(campos,{"cident_v"  ,"C",30,0 })
   aadd(campos,{"estent_v"  ,"C",2 ,0 })
   aadd(campos,{"cepent_v"  ,"C",8 ,0 })
   aadd(campos,{"foneent1_v","C",12,0 })
   aadd(campos,{"foneent2_v","C",12,0 })
   aadd(campos,{"faxent_v"  ,"C",12,0 })
   aadd(campos,{"midia_v"   ,"N",2 ,0 })
   aadd(campos,{"codtran_v" ,"N",5 ,0 })
   aadd(campos,{"datcad_v"  ,"D",8 ,0 })
   aadd(campos,{"datped_v"  ,"D",8 ,0 })
   aadd(campos,{"ultped_v"  ,"C",6 ,0 })
   aadd(campos,{"valped_v"  ,"N",14,2 })
   aadd(campos,{"dattec_v"  ,"D",8 ,0 })
   aadd(campos,{"ulttec_v"  ,"C",5 ,0 })
   aadd(campos,{"datmai_v"  ,"D",8 ,0 })
   aadd(campos,{"pedmai_v"  ,"C",6 ,0 })
   aadd(campos,{"valmai_v"  ,"N",14,2 })
   aadd(campos,{"codven_v"  ,"C",6 ,0 })
   aadd(campos,{"pessoa_v"  ,"C",1 ,0 })
   aadd(campos,{"texto_v"   ,"M",10,0 })
   aadd(campos,{"black_v"   ,"M",10,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"emailnf_v" ,"C",90,0 })
   aadd(campos,{"insmun_v"  ,"C",15,0 })
   dbcreate(datapath+"clifor",campos)
endif

if .not. file(datapath+"mecven.dbf") //
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",6 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"endereco_v","C",50,0 })
   aadd(campos,{"numero_v"  ,"C",6 ,0 })
   aadd(campos,{"complem_v" ,"C",10,0 })
   aadd(campos,{"bairro_v"  ,"C",30,0 })
   aadd(campos,{"cidade_v"  ,"C",30,0 })
   aadd(campos,{"estado_v"  ,"C",2 ,0 })
   aadd(campos,{"cep_v"     ,"C",8 ,0 })
   aadd(campos,{"fone1_v"   ,"C",12,0 })
   aadd(campos,{"fone2_v"   ,"C",12,0 })
   aadd(campos,{"fax_v"     ,"C",12,0 })
   aadd(campos,{"contato_v" ,"C",50,0 })
   aadd(campos,{"cgccpf_v"  ,"C",19,0 })
   aadd(campos,{"rginsest_v","C",15,0 })
   aadd(campos,{"calcula_v" ,"C",1 ,0 })
   aadd(campos,{"percent_v" ,"N",7 ,2 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"allcli_v"  ,"C",1 ,0 })
   dbcreate(datapath+"mecven",campos)
endif

if .not. file(datapath+"bank.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"N",5 ,0 })
   aadd(campos,{"nome_v"    ,"C",10,0 })
   aadd(campos,{"conta_v"   ,"C",13,0 })
   aadd(campos,{"agencia_v" ,"C",7 ,0 })
   aadd(campos,{"saldo_v"   ,"N",14,2 })
   aadd(campos,{"aplica_v"  ,"N",14,2 })
   aadd(campos,{"bloqueio_v","N",14,2 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"nobank_v"  ,"C",1 ,0 })
   dbcreate(datapath+"bank",campos)
endif

if .not. file(datapath+"cheque.dbf")
   campos:={}
   aadd(campos,{"codban_v"  ,"N",5 ,0 })
   aadd(campos,{"cheque_v"  ,"C",6 ,0 })
   aadd(campos,{"valor_v"   ,"N",14,2 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"datbai_v"  ,"D",8 ,0 })
   aadd(campos,{"obs_v"     ,"C",10,0 })
   dbcreate(datapath+"cheque",campos)
endif

if .not. file(datapath+"cadimp.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"N",5 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   dbcreate(datapath+"cadimp",campos)
endif

if .not. file(datapath+"bascal.dbf") //
   campos:={}
   aadd(campos,{"codimp_v"  ,"N",5 ,0 })
   aadd(campos,{"codigo_v"  ,"N",5 ,0 })
   aadd(campos,{"sittabb_v" ,"C",3 ,0 })
   aadd(campos,{"modbc_v"   ,"N",1 ,0 })
   aadd(campos,{"bascal_v"  ,"N",7 ,2 })
   aadd(campos,{"icms_v"    ,"N",7 ,4 })
   aadd(campos,{"bascalpf_v","N",7 ,2 })
   aadd(campos,{"icmspf_v"  ,"N",7 ,4 })
   aadd(campos,{"modbcst_v" ,"N",1 ,0})
   aadd(campos,{"mgvradic_v","N",7 ,4})
   aadd(campos,{"bascalst_v","N",7 ,2 })
   aadd(campos,{"icmsst_v"  ,"N",7 ,4 })
   aadd(campos,{"bcstpf_v"  ,"N",7 ,2 })
   aadd(campos,{"icmsstpf_v","N",7 ,4 })
   aadd(campos,{"mensagem_v","C",80,0 })
   aadd(campos,{"sigla_v"   ,"C",2 ,0 })
   aadd(campos,{"estado_v"  ,"C",30,0 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"modpis_v"  ,"C",2 ,0 })
   aadd(campos,{"pis_v"     ,"N",7 ,4 })
   aadd(campos,{"mdcofins_v","C",2 ,0 })
   aadd(campos,{"cofins_v"  ,"N",7 ,4 })
   aadd(campos,{"aliqcred_v","N",7 ,4 })
   dbcreate(datapath+"bascal",campos)
endif

if .not. file(datapath+"senha.dbf")
   campos:={}
   aadd(campos,{"codsen_v"  ,"N",5 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"senha_v"   ,"C",10,0 })
   aadd(campos,{"level_v"   ,"C",2 ,0 })
   aadd(campos,{"codven_v"  ,"C",6 ,0 })
   aadd(campos,{"impfun_v"  ,"N",1 ,0 })
   aadd(campos,{"cortit_v"  ,"C",9 ,0 })
   aadd(campos,{"cortex_v"  ,"C",9 ,0 })
   aadd(campos,{"corpar_v"  ,"C",9 ,0 })
   aadd(campos,{"corbar_v"  ,"C",9 ,0 })
   aadd(campos,{"cordes_v"  ,"C",9 ,0 })
   aadd(campos,{"pagar_v"   ,"C",1 ,0 })
   aadd(campos,{"receber_v" ,"C",1 ,0 })
   aadd(campos,{"filpr_v"   ,"C",1 ,0 })
   aadd(campos,{"filcf_v"   ,"C",1 ,0 })
   dbcreate(datapath+"senha",campos)
   if !file(datapath+"privil.dbf")
      dbusearea(.t.,,datapath+"config","config",.f.)
      dbusearea(.t.,,datapath+"senha","senha",.f.)
      if config->(reclock(5))
         config->senha_v:=config->senha_v+1
         codsen:=config->senha_v
         config->(dbunlock())

         senha->(addrec(5))
         senha->codsen_v:=codsen
         senha->nomsen_v:="ADMIN"
         senha->senha_v :=crip("250596")
         senha->codven_v:=""
         senha->level_v :="NE"
         senha->cortit_v:="GR+/BR+"
         senha->cortex_v:="W/B+"
         senha->corpar_v:="BG+/N+*"
         senha->corbar_v:="GR+/R+"
         senha->cordes_v:="W+/N"
         senha->(dbunlock())
      endif
      config->(dbclosearea())
      senha->(dbclosearea())
   endif
endif

if .not. file(datapath+"privil.dbf")
   campos:={}
   aadd(campos,{"codsen_v"  ,"N",5 ,0 })
   aadd(campos,{"codmen_v"  ,"C",6 ,0 })
   dbcreate(datapath+"privil",campos)
endif

if .not. file(datapath+"plano.dbf") 
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",4 ,0 })
   aadd(campos,{"nome_v"    ,"C",15,0 })
   dbcreate(datapath+"plano",campos)
endif

if .not. file(datapath+"tecnica.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",5 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"item_v"    ,"C",20,0 })
   aadd(campos,{"marca_v"   ,"C",20,0 })
   aadd(campos,{"modelo_v"  ,"C",10,0 })
   aadd(campos,{"nserie_v"  ,"C",15,0 })
   aadd(campos,{"tipokm_v"  ,"C",1 ,0 })
   aadd(campos,{"qtdkm_v"   ,"N",8 ,1 })
   aadd(campos,{"ano_v"     ,"C",4 ,0 })
   aadd(campos,{"cor_v"     ,"C",15,0 })
   aadd(campos,{"tanque_v"  ,"C",1 ,0 })
   aadd(campos,{"placa_v"   ,"C",8 ,0 })
   aadd(campos,{"orcament_v","C",1 ,0 })
   aadd(campos,{"texto_v"   ,"M",10,0 })
   aadd(campos,{"datent_v"  ,"D",8 ,0 })
   aadd(campos,{"datorc_v"  ,"D",8 ,0 })
   aadd(campos,{"datapr_v"  ,"D",8 ,0 })
   aadd(campos,{"datexe_v"  ,"D",8 ,0 })
   aadd(campos,{"datexe2_v" ,"D",8 ,0 })
   aadd(campos,{"datsai_v"  ,"D",8 ,0 })
   aadd(campos,{"pagrec_v"  ,"C",6 ,0 })
   aadd(campos,{"pagrec1_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec2_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec3_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec4_v" ,"C",6 ,0 })
   aadd(campos,{"datpag_v"  ,"D",8 ,0 })
   aadd(campos,{"datpag1_v" ,"D",8 ,0 })
   aadd(campos,{"datpag2_v" ,"D",8 ,0 })
   aadd(campos,{"datpag3_v" ,"D",8 ,0 })
   aadd(campos,{"datpag4_v" ,"D",8 ,0 })
   aadd(campos,{"valpar_v"  ,"N",14,2 })
   aadd(campos,{"valpar1_v" ,"N",14,2 })
   aadd(campos,{"valpar2_v" ,"N",14,2 })
   aadd(campos,{"valpar3_v" ,"N",14,2 })
   aadd(campos,{"valpar4_v" ,"N",14,2 })
   aadd(campos,{"datgar_v"  ,"D",8 ,0 })
   aadd(campos,{"mecven_v"  ,"C",6 ,0 })
   aadd(campos,{"serv_v"    ,"C",3 ,0 })
   aadd(campos,{"garantia_v","C",5 ,0 })
   aadd(campos,{"valmo_v"   ,"N",14,2 })
   aadd(campos,{"valterc_v" ,"N",14,2 })
   aadd(campos,{"valoutro_v","N",14,2 })
   aadd(campos,{"valitot_v" ,"N",14,2 })
   aadd(campos,{"nota_v"    ,"N",6 ,0 })
   aadd(campos,{"avar1_v"   ,"C",76,0 })
   aadd(campos,{"avar2_v"   ,"C",76,0 })
   aadd(campos,{"avar3_v"   ,"C",76,0 })
   aadd(campos,{"solicli1_v","C",76,0 })
   aadd(campos,{"solicli2_v","C",76,0 })
   aadd(campos,{"solicli3_v","C",76,0 })
   aadd(campos,{"orient1_v" ,"C",76,0 })
   aadd(campos,{"orient2_v" ,"C",76,0 })
   aadd(campos,{"orient3_v" ,"C",76,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"nomorc_v"  ,"C",10,0 })
   aadd(campos,{"nomsai_v"  ,"C",10,0 })
   aadd(campos,{"codpla_v"  ,"C",4 ,0 })
   aadd(campos,{"nfs_v"     ,"N",6 ,0 })
   dbcreate(datapath+"tecnica",campos)
endif

if .not. file(datapath+"tecnica2.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",5 ,0 })
   aadd(campos,{"item_v"    ,"C",12,0 })
   aadd(campos,{"tipo_v"    ,"C",1 ,0 })
   aadd(campos,{"valuni_v"  ,"N",14,2 })
   aadd(campos,{"qtd_v"     ,"N",14,2 })
   aadd(campos,{"nf_v"      ,"C",1 ,0 })
   aadd(campos,{"icms_v"    ,"N",7 ,4 })
   aadd(campos,{"bascal_v"  ,"N",6 ,2 })
   aadd(campos,{"tbascal_v" ,"C",80,0 })
   aadd(campos,{"ipi_v"     ,"N",5 ,2 })
   aadd(campos,{"valipi_v"  ,"N",14,2 })
   aadd(campos,{"frete_v"   ,"N",16,4 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"sittaba_v" ,"N",1 ,0 })
   aadd(campos,{"sittabb_v" ,"N",3 ,0 })
   aadd(campos,{"modbc_v"   ,"N",1 ,0 })
   aadd(campos,{"modbcst_v" ,"N",1 ,0 })
   aadd(campos,{"mgvradic_v","N",7 ,4 })
   aadd(campos,{"bascalst_v","N",7 ,2 })
   aadd(campos,{"icmsst_v"  ,"N",7 ,4 })
   aadd(campos,{"modpis_v"  ,"C",2 ,0 })
   aadd(campos,{"pis_v"     ,"N",7 ,4 })
   aadd(campos,{"mdcofins_v","C",2 ,0 })
   aadd(campos,{"cofins_v"  ,"N",7 ,4 })
   aadd(campos,{"aliqcred_v","N",7 ,4 })
   dbcreate(datapath+"tecnica2",campos)
endif

if .not. file(datapath+"pedido.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",6 ,0 })
   aadd(campos,{"pedcli_v"  ,"C",10,0 })
   aadd(campos,{"mecven_v"  ,"C",6 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"datbai_v"  ,"D",8 ,0 })
   aadd(campos,{"datfat_v"  ,"D",8 ,0 })
   aadd(campos,{"datpag_v"  ,"D",8 ,0 })
   aadd(campos,{"datpag1_v" ,"D",8 ,0 })
   aadd(campos,{"datpag2_v" ,"D",8 ,0 })
   aadd(campos,{"datpag3_v" ,"D",8 ,0 })
   aadd(campos,{"datpag4_v" ,"D",8 ,0 })
   aadd(campos,{"datcan_v"  ,"D",8 ,0 })
   aadd(campos,{"valpar_v"  ,"N",14,2 })
   aadd(campos,{"valpar1_v" ,"N",14,2 })
   aadd(campos,{"valpar2_v" ,"N",14,2 })
   aadd(campos,{"valpar3_v" ,"N",14,2 })
   aadd(campos,{"valpar4_v" ,"N",14,2 })
   aadd(campos,{"docext_v"  ,"C",10,0 })
   aadd(campos,{"docext1_v" ,"C",10,0 })
   aadd(campos,{"docext2_v" ,"C",10,0 })
   aadd(campos,{"docext3_v" ,"C",10,0 })
   aadd(campos,{"docext4_v" ,"C",10,0 })
   aadd(campos,{"pagrec_v"  ,"C",6 ,0 })
   aadd(campos,{"pagrec1_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec2_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec3_v" ,"C",6 ,0 })
   aadd(campos,{"pagrec4_v" ,"C",6 ,0 })
   aadd(campos,{"valcus_v"  ,"N",14,2 })
   aadd(campos,{"valmin_v"  ,"N",14,2 })
   aadd(campos,{"valmed_v"  ,"N",14,2 })
   aadd(campos,{"valmax_v"  ,"N",14,2 })
   aadd(campos,{"valtot_v"  ,"N",14,2 })
   aadd(campos,{"valtot2_v" ,"N",14,2 })
   aadd(campos,{"valmo_v"   ,"N",14,2 })
   aadd(campos,{"valipi_v"  ,"N",14,2 })
   aadd(campos,{"frete_v"   ,"N",14,2 })
   aadd(campos,{"linserv1_v","C",65,0 })
   aadd(campos,{"linserv2_v","C",65,0 })
   aadd(campos,{"linserv3_v","C",65,0 })
   aadd(campos,{"linserv4_v","C",65,0 })
   aadd(campos,{"tipo_v"    ,"C",1 ,0 })
   aadd(campos,{"nota_v"    ,"N",6 ,0 })
   aadd(campos,{"notacom_v" ,"N",8 ,0 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"system_v"  ,"N",10,0 })
   aadd(campos,{"observa1_v","C",130,0})
   aadd(campos,{"codpla_v"  ,"C",4 ,0 })
   aadd(campos,{"horaemi_v" ,"C",8 ,0 })
   dbcreate(datapath+"pedido",campos)
endif

if .not. file(datapath+"pedido2.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"C",6 ,0 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"item_v"    ,"C",12,0 })
   aadd(campos,{"valcus_v"  ,"N",14,2 })
   aadd(campos,{"valmin_v"  ,"N",14,2 })
   aadd(campos,{"valmed_v"  ,"N",14,2 })
   aadd(campos,{"valmax_v"  ,"N",14,2 })
   aadd(campos,{"valuni_v"  ,"N",16,4 })
   aadd(campos,{"qtd_v"     ,"N",14,2 })
   aadd(campos,{"icms_v"    ,"N",7 ,4 })
   aadd(campos,{"ipi_v"     ,"N",5 ,2 })
   aadd(campos,{"valipi_v"  ,"N",14,2 })
   aadd(campos,{"bascal_v"  ,"N",6 ,2 })
   aadd(campos,{"tbascal_v" ,"C",80,0 })
   aadd(campos,{"frete_v"   ,"N",16,4 })
   aadd(campos,{"datbai_v"  ,"D",8 ,0 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"sittaba_v" ,"N",1 ,0 })
   aadd(campos,{"sittabb_v" ,"N",3 ,0 })
   aadd(campos,{"modbc_v"   ,"N",1 ,0 })
   aadd(campos,{"modbcst_v" ,"N",1 ,0 })
   aadd(campos,{"mgvradic_v","N",7 ,4 })
   aadd(campos,{"bascalst_v","N",7 ,2 })
   aadd(campos,{"icmsst_v"  ,"N",7 ,4 })
   aadd(campos,{"modpis_v"  ,"C",2 ,0 })
   aadd(campos,{"pis_v"     ,"N",7 ,4 })
   aadd(campos,{"mdcofins_v","C",2 ,0 })
   aadd(campos,{"cofins_v"  ,"N",7 ,4 })
   aadd(campos,{"aliqcred_v","N",7 ,4 })
   dbcreate(datapath+"pedido2",campos)
endif

if .not. file(datapath+"cotacao.dbf")
   campos := {}
   aadd(campos,{"codigo_v"  ,"N",6 ,0 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"revenda_v" ,"C",1 ,0 })
   aadd(campos,{"endereco_v","C",50,0 })
   aadd(campos,{"numero_v"  ,"C",6 ,0 })
   aadd(campos,{"complem_v" ,"C",10,0 })
   aadd(campos,{"bairro_v"  ,"C",30,0 })
   aadd(campos,{"cidade_v"  ,"C",30,0 })
   aadd(campos,{"estado_v"  ,"C",2 ,0 })
   aadd(campos,{"cep_v"     ,"C",8 ,0 })
   aadd(campos,{"fone1_v"   ,"C",12,0 })
   aadd(campos,{"fone2_v"   ,"C",12,0 })
   aadd(campos,{"fax_v"     ,"C",12,0 })
   aadd(campos,{"contato_v" ,"C",50,0 })
   aadd(campos,{"valtot_v"  ,"N",14,2 })
   aadd(campos,{"mecven_v"  ,"C",6 ,0 })
   aadd(campos,{"frmpgto_v" ,"C",15,0 })
   aadd(campos,{"przentr_v" ,"C",15,0 })
   dbcreate(datapath+"cotacao",campos)
endif

if .not. file(datapath+"cotacao2.dbf")
   campos := {}
   aadd(campos,{"codigo_v"  ,"N",6 ,0 })
   aadd(campos,{"item_v"    ,"C",12,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"valuni_v"  ,"N",16,4 })
   aadd(campos,{"qtd_v"     ,"N",14,2 })
   dbcreate(datapath+"cotacao2",campos)
endif

if .not. file(datapath+"nota.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"N",6 ,0 })
   aadd(campos,{"tipoes_v"  ,"C",1 ,0 })
   aadd(campos,{"cupom_v"   ,"N",6 ,0 })
   aadd(campos,{"pedido_v"  ,"C",6 ,0 })
   aadd(campos,{"ficha_v"   ,"C",5 ,0 })
   aadd(campos,{"codtran_v" ,"N",5 ,0 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"datsai_v"  ,"D",8 ,0 })
   aadd(campos,{"horasai_v" ,"C",8 ,0 })
   aadd(campos,{"frete_v"   ,"C",1 ,0 })
   aadd(campos,{"placa_v"   ,"C",8 ,0 })
   aadd(campos,{"uf_v"      ,"C",2 ,0 })
   aadd(campos,{"qtd_v"     ,"N",14,0 })
   aadd(campos,{"especie_v" ,"C",15,0 })
   aadd(campos,{"marca_v"   ,"C",15,0 })
   aadd(campos,{"numero_v"  ,"C",15,0 })
   aadd(campos,{"pesobru_v" ,"C",15,0 })
   aadd(campos,{"pesoliq_v" ,"C",15,0 })
   aadd(campos,{"valitot_v" ,"N",14,2 })
   aadd(campos,{"valmo_v"   ,"N",14,2 })
   aadd(campos,{"valipi_v"  ,"N",14,2 })
   aadd(campos,{"valfrete_v","N",14,2 })
   aadd(campos,{"icmfrete_v","N",7 ,4 })
   aadd(campos,{"datpar1_v" ,"D",8 ,0 })
   aadd(campos,{"valpar1_v" ,"N",14,2 })
   aadd(campos,{"datpar2_v" ,"D",8 ,0 })
   aadd(campos,{"valpar2_v" ,"N",14,2 })
   aadd(campos,{"datpar3_v" ,"D",8 ,0 })
   aadd(campos,{"valpar3_v" ,"N",14,2 })
   aadd(campos,{"datpar4_v" ,"D",8 ,0 })
   aadd(campos,{"valpar4_v" ,"N",14,2 })
   aadd(campos,{"datpar5_v" ,"D",8 ,0 })
   aadd(campos,{"valpar5_v" ,"N",14,2 })
   aadd(campos,{"linserv1_v","C",65,0 })
   aadd(campos,{"linserv2_v","C",65,0 })
   aadd(campos,{"linserv3_v","C",65,0 })
   aadd(campos,{"linserv4_v","C",65,0 })
   aadd(campos,{"dadoadi1_v","C",60,0 })
   aadd(campos,{"dadoadi2_v","C",60,0 })
   aadd(campos,{"dadoadi3_v","C",60,0 })
   aadd(campos,{"dadoadi4_v","C",60,0 })
   aadd(campos,{"dadoadi5_v","C",60,0 })
   aadd(campos,{"dadoadi6_v","C",60,0 })
   aadd(campos,{"dadoadi7_v","C",60,0 })
   aadd(campos,{"dadoadi8_v","C",60,0 })
   aadd(campos,{"observa1_v","C",130,0})
   aadd(campos,{"cancela_v" ,"C",1 ,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   aadd(campos,{"natoper_v" ,"C",30,0 })
   aadd(campos,{"msgfisc_v" ,"C",99,0 })
   aadd(campos,{"serie_v"   ,"C",2 ,0 })
   aadd(campos,{"nfs_v"     ,"N",6 ,0 })
   aadd(campos,{"horaemi_v" ,"C",8 ,0 })
   dbcreate(datapath+"nota",campos)
endif

if .not. file(datapath+"nota2.dbf")
   campos:={}
   aadd(campos,{"codigo_v"  ,"N",6 ,0 })
   aadd(campos,{"datemi_v"  ,"D",8 ,0 })
   aadd(campos,{"item_v"    ,"C",12,0 })
   aadd(campos,{"valcus_v"  ,"N",14,2 })
   aadd(campos,{"valmin_v"  ,"N",14,2 })
   aadd(campos,{"valmed_v"  ,"N",14,2 })
   aadd(campos,{"valmax_v"  ,"N",14,2 })
   aadd(campos,{"valuni_v"  ,"N",16,4 })
   aadd(campos,{"qtd_v"     ,"N",14,2 })
   aadd(campos,{"icms_v"    ,"N",7 ,4 })
   aadd(campos,{"ipi_v"     ,"N",5 ,2 })
   aadd(campos,{"valipi_v"  ,"N",14,2 })
   aadd(campos,{"bascal_v"  ,"N",6 ,2 })
   aadd(campos,{"tbascal_v" ,"C",80,0 })
   aadd(campos,{"frete_v"   ,"N",16,4 })
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"sittaba_v" ,"N",1 ,0 })
   aadd(campos,{"sittabb_v" ,"N",3 ,0 })
   aadd(campos,{"modbc_v"   ,"N",1 ,0 })
   aadd(campos,{"modbcst_v" ,"N",1 ,0 })
   aadd(campos,{"mgvradic_v","N",7 ,4 })
   aadd(campos,{"bascalst_v","N",7 ,2 })
   aadd(campos,{"icmsst_v"  ,"N",7 ,4 })
   aadd(campos,{"modpis_v"  ,"C",2 ,0 })
   aadd(campos,{"pis_v"     ,"N",7 ,4 })
   aadd(campos,{"mdcofins_v","C",2 ,0 })
   aadd(campos,{"cofins_v"  ,"N",7 ,4 })
   aadd(campos,{"aliqcred_v","N",7 ,4 })
   aadd(campos,{"serie_v"   ,"C",2 ,0 })
   dbcreate(datapath+"nota2",campos)
endif


if .not. file(datapath+"cfop.dbf")
   campos:={}
   aadd(campos,{"cfop_v"    ,"C",9 ,0 })
   aadd(campos,{"mensagem_v","C",18,0 })
   aadd(campos,{"movest_v"  ,"L",1 ,0 })
   aadd(campos,{"movimp_v"  ,"L",1 ,0 })
   aadd(campos,{"movfin_v"  ,"L",1 ,0 })
   dbcreate(datapath+"cfop",campos)
endif

if .not. file(datapath+"transp.dbf") //
   campos:={}
   aadd(campos,{"codigo_v"  ,"N",5 ,0 })
   aadd(campos,{"nome_v"    ,"C",50,0 })
   aadd(campos,{"endereco_v","C",50,0 })
   aadd(campos,{"numero_v"  ,"C",6 ,0 })
   aadd(campos,{"complem_v" ,"C",10,0 })
   aadd(campos,{"cidade_v"  ,"C",30,0 })
   aadd(campos,{"estado_v"  ,"C",2 ,0 })
   aadd(campos,{"cgc_v"     ,"C",19,0 })
   aadd(campos,{"insest_v"  ,"C",15,0 })
   aadd(campos,{"fone1_v"   ,"C",12,0 })
   aadd(campos,{"fone2_v"   ,"C",12,0 })
   aadd(campos,{"fax_v"     ,"C",12,0 })
   aadd(campos,{"contato_v" ,"C",50,0 })
   aadd(campos,{"cidserv1_v","C",20,0 })
   aadd(campos,{"cidserv2_v","C",20,0 })
   aadd(campos,{"cidserv3_v","C",20,0 })
   aadd(campos,{"texto_v"   ,"M",10,0 })
   aadd(campos,{"nomsen_v"  ,"C",10,0 })
   dbcreate(datapath+"transp",campos)
endif

if .not. file(datapath+"cota.dbf")
   campos:={}
   aadd(campos,{"clifor_v"  ,"C",6 ,0 })
   aadd(campos,{"item_v"    ,"C",12,0 })
   aadd(campos,{"valor_v"   ,"N",14,2 })
   dbcreate(datapath+"cota",campos)
endif

if .not. file(datapath+"mala.dbf")
   campos:={}
   aadd(campos,{"modelo_v","C",10, 0})
   aadd(campos,{"linha_v" ,"N", 2, 0})
   aadd(campos,{"coluna_v","N", 2, 0})
   aadd(campos,{"intlin_v","N", 1, 0})
   aadd(campos,{"intcol_v","N", 1, 0})
   aadd(campos,{"qtd_v"   ,"N", 1, 0})
   dbcreate(datapath+"mala",campos)
endif

if .not. file(datapath+"midia.dbf") //
   campos:={}
   aadd(campos,{"codigo_v"    ,"N",2 ,0 })
   aadd(campos,{"nome_v"      ,"C",15,0 })
   dbcreate(datapath+"midia",campos)
endif

if .not. file(datapath+"serv.dbf")
   campos:={}
   aadd(campos,{"codigo_v"    ,"C",3 ,0 })
   aadd(campos,{"nome_v"      ,"C",15,0 })
   aadd(campos,{"texto_v"     ,"M",10,0 })
   dbcreate(datapath+"serv.dbf",campos)
endif

if .not. file(datapath+"moeda.dbf")
   campos:={}
   aadd(campos,{"moeda_v"     ,"C",3 ,0 })
   aadd(campos,{"data_v"      ,"D",8 ,0 })
   aadd(campos,{"valor_v"     ,"N",7 ,2 })
   dbcreate(datapath+"moeda.dbf",campos)
endif

if .not. file(datapath+"defmat.dbf")
   campos:={}
   aadd(campos,{"item_v"      ,"C",12,0 })
   aadd(campos,{"codigo_v"    ,"C",12,0 })
   aadd(campos,{"qtd_v"       ,"N",14,0 })
   dbcreate(datapath+"defmat.dbf",campos)
endif

if .not. file(datapath+"prod.dbf")
   campos:={}
   aadd(campos,{"codigo_v"   ,"N",7 ,0 })
   aadd(campos,{"mecven_v"   ,"C",6 ,0 })
   aadd(campos,{"data_v"     ,"D",8 ,0 })
   aadd(campos,{"valtot_v"   ,"N",14,2 })
   dbcreate(datapath+"prod.dbf",campos)
endif

if.not. file(datapath+"prod2.dbf")
   campos:={}
   aadd(campos,{"codigo_v"   ,"N",7 ,0 })
   aadd(campos,{"item_v"     ,"C",12,0 })
   aadd(campos,{"valcus_v"   ,"N",14,2 })
   aadd(campos,{"qtd_v"      ,"N",14,2 })
   aadd(campos,{"valtot_v"   ,"N",14,2 })
   dbcreate(datapath+"prod2.dbf",campos)
endif

if .not. file(datapath+"porta.dbf")
   campos:={}
   aadd(campos,{"codigo_v"   ,"C",02,0 })
   aadd(campos,{"nome_v"     ,"C",15,0 })
   dbcreate(datapath+"porta.dbf",campos)
endif

if .not. file(datapath+"system.dbf")
   campos:={}
   aadd(campos,{"codigo_v" ,"N",10,0 })
   aadd(campos,{"descr_v"  ,"C",50,0 })
   aadd(campos,{"data_v"   ,"D",08,0 })
   aadd(campos,{"hora_v"   ,"C",08,0 })
   aadd(campos,{"usuario_v","C",10,0 })
   dbcreate(datapath+"system.dbf",campos)
endif

if .not. file(datapath+"controle.dbf")
   campos:={}
   aadd(campos,{"tabela_v" ,"C",8 ,0})
   aadd(campos,{"campo_v"  ,"C",10,0})
   aadd(campos,{"antigo_v" ,"C",50,0})
   aadd(campos,{"novo_v"   ,"C",50,0})
   aadd(campos,{"codsen_v" ,"N",5 ,0})
   aadd(campos,{"data_v"   ,"D",8 ,0})
   aadd(campos,{"hora_v"   ,"C",8 ,0})
   dbcreate(datapath+"controle.dbf",campos)
endif

if .not. file(datapath+"acccom.dbf")
   campos:={}
   aadd(campos,{"codigo_v" ,"C",6  ,0})
   aadd(campos,{"menu_v"   ,"C",40 ,0})
   aadd(campos,{"help_v"   ,"M",10 ,0})
   aadd(campos,{"access_v" ,"C",256,0})
   dbcreate(datapath+"acccom.dbf",campos)
endif

if .not. file(datapath+"movest.dbf")
   campos:={}
   aadd(campos,{"id_v"     ,"N",8  ,0})
   aadd(campos,{"data_v"   ,"D",8  ,0})
   aadd(campos,{"codigo_v" ,"C",12 ,0})
   aadd(campos,{"tipomov_v","C",2  ,0})
   aadd(campos,{"qtd_v"    ,"N",14 ,2})
   aadd(campos,{"doc_v"    ,"C",6  ,0})
   aadd(campos,{"usuario_v","C",10 ,0})
   aadd(campos,{"saldo_v"  ,"N",14 ,2})
   dbcreate(datapath+"movest.dbf",campos)
endif

if .not. file(datapath+"lastid.dbf")
   campos:={}
   aadd(campos,{"tabela_v","C",10,0})
   aadd(campos,{"lastid_v","N",8 ,0})
   dbcreate(datapath+"lastid.dbf",campos)
endif

if .not. file(datapath+"pedfat.dbf")
   campos:={}
   aadd(campos,{"id_v"     ,"N",8 ,0})
   aadd(campos,{"datemi_v" ,"D",8 ,0})
   aadd(campos,{"codigo_v" ,"C",6 ,0})
   aadd(campos,{"dtparc_v" ,"D",8 ,0})
   aadd(campos,{"vrparc_v" ,"N",14,2})
   aadd(campos,{"docext_v" ,"C",10,0})
   aadd(campos,{"pagrec_v" ,"C",6 ,0})
   aadd(campos,{"nota_v"   ,"N",6 ,0})
   aadd(campos,{"datnf_v"  ,"D",8 ,0})
   dbcreate(datapath+"pedfat.dbf",campos)
endif

if .not. file(datapath+"tecfat.dbf")
   campos:={}
   aadd(campos,{"id_v"     ,"N",8 ,0})
   aadd(campos,{"datemi_v" ,"D",8 ,0})
   aadd(campos,{"codigo_v" ,"C",5 ,0})
   aadd(campos,{"dtparc_v" ,"D",8 ,0})
   aadd(campos,{"vrparc_v" ,"N",14,2})
   aadd(campos,{"docext_v" ,"C",10,0})
   aadd(campos,{"tpparc_v" ,"C",1 ,0})
   aadd(campos,{"pagrec_v" ,"C",6 ,0})
   aadd(campos,{"nota_v"   ,"N",6 ,0})
   aadd(campos,{"datnf_v"  ,"D",8 ,0})
   dbcreate(datapath+"tecfat.dbf",campos)
endif

if .not. file(datapath+"caduf.dbf")
   campos:={}
   aadd(campos,{"uf_v"     ,"C",2 ,0})
   aadd(campos,{"nome_v"   ,"C",20,0})
   aadd(campos,{"ibge_v"   ,"C",2 ,0})
   dbcreate(datapath+"caduf.dbf",campos)
endif

if .not. file(datapath+"cadcid.dbf")
   campos:={}
   aadd(campos,{"ibge_v"     ,"C",10,0})
   aadd(campos,{"ddd_v"      ,"C",2 ,0})
   aadd(campos,{"nome_v"     ,"C",30,0})
   aadd(campos,{"uf_v"       ,"C",2 ,0})
   dbcreate(datapath+"cadcid.dbf",campos)
endif

if .not. file(datapath+"sittabb.dbf")
   campos:={}
   aadd(campos,{"codigo_v"   ,"C",3 ,0})
   aadd(campos,{"nome_v"     ,"C",50,0})
   aadd(campos,{"modbc_v"    ,"C",1 ,0})
   aadd(campos,{"redbc_v"    ,"C",1 ,0})
   aadd(campos,{"vrbc_v"     ,"C",1 ,0})
   aadd(campos,{"icmsal_v"   ,"C",1 ,0})
   aadd(campos,{"icms_v"     ,"C",1 ,0})
   aadd(campos,{"modbcst_v"  ,"C",1 ,0})
   aadd(campos,{"mgvradic_v" ,"C",1 ,0})
   aadd(campos,{"redbcst_v"  ,"C",1 ,0})
   aadd(campos,{"vrbcst_v"   ,"C",1 ,0})
   aadd(campos,{"icmsstal_v" ,"C",1 ,0})
   aadd(campos,{"icmsst_v"   ,"C",1 ,0})
   aadd(campos,{"regtrib_v"  ,"C",1 ,0})
   aadd(campos,{"aliqcred_v" ,"C",1 ,0})
   aadd(campos,{"vrcred_v"   ,"C",1 ,0})
   dbcreate(datapath+"sittabb.dbf",campos)
   dbusearea(.t.,,datapath+"sittabb","sittabb",.f.)
   registros := {{"00" ,"Tributada integralmente"                         ,"S","N","S","S","S","N","N","N","N","N","N","3","N","N"},;
                 {"10" ,"Tributada c/cobranca do ICMS p/ST"               ,"S","N","S","S","S","S","S","S","S","S","S","3","N","N"},;
                 {"20" ,"Tributada c/reducao da base de calculo"          ,"S","S","S","S","S","N","N","N","N","N","N","3","N","N"},;
                 {"30" ,"Isenta/nao tribut.c/cobr.do ICMS por ST"         ,"N","N","N","N","N","S","S","S","S","S","S","3","N","N"},;
                 {"40" ,"Isenta","N","N"                                  ,"N","N","N","N","N","N","N","N","N","N","N","3","N","N"},;
                 {"41" ,"Nao tributada"                                   ,"N","N","N","N","N","N","N","N","N","N","N","3","N","N"},;
                 {"50" ,"Suspensao"                                       ,"N","N","N","N","N","N","N","N","N","N","N","3","N","N"},;
                 {"51" ,"Diferimento"                                     ,"S","S","S","S","S","N","N","N","N","N","N","3","N","N"},;
                 {"60" ,"Cobrado anteriormente por ST"                    ,"N","N","N","N","N","N","N","N","S","N","S","3","N","N"},;
                 {"70" ,"Com red.da base de calculo e cobr.do ICMS por ST","S","S","S","S","S","S","S","S","S","S","S","3","N","N"},;
                 {"90" ,"Outras"                                          ,"S","S","S","S","S","S","S","S","S","S","S","3","N","N"},;
                 {"101","Tributada com permissao de credito"              ,"N","N","N","N","N","N","N","N","N","N","N","1","S","S"},;
                 {"102","Tributada sem permissao de credito"              ,"N","N","N","N","N","N","N","N","N","N","N","1","N","N"},;
                 {"103","Isencao do ICMS para faixa de receita bruta"     ,"N","N","N","N","N","N","N","N","N","N","N","1","N","N"},;
                 {"201","Trib.c/permissao de credito e cob do ICMS por ST","N","N","N","N","N","S","S","S","S","S","S","1","S","S"},;
                 {"202","Trib.s/permissao de credito e cob do ICMS por ST","N","N","N","N","N","S","S","S","S","S","S","1","N","N"},;
                 {"203","Isencao ICMS p/fx de receita bruta c/cob.por ST" ,"N","N","N","N","N","S","S","S","S","S","S","1","N","N"},;
                 {"300","Imune"                                           ,"N","N","N","N","N","N","N","N","N","N","N","1","N","N"},;
                 {"400","Nao tributada"                                   ,"N","N","N","N","N","N","N","N","N","N","N","1","N","N"},;
                 {"500","ICMS cobrado anteriormente por ST ou antecipacao","N","N","N","N","N","N","N","N","S","N","S","1","N","N"},;
                 {"900","Outros"                                          ,"S","S","S","S","S","S","S","S","S","S","S","1","S","S"}}
   for i := 1 to len(registros)
      sittabb->(dbappend())
      sittabb->codigo_v := registros[i][1]
      sittabb->nome_v := registros[i][2]
      sittabb->modbc_v := registros[i][3]
      sittabb->redbc_v := registros[i][4]
      sittabb->vrbc_v := registros[i][5]
      sittabb->icmsal_v := registros[i][6]
      sittabb->icms_v := registros[i][7]
      sittabb->modbcst_v := registros[i][8]
      sittabb->mgvradic_v := registros[i][9]
      sittabb->redbcst_v := registros[i][10]
      sittabb->vrbcst_v := registros[i][11]
      sittabb->icmsstal_v := registros[i][12]
      sittabb->icmsst_v := registros[i][13]
      sittabb->regtrib_v := registros[i][14]
      sittabb->aliqcred_v := registros[i][15]
      sittabb->vrcred_v := registros[i][16]
      sittabb->(dbcommit(), dbunlock())
   next
   sittabb->(dbclosearea())
endif

if .not. file(datapath+"cfgmail.dbf")
   campos:={}
   aadd(campos,{"smtpsrv_v","C",50,0})
   aadd(campos,{"popsrv_v" ,"C",50,0})
   aadd(campos,{"port_v"    ,"N", 5,0})
   aadd(campos,{"user_v"    ,"C",50,0})
   aadd(campos,{"password_v","C",50,0})
   aadd(campos,{"pathnfe_v" ,"C",90,0})
   aadd(campos,{"trace_v"   ,"C",1 ,0})
   dbcreate(datapath+"cfgmail.dbf",campos)
   dbf_cfgmail()
   cfgmail->(dbappend())
   cfgmail->trace_v := 'N'
   cfgmail->(dbclosearea())
endif

if .not. file(datapath+"nfe.dbf")
   campos:={}
   aadd(campos,{"arquivo_v"  ,"C",56,0})
   aadd(campos,{"datcad_v"   ,"D",8 ,0})
   aadd(campos,{"datenv_v"   ,"D",8 ,0})
   aadd(campos,{"email_v"    ,"C",90,0})
   aadd(campos,{"cgccpf_v"   ,"C",19,0})
   aadd(campos,{"numnfe_v"   ,"N",9 ,0})
   dbcreate(datapath+"nfe.dbf",campos)
endif


return(.t.)

function VerificaCampos()
local nResult
local oldDataPath := datapath
local nFile, aFiles[adir(datapath+"*.dbf")]
local nCampo, aCamposOrig, aNewCampos, cAlias, cNewAlias, nNewCampo
local lIgual, cTmpDBF, cTmpDBFM, cFileOrig, cFileOrigM, cNewFile, cNewFileM, lTeveMudanca
memvar datapath

aeval(directory("tempdbf\*.*"), { |afile| ferase("tempdbf\"+afile[1]) })
dirremove("tempdbf")
nResult := dirmake("tempdbf")

adir(datapath+"*.dbf",aFiles)
if nResult == 0 .or. nResult == -183
   datapath := "TEMPDBF\"
   
   verify()
   datapath := oldDataPath
   lTeveMudanca := .f.
   
   for nFile := 1 to len(aFiles)
      cAlias := strtran(lower(aFiles[nFile]),".dbf","")
      cFileOrig := datapath+aFiles[nFile]
      cFileOrigM := ""
      if file(datapath+cAlias+".fpt")
         cFileOrigM := datapath+cAlias+".fpt"
      elseif file(datapath+cAlias+".dbt")
         cFileOrigM := datapath+cAlias+".dbt"
      endif 
      dbusearea(.t.,, cFileOrig, cAlias)
      aCamposOrig := (cAlias)->(dbstruct())
      (cAlias)->(dbclosearea())
      
      cNewAlias := strtran(lower("n"+aFiles[nFile]),".dbf","")
      cNewFile := "tempdbf\"+aFiles[nFile]
      if file(datapath+cAlias+".fpt")
         cNewfileM := "tempdbf\"+strtran(lower(aFiles[nFile]),".dbf",".fpt")
      elseif file(datapath+cAlias+".dbt")
         cNewfileM := "tempdbf\"+strtran(lower(aFiles[nFile]),".dbf",".dbt")
      endif 

      if file(cNewFile)
         dbusearea(.t.,, cNewFile, cNewAlias)
         aNewCampos := (cNewAlias)->(dbstruct())
         (cNewAlias)->(dbclosearea())
         
         // 1/2 - verificar a quantidade dos campos
         lIgual := len(aCamposOrig) == len(aNewCampos)
         
         // 2/2 - verificar os atributos dos campos
         if lIgual
            for nCampo := 1 to len(aCamposOrig)
               nNewCampo := ascan(aNewCampos,{|x| x[1] = aCamposOrig[nCampo,1]})
               lIgual :=  (aNewCampos[nNewCampo,3] == aCamposOrig[nCampo,3]) .and. (aNewCampos[nNewCampo,4] == aCamposOrig[nCampo,4])
               if !lIgual
                  exit
               endif
            next
         endif
         
         if !lIgual
            cTmpDBF := "tempdbf\_"+aFiles[nFile]
            rename (cFileOrig) to (cTmpDBF)
            if !empty(cFileOrigM)
               if file(datapath+cAlias+".fpt")
                  cTmpDBFM := "tempdbf\_"+strtran(lower(aFiles[nFile]),".dbf",".fpt")
               elseif file(datapath+cAlias+".dbt")
                  cTmpDBFM := "tempdbf\_"+strtran(lower(aFiles[nFile]),".dbf",".dbt")
               endif 
            
               rename (cFileOrigM) to (cTmpDBFM)
            endif
            
            rename (cNewFile) to (cFileOrig)
            if !empty(cFileOrigM)
               rename (cNewFileM) to (cFileOrigM)
            endif
               
            dbusearea(.t.,,cFileOrig , cAlias, .f.)
            if cAlias = "config"
               zap
            endif
            select(cAlias)
            append from &cTmpDBF
            
            if upper(cAlias) = "NOTA" .or. upper(cAlias) = "NOTA2"
               locate for !empty(serie_v)
               if eof()
                  repl all serie_v with "0"
               endif
            endif
            
            (cAlias)->(dbclosearea())
         endif
      endif
   next
   
   if !lTeveMudanca
   
      aeval(directory("tempdbf\*.*"), { |afile| if(left(afile[1],1)="_",.t.,ferase("tempdbf\"+afile[1])) })
   
      dirremove("tempdbf")
   
   endif
endif
return(.t.)
