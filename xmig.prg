function exporta_xmig()
memvar nHand
	dbf_config()
  nHand := fcreate("sql/xmig.sql")
	exporta_cadimp("1","1")
	config->(dbclosearea())
	fclose(nHand)
return nil

function exporta_cadimp(empresa_id, usuario_id)
	memvar nHand
	dbf_cadimp()
	cadimp->(dbgotop())
	do while !cadimp->(eof())
		fputs(nHand, "INSERT INTO grupos_impostos("+;
			"empresa_id, "+;
			"usuario_id, "+;
			"nome, "+;
			"codigo_externo, "+;
			"created, "+;
			"modified) VALUES(" + ;
			empresa_id + ", "+;
			usuario_id+", '"+;
			cadimp->nome_v+"', "+;
			"'"+alltrim(str(cadimp->codigo_v))+"', "+;
			"now(), "+;
			"now())")
		cadimp->(dbskip())
	enddo
	cadimp->(dbclosearea())
return nil
/*
function exporta_bascal(empresa_id, usuario_id)
	memvar nHand
	dbf_cadimp()
	cadimp->(dbgotop())
	do while !cadimp->(eof())
		fputs(nHand, "INSERT INTO impostos("+;
			"empresa_id, "+;
			"usuario_id, "+;
			"grupo_imposto_id, "+;
			"uf_id, "+;
			"tributacao_icms_id, "+;
			"modalidade_base_calculo_id, "+;
			"base_calculo_juridica, "+;
			"aliquota_icms_juridica, "+;
			"base_calculo_fisica, "+;
			"aliquota_icms_fisica, "+;
			"modalidade_base_calculo_st_id, "+;
			"margem_valor_adicionado_st, "+;
			"base_calculo_st_juridica, "+;
			"aliquota_icms_st_juridica, "+;
			"base_calculo_st_fisica, "+;
			"aliquota_icms_st_fisica, "+;
			"tributacao_pis_id, "+;
			"aliquota_pis, "+;
			"tributacao_cofins_id, "+;
			"aliquota_cofins, "+;
			"regime_tributario, "+;
			"aliquota_calculo_credito, "+;
			"valor_credito_aproveitavel, "+;
			"created, "+;
			"modified) VALUES(" + ;
			empresa_id + ", "+;
			usuario_id+", "+;
			"SELECT id FROM grupos_impostos WHERE codigo_externo = '"+alltrim(str(bascal->codimp_v))+"', "+;
			"SELECT id FROM ufs WHERE uf = '"+alltrim(bascal->sigla_v)+"', "+;
			"0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2013-5-20 8:33:18.0', '2013-5-20 8:33:18.0', '2013-5-20 8:33:18.0')
		
		INSERT INTO grupos_impostos(empresa_id, usuario_id, nome, codigo_externo, created, modified) VALUES(" + empresa_id + ", "+usuario_id+", '"+cadimp->nome_v+"', '"+alltrim(str(cadimp->codigo_v))+"', now(), now())")
		cadimp->(dbskip())
	enddo
	cadimp->(dbclosearea())
return nil*/