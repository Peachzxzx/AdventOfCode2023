local sortedList = {
    create = function(self)
        self = setmetatable({
            first = 1,
            last = 1
        }, self)
        return self
    end,
    size = function(self)
        return self.last - self.first
    end,
    insertLast = function(self, item, compFunc)
        compFunc = compFunc or function(a, b)
            return a < b
        end
        local temp = item
        for i = self.first, self.last - 1 do
            if compFunc(item, self[i]) then
                temp = self[i]
                self[i] = item
                item = temp
            end
        end
        self[self.last] = temp
        self.last = self.last + 1
    end,
    popHead = function(self)
        local x = self[self.first]
        self.first = self.first + 1
        return x
    end
}
sortedList.__index = sortedList
local unpack = unpack or table.unpack
local graph = {}
local gr, gc
local count = 1
for line in io.lines("input.txt") do
    graph[count] = {}
    for j = 1, #line do
        graph[count][j] = string.sub(line, j, j)
    end
    count = count + 1
end
gr = #graph
gc = #graph[1]
local queue = sortedList:create()
queue:insertLast({ 0, 1, 1, -1, 0 })
local cache = {}
local com = function(x, y)
    return x[1] < y[1]
end
local x = { { -1, 0 }, { 0, -1 }, { 1, 0 }, { 0, 1 } }
while queue:size() > 0 do
    local distance, row, column, facingDirection, count = unpack(queue:popHead())
    if gr == row and gc == column and count > 3 then
        print(distance)
        break
    end
    if cache[row] == nil then
        cache[row] = {}
    end
    if cache[row][column] == nil then
        cache[row][column] = {}
    end
    if cache[row][column][facingDirection] == nil then
        cache[row][column][facingDirection] = {}
    end
    if cache[row][column][facingDirection][count] then
        goto continue
    end
    cache[row][column][facingDirection][count] = true
    for i = 1, 4 do
        local newRow = row + x[i][1]
        local newCol = column + x[i][2]

        if 0 < newRow and newRow <= gr and 0 < newCol and newCol <= gc  then
            local newDistance = distance + graph[newRow][newCol]

            if count < 10 and i == facingDirection or -1 == facingDirection then
                queue:insertLast({ newDistance, newRow, newCol, i, count + 1 }, com)
            end

            if count > 3 and facingDirection ~= i and ((facingDirection + 1) % 4) + 1 ~= i then
                queue:insertLast({ newDistance, newRow, newCol, i, 1 }, com)
            end
        end
    end
    ::continue::
end
