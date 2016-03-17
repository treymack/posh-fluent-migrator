param (
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    $LocalDatabaseName,
    [Switch] $DropDatabaseIfExists
)

begin {
    $ErrorActionPreference = 'Stop'
    pushd \ #importing sqlps switches you to the sql psdrive...
    Import-Module SQLPS
    popd

    function Get-LocalDatabaseExists([string] $LocalDatabaseName) {
        (Invoke-Sqlcmd -ServerInstance . -Query "select case when db_id('$LocalDatabaseName') is null then 0 else 1 end AlreadyExists").AlreadyExists -eq 1
    }
}

process {
    Write-Host "Creating $LocalDatabaseName" -ForegroundColor DarkCyan

    $databaseExists = Get-LocalDatabaseExists($LocalDatabaseName)
    if ($databaseExists) {
        Write-Host "$LocalDatabaseName already exists" -ForegroundColor Yellow
    }

    if ($databaseExists -and $DropDatabaseIfExists) {
        Write-Host "Dropping Database $LocalDatabaseName" -ForegroundColor Red
        Invoke-Sqlcmd -AbortOnError -Database master -ServerInstance . -Query "ALTER DATABASE [$LocalDatabaseName] SET single_user WITH ROLLBACK IMMEDIATE"
        Invoke-Sqlcmd -AbortOnError -Database master -ServerInstance . -Query "drop database [$LocalDatabaseName]"
        Write-Host "Drop Complete" -ForegroundColor DarkGreen
    }
    
    if (-Not (Get-LocalDatabaseExists($LocalDatabaseName))) {
        Invoke-Sqlcmd -AbortOnError -Database master -ServerInstance . -Query "create database [$LocalDatabaseName]"
        Write-Host "Creation Complete" -ForegroundColor DarkGreen
    }

    $_
}
