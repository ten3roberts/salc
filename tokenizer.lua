function tokenize_char(ty, value, str, offset) 
    local sub = str:sub(offset, offset)
    if sub == value then return {ty=ty, value=value}, 1 else return nil end
end

-- Defines a token
function tokenize_pattern(ty, pattern, str, offset) 
    local i,j = str:find("^"..pattern, offset)
    if i and j then return {ty=ty,value=str:sub(i,j)},j-i+1 else return nil end
end

function tokenize_whitespace(str, offset) 
    local i,j  = str:find("^%s", offset)
    if i and j then return nil,j-i+1 else return nil end
end

-- Tokenizes a string with passed table of tokenizers
function tokenize(tokenizers, str) 
    local offset = 1
    local t = {}
    while offset <= #str do 
        -- Try all tokenizers until one works or err
        local success = false
        for i, tokenizer in ipairs(tokenizers) do
            local token,consumed = tokenizer(str, offset)
            -- Token can be nil and still succeed
            if token ~= nil then table.insert(t, token) end
            -- When consumed ~≃ 0 it is treated as a success, even if token may be nil
            if consumed then
                offset = offset + consumed 
                success = true 
                break 
            end

        end

        if not success then
            printerr("Unknown token after '{}'", str:sub(offset, offset+10))
            break
        end
    end
    return t
end
