--------------------------------------------------------------------------------------
-- this is the DriveCollection class which extends PlanElement                      --
-- a DriveCollection is an aggregate defined by:                                    --
--  . unique name identifier                                                        --
--  . ordered list of Drives                                                        --
--  . desired goal                                                                  --
--  . status that is                                                                --
--      . 'idle'                                                                    --
--      . 'running'                                                                 --
--      . 'success'                                                                 --
--      . 'failure'                                                                 --
--                                                                                  --
-- tick() checks goal and only:                                                     --
--  . moves on to next drive if previous drive failed to tick                       --
--  . returns 'success' once goal satisfied                                         --
--  . returns 'failure' if none of the drives can fire                              --
--                                                                                  --
-- for more on POSH DriveCollections see:                                           --
--      http://www.cs.bath.ac.uk/~jjb/web/BOD/AgeS02/node12.html                    --
--------------------------------------------------------------------------------------

DriveCollection = Class{__includes = PlanElement}

function DriveCollection:init(name, drives)
    self.name = name --name
    self.drives = drives --list of drives
    self.goal = false --should be a sense
    self.status = 'idle'
    self.currentDrive = nil -- keep pointer to currently running drive
end

function DriveCollection:tick()
    -- print('current status is', self.status)
    local childStatus = 'idle' --keep track of child state
    if self.goal then --check if goal reached
        return 'success'
    end

    if self.status == 'idle' then --if idle upon tick, update status
        self.status = 'running'
        print('running drive collection', self.status)
    end

    if self.status == 'running' then --if running, execute children in order
        for _,drive in pairs(self.drives) do

            local childStatus = drive:tick() --tick child
            if childStatus == 'running' or childStatus == 'success' then --if running or success, return success this tick
                self.status = 'running'
                if self.currentDrive ~= drive.name then --if not already running
                    self.currentDrive = drive.name --keep track of running drive
                    print('current active drive is ', self.currentDrive)
                end
                return 'running'
            end
            print('child status is', childStatus, 'go to next child!') -- this should always be failure
            
        end --else 'failure', so move on to next child

        --if all children traversed ... something went wrong
        print ('somehow all drives failed. return failure.')
        return 'failure'
    end
end