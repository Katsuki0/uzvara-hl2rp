function ContextOpen()
        LocalPlayer():ConCommand ("open_context_menu")
end
hook.Add ("OnContextMenuOpen", "Context", ContextOpen)

local function isCP()
	return LocalPlayer():isCP()
end
 
function closecontext ()
        if loz then
                loz:Remove()
        end
end
hook.Add ("OnContextMenuClose", "Context", closecontext)
 
function draw_textbox(strTitle, strBtn, strDefaultText, fnEnter)
        local Window = vgui.Create ("DFrame")
        Window:SetTitle (strTitle)
        Window:ShowCloseButton(true)
        Window:MakePopup()
        Window:SetSize (250, 100)
        Window:Center()
        Window:SetKeyboardInputEnabled(true)
        Window:SetMouseInputEnabled(true)
        Window.Paint = function()
                draw.RoundedBox ( 0, 0, 0, Window:GetWide(), Window:GetTall(), Color(0,0,0,255) )
                draw.RoundedBox ( 0, 1, 1, Window:GetWide()-2, Window:GetTall()-2, Color(255,255,255,100) )
        end
 
        local TextEntr = vgui.Create( "DTextEntry", Window)
        TextEntr:SetPos (75, 25)
        TextEntr:SetSize (110, 20)
        TextEntr:SetMultiline (false)
        TextEntr:SetAllowNonAsciiCharacters( true )
        TextEntr:SetText(strDefaultText || "")
        TextEntr:SetEnterAllowed (true)
 
        local Btn = vgui.Create ("DButton", Window)
        Btn:SetText(strBtn)
        Btn:SetSize (110, 20)
        Btn:SetPos (75, 50)
        Btn.DoClick = function ()
                fnEnter( TextEntr:GetValue() )
                Window:Remove()
        end
end
  
function OpenContextMenu(ply, argm, cmd)
        local context = DermaMenu()
		if (ply:Team() == TEAM_GRAZHDANIN) or (ply:Team() == TEAM_RAZNORABOCHIJ) or (ply:Team() == TEAM_DSPMEDIK) or (ply:Team() == TEAM_OGNEMETXHIK) or (ply:Team() == TEAM_PISHEVOJSNABDITEL) or (ply:Team() == TEAM_GRUZHCHIK) or (ply:Team() == TEAM_POSILNIJ) or (ply:Team() == TEAM_BEZHENEC) or (ply:Team() == TEAM_VORTIGONT) or (ply:Team() == TEAM_MEDICPOVSTANEC) or (ply:Team() == TEAM_TORGOVECPOVSTANCEV) or (ply:Team() == TEAM_ADMGORODA) or (ply:Team() == TEAM_POVSTANEC) then
		 local vortmenucod, editvort = context:AddSubMenu("Общение")
            editvort:SetImage ("feed.png")
			vortmenucod:AddOption( "Привет", function() 
                RunConsoleCommand ("say", "Привет") 
        net.Start("emitradius")
        net.WriteString("hi02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Окей", function() 
                RunConsoleCommand ("say", "Окей") 
        net.Start("emitradius")
        net.WriteString("ok01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Нет", function() 
                RunConsoleCommand ("say", "Нет") 
        net.Start("emitradius")
        net.WriteString("no01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Извините", function() 
                RunConsoleCommand ("say", "Извините") 
        net.Start("emitradius")
        net.WriteString("excuseme02.mp3")
        net.SendToServer()
	 end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Потрясающе", function() 
                RunConsoleCommand ("say", "Потрясающе") 
        net.Start("emitradius")
        net.WriteString("fantastic01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Понятно", function() 
                RunConsoleCommand ("say", "Понятно") 
        net.Start("emitradius")
        net.WriteString("answer08.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Зачем?", function() 
                RunConsoleCommand ("say", "Зачем?") 
        net.Start("emitradius")
        net.WriteString("gordead_ans13.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Берегись!", function() 
                RunConsoleCommand ("say", "Берегись!") 
        net.Start("emitradius")
        net.WriteString("headsup01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 		vortmenucod:AddOption( "Помогите!", function() 
                RunConsoleCommand ("say", "Помогите!") 
        net.Start("emitradius")
        net.WriteString("help01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 			
	 	 	vortmenucod:AddOption( "Чёрт", function() 
                RunConsoleCommand ("say", "Чёрт") 
        net.Start("emitradius")
        net.WriteString("imhurt02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Отлично", function() 
                RunConsoleCommand ("say", "Отлично") 
        net.Start("emitradius")
        net.WriteString("nice.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 	 	vortmenucod:AddOption( "Убирайся отсюда к чёрту!", function() 
                RunConsoleCommand ("say", "Убирайся отсюда к чёрту!") 
        net.Start("emitradius")
        net.WriteString("gethellout.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "ГО-шники", function() 
                RunConsoleCommand ("say", "ГО-шники") 
        net.Start("emitradius")
        net.WriteString("cps02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			vortmenucod:AddOption( "Зомби!", function() 
                RunConsoleCommand ("say", "Зомби!") 
        net.Start("emitradius")
        net.WriteString("zombies02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		end
		if (ply:Team() == TEAM_DEZERTIR) or (ply:Team() == TEAM_UNIT1) or (ply:Team() == TEAM_UNIT2) or (ply:Team() == TEAM_UNIT3) or (ply:Team() == TEAM_UNIT4) or (ply:Team() == TEAM_UNIT5) or (ply:Team() == TEAM_UNITENGINER) or (ply:Team() == TEAM_PILIOTA) or (ply:Team() == TEAM_UNITMEDIC) or (ply:Team() == TEAM_CMDUNIT) or (ply:Team() == TEAM_CMDOTA) then
		 local gomenucod, editgo = context:AddSubMenu("Общение")
            editgo:SetImage ("transmit_blue.png")
			gomenucod:AddOption( "Выполнять", function() 
                RunConsoleCommand ("say", "Выполнять") 
        net.Start("emitradius")
        net.WriteString("administer.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Так точно", function() 
                RunConsoleCommand ("say", "Так точно") 
        net.Start("emitradius")
        net.WriteString("affirmative.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Отсечь!", function() 
                RunConsoleCommand ("say", "Отсечь!") 
        net.Start("emitradius")
        net.WriteString("amputate.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Нарушитель", function() 
                RunConsoleCommand ("say", "Нарушитель") 
        net.Start("emitradius")
        net.WriteString("anticitizen.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Назад", function() 
                RunConsoleCommand ("say", "Назад") 
        net.Start("emitradius")
        net.WriteString("backup.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Ха-Ха-Ха", function() 
                RunConsoleCommand ("say", "Ха-Ха-Ха") 
        net.Start("emitradius")
        net.WriteString("chuckle.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Стоять!", function() 
                RunConsoleCommand ("say", "Стоять!") 
        net.Start("emitradius")
        net.WriteString("dontmove.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Проверить", function() 
                RunConsoleCommand ("say", "Проверить") 
        net.Start("emitradius")
        net.WriteString("examine.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Первое предупреждение", function() 
                RunConsoleCommand ("say", "Первое предупреждение") 
        net.Start("emitradius")
        net.WriteString("firstwarningmove.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Второе предупреждение", function() 
                RunConsoleCommand ("say", "Второе предупреждение") 
        net.Start("emitradius")
        net.WriteString("secondwarning.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Последние предупреждение", function() 
                RunConsoleCommand ("say", "Последние предупреждение") 
        net.Start("emitradius")
        net.WriteString("finalwarning.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Убирайся вон!", function() 
                RunConsoleCommand ("say", "Убирайся вон!") 
        net.Start("emitradius")
        net.WriteString("getoutofhere.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Двигайся!", function() 
                RunConsoleCommand ("say", "Двигайся!") 
        net.Start("emitradius")
        net.WriteString("move.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Помощь нужна?", function() 
                RunConsoleCommand ("say", "Помощь нужна?") 
        net.Start("emitradius")
        net.WriteString("needanyhelpwiththisone.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Хочешь в участок?", function() 
                RunConsoleCommand ("say", "Хочешь в участок?") 
        net.Start("emitradius")
        net.WriteString("youwantamalcomplianceverdict.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			gomenucod:AddOption( "Прикройте меня, я захожу!", function() 
                RunConsoleCommand ("say", "Прикройте меня, я захожу!") 
        net.Start("emitradius")
        net.WriteString("covermegoingin.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
        end
		if (ply:Team() == TEAM_OTAUNION) or (ply:Team() == TEAM_OTASECURITY) or (ply:Team() == TEAM_OTAHEAVY) or (ply:Team() == TEAM_OTAELITE) or (ply:Team() == TEAM_SNIPER) then
		 local otamenucod, editota = context:AddSubMenu("Общение")
            editota:SetImage ("transmit.png")
			otamenucod:AddOption( "Вас понял!", function() 
                RunConsoleCommand ("say", "Вас понял!") 
        net.Start("emitradius")
        net.WriteString("copythat.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			otamenucod:AddOption( "Прикрой", function() 
                RunConsoleCommand ("say", "Прикрой") 
        net.Start("emitradius")
        net.WriteString("cover.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Готов!", function() 
                RunConsoleCommand ("say", "Готов!") 
        net.Start("emitradius")
        net.WriteString("delivered.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Вперёд!", function() 
                RunConsoleCommand ("say", "Вперёд!") 
        net.Start("emitradius")
        net.WriteString("movein.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Стоп!", function() 
                RunConsoleCommand ("say", "Стоп!") 
        net.Start("emitradius")
        net.WriteString("onehundred.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Чисто!", function() 
                RunConsoleCommand ("say", "Чисто!") 
        net.Start("emitradius")
        net.WriteString("secure.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Жду указаний!", function() 
                RunConsoleCommand ("say", "Жду указаний!") 
        net.Start("emitradius")
        net.WriteString("standingby.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Выдвигаюсь!", function() 
                RunConsoleCommand ("say", "Выдвигаюсь!") 
        net.Start("emitradius")
        net.WriteString("sweepingin.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		otamenucod:AddOption( "Вижу цель!", function() 
                RunConsoleCommand ("say", "Вижу цель!") 
        net.Start("emitradius")
        net.WriteString("targetcontactat.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		end
		if (ply:Team() == TEAM_ZOMBINE) or (ply:Team() == TEAM_ZOMBIE) then
		 local zombiemenucod, editzombie = context:AddSubMenu("Общение")
            editzombie:SetImage ("feed.png")
			zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie1.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie2.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 		zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie3.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 			zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie4.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 			zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie5.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 			zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie6.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
				zombiemenucod:AddOption( "Рычание", function() 
                RunConsoleCommand ("say", "") 
        net.Start("emitradius")
        net.WriteString("zombie7.wav")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		end
		if (ply:Team() == TEAM_VIZHIVSHIJVOENNIJ) then
		 local voennijmenucod, editvoennij = context:AddSubMenu("Общение")
            editvoennij:SetImage ("feed.png")
			voennijmenucod:AddOption( "Привет", function() 
                RunConsoleCommand ("say", "Привет") 
        net.Start("emitradius")
        net.WriteString("hi02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Окей", function() 
                RunConsoleCommand ("say", "Окей") 
        net.Start("emitradius")
        net.WriteString("ok01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Нет", function() 
                RunConsoleCommand ("say", "Нет") 
        net.Start("emitradius")
        net.WriteString("no01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Извините", function() 
                RunConsoleCommand ("say", "Извините") 
        net.Start("emitradius")
        net.WriteString("excuseme02.mp3")
        net.SendToServer()
	 end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Потрясающе", function() 
                RunConsoleCommand ("say", "Потрясающе") 
        net.Start("emitradius")
        net.WriteString("fantastic01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Понятно", function() 
                RunConsoleCommand ("say", "Понятно") 
        net.Start("emitradius")
        net.WriteString("answer08.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Зачем?", function() 
                RunConsoleCommand ("say", "Зачем?") 
        net.Start("emitradius")
        net.WriteString("gordead_ans13.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Берегись!", function() 
                RunConsoleCommand ("say", "Берегись!") 
        net.Start("emitradius")
        net.WriteString("headsup01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 		voennijmenucod:AddOption( "Помогите!", function() 
                RunConsoleCommand ("say", "Помогите!") 
        net.Start("emitradius")
        net.WriteString("help01.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 	 	voennijmenucod:AddOption( "Чёрт", function() 
                RunConsoleCommand ("say", "Чёрт") 
        net.Start("emitradius")
        net.WriteString("imhurt02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Отлично", function() 
                RunConsoleCommand ("say", "Отлично") 
        net.Start("emitradius")
        net.WriteString("nice.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
	 	 	voennijmenucod:AddOption( "Убирайся отсюда к чёрту!", function() 
                RunConsoleCommand ("say", "Убирайся отсюда к чёрту!") 
        net.Start("emitradius")
        net.WriteString("gethellout.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "ГО-шники", function() 
                RunConsoleCommand ("say", "ГО-шники") 
        net.Start("emitradius")
        net.WriteString("cps02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
			voennijmenucod:AddOption( "Зомби!", function() 
                RunConsoleCommand ("say", "Зомби!") 
        net.Start("emitradius")
        net.WriteString("zombies02.mp3")
        net.SendToServer()
     end):SetImage("icon16/user_comment.png")
		end
	if LocalPlayer():isMayor() then
                context:AddOption("Начать лотерею", function () Derma_StringRequest("Лотерея", "Введите количество денег которые хотите разыграть", "500", function (text) RunConsoleCommand("say", "/lottery ", text) end, function () end, "Начать", "Отмена") end):SetImage("icon16/money.png")
        end
        context:AddSpacer()
		if LocalPlayer():Team() == TEAM_CMDUNIT then
		context:AddOption ("[Доп]Вкл комендатский час", function() RunConsoleCommand("say", "/lockdown") end):SetImage("icon16/add.png") 
		end
		
		context:AddSpacer()
		if LocalPlayer():Team() == TEAM_CMDUNIT then
		context:AddOption ("[Доп]Выкл комендатский час", function() RunConsoleCommand("say", "/unlockdown") end):SetImage("icon16/cancel.png") 
		end
		--Написать жалобу
		context:AddOption ("Написать жалобу", function() RunConsoleCommand("say", "/calladmin") end):SetImage("icon16/flag_green.png")
		--Вызвать Гражданскую оборону
		context:AddOption ("Бросить кубик", function() RunConsoleCommand("say", "/roll 6") end):SetImage("icon16/sport_8ball.png") 
		--Режим полета
		context:AddOption ("Режим полета", function() RunConsoleCommand("ulx", "noclip") end, function() return ULib.ucl.query(LocalPlayer(), "ulx noclip") end):SetImage("icon16/arrow_out.png")       
		--Передать деньги
        context:AddOption ("Передать деньги тому на кого вы смотрите", function ()
        draw_textbox("Введите кол-во", "Передать", "", function(a) RunConsoleCommand ("darkrp", "give", tostring(a)) end)   
        end):SetImage ("icon16/money.png")
		--Выбросить оружие
        context:AddOption( "Выбросить оружие", function() RunConsoleCommand ("darkrp", "dropweapon") end ):SetImage("icon16/gun.png")
		--Выбросить деньги
        context:AddOption( "Выбросить деньги", function()
        draw_textbox("Введите кол-во", "Выбросить", "", function(a) RunConsoleCommand ("darkrp", "dropmoney", tostring(a)) end)
        end ):SetImage("icon16/money.png")
		--Продать все двери
        context:AddOption ("Продать все двери", function() RunConsoleCommand ("darkrp", "unownalldoors") end):SetImage("icon16/door.png")
        context:Open()
        context:CenterHorizontal()
        context.y = ScrH() + 100
        context:MoveTo(context.x, ScrH() - context:GetTall() - 8, .0, 0)
end

concommand.Add("open_context_menu", OpenContextMenu)