local QBCore = exports['qb-core']:GetCoreObject()


local ItemList = {
    ["casinochips"] = 1,
}

RegisterNetEvent('qb-shops:server:sellChips', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem ~= nil then
        for k in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    local price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    
                    Player.Functions.AddMoney("cash", price, "sold-casino-chips")
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.sold_chips").. " " .. price)
                    TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "blue", "**" .. GetPlayerName(src) .. "** ".. Lang:t("log_1") .. " " .. price .. " ".. Lang:t("log_2"))
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_chips"))
    end
end)

QBCore.Functions.CreateCallback('qb-shops:server:getLicenseStatus', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Item = Player.Functions.GetItemByName("weaponlicense")
    local Itamount = Item.amount
    cb(Itamount)
end)

QBCore.Functions.CreateCallback('shop:checkshop', function(source, cd)
    local result = MySQL.query.await('SELECT * FROM shops_data', {})
    cd(result)
end)

QBCore.Functions.CreateCallback('shop:getitems', function(source, cb)
    local result = MySQL.query.await('SELECT * FROM shops', {})
   cb(result)
end)

QBCore.Functions.CreateCallback('shop:getmoney', function(source, cdata)
    local result = MySQL.query.await('SELECT * FROM shops_data', {})
    cdata(result)
end)

RegisterNetEvent("shop:server:Buy", function(amount, data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = amount*data.price
    local playermoney = Player.PlayerData.money['cash']
    if tonumber(data.amount) >= amount then
        if tonumber(playermoney) >= money then
            Player.Functions.RemoveMoney('cash', money)
            Player.Functions.AddItem(data.item, amount)
            TriggerClientEvent('QBCore:Notify', src,Lang:t("success.buy_b").." "..amount.. " "..QBCore.Shared.Items[data.item].label.." "..Lang:t("success.for_b").." "..money.. "$")   
            local result = MySQL.query.await('SELECT * FROM shops_data WHERE shop = ?', {data.shop})
            for a, v in pairs(result) do 
                local amountnew = money + v.money
                MySQL.update('UPDATE shops_data SET money = ? WHERE shop = ?', {amountnew,data.shop})
            end
            local newitemamount = tonumber(data.amount) - amount
            MySQL.update('UPDATE shops SET amount = ? WHERE item = ? AND shop = ?', {newitemamount,data.item,data.shop})
            TriggerEvent("qb-log:server:CreateLog", "shops", "Buy Item"..data.shop, "green", "**" .. GetPlayerName(src) .. "** "..Lang:t("log_3").." " .. amount.. " * " ..data.item.." ".. Lang:t("log_4") .." "..money.."$")
        else
            TriggerClientEvent('QBCore:Notify', src,Lang:t("error.player_no_money"))   
        end
    else
        TriggerClientEvent('QBCore:Notify', src,Lang:t("error.seller_no_item"))
    end
end)

RegisterNetEvent("shop:server:sell", function(amount, data)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Item = Player.Functions.GetItemByName(data.item)
    local money = amount*data.price
    if Item.amount >= amount then   
        if tonumber(data.money) >= money then
            Player.Functions.RemoveItem(data.item, amount)
            Player.Functions.AddMoney('cash', money)
            TriggerClientEvent('QBCore:Notify', src,Lang:t("success.recive_money").." "..money.."$ "..Lang:t("success.recive_money2").. " "..amount.. " " ..QBCore.Shared.Items[data.item].label.."") 
            local amountnew = data.money - money 
            MySQL.update('UPDATE shops_data SET money = ? WHERE shop = ?', {amountnew,data.shop})
            local newitemamount = tonumber(data.itememount) + amount
            MySQL.update('UPDATE shops SET amount = ? WHERE item = ? AND shop = ?', {newitemamount,data.item,data.shop})
            TriggerEvent("qb-log:server:CreateLog", "shops", "Sell Item "..data.shop, "red", "**" .. GetPlayerName(src) .. "** "..Lang:t("log_5").." "  .. amount.. " * " ..data.item.." "..Lang:t("log_6").." "..money.."$")
        else
            TriggerClientEvent('QBCore:Notify', src,Lang:t("error.seller_no_money")) 
        end    
    else
        TriggerClientEvent('QBCore:Notify', src,Lang:t("error.player_no_item")) 
    end
end)
