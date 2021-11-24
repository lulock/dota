----------------------------------------------------------------------------------------------------
-- this is the base class for any plan element in the planner tree.                               --
-- a plan element consists simply of a:                                                           --
--  . unique name identifier                                                                      --
--  . status that is one of:                                                                      --
--      . IDLE                                                                                  --
--      . RUNNING                                                                               --
--      . SUCCESS                                                                               --
--      . FAILURE                                                                               --
--                                                                                                --
-- resources used to help build this planner as a whole:                                          --
--  . http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/AgeS02.html                                    --
--  . https://github.com/RecklessCoding/BOD-UNity-Game                                            --
--  . https://www.gamedeveloper.com/programming/behavior-trees-for-ai-how-they-work               --
--  . https://www.gameaipro.com/GameAIPro/GameAIPro_Chapter06_The_Behavior_Tree_Starter_Kit.pdf   --
--  . and counting...                                                                             --
----------------------------------------------------------------------------------------------------

PlanElement = Class {}

function PlanElement:init(name)
    self.name = name
    self.status = IDLE --instantiated as IDLE, updated on tick()
end

function PlanElement:getName()
    return self.name -- return this node's name
end

-- all elements can be ticked. return value is the status. default status is IDLE.
function PlanElement:tick()
    return self.status
end