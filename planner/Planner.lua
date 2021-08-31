--------------------------------------------------------------------------------------
-- NOTE: this file needs significant refactoring
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

function Planner:getDrives()
    return self.plan["Drives"]
end

function Planner:getDriveElements()
    return self.plan["DriveElements"]
end

function Planner:getCompetences()
    return self.plan["Competences"]
end

function Planner:getCompetenceElements()
    return self.plan["CompetenceElements"]
end

function Planner:getActionPatterns()
    return self.plan["ActionPatterns"]
end

function Planner:buildActionPatterns()
    local actionPatterns = {}
    for _,ap in pairs(self.plan["ActionPatterns"]) do 
        -- print(ap["name"])
        -- print(ap["actions"])
        local actions = {}
        for _,a in pairs(ap["actions"]) do 
            table.insert(actions, Action(a["name"], 0))
            -- actions[a["name"]] = Action(a["name"],0)
        end
        -- table.insert(actionPatterns, ActionPattern(ap["name"], actions))
        actionPatterns[ap["name"]] = ActionPattern(ap["name"], actions)
    end
    return actionPatterns
end

function Planner:buildCompetenceElements(elements)
    local competenceElements = {}
    for _,ce in pairs(self.plan["CompetenceElements"]) do 
        print(ce["name"])
        print(ce["element"])

        local senses = {}
        for _, s in pairs(ce["Senses"]) do
            local sense = Sense(s.name, s.value, s.comparator)
            table.insert(senses, sense)
        end

        competenceElements[ce["name"]] = CompetenceElement(ce["name"], senses, elements[ce["element"].name])
    end
    return competenceElements
end

function Planner:buildCompetence(elements)  
    local competences = {}
    for _,c in pairs(self.plan["Competences"]) do 
        -- print(c["name"])
        -- print(c["goals"])
        local comp_elements = {}
        for _,ce in pairs(c["CompetenceElements"]) do 
            --find name in elements list
            -- print(ce,elements[ce.name])
            table.insert(comp_elements, elements[ce.name])
        end

        local goals = {}
        for _, g in pairs(c["goals"]) do
            local goal = Sense(g.name, g.value, g.comparator)
            table.insert(goals, goal)
        end

        competences[c["name"]] = Competence(c["name"], goals, comp_elements)
    end
    return competences
end

function Planner:buildDrive(elements)  
    local driveElements = {}
    for _,de in pairs(self.plan["DriveElements"]) do 
        print(de["name"])
        print(de["Senses"])
        print(de["element"])
        print('is this the same', de.element.name)

        local senses = {}
        for _, s in pairs(de["Senses"]) do
            local sense = Sense(s.name, s.value, s.comparator)
            table.insert(senses, sense)
        end

        -- driveElements[de["name"]] = Drive(de["name"], senses, triggers[1])
        table.insert(driveElements, Drive(de["name"], senses, elements[de["element"].name))
    end
    return driveElements
end

function Planner:buildDriveCollection(elements)  
    return DriveCollection('life', elements) 
end


function Planner:buildPlanner()  
    local ap = self:buildActionPatterns() --action patterns
    local ce = self:buildCompetenceElements(ap) --competence elements
    local c = self:buildCompetence(ce) --competences

    local elements = {}
    for k,v in pairs(ap) do elements[k] = v end 
    for k,v in pairs(c) do elements[k] = v end 
    -- PrintTable(elements)

    local de = self:buildDrive(elements) --drive elements
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
    p:tickRoot(dc) -- this isn't right. Return values are handled by parent nodes
end