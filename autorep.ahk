#SingleInstance, Force
#IfWinActive, MTA: Province
if (A_IsAdmin = false) {
   Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
   ;ExitApp
}
ptitle = Multi-Helper by M1kkeL Bots
IfWinNotExist, MTA: Province
{
	MsgBox, 16, %ptitle%, Перед запуском программы у Вас должна быть запущена игра.`n`nЭто окно будет закрыто через 10 секунд., 10
	ExitApp
}
WinGet, tes, ProcessPath, MTA: Province
if tes contains gta_sa
	RegExMatch(tes, "(.*)gta_sa.exe", tes2)
else if tes contains proxy_sa
	RegExMatch(tes, "(.*)proxy_sa.exe", tes2)
else
{
	MsgBox, 16, %ptitle%, Программа не смогла определить процесс игры.`n`nЭто окно будет закрыто через 10 секунд.`n`nINFO: %tes%, 10
	ExitApp
}

DoGet(link, type := "0") {
    global
    link := RegExReplace(link, "\+", "%2B")
    ComObjError(False)
    reqg := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
    reqg.SetTimeouts(0, 60000, 30000, 10000)
    reqg.Open("GET", link)
    try
    reqg.Send()
    reqg.WaitForResponse()
    resultdoget := reqg.responseText
    if resultdoget contains NotFound,Не найдено - HostiMan.ru
        resultdoget := "Не найдено"
    return resultdoget
}
vk_send(msg) {
	global
	result := DoGet("https://api.vk.com/method/messages.send?message=" msg "&peer_id= "vkid "&access_token=" token "&v=5.103&random_id=0")
	return %result%
}
token = 
vkid = 
chatlog = %tes21%MTA\MTA\logs\console.log
lastsizefile = 0
chattime := A_TickCount
SetTimer, readchat, 500
return

dochat:
if RegExMatch(lastline, "(.*)\[(.*) (.*)\] \[Output\] : Администратор (.*)\[(.*)\] для (.*)\[(.*)\]: (.*)", las)
{
	if (las1 = "")
	{
		vk_send("Тебе отписал администратор " las4 ":`n" las8)
	}
}
return

readchat:
Total = 0
FileGetSize, sizefile, %chatlog%
if (lastsizefile = sizefile)
    return
lastsizefile = %sizefile%
FileEncoding, UTF-8
FileRead, chatt, %chatlog%
Loop, parse, chatt, `n, `r
{
	if (A_LoopField = "")
		continue
	last3line := last2line
	last2line := lastline
	lastline := A_LoopField
	Total++
}
if chatall not contains %last3line%
{
	templl := last3line
	lastline := last3line
	gosub dochat
	last3line := templl
	chatall = %chatall%`n%last3line%
}
if chatall not contains %last2line%
{
	templl := last2line
	lastline := last2line
	gosub dochat
	last2line := templl
	chatall = %chatall%`n%last2line%
}
if chatall not contains %lastline%
{
	gosub dochat
	chatall = %chatall%`n%lastline%
}
chatrazn := A_TickCount - chattime
if chatrazn > 600000
{
	chattime := A_TickCount
	chatall = %last3line%`n%last2line%`n%lastline%
}
;tooltip, %last3line%`n%last2line%`n%lastline%
return

Escape::ExitApp