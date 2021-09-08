--------------------------------------------------------------------------------------
-- NOTE: this class has not been tested yet                                         --
--                                                                                  --
-- this is the Competence class which extends PlanElement                           --
-- an Competence is an aggregate defined by:                                        --
--  . unique name identifier                                                        --
--  . list of desired goals of type Sense                                           --
--  . ordered list of CompetenceElements                                            --
--  . status that is                                                                --
--      . 'idle'                                                                    --
--      . 'running'                                                                 --
--      . 'success'                                                                 --
--      . 'failure'                                                                 --
--                                                                                  --
-- tick() checks goals and only:                                                    --
--  . fires competence if any one goal not yet satisfied                            --
--  . returns 'success' once all goals satisfied                                    --
--  . returns 'failure' if none of the elements can fire                            --
--                                                                                  --
-- for more on POSH Competences see:                                                --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node11.html                    --
--------------------------------------------------------------------------------------

Competence = Class{__includes = PlanElement}

function Competence:init(name, goals, elements)
    self.name = name --string name
    self.goals = goals --list of sense goals
    self.elements = elements --list of competence elements
    self.status = 'idle'
end

function Competence:tick()
    --When the goal has been achieved, or if none of the elements can fire, the competence terminates.
    for _,goal in pairs(self.goals) do --check all goals
        print('checking goal', goal.name)
        local goalstatus = goal:tick()
        print('gaol status is', goalstatus)
        if not goalstatus then
            print('not goal, so tick child element', #self.elements)
            for _,element in pairs(self.elements) do --tick all children
                print('ticking competence element', element.name, 'with #senses:', #element.senses, 'and child element')
                self.status = element:tick()
                print('and competence returned', self.status)
                if self.status == 'running' or self.status == 'success' then
                    return self.status 
                end
                --continue to next child upon failure
            end 
            --if none of the elements can fire, the competence terminates
            print('none of the elements can fire, the competence terminates', self.name)
            return self.status
        end
    end
    print('returning competence success', self.name)
    self.status = 'success'
    return self.status --when the goal has been achieved the competence terminates

end