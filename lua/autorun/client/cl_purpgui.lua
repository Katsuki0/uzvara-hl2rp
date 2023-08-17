PURP_Skin = {}
PURP_Skin.FontTbl = {}

PURP_ColorLight = Color(160,120,200,200)
PURP_Color = Color(100,60,140,200)
PURP_ColorBG = Color(100,60,140,255)

PURP_GetHud = Material("viv_arp_hud/arp_hud_texture.png")
PURP_GetHudPDA = Material("viv_arp_hud/arp_hud_pda.png")
PURP_GetPanel = Material("viv_arp_panel/bg_panel.png")

blur = Material("pp/blurscreen")
gradient_PURP = surface.GetTextureID("VGUI/fas2/gradient_dual")

if( SERVER )then
	AddCSLuaFile("textureSheet.lua")
	return
end

function PURP_Skin.Font(font, size, weightf, shadowf) 
	local name = font.."GuiFont"..size
	if(weightf == nil)then weightf = 500 end
	if(shadowf == nil)then shadowf = false end
	if !table.HasValue(PURP_Skin.FontTbl, name) then
		surface.CreateFont( name,
		{
			font = font,
			size = size,
			weight = weightf,
			outline = shadowf
		}
		) 
		table.insert(PURP_Skin.FontTbl, name)
	end
	return name 
end

function DrawBlurRect(x, y, w, h, amount, heavyness, color)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(blur)
	
	for i = 1, heavyness do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()		
		render.SetScissorRect(x, y, x + w, y + h, true)
		surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
	draw.RoundedBoxEx(0, x, y, w, h, color, true, true, true, true )
	
	surface.SetTexture(gradient_PURP)
	surface.SetDrawColor(60,20,100, 200)
	surface.DrawTexturedRect(x, y, w, h)
end

function PURPRoundedBoxEx(roll, x, y, w, h, color, lu, ru, ld, rd, colorg)
	draw.RoundedBoxEx(roll, x, y, w, h, color, lu, ru, ld, rd)
	surface.SetTexture(gradient_PURP)
	surface.SetDrawColor(colorg)
	surface.DrawTexturedRect(x, y, w, h)
end
function PURPRoundedBoxExText(text, font,roll, x, y, w, h, color, lu, ru, ld, rd, colorg)
	draw.RoundedBoxEx(roll, x, y, w, h, color, lu, ru, ld, rd)
	surface.SetTexture(gradient_PURP)
	surface.SetDrawColor(colorg)
	surface.DrawTexturedRect(x, y, w, h)
	draw.SimpleTextOutlined( text, font,  x + w /2, y + h / 2, Color( 255,255,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )		
end

if( SERVER )then
	AddCSLuaFile( "textureSheet.lua" );
	
	-- We don't need these functions on the server
	return;
end;

-- A function to draw a certain part of a texture
function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	--[[ 
		Arguments:
		x: Where is it drawn on the x-axis of your screen
		y: Where is it drawn on the y-axis of your screen
		w: How wide must the image be?
		h: How high must the image be?
		partx: Where on the given texture's x-axis can we find the image you want?
		party: Where on the given texture's y-axis can we find the image you want?
		partw: How wide is the partial image in the given texture?
		parth: How high is the partial image in the given texture?
		texw: How wide is the texture?
		texh: How high is the texture?
	]]--
	
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
		ErrorNoHalt("surface.DrawPartialTexturedRect: Missing argument!");
		
		return;
	end;
	
	-- Get the positions and sizes as percentages / 100
	local percX, percY = partx / texw, party / texh;
	local percW, percH = partw / texw, parth / texh;
	
	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
		}
	};
		
	surface.DrawPoly( vertexData );
end;

function draw.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texturename )
	--[[ 
		Arguments:
		- Also look at the arguments of the surface version of this
		texturename: What is the name of the texture?
	]]--
	
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texturename ) then
		ErrorNoHalt("draw.DrawPartialTexturedRect: Missing argument!");
		
		return;
	end;
	
	-- Get the texture
	local texture = texturename
	
	-- Get the positions and sizes as percentages / 100
	local texW, texH = 512,256
	local percX, percY = partx / texW, party / texH;
	local percW, percH = partw / texW, parth / texH;
	
	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
		}
	};
	
	surface.SetMaterial( texture );
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.DrawPoly( vertexData );
end;