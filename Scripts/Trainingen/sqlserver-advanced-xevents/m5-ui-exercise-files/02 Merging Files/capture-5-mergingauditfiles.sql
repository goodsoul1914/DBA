USE [master]
GO

/****** Object:  Audit [ServerAudit]    Script Date: 2/6/2013 11:24:37 PM ******/
CREATE SERVER AUDIT [ServerAudit]
TO FILE 
(	FILEPATH = N'C:\Pluralsight\'
	,MAXSIZE = 20 MB
	,MAX_FILES = 4
	,RESERVE_DISK_SPACE = OFF
)
GO
ALTER SERVER AUDIT [ServerAudit] WITH (STATE = ON)
GO

CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpec]
FOR SERVER AUDIT [ServerAudit]
ADD (DATABASE_OPERATION_GROUP)
WITH (STATE = ON)
GO

USE [AdventureWorks2008R2]
GO

CREATE DATABASE AUDIT SPECIFICATION [AdventureWorks2008R2Audit]
FOR SERVER AUDIT [ServerAudit]
ADD (DATABASE_OBJECT_ACCESS_GROUP),
ADD (SCHEMA_OBJECT_ACCESS_GROUP)
WITH (STATE = ON)
GO

USE [AdventureWorks2012]
GO

CREATE DATABASE AUDIT SPECIFICATION [AdventureWorks2012Audit]
FOR SERVER AUDIT [ServerAudit]
ADD (DATABASE_OBJECT_ACCESS_GROUP),
ADD (SCHEMA_OBJECT_ACCESS_GROUP)
WITH (STATE = ON)
GO

CREATE EVENT SESSION [StatementEvents] ON SERVER 
ADD EVENT sqlserver.sql_statement_completed,
ADD EVENT sqlserver.sql_statement_starting 
ADD TARGET package0.event_file(SET filename=N'C:\Pluralsight\StatementEvents.xel',max_file_size=(20),max_rollover_files=(4))
GO
ALTER EVENT SESSION [StatementEvents] ON SERVER 
STATE = START;

USE AdventureWorks2012;
GO

SELECT TOP 10 *
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID;

GO

USE AdventureWorks2008R2;
GO

SELECT TOP 10 *
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID;
GO

-- Cleanup
USE [AdventureWorks2008R2]
GO
ALTER DATABASE AUDIT SPECIFICATION [AdventureWorks2008R2Audit]
WITH (STATE = OFF);
GO

DROP DATABASE AUDIT SPECIFICATION [AdventureWorks2008R2Audit];
GO


USE [AdventureWorks2012]
GO
ALTER DATABASE AUDIT SPECIFICATION [AdventureWorks2012Audit]
WITH (STATE = OFF);
GO
DROP DATABASE AUDIT SPECIFICATION [AdventureWorks2012Audit]
GO

USE [master]
GO
ALTER SERVER AUDIT SPECIFICATION [ServerAuditSpec]
WITH (STATE = OFF);
GO
DROP SERVER AUDIT SPECIFICATION [ServerAuditSpec];
GO
ALTER SERVER AUDIT [ServerAudit] WITH (STATE = OFF);
GO
DROP SERVER AUDIT [ServerAudit];
GO
DROP EVENT SESSION [StatementEvents] ON SERVER;

-- DELETE FILE SYSTEM FILES