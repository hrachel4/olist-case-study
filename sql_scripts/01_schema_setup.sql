-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema olist_intelligence
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema olist_intelligence
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `olist_intelligence` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `olist_intelligence` ;

-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_customers_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_customers_dataset` (
  `customer_id` VARCHAR(100) NOT NULL,
  `customer_unique_id` VARCHAR(100) NULL,
  `customer_zip_code_prefix` VARCHAR(10) NULL DEFAULT NULL,
  `customer_city` VARCHAR(100) NULL DEFAULT NULL,
  `customer_state` VARCHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_geolocation_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_geolocation_dataset` (
  `geolocation_zip_code_prefix` VARCHAR(10) NULL DEFAULT NULL,
  `geolocation_lat` DOUBLE NULL DEFAULT NULL,
  `geolocation_lng` DOUBLE NULL DEFAULT NULL,
  `geolocation_city` TEXT NULL DEFAULT NULL,
  `geolocation_state` VARCHAR(10) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_orders_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_orders_dataset` (
  `order_id` VARCHAR(100) NOT NULL,
  `customer_id` VARCHAR(100) NULL DEFAULT NULL,
  `order_status` VARCHAR(50) NULL DEFAULT NULL,
  `order_purchase_timestamp` VARCHAR(50) NULL DEFAULT NULL,
  `order_approved_at` VARCHAR(50) NULL DEFAULT NULL,
  `order_delivered_carrier_date` VARCHAR(50) NULL DEFAULT NULL,
  `order_delivered_customer_date` VARCHAR(50) NULL DEFAULT NULL,
  `order_estimated_delivery_date` VARCHAR(50) NULL DEFAULT NULL,
  `olist_customers_dataset_customer_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_olist_orders_dataset_olist_customers_dataset_idx` (`olist_customers_dataset_customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_olist_orders_dataset_olist_customers_dataset`
    FOREIGN KEY (`olist_customers_dataset_customer_id`)
    REFERENCES `olist_intelligence`.`olist_customers_dataset` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`product_category_name_translation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`product_category_name_translation` (
  `product_category_name` TEXT NOT NULL,
  `product_category_name_english` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`product_category_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/hanna/Downloads/OLIST/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_products_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_products_dataset` (
  `product_id` VARCHAR(100) NOT NULL,
  `product_category_name` TEXT NULL DEFAULT NULL,
  `product_name_lenght` INT NULL DEFAULT NULL,
  `product_description_lenght` INT NULL DEFAULT NULL,
  `product_photos_qty` INT NULL DEFAULT NULL,
  `product_weight_g` INT NULL DEFAULT NULL,
  `product_length_cm` INT NULL DEFAULT NULL,
  `product_height_cm` INT NULL DEFAULT NULL,
  `product_width_cm` INT NULL DEFAULT NULL,
  `product_category_name_translation_product_category_name` TEXT NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `fk_olist_products_dataset_product_category_name_translation_idx` (`product_category_name_translation_product_category_name` ASC) VISIBLE,
  CONSTRAINT `fk_olist_products_dataset_product_category_name_translation1`
    FOREIGN KEY (`product_category_name_translation_product_category_name`)
    REFERENCES `olist_intelligence`.`product_category_name_translation` (`product_category_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- 2. Import the data
LOAD DATA LOCAL INFILE '/Users/Shared/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_sellers_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_sellers_dataset` (
  `seller_id` VARCHAR(100) NOT NULL,
  `seller_zip_code_prefix` VARCHAR(10) NULL DEFAULT NULL,
  `seller_city` TEXT NULL DEFAULT NULL,
  `seller_state` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`seller_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_order_items_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_order_items_dataset` (
  `order_id` VARCHAR(100) NOT NULL,
  `order_item_id` INT NOT NULL,
  `product_id` VARCHAR(100) NULL DEFAULT NULL,
  `seller_id` VARCHAR(100) NULL DEFAULT NULL,
  `shipping_limit_date` DATETIME NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  `freight_value` DECIMAL(10,2) NULL DEFAULT NULL,
  `olist_orders_dataset_order_id` VARCHAR(100) NOT NULL,
  `olist_products_dataset_product_id` VARCHAR(100) NOT NULL,
  `olist_sellers_dataset_seller_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`order_item_id`, `order_id`),
  INDEX `fk_olist_order_items_dataset_olist_orders_dataset1_idx` (`olist_orders_dataset_order_id` ASC) VISIBLE,
  INDEX `fk_olist_order_items_dataset_olist_products_dataset1_idx` (`olist_products_dataset_product_id` ASC) VISIBLE,
  INDEX `fk_olist_order_items_dataset_olist_sellers_dataset1_idx` (`olist_sellers_dataset_seller_id` ASC) VISIBLE,
  CONSTRAINT `fk_olist_order_items_dataset_olist_orders_dataset1`
    FOREIGN KEY (`olist_orders_dataset_order_id`)
    REFERENCES `olist_intelligence`.`olist_orders_dataset` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_olist_order_items_dataset_olist_products_dataset1`
    FOREIGN KEY (`olist_products_dataset_product_id`)
    REFERENCES `olist_intelligence`.`olist_products_dataset` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_olist_order_items_dataset_olist_sellers_dataset1`
    FOREIGN KEY (`olist_sellers_dataset_seller_id`)
    REFERENCES `olist_intelligence`.`olist_sellers_dataset` (`seller_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_order_payments_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_order_payments_dataset` (
  `order_id` VARCHAR(100) NOT NULL,
  `payment_sequential` INT NULL,
  `payment_type` VARCHAR(50) NULL DEFAULT NULL,
  `payment_installments` INT NULL DEFAULT NULL,
  `payment_value` DECIMAL(15,2) NULL DEFAULT NULL,
  `olist_orders_dataset_order_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `fk_olist_order_payments_dataset_olist_orders_dataset1_idx` (`olist_orders_dataset_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_olist_order_payments_dataset_olist_orders_dataset1`
    FOREIGN KEY (`olist_orders_dataset_order_id`)
    REFERENCES `olist_intelligence`.`olist_orders_dataset` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/Shared/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Table `olist_intelligence`.`olist_order_reviews_dataset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `olist_intelligence`.`olist_order_reviews_dataset` (
  `review_id` VARCHAR(100) NOT NULL,
  `order_id` VARCHAR(100) NULL DEFAULT NULL,
  `review_score` INT NULL DEFAULT NULL,
  `review_comment_title` VARCHAR(255) NULL DEFAULT NULL,
  `review_comment_message` TEXT NULL DEFAULT NULL,
  `review_creation_date` DATETIME NULL DEFAULT NULL,
  `review_answer_timestamp` DATETIME NULL DEFAULT NULL,
  `olist_orders_dataset_order_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`review_id`),
  INDEX `fk_olist_order_reviews_dataset_olist_orders_dataset1_idx` (`olist_orders_dataset_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_olist_order_reviews_dataset_olist_orders_dataset1`
    FOREIGN KEY (`olist_orders_dataset_order_id`)
    REFERENCES `olist_intelligence`.`olist_orders_dataset` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE '/Users/hanna/Downloads/OLIST/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews_dataset
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
IGNORE 1 ROWS;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
