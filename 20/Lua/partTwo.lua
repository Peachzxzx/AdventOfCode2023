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

local moduleBeforeRxName

for moduleName, module in pairs(moduleList) do
    for _, nextModuleName in ipairs(module.target) do
        if nextModuleName == "rx" then
            moduleBeforeRxName = moduleName
        end
        if conjunctionModuleName[nextModuleName] then
            moduleList[nextModuleName].input[moduleName] = true
        end
        if moduleList[nextModuleName] == nil then
            moduleList[nextModuleName] = { name = nextModuleName, state = LOW, type = 1, target = {} }
        end
    end
end

local product = 1
for _, moduleAfterBroadcaster in ipairs(moduleList["broadcaster"].target) do
    local countButtonPressed = 0
    for _, module in pairs(moduleList) do
        module.state = LOW
    end

    repeat
        local queue = { { moduleList[moduleAfterBroadcaster], LOW, "" } }
        countButtonPressed = countButtonPressed + 1
        while #queue > 0 do
            local pulseDirectedEdge = table.remove(queue, 1)
            local module, inputState, prevModule = unpack(pulseDirectedEdge)
            local outputState

            if module.name == moduleBeforeRxName and inputState == HIGH then
                product = product * countButtonPressed
                goto exitLoop
            end
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
            end
            ::continue::
        end
    until false
    ::exitLoop::
end

io.write(string.format("%.f", product))
