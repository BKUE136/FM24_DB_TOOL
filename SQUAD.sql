
/* Following the Plan of hiddenattribute */

-- use fm_ha;

-- DROP TABLE Squad;

------------------------------------------------------------------------------------------------
---------------- *** Edit '*.rft ' file                        : Ctrl + H           *** --------
---------------- *** remove rows that start with  '| --- _'    : ^\|\s*---.*\R      *** --------
---------------- *** remove the r-EID                          : r-(\d+) : \1       *** --------
--------------------------------/* Import [*rtf] */ --------------------------------------------


--------------------------------/* Test Import */ --------------------------------

Select * FROM Squad;

Select count(*) FROM Squad;

--------------------------------/* Modify Table */ --------------------------------

alter table dbo.Squad
    drop column [Ausgewählte Position]
go

alter table dbo.Squad
    drop column Info
go

alter table dbo.Squad
    drop column _2
go

alter table dbo.Squad
    drop column Position
go

ALTER TABLE Squad
Alter COLUMN EID INT NOT NULL;

ALTER TABLE Squad
add primary key (EID);

ALTER TABLE Squad
Alter COLUMN Name VARCHAR(max) NOT NULL;

UPDATE Squad
SET Name = TRIM(Name);

ALTER TABLE Squad
Alter COLUMN AF VARCHAR(max) NOT NULL;

UPDATE Squad
SET AF = TRIM(AF);

ALTER TABLE Squad
Alter COLUMN [Alter] INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Ant INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Sch INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Spr INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Dri INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Ann INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Tec INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Pas INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Fähigkeit INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Pot INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Kons INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN [Wi Sp] INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Prof INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Zie INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Ehr INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Dru INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Anp INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Loy INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Fair INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Temp INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Unsp INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Anfäll INT NOT NULL;

ALTER TABLE Squad
Alter COLUMN Stre INT NOT NULL;

--------------------------------/* Modify KEY */ --------------------------------

    /*
    Sadly the MODIFY KEY SCRIPT did not replicate. Instead choose GUI: Modify KEY, change name
    */

------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
--------------------------------/* Functions to Sort out AF */ --------------------------------
------------------------------------------------------------------------------------------------

--------------------------------/* Function remove the '€' Char */ --------------------------------

ALTER TABLE Squad
ADD AF_INT INT;

UPDATE Squad
    SET AF_INT =
    CAST
    (dbo.AF_isINT(dbo.AF_noEuro(Trim(dbo.AF_Sorter((Trim(AF)))))) AS INT);

alter table dbo.Squad
    drop column AF
go

SELECT name, Fähigkeit, pot, AF_INT
FROM Squad
WHERE
   -- [Alter] > 39

        Kons < 11
        OR [Wi Sp] < 10
        OR Prof < 9
        OR Zie < 9
        OR Dru < 9
        OR Ehr < 9

ORDER BY Pot DESC;

SELECT name, Fähigkeit, pot, AF_INT
FROM Squad
WHERE
        [Alter] < 23

        AND Kons > 10
        AND [Wi Sp] > 9
        AND Prof > 8
        AND Zie > 8
        AND Dru > 8
        AND Ehr > 8

ORDER BY Pot DESC;







