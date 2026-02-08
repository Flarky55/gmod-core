local command = sam.command

-- From EasyChat
local COLOR_LOCAL = Color(120, 210, 255)
local COLOR_GRAY = Color(184, 189, 209)


local send_message
if SERVER then
    send_message = function(ply, msg, local_mode, ...)
        local players = {}
    
        for _, listener in player.Iterator() do
            local can_see = hook.Run("PlayerCanSeePlayersChat", msg, false --[[is_team]], listener, ply, "global", local_mode)
            if can_see then
                players[#players + 1] = listener
            end
        end
    
        sam.player.add_text(players, 
            local_mode and COLOR_LOCAL or COLOR_GRAY, local_mode and "(Локальный) " or "", COLOR_GRAY, ...
        )
    end
end


command.set_category("Role Play")


command.new("me")
    :DisableNotify()

    :Help("Выполинть действие")

    :AddArg("text")

    :GetRestArgs()

    :OnExecuteExtra(function(params, text)
        local ply = params.Player

        send_message(ply, text, params.LocalMode, 
            ply:Name() .. " " .. text
        )
    end)
:End()

command.new("it")
    :DisableNotify()

    :Help("Описать окружение")

    :AddArg("text")

    :GetRestArgs()

    :OnExecuteExtra(function(params, text)
        local ply = params.Player

        send_message(ply, text, params.LocalMode,
            text, COLOR_GRAY, " (", color_white, ply:Name(), COLOR_GRAY, ")"
        )
    end)
:End()

command.new("try")
    :DisableNotify()

    :Help("Выполинть действие с шансом 50/50 на успех")

    :AddArg("text")
    
    :GetRestArgs()

    :OnExecuteExtra(function(params, text)
        local ply = params.Player

        local chance = math.random(0, 100)
        local success = chance > 50

        send_message(ply, text, params.LocalMode,
            ply:Name() .. " " .. text, COLOR_GRAY, " (", success and color_green or color_red, success and "Успешно" or "Неуспешно", COLOR_GRAY, ")"
        )
    end)
:End()

command.new("dice")
    :Aliases("d", "roll")
    :DisableNotify()

    :Help("Бросить кубики")

    :AddArg("number", {
        optional = true,
        default = 20,
        hint = "грани",
        min = 4,
        round = true,
    })

    :AddArg("number", {
        optional = true,
        default = 10,
        hint = "сложность",
        min = 1,
        round = true
    })

    :OnExecuteExtra(function(params, dice, difficult)
        local ply = params.Player
        
        local chance = math.random(0, dice)
        local success = chance >= difficult

        local color_result = success and color_green or color_red
        
        send_message(ply, "", params.LocalMode,
            ply:Name() .. " бросил кубик ", color_white, "d" .. dice, COLOR_GRAY, " со сложностью ", color_white, difficult,
            COLOR_GRAY, ". Выпало: ", color_result, chance,
            COLOR_GRAY, ", это ", color_result, chance == 0 and "полный " or (chance == dice and "абсолютный " or ""), success and "успех" or "провал"
        )
    end)
:End()