AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Станковый пулемет"
ENT.Category = "Технологии Альянса"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

local function matTranspose3x3(matrix)
    local tb = matrix:ToTable()
    local tb1 = {
        {tb[1][1], tb[2][1], tb[3][1], 0},
        {tb[1][2], tb[2][2], tb[3][2], 0},
        {tb[1][3], tb[2][3], tb[3][3], 0},
        {0, 0, 0, 0},
    }

    return Matrix(tb1)
end

if (SERVER) then
    local _vehicleTable = {}
    local _mantable = {}

    local function FindTheGun(_ent)
        local _const = constraint.FindConstraints(_ent, "Weld")
        for k, v in pairs(_const) do
            local ent = NULL

            if(v.Ent1:GetClass() == "entity_ar3_ent") then
                ent = v.Ent1
            elseif(v.Ent2:GetClass() == "entity_ar3_ent") then
                ent = v.Ent2
            end

            if(IsValid(ent)) then return ent end
        end
    end

    hook.Add("PlayerEnteredVehicle", "AR3DriveTest", function(ply, veh, role)
        local mannedgun = _mantable[ply:EntIndex()]
        if(IsValid(mannedgun)) then
            mannedgun:AR3Deactivate()
        end

        local gun = _vehicleTable[veh:EntIndex()] or FindTheGun(veh)

        if(!IsValid(gun)) then return end

        gun.DriveMode = true
        gun.Vehicle = veh

        _vehicleTable[veh:EntIndex()] = gun

        gun.User = ply
        
        gun:AR3Activate()
    end)

    hook.Add("PlayerLeaveVehicle", "AR3DriveTest", function(ply, veh)
        local gun = _vehicleTable[veh:EntIndex()] or FindTheGun(veh)

        if(!IsValid(gun)) then return end

        gun:AR3Deactivate()
    end)

    function ENT:Initialize()
        self:SetModel("models/props_combine/bunker_gun01.mdl")
        
        self:PhysicsInitBox(-Vector(8,8,0), Vector(8,8,8))

        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:Wake()
        end

        self.User = NULL
        self.UserPrevWeapon = NULL
        self.Active = false
        self.DriveMode = false
        self.Vehicle = NULL

        self.OldAim = Vector(0, 0, 0)

        self._ShootTimer = 0
        self._UseTimer = 0
        self._SequenceTimer = 0

        self:SetUseType(USE_TOGGLE)

        /*for i = 0, self:GetSequenceCount() - 1 do
            print(i, self:GetSequenceName(i))
        end*/

        /*for i = 0, self:GetBoneCount() - 1 do
            print(i, self:GetBoneName(i))
        end*/
    end

    local shootdelay = 0.1
    local usetime = 0.5

    function ENT:DoImpactEffect(tr, _dmg)
        local ef = EffectData()
        ef:SetOrigin(tr.HitPos + tr.HitNormal * 2)
        ef:SetNormal(tr.HitNormal)
        ef:SetScale(1)

        util.Effect("AR2Impact", ef)
        return true
    end

    function ENT:AR3Activate()
        self:EmitSound("weapons/shotgun/shotgun_cock.wav")

        self:ResetSequence(1)
        self._SequenceTimer = CurTime() + 0.5

        if(!self.DriveMode) then
            self.UserPrevWeapon = self.User:GetActiveWeapon()
            self.User:SetActiveWeapon(NULL)            
        end

        _mantable[self.User:EntIndex()] = self

        self.Active = true

        self:SetNWEntity("user", self.User)
        self:SetNWBool("driving", self.DriveMode)
        self:SetNWBool("using", true)

        self.OldAim = self:GetForward()
    end

    function ENT:AR3Deactivate()
        if(!IsValid(self.User)) then return end

        self:EmitSound("weapons/shotgun/shotgun_cock.wav")

        self:ResetSequence(3)
        self._SequenceTimer = CurTime() + self:SequenceDuration()

        if(!self.DriveMode && IsValid(self.UserPrevWeapon)) then
            self.User:SelectWeapon(self.UserPrevWeapon:GetClass() or "weapon_crowbar")
        end

        _mantable[self.User:EntIndex()] = nil

        self.User = NULL

        self.Active = false

        self:SetNWEntity("user", self.User)
        self:SetNWBool("driving", false)
        self:SetNWBool("using", false)
    end

    function ENT:Use(act, caller, _type, _val)
        if(self._UseTimer > CurTime() || act:EyePos():DistToSqr(self:GetPos()) > 64 * 64) then return end

        if(self.DriveMode) then
            if(IsValid(self.Vehicle) && IsValid(FindTheGun(self.Vehicle))) then return
            else
                self.Vehicle = NULL
                self.DriveMode = false
            end
        end

        if(!IsValid(self.User) && !_mantable[act:EntIndex()]) then
            self.User = act

            self:AR3Activate()
        elseif(self.User == act) then
            self:AR3Deactivate()
        end

        self._UseTimer = CurTime() + usetime
    end
    
    function ENT:OnRemove()
        self:AR3Deactivate()
    end

    local function ApproachVector(v1, v2, delta)
        local x = math.Approach(v1.x, v2.x, delta)
        local y = math.Approach(v1.y, v2.y, delta)
        local z = math.Approach(v1.z, v2.z, delta)

        return Vector(x,y,z)
    end

    function ENT:Think()
        if(IsValid(self.User)) then
            local ply = self.User

            if(ply:EyePos():DistToSqr(self:GetPos()) > 64 * 64 && !self.DriveMode || !ply:Alive()) then
                self:AR3Deactivate()
            end

            local _filter_ = {self, ply}

            if(ply:InVehicle()) then
                table.insert(_filter_, ply:GetVehicle())
            end

            local tr = util.TraceLine({
                start = ply:EyePos(),
                endpos = ply:EyePos() + ply:GetAimVector() * 65535,
                filter = _filter_
            })

            local transposed1 = matTranspose3x3(self:GetWorldTransformMatrix())

            local look = (tr.HitPos - self:GetBonePosition(4))
            local __dist = look:LengthSqr()
            look:Normalize()

            local mydestlook = ApproachVector(self.OldAim, look, 5 * FrameTime())

            self.OldAim = mydestlook
            local transformed = transposed1 * look
            local relang = transformed:Angle()

            if(relang.yaw > 180) then
                relang.yaw = relang.yaw - 360
            end

            if(relang.pitch > 180) then
                relang.pitch = relang.pitch - 360
            end

            local pitchoff = 10
            
            if(__dist > 2000) then
                self:ClearPoseParameters()
                self:SetPoseParameter("aim_yaw", relang.yaw)
                self:SetPoseParameter("aim_pitch", relang.pitch + pitchoff)
            end

            if(self._ShootTimer < CurTime() && ply:KeyDown(IN_ATTACK)) then
                local dest = mydestlook

                if(math.abs(relang.yaw) > 60 || relang.pitch < -35 || relang.pitch > 60) then
                    dest = self:GetAttachment(1).Ang:Forward()
                end

                local bullet = {
                    TracerName = "AR2Tracer",
                    Damage = 17,
                    Spread = Vector(1, 1, 0) * 0.02,
                    Src = self:GetAttachment(1).Pos,
                    Dir = dest,
                    Attacker = self.User,
                    Inflictor = self,
                    Callback = function(_att, _tr, _dmg)
                        if(_tr.Entity:IsPlayer() or _tr.Entity:IsVehicle()) then
                            _dmg:SetDamage(20)
                        end
                    end
                }

                self:FireBullets(bullet)
                self:EmitSound("Weapon_AR2.NPC_Single")

                self:ResetSequence(2)

                local ef = EffectData()
                ef:SetEntity(self)
                ef:SetAttachment(1)
                ef:SetFlags(5)

                util.Effect("MuzzleFlash", ef)

                self._SequenceTimer = CurTime() + self:SequenceDuration()

                self._ShootTimer = CurTime() + shootdelay
            end
        end

        if(self._SequenceTimer < CurTime() && self.Active) then
            self:ResetSequence(0)
            self._SequenceTimer = CurTime() + self:SequenceDuration()
        end

        self:NextThink(CurTime())
        return true
    end
else
    function ENT:Initialize()
        local mins, maxs = self:GetModelBounds()
        self:SetRenderBounds(mins, maxs, Vector(1, 1, 1) * 30)
    end

    function ENT:Think()
    end

    local chair = Material("sprites/hud/v_crosshair1")
    local flashlight = Material("sprites/glow03")
    local glow = Material("sprites/glow_test02")

    function ENT:Draw()
        self:DrawModel()

        local ply = self:GetNWEntity("user")

        if(self:GetNWBool("driving") && ply == LocalPlayer()) then
            render.SetMaterial(chair)
            render.DrawSprite(ply:EyePos() + ply:GetAimVector() * 200, 8, 8, Color(255,255,0,255))
        end
    end
end