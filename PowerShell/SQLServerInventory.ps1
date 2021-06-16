$managementServer = "GTSQL01"
$managentDatabase = "DBA"

## Retrieve all SQL Server instances from the management database
$SqlInstances = (Invoke-DbaQuery -SqlInstance $managementServer -Database $managentDatabase -Query "SELECT SqlInstance FROM DBA.dbo.SqlInstances WHERE Scan = 1 ORDER BY SqlInstance;").SqlInstance

## Retrieve all unique computernames from the management database
$ComputerNames = (Invoke-DbaQuery -SqlInstance $managementServer -Database $managentDatabase -Query "SELECT DISTINCT ComputerName FROM dbo.SqlInstances ORDER BY ComputerName;").ComputerName

## Update some fields of instance records
foreach ($instance in $SqlInstances) {    
    $infoObj = Get-DbaInstanceProperty -SqlInstance $instance

    $version = ($infoObj | where {$_.Name -eq "VersionString"}).Value
    $edition = ($infoObj | where {$_.Name -eq "Edition"}).Value

    Invoke-DbaQuery -SqlInstance $managementServer -Database $managentDatabase -Query "UPDATE dbo.SqlInstances SET Timestamp = GETDATE(), SqlVersion = '$version', SqlEdition = '$edition' WHERE SqlInstance = '$instance';"
}

## Update some fields of computer records
foreach ($computer in $ComputerNames) {    
    $infoObj = Get-DbaComputerSystem -ComputerName $computer

    $cpuPhysicalCount = $infoObj.NumberProcessors
    $cpuLogicalCount = $infoObj.NumberLogicalProcessors
    $memPhysical = $infoObj.TotalPhysicalMemory

    Invoke-DbaQuery -SqlInstance $managementServer -Database $managentDatabase -Query "UPDATE dbo.SqlInstances SET Timestamp = GETDATE(), ProcessorInfo = '$cpuPhysicalCount / $cpuLogicalCount', PhysicalMemory = '$memPhysical' WHERE ComputerName = '$computer';"
}

## Retrieve errorlog info
Get-DbaErrorLog -SqlInstance $SqlInstances -After (Get-Date).AddDays(-1) | 
    Select-Object ComputerName,InstanceName,SqlInstance,LogDate,Source,Text | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table ErrorLogs -AutoCreateTable

## Retrieve failed agent jobs from all instances and store them in DBA.dbo.FailedJobHistory
Get-DbaAgentJobHistory -SqlInstance $SqlInstances -StartDate (Get-Date).AddDays(-1) -OutcomeType Failed | 
    Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table FailedJobHistory -AutoCreateTable

## Retrieve database info
Get-DbaDatabase -SqlInstance $SqlInstances | 
    Select SqlInstance,Name,SizeMB,Compatibility,LastFullBackup,LastDiffBackup,LastLogBackup,ActiveConnections,Collation,ContainmentType,CreateDate,DataSpaceUsage,FilestreamDirectoryName,IndexSpaceUsage,LogReuseWaitStatus,PageVerify,PrimaryFilePath,ReadOnly,RecoveryModel,Size,SnapshotIsolationState,SpaceAvailable,MaxDop,ServerVersion | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table Databases -AutoCreateTable

## Retrieve diskspace info
Get-DbaDiskSpace -ComputerName $ComputerNames | 
    Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table DiskSpace -AutoCreateTable

## Retrieve disk speed
Test-DbaDiskSpeed -SqlInstance $SqlInstances | 
    Select-Object SqlInstance,Database,SizeGB,FileName,FileID,FileType,DiskLocation,Reads,AverageReadStall,ReadPerformance,Writes,AverageWriteStall,WritePerformance,"Avg Overall Latency","Avg Bytes/Read","Avg Bytes/Write","Avg Bytes/Transfer" | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table DiskSpeedTests -AutoCreateTable

## Retrieve all logins
Get-DbaLogin -SqlInstance $SqlInstances | 
    Select-Object ComputerName,InstanceName,SqlInstance,LastLogin,AsymmetricKey,Certificate,CreateDate,Credential,DateLastModified,DefaultDatabase,DenyWindowsLogin,HasAccess,ID,IsDisabled,IsLocked,IsPasswordExpired,IsSystemObject,LoginType,MustChangePassword,PasswordExpirationEnabled,PasswordHashAlgorithm,PasswordPolicyEnforced,Sid,WindowsLoginAccessType,Name | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table ServerLogins -AutoCreateTable

## Retrieve all database role members
Get-DbaDbRoleMember -SqlInstance $SqlInstances -ExcludeDatabase tempdb,model | 
    Select-Object ComputerName,InstanceName,SqlInstance,Database,Role,UserName,Login,IsSystemObject,LoginType | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table DatabaseRoleMembers -AutoCreateTable

## Retrieve all database role members
Get-DbaServerRoleMember -SqlInstance $SqlInstances | 
    Select-Object ComputerName,InstanceName,SqlInstance,Role,Name | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table ServerRoleMembers -AutoCreateTable

## Retrieve database space info
Get-DbaDbSpace -SqlInstance $SqlInstances | 
    Select-Object ComputerName,InstanceName,SqlInstance,Database,FileName,FileGroup,PhysicalName,FileType,UsedSpace,FreeSpace,FileSize,PercentUsed,AutoGrowth,AutoGrowType,SpaceUntilMaxSize,AutoGrowthPossible,UnusableSpace | 
        Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table DatabaseSpace -AutoCreateTable

## Retrieve all growth events
Find-DbaDbGrowthEvent -SqlInstance $SqlInstances -UseLocalTime | 
    Where-Object {$_.StartTime -ge (Get-Date).AddDays(-1)} | 
        Select-Object SqlInstance,DatabaseName,FileName,Duration,StartTime,EndTime,ChangeInSize,ApplicationName,HostName,SessionLoginName |
            Write-DbaDataTable -SqlInstance $managementServer -Database $managentDatabase -Table DatabaseGrowthEvents -AutoCreateTable

## Generate a report
powershell.exe -File "C:\temp\SQLServerReport.ps1"