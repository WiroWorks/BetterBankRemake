ESX				= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand(Config.UIOpener, function()
    TriggerEvent('BetterBank:CheckATM')
end)
--===============================================
--==          Banka Bliplerini ekler           ==
--===============================================
CreateThread(function()
    for k,v in pairs(Config.Banks) do
        v.blip = AddBlipForCoord(v.Location, v.Location, v.Location)
        SetBlipSprite(v.blip, v.id)
        SetBlipAsShortRange(v.blip, true)
	    BeginTextCommandSetBlipName("STRING")
        SetBlipColour(v.blip, 2)
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(v.blip)
    end
end)

function Display(company, data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ui",
        openForCompany = company,
        data = data
    })
end


RegisterNetEvent("BetterBank:CheckATM")
AddEventHandler("BetterBank:CheckATM", function()
    if PlayerNearATM() or nearBank() then
        PlayerBankOpener()
    end
end)

function PlayerNearATM()
    for i = 1, #Config.Atms do
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 0.75, Config.Atms[i], 0, 0, 0)
        if DoesEntityExist(obj) then
            TaskTurnPedToFaceEntity(PlayerPedId(), obj, 3.0)
            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_ATM", 0, true)
            return true
        end
    end
    exports['mythic_notify']:SendAlert('error', Config.noCloseATM)
    return false
end

function nearBank()
    if not Config.openBankWithCom then
        local player = PlayerPedId()
        local playerloc = GetEntityCoords(player, 0)

        for k,v in pairs(Config.Banks) do
            local distance = GetDistanceBetweenCoords(v.Location.x, v.Location.y, v.Location.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
            if distance <= 3 then
                TaskPlayAnim(player, "anim@amb@prop_human_atm@interior@male@enter", "enter", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
                return true
            end
        end
        return false
    end
    return false
end

function drawTxt(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
    while not Config.openBankWithCom do
        Citizen.Wait(1)
        if ESX ~= nil then
            local plyPed = PlayerPedId()
            local pos = GetEntityCoords(plyPed)

            for k,v in pairs(Config.Banks) do
                if (#(v.Location - pos) < 1) then
                    drawTxt(v.Location.x, v.Location.y, v.Location.z, "[E] Hesabına Eris")
                    if IsControlJustPressed(0, 38) then
                        PlayerBankOpener()
                    end
                elseif (#(v.Location - pos) < 4.5) then
                    drawTxt(v.Location.x, v.Location.y, v.Location.z, "Banka")
                end
            end
        end
    end
end)

function PlayerBankOpener()
    --MAİN STARTER
    ESX.TriggerServerCallback('Betterbank:getSourceDatas', function(datas)
        Display(false, datas)
    end)
    --MAİN STARTER
end 

RegisterNetEvent('BetterBank:CompanyBankOpener')
AddEventHandler('BetterBank:CompanyBankOpener', function(IBAN)
    ESX.TriggerServerCallback('BetterBank:openForCompany', function(datas)
        Display(true, datas)
    end, IBAN)
end)

RegisterCommand('bbank', function(source, args, raw)
    TriggerEvent('BetterBank:CompanyBankOpener', args[1])
end)

--===============================================
--==                 Events                    ==
--===============================================

RegisterNetEvent('BetterBank:ShowMessage')
AddEventHandler('BetterBank:ShowMessage', function(icon, message)
    SendNUIMessage({
        type = "message",
        icon = icon,
        message = message,
    })
end)

RegisterNetEvent('BetterBank:addTransaction')
AddEventHandler('BetterBank:addTransaction', function(status, amount, time, comingFrom, icon, color, numberAmount)
    if Config.dbMinAmount <= tonumber(numberAmount) then
        data = {}
        data.status = status
        data.amount = amount
        data.time = time
        data.comingFrom = comingFrom
        data.icon = icon
        data.color = color
        SendNUIMessage({
            type = "addTransaction",
            transaction = data,
        })
    end
end)

RegisterNetEvent('BetterBank:UpdateBalance')
AddEventHandler('BetterBank:UpdateBalance', function(balance)
    SendNUIMessage({
        type = "updateBalance",
        balance = balance,
    })
end)
--===============================================
--==           NUI CALL BACKS                  ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('BetterBank:deposit', tonumber(data.amount), data.IBAN ,data.time, data.editedAmount, data.openedForCompany)
    Citizen.Wait(1000)
    TriggerServerEvent('BetterBank:UpdateBalance', data.IBAN)
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('BetterBank:withdraw', tonumber(data.amount), data.IBAN, data.time, data.editedAmount, data.openedForCompany)
    Citizen.Wait(1000)
	TriggerServerEvent('BetterBank:UpdateBalance', data.IBAN)
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('BetterBank:transferMoney', data.senderIBAN, data.targetIBAN, data.time, data.amount, data.editedAmount, data.openedForCompany)
    Citizen.Wait(1000)
	TriggerServerEvent('BetterBank:UpdateBalance', data.senderIBAN)
end)

RegisterNUICallback('payBill', function(datas)
    ESX.TriggerServerCallback('Betterbank:tryToPayBill', function(cb)
        TriggerServerEvent('BetterBank:UpdateBalance')
        SendNUIMessage({
            type = "deleteBill",
            index = datas.data.id,
        })
    end, datas.data)
end)


RegisterNUICallback("exit", function(data)
    ClearPedTasksImmediately(PlayerPedId())
    SetNuiFocus(false, false)
end)