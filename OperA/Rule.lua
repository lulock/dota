--------------------------------------------------------------------------------------
-- this is the Rule class                                                           --
-- a Rule specifies:                                                                --
--  . a condition (IF) corresponding to a sense                                     --
--  . a consequence (THEN) corresponding to a behaviour/drive                       --
--  . an alternative (ELSE) corresponding to a behaviour/drive                      --
--                                                                                  --
--------------------------------------------------------------------------------------

Rule =  Class{ }

-- condition: Sense
-- consequence: Norm 
-- alternative: Norm
function Rule:init(conditions, consequence, alternative)
    self.conditions = conditions -- Sense (IF)
    self.consequence = consequence -- Norm (THEN)
    self.alternative = alternative -- Norm (ELSE)
end

function Rule:tick()
    for _, condition in pairs(self.conditions) do
        print('if ', condition.name)
        if not condition:tick() then
            -- print('as per norm, the expected behaviour is ', self.alternative.name)
            return self.alternative -- conditions not true, return alt norm behaviour
        end
    end
    
    -- print('as per norm, the expected behaviour is ', self.consequence.name)
    return self.consequence -- all conditions true, return consequence norm behaviour
end