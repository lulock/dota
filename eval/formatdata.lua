-- io.open(filename [,mode])

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

writefile = io.open("eval/tempfile.txt", "w")
-- Write content
writefile:write(content)
writefile:close()