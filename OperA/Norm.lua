Norm =  Class{ }

-- should a norm have one agent or MORE? 
-- are these INTERACTION norms? In which case, more. (At least two)

-- ORRRR

-- one agent, each with a 'target agent', in which case, the action must be executed on the agent's target
-- e.g. position 5 has position 1 as target hero to cast healing ability

-- what does opera say about doing a job WELL? so, maybe the agent will execute an action, but fail. is there a sanction? should be.

function Norm:init(name, agent, behaviour, operator)
    self.name = name -- unique name id
    self.agent = agent -- pointer to bot 
    self.behaviour = behaviour -- maybe this should be drive ID?
    self.operator = operator -- OBLIGED / PERMITTED
end

function Norm:validate()
    print(self.agent, 'is', self.operator, 'to', self.behaviour)
    -- maybe this should check obligation / permission against agent's active drive?
end