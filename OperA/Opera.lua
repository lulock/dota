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
-- opera needs a pointer to the agent's plan so that it can be 
-- 'sanctioned/changed/configured' but also access to the bot's name so that
-- it can check bot's state?? Or should information about bot be limited to only
-- what the plane states. Opera has access to: WORLD state and PLAN state ... ?
--
-- currently, try to check if it is farming time
-- check if obligation to farm is satisfied
-- if not, sanction.
-- 
-- Drive Collection needs to be extended to include an option to remove and add drives
-- Use table.insert({table_name}, {index}, {value}) to determine order (: 

Opera = Class{ }

function Opera:init(operaFile, plan)
    local operaTable = json.decode(operaFile) -- norms loaded as lua table
    -- some OMs ... TODO: there is repetition below. consider refactor!!
    self.norms = self:buildNorms(operaTable, plan)
    self.scenes = self:buildScenes(operaTable, plan)
    self.currentScenes = {}

    -- TODO: refactor and create a load/reload function.
    self.normFileName = "/OperA/IM/scenes/testx"
    self.roleNormFile = reload ( self.normFileName ) -- json string

    local roleNormTable = json.decode(self.roleNormFile)
    self.roleNorms = self:buildNorms(roleNormTable, plan)

    -- SM
    self.units = nil 

end

function reload(module)
    if package.loaded[GetScriptDirectory() .. module] ~= nil then    
        package.loaded[GetScriptDirectory() .. module] = nil
    end
    return require( GetScriptDirectory() .. module ) 
end

function Opera:reloadNorms()
    -- reload incase changes made to role norms in-game
    self.roleNormFile = reload(self.normFileName)
    local roleNormTable = json.decode(self.roleNormFile)
    self.roleNorms = self:buildNorms(roleNormTable, plan) 
end

function Opera:update()
    --print('there are ', #self.scenes, 'scenes in this opera model')

    for _,scene in pairs(self.scenes) do
        --print('scene', scene.name)
        local s = scene:update()
    end

    self:reloadNorms()

    for _,roleNorm in pairs(self.roleNorms) do
        -- print("ROLE NORM FOR", GetBot():GetUnitName(), "IS" )
        -- for i,v in pairs(roleNorm) do
        --     print(i,v)
        -- end
    end

end

function Opera:buildNorms(operaTable, plan)
    local norms = {}
    for _, norm in pairs(operaTable.norms) do
        local n = Norm(norm.name, plan, norm.behaviour, norm.operator)
        norms[norm.name] = n
    end
    return norms
end

function Opera:buildScenes(operaTable, plan)
    local scenes = {}
    for _, scene in pairs(operaTable.scenes) do
        -- print('building scene', scene.name, scene.roles, scene.landmarks, scene.results, scene.norms)
        
        local landmarks = {}
        for _, l in pairs(scene.landmarks) do
            table.insert(landmarks, Sense(l.name, l.value, l.comparator, l.arg))
        end

        local results = {}
        for _, res in pairs(scene.results) do
            table.insert(results, Sense(res.name, res.value, res.comparator, res.arg))
        end

        local rules = {}
        for _, r in pairs(scene.rules) do
            -- construct conditional
            local conditions = {}
            for _, cond in pairs(r.conditions) do
                table.insert(conditions, Sense(cond.name, cond.value, cond.comparator, cond.arg))
            end
            
            local rule = Rule(conditions, self.norms[r.consequence], self.norms[r.alternative])
            table.insert(rules, rule)
        end

        local s = Scene(scene.name, scene.roles, landmarks, results, rules, plan)
        --print('scene just created is ', s.name)
        table.insert(scenes, s)
    end
    return scenes
end

---- OLD BUILD SCENES ----

-- function Opera:buildScenes(operaTable)
--     local scenes = {}
--     for _, scene in pairs(operaTable.scenes) do
--         --print('building scene', scene.name, scene.roles, scene.landmarks, scene.results, scene.norms)
        
--         local landmarks = {}
--         for _, l in pairs(scene.landmarks) do
--             table.insert(landmarks, Sense(l.name, l.value, l.comparator))
--         end

--         local results = {}
--         for _, r in pairs(scene.results) do
--             table.insert(results, Sense(r.name, r.value, r.comparator))
--         end

--         local norms = {}
--         for _, n in pairs(scene.norms) do
--             table.insert(norms, self.norms[n.name])
--         end

--         local s = Scene(scene.name, scene.roles, landmarks, results, norms)
--         --print('scene just created is ', s.name)
--         table.insert(scenes, s)
--     end
--     return scenes
-- end