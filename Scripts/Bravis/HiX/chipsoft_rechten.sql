/****** Script for SelectTopNRows command from SSMS  ******/
USE HIX_ACCEPTATIE
SELECT *
  FROM [dbo].[ZISCON_GROEPUSR]
  WHERE USERCODE LIKE 'MPIJNEN'
 
INSERT INTO [dbo].[ZISCON_GROEPUSR] VALUES ('CS+','MPIJNEN','0','0')