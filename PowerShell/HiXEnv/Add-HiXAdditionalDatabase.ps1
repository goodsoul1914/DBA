<#
.SYNOPSIS
    Adds a HiX Environment Additional Database.
.DESCRIPTION
	Adds a HiX Environment Additional Database. These databases are specific for an 
	environment. 
.PARAMETER EnvironmentId
    The unique id of the HiX Environment to which this Extra Connection String belongs.
.PARAMETER Type
	The type of the HiX Environment Additional Database which is used to signify its use.
	Possible values are:
		* CONF    - Environment Settings
		* AUDIT	  - Audit logging
		* AUDITFB - Audit logging fallback
		* LOG     - General logging
		* BLOB	  - Blob file storage
.PARAMETER ConnectionString
	The connection string used to connect to the database. 
	Examples are:
		* Data Source=SERVER;Initial Catalog=DATABASE;User ID=chipsoftwinzis
		* Data Source=SERVER;Initial Catalog=DATABASE;Integrated Security=SSPI
.PARAMETER Url
	The url of the HiX Environment host. This can be used in case the host can not be found
	the usual way.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('id')][string]$EnvironmentId,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateSet('CONF', 'AUDIT', 'AUDITFB', 'LOG', 'BLOB')][string]$Type,
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][AllowEmptyString()][string]$ConnectionString,
    [Parameter(Mandatory=$false)][string]$Url
)
begin
{
	Set-StrictMode -Version Latest

	if (-not $Url)
	{
		$Url = &"$PSScriptRoot\Get-HiXEnvironmentUrl.ps1"
	}
}
process
{
	Set-StrictMode -Version Latest

	$body = @{
		EnvironmentId = $EnvironmentId;
		Type = $Type;
		ConnectionString = $ConnectionString;
		} | ConvertTo-Json

	$uri = "$Url/api/v2/additionaldatabases"
	Invoke-RestMethod -Uri $uri -Method Post -UseDefaultCredentials -ContentType 'application/json' -Body $body | Out-Null
}