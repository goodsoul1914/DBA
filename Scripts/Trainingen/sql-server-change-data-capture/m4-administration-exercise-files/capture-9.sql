USE [master];
GO

-- Take a backup of the CDC enabled database
BACKUP DATABASE [Credit] TO DISK = N'E:\SQLBackups\CreditBackup_PSDemo.bak' 
WITH INIT,  
	 NAME = N'Credit-Full Database Backup for Pluralsight Demos', 
	 COMPRESSION, 
	 STATS = 10, 
	 CHECKSUM;
GO

-- Restore the database as Credit_CDCKeep using the UI first

-- Check for CDC existence




-- Now restore database as Credit_CDCKeep using TSQL and KEEP_CDC option
RESTORE DATABASE [Credit_CDCKeep] 
FROM DISK = N'E:\SQLBackups\CreditBackup_PSDemo.bak' 
WITH FILE = 1,  
	 REPLACE, 
	 STATS = 5,
	 KEEP_CDC;
GO

-- Check for CDC existence
