-- Imports println format and table_tostring
require "formatting"
require "tokenizer"
require "stack"

-- local str = "2 2.1 + 14-x/"
local str = "22 42 + 4 * Q"
-- local str = "2 2 + -" -- Too few error
-- local str = "2 2"
-- local str = io.read()
local offset = 1

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

local tokens = tokenize(tokenizers, str) 

-- For now, print tokens
for i,v in pairs(tokens) do
    println("{}", v)
end

local stack = {}

stack_push(stack, tokens)


