<#
.SYNOPSIS
    Updates a HiX Environment Default Additional Database.
.DESCRIPTION
	Updates a HiX Environment Default Additional Database. 
.PARAMETER Type
	The type of the HiX Environment Default Additional Database to be removed.
	Possible values are:
		* CONF    - Environment Settings
		* AUDIT	  - Audit logging
		* AUDITFB - Audit logging fallback
		* LOG     - General logging
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
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateSet('CONF', 'AUDIT', 'AUDITFB', 'LOG')][string]$Type,
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string]$ConnectionString,
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
		Type = $Type;
		ConnectionString = $ConnectionString;
		} | ConvertTo-Json

	$uri = "$Url/api/v2/defaultadditionaldatabases"
	Invoke-RestMethod -Uri $uri -Method Put -UseDefaultCredentials -ContentType 'application/json' -Body $body | Out-Null
}