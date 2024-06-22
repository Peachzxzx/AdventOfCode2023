local LOW = true
local HIGH = false

local moduleList = {}
local conjunctionModuleName = {}

for line in io.lines("input.txt") do
    local moduleType, moduleName, targetModuleListString = string.match(line, "^([%%&]?)(%a+) %->(.+)$")
    local moduleTarget = {}
    for targetModule in string.gmatch(targetModuleListString, ' ([^,]+)') do
        moduleTarget[#moduleTarget + 1] = targetModule
    end
    local module = { name = moduleName, state = LOW, target = moduleTarget }
    if moduleType == "" then
        module.type = 1
    elseif moduleType == "%" then
        module.type = 2
    elseif moduleType == "&" then
        module.type = 3
        module.input = {}
        conjunctionModuleName[moduleName] = true
    end
    moduleList[moduleName] = module
end

for moduleName, module in pairs(moduleList) do
    for _, nextModuleName in ipairs(module.target) do
        if conjunctionModuleName[nextModuleName] then
            moduleList[nextModuleName].input[moduleName] = true
        end
        if moduleList[nextModuleName] == nil then
            moduleList[nextModuleName] = { name = nextModuleName, state = LOW, type = 1, target = {} }
        end
    end
end
moduleList["button"] = { name = "button", state = LOW, type = 1, target = { "broadcaster" } }
local memorize = {}
local countAllLow, countAllHigh = 0, 0
local countButtonPressed = 0
repeat
    local queue = { { moduleList["button"], LOW, "" } }
    local countLOW, countHIGH = 0, 0
    while #queue > 0 do
        local pulseDirectedEdge = table.remove(queue, 1)
        local module, inputState, prevModule = unpack(pulseDirectedEdge)
        local outputState

        if module.type == 2 then
            if inputState == HIGH then
                goto continue
            end
            module.state = not module.state
        elseif module.type == 3 then
            module.input[prevModule] = inputState
            local isAllHigh = HIGH
            for _, value in pairs(module.input) do
                isAllHigh = isAllHigh or value
            end
            module.state = not isAllHigh
        end

        outputState = module.state
        for i = 1, #module.target do
            local nextModule = module.target[i]
            queue[#queue + 1] = { moduleList[nextModule], outputState, module.name }
            if module.state == LOW then
                countLOW = countLOW + 1
            else
                countHIGH = countHIGH + 1
            end
        end
        ::continue::
    end

    for _, seenState in ipairs(memorize) do
        for key, value in pairs(seenState) do
            if moduleList[key].state ~= value then
                goto continue
            end
        end
        do
            goto exitLoop
        end
        ::continue::
    end

    local seenState = {}
    for key, value in pairs(moduleList) do
        seenState[key] = value.state
    end

    memorize[#memorize + 1] = seenState
    countAllLow = countAllLow + countLOW
    countAllHigh = countAllHigh + countHIGH
    countButtonPressed = countButtonPressed + 1
    if countButtonPressed >= 1000 then
        break
    end
until false
::exitLoop::

local multi = 1000 / countButtonPressed
print(countAllLow * multi * countAllHigh * multi)
