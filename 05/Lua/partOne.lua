local seedList = {}
local seedToSoilMap = {}
local soilToFertilizer = {}
local fertilizerToWater = {}
local waterToLight = {}
local lightToTemperature = {}
local temperatureToHumidity = {}
local humidityToLocation = {}
local selectedTable = nil

local function mapValue(map, value)
    for _, ta in ipairs(map) do
        if value >= ta[2] and value < ta[2] + ta[3] then
            return ta[1] + (value - ta[2])
        end
    end
    return value
end

for line in io.lines("input.txt") do
    if line:find("^seeds: ") then
        for number in string.gmatch(line, "%d+") do
            seedList[#seedList + 1] = tonumber(number)
        end
    elseif line == "" then
    elseif line == "seed-to-soil map:" then
        selectedTable = seedToSoilMap
    elseif line == "seed-to-soil map:" then
        selectedTable = seedToSoilMap
    elseif line == "soil-to-fertilizer map:" then
        selectedTable = soilToFertilizer
    elseif line == "fertilizer-to-water map:" then
        selectedTable = fertilizerToWater
    elseif line == "water-to-light map:" then
        selectedTable = waterToLight
    elseif line == "light-to-temperature map:" then
        selectedTable = lightToTemperature
    elseif line == "temperature-to-humidity map:" then
        selectedTable = temperatureToHumidity
    elseif line == "humidity-to-location map:" then
        selectedTable = humidityToLocation
    else
        local x, y, z = line:match("^(%d+) (%d+) (%d+)$")
        selectedTable[#selectedTable + 1] = { tonumber(x), tonumber(y), tonumber(z) }
    end
end

local lowest = math.huge
for _, seed in ipairs(seedList) do
    local soil = mapValue(seedToSoilMap, seed)
    local fertilizer = mapValue(soilToFertilizer, soil)
    local water = mapValue(fertilizerToWater, fertilizer)
    local light = mapValue(waterToLight, water)
    local temperature = mapValue(lightToTemperature, light)
    local humidity = mapValue(temperatureToHumidity, temperature)
    local location = mapValue(humidityToLocation, humidity)
    if location < lowest then
        lowest = location
    end
end
print(lowest)