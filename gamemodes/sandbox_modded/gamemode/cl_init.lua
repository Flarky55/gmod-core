include( "shared.lua" )

local PaintManual = FindMetaTable( "Panel" ).PaintManual
local Health = FindMetaTable( "Entity" ).Health
local Armor = FindMetaTable( "Player" ).Armor

local Scale = vgui.Scale
local IsValid = IsValid

local lply = LocalPlayer()


local HUD = {
    Init = function( self )
        self:Dock( FILL )
        self:DockPadding( 4, 4, 4, 4 )
        self:SetPaintedManually( true )

        local container = self:Add( "Panel" )
        container:Dock( BOTTOM )
        container:SetTall( Scale(72) )
        do
            local panel = container:Add( "DPanel" )
            panel:Dock( LEFT )
            panel:DockMargin( 0, 0, 4, 0 )
            panel:SetPaintBackgroundEnabled( true )
            panel:SetWide( Scale(128) )
            panel.Paint = function( s, w, h )
                surface.SetAlphaMultiplier( 0.3 )
                DPanel.Paint( s, w, h )
                surface.SetAlphaMultiplier( 1 )
            end
            self.m_pHealth = panel

            local panel = container:Add( "DPanel" )
            panel:Dock( LEFT )
            panel:SetWide( Scale(128) )
            panel.Paint = function( s, w, h )
                surface.SetAlphaMultiplier( 0.3 )
                DPanel.Paint( s, w, h )
                surface.SetAlphaMultiplier( 1 )
            end
            self.m_pArmor = panel
        end
    end,

    Think = function( self )
        if not IsValid( lply ) then return end

        do
            local panel = self.m_pArmor
            local value = Armor( lply )

            local visible = value > 0

            if visible ~= panel:IsVisible() then
                panel:SetVisible( visible )
            end
        end
    end,
}

vgui.RegisterTable( HUD, "Panel" )


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawTargetID( )
   Desc: Draw the target id (the name of the player you're currently looking at)
-----------------------------------------------------------]]
-- (?) draw here entity info panel
function GM:HUDDrawTargetID()
    return false
end

local DISABLED = {
    -- ["CHudHealth"]  = false,    -- Health
    -- ["CHudBattery"] = false,    -- Armor
}

--[[---------------------------------------------------------
    Name: gamemode:HUDShouldDraw( name )
    Desc: return true if we should draw the named element
-----------------------------------------------------------]]
function GM:HUDShouldDraw( name )

    -- Allow the weapon to override this
    local ply = LocalPlayer()
    if ( IsValid( ply ) ) then

        local wep = ply:GetActiveWeapon()

        if ( IsValid( wep ) ) then

            local fShouldDraw = wep.HUDShouldDraw

            if ( isfunction( fShouldDraw ) ) then

                local ret = fShouldDraw( wep, name )
                if ( ret != nil ) then return ret end

            end

        end

    end

    return DISABLED[name] ~= false

end

--[[---------------------------------------------------------
    Name: gamemode:HUDPaint()
    Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
-- TODO: super duper cool 3D wow effect
-- function GM:HUDPaint()

--     -- hook.Run( "HUDDrawTargetID" )
--     hook.Run( "HUDDrawPickupHistory" )
--     hook.Run( "DrawDeathNotice", 0.85, 0.04 )

--     if not IsValid( g_HUD ) then
--         g_HUD = vgui.CreateFromTable( HUD )
--     end

--     if IsValid( g_HUD ) then
--         PaintManual( g_HUD )
--     end

-- end

-- concommand.Add( "hud_reload", function()
--     if IsValid( g_HUD ) then
--         g_HUD:Remove()
--     end
-- end )

-- hook.Add( "DermaSkinChanged", "Scoreboard", function()
--     RunConsoleCommand( "hud_reload" )
-- end )