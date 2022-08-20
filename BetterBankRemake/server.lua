ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('BetterBank:UpdateBalance')
AddEventHandler('BetterBank:UpdateBalance', function(IBAN)
	local _source = source
	if IsIBANBelongToCompany(IBAN) then
		TriggerClientEvent('BetterBank:UpdateBalance', _source, GetCompanyBalance(IBAN))
	else
		local xPlayer = ESX.GetPlayerFromId(_source)
		balance = xPlayer.getAccount('bank').money
		TriggerClientEvent('BetterBank:UpdateBalance', _source, balance)
	end
end)

RegisterServerEvent('BetterBank:deposit')
AddEventHandler('BetterBank:deposit', function(amount, IBAN, time, editedAmount, openedForCompany)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-times-circle", "Error.")
	else
		xPlayer.removeMoney(amount)
		if openedForCompany and IsIBANBelongToCompany(IBAN) then
			nextAmount = GetCompanyBalance(IBAN) + amount
			SetCompanyBalance(IBAN, nextAmount)
		else
			xPlayer.addAccountMoney('bank', tonumber(amount))
		end
		TriggerEvent('BetterBank:addTransactionsDB', IBAN, "Deposit", editedAmount, time, "", "fal fa-chart-line", "green", amount)
		TriggerClientEvent('BetterBank:addTransaction', _source, "Deposit", tostring(editedAmount), time, "", "fal fa-chart-line", "green", amount)
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-check-circle", "Succesful.")
	end
end)

RegisterServerEvent('BetterBank:withdraw')
AddEventHandler('BetterBank:withdraw', function(amount, IBAN, time, editedAmount, openedForCompany)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = tonumber(amount)
	currentMoney = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > currentMoney then
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-times-circle", "Error.")
	else
		if openedForCompany and IsIBANBelongToCompany(IBAN) and GetCompanyBalance(IBAN) >= amount then
			nextAmount = GetCompanyBalance(IBAN) - amount
			SetCompanyBalance(IBAN, nextAmount)
		else
			xPlayer.removeAccountMoney('bank', amount)
		end
		xPlayer.addMoney(amount)
		TriggerEvent('BetterBank:addTransactionsDB', IBAN, "Withdraw", editedAmount, time, "", "fal fa-chart-line-down", "red", amount)
		TriggerClientEvent('BetterBank:addTransaction', _source, "Withdraw", tostring(editedAmount), time, "", "fal fa-chart-line-down", "red", amount)
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-check-circle", "Succesful.")
	end
end)

RegisterServerEvent('BetterBank:transferMoney')
AddEventHandler('BetterBank:transferMoney', function(IBAN, targetIBAN, time, amount, editedAmount, openedForCompany)
	local _source = source
	local sourceName = ""
	local targetName = ""
	if TransferMoney(IBAN, amount, targetIBAN) then
		if IsIBANBelongToCompany(IBAN) then
			sourceName = MySQL.Sync.fetchAll('SELECT * FROM betterbankcompanies WHERE IBAN = @IBAN', {
				['@IBAN'] = IBAN
			})
			sourceName = sourceName[1].fullName .. " - " .. IBAN
		else
			sourceName = MySQL.Sync.fetchAll('SELECT * FROM users WHERE IBAN = @IBAN', {
				['@IBAN'] = IBAN
			})
			sourceName = sourceName[1].firstname .. " " .. sourceName[1].lastname .. " - " .. IBAN
		end
		if IsIBANBelongToCompany(targetIBAN) then
			targetName = MySQL.Sync.fetchAll('SELECT * FROM betterbankcompanies WHERE IBAN = @IBAN', {
				['@IBAN'] = targetIBAN
			})
			targetName = targetName[1].fullName .. " - " .. targetIBAN
		else
			targetName = MySQL.Sync.fetchAll('SELECT * FROM users WHERE IBAN = @IBAN', {
				['@IBAN'] = targetIBAN
			})
			targetName = targetName[1].firstname .. " " .. targetName[1].lastname .. " - " .. targetIBAN
		end
		TriggerEvent('BetterBank:addTransactionsDB', IBAN, "Transfer", editedAmount, time, targetName, "fal fa-exchange", "red", amount)
		TriggerEvent('BetterBank:addTransactionsDB', targetIBAN, "Transfer", editedAmount, time, sourceName, "fal fa-exchange", "green", amount)
		TriggerClientEvent('BetterBank:addTransaction', _source, "Transfer", editedAmount, time, targetName, "fal fa-exchange", "red", amount)
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-check-circle", "Succesful.")
	else 
		TriggerClientEvent('BetterBank:ShowMessage', _source, "fal fa-times-circle", "Error.")
	end
end)

RegisterServerEvent('BetterBank:addTransactionsDB')
AddEventHandler('BetterBank:addTransactionsDB', function(IBAN, status, amount, time, comingFrom, icon, color, numberAmount)
	if Config.dbMinAmount <= tonumber(numberAmount) then
		MySQL.Async.fetchAll("INSERT INTO betterbanktransactions (IBAN, status, amount, time, comingFrom, icon, color) VALUES(@IBAN, @status, @amount, @time, @comingFrom, @icon, @color)",{
			['@IBAN'] = IBAN,
			['@status'] = status,
			['@amount'] = amount,
			['@time'] = time,
			['@comingFrom'] = comingFrom,
			['@icon'] = icon,
			['@color'] = color
		})
	end
end)

ESX.RegisterServerCallback('BetterBank:openForCompany', function(source, cb, IBAN)
	datas = {}
	datas.IBAN = IBAN
	--Get Name
	MySQL.Async.fetchAll('SELECT * FROM betterbankcompanies WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	}, function(result)
		if result[1] ~= nil then
			datas.fullName = result[1].fullName
			datas.currentMoney = result[1].moneyAmount
		else
			cb(nil)
		end
	end)
	--Get Name

	datas.LastTransactions = GetLastTransactions(datas.IBAN, Config.MaxLastTransactions)
	datas.Bills = GetUnPayedBills(datas.IBAN)
	cb(datas)

end)

ESX.RegisterServerCallback('Betterbank:getSourceDatas', function(source, cb)
	datas = {}

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	datas.currentMoney = xPlayer.getAccount('bank').money

	--Get Name
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
	}, function(result)
		if result[1] ~= nil then
			datas.fullName = result[1].firstname .. " " .. result[1].lastname
		else
			cb(nil)
		end
	end)
	--Get Name

	datas.IBAN = CreateOrGetIBAN(_source)
	datas.LastTransactions = GetLastTransactions(datas.IBAN, "20")
	datas.Bills = GetUnPayedBills(datas.IBAN)

    if xPlayer ~= nil then
		cb(datas)
	else 
		cb(nil)
	end
end)

ESX.RegisterServerCallback('Betterbank:tryToPayBill', function(source, cb, data)
	if TransferMoney(data.payerIBAN, data.amount, data.senderIBAN) then 
		MySQL.Async.insert("UPDATE billing SET status = 'Payed' WHERE id = @ID", { 
			['@ID'] = data.id
		})
		TriggerEvent('BetterBank:addTransactionsDB', data.payerIBAN, "Bill", data.editedAmount, data.time, data.senderFullName, "fal fa-file-invoice-dollar", "red", data.amount)
		TriggerEvent('BetterBank:addTransactionsDB', data.senderIBAN, "Bill", data.editedAmount, data.time, data.payerFullName, "fal fa-file-invoice-dollar", "green", data.amount)
		TriggerClientEvent('BetterBank:addTransaction', source, "Bill", data.editedAmount, data.time, data.senderFullName, "fal fa-file-invoice-dollar", "red", data.amount)
		TriggerClientEvent('BetterBank:ShowMessage', source, "fal fa-check-circle", "Succesful.")
		cb(true)
	end
	cb(false)
end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(targetPlayer, sharedAccountName, label, amount)
	local _source = source
	-- sharedAccountName not usefull but don't delete it
	if amount > 0 and IsIBANExist(CreateOrGetIBAN(targetPlayer)) and IsIBANExist(CreateOrGetIBAN(_source)) then
		MySQL.Async.fetchAll("INSERT INTO billing (payerIBAN, senderIBAN, payerFullName, senderFullName, time, label, amount) VALUES(@pIBAN, @sIBAN, @PFM, @SFN, @time, @label, @amount)",{
			['@pIBAN'] = CreateOrGetIBAN(targetPlayer),
			['@sIBAN'] = CreateOrGetIBAN(_source),
			['@PFN'] = GetFullnameFromId(targetPlayer),
			['@SFN'] = GetFullnameFromId(_source),
			['@time'] = GetDateAndTime(),
			['@label'] = label,
			['@amount'] = amount,
		})
	end
end)

function CreateOrGetIBAN(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)


	local result = MySQL.Sync.fetchAll('SELECT IBAN FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	if result[1].IBAN == '0' then 
		while not IsIBANExist() or result[1].IBAN == '0' do
			local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
			local length = 4
			local randomString = 'WR'

			math.randomseed(os.time())

			charTable = {}
			for c in chars:gmatch"." do
				table.insert(charTable, c)
			end

			for i = 1, length do
				randomString = randomString .. charTable[math.random(1, #charTable)]
			end

			MySQL.Async.insert("UPDATE users SET IBAN = @IBAN WHERE identifier = @identifier", { 
				['@IBAN'] = randomString,
				['@identifier'] = xPlayer.identifier
			})
		end
		return result[1].IBAN

	else 
	
		return result[1].IBAN

	end
end

function GetLastTransactions(IBAN, count)
	local result = MySQL.Sync.fetchAll('SELECT * FROM betterbanktransactions WHERE IBAN = @IBAN ORDER BY time ASC LIMIT '.. tostring(count), {
		['@IBAN'] = IBAN
	})
	return result
end

function GetUnPayedBills(IBAN)
	local result = MySQL.Sync.fetchAll("SELECT * FROM billing WHERE payerIBAN = @IBAN AND status = 'Waiting' ORDER BY time ASC", {
		['@IBAN'] = IBAN
	})
	return result
end

function TransferMoney(senderIBAN, amount, targetIBAN)
	if not IsIBANExist(senderIBAN) or not IsIBANExist(targetIBAN) then
		return false
	end
	local isSenderIBANCompany =IsIBANBelongToCompany(senderIBAN)
	local isTargetIBANCompany = IsIBANBelongToCompany(targetIBAN)
	local senderBalance = 0
	local targetBalance = 0
    local targetAccount = {}
	local senderID = nil
	local targetID = nil
	amount = tonumber(amount)
	if isSenderIBANCompany then
		senderBalance = GetCompanyBalance(senderIBAN)
	else
		local senderIdentiier = GetIdentifierFromIBAN(senderIBAN)
		senderID = ESX.GetPlayerFromIdentifier(senderIdentiier)
		if senderID ~= nil then
			senderBalance =senderID.getAccount('bank').money
		end
	end

	if isTargetIBANCompany then
		targetBalance = GetCompanyBalance(targetIBAN)
	else
		local targetIdentiier = GetIdentifierFromIBAN(targetIBAN)
		targetID = ESX.GetPlayerFromIdentifier(targetIdentiier)
		if targetID ~= nil then
			targetBalance =targetID.getAccount('bank').money
		else
			targetAccount = MySQL.Sync.fetchAll('SELECT accounts FROM users WHERE IBAN = @IBAN', {
				['@IBAN'] = targetIBAN,
			})
            targetAccount = json.decode(targetAccount[1].accounts)
			targetBalance = targetAccount["bank"]
		end
	end

	if amount > 0 and amount <= senderBalance then 
		if isSenderIBANCompany then
			senderBalance = senderBalance - amount
			SetCompanyBalance(senderIBAN, senderBalance)

		else
			if senderID ~= nil then
				senderID.removeAccountMoney('bank', amount)
			else
                return false
			end
		end
		if isTargetIBANCompany then
			targetBalance = targetBalance + amount
			SetCompanyBalance(targetIBAN, targetBalance)
		else
			if targetID ~= nil then
				targetID.addAccountMoney('bank', amount)
			else
				targetBalance = targetBalance + amount
                targetAccount["bank"] = targetBalance
				MySQL.Async.insert("UPDATE users SET accounts = @M WHERE IBAN = @IBAN", { 
					['@IBAN'] = targetIBAN,
					['@M'] = json.encode(targetAccount)
				})
			end
		end
	else 
		return false
	end
	return true
end

function GetCompanyBalance(IBAN)
	local result = MySQL.Sync.fetchAll('SELECT moneyAmount FROM betterbankcompanies WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	})
	return result[1].moneyAmount
end

function SetCompanyBalance(IBAN, amount)
	MySQL.Async.insert("UPDATE betterbankcompanies SET moneyAmount = @M WHERE IBAN = @IBAN", { 
		['@IBAN'] = IBAN,
		['@M'] = amount
	})
end

function GetIdentifierFromIBAN(IBAN)
	if not IsIBANExist(IBAN) then
		return nil
	end
	local result = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	})
	return result[1].identifier
end

function IsIBANExist(IBAN)
	local result = MySQL.Sync.fetchAll('SELECT COUNT(*) as count FROM users WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	})
	if result[1].count == 1 then
		return true
	else 
		local result2 = MySQL.Sync.fetchAll('SELECT COUNT(*) as count FROM betterbankcompanies WHERE IBAN = @IBAN', {
			['@IBAN'] = IBAN,
		})
		if result2[1].count == 1 then
			return true
		else
			return false
		end
	end
end

function IsIBANBelongToCompany(IBAN)
	local result = MySQL.Sync.fetchAll('SELECT COUNT(*) as count FROM betterbankcompanies WHERE IBAN = @IBAN', {
		['@IBAN'] = IBAN,
	})
	if result[1].count == 1 then
		return true
	else
		return false
	end
end

function GetFullnameFromId(id) 
	local idIdentifier = ESX.GetPlayerFromId(id)
	local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = idIdentifier.identifier
	})
	return (result[1].firstname .. " " .. result[1].lastname)
end

function GetDateAndTime()
	D = os.date("*t")
	date = tostring(D.day) .. "-" .. tostring(D.month) .. "-" .. tostring(D.year) .. " " .. tostring(D.hour) .. ":" .. tostring(D.min)
	return date
end

AddEventHandler('esx:playerLoaded',function(source)
	CreateOrGetIBAN(source)
end)

RegisterServerEvent('Betterbank:tryToCreateBillForCompany')
AddEventHandler('Betterbank:tryToCreateBillForCompany', function(name, IBAN, money)
	if IsIBANExist(IBAN) and not IsIBANBelongToCompany(IBAN) then
	print("Alert some script is tried to create company iban that alredy using by player")
	elseif not IsIBANExist(IBAN) then
		MySQL.Async.fetchAll("INSERT INTO betterbankcompanies (fullName, IBAN, moneyAmount) VALUES(@name, @iban, @money)",{
			['@name'] = name,
			['@iban'] = IBAN,
			['@money'] = money,
		})
		print("New IBAN is created for a company : " .. name .. " IBAN : " .. IBAN )
	end
end)
