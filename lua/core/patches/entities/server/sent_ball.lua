return function( tbl )
    tbl.Use = function( self, activator )
        self:Remove()

        if activator:IsPlayer() then
            activator:SendLua( "achievements.EatBall()" )
            activator:Kill()
        end
    end
end