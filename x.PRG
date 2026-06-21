#include "dbinfo.ch"
REQUEST DBFCDX
request DBFFPT

FUNCTION MAIN()
LOCAL GETLIST:={},x
SETMODE(25,80)
SETCANCEL(.T.)
SETBLINK(.F.)
SET DEFA TO (GETENV("DATACOML"))
SET EPOCH TO 1940
SET CENTURY    ON
SET CONFIRM    ON
SET DATE       BRIT
SET DELETED    ON
SET SCOREBOARD OFF
SET SOFTSEEK   OFF
SET WRAP       ON
RDDSETDEFAULT("DBFCDX")
DBUSEAREA(.T.,,"cdx\clifor", "clifor", .t.)
DBSETINDEX("cdx\clifor")
clifor->(dbsetorder(1))
x := 0
clifor->(dbgotop())
@ 0,0 clear to 23,79
do while !clifor->(eof())
   x++
   @ 10,10 say x
   clifor->(rlock())
   if empty(alltrim(clifor->emailnf_v)) .and. !empty(alltrim(clifor->email_v))
      clifor->emailnf_v := clifor->email_v
   endif 
   clifor->fone1_v := formata(clifor->fone1_v)
   clifor->fone2_v := formata(clifor->fone2_v)
   clifor->fax_v := formata(clifor->fax_v)
   clifor->fonecob1_v := formata(clifor->fonecob1_v)
   clifor->fonecob2_v := formata(clifor->fonecob2_v)
   clifor->faxcob_v := formata(clifor->faxcob_v)
   clifor->foneent1_v := formata(clifor->foneent1_v)
   clifor->foneent2_v := formata(clifor->foneent2_v)
   clifor->faxent_v := formata(clifor->faxent_v)
   clifor->(dbcommit(), dbunlock())
   clifor->(dbskip())
enddo
RETURN(.T.)

function sonumero(texto)
local i, cReturn := ""
for i := 1 to len(texto)
   if substr(texto,i,1)$"1234567890"
      cReturn += substr(texto,i,1)
   endif
next
return cReturn

function formata(texto)
local cReturn
cReturn = sonumero(texto)
if left(cReturn,2) == '00'
   cReturn := substr(cReturn,2)
endif
if len(cReturn)>9

      if len(cReturn) == 11
         cReturn := left(cReturn,3)+' '+substr(cReturn,4)
      endif

      if len(cReturn) == 10
         cReturn := ' '+left(cReturn,2)+" "+substr(cReturn,3)
      endif

else
   if len(cReturn) == 8
      cReturn := '    '+cReturn
   else
      cReturn := '   '+cReturn
   endif
endif
@ 12,10 say cReturn
return cReturn

FUNCTION lpad

PARAMETERS string,n

RETURN (SPACE(M->n - LEN(M->string)) + M->string)