--------------------------------------------------------------------------------------
-- this is the Norm class                                                           --
-- a Norm will:                                                                     --
--  . validate bot behaviour                                                        --
--  . apply sanctions on violated norms                                             --
--                                                                                  --
-- validate() cross-checks bot's active drive with expected behaviour               --
--------------------------------------------------------------------------------------

Norm =  Class{ }

-- should a norm have one agent or MORE? 
-- are these INTERACTION norms? In which case, more. (At least two)

-- ORRRR

-- one agent, each with a 'target agent', in which case, the action must be executed on the agent's target
-- e.g. position 5 has position 1 as target hero to cast healing ability

-- what does opera say about doing a job WELL? so, maybe the agent will execute an action, but fail. is there a sanction? should be.

function Norm:init(name, planner, behaviour, operator)
    self.name = name -- unique name id
    self.planner = planner -- pointer to bot (or rather bot's plan??) 
    self.behaviour = behaviour -- maybe this should be drive ID?
    self.operator = operator -- OBLIGED / PERMITTED / TODO: NOT PERMITTED
end

function Norm:validate()
    --print(self.planner, 'is', self.operator, 'to', self.behaviour)

    if self.planner.root.currentDriveName ~= self.behaviour then
        --print ('NORM VIOLATION')

        -- ping at bot location where norm has been violated!! 
        local loc = GetBot():GetLocation()
        -- GetBot():ActionImmediate_Ping(loc.x, loc.y, true)
        --print ('Current behaviour set to:', self.planner.root.currentDriveName,'but it should be ', self.behaviour)
        return false
    else
        --print ('behaviour approved')
        --print ('Current behaviour set to:', self.planner.root.currentDriveName,'which aligns with ', self.behaviour)
        return true
    end
    -- maybe this should check obligation / permission against agent's active drive?
end