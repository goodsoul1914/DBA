USE master;
GO

IF DATABASEPROPERTYEX (N'DBMaint2012', N'Version') > 0
BEGIN
    ALTER DATABASE DBMaint2012 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DBMaint2012;
END;
GO

-- Create the database
CREATE DATABASE DBMaint2012;
GO

USE DBMaint2012;
GO
SET NOCOUNT ON;
GO

-- Create a table to play with
CREATE TABLE ProdTable (
    c1 INT IDENTITY,
    c2 DATETIME
        DEFAULT GETDATE (),
    c3 AS c1 * 2 PERSISTED,
    c4 CHAR(5)
        DEFAULT 'a'
);
GO

INSERT INTO ProdTable
DEFAULT VALUES;
GO 1000

-- Take initial backups
BACKUP DATABASE DBMaint2012
TO  DISK = N'D:\Pluralsight\DBMaint2012_Full.bak'
WITH INIT;
GO

BACKUP LOG DBMaint2012
TO  DISK = N'D:\Pluralsight\DBMaint2012_Log1.bak'
WITH INIT;
GO

-- Insert some more data
INSERT INTO ProdTable
DEFAULT VALUES;
GO 1000

CREATE CLUSTERED INDEX Prod_CL ON ProdTable (c1);
GO
CREATE NONCLUSTERED INDEX Prod_NCL ON ProdTable (c2);
GO

INSERT INTO ProdTable
DEFAULT VALUES;
GO 1000

-- Now do something specific
DROP INDEX Prod_NCL ON ProdTable;
GO

INSERT INTO ProdTable
DEFAULT VALUES;
GO 1000

-- Can we find it?
SELECT *
FROM fn_dblog (NULL, NULL);
GO

SELECT *
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] LIKE N'%DROP%';
GO

SELECT *
FROM fn_dblog (NULL, NULL)
WHERE [Transaction ID] = N'XXX';
GO

-- Prove its a drop index on the table we're interested in...
SELECT TOP (1) [Lock Information]
FROM fn_dblog (NULL, NULL)
WHERE [Transaction ID] = N'XXX'
      AND [Lock Information] LIKE N'%SCH_M OBJECT%';
GO

SELECT OBJECT_NAME (XXX);
GO

-- You could also find out which SPID did the drop and if you're logging failed 
-- AND successful logins, you can see who did the deed!

-- Now what if the log isn't there any more...
BACKUP LOG DBMaint2012
TO  DISK = N'D:\Pluralsight\DBMaint2012_Log2.bak'
WITH INIT;
GO

SELECT *
FROM fn_dblog (NULL, NULL);
GO

-- Use the ability to return log from a backup...
SELECT *
FROM fn_dump_dblog (
         NULL,
         NULL,
         N'DISK',
         1,
         N'D:\Pluralsight\DBMaint2012_Log2.bak',
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT
     );
GO

SELECT *
FROM fn_dump_dblog (
         NULL,
         NULL,
         N'DISK',
         1,
         N'D:\Pluralsight\DBMaint2012_Log2.bak',
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT,
         DEFAULT
     )
WHERE [Transaction Name] LIKE N'%DROP%';
GO

-- And so on...

-- Imagine that was a DROP TABLE command, we could restore a copy 
-- of the database back to just before the drop...

-- Restore full backup and all log backups....
-- Need to convert the LSN to decimal in format
-- 'lsn:<VLFSeqnum><10character log block><5character log rec)'
-- e.g. '00000028:0000003a:0001' becomes '40000000005800001'
--

RESTORE LOG DBMaint2012
FROM DISK = N'D:\Pluralsight\DBMaint2012_Log2.bak'
WITH STOPBEFOREMARK = N'lsn:40000000005800001',
     NORECOVERY,
     STATS;
GO
