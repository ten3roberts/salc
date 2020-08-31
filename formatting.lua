function format(fmt, ...)
    local args = {...}
    local args_offset = 1
    local t = {}
    local offset = 1
    while true do  
        local next_fmt = string.find(fmt, "{}", offset)
        if next_fmt == nil then break end
        -- Insert part before next {}
        table.insert(t, string.sub(fmt, offset, next_fmt-1))
        local arg = args[args_offset]
        if type(arg) == "table" then arg = table_tostring(arg) end
        if arg == nil then arg = "nil" end

        table.insert(t, arg)
        args_offset = args_offset + 1
        offset = next_fmt + 2
    end
    table.insert(t, fmt:sub(offset))
    return table.concat(t)
end

function println(fmt, ...) 
    io.write(format(fmt, ...)) 
    io.write("\n") 
end

function table_tostring(t) 
    local result = {" {"}
    for k,v in pairs(t) do
        if #result > 1 then table.insert(result, ",\t") end
        table.insert(result, string.format("\"%s\":\t \"%s\"", k, v))
    end
    table.insert(result, " }")
    return table.concat(result)
end
