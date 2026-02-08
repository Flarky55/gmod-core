local ARGUMENT_NICKNAME = { default = "garry :D", hint = "nickname" }


sam.command.set_category( "C.O.R.E." )

sam.command.new( "build" )
    :Help( "Перейти в режим Build." )
    :OnExecute( function( ply )
        ply:SetGamemode( CORE_GAMEMODE_BUILD )
    end )
:End()

sam.command.new( "pvp" )
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
    :OnExecute( function( ply, nick )
        ply:SetPersistentNick( nick )
        ply:SetFakeNick( nick )
    end )
:End()


sam.command.set_category( "C.O.R.E. Admin" )

sam.command.new( "forcenick" )
    :SetPermission( "forcenick", "admin" )

    :AddArg( "player" )
    :AddArg( "text", ARGUMENT_NICKNAME )

    :OnExecute( function( ply, targets, nick )
        for _, target in ipairs( targets ) do
            ply:SetFakeNick( nick )
        end
    end )
:End()