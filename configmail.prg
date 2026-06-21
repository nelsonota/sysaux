function configmail()
local getlist:={}
local smtpsrv, port, user, password, pathnfe, popsrv, trace
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,IMPFUN
dbf_cfgmail()
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(10,0,18,79)
do while .t.
	smtpsrv := cfgmail->smtpsrv_v
	popsrv := cfgmail->popsrv_v
	port := cfgmail->port_v
	user := cfgmail->user_v
	password := cfgmail->password_v
	trace := cfgmail->trace_v
	pathnfe := cfgmail->pathnfe_v
	@11,02 say "Servidor SMTP:" get smtpsrv
	@12,02 say "Porta SMTP:" get port pict "99999"
	@13,02 say "Servidor POP:" get popsrv	
	@14,02 say "Usuario:" get user
	@15,02 say "Senha:" get password
	@16,02 say "Caminho XML NFe:" get pathnfe pict "@S59"
	@17,02 say "Trace:" get trace pict "@!" valid trace$'SN'
	read
	if lastkey() = 27
		exit
	endif
	if CONFIRMA(20,20,"Confirma Altera‡oes ?")
		if cfgmail->(reclock(5))
			cfgmail->smtpsrv_v := smtpsrv
			cfgmail->popsrv_v := popsrv
			cfgmail->port_v := port
			cfgmail->user_v := user
			cfgmail->password_v := password
			cfgmail->trace_v := trace
			cfgmail->pathnfe_v := pathnfe
			cfgmail->(dbcommit(), dbunlock())
		endif
		exit
	endif
enddo
cfgmail->(dbclosearea())
RESTSCREEN(0,0,24,80,TELA)
return .t.