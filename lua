getgenv().Config = {
    ["Pet_Remote_Name"] = "butterfly_2025_amber_butterfly"
}

----

local Age_Pots = 0
local Tiny_pots = 0

local uniqueAgePots = {}

local clientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local playerData = clientData.get_data()[tostring(game.Players.LocalPlayer)]

if playerData then
    for num, i in pairs(playerData) do
        if num == 'inventory' then
            if i.food then
                for num2, i2 in pairs(i.food) do
                    if i2.kind == 'pet_age_potion' then
                        AgePots += 1
                        if not uniqueAgePots[i2] then
                            uniqueAgePots[i2] = true
                        end
                    end
                end
            else
                warn("фуд не найден")
            end
        end
    end
else
    warn("дата не найдена")
end

local count = 0
print("Unique Age Pots:")
for agePot, _ in pairs(uniqueAgePots) do
    if count < 5 then
        if count == 1 then
            uniqueAge1 = agePot.unique
        elseif count == 2 then
            uniqueAge2 = agePot.unique
        elseif count == 3 then
            uniqueAge3 = agePot.unique
        elseif count == 4 then
            uniqueAge4 = agePot.unique
        end
        count = count + 1
        uniqueAgePots[agePot] = nil
    else
        break
    end
end

--- pets

local PetsNoFull = {}
local pets = 0
local clientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local playerData = clientData.get_data()[tostring(game.Players.LocalPlayer)]
local petName = getgenv().Config["Pet_Remote_Name"]

for num,i in pairs(playerData.inventory.pets) do
    if i.kind == petName then
        if i.properties.age == 6 then
            print("Full grown")
        else
            if not PetsNoFull[i] then
                PetsNoFull[i] = true
            end
        end
        pets += 1
    end
end

print("Pets: ".. petName .." Stock: ".. pets)

if pets == 0 then
    error("0 Stock pets")
end

count = 0
for PetAge,  in pairs(PetsNoFull) do
    if count == 0 then
        PetsUniqie = PetAge.unique
        local args = {
            [1] = PetsUniqie,
            [2] = {
                ["use_sound_delay"] = true,
                ["equip_as_last"] = false
            }
        }

        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(unpack(args))
    else
        break
    end
    count += 1
    PetsNoFull[PetAge] = nil
end

local args = {
    [1] = uniqueAge1,
    [2] = {
        ["use_sound_delay"] = true,
        ["equip_as_last"] = false
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(unpack(args))

task.wait(5)

local args = {
    [1] = "__Enum_PetObjectCreatorType_2",
    [2] = {
        ["additional_consume_uniques"] = {
            [1] = uniqueAge1,
            [2] = uniqueAge2,
            [3] = uniqueAge3
        },
        ["pet_unique"] = PetsUniqie,
        ["unique_id"] = uniqueAge4
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("PetObjectAPI/CreatePetObject"):InvokeServer(unpack(args))
