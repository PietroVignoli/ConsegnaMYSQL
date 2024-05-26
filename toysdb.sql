CREATE TABLE `product` (
  `ProductID` INT NOT NULL,
  `ProductName` VARCHAR(45) NOT NULL,
  `Category` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ProductID`)
);

CREATE TABLE `region` (
  `RegionID` INT NOT NULL,
  `RegionName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`RegionID`)
);

CREATE TABLE `sales` (
  `SalesID` INT NOT NULL,
  `ProductID` INT NOT NULL,
  `RegionID` INT NOT NULL,
  `SaleDate` DATE NOT NULL,
  `Amount` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`SalesID`),
  FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  FOREIGN KEY (`RegionID`) REFERENCES `region` (`RegionID`)
);

-- Inserimento dati
INSERT INTO `product` (`ProductID`, `ProductName`, `Category`) VALUES
(1, 'Monopoli', 'Giochi da Tavolo'),
(2, 'Hasbro', 'Puzzle'),
(3, 'Barbie', 'Bambole');

INSERT INTO `region` (`RegionID`, `RegionName`) VALUES
(1, 'Europa'),
(2, 'Asia'),
(3, 'America');

INSERT INTO `sales` (`SalesID`, `ProductID`, `RegionID`, `SaleDate`, `Amount`) VALUES
(1, 1, 1, '2024-01-01', 100.00),
(2, 2, 1, '2024-02-15', 200.00),
(3, 1, 2, '2024-03-30', 150.00),
(4, 3, 3, '2024-04-20', 300.00);

-- Query verifica PK 
SELECT `ProductID`, COUNT(*) FROM `product` GROUP BY `ProductID` HAVING COUNT(*) > 1;
SELECT `RegionID`, COUNT(*) FROM `region` GROUP BY `RegionID` HAVING COUNT(*) > 1;
SELECT `SalesID`, COUNT(*) FROM `sales` GROUP BY `SalesID` HAVING COUNT(*) > 1;

-- Elenco dei soli prodotti venduti e il fatturato totale per anno
SELECT `product`.`ProductName`, YEAR(`SaleDate`) AS `Year`, SUM(`Amount`) AS `TotalSales`
FROM `sales`
JOIN `product` ON `sales`.`ProductID` = `product`.`ProductID`
GROUP BY `product`.`ProductName`, YEAR(`SaleDate`);

-- Fatturato totale per stato per anno
SELECT `region`.`RegionName`, YEAR(`SaleDate`) AS `Year`, SUM(`Amount`) AS `TotalSales`
FROM `sales`
JOIN `region` ON `sales`.`RegionID` = `region`.`RegionID`
GROUP BY `region`.`RegionName`, YEAR(`SaleDate`)
ORDER BY `Year`, `TotalSales` DESC;

-- Categoria di articoli maggiormente richiesta
SELECT `product`.`Category`, COUNT(`sales`.`SalesID`) AS `TotalSales`
FROM `sales`
JOIN `product` ON `sales`.`ProductID` = `product`.`ProductID`
GROUP BY `product`.`Category`
ORDER BY `TotalSales` DESC
LIMIT 1;

-- Prodotti invenduti 
SELECT `product`.`ProductName`
FROM `product`
WHERE `ProductID` NOT IN (SELECT `ProductID` FROM `sales`);

-- Elenco dei prodotti con la rispettiva ultima data di vendita
SELECT `product`.`ProductName`, MAX(`SaleDate`) AS `LastSaleDate`
FROM `sales`
JOIN `product` ON `sales`.`ProductID` = `product`.`ProductID`
GROUP BY `product`.`ProductName`;
