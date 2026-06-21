FUNCTION RELTEC()
LOCAL OPCOES,TELA,OP
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,IMPFUN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(5,30,24,70)
DO WHILE .T.
   OPCOES:={"  Geral  por per¡odo                  ",;
            "  Geral  por cliente                  ",;
            "  Fichas sem or‡amento                ",;
            "  Fichas com or‡amento                ",;
            "  Fichas c/or‡amentos por t‚cnico     ",;
            "  Fichas com or‡amentos sem aprova‡ao ",;
            "  Fichas com or‡amentos aprovados     ",;
            "  Fichas aprovadas sem sa¡da de pe‡as ",;
            "  Fichas c/sa¡da de pe‡as nao prontas ",;
            "  Fichas prontas                      ",;
            "  Fichas prontas por cliente          ",;
            "  Fichas prontas por t‚cnico          ",;
            "  Fichas finalizadas                  ",;
            "  Ficha  finalizadas com execu‡ao     ",;
            "  Fichas finalizadas por cliente      ",;
            "  Fichas finalizadas por t‚cnico      ",;
            "  Fichas finalizadas com Pendˆncia    ",;
            "  Fichas finalizadas sem Pendˆncia    " }
   OP:=ACHOICE(6,31,23,68,OPCOES,.T.,"ACHOFUN")
   DO CASE
      CASE OP=1
         RETECPE("GER")
      CASE OP=2
         RETECPE("CLI")
      CASE OP=3
         RETECPE("SORC")
      CASE OP=4
         RETECPE("ORC")
      CASE OP=5
         RETECPE("MEC")
      CASE OP=6
         RETECPE("SAPR")
      CASE OP=7
         RETECPE("APR")
      CASE OP=8
         RETECPE("SEXE")
      CASE OP=9
         RETECPE("SEXE2")
      CASE OP=10
         RETECPE("EXE2")
      CASE OP=11
         RETECPE("EXE2C")
      CASE OP=12
         RETECPE("EXE2M")
      CASE OP=13
         RETECPE("SAI")
      CASE OP=14
         RETECPE("SAIE")
      CASE OP=15
         RETECPE("SAIC")
      CASE OP=16
         RETECPE("SAIM")
      CASE OP=17
         RETECPE("SAIP")
      CASE OP=18
         RETECPE("SAINP")
      OTHERWISE
         EXIT
   ENDCASE
ENDDO
RESTSCREEN(0,0,24,80,TELA)
CLOSEWIN(5,30,24,70)
RETURN(.T.)