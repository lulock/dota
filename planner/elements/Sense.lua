--------------------------------------------------------------------------------------
-- this is the Sense class which extends PlanElement                                --
-- a Sense is a primitive that defines a condition and consists of:                 --
--  . unique name identifier                                                        --
--  . a desired world state value                                                   --
--  . a comparator that checks world state against desired value                    --
--  . status that is                                                                --
--      . SUCCESS (currently just true)                                             --
--      . FAILURE (currently just false)                                            --
--                                                                                  --
-- tick() calls corresponding function in behaviour library (shared by agents)      --
-- and checks world state against desired value to update status (currently ==)     --
--                                                                                  --
-- for more on POSH Plan Components see:                                            --
--      http://www.cs.bath.ac.uk/~jjb/web/posh.html#POSH_Plan_Components            --
--------------------------------------------------------------------------------------

Sense = Class{__includes = PlanElement}

function Sense:init(name, value, comparator, arg)
    self.name = name --name
    self.value = tonumber(value) --value
    self.comparator = comparator --comparator
    self.arg = arg --argument
end

function Sense:tick()
    local val = nil
    
    if self.arg ~= nil then
        val = _G[self.name](self.arg) --call function (by name) in the global namespace with argument
    else
        val = _G[self.name]() --call function (by name) in the global namespace with no argument
    end

    if self.comparator == 'bool' then
        return val == self.value
    elseif self.comparator == '<' then
        return val < self.value
    elseif self.comparator == '>' then
        return val > self.value
    else -- unidentified comparator 
        return false
    end
end