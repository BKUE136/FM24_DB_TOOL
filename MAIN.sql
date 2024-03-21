------------------------------------------------------------------------------------------------
--------------------------------/* Create Database FM_HA; */ --------------------------------
------------------------------------------------------------------------------------------------

-- Create Database FM_HA;

-- use FM_HA;

    /*
        Note that you have to select default Schema [dbo] !
        Importing *.rft ! on db while sql dialect is ms sql
        checking types in columns to match function types
    */

-- Drop database fm_ha;

-- Use master;

-- DROP TABLE HiddenAttributes;

-- truncate table hiddenattributes;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
---------------- *** Edit '*.rft ' file                        : Ctrl + H           *** --------
---------------- *** remove rows that start with  '| --- _'    : ^\|\s*---.*\R      *** --------
---------------- *** remove the r-EID                          : r-(\d+) : \1       *** --------
--------------------------------/* Import [*rtf] */ --------------------------------------------
------------------------------------------------------------------------------------------------

--------------------------------/* Test Import */ --------------------------------

select top 12 *
from HiddenAttributes;

Select Count(*) from HiddenAttributes;

------------------------------------------------------------------------------------
-------------------------------- /* Modify Table */ --------------------------------
------------------------------------------------------------------------------------

------------------------ /* PROCEDURE to SET TYPE VARCHAR(max) */ -------------
------------------------ /* Works but needs to be dynamic */ -------------

-- DROP PROCEDURE dbo.SET_COL_TYPE_VARCHAR_PROCEDURE;

CREATE OR ALTER PROCEDURE
dbo.SET_COL_TYPE_VARCHAR_PROCEDURE
AS
BEGIN
    /* TYPE */
    BEGIN
        ALTER TABLE hiddenattributes
        Alter COLUMN Info VARCHAR(max);
    END
END
GO

------------------------ /* EXECUTE PROCEDURE TO SET VARCHAR TYPE */ ------------------------

EXEC dbo.SET_COL_TYPE_VARCHAR_PROCEDURE;

------------------------ /* PROCEDURE/FUNCTION to TRIM COLUMN */ -------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.TRIM_COL_PROCEDURE
AS
BEGIN
    /* TRIM */
    BEGIN
        UPDATE dbo.HiddenAttributes
        SET Info = TRIM(Info)
    END
END
GO

------------------------ /* EXECUTE PROCEDURE TO TRIM VALUE */ ------------------------

EXEC dbo.TRIM_COL_PROCEDURE;

------------------------ /* PROCEDURE TO SET VALUE NULL */ ------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.SET_COL_NULL_PROCEDURE
AS
BEGIN
    /* CHECK FOR EXISTENCE OF ZERO LENGTH STRING */
    IF EXISTS
        (SELECT Info from HiddenAttributes WHERE len(info) = 0)
    /* SET NULL */
    BEGIN
        UPDATE dbo.HiddenAttributes
        SET Info = NULL
        WHERE len(info) = 0;
    END
END
GO

SELECT Info from HiddenAttributes WHERE len(info) = 0;

------------------------ /* EXECUTE PROCEDURE TO SET VALUE NULL */ ------------------------

EXEC dbo.SET_COL_NULL_PROCEDURE;

------------------------ /* PROCEDURE to NULL EMPTY COLUMN */ -------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.DROP_NULL_COL_PROCEDURE
AS
BEGIN
    DECLARE @drop_complete BIT = 0;

    IF EXISTS
        (SELECT 1 FROM FM_HA.dbo.HiddenAttributes WHERE Info IS NULL)
    BEGIN
        ALTER TABLE FM_HA.dbo.HiddenAttributes
        DROP COLUMN Info;
        SET @drop_complete = 1;
    END

    SELECT @drop_complete AS DropComplete;
END
GO

------------------------ /* TEST IF COLUMN CONTAINING NULL VALUES GETS DROPPED */ ------------------------

SELECT 1 FROM FM_HA.dbo.HiddenAttributes WHERE Info IS NULL;

------------------------ /* PROCEDURE to DROP NULL COLUMN */ -----------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.DROP_NULL_COL_PROCEDURE
AS
BEGIN
    DECLARE @drop_complete BIT = 0;

    IF EXISTS (SELECT 1 FROM FM_HA.dbo.HiddenAttributes WHERE Info IS NULL)
    BEGIN
        ALTER TABLE FM_HA.dbo.HiddenAttributes
        DROP COLUMN Info;
        SET @drop_complete = 1;
    END

    SELECT @drop_complete AS DropComplete;
END
GO

------------------------ /* TEST IF COLUMN CONTAINING NULL VALUES GETS DROPPED */ ------------------------

SELECT 1 FROM FM_HA.dbo.HiddenAttributes WHERE Info IS NULL;

Select Count(*) from HiddenAttributes WHERE Info IS NULL;

------------------------ /* EXECUTE PROCEDURE to DROP NULL COLUMN  */ ------------------------

EXEC dbo.DROP_NULL_COL_PROCEDURE;

------------------------ /* PROCEDURE 'DANCE OVER THE TABLE' */ -------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.DANCE_COL_PROCEDURE
AS
BEGIN

    IF EXISTS

    (
        SELECT 1 FROM
        INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'HiddenAttributes'
        AND COLUMN_NAME = 'Info'
        AND DATA_TYPE = 'text'
    )

    BEGIN
    EXEC
        dbo.SET_COL_TYPE_VARCHAR_PROCEDURE;
    EXEC
        dbo.TRIM_COL_PROCEDURE;
    EXEC
        dbo.SET_COL_NULL_PROCEDURE;
    EXEC
        dbo.DROP_NULL_COL_PROCEDURE;
    END
END
GO

------------------------ /* EXECUTE PROCEDURE to DANCE COLUMN */ ------------------------

EXEC dbo.DANCE_COL_PROCEDURE;

------------------------ /* END OF PROCEDURE PART */ ------------------------

------------------------------------------------------------------------------------------------
--------------------------------/* Functions to Sort out AF */ --------------------------------
------------------------------------------------------------------------------------------------

--------------------------------/* Function remove the '€' Char */ --------------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER
FUNCTION dbo.AF_noEuro
    (@AF VARCHAR(max))
    RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @result VARCHAR(max);
    DECLARE @pattern VARCHAR(100) = N'[€$£¥₹₽฿₺₴₩₪₮₱₡₦៛₭₮₲₵₣₢₤₸₥]';
    SET @result = @AF;

    IF PATINDEX(@pattern, @AF) = 1
    BEGIN
        SET @result = RIGHT(@AF, LEN(@AF) - 1) + '';
    END;

    RETURN @result;
END
go

--------------------------------/* Function remove all non-number-chars */ --------------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER FUNCTION dbo.AF_Sorter
    (@AF VARCHAR(max))
RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @result VARCHAR(max);
    SET @result = @AF;

    IF RIGHT(@AF, 3) = 'Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '000000';
    END;

    IF RIGHT(@AF, 1) = 'K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 1) + '000';
    END;

    IF RIGHT(@AF, 6) = '.25Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 6) + '250000';
    END;

    IF RIGHT(@AF, 6) = '.75Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 6) + '750000';
    END;

    IF RIGHT(@AF, 5) = '.9Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '900000';
    END;

    IF RIGHT(@AF, 5) = '.8Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '800000';
    END;

    IF RIGHT(@AF, 5) = '.7Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '700000';
    END;

    IF RIGHT(@AF, 5) = '.6Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '600000';
    END;

    IF RIGHT(@AF, 5) = '.5Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '500000';
    END;

    IF RIGHT(@AF, 5) = '.4Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '400000';
    END;

    IF RIGHT(@AF, 5) = '.3Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '300000';
    END;

        IF RIGHT(@AF, 5) = '.2Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '200000';
    END;

    IF RIGHT(@AF, 5) = '.1Mio'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 5) + '100000';
    END;

    IF RIGHT(@AF, 4) = '.25K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 4) + '250';
    END;

    IF RIGHT(@AF, 4) = '.75K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 4) + '750';
    END;

    IF RIGHT(@AF, 3) = '.9K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '900';
    END;

    IF RIGHT(@AF, 3) = '.8K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '800';
    END;

    IF RIGHT(@AF, 3) = '.7K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '700';
    END;

    IF RIGHT(@AF, 3) = '.6K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '600';
    END;

    IF RIGHT(@AF, 3) = '.5K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '500';
    END;

        IF RIGHT(@AF, 3) = '.4K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '400';
    END;

        IF RIGHT(@AF, 3) = '.3K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '300';
    END;

        IF RIGHT(@AF, 3) = '.2K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '200';
    END;

            IF RIGHT(@AF, 3) = '.1K'
    BEGIN
        SET @result = LEFT(@AF, LEN(@AF) - 3) + '100';
    END;

    RETURN @result;
END;

--------------------------------/* Function convert VARCHAR INTO INT */ --------------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER
FUNCTION dbo.AF_isINT
    (@AF VARCHAR(max))
    RETURNS INT
AS
BEGIN
    DECLARE @result VARCHAR(max);
    SET @result = @AF;

    BEGIN
        SET @result = RIGHT(@AF, LEN(@AF)) + '';
    END;

    RETURN @result;
END
go

------------------------ /*  */ ------------------------

ALTER TABLE dbo.HiddenAttributes
    DROP COLUMN Empf
GO

ALTER TABLE dbo.HiddenAttributes
    DROP COLUMN Info
GO

ALTER TABLE dbo.HiddenAttributes
    DROP COLUMN _2
GO

--------------------------------/* Modify Table */ --------------------------------

ALTER TABLE hiddenattributes
Alter COLUMN EID INT NOT NULL;

ALTER TABLE hiddenattributes
add primary key (EID);

--------------------------------/* Modify KEY */ --------------------------------

    /*
    Sadly the MODIFY KEY SCRIPT did not replicate. Instead choose GUI: Modify KEY, change name
    */

------------------------ /*  */ ------------------------

ALTER TABLE hiddenattributes
Alter COLUMN Name VARCHAR(max) NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Verein VARCHAR(max) NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN AF VARCHAR(max) NOT NULL;

------------------------ /*  */ ------------------------

ALTER TABLE hiddenattributes
Alter COLUMN [Alter] INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Ant INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Sch INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Spr INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Ann INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Dri INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Tec INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Pas INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Prof INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Zie INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Dru INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Ehr INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Kons INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN [Wi Sp] INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Viel INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Fähigkeit INT NOT NULL;

ALTER TABLE hiddenattributes
Alter COLUMN Pot INT NOT NULL;

--------------------------------/* Test Table [Felle] */ --------------------------------
/*
Create Table Felle
(
    Felle varchar(max)
    , fall varchar(max)
);

truncate table Felle;

INSERT INTO Felle
    VALUES
    (N'€XXXMio', N'€350Mio')
    ,(N'€XX.XMio', N'€35.5Mio')
    ,(N'€XX.XXMio', N'€10.25Mio')
    ,(N'€X.XMio', N'€3.5Mio')
    ,(N'€X.XMio', N'€3.2Mio')
    ,(N'€XX.XK', N'€33.5K') -- 33.5k
    ,(N'€XX.XXK', N'€10.25K')
    ,(N'€X.XK', N'€8.5K') -- tausender mit komma
    ,(N'€XK', N'€4K') -- tausender
    ,(N'€.XK', N'€.75K')
    ,(N'€.XK', N'€.5K') -- 0.5k
    ,(N'€.XK', N'€.25K')
    ,(N'€.XK', N'€.9K')
    ,(N'€.XK', N'€.8K')
    ,(N'€.XK', N'€.7K')
    ,(N'€.XK', N'€.6K')
    ,(N'€.XK', N'€.5K') -- 0.5k
    ,(N'€XXX', N'€400')
    ,(N'€XXX', N'€300')
    ,(N'€XXX', N'€200')
    ,(N'€XXX', N'€100')
 ;

 */
--------------------------------/* Tests */ --------------------------------
/*
SELECT top 12 *
FROM HiddenAttributes;

Select * from Felle;

Select  Felle, fall, dbo.AF_Sorter(fall) AS calculated from Felle;

Select  Felle, fall, dbo.AF_noEuro(fall) AS calculated from Felle;

Select  Felle, fall, dbo.AF_noEuro(dbo.AF_Sorter(fall)) AS calculated from Felle;

Select HiddenAttributes.AF, dbo.AF_isINT(dbo.AF_noEuro(Trim(dbo.AF_Sorter((trim(AF)))))) AS calculated from HiddenAttributes;

Select Felle, fall, dbo.AF_isINT(dbo.AF_noEuro(Trim(dbo.AF_Sorter((trim(fall)))))) AS calculated from Felle;
*/

--------------------------------/* ALTER TABLE HIDDENATTRIBUTES */ --------------------------------

ALTER TABLE HiddenAttributes
ADD AF_INT INT;

UPDATE HiddenAttributes
    SET AF =
    CAST
    (dbo.AF_isINT(dbo.AF_noEuro(Trim(dbo.AF_Sorter((Trim(AF)))))) AS INT);

alter table dbo.HiddenAttributes
    drop column AF
go

--------------------------------/* Tests */ --------------------------------

SELECT *
FROM HiddenAttributes
where AF_INT > 0
AND AF_INT < 1000;

SELECT *
FROM HiddenAttributes
where AF_INT > 1000
AND AF_INT < 10000;

SELECT *
FROM HiddenAttributes
where AF_INT > 10000
AND AF_INT < 100000;

SELECT *
FROM HiddenAttributes
where AF_INT > 100000
AND AF_INT < 1000000;

SELECT *
FROM HiddenAttributes
where AF_INT > 1000000
AND AF_INT < 10000000;

SELECT *
FROM HiddenAttributes
where AF_INT > 10000000
AND AF_INT < 100000000;

SELECT *
FROM HiddenAttributes
where AF_INT > 100000000
AND AF_INT < 1000000000;

--------------------------------/* STATUS */ --------------------------------
/*

working
[dbo.AF_noEuro]
[dbo.AF_Sorter]

new col AF_INT

Export?

    *** Special THX to Jasper Haag
*/
-------------------------------- ---------- --------------------------------

CREATE VIEW [HA_ALL_TRIM] AS
SELECT
    (EID)
    ,TRIM(HiddenAttributes.Name) AS Name
    ,TRIM(Verein) AS Verein
    ,([Alter])
    ,(Ant)
    ,(Sch)
    ,(Spr)
    ,(Ann)
    ,(Dri)
    ,(Tec)
    ,(Pas)
    ,(Prof)
    ,(Zie)
    ,(Dru)
    ,(Ehr)
    ,(Kons)
    ,([Wi Sp])
    ,(Viel)
    ,(Fähigkeit)
    ,(Pot)
    ,(AF_INT)
FROM HiddenAttributes
go

Select * from HiddenAttributes
Where

        [Alter] < 29
    AND AF_INT < 1000000
    AND HiddenAttributes.Kons > 11
    AND HiddenAttributes.[Wi Sp] > 11
    AND HiddenAttributes.Prof > 9
    AND HiddenAttributes.Zie > 9
    AND HiddenAttributes.Dru > 9
    AND HiddenAttributes.Ehr > 9
    AND HiddenAttributes.Ant > 13
    AND HiddenAttributes.Sch > 13
    AND HiddenAttributes.Dri > 13
;

Select * from HiddenAttributes
Where

        [Alter] < 29
    AND AF_INT < 1000000
    AND HiddenAttributes.Kons > 11
    AND HiddenAttributes.[Wi Sp] > 11
    AND HiddenAttributes.Prof > 9
    AND HiddenAttributes.Zie > 9
    AND HiddenAttributes.Dru > 9
    AND HiddenAttributes.Ehr > 9
    AND HiddenAttributes.Ant > 13
    AND HiddenAttributes.Sch > 13
    AND HiddenAttributes.Dri > 13
;

Select *

from HiddenAttributes
Where trim(name) = 'Nigel Robertha';
