--------------------------------------------------------------------------------------
-- this is the Sense class which extends PlanElement                                --
-- a Sense is a primitive that defines a condition and consists of:                 --
--  . unique name identifier                                                        --
--  . a desired world state value                                                   --
--  . a comparator that checks world state against desired value                    --
--  . status that is                                                                --
--      . 'success' (currently just true)                                           --
--      . 'failure' (currently just false)                                          --
--                                                                                  --
-- tick() calls corresponding function in behaviour library (shared by agents)      --
-- and checks world state against desired value to update status (currently ==)     --
--                                                                                  --
-- for more on POSH Plan Components see:                                            --
--      http://www.cs.bath.ac.uk/~jjb/web/posh.html#POSH_Plan_Components            --
--------------------------------------------------------------------------------------

Sense = Class{__includes = PlanElement}

function Sense:init(name, value, comparator)
    self.name = name --name
    self.value = tonumber(value) --value
    self.comparator = comparator --comparator
end

function Sense:tick()
    local val = _G[self.name]() --call function (by name) in the global namespace
    if self.comparator == 'bool' then
        return val == self.value
    else
        print('comparator aint no bool')
        return false
    end
end