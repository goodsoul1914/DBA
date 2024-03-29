/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [exchange].[dbo].[MailboxReport_Bravis_20150313]
  WHERE 
	[leidend] is not null 
	AND [migratiegroep] is not null
	AND [migratiegroep] != 'FZR'
  ORDER BY
    [NewSmtpAddress] ASC

SELECT 
	a.[NewSmtpAddress] as 'Primary', 
	a.[mailboxsize] as 'Size',
	b.[NewSmtpAddress] as 'Secondary',
	b.[mailboxsize] as 'Size'
FROM 
	[MailboxReport_Bravis_20150313] a, 
	[MailboxReport_Bravis_20150313] b
WHERE 
	a.[leidend] ='ja' 
	AND a.[migratiegroep] is not null 
	AND a.[migratiegroep] != 'FZR'
	AND b.[leidend] ='nee' 
	AND b.[gekoppeldaccount] = a.[PrimarySmtpAddress]
ORDER BY 
	b.[mailboxsize]  DESC