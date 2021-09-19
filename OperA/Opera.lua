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
    self.currentScenes = {}
end

function Opera:update()
    print('there are ', #self.scenes, 'scenes in this opera model')

    for _,scene in pairs(self.scenes) do
        print('scene', scene.name)
        local s = scene:update()
    end
end

function Opera:buildNorms(operaTable, planner)
    local norms = {}
    for _, norm in pairs(operaTable.norms) do
        print(norm.name, planner.root.name, norm.behaviour, norm.operator)
        local n = Norm(norm.name, planner, norm.behaviour, norm.operator)
        norms[norm.name] = n
    end
    return norms
end

function Opera:buildScenes(operaTable)
    local scenes = {}
    for _, scene in pairs(operaTable.scenes) do
        print('building scene', scene.name, scene.roles, scene.landmarks, scene.results, scene.norms)
        
        local landmarks = {}
        for _, l in pairs(scene.landmarks) do
            table.insert(landmarks, Sense(l.name, l.value, l.comparator))
        end

        local results = {}
        for _, r in pairs(scene.results) do
            table.insert(results, Sense(r.name, r.value, r.comparator))
        end

        local norms = {}
        for _, n in pairs(scene.norms) do
            table.insert(norms, self.norms[n.name])
        end

        local s = Scene(scene.name, scene.roles, landmarks, results, norms)
        print('scene just created is ', s.name)
        table.insert(scenes, s)
    end
    return scenes
end