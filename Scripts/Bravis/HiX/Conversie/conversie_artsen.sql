/****** Script for SelectTopNRows command from SSMS  ******/
SELECT FZR.OUD AS OUD_FZR, LZB.OUD AS OUD_LZB, A.*
  FROM [FZR_aanlevering].[dbo].[CSZISLIB_ARTS_14062013] A
  LEFT OUTER JOIN [FZR_aanlevering].[dbo].[FZR_omnummering_cszislib_arts] FZR
  ON A.ARTSCODE = FZR.[NIEUW]
  LEFT OUTER JOIN [FZR_aanlevering].[dbo].[LZB_omnummering_cszislib_arts] LZB
  ON A.ARTSCODE = LZB.[NIEUW]
  WHERE A.ARTSTYPE = 'I' AND a.VERVALLEN = 0