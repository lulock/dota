Scene = Class{ }

function Scene:init(name, roles, result, norms)
    self.name = name
    self.roles = roles
    self.result = result -- sense
    self.norms = norms --  new class
    self.status = false 
end

function Scene:activate()
    if not self.status then
        self.status = true
    end
end

function Scene:deactivate()
    if self.status then 
        self.status = false
    end
end

function Scene:getStatus()
    return self.status
end

function Scene:update()
    
    self:activate()

    if not result:tick() then -- if result still not met
        for _, norm in pairs(norms) do -- check agents abiding by norms
            local legal = norm:validate() -- for now this prints norm
            if not legal then -- if agent in violation
                -- impose sanction (e.g. alter plan)
            end
        end
    else -- once result achieved, exit scene
        self:deactivate() 
    end

end