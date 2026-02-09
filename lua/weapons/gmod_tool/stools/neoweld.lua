local TOOL = TOOL

TOOL.Name = "#tool.neoweld.name"
TOOL.Category = "Constraints"

TOOL.ClientConVar = {
    weld = "1",
    nocollide = "1",

    select_radius = "256",

    pairgen_bound_extend_factor = "2"
}

-- GUI

TOOL.Information = {
    { name = "left" }, -- Toggle selection
    { name = "left_use" }, -- Select in range
    { name = "right" }, -- Weld to each other
    { name = "right_use" }, -- Weld to world
    { name = "reload" }, -- Clear selection
}


function TOOL.BuildCPanel(form)
    local locprefix = "#tool.neoweld."
    local cvarprefix = "neoweld_"

    form:CheckBox(locprefix.."do_weld", cvarprefix.."weld")
    form:CheckBox(locprefix.."do_nocollide", cvarprefix.."nocollide")

    form:NumSlider(locprefix.."select_radius", cvarprefix.."select_radius",
        1, 65565) -- Да, теоритически можно всю карту сварить.    

    form:NumSlider(locprefix.."bound_scale", cvarprefix.."pairgen_bound_extend_factor",
        0.1, 10)
end

if SERVER then
    util.AddNetworkString("stpM64.NeoWeld.Notify")
    function TOOL:Notify(error, msg)
        net.Start("stpM64.NeoWeld.Notify")
            net.WriteBool(error)
            net.WriteString(msg)
        net.Send(self:GetOwner())
    end
else
    function TOOL.Notify(_self, error, msg)
        notification.AddLegacy(msg, error and NOTIFY_ERROR or NOTIFY_GENERIC, 2)
    end

    net.Receive("stpM64.NeoWeld.Notify", function(_, _)
        local error = net.ReadBool()
        local msg = net.ReadString()
        TOOL.Notify(nil, error, msg)
    end)
end

local PROG_BITS = 8
local PROG_MUL = bit.lshift(1, PROG_BITS) - 1

if SERVER then
    util.AddNetworkString("stpm64.NeoWeld.NotifyProgress")
    function TOOL:NotifyProgress(is_applying, progress)
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        net.Start("stpm64.NeoWeld.NotifyProgress", true)
            net.WriteBool(is_applying)
            net.WriteUInt(progress * PROG_MUL, PROG_BITS)
        net.Send(owner)
    end

    function TOOL:NotifyProgressClear()
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        net.Start("stpm64.NeoWeld.NotifyProgress")
            net.WriteBool(true)
            net.WriteUInt(PROG_MUL, PROG_BITS)
        net.Send(owner)
    end
else
    net.Receive("stpM64.NeoWeld.NotifyProgress", function(_, _)
        local is_applying = net.ReadBool()
        local progress = net.ReadUInt(PROG_BITS) / PROG_MUL
        --print("Progress", is_applying, progress)

        local tool = LocalPlayer():GetTool("neoweld")
        if tool == nil then return end
        
        if progress == 1 then 
            tool._progress = nil
            tool._progressStage = nil
        else
            tool._progress = progress
            tool._progressStage = is_applying and "Welding/nocolliding" or "Generating pairs"
        end
    end)

    local CLR_PROG_BG = Color( 255, 255, 255, 150 )
    local CLR_PROG_FG = Color( 0, 255, 0, 255 )
    local CLR_TEXT = Color(255,255,255,255)

    function TOOL:DrawToolScreen()
        local prog = self._progress
        local stage = self._progressStage

        -- Progress bar is stolen from AdvDupe2
        surface.SetDrawColor(32, 32, 32, 255)
        surface.DrawRect(0, 0, 256, 256)

        draw.SimpleText("NeoWeld", "AD2Font", 128, 50, CLR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        if stage == nil then return end



        draw.SimpleText(stage, "AD2TitleFont", 128, 128, CLR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        draw.RoundedBox( 6, 32, 178, 192, 28, CLR_PROG_BG )
        draw.RoundedBox( 6, 34, 180, 188 * prog , 24, CLR_PROG_FG )
    end
end


-- Misc

local function IsWeldableEntity(ent, ply)
    if not IsValid(ent) then return false end

    if ent:IsPlayer() then return false end

    if ent:GetPhysicsObjectCount() ~= 1 then return false end

    if SERVER and not util.IsValidPhysicsObject(ent, 0) then return false end

    if IsValid(ent:GetParent()) then return false end

    if ent.CPPICanTool and not ent:CPPICanTool(ply, "weld") then return false end

    return true
end

-- Interaction

function TOOL:LeftClick(trace)
    if not IsFirstTimePredicted() then return false end

    if not self:GetOwner():KeyDown(IN_USE) then
        return self:Interact_SelectToggle(trace.Entity)
    else
        if not trace.Hit then return false end

        return self:Interact_SelectInRadius(trace.HitPos)
    end
end

function TOOL:RightClick(trace)
    if not IsFirstTimePredicted() then return false end

    return self:Interact_Apply(self:GetOwner():KeyDown(IN_USE))
end

function TOOL:Reload()
    if not IsFirstTimePredicted() then return false end

    return self:Interact_SelectClear()
end

function TOOL:Interact_SelectToggle(ent)
    if not IsWeldableEntity(ent, self:GetOwner()) then return false end
    if CLIENT then return true end

    self:SelectSet(ent, not self:Selected(ent))

    return true
end

local function IsWorldOwnedEntity(ent)
    if not CPPI then return ent:MapCreationID() ~= 0 end

    local owner = ent:CPPIGetOwner()
    return not IsValid(owner) 
end

function TOOL:Interact_SelectInRadius(pos)
    if CLIENT then return true end
    
    local range = self:GetClientNumber("select_radius")

    for _, e in ipairs(ents.FindInSphere(pos, range)) do
        if IsWeldableEntity(e, self:GetOwner()) and not IsWorldOwnedEntity(e) then
            self:SelectSet(e, true)
        end
    end

    return true
end

function TOOL:Interact_SelectClear()
    if CLIENT then return true end

    self:SelectClear()

    return true
end

-- Selection

-- TOOL._selection: table(Entity, true)

local SELECT_COLOR = Color(0, 255, 0, 255)

function TOOL:SelectSet(ent, value)
    --print("SelectSet", ent, value)
    if value then
        self._selection = self._selection or {}
        self._selection[ent] = true
        ent._Neoweld_OldColor = ent:GetColor()
        ent:SetColor(SELECT_COLOR)
    elseif self._selection ~= nil then
        self._selection[ent] = nil
        ent:SetColor(ent._Neoweld_OldColor)
    end
end

function TOOL:Selected(ent)
    return self._selection and self._selection[ent] or false
end

function TOOL:SelectClear()
    for ent, _ in pairs(self._selection or {}) do
        if IsValid(ent) then
            ent:SetColor(ent._Neoweld_OldColor)
        end
    end

    self._selection = nil
end


-- Welding/nocolliding

-- TOOL._actStarted: nil|true

function TOOL:Interact_Apply(to_world)
    if CLIENT then return true end

    local err = self:ApplyValidate(to_world)
    if err ~= true then
        self:Notify(true, err)
        return false
    end
    
    self:ApplyBegin(to_world)

    return true
end

function TOOL:ApplyValidate(to_world)
    local is_weld = self:GetClientBool("weld")
    local is_nocollide = self:GetClientBool("nocollide")
    --print(is_weld, is_nocollide)

    if not is_weld and not is_nocollide then
        return "Select either 'weld' or 'no-collide' or both"
    end

    if not is_weld and is_nocollide and to_world then
        return "No-colliding to world is not supported"
    end

    if self._actStarted then
        return "Already started"
    end

    if self._selection == nil or table.IsEmpty(self._selection) then
        return "No selection"
    end

    return true
end

if SERVER then
    TOOL.ServerConVar = {
        pairgen_act_per_tick = "20",
        pairgen_delay = "0.2",
        apply_act_per_tick = "2",
        apply_delay = "0.5"
    }

    function TOOL:ApplyBegin(to_world)
        self._actStarted = true
        self._actToWorld = to_world
        self._actDoWeld = self:GetClientBool("weld")
        self._actDoNocollide = self:GetClientBool("nocollide")
        self._pairgenExtendFactor = self:GetClientNumber("pairgen_bound_extend_factor")
        if self._pairgenExtendFactor <= 0.1 then
            self._pairgenExtendFactor = 0.1
        end
    
        --print("Pairs start")
        -- Good old callback hell...
        self:GeneratePairsStart(function(epairs)
            --print("Pairs done")
            self:ApplyStart(epairs, function(count)
                --print("Start done")
                self:ApplyFinished()
                self:Notify(false, "Created "..tostring(count).." constraints")
                self:SelectClear()
            end)
        end)
    end

    function TOOL:ApplyFinished()
        self._actStarted = nil
        self:NotifyProgressClear()
    end
    
    -- Pair generation

    function TOOL:GeneratePairsStart(callback)
        local selArray = table.GetKeys(self._selection)

        if self._actToWorld then
            local epairs = {}
            local world = game.GetWorld()
    
            for i, e in ipairs(selArray) do
                epairs[i] = {e, world}
            end
    
            --print("Pairs toWorld")
            callback(epairs)
            return
        end
    
        if #selArray == 1 then
            --print("Pairs single")
            callback({})
            return
        end

        --print("Selections:")
        --PrintTable(selArray)
        self._pairgenSelections = selArray
        self._pairgenCur1 = 1
        self._pairgenCur2 = 2
        self._pairgenResult = {}
        self._pairgenCallback = callback
        self._pairgenTimer = "neoweld_"..self:GetOwner():SteamID().."_pairgen"

        self:GeneratePairsIter()
    end

    function TOOL:GeneratePairsIter()
        --print("Pairs iter")
        local maxsteps = self.ServerConVars.pairgen_act_per_tick:GetInt()
        if maxsteps < 1 then 
            --print(maxstesp)
            self:ApplyFinished()
            return
        end

        for step = 1, maxsteps do
            if self:GeneratePairsStep() then
                self:Notify(false, "Generated weld/no-collide pairs")

                self._pairgenCallback(self._pairgenResult)
                return
            end

        end

        local selCount = #self._pairgenSelections
        local curWork = selCount * self._pairgenCur1 + self._pairgenCur2
        self:NotifyProgress(false, curWork / (selCount * selCount * 2) )

        local delay = self.ServerConVars.pairgen_delay:GetFloat()
        timer.Create(self._pairgenTimer, delay,1, function()
            if not IsValid(self:GetOwner()) then 
                --print("Pairs iter: bad owner")
                self:ApplyFinished()
                return
            end

            self:GeneratePairsIter()
        end)
    end

    function TOOL:GeneratePairsStep()
        local sels = self._pairgenSelections
        local selcnt = #sels

        local i1 = self._pairgenCur1
        local sel1 = sels[i1]
        local i2 = self._pairgenCur2
        local sel2 = sels[i2]

        --print("Pair",i1,i2)

        if self:IsPair(sel1, sel2) then
            table.insert(self._pairgenResult, {sel1, sel2})
        end

        i2 = i2 + 1
        --print(">newi",i1, i2)
        if i2 > selcnt then
            i1 = i1 + 1
            i2 = i1 + 1
            --print(">>",i1, i2)
        end
        if i1 >= selcnt then
            --print(">>finish>", i1, i2)
            return true -- Finished
        end

        self._pairgenCur1 = i1
        self._pairgenCur2 = i2
    end
    
    local function IsValidAllowWorld(ent)
        if ent == nil then return false end
        return ent:IsValid() or ent:IsWorld()
    end


    function TOOL:IsPair(ent1, ent2)
        if not IsValidAllowWorld(ent1) or not IsValidAllowWorld(ent2) then return false end

        local pos1 = ent1:LocalToWorld(ent1:OBBCenter())
        local pos2 = ent2:LocalToWorld(ent2:OBBCenter())

        local distsqr = pos1:DistToSqr(pos2)
        local maxdist = ent1:BoundingRadius() + ent2:BoundingRadius()

        local corrmaxdist = maxdist * self._pairgenExtendFactor

        return distsqr <= corrmaxdist * corrmaxdist

    end

    -- Welding/nocolliding

    function TOOL:ApplyStart(epairs, callback)
        if #epairs == 0 then 
            callback()
            return
        end
        --print("Apply", #epairs)

        self._applyEPairs = epairs
        self._applyCur = 1
        self._applyCallback = callback
        self._applyTimer = "neoweld_"..self:GetOwner():SteamID().."_apply"

        self:ApplyIter()
    end

    function TOOL:ApplyIter()
        --print("Apply iter", self._applyCur)
        local maxcount = TOOL.ServerConVars.apply_act_per_tick:GetInt()
        if maxcount < 1 then
            self:ApplyFinished()
            return
        end

        local firsti = self._applyCur
        local lasti = firsti + maxcount
        for i = firsti, lasti do
            local epair = self._applyEPairs[i]
            --print("Apply iter",i, epair)
            if epair == nil then
                self._applyCallback(#self._applyEPairs)
                return
            end

            self:Apply(epair[1], epair[2])
        end
        self:NotifyProgress(true, lasti / #self._applyEPairs)
        self._applyCur = lasti + 1

        local delay = self.ServerConVars.apply_delay:GetFloat()
        --print("Apply iter: timer start", delay)
        timer.Create(self._applyTimer, delay, 1, function()
            --print("Apply iter: timer")
            if not IsValid(self:GetOwner()) then 
                --print("Apply iter: owner invalid")
                self:ApplyFinished()
                return
            end

            self:ApplyIter()
        end)
    end

    function TOOL:Apply(ent1, ent2)
        if not IsValidAllowWorld(ent1) or not IsValidAllowWorld(ent2) then return end

        local weld = self._actDoWeld
        local nocollide = self._actDoNocollide

        if weld then
            constraint.Weld(ent1, ent2, 0, 0, 
                0, nocollide, false)
        else
            constraint.NoCollide(ent1, ent2, 0, 0)
        end
    end
end

