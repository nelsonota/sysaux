FUNCTION DADOS()
LOCAL BANCOS,OP,TELA
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
TELA:=SAVESCREEN()
DO WHILE .T.
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   WINDOW(6,64,21,75)
   BANCOS:={" Bank     ",;
            " Bascal   ",;
            " CFOP     ",;
            " Cheque   ",;
            " Clifor   ",;
            " Config   ",;
            " Cota     ",;
            " Cotacao  ",;
            " Cotacao2 ",;
            " Estoque  ",;
            " Mecven   ",;
            " Midia    ",;
            " Moeda    ",;
            " Nota     ",;
            " Pagrec   ",;
            " Pedido   ",;
            " Pedido2  ",;
            " Plano    ",;
            " Senha    ",;
            " Serv     ",;
            " Tecnica  ",;
            " Tecnica2 ",;
            " Transp   " }
   OP:=ACHOICE(7,65,20,74,BANCOS,.T.)
   DO CASE
      CASE OP=1
*         DBF_BANK()
      CASE OP=2
*         DBF_BASCAL()
      CASE OP=3
*         DBF_CFOP()
      CASE OP=4
*         DBF_CHEQUE()
      CASE OP=5
*         DBF_CLIFOR()
      CASE OP=6
*         DBF_CONFIG()
      CASE OP=7
*         DBF_COTA()
      CASE OP=8
*         DBF_COTACAO()
      CASE OP=9
*         DBF_2COTACAO()
      CASE OP=10
*         DBF_ESTOQUE()
      CASE OP=11
*         DBF_MECVEN()
      CASE OP=12
*         DBF_MIDIA()
      CASE OP=13
*         DBF_MOEDA()
      CASE OP=14
*         DBF_NOTA()
      CASE OP=15
*        DBF_PAGREC()
      CASE OP=16
*         DBF_PEDIDO()
      CASE OP=17
*         DBF_2PEDIDO()
      CASE OP=18
*         DBF_PLANO()
      CASE OP=19
*         DBF_SENHA()
      CASE OP=20
*         DBF_SERV()
      CASE OP=21
*         DBF_TECNICA()
      CASE OP=22
*         DBF_2TECNICA()
      CASE OP=23
*         DBF_TRANSP()
      OTHERWISE
         EXIT
   ENDCASE
*   WINDOW(5,4,20,76)
*   IF (ALLTRIM(BANCOS[OP]))->(ARQLOCK(5))
*      (ALLTRIM(BANCOS[OP])) ->(BROWSE(6,5,19,75))
*      (ALLTRIM(BANCOS[OP]))  ->(DBCLOSEAREA())
*   ELSE
*      AVISO("O Sistema nao conseguiu travar o arquivo ...")
*   ENDIF
   SET DELETED OFF
   PRIVIL->(DBCLOSEAREA())
   DBU(BANCOS[OP])
   DBF_PRIVIL()
   SET DELETED ON
   RESTSCREEN(,,,,TELA)
ENDDO
RESTSCREEN(,,,,TELA)
RETURN(.T.)