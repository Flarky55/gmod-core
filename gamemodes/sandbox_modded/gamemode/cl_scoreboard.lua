local META_PLAYER = FindMetaTable( "Player" )

local GetGamemode = META_PLAYER.GetGamemode

local SimpleText = draw.SimpleText
local Scale = vgui.Scale

local FONT_ServerName   = vgui.CreateFont( "scoreboard.ServerName", "Comfortaa", 72 )
local FONT_Comfortaa24  = vgui.CreateFont( "Comfortaa24", "Comfortaa", 24 )
local FONT_Comfortaa18  = vgui.CreateFont( "Comfortaa18", "Comfortaa", 18 )

local PATH_ICON_MUTED   = "icon32/muted.png"
local PATH_ICON_UNMUTED = "icon32/unmuted.png"


local Names = {
    "", "NLS - NameLessServer", "?¿?¿?", "я люблю оладушки!", "Привет!", "My Garry's Mod Server", "Flarky's Mod", "Тайлер исчез.", "распространение плывтауна. распространите", "MANKIND IS DEAD.", "HELL IS FULL.", "BLOOD IS FUEL.",
    "C.O.R.E.", "Наф-наф здесь больше не живёт", "REDCON"
}

local Links = {
    {
        Name = "#core.scoreboard.links.addons",
        DoClick = function()
            steamworks.ViewFile( "3489704871" )
        end,
        Enabled = false,
    },
    {
        Name = "#core.scoreboard.links.github",
        URL = "https://github.com/Flarky55/gmod-core",
    }
}

local Info = {
    {
        Name = "#core.scoreboard.info.map",
        GetValue = game.GetMap
    },
    {
        Name = "#core.scoreboard.info.players",
        GetValue = function()
            return player.GetCount() .. "/" .. game.MaxPlayers()
        end,
        UpdateTime = 5,
    },
    {
        Name = "#core.scoreboard.info.uptime",
        GetValue = function()
            return os.date( "!%X", CurTime() )
        end,
        UpdateTime = 1,
    },
    {
        Name    = "#core.scoreboard.info.tps",
        Tooltip = "#core.scoreboard.info.tps.tip",
        GetValue = function()
            return math.Round( 1 / engine.ServerFrameTime() )
        end,
        UpdateTime = 0.33,
    },
    {
        Name    = "#core.scoreboard.info.entities",
        Tooltip = "#core.scoreboard.info.entities.tip",
        GetValue = ents.GetCount,
        UpdateTime = 5,
    },
}

local News = {
    {
        Name = "я схожу с ума",
        Author = "Flarky",
        Text = "я схожу с ума\nlorem ipsum dolor sit amet.",
    },
    {
        Name = "FRAUD TOMORROW",
        Author = "Flarky Prime",
        Text = "Fraud ещё не вышел, а может вышел. Это пока ещё не динамическая новость."
    },
    {
        Name = "ВНИМАНИЕ! РОЗЫСК!",
        Author = "[ДАННЫЕ УДАЛЕНЫ]",
        Text = "Разыскивается ВОР АРБРУЗОВ!\nПриметы:\n - чёрный.\n - ворует арбрузы.\nПросьба любую информацию сообщать местным властям!"
    }
}

local PlayerValues = {
    {
        Name = "#core.scoreboard.player.nick",
        GetValue = META_PLAYER.Nick,
        DockMargin = { 4, 0, 0, 0 },
        Width = 1/2,
    },
    {
        Name = "#core.scoreboard.player.gamemode",
        GetValue = function( ply ) return GetGamemode( ply ).Name end,
        Width = 1/4,
    },
    {
        Name = "#core.scoreboard.player.ping",
        GetValue = META_PLAYER.Ping,
        Width = 1/4,
    },
}

local PlayerProperties = {
    {
        Name = "#core.scoreboard.player.nick",
        GetValue = META_PLAYER.EngineNick
    },
    {
        Name = "SteamID",
        GetValue = META_PLAYER.SteamID
    },
    {
        Name = "SteamID64",
        GetValue = META_PLAYER.SteamID64
    },
}


local function SetupPlayerValue( panel, entry )
    local DockMargin = entry.DockMargin

    if DockMargin then
        panel:DockMargin( unpack( DockMargin ) )
    end

    panel._PlayerValueEntry = entry
end

local function LayoutPlayerValuePanels( panel, w, h )
    local pl, pt, pr, pb = panel:GetDockPadding()
    local width = w - ( pl + pr )

    for i = 1, panel:ChildCount() do
        local panel = panel:GetChild( i-1 )
        local entry = panel._PlayerValueEntry

        if entry ~= nil then
            panel:SetWide( width * entry.Width )
        end
    end
end


--[[
        Player Properties
--]]
local PLAYER_PROPERTIES = {
    Init = function( self )
        self:Dock( TOP )
        self:DockPadding( 2, 2, 2, 2 )

        local container = self:Add( "Panel" )
        container:Dock( TOP )
        do
            for _, entry in ipairs( PlayerProperties ) do

            end
        end
    end,

    Setup = function( self, ply )

    end,
}

vgui.RegisterTable( PLAYER_PROPERTIES, "DPanel" )


--[[
        Player Line (Valid Entity) 
--]]
local PLAYER_LINE = {
    Init = function( self )
        self:Dock( TOP )
        self:SetTall( Scale(32) )
        self:DockPadding( 1, 1, 1, 1 )


        local avatar = self:Add( "AvatarImage" )
        avatar:Dock( LEFT )
        avatar:SetMouseInputEnabled( false )
        self.m_pAvatar = avatar

        
        local container = self:Add( "Panel" )
        container:Dock( FILL )
        container:SetMouseInputEnabled( false )
        container.PerformLayout = function( s, w, h )
            LayoutPlayerValuePanels( s, w, h )
        end
        self.m_pPlayerValuesContainer = container
        do
            for i, entry in ipairs( PlayerValues ) do
                local label = container:Add( "DLabel" )
                label:Dock( LEFT )
                label:SetDark( true )
                label:SetFont( FONT_Comfortaa24 )
                SetupPlayerValue( label, entry )
            end
        end

        
        local mute = self:Add( "DCheckBox" )
        mute:Dock( RIGHT )
        mute.Paint = nil
        mute.PaintOver = function( s )

        end
        mute.OnMouseWheeled = function( s, delta )

        end
        mute.OnChange = function( s, bValue )
            self.Player:SetMuted( bValue )

            s:Update()
        end
        mute.Update = function( s )
            local image = s.m_pImage

            image:SetImage( s:GetChecked() and PATH_ICON_MUTED or PATH_ICON_UNMUTED )
        end
        self.m_pMute = mute
        do
            local image = mute:Add( "DImage" )
            image:Dock( FILL )
            mute.m_pImage = image
        end
    end,

    PerformLayout = function( self, w, h )
        self.m_pAvatar:SetWide( h )
        self.m_pMute:SetWide( h )
    end,

    Paint = function( self, w, h )
        -- TODO: make this as Panel:Method
        surface.SetAlphaMultiplier( 0.8 )
        DButton.Paint( self, w, h )
        surface.SetAlphaMultiplier( 1 )
    end,

    DoClick = function( self )
        self.Player:ShowProfile()
    end,

    Setup = function( self, ply )
        self.Player = ply

        self.m_pAvatar:SetPlayer( ply )

        self.m_pMute:SetChecked( ply:IsMuted() )
        self.m_pMute:Update()

        -- self:Update()
    end,

    Update = function( self )
        local ply = self.Player
        if not IsValid( ply ) then 
            self:Remove() 
            return
        end

        local container = self.m_pPlayerValuesContainer
        for i = 1, container:ChildCount() do
            local panel = container:GetChild( i-1 )
            local entry = panel._PlayerValueEntry

            if entry ~= nil then
                panel:SetText( entry.GetValue( ply ) )
            end
        end
    end,
}

vgui.RegisterTable( PLAYER_LINE, "DCheckBox" )


--[[
        Player Line (Connecting)
--]]
local PLAYER_LINE_CONNECTING = {
    Init = function( self )
        self:SetTall( Scale(32) )
        self:SetText( "" )
    end,

    Paint = function( self, w, h )
        surface.SetAlphaMultiplier( 0.8 )
        DButton.Paint( self, w, h )
        surface.SetAlphaMultiplier( 1 )
    end,
    
    Setup = function( self, data )

    end,
}

vgui.RegisterTable( PLAYER_LINE_CONNECTING, "DButton" )


--[[
        Scoreboard
--]]
local SCORE_BOARD = {
    Init = function( self )
        self:Dock( FILL )
        self:MakePopup()


        local container = self:Add( "Panel" )
        container:Dock( TOP )
        container:SetTall( Scale(120) )
        container.Paint = function( s, w, h )
            -- TODO: nice fade-out fade-in
            SimpleText( s._text, FONT_ServerName, w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        container.Think = function( s )
            if s._NextThink and s._NextThink > CurTime() then return end
            s._NextThink = CurTime() + 6

            s._text = table.RandomSeq( Names )
        end


        local container = self:Add( "Panel" )
        container:Dock( LEFT )
        container:DockPadding( 4, 0, 4, 0 )
        container:SetWide( Scale(360) )
        do
            for _, entry in ipairs( Info ) do
                local GetValue, UpdateTime = entry.GetValue, entry.UpdateTime

                local button = container:Add( "DPanel" )
                button:Dock( TOP )
                button:DockPadding( 4, 0, 4, 0 )
                button:DockMargin( 0, 0, 0, 4 )
                button:SetTall( Scale(32) )
                button:SetText( "" )
                button:SetTooltip( entry.Tooltip )
                button.Paint = function( s, w, h )
                    surface.SetAlphaMultiplier( 0.8 )
                    DPanel.Paint( s, w, h )
                    surface.SetAlphaMultiplier( 1 )
                end
                do
                    local lblTitle = button:Add( "DLabel" )
                    lblTitle:Dock( LEFT )
                    lblTitle:SetDark( true )
                    lblTitle:SetFont( FONT_Comfortaa24 )
                    lblTitle:SetText( entry.Name )
                    lblTitle:SizeToContents()
                    
                    local lblValue = button:Add( "DLabel" )
                    lblValue:Dock( RIGHT )
                    lblValue:SetDark( true )
                    lblValue:SetFont( FONT_Comfortaa24 )
                    lblValue:SetText( GetValue() )
                    lblValue:SizeToContents()

                    if UpdateTime then
                        local nextThink = 0
                        
                        lblValue.Think = function( s )
                            if nextThink > CurTime() then return end
                            nextThink = CurTime() + UpdateTime

                            s:SetText( GetValue() )
                            s:SizeToContentsX() -- resize only on X axis, otherwise text will start jumping
                        end
                    end
                end
            end
        end


        local container = self:Add( "Panel" )
        container:Dock( RIGHT )
        container:DockPadding( 4, 0, 4, 0 )
        container:SetWide( Scale(360) )
        container.PerformLayout = function( s )
            for _, p in ipairs( s:GetChildren() ) do
                p:SizeToChildren( nil, true )
            end
        end
        do
            for _, entry in ipairs( News ) do
                local button = container:Add( "DPanel" )
                button:Dock( TOP )
                button:DockPadding( 4, 4, 4, 4 )
                button:DockMargin( 0, 0, 0, 4 )
                button:SetText( "" )
                button.Paint = function( s, w, h )
                    surface.SetAlphaMultiplier( 0.8 )
                    DPanel.Paint( s, w, h )
                    surface.SetAlphaMultiplier( 1 )
                end
                do
                    local lblTitle = button:Add( "DLabel" )
                    lblTitle:Dock( TOP )
                    lblTitle:SetDark( true )
                    lblTitle:SetFont( FONT_Comfortaa24 )
                    lblTitle:SetText( entry.Name )
                    lblTitle:SizeToContents()

                    local lblAuthor = button:Add( "DLabel" )
                    lblAuthor:Dock( TOP )
                    lblAuthor:SetDark( true )
                    lblAuthor:SetFont( FONT_Comfortaa18 )
                    lblAuthor:SetText( entry.Author )
                    lblAuthor:SizeToContents()

                    local lblValue = button:Add( "DLabel" )
                    lblValue:Dock( TOP )
                    lblValue:DockMargin( 0, 6, 0, 0 )
                    lblValue:SetDark( true )
                    lblValue:SetAutoStretchVertical( true )
                    lblValue:SetWrap( true )
                    lblValue:SetFont( FONT_Comfortaa18 )
                    lblValue:SetText( entry.Text )
                end
            end
        end
        

        local container = self:Add( "DPanel" )
        container:Dock( TOP )
        container:DockPadding( Scale(32), 0, Scale(32), 0 )
        container:SetTall( Scale(30) )
        container.PerformLayout = function( s, w, h )
            LayoutPlayerValuePanels( s, w, h )
        end
        do
            for _, entry in ipairs( PlayerValues ) do
                local label = container:Add( "DLabel" )
                label:Dock( LEFT )
                label:SetDark( true )
                label:SetFont( FONT_Comfortaa18 )
                label:SetText( entry.Name )
                SetupPlayerValue( label, entry )
            end
        end


        local scrollpanel = self:Add( "DScrollPanel" )
        scrollpanel:Dock( FILL )
        self.m_pPlayerList = scrollpanel


        local container = self:Add( "Panel" )
        container:Dock( BOTTOM )
        container.PerformLayout = function( s, w, h )
            local canvas = s._Canvas
            canvas:SizeToChildren( true, true )
            canvas:Center()
        end
        self.m_pLinksContainer = container
        do
            local canvas = container:Add( "Panel" )
            canvas:DockPadding( 0, 0, 0, 4 )
            container._Canvas = canvas

            for _, entry in ipairs( Links ) do
                local button = canvas:Add( "DButton" )
                button:Dock( LEFT )
                button:DockMargin( 0, 0, 4, 0 )
                button:SetFont( FONT_Comfortaa24 )
                button:SetText( entry.Name )
                button:SetEnabled( entry.Enabled == nil or entry.Enabled )
                button:SizeToContentsX( 2 )
                button:SizeToContentsY()
                button.DoClick = entry.DoClick or function()
                    gui.OpenURL( entry.URL )
                end
            end
        end
    end,

    PerformLayout = function( self, w, h )
        self.m_pLinksContainer:SizeToChildren( nil, true )
    end,

    Think = function( self )
        if self._NextThink and self._NextThink > CurTime() then return end
        self._NextThink = CurTime() + 5 

        local scrollpanel_cv = self.m_pPlayerList:GetCanvas()
        
        for i = 1, scrollpanel_cv:ChildCount() do
            local panel = scrollpanel_cv:GetChild( i-1 )
            
            panel:Update()
        end        
    end,

    Update = function( self )
        local scrollpanel = self.m_pPlayerList
        scrollpanel:Clear()

        for _, ply in player.Iterator() do
            local p = vgui.CreateFromTable( PLAYER_LINE, scrollpanel )
            p:Setup( ply )
            p:Update()
        end
    end,
}

vgui.RegisterTable( SCORE_BOARD, "Panel" )


--[[---------------------------------------------------------
    Name: gamemode:ScoreboardShow( )
    Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

    if ( !IsValid( g_Scoreboard ) ) then
        g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
    end

    if ( IsValid( g_Scoreboard ) ) then
        g_Scoreboard:Show()
        g_Scoreboard:Update()
        g_Scoreboard:SetKeyboardInputEnabled( false )
    end

end

--[[---------------------------------------------------------
    Name: gamemode:ScoreboardHide( )
    Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

    if ( IsValid( g_Scoreboard ) ) then
        g_Scoreboard:Hide()
    end

end


local function Reload()
    if IsValid( g_Scoreboard ) then 
        g_Scoreboard:Remove()
    end
end

concommand.Add( "scoreboard_reload", Reload )

hook.Add( "DermaSkinChanged", "core.scoreboard", Reload )