-------------------------------------------------------------------------------
//  Underwater ambient sound bugfix
//
//  ValsdalV
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
//  Play the ambient sound when underwater
-------------------------------------------------------------------------------
hook.Add( "InitPostEntity", "UAS_CreateCSoundPatch", function()

   local client = LocalPlayer()

   if !IsValid( client )
   then
      // This should never happen
      ErrorNoHalt( "Invalid local player entity on startup! This is not supposed to happen.\n" )
      return
   end

   local ambientSound = CreateSound( client, "Player.AmbientUnderWater" )

   // GM:OnEntityWaterLevelChanged() can't be hooked clientside, leaving GM:Tick()
   // as the best option since it works in singleplayer, unlike predicted hooks

   hook.Add( "Tick", "UAS_PlayerWaterLevelCheck", function()

      if !client:IsValid()
      then
         // This should also never happen
         return
      end

      if client:WaterLevel() == 3
      then
         // Player is completely submerged, start the ambient sound
         if !ambientSound:IsPlaying()
         then
            ambientSound:Play()
         end

      elseif ambientSound:IsPlaying()
      then
         // Stop the looping sound when exiting water
         ambientSound:Stop()
      end
   end)
end)