--------------------------------------------------------------------------------------
-- this is the DriveCollection class which extends PlanElement                      --
-- a DriveCollection is an aggregate defined by:                                    --
--  . unique name identifier                                                        --
--  . ordered list of Drives                                                        --
--  . desired goal                                                                  --
--  . status that is                                                                --
--      . IDLE                                                                    --
--      . RUNNING                                                                 --
--      . SUCCESS                                                                 --
--      . FAILURE                                                                 --
--                                                                                  --
-- tick() checks goal and only:                                                     --
--  . moves on to next drive if previous drive failed to tick                       --
--  . returns SUCCESS once goal satisfied                                         --
--  . returns FAILURE if none of the drives can fire                              --
--                                                                                  --
-- for more on POSH DriveCollections see:                                           --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node12.html                    --
--------------------------------------------------------------------------------------

DriveCollection = Class{__includes = PlanElement}

function DriveCollection:init(name, drives)
    self.name = name --name
    self.drives = drives --list of drives
    self.goal = false --should be a sense
    self.status = IDLE
    self.currentDrive = nil -- keep pointer to currently running drive index
    self.currentDriveName = nil -- keep pointer to currently running drive name
end

function DriveCollection:tick()
    -- --print('current status is', self.status)
    local childStatus = IDLE --keep track of child state
    if self.goal then --check if goal reached
        return SUCCESS
    end

    if self.status == IDLE then --if idle upon tick, update status
        self.status = RUNNING
        --print('running drive collection', self.status)
    end

    if self.status == RUNNING then --if running, execute children in order
        for i,drive in pairs(self.drives) do

            local childStatus = drive:tick() --tick child
            if childStatus == RUNNING or childStatus == SUCCESS then --if running or success, return success this tick
                self.status = RUNNING
                if self.currentDriveName ~= drive.name then --if not already running
                    print('SWITCHING DRIVES CLEAR ACTIONS', GetBot():GetUnitName())
                    self:reset()
                    self.currentDrive = i --keep track of running drive index (in case of removal later) MAYBE THIS SHOULD BE A POINTER TO DRIVE ITSELFFFF
                    self.currentDriveName = drive.name --keep track of running drive name
                    _G["clearActions"]() -- MAYBE ALSO RESET ALL NODES?
                end
                return RUNNING
            end
            --print('child status is', childStatus, 'go to next child!') -- this should always be failure. But we do not want to move to next drive if prev drive fails, rather we want to move to next drive if SENSES from prev drive fails?
            
        end --else FAILURE, so move on to next child

        --if all children traversed ... something went wrong
        --print ('somehow all drives failed. return failure.')
        return FAILURE
    end
end

function DriveCollection:removeDrive(index)
    -- remove from DC table
    table.remove(self.drives, index)
end

-- this function inserts a drive into the existing drive collection
-- this can either take a json description of the drive, and build it in-method, then append
-- OR take a pre-built drive object and insert it directly. 
function DriveCollection:insertDrive(drive, index)
    -- insert into DC table at specified index
    table.insert(self.drives, index, drive)
end

function DriveCollection:reset()
    -- reset all nodes up to running node
    if self.currentDrive ~= nil then
        for idx = 1, self.currentDrive do
            self.drives[idx]:reset()
        end
    end

end