FUNCTION GLOTENFP()
local tela := savescreen()
local nLote
WINDOW(10,10,13,60)
do while .t.
   nLote := 0
   @ 11,12 say "Lote:" get nLote pict "999999"
   read
   if lastkey()=27
      exit
   endif
   if nLote == 0
      dDtIni := ctod("")
      dDtFin := ctod("")
      @ 12,12 say "Data inicial:" get dDtIni
      @ 12,37 say "Data final:" get dDtFin
      read
      if lastkey()==27
         loop
      endif
      if confirma(20,10,"Iniciar geracao do arquivo?")
         GerarArquivoNFP(dDtIni,dDtFin)
      endif
   endif
enddo
restscreen(,,,,tela)
RETURN NIL

function GerarArquivoNFP(dDtIni, dDtFin)
dbf_nota()
dbf_pedido()
dbf_2pedido()
nota->(dbsetorder(1), dbseek(dDtIni,.t.))
if nota->datemi_v>=dDtIni .and. nota->datemi_v<=dDtfin
   
   do while !nota->(eof()) .and. nota->datemi_v>=dDtIni .and. nota->datemi_v<=dDtfin
      nota->(dbskip())
   enddo
else
   aviso("Nao existem notas fiscais neste periodo.")
endif
return nil