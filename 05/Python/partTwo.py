state = -1
seedList = []
seedToSoilMap = []
soilToFertilizer = []
fertilizerToWater = []
waterToLight = []
lightToTemperature = []
temperatureToHumidity = []
humidityToLocation = []
themap = None
with open("input.txt", "r") as f:
    for i in f.readlines():
        stripText = i.strip()
        if state == -1:
            seedList = [int(i) for i in stripText.split("seeds: ")[-1].split()]
            state = 0
            continue
        elif state == 0:
            if stripText == "seed-to-soil map:":
                themap = seedToSoilMap
                state = 1
            elif stripText == "soil-to-fertilizer map:":
                themap = soilToFertilizer
                state = 2
            elif stripText == "fertilizer-to-water map:":
                themap = fertilizerToWater
                state = 3
            elif stripText == "water-to-light map:":
                themap = waterToLight
                state = 4
            elif stripText == "light-to-temperature map:":
                themap = lightToTemperature
                state = 5
            elif stripText == "temperature-to-humidity map:":
                themap = temperatureToHumidity
                state = 6
            elif stripText == "humidity-to-location map:":
                themap = humidityToLocation
                state = 7
            continue
        if stripText == "":
            state = 0
            continue
        rangeMap = [int(i) for i in stripText.split()]
        themap.append((rangeMap[0], rangeMap[1], rangeMap[2]))

def mapValue (map,value):
    for des,start,range in map:
        if value >= start and value < start+range:
            return des+(value-start)
    return value
def seedMap(seedList):
    for i in range(0,len(seedList),2):
        x = seedList[i]
        y = seedList[i+1]
        for seed in range(x,x+y):
            yield seed 
lowest = 2**100
for seed in seedMap(seedList):
    print(seed)
    soil = mapValue(seedToSoilMap, seed)
    fertilizer = mapValue(soilToFertilizer, soil)
    water = mapValue(fertilizerToWater, fertilizer)
    light = mapValue(waterToLight, water)
    temperature = mapValue(lightToTemperature, light)
    humidity = mapValue(temperatureToHumidity, temperature)
    location = mapValue(humidityToLocation, humidity)
    if location < lowest:
        lowest = location
print(lowest)
