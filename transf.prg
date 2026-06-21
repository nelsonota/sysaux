#include "dbinfo.ch"
REQUEST DBFCDX
request DBFFPT

function main()
local ultimo
RDDSETDEFAULT("DBFCDX")
SETMODE(25,80)
new_tecnica()
DBUSEAREA(.T.,"DBFCDX", "cdx\tecnica", "tecnica")
DBUSEAREA(.T.,"DBFCDX", "new_tecnica", "new_tecnica")
ultimo := tecnica->(lastrec())
tecnica->(dbgotop())
scroll(0,0,23,79)
do while !tecnica->(eof())
	@ 10,10 say str(tecnica->(recno()),6)+"/"+str(ultimo,6)
	new_tecnica->(dbappend())
	new_tecnica->codigo_v := tecnica->codigo_v
  new_tecnica->clifor_v := tecnica->clifor_v
  new_tecnica->item_v := tecnica->item_v
  new_tecnica->marca_v := tecnica->marca_v
  new_tecnica->modelo_v := tecnica->modelo_v
  new_tecnica->nserie_v := tecnica->nserie_v
  new_tecnica->tipokm_v := tecnica->tipokm_v
  new_tecnica->qtdkm_v := tecnica->qtdkm_v
  new_tecnica->ano_v := tecnica->ano_v
  new_tecnica->cor_v := tecnica->cor_v
  new_tecnica->tanque_v := tecnica->tanque_v
  new_tecnica->placa_v := tecnica->placa_v
  new_tecnica->orcament_v := tecnica->orcament_v
  try
  	new_tecnica->texto_v := tecnica->texto_v
  catch
		//new_tecnica->(dbcommit(), dbunlock())
	end
  new_tecnica->datent_v := tecnica->datent_v
  new_tecnica->datorc_v := tecnica->datorc_v
  new_tecnica->datapr_v := tecnica->datapr_v
  new_tecnica->datexe_v := tecnica->datexe_v
  new_tecnica->datexe2_v := tecnica->datexe2_v
  new_tecnica->datsai_v := tecnica->datsai_v
  new_tecnica->pagrec_v := tecnica->pagrec_v
  new_tecnica->pagrec1_v := tecnica->pagrec1_v
  new_tecnica->pagrec2_v := tecnica->pagrec2_v
  new_tecnica->pagrec3_v := tecnica->pagrec3_v
  new_tecnica->pagrec4_v := tecnica->pagrec4_v
  new_tecnica->datpag_v := tecnica->datpag_v
  new_tecnica->datpag1_v := tecnica->datpag1_v
  new_tecnica->datpag2_v := tecnica->datpag2_v
  new_tecnica->datpag3_v := tecnica->datpag3_v
  new_tecnica->datpag4_v := tecnica->datpag4_v
  new_tecnica->valpar_v := tecnica->valpar_v
  new_tecnica->valpar1_v := tecnica->valpar1_v
  new_tecnica->valpar2_v := tecnica->valpar2_v
  new_tecnica->valpar3_v := tecnica->valpar3_v
  new_tecnica->valpar4_v := tecnica->valpar4_v
  new_tecnica->datgar_v := tecnica->datgar_v
  new_tecnica->mecven_v := tecnica->mecven_v
  new_tecnica->serv_v := tecnica->serv_v
  new_tecnica->garantia_v := tecnica->garantia_v
  new_tecnica->valmo_v := tecnica->valmo_v
  new_tecnica->valterc_v := tecnica->valterc_v
  new_tecnica->valoutro_v := tecnica->valoutro_v
  new_tecnica->valitot_v := tecnica->valitot_v
  new_tecnica->nota_v := tecnica->nota_v
  new_tecnica->avar1_v := tecnica->avar1_v
  new_tecnica->avar2_v := tecnica->avar2_v
  new_tecnica->avar3_v := tecnica->avar3_v
  new_tecnica->solicli1_v := tecnica->solicli1_v
  new_tecnica->solicli2_v := tecnica->solicli2_v
  new_tecnica->solicli3_v := tecnica->solicli3_v
  new_tecnica->orient1_v := tecnica->orient1_v
  new_tecnica->orient2_v := tecnica->orient2_v
  new_tecnica->orient3_v := tecnica->orient3_v
  new_tecnica->nomsen_v := tecnica->nomsen_v
  new_tecnica->nomorc_v := tecnica->nomorc_v
  new_tecnica->nomsai_v := tecnica->nomsai_v
  new_tecnica->codpla_v := tecnica->codpla_v
  new_tecnica->nfs_v := tecnica->nfs_v
  new_tecnica->(dbcommit(), dbunlock())
	tecnica->(dbskip())
enddo
return nil

function new_tecnica()
	if .not. file("new_tecnica.dbf")
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
	   dbcreate("new_tecnica",campos)
	endif
return nil