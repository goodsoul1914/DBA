/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ServerType]
      ,[Name]
      ,[Id]
      ,[Url]
      ,[Host]
      ,[Port]
      ,[Enabled]
      ,[AETitle]      
  FROM [SectraHealthcareStorage].[dbo].[Servers]
  WHERE Enabled = 1