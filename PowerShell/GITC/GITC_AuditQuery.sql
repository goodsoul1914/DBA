-------------------------------------------------------------------------------
-- GPHIXSQL02
-------------------------------------------------------------------------------
CREATE OR ALTER PROC dbo.usp_GITCAuditVerhoogdeRechten
    @StartTime                  DATETIME = NULL,
    @EndTime                    DATETIME = NULL,
    @ExcludeClutteringActionIds BIT      = 0
AS
BEGIN
    IF @StartTime IS NULL
        SET @StartTime = DATEADD(DAY, -7, GETDATE());

    IF @EndTime IS NULL
        SET @EndTime = GETDATE();

    SELECT event_time,
           action_id,
           statement,
           server_instance_name,
           database_name,
           server_principal_name,
           succeeded,
           class_type,
           client_ip,
           application_name,
           duration_milliseconds,
           response_rows,
           affected_rows
    FROM   fn_get_audit_file('F:\SQLAudit\GITC_GPHIXSQL02_Audit*.sqlaudit', DEFAULT, DEFAULT)
    WHERE  event_time >= @StartTime
           AND event_time <= @EndTime
           AND action_id NOT IN ( 'LGIS', 'DBCC', 'AL' )
           AND statement NOT LIKE 'SSPI handshake%'
           AND statement NOT LIKE 'Login failed. The login is from an untrusted domain and cannot be used with Integrated authentication.%';
END;
GO

-------------------------------------------------------------------------------
-- GPAX4HSQL02
-------------------------------------------------------------------------------

CREATE PROC dbo.usp_GITCAuditVerhoogdeRechten
    @StartTime                  DATETIME = NULL,
    @EndTime                    DATETIME = NULL,
    @ExcludeClutteringActionIds BIT      = 0
AS
BEGIN
    IF @StartTime IS NULL
        SET @StartTime = DATEADD(DAY, -7, GETDATE());

    IF @EndTime IS NULL
        SET @EndTime = GETDATE();

    SELECT event_time,
       action_id,
       statement,
       server_instance_name,
       database_name,
       server_principal_name,
       succeeded,
       class_type
	FROM   fn_get_audit_file('D:\SQLAudit\GITC_GPAX4SQL02_Audit*.sqlaudit', DEFAULT, DEFAULT)
    WHERE  event_time >= @StartTime
           AND event_time <= @EndTime
           AND action_id NOT IN ( 'LGIS', 'DBCC', 'AL' )
           AND statement NOT LIKE 'SSPI handshake%'
           AND statement NOT LIKE 'Login failed. The login is from an untrusted domain and cannot be used with Integrated authentication.%';
END;
GO
