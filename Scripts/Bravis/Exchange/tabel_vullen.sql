/****** Script for SelectTopNRows command from SSMS  ******/
INSERT INTO [dbo].[MailboxReport_Bravis_20150313] (
[FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Alias]
      ,[PrimarySmtpAddress]
      ,[NewSmtpAddress]
      ,[Herkomst]
      ,[type]
      ,[leidend]
      ,[gekoppeldaccount]
      ,[migratiefase]
      ,[migratiegroep]
      ,[activesync]
      ,[pst]
      ,[mailboxsize]
      ,[mailboxitems]
      ,[quota]
      ,[database]
	  ,[import]
)
SELECT [FirstName]
      ,[LastName]
      ,[DisplayName]
      ,[Alias]
      ,[PrimarySmtpAddress]
      ,[NewSmtpAddress]
      ,[Herkomst]
      ,[type]
      ,[leidend]
      ,[gekoppeldaccount]
      ,[migratiefase]
      ,[migratiegroep]
      ,[activesync]
      ,[pst]
      ,[mailboxsize]
      ,[mailboxitems]
      ,[quota]
      ,[database]
	  ,[import]
  FROM [exchange].[dbo].[MailboxReport_Bravis_20150302]
