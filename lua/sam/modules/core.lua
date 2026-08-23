local ARGUMENT_NICKNAME = { default = "garry :D", hint = "nickname" }


sam.command.remove_command( "pm" )


sam.command.set_category( "C.O.R.E." )

sam.command.new( "build" )
    :Aliases( "билд" )
    :DisallowConsole()
    :Help( "Перейти в режим Build." )

    :OnExecute( function( ply )
        ply:SetGamemode( CORE_GAMEMODE_BUILD )
    end )
:End()

sam.command.new( "pvp" )
    :Aliases( "пвп" )
    :DisallowConsole()
    :Help( "Перейти в режим PvP." )

    :OnExecute( function( ply )
        ply:SetGamemode( CORE_GAMEMODE_PVP )
    end )
:End()

sam.command.new( "nick" )
    :Aliases( "setnick", "name", "setname" )
    :DisallowConsole()
    :Help( "Изменить свой никнейм." )

    :AddArg( "text", ARGUMENT_NICKNAME )
    :GetRestArgs()

    :OnExecute( function( ply, nick )
        ply:SetFakeNick( nick )
    end )
:End()

sam.command.new( "persistentnick" )
    :DisallowConsole()
    :Help(
        "Установить постоянный никнейм.\n" ..
        "Этот никнейм будет отображаться при подключении и автоматически устанавливаться после захода на сервер."
    )

    :AddArg( "text", ARGUMENT_NICKNAME )
    :GetRestArgs()

    :OnExecute( function( ply, nick )
        ply:SetPersistentNick( nick )
        ply:SetFakeNick( nick )
    end )
:End()

sam.command.new( "leave" )
    :DisallowConsole()
    :Help( "Выйти с сервера с кастомной причиной. Но выходить не надо." )

    :AddArg( "text", {
        default = "Kicked by user.",
        hint = "причина"
    } )
    :GetRestArgs()

    :OnExecute( function( ply, reason )
        ply:Kick( reason )
    end )
:End()


sam.command.set_category( "C.O.R.E. Admin" )

sam.command.new( "forcenick" )
    :SetPermission( "forcenick", "admin" )

    :AddArg( "player" )
    :AddArg( "text", ARGUMENT_NICKNAME )
    :GetRestArgs()

    :OnExecute( function( ply, targets, nick )
        for _, target in ipairs( targets ) do
            target:SetFakeNick( nick )
        end
    end )
:End()

sam.command.new( "keepmap" )
    :SetPermission( "keepmap", "admin" )
    :OnExecute( function( ply )
        if not timer.Exists( "SAM.Command.Map" ) then return end

        timer.Remove("SAM.Command.Map")
        sam.player.send_message(nil, "{A} отменил смену карты.", {
            A = ply
        })
    end )
:End()