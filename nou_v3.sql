-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Eleccions_Grup2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Eleccions_Grup2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Eleccions_Grup2` DEFAULT CHARACTER SET utf8 ;
USE `Eleccions_Grup2` ;

-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`comunitats_autonomes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`comunitats_autonomes` (
  `comunitat_aut_id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`comunitat_aut_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`eleccions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`eleccions` (
  `eleccio_id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL DEFAULT NULL,
  `any` SMALLINT(4) NULL DEFAULT NULL COMMENT 'any el qual s\'han celebrat les eleccions',
  `mes` TINYINT(2) NULL DEFAULT NULL COMMENT 'El mes que s\'han celebrat les eleccions',
  `data` DATE NOT NULL COMMENT 'Data (dia mes i any) de quan s\'han celebrat les eleccions',
  PRIMARY KEY (`eleccio_id`),
  UNIQUE INDEX `uk_eleccions_any_mes` USING BTREE (`any`, `mes`) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`provincies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`provincies` (
  `provincia_id` TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL DEFAULT NULL,
  `comunitat_aut_id` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`provincia_id`),
  INDEX `idx_fk_provincies_comunitats_autonomes` (`comunitat_aut_id` ASC) VISIBLE,
  CONSTRAINT `fk_provincies_comunitats_autonomes`
    FOREIGN KEY (`comunitat_aut_id`)
    REFERENCES `Eleccions_Grup2`.`comunitats_autonomes` (`comunitat_aut_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`municipis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`municipis` (
  `municipi_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(70) NULL DEFAULT NULL,
  `provincia_id` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`municipi_id`),
  INDEX `idx_fk_municipis_provincies1` (`provincia_id` ASC) VISIBLE,
  CONSTRAINT `fk_municipis_provincies`
    FOREIGN KEY (`provincia_id`)
    REFERENCES `Eleccions_Grup2`.`provincies` (`provincia_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`eleccions_municipis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`eleccions_municipis` (
  `eleccio_municipi_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `eleccio_id` TINYINT(3) UNSIGNED NOT NULL,
  `municipi_id` SMALLINT(5) UNSIGNED NOT NULL,
  `num_meses` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `poblacio` INT(10) UNSIGNED NULL DEFAULT NULL,
  `cens` INT(10) UNSIGNED NULL DEFAULT NULL,
  `vots_emesos` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Número total de vots realitzats en el municipi',
  `vots_valids` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Número de vots es que tindran en compte: vots a candidatures + vots nuls',
  `vots_candidatures` INT(10) UNSIGNED NULL DEFAULT NULL,
  `vots_blanc` INT(10) UNSIGNED NULL DEFAULT NULL,
  `vots_nuls` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`eleccio_municipi_id`),
  INDEX `fk_eleccions_municipis_eleccions` (`eleccio_id` ASC) VISIBLE,
  INDEX `fk_eleccions_municipis_municipis` (`municipi_id` ASC) VISIBLE,
  CONSTRAINT `fk_eleccions_municipis_eleccions`
    FOREIGN KEY (`eleccio_id`)
    REFERENCES `Eleccions_Grup2`.`eleccions` (`eleccio_id`),
  CONSTRAINT `fk_eleccions_municipis_municipis`
    FOREIGN KEY (`municipi_id`)
    REFERENCES `Eleccions_Grup2`.`municipis` (`municipi_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`partits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`partits` (
  `partit_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom_llarg` VARCHAR(100) NULL DEFAULT NULL,
  `nom_curt` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`partit_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Eleccions_Grup2`.`eleccions_municipis_partits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Eleccions_Grup2`.`eleccions_municipis_partits` (
  `eleccions_municipis_partits_id` INT NOT NULL AUTO_INCREMENT,
  `municipi_id` SMALLINT(5) UNSIGNED NOT NULL,
  `eleccio_id` TINYINT(3) UNSIGNED NOT NULL,
  `partit_id` SMALLINT(5) UNSIGNED NOT NULL,
  `vots` INT NOT NULL,
  INDEX `fk_eleccions_has_municipis_municipis1_idx` (`municipi_id` ASC) VISIBLE,
  INDEX `fk_eleccions_has_municipis_eleccions1_idx` (`eleccio_id` ASC) VISIBLE,
  PRIMARY KEY (`eleccions_municipis_partits_id`),
  INDEX `fk_eleccions_municipis_partits_partits1_idx` (`partit_id` ASC) VISIBLE,
  CONSTRAINT `fk_eleccions_municipis_partits_municipis`
    FOREIGN KEY (`municipi_id`)
    REFERENCES `Eleccions_Grup2`.`municipis` (`municipi_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_eleccions_municipis_partits_eleccions`
    FOREIGN KEY (`eleccio_id`)
    REFERENCES `Eleccions_Grup2`.`eleccions` (`eleccio_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_eleccions_municipis_partits_partits`
    FOREIGN KEY (`partit_id`)
    REFERENCES `Eleccions_Grup2`.`partits` (`partit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
