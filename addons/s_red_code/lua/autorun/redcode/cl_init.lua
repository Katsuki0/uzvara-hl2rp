surface.CreateFont( "DisplayStatusCodeInHUD", {
	font = "Trebuchet24",
	size = (ScrH() + ScrW()) * .011,
	weight = 300, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
} )

surface.CreateFont( "SW.ClockFont", {

	font = "Trebuchet MS",
	
	extended = false,
	
	size = 24,
	
	weight = 200,
	
	blursize = 0,
	
	scanlines = 1,
	
	antialias = true
	
} )


if redcode.config.hud then
	hook.Add("HUDPaint","PaintRedCodeHUD",function()
		if GetGlobalInt( "Slime_Red_Code" ) == 1 then
			draw.SimpleTextOutlined(redcode.config.hudtext2, "SW.ClockFont", ScrW() * .5, ScrH() * .2,  Color(255,70,70,100), 1, 0, 1,Color(0,0,0,255) )
			draw.SimpleTextOutlined("До окончания осталось : "..(math.Round(timer.TimeLeft("timer_for_RC") or 0)).." секунд", "SW.ClockFont", ScrW() * .5, ScrH() * .24,  Color(255,70,70,100), 1, 0, 1,Color(0,0,0,255) )
		end

		if GetGlobalInt("JobPhaseStatus") == 1 then
			draw.SimpleTextOutlined(redcode.config.hudtext_job, "SW.ClockFont", ScrW() * .5, ScrH() * .2,  Color(204,204,0,100), 1, 0, 1,Color(0,0,0,255) )
			draw.SimpleTextOutlined("До окончания осталось : "..(math.Round(timer.TimeLeft("timer_for_JP") or 0)).." секунд", "SW.ClockFont", ScrW() * .5, ScrH() * .24,  Color(204,204,0,100), 1, 0, 1,Color(0,0,0,255) )
		end
	end)
end


net.Receive("JobPhaseStarted", function ()
	timer.Create("timer_for_JP", redcode.config.job_phase, 1, function () end)
end)


net.Receive("JobPhaseEnded", function ()
	timer.Destroy("timer_for_JP")
end)

net.Receive("RedCodeStarted",function()
	local soundtable = {
	'ambient/alarms/citadel_alert_loop2', 
	'ambient/alarms/city_siren_loop2',
	'ambient/alarms/combine_bank_alarm_loop1',
	'ambient/alarms/combine_bank_alarm_loop4',
	'ambient/alarms/manhack_alert_pass1',
	'ambient/alarms/scanner_alert_pass1',
} 

timer.Create("timer_for_RC", redcode.config.redcode, 1, function () end)

 if( timer.Exists("CitadelAlarm")) then return end
	surface.PlaySound( soundtable[math.random( 1, 4 )] ..'.wav')
		timer.Create("CitadelAlarm",250,0,function() -- 15 секунды, после которой начинает играть другая рандомная музыка
		  print('playing: '..soundtable[math.random( 1, 4 )])
		         urface.PlaySound( soundtable[math.random( 1, 4 )] ..'.wav' )
		      end)
end)

net.Receive("RedCodeEnd",function(ply)
	LocalPlayer():ConCommand( "stopsound" )
	timer.Destroy("CitadelAlarm")
	timer.Destroy("timer_for_RC")
end)