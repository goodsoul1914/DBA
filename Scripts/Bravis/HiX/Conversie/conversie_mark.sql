/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [TESTCODE]
      ,[OMSCHRIJVING]
      ,[MATERIAALCODE_FZR]
      ,[MATERIAALCODE_LZB]
  FROM [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD]

SELECT [TESTCODE]
      ,[DESCRIPT]
      ,[EXTERNALCODE]
      ,[EXTLABCODE]
      ,[EXTERNALCODE2]
      ,[EXTLABCODE3]
  FROM [FZR_aanlevering].[dbo].[TESTCODES_HIX]
  
/* Welke testcode's staan wel in HIX maar niet in de AANLEVERING */
/* 222 */
SELECT * FROM [FZR_aanlevering].[dbo].[TESTCODES_HIX] 
WHERE 
TESTCODE NOT IN (
	SELECT TESTCODE FROM [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD]
)

/* Welke testcode's staan wel in AANLEVERING maar niet in de HIX */
/* 22 */
SELECT * FROM [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD] 
WHERE 
TESTCODE NOT IN (
	SELECT TESTCODE FROM [FZR_aanlevering].[dbo].[TESTCODES_HIX]
)

/* Kijk welke omschrijvingen verschillen tussen de 2 tabellen */
/* 113 */
SELECT 
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].TESTCODE AS TESTCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].[OMSCHRIJVING] AS OMSCHRIJVING_AANGELEVERD,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].[DESCRIPT] AS OMSCHRIJVING_HIX
FROM
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD]
INNER JOIN [FZR_aanlevering].[dbo].[TESTCODES_HIX] 
	ON [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].TESTCODE = [FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE
WHERE
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].[OMSCHRIJVING] <> [FZR_aanlevering].[dbo].[TESTCODES_HIX].[DESCRIPT]
GROUP BY
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].TESTCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].[OMSCHRIJVING],
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].[DESCRIPT]
	
	
/* Kijk welke materiaalcodes verschillen tussen de 2 tabellen */
/* FZR: 7 */	
SELECT 
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].DESCRIPT,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].EXTERNALCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].MATERIAALCODE_FZR
FROM [FZR_aanlevering].[dbo].[TESTCODES_HIX]
LEFT JOIN [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD] 
	ON [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].TESTCODE = [FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE
WHERE 
	EXTLABCODE = 'LA00000002'
	AND [FZR_aanlevering].[dbo].[TESTCODES_HIX].EXTERNALCODE <> [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].MATERIAALCODE_FZR
	
/* LZB: 3 */		
SELECT 
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].DESCRIPT,
	[FZR_aanlevering].[dbo].[TESTCODES_HIX].EXTERNALCODE,
	[FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].MATERIAALCODE_LZB
FROM [FZR_aanlevering].[dbo].[TESTCODES_HIX]
LEFT JOIN [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD] 
	ON [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].TESTCODE = [FZR_aanlevering].[dbo].[TESTCODES_HIX].TESTCODE
WHERE 
	EXTLABCODE = 'LA00000003'
	AND [FZR_aanlevering].[dbo].[TESTCODES_HIX].EXTERNALCODE <> [FZR_aanlevering].[dbo].[TESTCODES_AANGELEVERD].MATERIAALCODE_LZB
	