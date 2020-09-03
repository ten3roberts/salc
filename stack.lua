variables = {}
constants = {}

local function resolve_identifier(ident)

    local value = nil
    if type(ident) == "table" then value = tonumber(ident.value) end
    if value == nil then value = variables[ident] end
    if value == nil then value = constants[ident] end
    if value == nil then printerr("Undefined variable or constant '{}'", ident) end
    return value
end

local operations = {
    ["+"] = {n=2, resolve = true, func=function(a,b) return a+b end},
    ["-"] = {n=2, resolve = true, func=function(a,b) return a-b end},
    ["*"] = {n=2, resolve = true, func=function(a,b) return a*b end},
    ["/"] = {n=2, resolve = true, func=function(a,b) return a/b end},
    ["%"] = {n=2, resolve = true, func=function(a,b) return a%b end},
    ["^"] = {n=2, resolve = true, func=function(a,b) return math.pow(a,b) end},
    ["Q"] = {n=1, resolve = true, func=function(a) return math.sqrt(a) end},
    ["D"] = {n=1, resolve = true, func=function(_) return nil end},
    ["="] = {n=2, resolve = false, func = function(val, ident) variables[ident.value] = resolve_identifier(val) return nil end}
}



-- Removes n elements from the top and returns them as a new array
local function stack_popn(stack, n, resolve)
    local t = {}
    if #stack < n then
        printerr("Too few elements in stack")
        return nil
    end

    for i=#stack-n+1,#stack do
        local token = stack[i]
        local value = token
        if resolve then
            if token.ty == "number" then
                value = tonumber(token.value)
            elseif token.ty == "identifier" then
                value = resolve_identifier(token.value)
                if value == nil then return nil 
            end
            end
        end

        table.insert(t, value)
        stack[i]=nil
    end

    return t
end

-- Appends values to the stack
local function stack_append(stack, vals)
    -- Past end of the stack
    local offset = #stack
    for i=1,#vals do
        stack[i+offset] = vals[i]
    end
end

-- Pushes and executes a stack with rpn with given tokens
function stack_push(stack, tokens)
    local type_switch = {
        number=function(token) table.insert(stack, token) end,
        operator=function(token) 
            local op = operations[token.value]
            if op == nil then printerr("Unknown operation '{}'", token.value) return end
            local args = stack_popn(stack, op.n, op.resolve)

            -- Quit if there arent enough elements in the stack
            if args == nil then return end
            local result = {op.func(table.unpack(args))}
            for i,val in ipairs(result) do result[i] = {ty="number", value=val} end

            stack_append(stack, result)
        end,
        identifier=function(token) table.insert(stack, token) end,
    }
    for i,token in ipairs(tokens) do
        local action = type_switch[token.ty]
        if action == nil then
            printerr("Unknown token type '{}'", token.ty)
            break
        end
        action(token)
    end
end
