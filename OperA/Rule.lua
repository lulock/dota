--------------------------------------------------------------------------------------
-- this is the Rule class                                                           --
-- a Rule specifies:                                                                --
--  . a condition (IF) corresponding to a sense                                     --
--  . a consequence (THEN) corresponding to a behaviour/drive                       --
--  . an alternative (ELSE) corresponding to a behaviour/drive                      --
--                                                                                  --
--------------------------------------------------------------------------------------

Rule =  Class{ }

function Rule:init(name, planner, condition, consequence, alternative)
    self.name = name -- unique name id
    self.planner = planner -- pointer to bot (or rather bot's plan??) 
    self.condition = condition -- Sense (IF)
    self.consequence = consequence -- Drive (THEN)
    self.alternative = alternative -- Drive (ELSE)
end

function Rule:validate()
    -- should the rule validate the norm? OR the norm validate itself?
    
    print('if ', self.condition.name)
    if self.condition:tick() then
        print('as per norm, the expected behaviour is ', self.consequence.name)
    else
        print('as per norm, the expected behaviour is ', self.alternative.name)
    end
end