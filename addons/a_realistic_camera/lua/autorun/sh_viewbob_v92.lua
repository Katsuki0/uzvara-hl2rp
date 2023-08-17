
-----------------------------------------------------------
--	View Shake @ LuaPineapple
--	Update @ V92
--	Workshop Link:	http://steamcommunity.com/sharedfiles/filedetails/?id=572928034
-----------------------------------------------------------

AddCSLuaFile()

if !ConVarExists("VNT_ViewBob_Toggle") then		CreateConVar( "VNT_ViewBob_Toggle", 1,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("VNT_ViewBob_Mul") then		CreateConVar( "VNT_ViewBob_Mul", 0.4,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end

if CLIENT then

	local PCalcT = {}
		PCalcT.VS 	 = 0
		PCalcT.WT 	 = 0
		PCalcT.Air	 = 0
		
	local function ShakeView(ply, origin, angles, fov)
		if GetConVarNumber( "VNT_ViewBob_Toggle" ) != 0 then
			if ply:GetMoveType() == 8 then
				return
			elseif (not ply:IsOnGround()) or ply:InVehicle() then -- They're in the air or in a car
				PCalcT.Air = math.Clamp(PCalcT.Air + 1, 0, 300)
				return
			else
				local vel = (ply:GetVelocity() * GetConVarNumber("VNT_ViewBob_Mul"))
				local ang = ply:EyeAngles()
				local mul = 5 
				PCalcT.VS = PCalcT.VS * 0.9 + vel:Length() * 0.1
				PCalcT.WT = PCalcT.WT + PCalcT.VS * FrameTime() * 0.1
				local view = {}
				view.origin = origin
				view.ply = ply
				view.fov = fov
				view.angles = angles
				if PCalcT.Air > 0 then
					PCalcT.Air = PCalcT.Air - (PCalcT.Air/10) -- Make it end in 10 frames
					view.angles.p = view.angles.p + (PCalcT.Air * 0.1) -- Pitch Cam Shake on Land
					view.angles.r = view.angles.r + PCalcT.Air*0.1 -- Roll Cam Shake on Land
				end
				--view.angles.r = angles.r + ang:Right():DotProduct(vel) * 0.01
				view.angles.r = angles.r + ang:Right():DotProduct(vel) * 0.03 -- Strafe Angles
				view.angles.r = angles.r + math.sin( PCalcT.WT ) * PCalcT.VS * 0.001
				--view.angles.r = angles.r + math.sin( PCalcT.WT ) * PCalcT.VS * mul
				view.angles.p = angles.p + math.sin( PCalcT.WT * 0.5 ) * PCalcT.VS * 0.001
				--view.angles.p = angles.p + math.sin( PCalcT.WT * 0.5 ) * PCalcT.VS * mul
				--return view -- <---- Breaks Ironsights
			end
		else
			return
		end
	end
	hook.Add("CalcView", "VNTViewShaking", ShakeView)

	local	function vntViewBobOptions( Panel )

		Panel:ClearControls()

		Panel:AddControl( "Checkbox", 	{ 
		Label = "View Bob Toggle",	
		Command = "VNT_ViewBob_Toggle",
		Type = "bool", 	
		}  )

		Panel:AddControl( "Slider", 	{ 
		Label = "View Bob Multiplier",	
		Command = "VNT_ViewBob_Mul",
		Type = "float", 	
		Min = "3", 	
		Max = "3"
		}  )

	end
end