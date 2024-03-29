/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	'2013' as jaar,
	a.maand, 
	SUM(a.bedrag) AS bedrag_a, 
	SUM(a.debit) as debit_a, 
	SUM(a.credit) as credit_a
  FROM [FZR_AANLEVERING].[dbo].[_IMPORT_LEDGERJOURNALTRANS] a
  GROUP BY a.maand
  ORDER BY CAST(a.maand AS int)
  

SELECT 
	datepart(yy,b.TransDate) as jaar,
	datepart(mm,b.TransDate) as maand,
	SUM(b.AmountCurCredit) - SUM(b.AmountCurDebit) as bedrag_b,
	SUM(b.AmountCurCredit) as credit_b,
	SUM(b.AmountCurDebit) as debit_b
  FROM [FZR_AANLEVERING].[dbo].[ledgerjournaltrans] b
  GROUP BY b.TransDate
  ORDER BY datepart(yy,b.TransDate),datepart(mm,b.TransDate)
  
  
  
SELECT 
	datepart(yy,b.TransDate) as jaar,
	datepart(mm,b.TransDate) as maand,
	SUM(b.AmountCurCredit) - SUM(b.AmountCurDebit) as bedrag_b,
	SUM(b.AmountCurCredit) as credit_b,
	SUM(b.AmountCurDebit) as debit_b,
	SUM(a.bedrag) AS bedrag_a, 
	SUM(a.debit) as debit_a, 
	SUM(a.credit) as credit_a
  FROM [FZR_AANLEVERING].[dbo].[ledgerjournaltrans] b
  RIGHT OUTER JOIN [FZR_AANLEVERING].[dbo].[_IMPORT_LEDGERJOURNALTRANS] AS a 
	ON datepart(yy,b.TransDate) = '2013' 
	AND datepart(mm,b.TransDate)= a.maand
  GROUP BY b.TransDate
  ORDER BY datepart(yy,b.TransDate),datepart(mm,b.TransDate)
  
SELECT * 
 FROM [FZR_AANLEVERING].[dbo].[_IMPORT_LEDGERJOURNALTRANS]