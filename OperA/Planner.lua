--------------------------------------------------------------------------------------
-- this is the Norm class                                                        --
-- a Planner will:                                                                  --
--  . read a plan from a json string                                                --
--                                                                                  -- 
-- buildPlanner() constructs the plan from the primitives to the root               --
--------------------------------------------------------------------------------------

Planner = Class{}

-- input: json string
function Planner:init(planFile)
    self.plan = json.decode(planFile) -- plan loaded as lua table
    self.elements = {} -- list of currently constructed plan elements
    self.root = self:buildPlanner()
end

-- builds Action Patterns and stores in self.elements
function Planner:buildActionPatterns()
    for _,ap in pairs(self.plan.ActionPatterns) do 
        -- print(ap["name"])
        -- print(ap["actions"])
        local actions = {}
        for _,a in pairs(ap.actions) do 
            table.insert(actions, Action(a.name, 0)) -- construct actions and add to action pattern sequence
        end
        self.elements[ap.name] = ActionPattern(ap.name, actions) -- add action pattern to current list of plan elements
    end
end

-- builds Competences and stores in self.elements
function Planner:buildCompetence()  
    for _,c in pairs(self.plan.Competences) do 

        -- start by building new goals (which are Senses)
        local goals = {}
        for _, g in pairs(c.goals) do
            table.insert(goals, Sense(g.name, g.value, g.comparator)) -- construct new sense
        end

        -- next build competence elements
        local comp_elements = {}
        for _,ce in pairs(c.elements) do
            if not self.elements[ce.name] then -- check if competence element exists already
                local senses = {}
                for _,s in pairs(ce.Senses) do
                    table.insert(senses, Sense(s.name, s.value, s.comparator)) -- construct new sense
                end
                table.insert(comp_elements, CompetenceElement(ce.name, senses, self.elements[ce.element])) -- construct new competence element
            else
                table.insert(comp_elements, self.elements[ce.name]) -- reuse existing competence element
            end
        end
        self.elements[c.name] = Competence(c.name, goals, comp_elements) -- add competence to current list of plan elements
    end
end

-- builds Drives and returns list in order
function Planner:buildDriveCollection()  
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
    return DriveCollection('life', driveElements) 
end

function Planner:buildPlanner()  
    self:buildActionPatterns()
    self:buildCompetence()
    return self:buildDriveCollection()
end

function Planner:tickRoot()  
    self.root:tick()
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