CREATE TABLE IF NOT EXISTS `betterbankcompanies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `IBAN` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  `moneyAmount` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

DELETE FROM `betterbankcompanies`;
INSERT INTO `betterbankcompanies` (`id`, `fullName`, `IBAN`, `moneyAmount`) VALUES
	(1, 'Vehicle Store', 'WRCCCC', 11697),
	(2, 'Police Station', 'WRVVVV', 19111);

CREATE TABLE IF NOT EXISTS `betterbanktransactions` (
  `IBAN` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `amount` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `comingFrom` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `icon` varchar(50) DEFAULT '',
  `color` varchar(10) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELETE FROM `betterbanktransactions`;
INSERT INTO `betterbanktransactions` (`IBAN`, `status`, `amount`, `time`, `comingFrom`, `icon`, `color`) VALUES
	('WRWRWR', 'Bill', '$12.000,00', '17-07-2022 15:48', 'Mr. Yusuf', 'fal fa-file-invoice-dollar', 'red'),
	('WRXXXX', 'Bill', '$12.000,00', '17-07-2022 15:48', 'Wiro', 'fal fa-file-invoice-dollar', 'green'),
	('WRCCCC', 'Deposit', '$1.221,00', '17-07-2022 22:06', '', 'fal fa-chart-line', 'green'),
	('WRCCCC', 'Deposit', '$3.112,00', '17-07-2022 22:09', '', 'fal fa-chart-line', 'green'),
	('WRCCCC', 'Withdraw', '$1.312,00', '17-07-2022 22:14', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Withdraw', '$1.312,00', '17-07-2022 22:14', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Withdraw', '$1.312,00', '17-07-2022 22:14', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Withdraw', '$3.211,00', '17-07-2022 22:14', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Withdraw', '$3.211,00', '17-07-2022 22:15', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Withdraw', '$3.211,00', '17-07-2022 22:15', '', 'fal fa-chart-line-down', 'red'),
	('WRCCCC', 'Deposit', '$1.111,00', '17-07-2022 22:16', '', 'fal fa-chart-line', 'green'),
	('WRCCCC', 'Transfer', '$1.111,00', '17-07-2022 22:26', 'Police Station - WRVVVV', 'fal fa-exchange', 'red'),
	('WRVVVV', 'Transfer', '$1.111,00', '17-07-2022 22:26', 'Vehicle Store - WRCCCC', 'fal fa-exchange', 'green'),
	('WRCCCC', 'Transfer', '$1.111,00', '17-07-2022 22:27', 'Police Station - WRVVVV', 'fal fa-exchange', 'red'),
	('WRVVVV', 'Transfer', '$1.111,00', '17-07-2022 22:27', 'Vehicle Store - WRCCCC', 'fal fa-exchange', 'green'),
	('WRCCCC', 'Transfer', '$1.111,00', '17-07-2022 22:28', 'Police Station - WRVVVV', 'fal fa-exchange', 'red'),
	('WRVVVV', 'Transfer', '$1.111,00', '17-07-2022 22:28', 'Vehicle Store - WRCCCC', 'fal fa-exchange', 'green'),
	('WRVVVV', 'Transfer', '$1.111,00', '17-07-2022 22:29', 'kral kral - WRWRWR', 'fal fa-exchange', 'red'),
	('WRWRWR', 'Transfer', '$1.111,00', '17-07-2022 22:29', 'Police Station - WRVVVV', 'fal fa-exchange', 'green'),
	('WRWRWR', 'Transfer', '$30.000,00', '17-07-2022 22:29', 'Police Station - WRVVVV', 'fal fa-exchange', 'red'),
	('WRVVVV', 'Transfer', '$30.000,00', '17-07-2022 22:29', 'kral kral - WRWRWR', 'fal fa-exchange', 'green'),
	('WRVVVV', 'Transfer', '$12.000,00', '17-07-2022 22:30', 'Vehicle Store - WRCCCC', 'fal fa-exchange', 'red'),
	('WRCCCC', 'Transfer', '$12.000,00', '17-07-2022 22:30', 'Police Station - WRVVVV', 'fal fa-exchange', 'green'),
	('WRCCCC', 'Transfer', '$1.111,00', '17-07-2022 22:30', 'kral kral - WRWRWR', 'fal fa-exchange', 'red'),
	('WRWRWR', 'Transfer', '$1.111,00', '17-07-2022 22:30', 'Vehicle Store - WRCCCC', 'fal fa-exchange', 'green'),
	('WRWRWR', 'Deposit', '$1.111,00', '17-07-2022 22:34', '', 'fal fa-chart-line', 'green'),
	('WRWRWR', 'Deposit', '$1.111,00', '17-07-2022 22:41', '', 'fal fa-chart-line', 'green'),
	('WRWRWR', 'Withdraw', '$1.111,00', '17-07-2022 22:41', '', 'fal fa-chart-line-down', 'red');

CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payerIBAN` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `senderIBAN` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `payerFullName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `senderFullName` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `time` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `amount` int(11) NOT NULL,
  `status` varchar(40) COLLATE utf8mb4_bin NOT NULL DEFAULT 'Waiting',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

DELETE FROM `billing`;
INSERT INTO `billing` (`id`, `payerIBAN`, `senderIBAN`, `payerFullName`, `senderFullName`, `time`, `label`, `amount`, `status`) VALUES
	(36, 'WRWRWR', 'WRXXXX', 'Wiro', 'Mr. Yusuf', '17-07-2022 15:48', 'ceza', 12000, 'Payed');

ALTER TABLE `users`
ADD COLUMN `IBAN` VARCHAR(6) NOT NULL DEFAULT '0'