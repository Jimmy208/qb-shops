local QBCore = exports["qb-core"]:GetCoreObject()
local inChips = false
local currentShop, currentData
local pedSpawned = false
local ShopPed = {}

-- Functions
local function createBlips()
    for store, _ in pairs(Config.Locations) do
        if Config.Locations[store]["showblip"] then
            local StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"]["x"], Config.Locations[store]["coords"]["y"], Config.Locations[store]["coords"]["z"])
            SetBlipSprite(StoreBlip, Config.Locations[store]["blipsprite"])
            SetBlipScale(StoreBlip, 0.6)
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.Locations[store]["blipcolor"])
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end

-- Events

local function openShop(shop)
	TriggerEvent("shop:OpenMenu", shop)
end


RegisterNetEvent('shop:OpenMenu', function(shop)
    local shopMenu = {
        {
            header = Lang:t("shop") .." "..shop,
            icon = Config.fontawesome.main_menu1,
            isMenuHeader = true,
        },
        {
            header = Lang:t("buy"),
            txt = "",
            icon = Config.fontawesome.main_menu2,
            params = {
                event = "shop:open",
                args = {
                    shop,
                }
            }
        },
        {
            header = Lang:t("sell"),
            icon = Config.fontawesome.main_menu3,
            txt = "",
            params = {
            event = "shop:sell",
            args = {
                shop,
            }
            }
        },
    }
    shopMenu[#shopMenu + 1] = {
        header = Lang:t("exit_menu"),
        icon = "fa-solid fa-angle-left",
        params = {
            event = "qb-menu:closeMenu",
        }
    }
    exports['qb-menu']:openMenu(shopMenu)
end)

RegisterNetEvent('shop:open', function(shop)  
    local shopopen = {
        {
            header = Lang:t("buy_menu"),
            isMenuHeader = true,
            icon = Config.fontawesome.openshop_target,
        },
    }
    QBCore.Functions.TriggerCallback("shop:checkshop", function(cd)   
    for x,y in pairs(cd) do
        if shop[1] == y.shop and y.weapon == "yes" then
            print()
            QBCore.Functions.TriggerCallback("qb-shops:server:getLicenseStatus", function(Itamount)
                if Itamount > 0 then
                    QBCore.Functions.Notify(Lang:t("success.dealer_verify"), "success")
                    QBCore.Functions.TriggerCallback('shop:getitems', function(cb)
                        for _, data in pairs(cb) do
                            if shop[1] == data.shop then      
                                shopopen[#shopopen + 1] = {           
                                    header = Lang:t("item") .." "..QBCore.Shared.Items[data.item].label,                               
                                    txt = Lang:t("price").." "..data.buy.. "$<br>".. Lang:t("amount").. " "..data.amount,                                     
                                    icon = QBCore.Shared.Items[data.item].image,          
                                    params = {       
                                        event = "shop:client:Buy",
                                        args = {     
                                            price = data.buy,
                                            item = data.item,
                                            amount = data.amount,
                                            shop = shop[1]          
                                        }   
                                    }
                                }
                            end
                    
                        end
                        shopopen[#shopopen + 1] = {
                            header = Lang:t("close_menu"),
                            icon = Config.fontawesome.close_menu,
                            params = {
                                event = "",
                            }
                        }
                        exports['qb-menu']:openMenu(shopopen)
                    end)
                else 
                    QBCore.Functions.Notify(Lang:t("error.dealer_decline"), "error")
                end

            end)
        else           
        if shop[1] == y.shop and y.weapon == "no" then  
                QBCore.Functions.TriggerCallback('shop:getitems', function(cb)               
                    for _, data in pairs(cb) do                        
                        if shop[1] == data.shop then                  
                            shopopen[#shopopen + 1] = {                                  
                                header = Lang:t("item") .." "..QBCore.Shared.Items[data.item].label,                               
                                txt = Lang:t("price").." "..data.buy.. "$<br>".. Lang:t("amount").. " "..data.amount,                                      
                                icon = QBCore.Shared.Items[data.item].image,                 
                                params = {                        
                                    event = "shop:client:Buy",
                                    args = {     
                                        price = data.buy,
                                        item = data.item,
                                        amount = data.amount,
                                        shop = shop[1]                   
                                    }                                           
                                }                                      
                            }                               
                        end                                 
                    end                      
                    shopopen[#shopopen + 1] = {                                   
                        header = Lang:t("close_menu"),                               
                        icon = Config.fontawesome.close_menu,                                 
                        params = {                
                        event = "",
                               
                        }                  
                    }             
                    exports['qb-menu']:openMenu(shopopen)            
                end)      
            end
        end
    end
end)
end)



RegisterNetEvent('shop:client:Buy', function(data)
    local v = exports['qb-input']:ShowInput({
            header = Lang:t("item").." " .. QBCore.Shared.Items[data.item].label .. "<br>".. Lang:t("price") .." " ..data.price.. Lang:t("perone") .."<br>".. Lang:t("amount") .." "..data.amount,
            submitText = Lang:t("in_confirm"),
            inputs = {
                {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Lang:t("in_ammount")
                }
            }
        })
    if v then
        if not v.amount then return end
        TriggerServerEvent("shop:server:Buy", tonumber(v.amount),data)
    end
end)


RegisterNetEvent('shop:sell', function(shop)        
    QBCore.Functions.TriggerCallback('shop:getmoney', function(cdata)               
        for a, v in pairs(cdata) do  
            if shop[1] == v.shop then             
                local sellMenu = { 
                    {
                        header = Lang:t("sell_menu").."<br>"..Lang:t("buyer_account").." "..v.money.."$",
                        isMenuHeader = true,
                        icon = Config.fontawesome.sell_menu,
                    },
           
                }
                QBCore.Functions.TriggerCallback('shop:getitems', function(cb)
                    for _, data in pairs(cb) do
                        if shop[1] == data.shop then
                            sellMenu[#sellMenu + 1] = {
                                header = Lang:t("item").." "..QBCore.Shared.Items[data.item].label,       
                                txt = Lang:t("sell_price").." " ..data.sell.."$",  
                                icon = QBCore.Shared.Items[data.item].image,
                                params = {
                                    event = "shop:client:sell",          
                                    args = {               
                                        price = data.sell,
                                        item = data.item,
                                        shop = shop[1],
                                        money = v.money,
                                        itememount = data.amount
                                    }  
                                }
                            }          
                        end            
                    end           
                    sellMenu[#sellMenu + 1] = {                         
                        header = "Close",                         
                        icon = Config.fontawesome.close_menu,              
                        params = {
                            event = "",        
                        }   
                    }    
                    exports['qb-menu']:openMenu(sellMenu)        
                end)  
            end
        end
    end)
end)


RegisterNetEvent('shop:client:sell', function(data)
    local v = exports['qb-input']:ShowInput({
            header = Lang:t("item").." " .. QBCore.Shared.Items[data.item].label .. "<br>"..Lang:t("sell_price").. " " ..data.price.."$<br>"..Lang:t("buyer_account").." "..data.money.."$",
            submitText = Lang:t("in_confirm"),
            inputs = {
                {
                    type = 'number',
                    isRequired = true,
                    name = 'amount',
                    text = Lang:t("in_ammount")
                }
            }
        })
        if v then
            if not v.amount then return end
            TriggerServerEvent("shop:server:sell", tonumber(v.amount), data)
        end
    end)


local listen = false
local function Listen4Control()
    CreateThread(function()
        listen = true
        while listen do
            if IsControlJustPressed(0, 38) then -- E
                if inChips then
                    exports["qb-core"]:KeyPressed()
                    TriggerServerEvent("qb-shops:server:sellChips")
                else
                    exports["qb-core"]:KeyPressed()
                    openShop(currentShop, currentData)
                end
                listen = false
                break
            end
            Wait(1)
        end
    end)
end

local function createPeds()
    if pedSpawned then return end
    for k, v in pairs(Config.Locations) do
        if not ShopPed[k] then ShopPed[k] = {} end
        local current = v["ped"]
        current = type(current) == 'string' and joaat(current) or current
        RequestModel(current)

        while not HasModelLoaded(current) do
            Wait(0)
        end
        ShopPed[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
        TaskStartScenarioInPlace(ShopPed[k], v["scenario"], true)
        FreezeEntityPosition(ShopPed[k], true)
        SetEntityInvincible(ShopPed[k], true)
        SetBlockingOfNonTemporaryEvents(ShopPed[k], true)

        if Config.UseTarget then
            exports['qb-target']:AddTargetEntity(ShopPed[k], {
                options = {
                    {
                        label = v["targetLabel"],
                        icon = v["targetIcon"],
                        item = v["item"],
                        action = function()
                            openShop(k, Config.Locations[k])
                        end,
                    }
                },
                distance = 2.0
            })
        end
    end

    if not ShopPed["casino"] then ShopPed["casino"] = {} end
    local current = Config.SellCasinoChips.ped
    current = type(current) == 'string' and joaat(current) or current
    RequestModel(current)

    while not HasModelLoaded(current) do
        Wait(0)
    end
    ShopPed["casino"] = CreatePed(0, current, Config.SellCasinoChips.coords.x, Config.SellCasinoChips.coords.y, Config.SellCasinoChips.coords.z-1, Config.SellCasinoChips.coords.w, false, false)
    FreezeEntityPosition(ShopPed["casino"], true)
    SetEntityInvincible(ShopPed["casino"], true)
    SetBlockingOfNonTemporaryEvents(ShopPed["casino"], true)

    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(ShopPed["casino"], {
            options = {
                {
                    label = Lang:t("sell_chops_t"),
                    icon = Config.fontawesome.casino_target,
                    action = function()
                        TriggerServerEvent("qb-shops:server:sellChips")
                    end
                }
            },
            distance = 2.0
        })
    end

    pedSpawned = true
end

local function deletePeds()
    if pedSpawned then
        for _, v in pairs(ShopPed) do
            DeletePed(v)
        end
    end
end

-- Threads

local NewZones = {}
CreateThread(function()
    if not Config.UseTarget then
        for shop, _ in pairs(Config.Locations) do
            NewZones[#NewZones+1] = CircleZone:Create(vector3(Config.Locations[shop]["coords"]["x"], Config.Locations[shop]["coords"]["y"], Config.Locations[shop]["coords"]["z"]), Config.Locations[shop]["radius"], {
                useZ = true,
                debugPoly = false,
                name = shop,
            })
        end

        local combo = ComboZone:Create(NewZones, {name = "RandomZOneName", debugPoly = false})
        combo:onPlayerInOut(function(isPointInside, _, zone)
            if isPointInside then
                currentShop = zone.name
                currentData = Config.Locations[zone.name]
                exports["qb-core"]:DrawText(Lang:t("info.open_shop"))
                Listen4Control()
            else
                exports["qb-core"]:HideText()
                listen = false
            end
        end)

        local sellChips = CircleZone:Create(vector3(Config.SellCasinoChips.coords["x"], Config.SellCasinoChips.coords["y"], Config.SellCasinoChips.coords["z"]), Config.SellCasinoChips.radius, {useZ = true})
        sellChips:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inChips = true
                exports["qb-core"]:DrawText(Lang:t("info.sell_chips"))
            else
                inChips = false
                exports["qb-core"]:HideText()
            end
        end)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createBlips()
    createPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    deletePeds()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createBlips()
        createPeds()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deletePeds()
    end
end)
