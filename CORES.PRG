FUNCTION CORES()
LOCAL TELA,GETLIST:={}
MEMVAR CORTIT,CORTEX,CORPAR,CORBAR,CORDES,LEVEL,CODSEN,TRABALHO,NOMSEN
TELA:=SAVESCREEN(0,0,24,80)
WINDOW(3,0,23,44)
DBF_SENHA()
SENHA->(DBSEEK(CODSEN))
DO WHILE .T.
   SETCOLOR(CORTIT)
   @ 4,1 SAY PADC("Configura‡ao de Cores",43)
   SETCOLOR(CORTEX)
   @ 5,1  TO 5,43
   @ 6,2  SAY "Barra de TЎtulo  :" COLOR(CORTIT)
   @ 7,2  SAY "Textos e Janelas :" COLOR(CORTEX)
   @ 8,2  SAY "Campos Ativos    :" COLOR(CORBAR)
   @ 9,2  SAY "Campos Inativos  :" COLOR(CORDES)
   @ 10,2 SAY "Papel de Parede  :" COLOR(CORPAR)
   @ 11,1 TO 11,43
   SETCOLOR(CORTIT)
   @ 12,1 SAY "Cores Claras Acrescentar:Letras[+] Fundo[*]"
   @ 13,2 SAY "W    ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("W/N")
   @ 14,2 SAY "GR   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("GR/N")
   @ 15,2 SAY "GR+  ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("GR+/N")
   @ 16,2 SAY "R    ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("R/N")
   @ 17,2 SAY "B    ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("B/N")
   @ 18,2 SAY "G    ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("G/N")
   @ 19,2 SAY "BR   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("BR/N")
   @ 20,2 SAY "BG   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("BG/N")
   @ 21,2 SAY "N    ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("N/W")
   @ 22,2 SAY "N+   ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("N+/N")

   @ 13,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("W+/N")
   @ 14,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("GR/N")
   @ 15,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("GR+/N")
   @ 16,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("R+/N")
   @ 17,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("B+/N")
   @ 18,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("G+/N")
   @ 19,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("BR+/N")
   @ 20,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("BG+/N")
   @ 21,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("N/W")
   @ 22,23 SAY "ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ" COLOR("N+/N")
   SETCOLOR(CORTEX+","+CORBAR+",,,"+CORDES)
   @ 6,21  GET CORTIT
   @ 7,21  GET CORTEX
   @ 8,21  GET CORBAR
   @ 9,21  GET CORDES
   @ 10,21 GET CORPAR
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF CONFIRMA(10,10,"Altera‡oes Nas Cores ?")
      IF SENHA->(RECLOCK(5))
         SENHA->CORTIT_V:=CORTIT
         SENHA->CORTEX_V:=CORTEX
         SENHA->CORBAR_V:=CORBAR
         SENHA->CORDES_V:=CORDES
         SENHA->CORPAR_V:=CORPAR
         SENHA->(DBUNLOCK())
         EXIT
      ENDIF
   ENDIF
ENDDO
SENHA->(DBCLOSEAREA())
RESTSCREEN(0,0,24,80,TELA)
RETURN(.T.)