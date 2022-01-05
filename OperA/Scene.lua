Scene = Class{ }

function Scene:init(name, roles, landmarks, results, rules, plan)
    self.name = name
    self.roles = roles -- multiple roles involved? or only current agent this scene is running on ...
    self.landmarks = landmarks -- sense
    self.results = results -- sense
    self.rules = rules -- Rule object, condition with norm behaviour expectation
    self.status = IDLE
    self.previdx = nil
    self.prevDrive = nil
    self.curridx = nil
    self.plan = plan
end

function Scene:update() -- should a scene exit be determined by landmark?? 
    
    if self.status == IDLE then

        -- check landmarks for scene start
        for _, landmark in pairs(self.landmarks) do
            if not landmark:tick() then
                return false -- return
            end
        end 
        
        -- all landmarks sensed, set status to running
        self.status = RUNNING
    end
        -- print('scene running, check rules')

    if self.status == RUNNING then
        
        -- check results for scene ende
        local complete = self:checkResults()

        if complete then 
            return self:reset()
        else
            return self:checkRules()
        end

    end

    return false
    
end

function Scene:OldUpdate() -- should a scene exit be determined by landmark?? 
    
    if self.status == IDLE then
        for _, landmark in pairs(self.landmarks) do
            -- has the scene begun? This is a world sense
            if not landmark:tick() then
                --print('landmark not sensed. return false')
                return false 
            end
        end -- all landmarks sensed, set status to running.

        self.status = RUNNING
        -- print('scene running, check rules')
        self:checkRules()
        return true

    elseif self.status == RUNNING then -- wrong because the behaviour can change mid-scene!!! Always check norm in compliance or not.
        
        local complete = self:checkResults()

        if not complete then 
            self:checkRules()
        end

        return true
    end

    return false
    
end

function Scene:checkRules()

    for _, rule in pairs(self.rules) do -- check rules
        local norm = rule:tick() -- get norm / expected behaviour
        local legal = norm:validate() -- check if in compliance with norm

        if not legal then -- if agent in violation
            -- print('norm', norm.name, 'will impose SANCTIONS!')

            self.previdx, self.prevDrive, self.curridx = norm:sanction()
            print("NEW PLAN", GetBot():GetUnitName())
            printTable(self.plan.root.drives)

        end
    end

    return true

end

function Scene:checkResults()

    for _, result in pairs(self.results) do
        if not result:tick() then -- if result still not met, return
            return false
        end
    end -- all results met
    
    return true
end

function Scene:reset()
    
    -- reset --
    if self.curridx ~= nil then self.plan.root:removeDrive(self.curridx) end -- remove the drive
    if self.prevDrive ~= nil and self.previdx ~= nil then self.plan.root:insertDrive(self.prevDrive, self.previdx ) end -- re-insert drive in previous prio
    
    self.prevDrive = nil 
    self.previdx = nil 
    self.curridx = nil  
    self.status = IDLE 
    
    print('scene complete, reset to idle')
    printTable(self.plan.root.drives)
    return true

end

function Scene:OldUpdate()
    
    for _, landmark in pairs(self.landmarks) do
        -- check landmark: has the scene begun? This is a world sense
        if not landmark:tick() then
            --print('landmark not sensed. return false')
            return false 
        end
    end

    -- WAIT THIS IS NOT RIGHT
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
                    self.prevPlan = deepcopy(norm.plan)
                    norm:sanction()

                    print('plan now looks like')
                    printTable(norm.plan.root.drives)
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

function Scene:sanction()
    for i,d in pairs(norm.plan.root.drives) do
        if d.name == norm.behaviour then
            --print('drive is', d.name)
            norm.plan.root:removeDrive(i) -- remove the drive
            norm.plan.root:insertDrive(d, 1) -- re-insert drive as priority # 1
            -- log role, time of change, and name of new priority drive to console
            print(POSITIONS[GetBot():GetUnitName()], ', ', DotaTime(),', ', d.name) 
            -- these console logs are dumped into a text file by steam. Postprocess file by tokenising on [VScript] and then the rest should be CSV format.
        end -- TODO: handle if not found
    end
end

-- helper funciton: http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function copy1(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copy1(k)] = copy1(v) end
    return res
end