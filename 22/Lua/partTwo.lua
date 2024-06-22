local tetris = {
    index = 0,
    new = function(self, sx, sy, sz, ex, ey, ez)
        self.index = self.index + 1
        return setmetatable({ x = { sx, ex }, y = { sy, ey }, z = { sz, ez } }, self)
    end,
    copy = function(self)
        local r = { index = self.index, x = { unpack(self.x) }, y = { unpack(self.y) }, z = { unpack(self.z) } }
        return setmetatable(r, getmetatable(self))
    end
}
tetris.__index = tetris
local tetrisList = {}

local max = { x = 0, y = 0, z = 0 }
local min = { x = 0, y = 0, z = 0 }
for line in io.lines("input.txt") do
    local sx, sy, sz, ex, ey, ez = string.match(line, "^(%d+),(%d+),(%d+)~(%d+),(%d+),(%d+)$")
    sx, sy, sz, ex, ey, ez = tonumber(sx) + 1, tonumber(sy) + 1, tonumber(sz), tonumber(ex) + 1, tonumber(ey) + 1,
        tonumber(ez)
    tetrisList[#tetrisList + 1] = tetris:new(sx, sy, sz, ex, ey, ez)
    max.x = math.max(max.x, ex)
    max.y = math.max(max.y, ey)
    max.z = math.max(max.z, ez)
    min.x = math.min(min.x, sx)
    min.y = math.min(min.y, sy)
    min.z = math.min(min.z, sz)
end

table.sort(tetrisList, function(a, b)
    return a.z[1] < b.z[1]
end)

for index, tetrisBlock in ipairs(tetrisList) do
    tetrisBlock.index = index
end

local function createGrid()
    local grid = {}
    for z = min.z, max.z do
        grid[z] = {}
        for y = min.y, max.y do
            grid[z][y] = {}
        end
    end
    return grid
end

local function countDrop(tetrisList)
    local grid = createGrid()
    local count = 0
    for _, tetrisBlock in ipairs(tetrisList) do
        local sx, ex = unpack(tetrisBlock.x)
        local sy, ey = unpack(tetrisBlock.y)
        local level = max.z

        while level > 1 do
            for y = sy, ey do
                for x = sx, ex do
                    if grid[level - 1][y][x] ~= nil then
                        goto breakLoop
                    end
                end
            end
            level = level - 1
        end
        ::breakLoop::

        if level + tetrisBlock.z[2] - tetrisBlock.z[1] ~= tetrisBlock.z[2] then
            count = count + 1
        end
        tetrisBlock.z[2], tetrisBlock.z[1] = level + tetrisBlock.z[2] - tetrisBlock.z[1], level

        local sz, ez = unpack(tetrisBlock.z)
        for z = sz, ez do
            if grid[z] == nil then
                grid[z] = {}
            end
            for y = sy, ey do
                if grid[z][y] == nil then
                    grid[z][y] = {}
                end
                for x = sx, ex do
                    grid[z][y][x] = tetrisBlock.index
                end
            end
        end
    end
    return count
end
countDrop(tetrisList)

local sum = 0
for i, _ in ipairs(tetrisList) do
    local newTetrisList = {}
    local newIndex = 1
    for index, tetrisBlock in ipairs(tetrisList) do
        if i == index then
            goto continue
        end

        newTetrisList[newIndex] = { index = newIndex, x = { unpack(tetrisBlock.x) }, y = { unpack(tetrisBlock.y) }, z = { unpack(tetrisBlock.z) } }
        newIndex = newIndex + 1
        ::continue::
    end
    sum = sum + countDrop(newTetrisList)
end

print(sum)
