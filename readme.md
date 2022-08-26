**Shop system include innovations like:**

- Items have their own pool if the player buy item then removes the item from the pool
- Player can sell item if Player sell it then the item goes to the item pool
- If the player buys the item/items money goes to the player that listed item in the shop
- If the sum of the seller’s account is lower than the price for the items the player wants to sell, he will not be able to sell them


**Requirements:**

- Script is working only on the newest qbcore framework
- This script need oxmysql and qb-menu to work properly


**Open shop event:**

shop = Shop name
```lua
TriggerEvent("shop:OpenMenu", shop)
```

**DB schema:**
```sql
CREATE TABLE IF NOT EXISTS `shops` (
  `item` text DEFAULT NULL,
  `buy` varchar(50) DEFAULT NULL,
  `sell` varchar(50) DEFAULT NULL,
  `amount` varchar(50) DEFAULT '100',
  `shop` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `shops_data` (
  `shop` varchar(50) NOT NULL,
  `money` varchar(50) DEFAULT '2000',
  `weapon` text DEFAULT 'no',
  PRIMARY KEY (`shop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
``