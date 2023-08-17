/*
╔══╦╗╔╦════╦╗╔╦══╦═══╗
║╔╗║║║╠═╗╔═╣║║║╔╗║╔═╗╠╗
║╚╝║║║║─║║─║╚╝║║║║╚═╝╠╝
║╔╗║║║║─║║─║╔╗║║║║╔╗╔╬╗
║║║║╚╝║─║║─║║║║╚╝║║║║╚╝
╚╝╚╩══╝─╚╝─╚╝╚╩══╩╝╚╝
╔══╦╗─╔══╦╗──╔╦═══╦══╗╔══╦╗─╔╗
║╔═╣║─╚╗╔╣║──║║╔══╣╔╗║║╔╗║║─║║
║╚═╣║──║║║╚╗╔╝║╚══╣╚╝╚╣╚╝║║─║║
╚═╗║║──║║║╔╗╔╗║╔══╣╔═╗║╔╗║║─║║
╔═╝║╚═╦╝╚╣║╚╝║║╚══╣╚═╝║║║║╚═╣╚═╗
╚══╩══╩══╩╝──╚╩═══╩═══╩╝╚╩══╩══╝
*/
redcode = {}

if CLIENT then
	include( "redcode/config.lua" )
	include( "redcode/cl_init.lua" )
end

if SERVER then
	AddCSLuaFile( "redcode/config.lua" )
	AddCSLuaFile( "redcode/cl_init.lua" )

	include( "redcode/config.lua" )
	MsgC(Color(0,255,0), "")
end 
