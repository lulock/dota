--------------------------------------------------------------------------------------
-- this is the ActionPattern class which extends PlanElement                        --
-- an ActionPattern is an aggregate defined by:                                     --
--  . unique name identifier                                                        --
--  . list of actions in an ordered sequence                                        --
--  . status that is                                                                --
--      . 'idle'                                                                    --
--      . 'running'                                                                 --
--      . 'success'                                                                 --
--      . 'failure'                                                                 --
--                                                                                  --
-- tick() steps through the sequence in order, ticks each action and only:          --
--  . moves on to next action when prev action returns 'success'                    --
--  . returns 'success' once all actions return 'success'                           --
--                                                                                  --
-- for more on POSH Action Patterns see:                                            --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node10.html                    --
--------------------------------------------------------------------------------------

ActionPattern = Class{__includes = PlanElement}

function ActionPattern:init(name, actions)
    self.name = name --string name
    self.actions = actions --list of actions
    self.status = 'idle'
    -- self.index = 1
end

function ActionPattern:tick()
    for _,action in pairs(self.actions) do
        self.status = action:tick() --tick child
        if self.status == 'failure' or self.status =='running' then
            break
        end    
        --continue
    end
    -- return 'success' --return running, failure, or success
    return self.status --return running, failure, or success
end

function ActionPattern:oldtick()
    --print('ticking action pattern', self.name, 'with', #self.actions, 'actions and index is', self.index)
    if self.index > #self.actions then --all child actions executed with success
        self.index = 1 -- reset index
        --print('returning AP success and resetting index to', self.index)
        return 'success'
    else --otherwise, tick through children
    
        local childStatus = 'idle'
        --print('ticking AP child', self.actions[self.index].name)
        childStatus = self.actions[self.index]:tick() --tick child at current index
        if childStatus == 'success' then --increment index to next child when current child returns success
            self.index = self.index + 1
            --print(self.actions[self.index].name 'returned success and incremented index to', self.index)
            --status remains running
        elseif childStatus == 'running' then
            --print(self.actions[self.index].name 'returned running and index remains', self.index)
            return childStatus
            --index remains on current child
        elseif childStatus == 'failure' then
            self.index = 1 -- reset index
            --print(self.actions[self.index].name 'returned failure and reset index to', self.index)
            return 'failure'
        end
    end
end