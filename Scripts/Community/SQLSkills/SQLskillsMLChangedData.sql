/*============================================================================
   File: SQLskillsMLChangedData.sql

   Summary: This script creates a system-wide SP SQLskillsMLChangedData that
   works out what percentage of a database has been changed by minimally
   logged operations since the last log backup.

   Date: May 2009

   SQL Server Versions:
         10.0.2531.00 (SS2008 SP1)
         9.00.4035.00 (SS2005 SP3)
------------------------------------------------------------------------------
   Copyright (C) 2009 Paul S. Randal, SQLskills.com
   All rights reserved.

   For more scripts and sample code, check out 
      http://www.sqlskills.com/

   You may alter this code for your own *non-commercial* purposes. You may
   republish altered code as long as you give due credit.


   THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
   ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
   TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
   PARTICULAR PURPOSE.

============================================================================*/

-- Create the function in MSDB
--
USE msdb;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE NAME = 'SQLskillsConvertToExtents')
   DROP FUNCTION SQLskillsConvertToExtents;
GO

-- This function cracks the output from a DBCC PAGE dump
-- of an allocation bitmap. It takes a string in the form
-- "(1:8) - (1:16)" or "(1:8) -" and returns the number
-- of extents represented by the string. Both the examples
-- above equal 1 extent.
--

CREATE FUNCTION SQLskillsConvertToExtents (
   @extents VARCHAR (100))
RETURNS INTEGER
AS
BEGIN
   DECLARE @extentTotal   INT;
   DECLARE @colon         INT;
   DECLARE @firstExtent   INT;
   DECLARE @secondExtent  INT;

   SET @extentTotal = 0;
   SET @colon = CHARINDEX (':', @extents);

   -- Check for the single extent case
   --
   IF (CHARINDEX (':', @extents, @colon + 1) = 0)
      SET @extentTotal = 1;
   ELSE
      -- We're in the multi-extent case
      --
      BEGIN
      SET @firstExtent = CONVERT (INT,
         SUBSTRING (@extents, @colon + 1, CHARINDEX (')', @extents, @colon) - @colon - 1));
      SET @colon = CHARINDEX (':', @extents, @colon + 1);
      SET @secondExtent = CONVERT (INT,
         SUBSTRING (@extents, @colon + 1, CHARINDEX (')', @extents, @colon) - @colon - 1));
      SET @extentTotal = (@secondExtent - @firstExtent) / 8 + 1;
   END

   RETURN @extentTotal;
END;
GO

USE master;
GO


IF OBJECT_ID ('sp_SQLskillsMLChangedData') IS NOT NULL
   DROP PROCEDURE sp_SQLskillsMLChangedData;
GO

-- This SP cracks all minamally-logged bitmap pages for all online
-- data files in a database. It creates a sum of changed extents
-- and reports it as follows (example small msdb):
-- 
-- EXEC sp_SQLskillsMLChangedData 'msdb';
-- GO
--
-- Total Extents Changed Extents Percentage Changed
-- ------------- --------------- ----------------------
-- 102           56              54.9
--
CREATE PROCEDURE sp_SQLskillsMLChangedData (
   @dbName VARCHAR (128))
AS
BEGIN
   SET NOCOUNT ON;

   -- Create the temp table
   --
   IF EXISTS (SELECT * FROM msdb.sys.objects WHERE NAME = 'SQLskillsDBCCPage')
   DROP TABLE msdb.dbo.SQLskillsDBCCPage;

   CREATE TABLE msdb.dbo.SQLskillsDBCCPage (
      [ParentObject] VARCHAR (100),
      [Object]       VARCHAR (100),
      [Field]        VARCHAR (100),
      [VALUE]        VARCHAR (100)); 

   DECLARE @fileID         INT;
   DECLARE @fileSizePages  INT;
   DECLARE @extentID       INT;
   DECLARE @pageID         INT;
   DECLARE @MLTotal      INT;
   DECLARE @sizeTotal      INT;
   DECLARE @total          INT;
   DECLARE @dbccPageString VARCHAR (200);

   SELECT @MLTotal = 0;
   SELECT @sizeTotal = 0;

   -- Setup a cursor for all online data files in the database
   --
   DECLARE files CURSOR FOR
      SELECT [file_id], [size] FROM master.sys.master_files
      WHERE [type_desc] = 'ROWS'
      AND [state_desc] = 'ONLINE'
      AND [database_id] = DB_ID (@dbName);

   OPEN files;

   FETCH NEXT FROM files INTO @fileID, @fileSizePages;

   WHILE @@FETCH_STATUS = 0
   BEGIN
      SELECT @extentID = 0;

      -- The size returned from master.sys.master_files is in
      -- pages - we need to convert to extents
      --
      SELECT @sizeTotal = @sizeTotal + @fileSizePages / 8;

      WHILE (@extentID < @fileSizePages)
      BEGIN
         -- There may be an issue with the ML map page position
         -- on the four extents where PFS pages and GAM pages live
         -- (at page IDs 516855552, 1033711104, 1550566656, 2067422208)
         -- but I think we'll be ok.
         -- PFS pages are every 8088 pages (page 1, 8088, 16176, etc)
         -- GAM extents are every 511232 pages
         --
         SELECT @pageID = @extentID + 7;

         -- Build the dynamic SQL
         --
         SELECT @dbccPageString = 'DBCC PAGE ('
            + @dbName + ', '
            + CAST (@fileID AS VARCHAR) + ', '
            + CAST (@pageID AS VARCHAR) + ', 3) WITH TABLERESULTS, NO_INFOMSGS';

         -- Empty out the temp table and insert into it again
         --
         DELETE FROM msdb.dbo.SQLskillsDBCCPage;
         INSERT INTO msdb.dbo.SQLskillsDBCCPage EXEC (@dbccPageString);

         -- Aggregate all the changed extents using the function
         --
         SELECT @total = SUM ([msdb].[dbo].[SQLskillsConvertToExtents] ([Field]))
         FROM msdb.dbo.SQLskillsDBCCPage
            WHERE [VALUE] = '    MIN_LOGGED'
            AND [ParentObject] LIKE 'ML_MAP%';

         SET @MLTotal = @MLTotal + @total;

         -- Move to the next GAM extent
         SET @extentID = @extentID + 511232;
      END

      FETCH NEXT FROM files INTO @fileID, @fileSizePages;
   END;

   -- Clean up
   --
   DROP TABLE msdb.dbo.SQLskillsDBCCPage;
   CLOSE files;
   DEALLOCATE files;

   -- Output the results
   --
   SELECT
      @sizeTotal AS [Total Extents],
      @MLTotal AS [Changed Extents],
      ROUND (
         (CONVERT (FLOAT, @MLTotal) /
         CONVERT (FLOAT, @sizeTotal)) * 100, 2) AS [Percentage Changed];
END;
GO

-- Mark the SP as a system object
--
EXEC sys.sp_MS_marksystemobject sp_SQLskillsMLChangedData;
GO

-- Test to make sure everything was setup correctly
--
EXEC sp_SQLskillsMLChangedData 'msdb';
GO
