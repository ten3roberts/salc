-- Imports println format and table_tostring
require "formatting"

function tokenize_char(ty, value, str, offset) 
    local sub = str:sub(offset, offset)
    println("Sub: {}", sub)
    if sub == value then return {ty=ty, value=value}, 1 else return nil end
end

-- Defines a token
function tokenizeFn(ty, pattern, str, offset) 
    local i,j = str:find("^"..pattern, offset)
    println("i: {}, j: {}", i, j)
end

local str = "(((os*"
local offset = 1
for i=0,10 do
    token, adv = tokenize_char("paren", "(", str, offset)
    if token == nil then println("Unknown token at '{}'", str:sub(offset)) break end
    offset = offset + adv
    println("Token: {}, offset: {}", token, offset)
    
end
