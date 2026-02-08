--if SAM_LOADED then return end

local sam, command = sam, sam.command

local CAT_GENERIC = "CONRED"
local CAT_ADMIN = "CONRED - Admin"

if CLIENT then
    CreateClientConVar("cr_sam_allowtp", 1, true, true)
end

command.set_category(CAT_GENERIC)
do
    command.new("switchtp")
        :DisallowConsole()
        :SetPermission("switchtp", "user")

        :Help("Включить/отключить телепортацию.")

        :OnExecute(function(ply)
            local value = ply:GetInfoNum("cr_sam_allowtp", 1) == 1 and 0 or 1
            
            ply:ConCommand("cr_sam_allowtp " .. value)

            ply:sam_send_message("Вы {V} телепортацию к себе.", {
                V = value == 1 and "разрешили" or "запретили"
            })
        end)
    :End()

    command.new("leave")
        :DisallowConsole()
        :Aliases("выйти")

        :Help("Выйти с сервера, но этого не надо делать")

        :AddArg("text", {
            default = "Kicked by user.",
            hint = "причина"
        })

        :GetRestArgs()

        :OnExecute(function(ply, reason)
            ply:Kick(reason)
        end)
    :End() 

    command.new("voteclear")
        :SetCategory("Голосование")

        :Help("Начать голосование за очистку карты")

        :OnExecute(function(ply)
            local function callback(_, result)
                if result == "Нет" then
                    sam.player.send_message(nil, "Голосование провалилось, карта не будет очищена")
                    
                    return
                end
    
                timer.Simple( 60, game.CleanUpMap )
            end
            sam.vote.start_vote(ply, callback, "Очистить карту?", nil, "Да", "Нет")
    
            sam.player.send_message(nil, "{A} начал голосование за очистку карты", {
                A = ply
            })
        end)
    :End()
end


command.set_category(CAT_ADMIN)
do
    command.new("keepmap")
        :SetPermission("keepmap", "admin")

        :Help("Отменить смену карты.")

        :OnExecute(function(ply)
            if timer.Exists("SAM.Command.Map") then
                timer.Remove("SAM.Command.Map")
                sam.player.send_message(nil, "{A} отменил смену карты.", {
                    A = ply
                })
            end
        end)
    :End() 

    do
        local cmd_mute, cmd_unmute = command.get_command("mute"), command.get_command("unmute")
        local cmd_gag, cmd_ungag = command.get_command("gag"), command.get_command("ungag")
    
        command.new("shut")
            :SetPermission("shut", "admin")
    
            :Help("Замутить в голосовом и текстовом чате")
    
            :AddArg("player")
            :AddArg("length")
            :AddArg("text", {hint = "причина", optional = true, default = sam.language.get("default_reason")})

            :GetRestArgs()
    
            :OnExecute(function(ply, targets, length, reason)
                cmd_mute.on_execute(ply, targets, length, reason)
                cmd_gag.on_execute(ply, targets, length, reason)
            end)
        :End()
    
        command.new("unshut")
            :SetPermission("shut", "admin")
            
            :Help("Размутить в голосовом и текстовом чате")
    
            :AddArg("player")
    
            :OnExecute(function(ply, targets)
                cmd_unmute.on_execute(ply, targets)
                cmd_ungag.on_execute(ply, targets)
            end)
        :End() 
    end
end