/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT(*)
  FROM [FZR_aanlevering].[dbo].[aanlevering_jivex]
  
SELECT onderzoeksnummer as ONDERZNR, patientnummer as PATIENTNR, onderzoeksdatum as MONSTERDAT, '' AS OMSCHRIJV
  FROM [FZR_aanlevering].[dbo].[aanlevering_jivex]
  
SELECT ONDERZNR, PATIENTNR, MONSTERDAT, OMSCRHIJV AS OMSCHRIJV
FROM EZIS_FZR.DBO.UITSLAG5_PA_OND