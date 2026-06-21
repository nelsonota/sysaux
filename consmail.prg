FUNCTION CONSMAIL()
LOCAL  TELA, variaveis, mascaras, titulos, linha1, coluna, tela2, cEmail
local numnfe, arquivo, cgccpf
TELA:=SAVESCREEN()
WINDOW(1,0,23,79)
LINHA1:=CHR(220)
COLUNA:=CHR(219)
dbf_nfe()
dbf_clifor()
variaveis := {"IF(CLIFOR->(DBSETORDER(5), DBSEEK('C'+lpad(alltrim(nfe->cgccpf_v),19))), clifor->nome_v, space(len(clifor->nome_v)))",;
	"nfe->numnfe_v",; 
	"nfe->datenv_v",; 
	"nfe->email_v",;
	"nfe->datcad_v",; 
	"nfe->arquivo_v"}
mascaras := {,,,,,}
titulos := {"Cliente","Num.NFe", "Envio", "Email", "Data", "Arquivo"}
nfe->(dbsetorder(2), dbgobottom())
SETCOLOR(CORTEX)
@ 24,0 CLEAR TO 24,79
@ 24,2 SAY "(E)nviar"
do while .t.
   nfe->(DBEDIT(2,1,22,78,VARIAVEIS,"S_TECLAS",MASCARAS,TITULOS,LINHA1,COLUNA))
   tela2 := savescreen()
   nKey := lastkey()
   DO CASE
      CASE NKEY=27 .OR. NKEY=13
         exit
      case nkey = 101 .or. nkey = 69
         window(10,2,12,78)
         cEmail := nfe->email_v
         @11,4 say "Email:" get cEmail pict '@S50'
         read
         restscreen(,,,,tela2)
         if lastkey() # 27
            if empty(nfe->email_v) .or. empty(nfe->datenv_v)
               nfe->(reclock(5))
               nfe->email_v := cEmail
            else
               arquivo := nfe->arquivo_v
               cgccpf := nfe->cgccpf_v
               numnfe := nfe->numnfe_v
               nfe->(addrec(5))
               nfe->datcad_v := date()
               nfe->arquivo_v := arquivo
               nfe->cgccpf_v := cgccpf
               nfe->numnfe_v := numnfe
               nfe->email_v := cEmail
            endif
            nfe->(dbcommit(), dbunlock())
            send_mail_nfe(nfe->(recno()))
         endif
   ENDCASE
ENDDO
nfe->(dbclosearea())
clifor->(dbclosearea())
RESTSCREEN(,,,,TELA)
CLOSEWIN(0,0,22,79)
RETURN .T. 