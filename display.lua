term = require "plterm"

display = {lastn}

function display:notify_return()
    self.lastn = self.lastn+1
end

function display:read(prompt)
    io.write(prompt or "")
    local s = io.read()
    -- self.lastn = self.lastn + 1
    return s
end


function display:clear()
    term.clear()
end


function display:draw(lines)
    for i=1,(self.lastn or -1) + 1 do
        io.write("\r")
        term.cleareol()
        term.up()
    end

    for i,line in ipairs(lines) do
        io.write(line)
        io.write("\n")
    end
    self.lastn = #lines
end
