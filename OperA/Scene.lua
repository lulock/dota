Scene = Class{ }

function Scene:init(name, roles, landmarks, results, norms)
    self.name = name
    self.roles = roles -- multiple roles involved? or only current agent this scene is running on ...
    self.landmarks = landmarks -- sense
    self.results = results -- sense
    self.norms = norms --  Norm object. has pointer to this agent's planner
    -- self.status = false
end

function Scene:update()
    
    for _, landmark in pairs(self.landmarks) do
        -- check landmark: has the scene begun? This is a world sense
        if not landmark:tick() then
            print('landmark not sensed. return false')
            return false 
        end
    end

    for _, result in pairs(self.results) do
        -- self:activate() 
        if not result:tick() then -- if result still not met
            for _, norm in pairs(self.norms) do -- check agents abiding by norms
                local legal = norm:validate() -- for now this prints norm
                if not legal then -- if agent in violation
                    -- impose sanction (e.g. alter plan)
                    print('norm', norm.name, 'will impose SANCTIONS!')
                    -- for now sanction is to switch expected drive and current drive

                    -- THIS IS UGLY AND NEEDS TO BE CHANGED
                    for i,d in pairs(norm.planner.root.drives) do
                        if d.name == norm.behaviour then
                            print('drive is', d.name)
                            norm.planner.root:removeDrive(i)
                            norm.planner.root:insertDrive(d, 1)
                        end
                    end

                    print('planner now looks like')
                    PrintTable(norm.planner.root.drives)
                    return false -- not sure if false should be returned here
                end
            end
        end -- else continue checking result senses
    end
    -- self:deactivate()
    -- THIS IS UGLY AND NEEDS TO BE CHANGED
    
    print('planner now looks like')
    PrintTable(norm.planner.root)
    print('scene complete! return true')
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