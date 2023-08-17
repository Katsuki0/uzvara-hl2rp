PrecacheParticleSystem("cmb_tracer")
PrecacheParticleSystem("ar2_combineball")

if CLIENT then
	game.AddParticles("particles/cmb_tracers_rework.pcf")
	CreateClientConVar("cmb_tracers_energyball", 1)
end

if SERVER then
	game.AddParticles("particles/cmb_tracers_rework.pcf")
end