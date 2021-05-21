/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ABC]
      ,[AccountNum]
      ,[AccountStatement]
      ,[CustGroup]
      ,[PartyType]
      ,[Name]
      ,[OrgNumber]
      ,[VATNum]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[TaxGroup]
      ,[Currency]
      ,[LanguageId]
      ,[CashDisc]
      ,[CashDiscBaseDays]
      ,[CellularPhone]
      ,[ClearingPeriod]
      ,[CompanyChainId]
      ,[ContactPersonId]
      ,[CountryRegionId]
      ,[CreditMax]
      ,[CreditRating]
      ,[CustClassificationId]
      ,[CustExcludeCollectionFee]
      ,[CustExcludeInterestCharges]
      ,[CustItemGroupId]
      ,[ZipCode]
      ,[Street]
      ,[City]
      ,[DlvMode]
      ,[DlvTerm]
      ,[DunsNumber]
      ,[EndDisc]
      ,[EnterpriseNumber]
      ,[FactoringAccount]
      ,[Gender]
      ,[IdentificationNumber]
      ,[InclTax]
      ,[InventLocation]
      ,[InventSiteId]
      ,[InvoiceAccount]
      ,[KnownAs]
      ,[Blocked]
      ,[LineDisc]
      ,[LineOfBusinessId]
      ,[MainContactWorkerPersonnelNumber]
      ,[MandatoryCreditLimit]
      ,[MarkupGroup]
      ,[Memo]
      ,[MultiLineDisc]
      ,[NumberOfEmployees]
      ,[numberSequenceGroup]
      ,[OneTimeCustomer]
      ,[OrderEntryDeadlineGroupId]
      ,[OrgId]
      ,[OurAccountNum]
      ,[Pager]
      ,[PaymDayId]
      ,[PaymMode]
      ,[PaymSched]
      ,[PaymSpec]
      ,[PaymTermId]
      ,[BankAccount]
      ,[IBAN]
      ,[Phone]
      ,[PhoneLocal]
      ,[PostBox]
      ,[PriceGroup]
      ,[SalesCalendarId]
      ,[SalesDistrictId]
      ,[SalesPoolId]
      ,[SegmentId]
      ,[SMS]
      ,[State]
      ,[StatisticsGroup]
      ,[StreetNumber]
      ,[SubsegmentId]
      ,[SuppItemGroupId]
      ,[Email]
      ,[TeleFax]
      ,[Telex]
      ,[URL]
      ,[UseCashDisc]
      ,[VendAccount]
      ,[DefaultDimensionStr]
      ,[BSN nummer]
      ,[Polisnummer]
      ,[Ingangsdatum polis]
      ,[Uzovi nummer]
      ,[Gesloten]
      ,[Overleden]
      ,[Datum overlijden]
  FROM [FZR_AANLEVERING].[dbo].[custtable_patienten]

  
UPDATE [FZR_AANLEVERING].[dbo].[custtable_patienten]
SET 
	[FZR_AANLEVERING].[dbo].[custtable_patienten].[Name] = b.[VOORNAAM] + ' ' + b.[ACHTERNAAM] + '-' + b.[MEISJESNAA]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[FirstName] = b.[VOORNAAM]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[LastName] = b.[ACHTERNAAM] + '-' + b.[MEISJESNAA]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[Phone] = b.[TELEFOON1]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[ZipCode] = b.[POSTCODE]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[Street] = b.[ADRES] + ' ' + b.[HUISNR]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[City] = b.[WOONPLAATS]
	,[FZR_AANLEVERING].[dbo].[custtable_patienten].[BSN nummer] = b.[TELEFOON1]
FROM [FZR_AANLEVERING].[dbo].[custtable_patienten] a, [FZR_AANLEVERING].[dbo].[patienten_fzr] b
WHERE a.AccountNum = b.PATIENTNR