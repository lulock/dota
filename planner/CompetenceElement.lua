--------------------------------------------------------------------------------------
-- NOTE: this class has not been tested yet                                         --
--                                                                                  --
-- this is the CompetenceElement class which extends PlanElement                    --
-- an Competence is an aggregate defined by:                                        --
--  . unique name identifier                                                        --
--  . list of Senses that trigger an Action, ActionPattern, or Competence           --
--  . trigger THAT NEEDS RENAMING TO SOMETHING MORE APPROPRIATELY DESCRIPTIVE       --
--                                                                                  --
-- tick() checks Senses and only:                                                   --
--  . ticks element if all senses are satisfied                                     --
-- for more on POSH Competences see:                                                --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node11.html                    --
--------------------------------------------------------------------------------------

CompetenceElement = Class{__includes = PlanElement}

function CompetenceElement:init(name, trigger, senses)
    self.name = name --string name
    self.senses = senses --list of senses
    self.trigger = trigger --should probably be renamed to element or something
end

function CompetenceElement:tick()
    for _,sense in pairs(self.senses) do --check all conditions
        if not sense:tick() then
            return 'failure'
        end
    end

    return self.trigger:tick() --tick trigger element only if all conditions satisfied
end