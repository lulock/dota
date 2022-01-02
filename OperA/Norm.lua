--------------------------------------------------------------------------------------
-- this is the Norm class                                                           --
-- a Norm will:                                                                     --
--  . validate bot behaviour                                                        --
--  . apply sanctions on violated norms                                             --
--                                                                                  --
-- validate() cross-checks bot's active drive with expected behaviour               --
--------------------------------------------------------------------------------------

Norm =  Class{ }

-- should a norm have one agent or MORE? 
-- are these INTERACTION norms? In which case, more. (At least two)

-- ORRRR

-- one agent, each with a 'target agent', in which case, the action must be executed on the agent's target
-- e.g. position 5 has position 1 as target hero to cast healing ability

-- what does opera say about doing a job WELL? so, maybe the agent will execute an action, but fail. is there a sanction? should be.

function Norm:init(name, plan, behaviour, operator)
    self.name = name -- unique name id
    self.plan = plan -- pointer to bot (or rather bot's plan??) 
    self.behaviour = behaviour -- maybe this should be drive ID?
    self.operator = tonumber(operator) -- OBLIGED / PERMITTED / TODO: NOT PERMITTED
end

function Norm:validate()
    local sameDrive =  self.plan.root.currentDriveName == self.behaviour --bool
    print(self.plan, 'is', self.operator, 'to', self.behaviour)
    if (self.operator == OBLIGED and not sameDrive) or ( self.operator == NOTPERMITTED and sameDrive ) then        
        print ('NORM VIOLATION')
        return false
        -- local loc = GetBot():GetLocation()
        -- ping at bot location where norm has been violated!! 
        -- GetBot():ActionImmediate_Ping(loc.x, loc.y, true)
    else -- permitted so doesn't matter, return true
        return true
    end
    
end

-- constrain to expected behaviour and TODO: condition on OPERATOR 
function Norm:sanction()
    -- local prevDrive = self.plan.root.currentDrive
    -- print(self.operator)
    -- print(OBLIGED)
    if self.operator == OBLIGED then
        print("OBLIGED - make drive prio 2 after heal lol")
        local prio = 2
        for i,drive in pairs(self.plan.root.drives) do
            if drive.name == self.behaviour then
                --print('drive is', d.name)
                self.plan.root:removeDrive(i) -- remove the drive
                self.plan.root:insertDrive(drive, prio) -- re-insert drive as priority # 1
                -- log role, time of change, and name of new priority drive to console

                self:log(drive)

                -- these console logs are dumped into a text file by steam. Postprocess file by tokenising on [VScript] and then the rest should be CSV format.
                return i, drive, prio -- return prev index and drive
            end -- TODO: handle if not found
        end
    elseif self.operator == NOTPERMITTED then
        print("NOT PERMITTED - remove drive!")
        for i,drive in pairs(self.plan.root.drives) do
            if drive.name == self.behaviour then
                --print('drive is', d.name)
                self.plan.root:removeDrive(i) -- remove the drive
                -- self.plan.root:insertDrive(drive, 1) -- re-insert drive as priority # 1
                -- log role, time of change, and name of new priority drive to console
                
                self:log(drive)
                
                -- these console logs are dumped into a text file by steam. Postprocess file by tokenising on [VScript] and then the rest should be CSV format.
                return i, drive, nil -- return prev index and drive
            end -- TODO: handle if not found
        end
    elseif self.operator == PERMITTED then
        print("PERMITTED - do nothing if drive is active")
    end


    return nil, nil, nil
end

function Norm:log(drive)
    local nPlayerID =  GetBot():GetPlayerID()
    print(GetBot():GetUnitName(), POSITIONS[GetBot():GetUnitName()], ', ', DotaTime(),', ', drive.name, GetHeroLevel( nPlayerID ), ', ', GetHeroKills( nPlayerID ), ', ', GetHeroDeaths( nPlayerID ), ', ', GetHeroAssists( nPlayerID ) ) 
end

-- restore
function Norm:restore()
    local prevDrive = self.plan.root.currentDrive

    for i,drive in pairs(self.plan.root.drives) do
        if drive.name == self.behaviour then
            --print('drive is', d.name)
            self.plan.root:removeDrive(i) -- remove the drive
            self.plan.root:insertDrive(drive, 1) -- re-insert drive as priority # 1
            -- log role, time of change, and name of new priority drive to console
            print(POSITIONS[GetBot():GetUnitName()], ', ', DotaTime(),', ', drive.name) 
            -- these console logs are dumped into a text file by steam. Postprocess file by tokenising on [VScript] and then the rest should be CSV format.
        end -- TODO: handle if not found
    end
    return prevDrive
end