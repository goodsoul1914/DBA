SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.vwErrorLogLatest
AS
SELECT        SqlInstance, Text, COUNT(*) AS Count
FROM            dbo.ErrorLogs
WHERE        (Text NOT LIKE 'Login succeeded for %') AND (Text NOT LIKE 'Log was backed up%') AND (Text NOT LIKE 'Log was restored.%') AND (Text NOT LIKE 'BACKUP DATABASE successfully%') AND 
                         (Text NOT LIKE 'RESTORE DATABASE successfully%') AND (Text NOT LIKE 'Database backed up.%') AND (Text NOT LIKE 'Database was restored%') AND (Text NOT LIKE 'Restore is complete %') AND 
                         (Text NOT LIKE '%without errors%') AND (Text NOT LIKE '%0 errors%') AND (Text NOT LIKE 'Starting up database%') AND (Text NOT LIKE 'Parallel redo is %') AND (Text NOT LIKE 'This instance of SQL Server%') 
                         AND (Text NOT LIKE 'Error: %, Severity:%') AND (Text NOT LIKE 'Setting database option %') AND (Text NOT LIKE 'Recovery is writing a checkpoint%') AND (Text NOT LIKE 'Process ID % was killed by hostname %') 
                         AND (Text NOT LIKE 'The database % is marked RESTORING and is in a state that does not allow recovery to be run.') AND (Text NOT LIKE '%informational message only%') AND 
                         (Text NOT LIKE 'I/O is frozen on database%') AND (Text NOT LIKE 'I/O was resumed on database%') AND (Text NOT LIKE 'The error log has been reinitialized%') AND (LogDate >= DATEADD(D, - 1, GETDATE())) AND 
                         (Text NOT LIKE 'BACKUP DATABASE WITH DIFFERENTIAL successfully processed%') AND (Text NOT LIKE 'Database differential changes were backed up%')
GROUP BY SqlInstance, Text
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ErrorLogs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwErrorLogLatest'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwErrorLogLatest'
GO