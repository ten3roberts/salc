local term = require "plterm"

local i = 1
local last = nil

while true do
    print(i, last)
    local str = io.read()
    last = str
    i = i + 1
    term.up()
    term.cleareol()
    term.up()
    term.cleareol()
end
