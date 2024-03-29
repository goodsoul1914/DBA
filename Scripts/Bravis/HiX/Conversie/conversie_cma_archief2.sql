/****** Script for SelectTopNRows command from SSMS  ******/

   SELECT [IFourCArchive1299344].[dbo].[IFCDOCUMENT].[DOCUMENTID]
              ,[IFourCArchive1299344].[dbo].[IFCDOCUMENT].[FIELD1]
              ,[JIM].[dbo].[tabL2Basi].[fldL1BasCode]
              ,[JIM].[dbo].[tabL2Basi].[fldL2BasCode]
              ,[IFourCArchive1299344].[dbo].[IFCDATA].BINARY
              ,[IFourCArchive1299344].[dbo].[IFCDATA].[SORTORDER]
          FROM 
                [IFourCArchive1299344].[dbo].[IFCDOCUMENT] 
          INNER JOIN 
                [IFourCArchive1299344].[dbo].[IFCDATA] 
          ON 
                [IFourCArchive1299344].[dbo].[IFCDOCUMENT].[DOCUMENTID] = [IFourCArchive1299344].[dbo].[IFCDATA].DOCUMENTID
          INNER JOIN 
				[JIM].[dbo].[tabL2Basi]
		  ON 
				[IFourCArchive1299344].[dbo].[IFCDOCUMENT].[FIELD1] = [JIM].[dbo].[tabL2Basi].[fldL2BasCode]       
         WHERE [fldL1BasCode] LIKE '1331854'
			ORDER BY [IFourCArchive1299344].[dbo].[IFCDATA].[SORTORDER] ASC