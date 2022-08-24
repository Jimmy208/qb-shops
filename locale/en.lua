local Translations = {
    info = {
        open_shop = "[E] Shop",
        sell_chips = "[E] Sell Chips"
    },
    error = {
        dealer_decline = "The dealer declines to show you firearms",
        no_chips = "You have no chips..",
        player_no_money = "You don't have that much money",
        player_no_item = "You don't have that many items",
        seller_no_item = "The seller does not have that much stock",
        seller_no_money = "The merchant has no money",
    },
    success = {
        dealer_verify = "The dealer verifies your license",
        sold_chips = "You sold your chips for $",
        buy_b = "You bought",
        for_b = "for",
        recive_money = "You have received:",
        recive_money2 = "for"
    },
    shop = "Shop:",
    buy = "Buy",
    sell = "Sell",
    buy_menu = "Buy menu:",
    item = "Item:",
    price = "Price:",
    amount = "Amount:",
    perone = " $/per one",
    sell_menu = "Sell Menu:",
    buyer_account = "Buyer Account:",
    sell_price = "Sell Price:",

    sell_chops_t = "Sell Chips",

    in_confirm = "Confirm",
    in_ammount = "Amount",

    close_menu = "Close",
    exit_menu = "Exit",

    --TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "blue", "**" .. GetPlayerName(src) .. "** got $" .. price .. " for selling the Chips")
    log_1 = "got $",
    log_2 = "for selling the Chips",
    --TriggerEvent("qb-log:server:CreateLog", "shops", "Buy Item "..data.shop, "green", "**" .. GetPlayerName(src) .. "** bought " .. amount.. " * " ..data.item.." for "..money.."$")
    log_3 = "bought",
    log_4 = "for",
    --TriggerEvent("qb-log:server:CreateLog", "shops", "Sell Item "..data.shop, "red", "**" .. GetPlayerName(src) .. "** sell " .. amount.. " * " ..data.item.." for "..money.."$")
    log_5 = "sell",
    log_6 = "for"
}

Lang = Locale:new({phrases = Translations})
