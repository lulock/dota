-- utility funcs --

function loadQvals( qvalueFile )
    local qvals = json.decode(qvalueFile) -- plan loaded as lua table
    return qvals
end