local map = game.GetMap()

local Restrictions = {
    -- ["votemap"] = {
    --     Check = function(self, ply)
    --         if map == "gm_construct" or ply:IsAdmin() then return end

    --         if self._NextCommand ~= nil and self._NextCommand > CurTime() then
    --             return false,
    --                 "Следующее голосование можно запустить через {V_Time}",
    --                 {V_Time = sam.format_length( (self._NextCommand - CurTime()) / 60 )}
    --         end

    --         return self._NextChange < CurTime(),
    --             "Вы сможете сменить карту через {V_Time}",
    --             {V_Time = sam.format_length( (self._NextChange - CurTime()) / 60 )}
    --     end,

    --     _NextChange = CurTime() + 60 * 60 -- 1h
    -- },
    -- ["voteclear"] = {
    --     Check = function(self, ply)
    --         if ply:IsAdmin() then return end

    --         if self._NextCommand ~= nil and self._NextCommand > CurTime() then
    --             return false,
    --                 "Следующее голосования можно запустить через {V_Time}",
    --                 {V_Time = sam.format_length( (self._NextCommand - CurTime()) / 60 )}
    --         end
    --     end,
    -- },

    ["goto"] = {
        Check = function(self, ply, _, _, _, result)
            if ply:IsAdmin() then return end
            
            if not ply:IsInGamemode( CORE_GAMEMODE_BUILD ) then
                return false,
                    "Телепортация разрешена только в режиме Build!"
            end

            local targets = result[1]
            local target = targets[1]

            if target:GetInfoNum("cr_sam_allowtp", 1) == 0 then
                return false,
                    "{T} отключил телепортацию",
                    {T = targets}
            end
        end,
    }
}


hook.Add("SAM.CanRunCommand:ParsedArguments", "SAM.CONRED.Restrictions", function(ply, cmd_name, args, cmd, result)
    if sam.isconsole(ply) then return end

    local restriction = Restrictions[cmd.name]
    if restriction == nil then return end


    local can_run, message, content = restriction:Check(ply, cmd_name, args, cmd, result)

    if can_run == false then
        if message ~= nil then
            ply:sam_send_message(message, content) 
        end

        return false
    end
end)


do
    -- local cooldown = {
    --     ["votemap"] = 60 * 5, -- 5m
    --     ["voteclear"] = 60 * 30, -- 30m
    -- }
    
    -- hook.Add("SAM.RanCommand", "SAM.CONRED.Restrictions", function(_, _, _, cmd)
    --     local cmd_name = cmd.name
        
    --     local time = cooldown[cmd_name]
    --     if time == nil then return end
        
    --     Restrictions[cmd_name]._NextCommand = CurTime() + time
    -- end) 
end