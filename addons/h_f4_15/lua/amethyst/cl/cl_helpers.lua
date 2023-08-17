/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/


--[[ -----------------------------------------------------------------------------------------------

                    DRAW HELPERS

@desc:              A number of items that can be called in order to help with drawing certain
					things that are needed within the F4 Menu.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function draw.AmethystBox( xpos, ypos, wsize, hsize, color )
	surface.SetDrawColor( color )
	surface.DrawRect( xpos, ypos, wsize, hsize )
end

function draw.Amethyst_DrawBlur( obj, amt, depth )
	local doBlurMat = Material("pp/blurscreen")
	local xpos, ypos = obj:LocalToScreen(0, 0)
	local wsize, hsize = ScrW(), ScrH()

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( doBlurMat )

	for n = 1, ( depth or 3 ) do
		doBlurMat:SetFloat( "$blur", ( n / 3 ) * ( amt or 6 ) )
		doBlurMat:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( xpos * -1, ypos * -1, wsize, hsize )
	end
end

function draw.AmethystOutlinedBoxThick( x, y, w, h, borderthick, clr )
    surface.SetDrawColor( clr )
    for i=0, borderthick - 1 do
        surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
    end
end

function draw.AmethystOutlinedBox(xpos, ypos, wsize, hsize, colorMain, colorBorder)
	local i = 1
	local n = 2
	local defColor = Color( 0, 0, 0, 0 )

    surface.SetDrawColor(colorMain or defColor)
    surface.DrawRect(xpos + i, ypos + i, wsize - n, hsize - n)
    surface.SetDrawColor(colorBorder or defColor)
    surface.DrawOutlinedRect(xpos, ypos, wsize, hsize)
end

function draw.Amethyst_DoCircle(xpos, ypos, radius, seg)
	local c = {}
	local u = 0.5
	local v = 0.5
	local s = seg
	local r = radius

	surface.SetTexture(0)
	table.insert( c,
	{
		x = xpos,
		y = ypos,
		u = u,
		v = v
	})

	for n = 0, s do
		local a = math.rad((n / s) * -360)
		table.insert( c,
		{
			x = xpos + math.sin(a) * r,
			y = ypos + math.cos(a) * r,
			u = math.sin(a) / 2 + u,
			v = math.cos(a) / 2 + v
		})
	end

	local a = math.rad(0)
	table.insert( c,
	{
		x = xpos + math.sin(a) * r,
		y = ypos + math.cos(a) * r,
		u = math.sin(a) / 2 + u,
		v = math.cos(a) / 2 + v
	})
	return c
end

function draw.Amethyst_Circle(xpos, ypos, radius, seg, color)
	surface.SetDrawColor(color or Color( 0, 0, 0, 0 ))
	surface.DrawPoly(draw.Amethyst_DoCircle(xpos, ypos, radius, seg))
end

function Amethyst.StencilStart()
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	render.SetColorModulation( 1, 1, 1 )
end

function Amethyst.StencilReplace(v)
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue(v or 1)
end

function Amethyst.StencilEnd()
	render.SetStencilEnable( false )
end

function Amethyst.DrawCircle(posx, posy, radius, color)
	local p = {}
	local a = 40
	local c = 360
	local r = radius

	for n = 0, a do
		p[ n + 1 ] =
		{
			x = math.sin(-math.rad( n / a * c ) ) * r + posx,
			y = math.cos(-math.rad( n / a * c ) ) * r + posy
		}
	end

	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(p)
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS JOBS

@desc:              Determines if jobs section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasJobs()
	local doFetchCategories = DarkRP.getCategories().jobs
	for _, doCatResult in pairs( doFetchCategories ) do
		for k, v in pairs(RPExtraTeams) do
			if v.category == doCatResult.name then doHasCategory = true end
		end
		if doHasCategory then
			return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS AMMO

@desc:              Determines if ammo section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasAmmo()
	local doFetchCategories = DarkRP.getCategories().ammo
	for _, doCatResult in pairs( doFetchCategories ) do
		for k, v in pairs(GAMEMODE.AmmoTypes) do
			if v.category == doCatResult.name then
				doHasCategory = true
			end
		end
		if doHasCategory then
			return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS ENTITIES

@desc:              Determines if entities section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasEntities()
	local doFetchCategories = DarkRP.getCategories().entities
	for _, doCatResult in pairs( doFetchCategories ) do
		local doHasCategory = false
		for k, v in pairs(DarkRPEntities) do
			local doPopulateJobs = {}
			if type(v.allowed) == "string" then
				table.insert(doPopulateJobs, v.allowed)
			else
				doPopulateJobs = v.allowed
			end
			if (v.allowed and table.HasValue(doPopulateJobs, LocalPlayer():Team())) or not v.allowed then
				if v.category == doCatResult.name then doHasCategory = true end
			end
		end
		if doHasCategory then
			return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS WEAPONS

@desc:              Determines if weapoons section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasWeapons()
	local doFetchCategories = DarkRP.getCategories().weapons
	for _, doCatResult in pairs( doFetchCategories ) do
		local doHasCategory = false
		for k, v in pairs(CustomShipments) do
			if (v.seperate and (not GAMEMODE.Config.restrictbuypistol or (GAMEMODE.Config.restrictbuypistol and (not v.allowed[1] or table.HasValue(v.allowed, LocalPlayer():Team()))))) and (not v.customCheck or v.customCheck and v.customCheck(LocalPlayer())) then
				if v.category == doCatResult.name then doHasCategory = true end
			end
		end
		if doHasCategory then
			return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS SHIPMENTS

@desc:              Determines if shipments section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasShipments()
	local doFetchCategories = DarkRP.getCategories().shipments
	for _, doCatResult in pairs( doFetchCategories ) do
		local doHasCategory = false
		for k, v in pairs(CustomShipments) do
			if not v.noship and table.HasValue(v.allowed, LocalPlayer():Team()) and (not v.customCheck or (v.customCheck and v.customCheck(LocalPlayer()))) then
				if v.category == doCatResult.name then doHasCategory = true end
			end
		end
		if doHasCategory then
			return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS FOOD

@desc:              Determines if food section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasFood()
	if FoodItems then
		for k, v in pairs(FoodItems) do
		    return true
		end
	end
end

--[[ -----------------------------------------------------------------------------------------------

                    HAS VEHICLES

@desc:              Determines if vehicle section has any items within categories.
@conditions:        None
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst.HasVehicles()
	local GetVehicleItems = 0
	if CustomVehicles then
		for k, v in pairs(CustomVehicles) do
			local doPopulateAllowed = {}
			if type(v.allowed) == "string" then
				table.insert(doPopulateAllowed, v.allowed)
			else
				doPopulateAllowed = v.allowed
			end

			if (v.allowed and table.HasValue(doPopulateAllowed, LocalPlayer():Team())) or not v.allowed then
				GetVehicleItems = GetVehicleItems + 1
			end
		end
	end
	if GetVehicleItems != 0 then
		return true
	end
end

function Amethyst.RemoveTimers()
    if timer.Exists("amethyst.ticker") then timer.Remove( "amethyst.ticker" ) end
    if timer.Exists("amethyst.settings.reopen") then timer.Remove( "amethyst.settings.reopen" ) end
    if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove("amethyst.achievements.hoverdesc") end
end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/