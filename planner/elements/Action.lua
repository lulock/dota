--------------------------------------------------------------------------------------
-- this is the Action class which extends PlanElement                               --
-- an Action is a primitive defined by:                                             --
--  . unique name identifier                                                        --
--  . assigned time to complete (currently not implemented)                         --
--  . status that is                                                                --
--      . IDLE                                                                      --
--      . RUNNING                                                                   --
--      . SUCCESS                                                                   --
--      . FAILURE                                                                   --
--                                                                                  --
-- tick() calls corresponding function in behaviour library (shared by agents)      --
--                                                                                  --
-- for more on POSH Plan Components see:                                            --
--      http://www.cs.bath.ac.uk/~jjb/web/posh.html#POSH_Plan_Components            --
--------------------------------------------------------------------------------------

Action = Class{__includes = PlanElement}
-- require ( GetScriptDirectory().."/planner/BehaviourLib" )


function Action:init(name, timeToComplete)
    self.name = name --string name
    self.timeToComplete = timeToComplete --double
    self.status = IDLE
end

function Action:tick()
    --print('ticking action', self.name)
    self.status = _G[self.name](self.status)
    return self.status
end

function Action:reset()
    self.status = IDLE
end

-- OLD TICK -- 
-- function Action:tick()
--     --print('ticking action', self.name)
--     self.status = _G[self.name]() --execute command called (by name) in the global namespace
--     return self.status --return success, running, or failure
-- end