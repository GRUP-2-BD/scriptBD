ALTER TABLE partits 
  ADD COLUMN vots INT UNSIGNED DEFAULT NULL
  AFTER partit_id;

ALTER TABLE partits
  ADD COLUMN nom_curt_candidatura VARCHAR(10) DEFAULT NULL
    AFTER nom_curt,
  ADD COLUMN nom_llarg_candidatura VARCHAR(50) DEFAULT NULL
    AFTER nom_llarg;

ALTER TABLE candidats 
  ADD COLUMN partit_id smallint(5) unsigned 
    AFTER candidat_id,
  ADD CONSTRAINT FK_partit FOREIGN KEY (partit_id)
  REFERENCES partits(partit_id);

ALTER TABLE provincies
  ADD COLUMN partit_provincia VARCHAR(45) DEFAULT NULL,
  ADD COLUMN vots_partit INT UNSIGNED
    AFTER partit_provincia;

SELECT partit_provincia, vots_partit
  FROM provincies;

ALTER TABLE eleccions
  Modify column any tinyINT(4) as (YEAR(data))  STORED COMMENT 'any el qual s''han celebrat les eleccions',
  Modify column mes tinyINT(2) as (MONTH(data)) STORED COMMENT 'El mes que s''han celebrat les eleccions';

ALTER TABLE PARTITS
  DROP COLUMN nom_curt_candidatura,
  DROP COLUMN nom_llarg_candidatura;
