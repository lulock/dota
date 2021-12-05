Scene = Class{ }

function Scene:init(name, roles, landmarks, results, rules)
    self.name = name
    self.roles = roles -- multiple roles involved? or only current agent this scene is running on ...
    self.landmarks = landmarks -- sense
    self.results = results -- sense
    self.rules = rules -- Rule object, condition with norm behaviour expectation
    -- self.status = false
end

function Scene:update()
    
    for _, landmark in pairs(self.landmarks) do
        -- check landmark: has the scene begun? This is a world sense
        if not landmark:tick() then
            --print('landmark not sensed. return false')
            return false 
        end
    end

    for _, result in pairs(self.results) do
        -- self:activate() 
        if not result:tick() then -- if result still not met
            for _, rule in pairs(self.rules) do -- check rules
                local norm = rule:tick() -- get norm / expected behaviour
                local legal = norm:validate() -- check if in compliance with norm
                
                if not legal then -- if agent in violation
                    -- impose sanction (e.g. alter plan)
                    print('norm', norm.name, 'will impose SANCTIONS!')
                    -- for now sanction is to switch expected drive and current drive

                    -- TODO: Clean this up
                    -- for i,d in pairs(norm.planner.root.drives) do
                    --     if d.name == norm.behaviour then
                    --         --print('drive is', d.name)
                    --         norm.planner.root:removeDrive(i)
                    --         norm.planner.root:insertDrive(d, 1) -- make drive priority # 1
                    --         -- log role, time of change, and name of new priority drive to console
                    --         print(POSITIONS[GetBot():GetUnitName()], ', ', DotaTime(),', ', d.name) 
                    --         -- these console logs are dumped into a text file by steam. Postprocess file by tokenising on [VScript] and then the rest should be CSV format.
                    --     end
                    -- end

                    --print('planner now looks like')
                    printTable(norm.planner.root.drives)
                    return false -- not sure if false should be returned here
                end
            end
        end -- else continue checking result senses
    end
    -- self:deactivate()    
    --print('scene complete! return true')
    return true
    
end

-- function Scene:activate()
--     if not self.status then
--         self.status = true
--     end
-- end

-- function Scene:deactivate()
--     if self.status then 
--         self.status = false
--     end
-- end

-- function Scene:getStatus()
--     return self.status
-- end