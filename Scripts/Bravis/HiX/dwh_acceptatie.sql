UPDATE CONFIG_INSTVARS SET [VALUE] = 'CGPHIXDWH01' WHERE [NAAM] = 'DWH_AS' AND [INSTTYPE] = 'G'
UPDATE CONFIG_INSTVARS SET [VALUE] = 'CCSDW_Productie' WHERE [NAAM] = 'DWH_CATALOG' AND [INSTTYPE] = 'G'
UPDATE CONFIG_INSTVARS SET [VALUE] = 'Chttp://GPHIXDWH01/Reportserver' WHERE [NAAM] = 'DWH_REPSRV' AND [INSTTYPE] = 'G'
UPDATE CONFIG_INSTVARS SET [VALUE] = 'C\\gphixdwh01\udl$\CSDW_Productie.UDL' WHERE [NAAM] = 'DWH_UDL' AND [INSTTYPE] = 'G'

UPDATE HIX_ACCEPTATIE.dbo.TAAK_TAAK
   SET MACHINE = 'GAHIXTAAK01'
 WHERE MACHINE = 'GPHIXTAAK02' OR MACHINE = 'GPHIXTAAK01' 
   AND DATUM >= getdate()

UPDATE HIX_ACCEPTATIE.dbo.TAAK_TAAKDEF
   SET MACHINE = 'GAHIXTAAK01'
 WHERE MACHINE = 'GPHIXTAAK02' OR MACHINE = 'GPHIXTAAK01' 

UPDATE [HIX_ACCEPTATIE].[dbo].[TAAK_TAAKRUN]
SET [ENABLED] = 0


SELECT top 100 * 
FROM HIX_ACCEPTATIE.dbo.TAAK_TAAK 
WHERE OMSCHRIJV LIKE '%Datawarehouse%'
ORDER BY ID DESC