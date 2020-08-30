-- Imports println format and table_tostring
require "formatting"
require "tokenizer"
require "stack"

local str = "2 2.1 + 14-x/"
local offset = 1

-- Table of all acceptable tokens
local tokenizers = {
    function(str, offset) return tokenize_pattern("operator", "[%+%-%*%/%%]", str, offset) end,
    function(str, offset) return tokenize_char("paren", "(", str, offset) end,
    function(str, offset) return tokenize_char("paren", ")", str, offset) end,
    function(str, offset) return tokenize_pattern("number", "[%d%.]+", str, offset) end,
    function(str, offset) return tokenize_pattern("identifier", "%a+", str, offset) end,

    -- Do whitespace last incase something matches whitespace
    function(str, offset) return tokenize_whitespace(str, offset) end,
}

local tokens = tokenize(tokenizers, str) 

-- For now, print tokens
for i,v in pairs(tokens) do
    println("{}", v)
end
