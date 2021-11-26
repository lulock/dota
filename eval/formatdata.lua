-- io.open--io.open(filename [,mode])

-- r	Open file read-only,The file must exist.
-- r+	Open Files Readable and Writable,Other Same
-- w	Open Write-Only File,Content Clear 0,Creation does not exist
-- w+	Read-write mode on,Other as above
-- a	Append Write-Only Mode Open,Create if not present
-- a+	Append Read-Write Mode Open,Other as above
-- b	binary mode,If the file is a binary file
-- +	Indicates that the file can be read or written

-- Open file read-only
local file = io.open("eval/log.txt", "r+")

-- Read the first line
print(file:read())

content = ""
for line in file:lines() do
    -- print(line)
    for sub in (line):gmatch("%[VScript%].*") do 
    -- for w in (line):gsub("%[VScript%].*", 1) do 
        -- print(string.gsub( w, "%[VScript%]", "%0")  )
        sub = (sub:gsub("%[VScript%]%s", ""))
        content = content .. sub .. '\n'
    end
end
-- Close open files
file:close()

writefile = io.open("tempfile.txt", "w")
-- Write content
writefile:write(content)
writefile:close()

-- --Locate file cursor(That is, setting where to read or write data from a file)
-- file:seek(whence, offset)
-- --"set": Start from file header
-- --"cur": Start from the current location[default]
-- --"end": Start at the end of the file
-- --offset:Default 0

-- file:seek()     --Return to current location
-- file:seek("set")    --Locate to File Header
-- file:seek("end")    --Navigate to end of file

-- file:flush()
-- --refresh buffer
-- --Generally for performance reasons, when writing a piece of data to a file, it is not written immediately, but first
-- --Cache to a memory buffer, and then when a condition is met or a display call is made file:flush()time
-- --Will write the buffer's data to the file immediately

-- file:setvbuf(mode[, size])
-- --Set Buffer Mode
-- -- 'no' Direct write without buffer(Not recommended unless in development debugging phase)
-- -- 'full' Full buffer, write immediately only when the buffer is full
-- -- 'line' Line buffer, written immediately when line breaks are encountered
-- -- When displaying calls file:flush()Will write immediately