--------------------------------------------------------------------------------------
-- this is the OperA class that interfaces with the planner                         --
--                                                                                  --
--  ------------------------------------------------------------------------------  --
--  --                               OperA (sys2)                               --  --
--  --                 .org requirements + interaction constraints              --  --
--  ------------------------------------------------------------------------------  --
--                 ^   |                                      ^   |                 --
--                 |   v                                      |   v                 --
--  -----------------------------------        -----------------------------------  --
--  --        Behaviour Lib          --        --       Reactive Plannner       --  --
--  --                               -- -----> --                               --  --
--  --                               --        --                               --  --
--  --                               -- <----- --                               --  --
--  --                               --        --                               --  --
--  --                               --        --                               --  --
--  -----------------------------------        -----------------------------------  --
--                                                                                  --
-- buildNorms() constructs norms from a json string                                 --
--                                                                                  --
-- for more on OperA see:                                                           --
--      https://dspace.library.uu.nl/bitstream/handle/1874/890/full.pdf             --
--------------------------------------------------------------------------------------

--  wip

--------------------------------------------------------------------------------------
-- notes                                                                            --
--------------------------------------------------------------------------------------
--
-- opera needs a pointer to the agent's planner so that it can be 
-- 'sanctioned/changed/configured' but also access to the bot's name so that
-- it can check bot's state?? Or should information about bot be limited to only
-- what the planner states. Opera has access to: WORLD state and PLANNER state ... ?
--
-- currently, try to check if it is farming time
-- check if obligation to farm is satisfied
-- if not, sanction.
-- 
-- Drive Collection needs to be extended to include an option to remove and add drives
-- Use table.insert({table_name}, {index}, {value}) to determine order (: 

Opera = Class{ }

function Opera:init(operaFile, planner)
    local operaTable = json.decode(operaFile) -- norms loaded as lua table
    self.norms = self:buildNorms(operaTable, planner)
    self.scenes = self:buildScenes(operaTable)
end

function Opera:update()

end

function Opera:buildNorms(operaTable, planner)
    local norms = {}
    for _, norm in pairs(operaTable.norms) do
        print(norm.name, planner.root.name, norm.behaviour, norm.operator)
        local n = Norm(norm.name, planner, norm.behaviour, norm.operator)
        table.insert(norms, n)
    end
    return norms
end

function Opera:buildScenes(operaTable)
    local scenes = {}
    for _, scene in pairs(operaTable.scenes) do
        print(scene.name, scene.roles, scene.landmarks, scene.results, scene.norms)
        -- local s = Scene(scene.name, scene.roles, scene.landmarks, scene.results, scene.norms)
        -- table.insert(scenes, s)
    end
    return scenes
end