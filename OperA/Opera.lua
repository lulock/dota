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
-- buildNorms() constructs norms from a json string                                  --
--                                                                                  --
-- for more on OperA see:                                                           --
--      https://dspace.library.uu.nl/bitstream/handle/1874/890/full.pdf             --
--------------------------------------------------------------------------------------

--  wip
Opera = Class{ }

function Opera:init(operaFile, planner)
    local operaTable = json.decode(operaFile) -- norms loaded as lua table
    self.norms = self:buildNorms(operaTable, planner)

    -- self.scenes = sceneFile
end

function Opera:update()

end

function Opera:buildNorms(operaTable, planner)
    local norms = {}
    for _, norm in pairs(operaTable.norms) do
        print(norm.name, planner.root.name, norm.behaviour, norm.operator)
        -- local agent = norm.agent -- get bot here. 
        local agent = planner -- pointer to planner here. 
        local n = Norm(norm.name, agent, norm.behaviour, norm.operator)
        table.insert(norms, n)
    end
    return norms
end