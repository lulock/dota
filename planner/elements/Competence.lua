--------------------------------------------------------------------------------------
-- NOTE: this class has not been tested yet                                         --
--                                                                                  --
-- this is the Competence class which extends PlanElement                           --
-- an Competence is an aggregate defined by:                                        --
--  . unique name identifier                                                        --
--  . list of desired goals of type Sense                                           --
--  . ordered list of CompetenceElements                                            --
--  . status that is                                                                --
--      . IDLE                                                                      --
--      . RUNNING                                                                   --
--      . SUCCESS                                                                   --
--      . FAILURE                                                                   --
--                                                                                  --
-- tick() checks goals and only:                                                    --
--  . fires competence if any one goal not yet satisfied                            --
--  . returns SUCCESS once all goals satisfied                                      --
--  . returns FAILURE if none of the elements can fire                              --
--                                                                                  --
-- for more on POSH Competences see:                                                --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node11.html                    --
--------------------------------------------------------------------------------------

Competence = Class{__includes = PlanElement}

function Competence:init(name, goals, elements)
    self.name = name --string name
    self.goals = goals --list of sense goals
    self.elements = elements --list of competence elements
    self.status = IDLE
end

-- TODO: CHECK COMPETENCE ELEMENT FUNCTIONALITY
function Competence:tick()
    -- When the goal has been achieved, or if none of the elements can fire, the competence terminates.
    local goalsAchieved = self:checkGoals()

    if goalsAchieved then 
        self:reset()
        return SUCCESS 
    else 
        for _,element in pairs(self.elements) do -- tick all children
            -- print('ticking competence element', element.name, 'with #senses:', #element.senses, 'and child element')
            self.status = element:tick()
            -- print('and competence element returned', self.status)
            if self.status == RUNNING or self.status == SUCCESS then
                return self.status 
            end -- else failure go to next competence element
        end 
    end

    --if none of the elements can fire, the competence terminates
    -- print('none of the elements can fire, the competence terminates', self.name)
    return FAILURE
end

-- TODO: CHECK COMPETENCE ELEMENT FUNCTIONALITY
function Competence:oldtick()
    -- When the goal has been achieved, or if none of the elements can fire, the competence terminates.
    for _,goal in pairs(self.goals) do --check all goals
        -- print('checking goal', goal.name)
        local goalstatus = goal:tick()
        if not goalstatus and self.status == IDLE then
            -- print('not goal, so tick child element', #self.elements)
            for _,element in pairs(self.elements) do -- tick all children
                -- print('ticking competence element', element.name, 'with #senses:', #element.senses, 'and child element')
                self.status = element:tick()
                -- print('and competence returned', self.status)
                if self.status == RUNNING or self.status == SUCCESS then
                    return self.status 
                end
                --continue to next child upon failure
            end 
            --if none of the elements can fire, the competence terminates
            -- print('none of the elements can fire, the competence terminates', self.name)
            return self.status
        end
    end
    -- when the goal has been achieved the competence terminates
    self.status = IDLE -- reset status (why does IDLE matter here?)
    return SUCCESS -- return success, goals achieved
end

function Competence:reset()
    self.status = IDLE
    -- reset element children
    for i, elem in pairs(self.elements) do
        elem:reset()
    end
end

function Competence:checkGoals()
    for _,goal in pairs(self.goals) do --check all goals
        if not goal:tick() then -- if at least one goal not met
            return false
        end
    end -- else all goals met
    return true
end