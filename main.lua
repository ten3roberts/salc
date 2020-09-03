#!/bin/lua
-- Imports println format and table_tostring
require "formatting"
require "tokenizer"
require "stack"
term = require "plterm"
require "display"

-- Table of all acceptable tokens
local tokenizers = {
    function(str, offset) return tokenize_pattern("operator", "[%+%-%*%/%%%^%=%u]", str, offset) end,
    function(str, offset) return tokenize_pattern("number", "[%d%.]+", str, offset) end,
    function(str, offset) return tokenize_pattern("identifier", "%l+", str, offset) end,

    -- Do whitespace last incase something matches whitespace
    function(str, offset) return tokenize_whitespace(str, offset) end,
}

-- Constructs what is to be drawn to the screen
-- Does not actually print to screen
function generate_lines(stack)
    local lines = {}

    for i,token in ipairs(stack) do
        table.insert(lines, format("[{}] | {}", i, token.value))
    end

    -- Leave some blank lines between stack and prompt
    for i=1,2 do
        table.insert(lines, "")
    end

    -- Print variables
    table.insert(lines,string.rep("-", 16))
    local variable_display = {tostring(#stack)}
    for k,v in pairs(variables) do
        table.insert(variable_display, format("{}={}", k, v))
    end

    table.insert(lines, table.concat(variable_display, ", "))

    -- Print and clear errors
    for i, err in ipairs(errors) do
        table.insert(lines, format("Error: {}", err))
    end

    -- Clear errors
    errors[1] = nil
    return lines
end


local stack = {}
local lines = {}
generate_lines(lines, {})
display:draw(lines)
while true do
    local str = display:read("> ")
    local tokens = tokenize(tokenizers, str) 
    stack_push(stack, tokens) 
    lines = generate_lines(stack)
    display:draw(lines)
end
