[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    $ProjectAssemblyTargetPath,
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
    $LocalDatabaseConnectionString,

    [switch] $Rollback
)

process {
    Write-Host "Migrating $($db.LocalDatabaseName)" -ForegroundColor DarkCyan

    $exe = ".\packages\FluentMigrator.1.4.0.0\tools\Migrate.exe"
    $args = "--provider=SqlServer2012",
            "--connectionString=""$LocalDatabaseConnectionString""",
            "--assembly=$ProjectAssemblyTargetPath"

    if ($Rollback) {
        $args += "--task=rollback"
        $args += "--steps=1"
    }

    $process = Start-Process $exe ($args -join " ") -NoNewWindow -Wait -ErrorAction Stop -PassThru
    if ($process.ExitCode -ne 0) {
        throw "FAILED: $exe $args"
    }

    Write-Host "Migration Complete" -ForegroundColor DarkGreen

    $_
}
