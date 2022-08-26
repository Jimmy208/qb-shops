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