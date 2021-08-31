--------------------------------------------------------------------------------------
-- NOTE: this file needs significant refactoring                                    --
--                                                                                  -- 
-- this is the Planner class                                                        --
-- a Planner will:                                                                  --
--  . read a plan from a json string                                                --
--                                                                                  -- 
-- buildPlanner() constructs the plan from the primitives to the root               --
--------------------------------------------------------------------------------------

Planner = Class{}

-- input: json plan file
function Planner:init(planFile)
    -- self.planFile = planFile --json plan file
    self.plan = readPlanFile(planFile)
    self.elements = {}
    -- self.planTree = test()
end

function readPlanFile(file)
    -- read plan file
    -- local f = assert(io.open(file, "rb")) --try to open file
    -- local content = f:read("*all") --read content as json string
    -- f:close() --close file
    plan = json.decode(file) --decode json string into table
    return plan --return table
end

function Planner:buildActionPatterns()
    for _,ap in pairs(self.plan.ActionPatterns) do 
        -- print(ap["name"])
        -- print(ap["actions"])
        local actions = {}
        for _,a in pairs(ap.actions) do 
            if not self.elements[a.name] then
                table.insert(actions, Action(a.name, 0)) -- construct new action
            end
            -- actions[a["name"]] = Action(a["name"],0)
        end
        -- table.insert(actionPatterns, ActionPattern(ap["name"], actions))
        self.elements[ap.name] = ActionPattern(ap.name, actions)
    end
end

function Planner:buildCompetence()  
    for _,c in pairs(self.plan.Competences) do 

        -- start by building goals
        local goals = {}
        for _, g in pairs(c.goals) do
            if not self.elements[g.name] then
                table.insert(goals, Sense(g.name, g.value, g.comparator)) -- construct new sense
            end
        end

        -- next build competence elements
        local comp_elements = {}
        for _,ce in pairs(c.elements) do
            if not self.elements[ce.name] then -- check if ce exists already
                local senses = {}
                for _,s in pairs(ce.Senses) do
                    if not self.elements[s.name] then
                        table.insert(senses, Sense(s.name, s.value, s.comparator)) -- construct new sense
                    end
                end
                table.insert(comp_elements, CompetenceElement(ce.name, senses, self.elements[ce.element])) -- construct new sense
            else
                table.insert(comp_elements, self.elements[ce.name])
            end
        end

        self.elements[c.name] = Competence(c.name, goals, comp_elements)
    end
end


function Planner:buildDrive()  
    PrintTable(self.plan)
    local driveElements = {}
    for _,de in pairs(self.plan.DriveElements) do 
        print(de.name)
        print(de.Senses)
        print(de.element)

        local senses = {}
        for _, s in pairs(de.Senses) do
            local sense = Sense(s.name, s.value, s.comparator)
            print(s.name, s.value, s.comparator)
            table.insert(senses, sense)
        end

        -- driveElements[de["name"]] = Drive(de["name"], senses, triggers[1])
        table.insert(driveElements, Drive(de.name, senses, self.elements[de.element.name]))
    end
    return driveElements
end

function Planner:buildDriveCollection(elements)  
    return DriveCollection('life', elements) 
end


function Planner:buildPlanner()  
    self:buildActionPatterns() --action patterns
    self:buildCompetence() --competences
    -- local newC = self:buildCompetenceNew(ap) --competence + competence elements

    local de = self:buildDrive() --drive elements
    local dc = self:buildDriveCollection(de) --drives
    
    -- PrintTable(dc)

    return dc
end

function Planner:tickRoot(dc)  
    dc:tick()
end

--- helper functions ---

function Set (list) --use a set for easier search
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function PrintTable (t)
    for k,v in pairs(t) do print (k,v.name) end
end

function newPrint (t, count)
    prefix = string.rep("-", count)
    if type(t) == 'table' then
        for k,v in pairs(t) do
            print(prefix,k)
            newPrint(v, count+1)
        end
    else
        print (prefix, t) 
    end
end

function test(file)
    local p = Planner(file)
    dc = p:buildPlanner()
    -- p:tickRoot(dc) -- this isn't right. Return values are handled by parent nodes
end