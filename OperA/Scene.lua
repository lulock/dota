Scene = Class{ }

function Scene:init(name, roles, landmarks, results, norms)
    self.name = name
    self.roles = roles -- multiple roles involved? or only current agent this scene is running on ...
    self.landmarks = landmark -- sense
    self.results = results -- sense
    self.norms = norms --  Norm object
    -- self.status = false
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

function Scene:update()
    
    for landmark in pairs(self.landmarks) do
        -- check landmark: has the scene begun? This is a world sense
        if not landmark:tick() then
            print('landmark not sensed. return false')
            return false 
        end
    end

    -- self:activate() 
    if not result:tick() then -- if result still not met
        for _, norm in pairs(norms) do -- check agents abiding by norms
            local legal = norm:validate() -- for now this prints norm
            if not legal then -- if agent in violation
                -- impose sanction (e.g. alter plan)
            end
        end
    else -- once result achieved, exit scene and return true
        -- self:deactivate()
        print('scene complete! return true')
        return true
    end

end