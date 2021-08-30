--------------------------------------------------------------------------------------
-- NOTE: this class may need revisit to debug/refactor                              --
--                                                                                  --
-- this is the Drive class which extends PlanElement                                --
-- a Drive is an aggregate defined by:                                              --
--  . list of Sense conditions that determine whether the Drive fires               --
--  . element (that can be an Action, ActionPattern or Competence)                  --
--  . status that is                                                                --
--      . 'idle'                                                                    --
--      . 'running'                                                                 --
--      . 'success'                                                                 --
--      . 'failure'                                                                 --
--                                                                                  --
-- tick() steps through the Senses and only:                                        --
--  . ticks drive if all Sense conditions are satisfied                             --
--  . returns status of child PlanElement                                           --
--                                                                                  --
-- for more on POSH Drives see:                                                     --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node12.html                    --
--------------------------------------------------------------------------------------

Drive = Class{__includes = PlanElement}

function Drive:init(name, senses, element)
    self.name = name
    self.senses = senses
    self.element = element
    self.status = 'idle'
end

function Drive:tick()

    for _,sense in pairs(self.senses) do --check sense conditions
        print('checking sense.', sense.name)
        local senseStatus = sense:tick()
        print('senseStatus is:', senseStatus)
        if not senseStatus then
            return 'failure'
        end
    end
    print('ticking element.', self.element.name)
    self.status = self.element:tick() --only trigger if all sense conditions satisfied
    print('and returned.', self.status)
    return self.status
end