local tetris = {
    index = 0,
    new = function(self, sx, sy, sz, ex, ey, ez)
        self.index = self.index + 1
        return setmetatable({ x = { sx, ex }, y = { sy, ey }, z = { sz, ez } }, self)
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

local grid = {}
for z = min.z, max.z do
    grid[z] = {}
    for y = min.y, max.y do
        grid[z][y] = {}
    end
end

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

local count = 0
for _, v in ipairs(tetrisList) do
    local sx, ex = unpack(v.x)
    local sy, ey = unpack(v.y)
    local sz, ez = unpack(v.z)
    local z      = ez + 1

    if grid[z] == nil then
        count = count + 1
        goto continue
    end

    local tetrisOnTop = {}
    for y = sy, ey do
        if grid[z][y] then
            for x = sx, ex do
                if grid[z][y][x] then
                    tetrisOnTop[grid[z][y][x]] = true
                end
            end
        end
    end

    z = ez
    local removedPiece = v.index
    local supportedPieces = {}
    for k, _ in pairs(tetrisOnTop) do
        local tetrisBlock = tetrisList[k]
        local sx, ex = unpack(tetrisBlock.x)
        local sy, ey = unpack(tetrisBlock.y)
        for y = sy, ey do
            local zy = grid[z][y]
            if zy then
                for x = sx, ex do
                    if zy[x] and zy[x] ~= removedPiece then
                        supportedPieces[k] = true
                        goto continue
                    end
                end
            end
        end
        ::continue::
    end

    for ofTopPiece, _ in pairs(tetrisOnTop) do
        if supportedPieces[ofTopPiece] ~= true then
            goto continue
        end
    end

    count = count + 1
    ::continue::
end

print(count)
