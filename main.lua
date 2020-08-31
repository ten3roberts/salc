-- Imports println format and table_tostring
require "formatting"
require "tokenizer"
require "stack"
require "plterm"
require "display"

-- local str = "2 2.1 + 14-x/"
-- local str = "22 42 + 4 * Q 2 4"
-- local str = "2 2 + -" -- Too few error
-- local str = "2 2"
-- local str = io.read()

-- Table of all acceptable tokens
local tokenizers = {
    function(str, offset) return tokenize_pattern("operator", "[%+%-%*%/%%%u]", str, offset) end,
    function(str, offset) return tokenize_char("paren", "(", str, offset) end,
    function(str, offset) return tokenize_char("paren", ")", str, offset) end,
    function(str, offset) return tokenize_pattern("number", "[%d%.]+", str, offset) end,
    function(str, offset) return tokenize_pattern("identifier", "%i+", str, offset) end,

    -- Do whitespace last incase something matches whitespace
    function(str, offset) return tokenize_whitespace(str, offset) end,
}

-- Constructs what is to be drawn to the screen
-- Overwrites and outputs to lines as an array
-- Does not actually print to screen
function generate_lines(lines, stack)
    -- Line iterator
    local line_i = 1

    for i,value in ipairs(stack) do
        lines[line_i] = format("[{}] | {}", i, value)
        line_i = line_i+1
    end

    -- Leave some blank lines between stack and prompt
    for i=1,2 do
        lines[line_i] = ""
        line_i = line_i+1
    end

    -- nil terminate to be able to reuse table without clear
    lines[line_i] = nil
end


local stack = {}
local lines = {}
generate_lines(lines, {})
display:draw(lines)
while true do
    local str = display:read("> ")
    local tokens = tokenize(tokenizers, str) 
    stack_push(stack, tokens) 
    generate_lines(lines, stack)
    display:draw(lines)
end
