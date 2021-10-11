USE master;
GO

IF DATABASEPROPERTYEX (N'YieldTest', N'Version') > 0
BEGIN
    ALTER DATABASE YieldTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE YieldTest;
END;
GO

CREATE DATABASE YieldTest;
GO

USE YieldTest;
GO

CREATE TABLE SampleTable (c1 INT IDENTITY);
GO
CREATE NONCLUSTERED INDEX SampleTable_NC ON SampleTable (c1);
GO

SET NOCOUNT ON;
GO
INSERT INTO SampleTable
DEFAULT VALUES;
GO 100