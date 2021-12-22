--------------------------------------------------------------------------------------
-- this is the ActionPattern class which extends PlanElement                        --
-- an ActionPattern is an aggregate defined by:                                     --
--  . unique name identifier                                                        --
--  . list of actions in an ordered sequence                                        --
--  . status that is                                                                --
--      . IDLE                                                                    --
--      . RUNNING                                                                 --
--      . SUCCESS                                                                 --
--      . FAILURE                                                                 --
--                                                                                  --
-- tick() steps through the sequence in order, ticks each action and only:          --
--  . moves on to next action when prev action returns SUCCESS                    --
--  . returns SUCCESS once all actions return SUCCESS                           --
--                                                                                  --
-- for more on POSH Action Patterns see:                                            --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node10.html                    --
--------------------------------------------------------------------------------------

ActionPattern = Class{__includes = PlanElement}

function ActionPattern:init(name, actions)
    self.name = name --string name
    self.actions = actions --list of actions
    self.status = IDLE
    -- self.index = 1
end

function ActionPattern:tick()

    for _,action in pairs(self.actions) do
    
        local childStatus = action:tick() -- tick child
        if childStatus == FAILURE then -- action failed, return 
            self:resetChildren()
            self.status = IDLE -- reset status
            return FAILURE
        elseif childStatus == RUNNING then
            return RUNNING
        end
        -- on success, continue to next child
    end
    self.status = IDLE
    self:resetChildren()
    return SUCCESS
end

function ActionPattern:reset()
    self.status = IDLE
    -- reset element child
    self:resetChildren()

end

function ActionPattern:resetChildren()
    for _,action in pairs(self.actions) do
        action:reset()
    end
end

function ActionPattern:oldtick()
    --print('ticking action pattern', self.name, 'with', #self.actions, 'actions and index is', self.index)
    if self.index > #self.actions then --all child actions executed with success
        self.index = 1 -- reset index
        --print('returning AP success and resetting index to', self.index)
        return SUCCESS
    else --otherwise, tick through children
    
        local childStatus = IDLE
        --print('ticking AP child', self.actions[self.index].name)
        childStatus = self.actions[self.index]:tick() --tick child at current index
        if childStatus == SUCCESS then --increment index to next child when current child returns success
            self.index = self.index + 1
            --print(self.actions[self.index].name 'returned success and incremented index to', self.index)
            --status remains running
        elseif childStatus == RUNNING then
            --print(self.actions[self.index].name 'returned running and index remains', self.index)
            return childStatus
            --index remains on current child
        elseif childStatus == FAILURE then
            self.index = 1 -- reset index
            --print(self.actions[self.index].name 'returned failure and reset index to', self.index)
            return FAILURE
        end
    end
end