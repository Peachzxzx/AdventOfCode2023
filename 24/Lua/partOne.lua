local min = 200000000000000
local max = 400000000000000
local hailStone = {
    new = function(self, x, y, z, vx, vy, vz)
        return setmetatable(
            { x = tonumber(x), y = tonumber(y), z = tonumber(z), vx = tonumber(vx), vy = tonumber(vy), vz = tonumber(vz) },
            self)
    end,
    findForwardIntersect2d = function(i, j)
        -- ax + by = c

        -- px = x + vx t
        -- py = y + vy t
        -- t = (px - x) / vx
        -- (px - x) / vx = (py - y) / vy
        -- vy (px - x) = vx (py - y)
        -- vy px - vy x = vx py - vx y
        -- vy px - vx py = vy x - vx y
        local ai = i.vy
        local bi = -i.vx
        local ci = i.vy * i.x - i.vx * i.y

        local dj = j.vy
        local ej = -j.vx
        local fj = j.vy * j.x - j.vx * j.y
        -- ax + by = c
        -- dx + ey = f
        -- y = -a/b x + c
        -- -a/b x + c/b = -d/e x + f/e
        -- (d/e - a/b) x = f/e - c/b
        -- x = (f/e - c/b) / (d/e - a/b)
        local xIntersect = (fj / ej - ci / bi) / ((dj / ej) - (ai / bi))
        if xIntersect == math.huge or xIntersect == -math.huge then
            return nil, nil
        end
        -- x = -b/a y + c/a
        -- -b/a y + c/a = -e/d y + f/d
        -- y (e/d - b/a) = f/d - c/a
        local yIntersect = (fj / dj - ci / ai) / (ej / dj - bi / ai)
        local ti = (xIntersect - i.x) * i.vx
        local tj = (xIntersect - j.x) * j.vx
        if ti >= 0 and tj >= 0 then
            return xIntersect, yIntersect
        end

        return nil, nil
    end
}
hailStone.__index = hailStone
local hailStorm = {}
for line in io.lines("input.txt") do
    local x, y, z, vx, vy, vz = string.match(line, "^(-?%d+),%s+(-?%d+),%s+(-?%d+)%s+@%s+(-?%d+),%s+(-?%d+),%s+(-?%d+)$")

    local h = hailStone:new(x, y, z, vx, vy, vz)
    hailStorm[#hailStorm + 1] = h
end

local count = 0
for i, hail in ipairs(hailStorm) do
    for j = i + 1, #hailStorm do
        local x, y = hailStone.findForwardIntersect2d(hail, hailStorm[j])
        if x ~= nil and y ~= nil and (min <= x and x <= max) and (min <= y and y <= max) then
            count = count + 1
        end
    end
end

print(count)
