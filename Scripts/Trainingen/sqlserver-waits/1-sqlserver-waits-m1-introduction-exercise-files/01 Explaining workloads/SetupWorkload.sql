USE [master];
GO

IF DATABASEPROPERTYEX (N'HotSpot', N'Version') > 0
BEGIN
	ALTER DATABASE [HotSpot] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [HotSpot];
END
GO

CREATE DATABASE [HotSpot] ON PRIMARY (
    NAME = N'HotSpot_data',
    FILENAME = N'D:\Pluralsight\HotSpot_data.mdf')
LOG ON (
    NAME = N'HotSpot_log',
    FILENAME = N'C:\Pluralsight\HotSpot_log.ldf',
    SIZE = 250MB,
    FILEGROWTH = 25MB);
GO

ALTER DATABASE [HotSpot] SET RECOVERY SIMPLE;
GO

USE [HotSpot];
GO

CREATE TABLE [HotSpotTable] (
	[c1] INT IDENTITY);
CREATE CLUSTERED INDEX [HotSpotTable_CL] ON
	[HotSpotTable] ([c1]);
GO

-- Now start the workload by double-clicking the
-- file C:\Pluralsight\Add50Clients.cmd

-- Demo stuff

-- Now stop the workload by double-clicking the
-- file C:\Pluralsight\StopWorkload.cmd

USE [master];
GO

IF DATABASEPROPERTYEX (N'HotSpot', N'Version') > 0
BEGIN
	ALTER DATABASE [HotSpot] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [HotSpot];
END
GO