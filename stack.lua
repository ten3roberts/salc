local operations = {
    ["+"] = {n=2, func=function(a,b) return a+b end},
    ["-"] = {n=2, func=function(a,b) return a-b end},
    ["*"] = {n=2, func=function(a,b) return a*b end},
    ["/"] = {n=2, func=function(a,b) return a/b end},
    ["%"] = {n=2, func=function(a,b) return a%b end},
    ["Q"] = {n=1, func=function(a) return math.sqrt(a) end},
    ["D"] = {n=1, func=function(_) return nil end},
}

-- Removes n elements from the top and returns them as a new array
function stack_popn(stack, n)
    local t = {}
    if #stack < n then
        printerr("Too few elements in stack")
        return nil
    end

    for i=#stack-n+1,#stack do
        table.insert(t, stack[i])
        stack[i]=nil
    end

    return t
end

-- Appends values to the stack
function stack_append(stack, vals)
    -- Past end of the stack
    local offset = #stack
    for i=1,#vals do
        stack[i+offset] = vals[i]
    end
end

-- Pushes and executes a stack with rpn with given tokens
function stack_push(stack, tokens)
    local type_switch = {
        number=function(token) table.insert(stack, token.value) end,
        operator=function(token) 
            local op = operations[token.value]
            if op == nil then printerr("Unknown operation '{}'", token.value) return end
            local args = stack_popn(stack, op.n)

            -- Quit if there arent enough elements in the stack
            if args == nil then return end
            local result = {op.func(table.unpack(args))}
            stack_append(stack, result)
        end,
        identifier=nil,
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
