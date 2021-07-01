CREATE TABLE [dbo].[SqlAudit]
(
[event_time] [datetime2] (7) NULL,
[sequence_number] [int] NULL,
[action_id] [varchar] (4) NULL,
[succeeded] [bit] NOT NULL,
[permission_bitmask] [bigint] NOT NULL,
[is_column_permission] [bit] NOT NULL,
[session_id] [smallint] NOT NULL,
[server_principal_id] [int] NULL,
[database_principal_id] [int] NULL,
[target_server_principal_id] [int] NULL,
[target_database_principal_id] [int] NULL,
[object_id] [bigint] NULL,
[class_type] [varchar] (10) NULL,
[session_server_principal_name] [nvarchar] (100) NULL,
[server_principal_name] [nvarchar] (100) NULL,
[server_principal_sid] [nvarchar] (100) NULL,
[database_principal_name] [nvarchar] (100) NULL,
[target_server_principal_name] [nvarchar] (100) NULL,
[target_server_principal_sid] [nvarchar] (100) NULL,
[target_database_principal_name] [nvarchar] (100) NULL,
[server_instance_name] [nvarchar] (100) NULL,
[database_name] [nvarchar] (100) NULL,
[schema_name] [nvarchar] (100) NULL,
[object_name] [nvarchar] (100) NULL,
[statement] [nvarchar] (max) NULL,
[additional_information] [nvarchar] (500) NULL,
[file_name] [nvarchar] (500) NULL,
[audit_file_offset] [bigint] NULL,
[user_defined_event_id] [int] NULL,
[user_defined_information] [nvarchar] (100) NULL
) TEXTIMAGE_
GO