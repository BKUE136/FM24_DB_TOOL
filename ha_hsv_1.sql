-------------------------------------------------------------------------------------------------
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

-- DROP TABLE FM_HA.dbo.ha_robu_1;

-- truncate table ha_robu_1;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
---------------- *** Edit '*.rft ' file                        : Ctrl + H           *** --------
---------------- *** remove rows that start with  '| --- _'    : ^\|\s*---.*\R      *** --------
---------------- *** remove the r-UID                          : r-(\d+) : \1       *** --------
--------------------------------/* Import [*rtf] */ --------------------------------------------
------------------------------------------------------------------------------------------------

--------------------------------/* Test Import */ --------------------------------

select top 12 *
from ha_robu_1
ORDER BY PA desc;

Select Count(*) from ha_robu_1;

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
        ALTER TABLE ha_ROBU_1
        Alter COLUMN AP VARCHAR(max);
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
        UPDATE dbo.ha_robu_1
        SET AP = TRIM(AP)
    END
END
GO

------------------------ /* EXECUTE PROCEDURE TO TRIM VALUE */ ------------------------

EXEC dbo.TRIM_COL_PROCEDURE;

------------------------ /* PROCEDURE TO SET INT NOT NULL TYPE */ ------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.SET_COL_TYPE_INT_NN_PROCEDURE
AS
BEGIN
    /* TYPE */
    BEGIN
        ALTER TABLE ha_ROBU_1
        Alter COLUMN AP INT NOT NULL ;
    END
END
GO

------------------------ /* EXECUTE PROCEDURE TO SET INT TYPE */ ------------------------

EXEC dbo.SET_COL_TYPE_INT_NN_PROCEDURE;

------------------------ /* PROCEDURE TO SET INT NULL TYPE */ ------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.SET_COL_TYPE_INT_N_PROCEDURE
AS
BEGIN
    /* TYPE */
    BEGIN
        ALTER TABLE ha_ROBU_1
        Alter COLUMN AP INT NULL ;
    END
END
GO

------------------------ /* EXECUTE PROCEDURE TO SET INT TYPE */ ------------------------

EXEC dbo.SET_COL_TYPE_INT_N_PROCEDURE;


------------------------ /* PROCEDURE TO SET VALUE NULL */ ------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.SET_COL_NULL_PROCEDURE
AS
BEGIN
    /* CHECK FOR EXISTENCE OF ZERO LENGTH STRING */
    IF EXISTS
        (SELECT Pres from ha_robu_1 WHERE len(Pres) = 0)
    /* SET NULL */
    BEGIN
        UPDATE dbo.ha_robu_1
        SET Pres = NULL
        WHERE len(Pres) = 0;
    END
END
GO

SELECT Pres from ha_robu_1 WHERE len(Pres) = 0;

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
        (SELECT 1 FROM FM_HA.dbo.ha_robu_1 WHERE Pres IS NULL)
    BEGIN
        ALTER TABLE FM_HA.dbo.ha_robu_1
        DROP COLUMN Pres;
        SET @drop_complete = 1;
    END

    SELECT @drop_complete AS DropComplete;
END
GO

------------------------ /* TEST IF COLUMN CONTAINING NULL VALUES GETS DROPPED */ ------------------------

-- SELECT 1 FROM FM_HA.dbo.ha_robu_1 WHERE Pres IS NULL;

------------------------ /* PROCEDURE to DROP NULL COLUMN */ -----------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.DROP_NULL_COL_PROCEDURE
AS
BEGIN
    DECLARE @drop_complete BIT = 0;

    IF EXISTS (SELECT 1 FROM FM_HA.dbo.ha_robu_1 WHERE Pres IS NULL)
    BEGIN
        ALTER TABLE FM_HA.dbo.ha_robu_1
        DROP COLUMN Pres;
        SET @drop_complete = 1;
    END

    SELECT @drop_complete AS DropComplete;
END
GO

------------------------ /* TEST IF COLUMN CONTAINING NULL VALUES GETS DROPPED */ ------------------------

-- SELECT 1 FROM FM_HA.dbo.ha_robu_1 WHERE Pres IS NULL;

-- Select Count(*) from ha_robu_1 WHERE Pres IS NULL;

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
        WHERE TABLE_NAME = 'ha_robu_1'
        AND COLUMN_NAME = 'Pres'
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

------------------------ /*  */ -----------------------------------------

------------------------ /* PROCEDURE 'DANCE OVER THE TABLE' */ -------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER PROCEDURE
dbo.TRIM_INT_NN_COL_PROCEDURE
AS
BEGIN

    IF EXISTS

    (
        SELECT 1 FROM
        INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'ha_robu_1'
        AND COLUMN_NAME = 'Pres'
        AND DATA_TYPE = 'text'
    )

    BEGIN
    EXEC
        dbo.SET_COL_TYPE_VARCHAR_PROCEDURE;
    EXEC
        dbo.TRIM_COL_PROCEDURE;
    EXEC
        dbo.SET_COL_TYPE_INT_NN_PROCEDURE
    END
END
GO

------------------------ /* EXECUTE PROCEDURE to DANCE COLUMN */ ------------------------

EXEC dbo.TRIM_INT_NN_COL_PROCEDURE

------------------------ /*  */ -----------------------------------------
------------------------ /* SPACE FOR DYNAMIC PROCEDURE */ -----------------------------------------
------------------------ /* SOMETHING TO LEARN DYNAMIC SQL */ -----------------------------------------
------------------------ /*  */ -----------------------------------------

------------------------ /* CREATE FUNCTION DYN_VARCHAR() */ -----------------------------------------

CREATE OR ALTER FUNCTION
dbo.DYN_VARCHAR()
returns varchar(max)
AS

BEGIN

    declare @sql nvarchar(max)
            , @param varchar(max)
    set @param = '38'
    set @sql = 'SELECT * FROM ha_robu_1'+' where [Age] = ' + @param

RETURN @sql
END
GO


SELECT dbo.DYN_VARCHAR();
EXEC sp_executesql DYN_VARCHAR;

/*
declare @sql nvarchar(max)
        , @param varchar(max)
set @param = '38'
set @sql = 'SELECT * FROM ha_robu_1'+' where [Age] = ' + @param
Print 'Die execution von : ' + @sql + ' steht kurz bevor'
execute sp_executesql @sql

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS;
*/

/*
Select AP.type_id from ha_robu_1
where data_type = float
*/

Select * FROM sys.syscolumns where name = 'AP';
Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ha_robu_1';

------------------------ /* INTO VAR FROM SELECT */ -----------------------------------------

declare @myva varchar(max)
        ,@pos int;
/*set position */
 set @pos = 9;
/*run select into var */
Select @myva = COLUMN_NAME
--@myva = CONCAT(COLUMN_NAME, ' IS TYPE ', DATA_TYPE) /* with concat */
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'ha_robu_1'
  AND ORDINAL_POSITION = @pos;
/* print var value */
print
    'SELECTED VALUE IS: '
     + @myva +
    ' STORED IN VARIABLE @myva';

------------------------ /*  */ -----------------------------------------
------------------------ /* END OF THE DYNAMIC CHAPTER */ -----------------------------------------
------------------------ /*  */ -----------------------------------------


------------------------ /* END OF PROCEDURE PART */ ------------------------

------------------------------------------------------------------------------------------------
--------------------------------/* Functions to Sort out AP */ --------------------------------
------------------------------------------------------------------------------------------------

--------------------------------/* Function remove the '€' Char */ --------------------------------
------------------------ /* DOES NOT! with pattern! Works but needs to be dynamic */ -------------
/*
CREATE OR ALTER
FUNCTION dbo.AP_noEuro
    (@AP VARCHAR(max))
    RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @result VARCHAR(max);
    DECLARE @pattern VARCHAR(100) = N'[€$£¥₹₽฿₺₴₩₪₮₱₡₦៛₭₮₲₵₣₢₤₸₥]';
    SET @result = @AP;

    IF PATINDEX(@pattern, @AP) = 1
    BEGIN
        SET @result = SUBSTRING(@AP, 2, LEN(@AP));
    END;

    RETURN @result;
END
GO
*/

CREATE OR ALTER FUNCTION dbo.AP_noEuro
    (@AP VARCHAR(max))
    RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @result VARCHAR(max);

        IF LEFT(@AP, 1) = N'€'
    BEGIN
        SET @result = SUBSTRING(@AP, 2, LEN(@AP));
    END;

    RETURN @result;
END


--------------------------------/* Test Function to remove the '€' Char */ --------------------------------

UPDATE ha_ROBU_1
    SET AP =

    dbo.AP_noEuro(AP)

go

select top 12 Name, Club, AP
from ha_robu_1
ORDER BY PA desc;

--------------------------------/* Function remove all non-number-chars */ --------------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER FUNCTION dbo.AP_Sorter
    (@AP VARCHAR(max))
RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @result VARCHAR(max);
    SET @result = @AP;

    IF RIGHT(@AP, 1) = 'M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 1) + '000000';
    END;

    IF RIGHT(@AP, 1) = 'K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 1) + '000';
    END;

    IF RIGHT(@AP, 4) = '.25M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 4) + '250000';
    END;

    IF RIGHT(@AP, 4) = '.75M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 4) + '750000';
    END;

    IF RIGHT(@AP, 3) = '.9M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '900000';
    END;

    IF RIGHT(@AP, 3) = '.8M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '800000';
    END;

    IF RIGHT(@AP, 3) = '.7M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '700000';
    END;

    IF RIGHT(@AP, 3) = '.6M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '600000';
    END;

    IF RIGHT(@AP, 3) = '.5M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '500000';
    END;

    IF RIGHT(@AP, 3) = '.4M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '400000';
    END;

    IF RIGHT(@AP, 3) = '.3M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '300000';
    END;

        IF RIGHT(@AP, 3) = '.2M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '200000';
    END;

    IF RIGHT(@AP, 3) = '.1M'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '100000';
    END;

    IF RIGHT(@AP, 4) = '.25K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 4) + '250';
    END;

    IF RIGHT(@AP, 4) = '.75K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 4) + '750';
    END;

    IF RIGHT(@AP, 3) = '.9K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '900';
    END;

    IF RIGHT(@AP, 3) = '.8K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '800';
    END;

    IF RIGHT(@AP, 3) = '.7K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '700';
    END;

    IF RIGHT(@AP, 3) = '.6K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '600';
    END;

    IF RIGHT(@AP, 3) = '.5K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '500';
    END;

        IF RIGHT(@AP, 3) = '.4K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '400';
    END;

        IF RIGHT(@AP, 3) = '.3K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '300';
    END;

        IF RIGHT(@AP, 3) = '.2K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '200';
    END;

            IF RIGHT(@AP, 3) = '.1K'
    BEGIN
        SET @result = LEFT(@AP, LEN(@AP) - 3) + '100';
    END;

    RETURN @result;
END;

--------------------------------/* Function convert VARCHAR INTO INT */ --------------------------------
------------------------ /* Works but needs to be dynamic */ -------------

CREATE OR ALTER
FUNCTION dbo.AP_isINT
    (@AP VARCHAR(max))
    RETURNS INT
AS
BEGIN
    DECLARE @result VARCHAR(max);
    SET @result = @AP;

    BEGIN
        SET @result = RIGHT(@AP, LEN(@AP)) + '';
    END;

    RETURN @result;
END
go

------------------------ /*  */ ------------------------
/*
ALTER TABLE ha_ROBU_1
    DROP COLUMN Rec
GO

ALTER TABLE ha_ROBU_1
    DROP COLUMN Inf
GO

ALTER TABLE ha_ROBU_1
    DROP COLUMN _2
GO
*/
--------------------------------/* Modify Table */ --------------------------------

ALTER TABLE ha_ROBU_1
Alter COLUMN UID INT NOT NULL;

ALTER TABLE ha_ROBU_1
add primary key (UID);

--------------------------------/* Modify KEY */ --------------------------------

    /*
    Sadly the MODIFY KEY SCRIPT did not replicate. Instead choose GUI: Modify KEY, change name

    exec sp_rename 'dbo.PK__ha_robu_1__C5B19602328B816D', PLAYER_ID, 'OBJECT'
    go

    exec sp_addextendedproperty 'MS_Description', 'PLAYER_ID IS UID', 'SCHEMA', 'dbo', 'TABLE', 'ha_robu_1', 'CONSTRAINT',
     'PLAYER_ID'
    go

    */

------------------------ /*  */ ------------------------

ALTER TABLE ha_ROBU_1
Alter COLUMN Name VARCHAR(max) NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Club VARCHAR(max) NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN AP VARCHAR(max) NOT NULL;

------------------------ /*  */ ------------------------


ALTER TABLE ha_ROBU_1
Alter COLUMN [Age] INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Acc INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Pac INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Jum INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Fir INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Dri INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Tec INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Pas INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Prof INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Det INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Pres INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Amb INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Cons INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN [Imp M] INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN Vers INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN CA INT NOT NULL;

ALTER TABLE ha_ROBU_1
Alter COLUMN PA INT NOT NULL;

--------------------------------/* ALTER TABLE HIDDENATTRIBUTES */ --------------------------------

UPDATE ha_ROBU_1
    SET AP =
        trim(AP);
GO

UPDATE ha_ROBU_1
    SET AP =
        dbo.AP_noEuro(AP);
GO

UPDATE ha_ROBU_1
    SET AP =
        dbo.AP_Sorter(AP);
GO

UPDATE ha_ROBU_1
    SET AP =
        dbo.AP_isINT(AP);
GO

/*
UPDATE ha_robu_1
    SET AP =
    CAST
    (dbo.AP_isINT(dbo.AP_noEuro(Trim(dbo.AP_Sorter((Trim(AP)))))) AS INT);

go
*/

UPDATE ha_ROBU_1
    SET Club =
        trim(Club);
GO

UPDATE ha_ROBU_1
    SET Name =
        trim(Name);
GO

--------------------------------/* DROP */ --------------------------------
/*
alter table ha_ROBU_1
    drop column Expires
go

alter table dbo.ha_robu_1
    drop column Rec
go

alter table dbo.ha_robu_1
    drop column Inf
go

alter table dbo.ha_robu_1
    drop column _2
go
*/
--------------------------------/* Tests */ --------------------------------

SELECT *
FROM ha_robu_1
where AP > 0
AND AP < 1000;

SELECT *
FROM ha_robu_1
where AP > 1000
AND AP < 10000;

SELECT *
FROM ha_robu_1
where AP > 10000
AND AP < 100000;

SELECT *
FROM ha_robu_1
where AP > 100000
AND AP < 1000000;

SELECT *
FROM ha_robu_1
where AP > 1000000
AND AP < 10000000;

SELECT *
FROM ha_robu_1
where AP > 10000000
AND AP < 100000000;

SELECT *
FROM ha_robu_1
where AP > 100000000
AND AP < 1000000000;

--------------------------------/* STATUS */ --------------------------------
/*

working
[dbo.AP_noEuro]
[dbo.AP_Sorter]

new col AP_INT

Export?

    *** Special THX to Jasper Haag
*/
-------------------------------- ---------- --------------------------------

Select
    Name
    ,Club
    ,CA
    ,PA
    ,AP
from ha_ROBU_1
Where

        [Age] < 29
  --  AND AP < 20000000
    AND ha_ROBU_1.Cons > 11
    AND ha_ROBU_1.[Imp M] > 11
    AND ha_ROBU_1.Prof > 9
    AND ha_ROBU_1.Det > 9
    AND ha_ROBU_1.Pres > 9
    AND ha_ROBU_1.Amb > 9
    AND ha_ROBU_1.Acc > 9
    AND ha_ROBU_1.Pac > 9
    AND ha_ROBU_1.Dri > 6
    AND ha_ROBU_1.Jum > 11
;

Select
    Name
    ,Club
    ,CA
    ,PA
    ,AP
from ha_ROBU_1
Where

        [Age] < 29
    -- AND AP < 1000000
    AND ha_ROBU_1.Cons > 11
    AND ha_ROBU_1.[Imp M] > 11
    AND ha_ROBU_1.Prof > 9
    AND ha_ROBU_1.Det > 9
    AND ha_ROBU_1.Pres > 9
    AND ha_ROBU_1.Amb > 9
    AND ha_ROBU_1.Acc > 9
    AND ha_ROBU_1.Pac > 9
    AND ha_ROBU_1.Dri > 6
    AND ha_ROBU_1.Jum > 10

ORDER BY PA desc;
;

Select *

from ha_robu_1
Where trim(name) = 'Nigel Robertha';


select
    Name
    ,Club
   -- ,AP
    ,CA
    ,PA
    ,Age

from ha_robu_1
Where

        [Age] < 29
    -- AND Age > 18
    AND AP < 4999999
    AND ha_robu_1.Cons > 13
    AND ha_robu_1.[Imp M] > 13
    AND ha_robu_1.PA > 129
    AND ha_robu_1.Prof > 13
    AND ha_robu_1.Det > 9
    AND ha_robu_1.Pres > 9
    AND ha_robu_1.Amb > 9
    AND ha_robu_1.Acc > 11
    AND ha_robu_1.Pac > 11
    AND ha_robu_1.Pas > 6
    AND ha_robu_1.Tec > 6
    AND ha_robu_1.Dri > 6
    AND ha_robu_1.Fir > 8
    AND ha_robu_1.Jum > 13

ORDER BY PA desc;


select
    Name
    ,Club
   -- ,AP
    ,CA
    ,PA
    ,Age


from ha_robu_1
Where

        [Age] < 18

    AND ha_robu_1.Cons > 13
    AND ha_robu_1.[Imp M] > 13
    AND ha_robu_1.PA < 150
    AND ha_robu_1.PA > 139

ORDER BY PA desc;


-- Goalkeepers
select
    Name
    ,Club
    ,AP
    ,CA
    ,PA
    ,Age

from ha_robu_1
Where

        [Age] < 27
   -- AND Age > 22
   -- AND AP < 9750000
    AND ha_robu_1.Cons > 13
    AND ha_robu_1.[Imp M] > 13
    AND ha_robu_1.CA > 139
    AND ha_robu_1.Prof > 13
    AND ha_robu_1.Det > 13
    AND ha_robu_1.Pres > 13
    AND ha_robu_1.Amb > 11
   -- AND ha_robu_1.Jum > 14


ORDER BY PA desc;
