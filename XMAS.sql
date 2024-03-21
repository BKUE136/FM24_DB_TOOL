
use FM_HA;

select top 12 *
from XMAS;

Select Count(*) from XMAS;

-----------------------------------------------------------------------
 -- Alter TABLE XMAS;   Drops
-----------------------------------------------------------------------

ALTER TABLE dbo.XMAS
    DROP COLUMN Empf
GO

ALTER TABLE dbo.XMAS
    DROP COLUMN Info
GO

ALTER TABLE dbo.XMAS
    DROP COLUMN _2
GO

---------------------------------------------------------------------
 -- Alter TABLE XMAS;   floats
---------------------------------------------------------------------

ALTER TABLE dbo.XMAS
Alter COLUMN [Alter] INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Ant INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Sch INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Spr INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Ann INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Dri INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Tec INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Pas INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Prof INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Zie INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Dru INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Ehr INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Kons INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN [Wi Sp] INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Viel INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Fähigkeit INT NOT NULL;

ALTER TABLE dbo.XMAS
Alter COLUMN Pot INT NOT NULL;

---------------------------------------------------------------------
 -- Alter TABLE XMAS;   texts to varchar
---------------------------------------------------------------------

ALTER TABLE dbo.XMAS
Alter COLUMN Name VARCHAR(max) NOT NULL;

update dbo.XMAS
    set Name = trim(Name);

ALTER TABLE dbo.XMAS
Alter COLUMN Verein VARCHAR(max) NOT NULL;

update dbo.XMAS
    set Verein = trim(Verein);

ALTER TABLE dbo.XMAS
Alter COLUMN AF VARCHAR(max) NOT NULL;

update dbo.XMAS
    set AF = trim(AF);

---------------------------------------------------------------------
 -- Alter TABLE XMAS;   ended text to date      to do
---------------------------------------------------------------------
 /** Still problem converting date  **/


ALTER TABLE dbo.XMAS
Alter COLUMN Endet VARCHAR(max) NOT NULL;

--trim first

update dbo.XMAS
    set Endet = trim(Endet);

ALTER TABLE dbo.XMAS
Alter COLUMN Endet DATE;

---------------------------------------------------------------------
 -- Alter TABLE XMAS;   sort AF
---------------------------------------------------------------------

UPDATE dbo.XMAS
    SET AF =
    CAST
    (dbo.AF_isINT(dbo.AF_noEuro(Trim(dbo.AF_Sorter((Trim(AF)))))) AS INT);

---------------------------------------------------------------------
 -- some Selects
---------------------------------------------------------------------

select top 12 *
from XMAS
where [Alter] < 29;



Select XMAS.Name, XMAS.Verein, XMAS.[Alter], XMAS.Fähigkeit, XMAS.Pot, AF, Endet from dbo.XMAS
Where

        [Alter] < 19

    AND dbo.XMAS.Kons > 10
    AND dbo.XMAS.[Wi Sp] > 9
    AND dbo.XMAS.Prof > 8
    AND dbo.XMAS.Zie > 8
    AND dbo.XMAS.Dru > 8
    AND dbo.XMAS.Ehr > 8
    AND dbo.XMAS.Ant > 13
    AND dbo.XMAS.Sch > 13
    AND dbo.XMAS.Dri > 13
    AND XMAS.Pot > 139
  --  AND XMAS.Fähigkeit > 119
  --  and af < 999999
  --  AND dbo.XMAS.Endet LIKE '%6/2024%'
    order by Pot desc
;


SELECT XMAS.Name, XMAS.Verein, XMAS.[Alter], XMAS.Fähigkeit, XMAS.Pot, AF, Endet
FROM XMAS
WHERE
        [Alter] < 19

        AND Kons > 10
        AND [Wi Sp] > 9
        AND Prof > 8
        AND Zie > 8
        AND Dru > 8
        AND Ehr > 8
        AND AF < 9999999
        AND AF > 4999999
     --   AND XMAS.Spr > 12
        AND XMAS.Sch > 12
        AND XMAS.Ant > 12
        AND XMAS.Tec > 12
        AND XMAS.Pas > 12
        AND XMAS.Dri > 12



        AND XMAS.Pot > 119
ORDER BY Pot DESC;
