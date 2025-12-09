-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`empresa` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `STATUS` VARCHAR(20) NOT NULL,
  `TIPO_EMPRESA` VARCHAR(50) NOT NULL,
  `CNPJ` VARCHAR(14) NOT NULL,
  `RAZAO_SOCIAL` VARCHAR(120) NOT NULL,
  `NOME_FANTASIA` VARCHAR(120) NOT NULL,
  `DATA_CADASTRO` DATE NOT NULL,
  `EMAIL` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`servico` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DESCRICAO` VARCHAR(200) NOT NULL,
  `TIPO` VARCHAR(100) NOT NULL,
  `DATA_INICIO` DATE NOT NULL,
  `DATA_FIM` DATE NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_SERVICO_EMPRESA1_idx` (`EMPRESA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_SERVICO_EMPRESA1`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contrato` (
  `ID` INT NOT NULL,
  `NUMERO_CONTRATO` VARCHAR(45) NOT NULL,
  `DATA_ASSINATURA` DATE NOT NULL,
  `VIGENCIA` DATE NOT NULL,
  `DESCRICAO` VARCHAR(200) NOT NULL,
  `VALOR` DECIMAL(12,2) NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  `SERVICO_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_CONTRATO_EMPRESA1_idx` (`EMPRESA_ID` ASC) VISIBLE,
  INDEX `fk_CONTRATO_SERVICO1_idx` (`SERVICO_ID` ASC) VISIBLE,
  CONSTRAINT `fk_CONTRATO_EMPRESA1`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_CONTRATO_SERVICO1`
    FOREIGN KEY (`SERVICO_ID`)
    REFERENCES `mydb`.`servico` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`endereco_empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`endereco_empresa` (
  `ID` INT NOT NULL,
  `RUA` VARCHAR(120) NOT NULL,
  `BAIRRO` VARCHAR(80) NOT NULL,
  `CIDADE` VARCHAR(80) NOT NULL,
  `CEP` VARCHAR(20) NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_ENDERECO_EMPRESA_EMPRESA_idx` (`EMPRESA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_ENDERECO_EMPRESA_EMPRESA`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`fiscalizacao_publica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fiscalizacao_publica` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DATA_VISITA` DATE NOT NULL,
  `RESULTADO` VARCHAR(200) NOT NULL,
  `RELATORIO` TEXT NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pontuacao_esg`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pontuacao_esg` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NIVEL_SELO` VARCHAR(45) NOT NULL,
  `DESCRICAO_METRICA` VARCHAR(45) NOT NULL,
  `PONTUACAO_TOTAL` FLOAT NOT NULL,
  `DATA_ATUALIZAÇÃO` DATE NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_PONTUACAO_ESG_EMPRESA1_idx` (`EMPRESA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PONTUACAO_ESG_EMPRESA1`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`registro_ambiental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registro_ambiental` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `TIPO_MATERIAL` VARCHAR(100) NOT NULL,
  `QTD_RECICLADA` DECIMAL(10,2) NOT NULL,
  `DATA_VALIDACAO` DATE NOT NULL,
  `OBSERVACAO` VARCHAR(200) NULL DEFAULT NULL,
  `CONFORMIDADE_LEGISLACAO` VARCHAR(45) NOT NULL,
  `FISCALIZACAO_PUBLICA_ID` INT NOT NULL,
  `PONTUACAO_ESG_PONTUACAOESG` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_REGISTRO_AMBIENTAL_FISCALIZACAO_PUBLICA1_idx` (`FISCALIZACAO_PUBLICA_ID` ASC) VISIBLE,
  INDEX `fk_REGISTRO_AMBIENTAL_PONTUACAO_ESG1_idx` (`PONTUACAO_ESG_PONTUACAOESG` ASC) VISIBLE,
  CONSTRAINT `fk_REGISTRO_AMBIENTAL_FISCALIZACAO_PUBLICA1`
    FOREIGN KEY (`FISCALIZACAO_PUBLICA_ID`)
    REFERENCES `mydb`.`fiscalizacao_publica` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_REGISTRO_AMBIENTAL_PONTUACAO_ESG1`
    FOREIGN KEY (`PONTUACAO_ESG_PONTUACAOESG`)
    REFERENCES `mydb`.`pontuacao_esg` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`registro_de_transporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registro_de_transporte` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `PESO_TOTAL` DECIMAL(10,2) NOT NULL,
  `LOCAL_ORIGEM` VARCHAR(150) NOT NULL,
  `LOCAL_DESTINO` VARCHAR(150) NOT NULL,
  `DATA_COLETA` DATE NOT NULL,
  `DATA_ENTREGA` DATE NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `CONTRATO_ID` INT NOT NULL,
  `REGISTRO_AMBIENTAL_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_REGISTRO_DE_TRANSPORTE_CONTRATO1_idx` (`CONTRATO_ID` ASC) VISIBLE,
  INDEX `fk_REGISTRO_DE_TRANSPORTE_REGISTRO_AMBIENTAL1_idx` (`REGISTRO_AMBIENTAL_ID` ASC) VISIBLE,
  CONSTRAINT `fk_REGISTRO_DE_TRANSPORTE_CONTRATO1`
    FOREIGN KEY (`CONTRATO_ID`)
    REFERENCES `mydb`.`contrato` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_REGISTRO_DE_TRANSPORTE_REGISTRO_AMBIENTAL1`
    FOREIGN KEY (`REGISTRO_AMBIENTAL_ID`)
    REFERENCES `mydb`.`registro_ambiental` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`telefone_empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`telefone_empresa` (
  `ID` INT NOT NULL,
  `NUMERO` VARCHAR(40) NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_TELEFONE_EMPRESA_EMPRESA1_idx` (`EMPRESA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_TELEFONE_EMPRESA_EMPRESA1`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `ID` INT NOT NULL,
  `NOME` VARCHAR(45) NOT NULL,
  `CPF` VARCHAR(20) NOT NULL,
  `EMAIL` VARCHAR(120) NOT NULL,
  `SENHA` VARCHAR(100) NOT NULL,
  `NIVEL_ACESSO` VARCHAR(45) NOT NULL,
  `STATUS` VARCHAR(20) NOT NULL,
  `EMPRESA_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_USUARIO_EMPRESA1_idx` (`EMPRESA_ID` ASC) VISIBLE,
  CONSTRAINT `fk_USUARIO_EMPRESA1`
    FOREIGN KEY (`EMPRESA_ID`)
    REFERENCES `mydb`.`empresa` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
