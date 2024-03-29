/****** Script for SelectTopNRows command from SSMS  ******/
-- Hoeveel berichten zijn er aangeleverd
-- 287928
SELECT *
  FROM [FZR_aanlevering].[dbo].[aanlevering_mmb]
  ORDER BY onderzoeksnummer ASC
  
-- Hoeveel unieke onderzoeksnummers zijn er  
-- 232398
SELECT onderzoeksnummer
  FROM [FZR_aanlevering].[dbo].[aanlevering_mmb]
  GROUP BY onderzoeksnummer
  ORDER BY onderzoeksnummer ASC
  
-- Hoeveel unieke combinaties onderzoeksnummer+patientnummer zijn er
-- 232398
SELECT onderzoeksnummer, patientnummer
  FROM [FZR_aanlevering].[dbo].[aanlevering_mmb]
  GROUP BY onderzoeksnummer, patientnummer
  ORDER BY onderzoeksnummer ASC


-- Probleem gevallen zelfde onderzoeksnummer, andere patientnummer  
-- 35643 berichten
SELECT a.onderzoeksnummer, a.patientnummer, a.bestand
FROM [FZR_aanlevering].[dbo].[aanlevering_mmb] a
LEFT OUTER JOIN [FZR_aanlevering].[dbo].[aanlevering_mmb] b ON
a.onderzoeksnummer = b.onderzoeksnummer and a.patientnummer != b.patientnummer
WHERE b.onderzoeksnummer IS NOT NULL
GROUP BY a.onderzoeksnummer, a.patientnummer, a.bestand
ORDER BY a.onderzoeksnummer

  
-- Aantallen per jaar gebaseerd op unieke onderzoeksnummer/datum
SELECT a.jaar,COUNT(*) as Aantal
FROM (
	SELECT YEAR(onderzoeksdatum) as jaar
	  FROM [FZR_aanlevering].[dbo].[aanlevering_mmb]
	  GROUP BY onderzoeksnummer, onderzoeksdatum
) a 
GROUP BY a.jaar
ORDER BY a.jaar

  
-- 44782
SELECT COUNT(*)
  FROM [FZR_aanlevering].[dbo].[aanlevering_mmb]
  

  
select DISTINCT(onderzoeksnummer) from [FZR_aanlevering].dbo.aanlevering_mmb
where patientnummer = '6573097'



