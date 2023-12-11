local map = {}
local start
local mostDistance = -math.huge
for line in io.lines("input.txt") do
    local mapRow = {}
    for i = 1, #line do
        mapRow[i] = { ["sym"] = string.sub(line, i, i), ["distance"] = math.huge }
        if mapRow[i]["sym"] == "S" then
            start = { #map + 1, i }
        end
    end
    map[#map + 1] = mapRow
end

local direction = {
    { { -1, 0 }, { ["|"] = { -1, 0 }, ["7"] = { 0, -1 }, ["F"] = { 0, 1 } } }, --"N"
    { { 0, 1 },  { ["-"] = { 0, 1 }, ["7"] = { 1, 0 }, ["J"] = { -1, 0 } } },  -- "E"
    { { 0, -1 }, { ["-"] = { 0, -1 }, ["L"] = { -1, 0 }, ["F"] = { 1, 0 } } }, -- "W"
    { { 1, 0 },  { ["|"] = { 1, 0 }, ["L"] = { 0, 1 }, ["J"] = { 0, -1 } } }, -- "S"
}

local queue = {}
for _, value in ipairs(direction) do
    queue[#queue + 1] = {
        ["from"] = { start[1], start[2] },
        ["now"] = { start[1] + value[1][1], start[2] + value[1][2] },
        ["distance"] = 1
    }
end

while #queue ~= 0 do
    local point = table.remove(queue, 1)
    local sym = map[point["now"][1]][point["now"][2]]
    if sym == nil or sym["sym"] == "." then
        goto continue
    end
    local dx = point["now"][1] - point["from"][1]
    local dy = point["now"][2] - point["from"][2]
    for directionIndex = 1, #direction do
        if direction[directionIndex][1][1] == dx and direction[directionIndex][1][2] == dy then
            local nextCoordinate = direction[directionIndex][2][sym["sym"]]
            if nextCoordinate == nil then
                break
            end
            local newCoordinateX = point["now"][1] + nextCoordinate[1]
            local newCoordinateY = point["now"][2] + nextCoordinate[2]
            if newCoordinateX == point["from"][1] and newCoordinateY == point["from"][2] then
                break
            end
            local newDistance = point["distance"] + 1
            if map[point["now"][1]][point["now"][2]]["distance"] <= newDistance then
                break
            else
                map[point["now"][1]][point["now"][2]]["distance"] = point["distance"]
                if mostDistance < point["distance"] then
                    mostDistance = point["distance"]
                end
                queue[#queue + 1] = {
                    ["sym"] = map[newCoordinateX][newCoordinateY]["sym"],
                    ["from"] = point["now"],
                    ["now"] = { newCoordinateX, newCoordinateY },
                    ["distance"] = newDistance
                }
            end
        end
    end
    ::continue::
end

local sum = 0
for i = 2, #map - 1 do
    local stack = {}
    local inside = false
    for j = 2, #map - 1 do
        if map[i][j]["sym"] == "S" then
            map[i][j]["distance"] = 0
        end
        if map[i][j]["distance"] ~= math.huge then
            if map[i][j]["sym"] == "S" then
                map[i][j]["distance"] = 0
                if map[i][j + 1]["distance"] == 1 then
                    if map[i][j - 1]["distance"] == 1 then
                        map[i][j]["sym"] = "-"
                    elseif map[i - 1][j]["distance"] == 1 then
                        map[i][j]["sym"] = "L"
                    elseif map[i][j + 1]["distance"] == 1 then
                        map[i][j]["sym"] = "F"
                    end
                elseif map[i][j - 1]["distance"] == 1 then
                    if map[i - 1][j]["distance"] == 1 then
                        map[i][j]["sym"] = "J"
                    elseif map[i + 1][j]["distance"] == 1 then
                        map[i][j]["sym"] = "7"
                    end
                else
                    map[i][j]["sym"] = "|"
                end
            end
            local symbol = map[i][j]["sym"]
            if symbol == "-" then
            elseif symbol == "|" then
                inside = not inside
            elseif symbol == "F" or symbol == "L" then
                stack[#stack + 1] = symbol
            elseif symbol == "7" then
                if stack[#stack] == "F" then
                elseif stack[#stack] == "L" then
                    inside = not inside
                end
                stack[#stack] = nil
            elseif symbol == "J" then
                if stack[#stack] == "L" then
                elseif stack[#stack] == "F" then
                    inside = not inside
                end
                stack[#stack] = nil
            end
        else
            stack[#stack] = nil
            if inside then
                sum = sum + 1
            end
        end
    end
end
print(sum)
