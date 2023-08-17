cm = {} -- Do not edit this line.

-- Effects of the coffe.
cm.enablespeed		= true -- True = Coffe will heal you, False = Coffe will not heal you.

cm.enablehunger		= true -- True = Coffe will give food, False = Coffe will not give food.
-------------------------------------------------------------------------------------------------
cm.enablesounds		= true -- Enable or disable sounds.

cm.coffeprice		= 8 -- How much coffe will cost.

cm.coffeenergy		= 100 -- How much food will give (Hungermod Only)

cm.speedtimer		= 0 -- The amount of time the speed boost will last.

cm.speedmult		= 0 -- Speed multiplier.

-- Locations for coffe machines.
cm.mapspawn = {} -- Do not edit this line

/*--
	cm.mapspawn["map_name"] = {		-- Map that Coffe Machine spawns on.
		pos = Vector( 0, 0, 0 ),	-- The vector of the Coffe Machine.
		ang = Angle( 0, 0, 0 )		-- The angle of the Coffe Machine.
	}
--*/


cm.mapspawn["rp_downtown_v4c_v2a"] = {
	pos = Vector( -201, -780, -131),
	ang = Angle( 0, 0, 0 )
}
	
cm.mapspawn["rp_bangclaw"] = {
	pos = Vector( -1155, -528, 136 ),
	ang = Angle( 0, -90, 0 )
}
-------------------------------------------------------------------------------------------------

MsgC( Color( 0, 187, 255 ), "Machines mod." ) -- Do not edit this line.