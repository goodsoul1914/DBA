SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW vwAllScannedSqlInstances
AS
SELECT SqlInstance FROM DBA.dbo.SqlInstances WHERE Scan = 1;
GO