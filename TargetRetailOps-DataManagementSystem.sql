-- MySQL Workbench Forward Engineering

-- Save current values of system variables
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET @OLD_SQL_MODE=@@SQL_MODE;

-- Disable unique checks and foreign key checks
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;

-- Set SQL mode to the desired value
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema TargetDB
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `TargetDB` DEFAULT CHARACTER SET utf8 ;
USE `TargetDB` ;

-- -----------------------------------------------------
-- Table `TargetDB`.`Discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Discount` (
  `Discount_ID` INT NOT NULL,
  `Discount_Name` VARCHAR(45) NULL,
  `Discount_Type` VARCHAR(45) NULL,
  `Discount_Amount` VARCHAR(45) NULL,
  `Applicable_Products` VARCHAR(45) NULL,
  `Start_Date` VARCHAR(45) NULL,
  `End_Date` VARCHAR(45) NULL,
  `Product_ID` INT NULL,
  PRIMARY KEY (`Discount_ID`),
  INDEX `fk_Discount_Product_idx` (`Product_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Discount_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Product` (
  `Product_ID` INT NOT NULL,
  `Product_Name` VARCHAR(45) NULL,
  `Category` VARCHAR(45) NULL,
  `Price` FLOAT NULL,
  `Description` VARCHAR(255) NULL,
  PRIMARY KEY (`Product_ID`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Customer` (
  `Customer_ID` INT NOT NULL,
  `Customer_Type` VARCHAR(45) NULL,
  PRIMARY KEY (`Customer_ID`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Member`
-- -----------------------------------------------------
-- Corrected Member table creation
CREATE TABLE IF NOT EXISTS `TargetDB`.`Member` (
  `First_Name` VARCHAR(45) NULL,
  `Last_Name` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,  -- Corrected data type to VARCHAR(45)
  `Customer_ID` INT NOT NULL,
  PRIMARY KEY (`Customer_ID`),
  CONSTRAINT `fk_Member_Customer`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `TargetDB`.`Customer` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Non_Member`
-- -----------------------------------------------------
-- Corrected Non_Member table creation
CREATE TABLE IF NOT EXISTS `TargetDB`.`Non_Member` (
  `Contact_Number` VARCHAR(45) NULL,  -- Changed data type to VARCHAR(45)
  `Customer_ID` INT NOT NULL,
  PRIMARY KEY (`Customer_ID`),
  CONSTRAINT `fk_Non_Member_Customer`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `TargetDB`.`Customer` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Supplier` (
  `Supplier_ID` INT NOT NULL,
  `Supplier_Name` VARCHAR(45) NULL,
  `Contact_Name` VARCHAR(45) NULL,
  `Contact_Email` VARCHAR(45) NULL,
  `Contact_Phone` VARCHAR(45) NULL,
  PRIMARY KEY (`Supplier_ID`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Inventory` (
  `Inventory_ID` INT NOT NULL,
  `QTY_in_Stock` VARCHAR(45) NULL,
  `Reorder_Level` VARCHAR(45) NULL,
  `Last_Restocked_Date` VARCHAR(45) NULL,
  PRIMARY KEY (`Inventory_ID`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Store` (
  `Store_ID` INT NOT NULL,
  `Store_Name` VARCHAR(45) NULL,
  `Store_Address` VARCHAR(45) NULL,
  `Store_City` VARCHAR(45) NULL,
  `State` VARCHAR(45) NULL,
  `Zip_Code` INT NULL,
  `Store_Contact` VARCHAR(45) NULL,
  `Inventory_ID` INT NULL,
  PRIMARY KEY (`Store_ID`),
  INDEX `fk_Store_Inventory_idx` (`Inventory_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Store_Inventory`
    FOREIGN KEY (`Inventory_ID`)
    REFERENCES `TargetDB`.`Inventory` (`Inventory_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TargetDB`.`Online_Sale`
-- -----------------------------------------------------
-- Create Online_Sale subtype
CREATE TABLE IF NOT EXISTS `TargetDB`.`Online_Sale` (
  `Sale_ID` INT NOT NULL,
  `Website` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Sale_ID`),
  CONSTRAINT `fk_Online_Sale_Sale`
    FOREIGN KEY (`Sale_ID`)
    REFERENCES `TargetDB`.`Sales` (`Sale_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Instore_Sale`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `TargetDB`.`Instore_Sale` (
  `Sale_ID` INT NOT NULL,
  `Store_Location` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Sale_ID`),
  CONSTRAINT `fk_Instore_Sale_Sale`
    FOREIGN KEY (`Sale_ID`)
    REFERENCES `TargetDB`.`Sales` (`Sale_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TargetDB`.`Sales`
-- -----------------------------------------------------
-- Create Sales table with Sale_Type and subtypes
CREATE TABLE IF NOT EXISTS `TargetDB`.`Sales` (
  `Sale_ID` INT NOT NULL,
  `Quantity` INT NULL,
  `Total_Sales` FLOAT NULL,
  `Product_Category` VARCHAR(45) NULL,
  `Product_ID` INT NOT NULL,
  `Discount_ID` INT NOT NULL,
  `Sale_Type` ENUM('Online', 'Instore') NOT NULL,
  PRIMARY KEY (`Sale_ID`),
  INDEX `fk_Sales_Product_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Sales_Discount_idx` (`Discount_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Sales_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sales_Discount`
    FOREIGN KEY (`Discount_ID`)
    REFERENCES `TargetDB`.`Discount` (`Discount_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Orders` (
  `Order_ID` INT NOT NULL,
  `Order_Date` VARCHAR(45) NULL,
  `Ship_Date` VARCHAR(45) NULL,
  `Customer_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  `Store_ID` INT NOT NULL,
  PRIMARY KEY (`Order_ID`),
  INDEX `fk_Orders_Customer_idx` (`Customer_ID` ASC) VISIBLE,
  INDEX `fk_Orders_Product_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Orders_Store_idx` (`Store_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Customer`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `TargetDB`.`Customer` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Store`
    FOREIGN KEY (`Store_ID`)
    REFERENCES `TargetDB`.`Store` (`Store_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `TargetDB`.`Product_Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Product_Supplier` (
  `Product_ID` INT NOT NULL,
  `Supplier_ID` INT NOT NULL,
  PRIMARY KEY (`Product_ID`, `Supplier_ID`),
  INDEX `fk_Product_Supplier_Product_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Product_Supplier_Supplier_idx` (`Supplier_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Supplier_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Supplier_Supplier`
    FOREIGN KEY (`Supplier_ID`)
    REFERENCES `TargetDB`.`Supplier` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TargetDB`.`Product_Inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `TargetDB`.`Product_Inventory` (
  `Product_ID` INT NOT NULL,
  `Inventory_ID` INT NOT NULL,
  PRIMARY KEY (`Product_ID`, `Inventory_ID`),
  INDEX `fk_Product_Inventory_Product_idx` (`Product_ID` ASC) VISIBLE,
  INDEX `fk_Product_Inventory_Inventory_idx` (`Inventory_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Inventory_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Product_Inventory_Inventory`
    FOREIGN KEY (`Inventory_ID`)
    REFERENCES `TargetDB`.`Inventory` (`Inventory_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `TargetDB`.`Store_Product`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `TargetDB`.`Store_Product` (
  `Store_ID` INT NOT NULL,
  `Product_ID` INT NOT NULL,
  PRIMARY KEY (`Store_ID`, `Product_ID`),
  INDEX `fk_Store_Product_Store_idx` (`Store_ID` ASC) VISIBLE,
  INDEX `fk_Store_Product_Product_idx` (`Product_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Store_Product_Store`
    FOREIGN KEY (`Store_ID`)
    REFERENCES `TargetDB`.`Store` (`Store_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Store_Product_Product`
    FOREIGN KEY (`Product_ID`)
    REFERENCES `TargetDB`.`Product` (`Product_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;


-- Set back the original values of system variables
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET SQL_MODE=@OLD_SQL_MODE;


-- Insert data into Discount table
INSERT INTO TargetDB.Discount (Discount_ID, Discount_Name, Discount_Type, Discount_Amount, Applicable_Products, Start_Date, End_Date, Product_ID)
VALUES (1, 'Discount 1', 'Percentage', '10%', 'All', '2023-01-01', '2023-01-31',1),
       (2, 'Discount 2', 'Percentage', '20%', 'All', '2023-02-01', '2023-02-28', 2),
       (3, 'Discount 3', 'Percentage', '15%', 'All', '2023-03-01', '2023-03-31',3),
       (4, 'Discount 4', 'Percentage', '25%', 'All', '2023-04-01', '2023-04-30',4),
       (5, 'Discount 5', 'Percentage', '30%', 'All', '2023-05-01', '2023-05-31',5),
       (6, 'Discount 6', 'Percentage', '12%', 'All', '2023-06-01', '2023-06-30',6),
       (7, 'Discount 7', 'Percentage', '18%', 'All', '2023-07-01', '2023-07-31',7),
       (8, 'Discount 8', 'Percentage', '22%', 'All', '2023-08-01', '2023-08-31',8),
       (9, 'Discount 9', 'Percentage', '28%', 'All', '2023-09-01', '2023-09-30',9),
       (10, 'Discount 10', 'Percentage', '15%', 'All', '2023-10-01', '2023-10-31',10);

-- Insert data into Store table
INSERT INTO TargetDB.Store (Store_ID, Store_Name, Store_Address, Store_City, State, Zip_Code, Store_Contact,Inventory_ID)
VALUES (1, 'Store1', '123 Main St', 'City1', 'State1', 12345, '987-654-3210',1),
       (2, 'Store2', '456 Oak St', 'City2', 'State2', 67890, '123-456-7890',2),
       (3, 'Store3', '789 Pine St', 'City3', 'State3', 10111, '345-678-9012',3),
       (4, 'Store4', '111 Elm St', 'City4', 'State4', 20222, '567-890-1234',4),
       (5, 'Store5', '222 Maple St', 'City5', 'State5', 30333, '789-012-3456',5),
       (6, 'Store6', '333 Birch St', 'City6', 'State6', 40444, '890-123-4567',6),
       (7, 'Store7', '444 Cedar St', 'City7', 'State7', 50555, '901-234-5678',7),
       (8, 'Store8', '555 Pine St', 'City8', 'State8', 60666, '234-567-8901',8),
       (9, 'Store9', '666 Oak St', 'City9', 'State9', 70777, '345-678-9012',9),
       (10, 'Store10', '777 Maple St', 'City10', 'State10', 80888, '456-789-0123',10);
-- Insert data into Supplier table
INSERT INTO TargetDB.Supplier (Supplier_ID, Supplier_Name, Contact_Name, Contact_Email, Contact_Phone)
VALUES (1, 'Supplier X', 'John Smith', 'john@example.com', '123-456-7890'),
       (2, 'Supplier Y', 'Jane Doe', 'jane@example.com', '987-654-3210'),
       (3, 'Supplier Z', 'Alice Johnson', 'alice@example.com', '234-567-8901'),
       (4, 'Supplier W', 'Bob Williams', 'bob@example.com', '345-678-9012'),
       (5, 'Supplier P', 'Eva Brown', 'eva@example.com', '456-789-0123'),
       (6, 'Supplier Q', 'Charlie Lee', 'charlie@example.com', '567-890-1234'),
       (7, 'Supplier R', 'Grace Martin', 'grace@example.com', '678-901-2345'),
       (8, 'Supplier S', 'David Jones', 'david@example.com', '789-012-3456'),
       (9, 'Supplier T', 'Sophia Miller', 'sophia@example.com', '890-123-4567'),
       (10, 'Supplier U', 'Samuel Taylor', 'samuel@example.com', '901-234-5678');

-- Insert data into Product table
INSERT INTO TargetDB.Product (Product_ID, Product_Name, Category, Price, Description)
VALUES (1, 'Laptop', 'Electronics', 1000.00, 'Large'),
       (2, 'T-Shirt', 'Clothing', 20.00, 'Medium' ),
       (3, 'Smartphone', 'Electronics', 800.00, 'Medium'),
       (4, 'Jeans', 'Clothing', 50.00, 'Large'),
       (5, 'Headphones', 'Electronics', 80.00, 'Small'),
       (6, 'Dress', 'Clothing', 40.00, 'Medium'),
       (7, 'Tablet', 'Electronics', 300.00, 'Medium'),
       (8, 'Sweater', 'Clothing', 35.00, 'Large'),
       (9, 'Camera', 'Electronics', 500.00, 'Small'),
       (10, 'Shoes', 'Clothing', 60.00, 'Medium');

-- Insert data into Inventory table
INSERT INTO TargetDB.Inventory (Inventory_ID, QTY_in_Stock, Reorder_Level, Last_Restocked_Date)
VALUES (1, 100, 'Low', '2022-12-01'),
       (2, 50, 'Medium', '2022-12-01'),
       (3, 80, 'High', '2022-12-01'),
       (4, 30, 'Low', '2022-12-01'),
       (5, 70, 'Medium', '2022-12-01'),
       (6, 40, 'High', '2022-12-01'),
       (7, 60, 'Medium', '2022-12-01'),
       (8, 25, 'Low', '2022-12-01'),
       (9, 45, 'Medium', '2022-12-01'),
       (10, 55, 'High', '2022-12-01');

-- Insert data into Customer table
INSERT INTO TargetDB.Customer (Customer_ID, Customer_Type)
VALUES (1, 'Member'),
       (2, 'Non-Member'),
       (3, 'Member'),
       (4, 'Non-Member'),
       (5, 'Member'),
       (6, 'Non-Member'),
       (7, 'Member'),
       (8, 'Non-Member'),
       (9, 'Member'),
       (10, 'Non-Member'),
       (11, 'Non-Member'),  -- Added missing entries for Non-Members
       (12, 'Non-Member'),
       (13, 'Non-Member'),
       (14, 'Non-Member'),
       (15, 'Non-Member'),
       (16, 'Non-Member'),
       (17, 'Non-Member'),
       (18, 'Non-Member'),
       (19, 'Non-Member'),
       (20, 'Non-Member');

-- Insert data into Member table
INSERT INTO TargetDB.Member (First_Name, Last_Name, Email, Customer_ID)
VALUES ('John', 'Doe', 'john@example.com', 1),
       ('Jane', 'Smith', 'jane@example.com', 3),  
       ('Alice', 'Johnson', 'alice@example.com', 5),
       ('Bob', 'Williams', 'bob@example.com', 7),
       ('Eva', 'Brown', 'eva@example.com', 9),
       ('Charlie', 'Lee', 'charlie@example.com', 11),  
       ('Grace', 'Martin', 'grace@example.com', 13),  
       ('David', 'Jones', 'david@example.com', 15),  
       ('Sophia', 'Miller', 'sophia@example.com', 17), 
       ('Samuel', 'Taylor', 'samuel@example.com', 19); 

-- Insert data into Non_Member table
INSERT INTO TargetDB.Non_Member (Contact_Number, Customer_ID)
VALUES (1234567890, 2),  
       (9876543210, 4),   
       (3456789012, 6),   
       (5678901234, 8),   
       (7890123456, 10),  
       (2345678901, 12),  
       (4567890123, 14),  
       (6789012345, 16),  
       (8901234567, 18),  
       (9012345678, 20);  

-- Insert data into Orders table
INSERT INTO TargetDB.Orders (Order_ID, Order_Date, Ship_Date, Customer_ID, Product_ID, Store_ID)
VALUES (1, '2023-01-15', '2023-01-20', 1, 1, 1),
       (2, '2023-02-01', '2023-02-05', 2, 2, 2),
       (3, '2023-03-12', '2023-03-18', 3, 3, 3),
       (4, '2023-04-05', '2023-04-10', 4, 4, 4),
       (5, '2023-05-20', '2023-05-25', 5, 5, 5),
       (6, '2023-06-08', '2023-06-13', 6, 6, 6),
       (7, '2023-07-19', '2023-07-24', 7, 7, 7),
       (8, '2023-08-03', '2023-08-08', 8, 8, 8),
       (9, '2023-09-22', '2023-09-27', 9, 9, 9),
       (10, '2023-10-10', '2023-10-15', 10, 10, 10);


-- Insert data into Sales table
INSERT INTO TargetDB.Sales (Sale_ID, Quantity, Total_Sales, Sale_Type, Product_Category, Product_ID, Discount_ID)
VALUES (1, 5, 5000.00, 'Online', 'Electronics', 1, 1),
       (2, 10, 300.00, 'Online', 'Clothing', 2, 2),
       (3, 8, 2400.00, 'Online', 'Electronics', 3, 3),
       (4, 15, 750.00, 'Online', 'Clothing', 4, 4),
       (5, 3, 240.00, 'Online', 'Electronics', 5, 5),
       (6, 12, 480.00, 'Instore', 'Clothing', 6, 6),
       (7, 7, 2100.00, 'Instore', 'Electronics', 7, 7),
       (8, 20, 700.00, 'Instore', 'Clothing', 8, 8),
       (9, 6, 3000.00, 'Instore', 'Electronics', 9, 9),
       (10, 18, 1080.00, 'Instore', 'Clothing', 10, 10);

-- Insert data into Instore_Sale table
INSERT INTO TargetDB.Instore_Sale (Sale_ID, Store_Location)
VALUES (6, 'New York, NY'),
       (7, 'Los Angeles, CA'),
       (8, 'Chicago, IL'),
       (9, 'Houston, TX'),
       (10, 'Phoenix, AZ');

-- Insert data into Online_Sale table
INSERT INTO TargetDB.Online_Sale (Sale_ID, Website)
VALUES (1, 'https://www.targettechmart.com'),
       (2, 'https://www.targetfashionhub.com'),
       (3, 'https://www.targetelectronicsdepot.com'),
       (4, 'https://www.targetstyleemporium.com'),
       (5, 'https://www.targetgadgetgalaxy.net');


-- Insert data into Product_Supplier table
INSERT INTO TargetDB.Product_Supplier (Product_ID, Supplier_ID)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (3, 1),
    (3, 2),
    (4, 1),
    (4, 2),
    (5, 1),
    (5, 2);
    


-- Insert into `Store_Product`
INSERT INTO `TargetDB`.`Store_Product` (`Store_ID`, `Product_ID`)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10);
  
-- Insert into `Product_Inventory`
INSERT INTO `TargetDB`.`Product_Inventory` (`Product_ID`, `Inventory_ID`)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10);
  
  
SHOW TABLES;
-- Display values for each table
SELECT * FROM TargetDB.Customer;
SELECT * FROM TargetDB.Member;
SELECT * FROM TargetDB.Non_Member;
SELECT * FROM TargetDB.Orders;
SELECT * FROM TargetDB.Discount;
SELECT * FROM TargetDB.Product;
SELECT * FROM TargetDB.Inventory;
SELECT * FROM TargetDB.Product_Inventory;
SELECT * FROM TargetDB.Supplier;
SELECT * FROM TargetDB.Product_Supplier;
SELECT * FROM TargetDB.Store;
SELECT * FROM TargetDB.Store_Product;
SELECT * FROM TargetDB.Sales;
SELECT * FROM TargetDB.Instore_Sale;
SELECT * FROM TargetDB.Online_Sale;



