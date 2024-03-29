/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[NAAM]
      ,[OMSCHR]
      ,[PACS]
      ,[DICT]
      ,[VERVALLEN]
      ,[SYNCDIR]
      ,[SYNCDUUR]
      ,[SYNCINTERVAL]
      ,[URLEXPRESSIE]
	  ,cast(replace(cast([URLEXPRESSIE] as nvarchar(max)),'ssynapse03','asynapse02') as ntext)
      ,[KOPPELINST]
      ,[ClOSEURLEXPRE]
  FROM [HIX_ACCEPTATIE].[dbo].[RONTGEN_PACSINST]
  WHERE [ID] = 'CS000005'

  UPDATE
  [HIX_ACCEPTATIE].[dbo].[RONTGEN_PACSINST]
  SET [URLEXPRESSIE] = cast(replace(cast([URLEXPRESSIE] as nvarchar(max)),'ssynapse03','asynapse02') as ntext)
  WHERE [ID] = 'CS000005'