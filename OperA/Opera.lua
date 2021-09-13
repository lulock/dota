--------------------------------------------------------------------------------------
-- this is the OperA class that interfaces with the planner                         --
-- a scene is:                                                                      --
--  .                                                                               --
--                                                                                  --
-- for more on OperA see:                                                           --
--      https://dspace.library.uu.nl/bitstream/handle/1874/890/full.pdf             --
--------------------------------------------------------------------------------------

Opera = Class{ }

function Opera:init()
    self.scenes = {
        ['farmingScene'] = false,
        ['healingScene'] = false,
        ['fightingScene'] = false,
        ['roshanScene'] = false
    }
end

function Opera:activateScene(scene)
    if self.scenes[scene] == false then 
        self.scenes[scene] = true
        _G[self.name]() --call function (by name) in the global namespace
    end
end

function Opera:deactivateScene(scene)
    if self.scenes[scene] == true then 
        self.scenes[scene] = false
    end
end

function Opera:update()
    -- if it is time to farm, you betta be farming
    if DotaTime() < 10 * 60 then --(laning phase) 
        self.activateScene('farmingScene')
    else
        self.deactivateScene('farmingScene')
    end

end