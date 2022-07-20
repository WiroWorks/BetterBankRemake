CREATE TABLE IF NOT EXISTS `betterbankcompanies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `IBAN` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  `moneyAmount` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `betterbanktransactions` (
  `IBAN` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '0',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `amount` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `comingFrom` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `icon` varchar(50) DEFAULT '',
  `color` varchar(10) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

ALTER TABLE `users`
ADD COLUMN `IBAN` VARCHAR(6) NOT NULL DEFAULT '0'